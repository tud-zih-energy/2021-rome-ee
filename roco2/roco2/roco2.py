import pandas as pd

from .kernel import Kernel


def read_phase_profile(filename, power_channel=None, power_offset=0):
    experiments = pd.read_csv(filename, sep="\t", quotechar="'")
    experiments['kernel'] = experiments.experiment.apply(Kernel)
    if power_channel:
        power_flt = experiments.filter(regex=power_channel)
        experiments['power'] = power_flt.sum(1) - power_offset
    return experiments
