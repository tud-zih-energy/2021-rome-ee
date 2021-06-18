from enum import Enum
from functools import total_ordering

from .colors import color
from .markers import marker


@total_ordering
class Kernel(Enum):
    UNDEFINED = 0
    init = 1
    idle = 2
    addpd = 3
    busywait = 4
    compute = 5
    firestarter = 6
    matmul = 7
    memory_read = 8
    mulpd = 9
    sine = 10
    sqrt = 11
    high_low = 12
    memory_copy = 14
    memory_write = 13

    @property
    def color(self):
        return color(self.value - self.init.value)

    @property
    def marker(self):
        return marker(self.value - self.init.value)

    def __lt__(self, other):
        return self.value < other.value

    def __str__(self):
        return self.name
