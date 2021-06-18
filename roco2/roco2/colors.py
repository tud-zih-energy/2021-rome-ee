import itertools
from .utils import unique_index

# From http://eleanormaclure.files.wordpress.com/2011/03/colour-coding.pdf
colors = (
    # '#FFFFFF',  # White
    # '#000000',  # Black
    '#FFB300',  # Vivid Yellow
    '#803E75',  # Strong Purple
    '#FF6800',  # Vivid Orange
    '#A6BDD7',  # Very Light Blue
    '#C10020',  # Vivid Red
    '#CEA262',  # Grayish Yellow
    # '#817066',  # Medium Gray
    '#007D34',  # Vivid Green
    '#F6768E',  # Strong Purplish Pink
    '#00538A',  # Strong Blue
    #'#FF7A5C',  # Strong Yellowish Pink
    '#53377A',  # Strong Violet
    '#FF8E00',  # Vivid Orange Yellow
    '#B32851',  # Strong Purplish Red
    # '#F4C800',  # Vivid Greenish Yellow
    '#7F180D',  # Strong Reddish Brown
    '#93AA00',  # Vivid Yellowish Green
    '#593315',  # Deep Yellowish Brown
    '#F13A13',  # Vivid Reddish Orange
    '#232C16',  # Dark Olive Green
)


def color(i):
    return colors[i % len(colors)]


def unique_color(value, series):
    return color(unique_index(value, series))


def color_cycle():
    cycle = itertools.cycle(colors)

    def next_color():
        return next(cycle)

    return next_color
