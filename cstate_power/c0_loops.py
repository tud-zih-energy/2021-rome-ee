#!/bin/env python3
import asyncio
import math
import time
from contextlib import suppress
from csv import DictWriter
from datetime import datetime, timedelta
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


class ExperimentRunner:
    def __init__(self, duration: float, out: TextIO):
        self._duration = duration
        self._csvfile = out
        self._experiments: List[Dict[str, Any]] = []
        self._samples: List[Dict[str, Any]] = []

    def apply_configuration(self, frequency, **kwargs):
        lab_management_scripts.features.frequency.do_set("userspace", frequency)

    def run_experiment(self, **kwargs):
        self.apply_configuration(**kwargs)
        start = Timestamp.now()
        if kwargs["implementation"] == "POLL":
            time.sleep(self._duration)
        else:
            with suppress(TimeoutExpired):
                check_call(
                    "./low_power_" + kwargs["implementation"], timeout=self._duration
                )
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
        pass

    @staticmethod
    def configurations():
        for _ in range(3):
            for (
                frequency
            ) in lab_management_scripts.features.frequency.available_frequencies():
                for x in ("repnop", "pause", "sqrtsd", "fsqrt"):
                    yield {"implementation": x, "frequency": frequency}
                yield {"implementation": "POLL", "frequency": frequency}


@click.command()
@click.option("--duration", default=1, type=float)
@click.option("--out", default="c0_loops_power.csv", type=click.File(mode="w"))
@click.option("--server", default="amqp://localhost/")
@click.option("--power-metric", default="elab.conway.power")
@click_log.simple_verbosity_option(logger)
def main(duration: float, out: TextIO, server: str, power_metric: str):
    runner = ExperimentRunner(duration=duration, out=out)
    configurations = list(runner.configurations())
    click.echo("Estimated total time: {} s".format(len(configurations) * duration))
    for i, configuration in enumerate(configurations):
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
