#!/bin/env python3
import asyncio
import math
import time
from collections import defaultdict
from contextlib import suppress
from csv import DictWriter
from datetime import datetime, timedelta
from itertools import count
from logging import getLogger
from subprocess import TimeoutExpired, check_call
from typing import Any, Dict, List, TextIO

import click
import click_log
import lab_management_scripts.features.cstate
import lab_management_scripts.features.frequency
import lab_management_scripts.util
import metricq
from metricq.history_client import HistoryRequestType
from metricq.types import Timestamp

logger = getLogger()

click_log.basic_config(logger)


test_states = [
    name
    for name, state, description, latency, power in lab_management_scripts.features.cstate.available_all()[
        1
    ].values()
]

all_cpus = lab_management_scripts.util.cpu_range("online")
# Ariel has to many ... takes too long
# frequencies = 3001, 3000
frequencies = 2500,
#frequencies = lab_management_scripts.features.frequency.available_frequencies()

class ExperimentRunner:
    def __init__(self, duration: float, out: TextIO):
        self._duration = duration
        self._csvfile = out
        self._experiments: List[Dict[str, Any]] = []
        self._samples: List[Dict[str, Any]] = []

    def apply_configuration(self, states, frequency, **kwargs):
        lab_management_scripts.features.frequency.do_set("userspace", frequency)
        cpus_by_state = defaultdict(list)
        for cpu, state in states.items():
            cpus_by_state[state].append(cpu)

        for target_state, cpus in cpus_by_state.items():
            other_states = [
                state
                for state in lab_management_scripts.features.cstate.available().values()
                if state != target_state
            ]
            lab_management_scripts.features.cstate.enable_disable(
                cpus, [target_state], other_states
            )

    def run_experiment(self, **kwargs):
        self.apply_configuration(**kwargs)
        start = Timestamp.now()
        states = kwargs["states"]
        if "POLL" in states.values():
            poll_cpus = [
                str(cpu) for cpu, state in kwargs["states"].items() if state == "POLL"
            ]
            env = {"GOMP_CPU_AFFINITY": ",".join(poll_cpus)}
            with suppress(TimeoutExpired):
                check_call("./low_power_pause", timeout=self._duration, env=env)
        else:
            time.sleep(self._duration)
        end = Timestamp.now()
        kwargs["start"] = start
        kwargs["end"] = end
        self._experiments.append(kwargs)

    def report(self):
        assert len(self._samples) > 0
        writer = DictWriter(self._csvfile, fieldnames=self._samples[0].keys())
        writer.writeheader()
        for sample in self._samples:
            writer.writerow(sample)

    async def collect_power(self, server: str, metric: str):
        client = metricq.HistoryClient(
            token="elab-cstate", add_uuid=True, management_url=server
        )
        await client.connect()

        for experiment in self._experiments:
            start = experiment["start"]
            end = experiment["end"]
            # Convert for standard output
            experiment["start"] = experiment["start"].datetime
            experiment["end"] = experiment["end"].datetime
            duration = end - start
            # add buffer for requests
            start += duration / 10
            end -= duration / 10
            result = await client.history_data_request(
                metric,
                start_time=start,
                end_time=end,
                interval_max=metricq.Timedelta(0),
                request_type=HistoryRequestType.FLEX_TIMELINE,
            )
            values = list(result.values())
            if not values:
                logger.error("Power [{}: {} - {}] missing ".format(metric, start, end))
                sample = experiment.copy()
                sample["power"] = math.nan
                sample["timestamp"] = None
                self.expand_states(sample)
                self._samples.append(sample)

            for power in values:
                sample = experiment.copy()
                sample["timestamp"] = power.timestamp.datetime
                sample["power"] = power.value
                self.expand_states(sample)
                self._samples.append(sample)
                logger.debug("Power [{}: {} - {}] {}".format(metric, start, end, power))

        await client.stop()

    @staticmethod
    def expand_states(sample):
        for cpu, state in sample["states"].items():
            sample["state_{}".format(cpu)] = state
        del sample["states"]

    @staticmethod
    def configurations():
        for (
            frequency
        ) in frequencies:
            for base_state_index, base_state in enumerate(test_states):
                states = {cpu: base_state for cpu in all_cpus}
                yield {
                    "states": states,
                    "base_state": base_state,
                    "frequency": frequency,
                    "shallow_count": 0,
                    "shallow_state": base_state,
                    "strategy": "all",
                }
                for shallow_state in test_states[0:base_state_index]:
                    linear_states = states.copy()
                    for shallow_cpu, shallow_count in zip(states.keys(), count(1)):
                        # for shallow_cpu, shallow_count in zip(states.keys(), range(1, 5)):
                        linear_states[shallow_cpu] = shallow_state
                        yield {
                            "states": linear_states.copy(),
                            "base_state": base_state,
                            "shallow_state": shallow_state,
                            "frequency": frequency,
                            "shallow_count": shallow_count,
                            "strategy": "linear",
                        }


@click.command()
@click.option("--duration", default=1, type=float)
@click.option("--out", default="c_state_power.csv", type=click.File(mode="w"))
@click.option("--server", default="amqp://localhost/")
@click.option("--power-metric", default="elab.conway.power")
@click_log.simple_verbosity_option(logger)
def main(duration: float, out: TextIO, server: str, power_metric: str):
    runner = ExperimentRunner(duration=duration, out=out)
    configurations = list(runner.configurations())
    click.echo("Estimated total time: {} s".format(len(configurations) * duration))
    for i, configuration in enumerate(configurations):
        click.echo(
            "Configuration {frequency} MHz, {base_state}, {strategy}, {shallow_count}".format(
                **configuration
            )
        )
        remaining_duration = (len(configurations) - i) * duration
        click.echo(
            "ETA: {} s | {}".format(
                remaining_duration,
                datetime.now() + timedelta(seconds=remaining_duration),
            )
        )
        runner.run_experiment(**configuration)
    # Give the DB some time...
    time.sleep(2)
    asyncio.run(runner.collect_power(server, power_metric))
    runner.report()


if __name__ == "__main__":
    main()
