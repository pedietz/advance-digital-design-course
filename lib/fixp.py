from __future__ import annotations
from dataclasses import dataclass, field
from numbers import Real
from typing import Callable
import math

# Overflow actions:

@staticmethod
def saturate(value: int, limits: tuple[int, int]) -> int:
    min_value, max_value = (min(limits), max(limits))
    return max_value if value > max_value else min_value if value < min_value else value

@staticmethod
def wrap(value: int, limits: tuple[int, int]) -> int:
    min_value, max_value = (min(limits), max(limits))
    return (value - min_value) % (max_value - min_value + 1) + min_value

# Rounding methods:

@staticmethod
def truncate(value: Real) -> int:
    return math.floor(value) if value < 0 else int(value)

@staticmethod
def round_up(value: Real) -> int:
    return math.ceil(value)

@staticmethod
def round_dw(value: Real) -> int:
    return math.floor(value)

@staticmethod
def round_half_up(value: Real) -> int:
    return math.floor(value + 0.5)

@staticmethod
def round_half_dw(value: Real) -> int:
    return math.ceil(value - 0.5)

@staticmethod
def round_half_toward_zero(value: Real) -> int:
    return math.ceil(value - 0.5) if value >= 0 else math.floor(value + 0.5)

@staticmethod
def round_half_away_from_zero(value: Real) -> int:
    return math.floor(value + 0.5) if value >= 0 else math.ceil(value - 0.5)

@staticmethod
def round_half_to_even(value: Real) -> int:
    return round(value)

@staticmethod
def round_half_to_odd(value: Real) -> int:
    return math.floor(value + 0.5) - int(value) % 2 if value >= 0 else \
           math.ceil(value - 0.5) + int(value) % 2

# DeFixedInt Class:

@dataclass
class DeFixedInt:

    init_value:      Real = 0
    int_width:       int  = 0
    frac_width:      int  = 15
    signedness:      str  = 'S'
    rounding_method: Callable[[Real], int] = field(default=truncate)
    overflow_action: Callable[[int, tuple[int, int]], int] = field(default=saturate)

    def __post_init__(self):
        if self.int_width < 0 and abs(self.int_width) >= self.frac_width:
            raise ValueError("Integer width needs to be >= -(fractional width)!")
        if self.frac_width < 0:
            raise ValueError("Fractional width needs to be >= 0!")
        if self.signedness not in {'S', 'U'}:
            raise ValueError(f"Signed mode '{self.signed_mode}' not supported!")
        self.value = self.init_value
    
    @property
    def value(self) -> int:
        return self.__value
    
    @value.setter
    def value(self, value) -> None:
        aux = value * (2.0 ** self.frac_width)
        aux = self.rounding_method(aux)
        self.__value = self.overflow_action(aux, self.range)

    @property
    def fvalue(self) -> float:
        return self.__value / (2.0 ** self.frac_width)
    
    @property
    def width(self) -> int:
        return self.int_width + self.frac_width + 1

    @property
    def range(self) -> tuple[int, int]:
        max_lim =  2 ** (self.width - int(self.signedness == 'S')) - 1
        min_lim = -2 ** (self.width - 1) * int(self.signedness == 'S')
        return (min_lim, max_lim)
    
    def __repr__(self) -> str:
        return f"<{self.value} ({self.fvalue:.3f}) {self.signedness}({self.int_width + self.frac_width},{self.frac_width})>"

    def __index__(self) -> int:
        return self.value
    
    def __eq__(self, other: DeFixedInt) -> bool:
        return math.isclose(self.fvalue, other.fvalue, rel_tol=0.0, abs_tol=0.0)

    def __lt__(self, other: DeFixedInt) -> bool:
        return self.fvalue < other.fvalue

    def __le__(self, other: DeFixedInt) -> bool:
        return self.fvalue <= other.fvalue

    def __gt__(self, other: DeFixedInt) -> bool:
        return self.fvalue > other.fvalue

    def __ge__(self, other: DeFixedInt) -> bool:
        return self.fvalue >= other.fvalue

    def __add__(self, other: DeFixedInt) -> DeFixedInt:
        return DeFixedInt(init_value      = self.fvalue + other.fvalue,
                          int_width       = max(self.int_width,  other.int_width) + 1,
                          frac_width      = max(self.frac_width, other.frac_width),
                          signedness      = self.signedness,
                          rounding_method = self.rounding_method,
                          overflow_action = self.overflow_action)
    
    def __sub__(self, other: DeFixedInt) -> DeFixedInt:
        return DeFixedInt(init_value      = self.fvalue - other.fvalue,
                          int_width       = max(self.int_width, other.int_width) + 1,
                          frac_width      = max(self.frac_width, other.frac_width),
                          signedness      = self.signedness,
                          rounding_method = self.rounding_method,
                          overflow_action = self.overflow_action)

    def __mul__(self, other: DeFixedInt) -> DeFixedInt:
        return DeFixedInt(init_value      = self.fvalue * other.fvalue,
                          int_width       = self.int_width + other.int_width,
                          frac_width      = self.frac_width + other.frac_width,
                          signedness      = self.signedness,
                          rounding_method = self.rounding_method,
                          overflow_action = self.overflow_action)
    
if __name__ == '__main__':

    a = DeFixedInt(-223.14, 2, 2, signedness='U', rounding_method=round_half_to_even, overflow_action=saturate)
    b = DeFixedInt(-2.05, 2, 4, signedness='U', rounding_method=round_half_to_even, overflow_action=wrap)

    print(a)
    print(b)
    print(a + b)
    print(a - b)
    print(a * b)
    print(a < b)
    print(a > b)
    print(a == b)
