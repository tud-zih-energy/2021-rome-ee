import itertools
from .utils import unique_index

markers = "xsov^Dp<>*h8+"


def marker(i):
    return markers[i % len(markers)]


def unique_marker(value, series):
    return marker(unique_index(value, series))


def marker_cycle():
    return itertools.cycle(markers)