from __future__ import annotations
from dataclasses import dataclass, field
from numbers import Real
from typing import Callable
import math

# Saturation strategies:

@staticmethod
def saturate(value: int, limits: tuple[int, int]) -> int:
    min_value, max_value = limits
    return max_value if value > max_value else min_value if value < min_value else value

@staticmethod
def wrap(value: int, limits: tuple[int, int]) -> int:
    min_value, max_value = limits
    return value - max_value + min_value - 1 if value > max_value else \
           value + max_value - min_value + 1 if value < min_value else value

# Rounding strategies:

@staticmethod
def truncate(value: Real) -> int:
    return math.floor(value) if value < 0 else int(value)

@staticmethod
def round_half_up(value: Real) -> int:
    frac = math.modf(value)[0]
    return math.ceil(value) if math.isclose(abs(frac), 0.5, rel_tol=1e-18) else round(value)

@staticmethod
def round_half_dw(value: Real) -> int:
    frac = math.modf(value)[0]
    return math.floor(value) if math.isclose(abs(frac), 0.5, rel_tol=1e-18) else round(value)

@staticmethod
def round_to_even(value: Real) -> int:
    return round(value)

@staticmethod
def round_to_odd(value: Real) -> int:
    return round(value)

# DeFixedInt Class:

@dataclass
class DeFixedInt:

    init_value:    Real = 0
    int_width:     int  = 0
    frac_width:    int  = 15
    signed_mode:   str  = 'S'
    round_func:    Callable[[Real], int] = field(default=truncate)
    saturate_func: Callable[[int, tuple[int, int]], int] = field(default=saturate)

    def __post_init__(self):
        if self.int_width < 0 and abs(self.int_width) >= self.frac_width:
            raise ValueError("Integer width needs to be >= -(fractional width)!")
        if self.frac_width < 0:
            raise ValueError("Fractional width needs to be >= 0!")
        if self.signed_mode not in {'S', 'U'}:
            raise ValueError(f"Signed mode '{self.signed_mode}' not supported!")
        self.value = self.init_value
    
    @property
    def value(self) -> int:
        return self.__value
    
    @value.setter
    def value(self, value) -> None:
        aux = value * (2.0 ** self.frac_width)
        aux = self.round_func(aux)
        self.__value = self.saturate_func(aux, self.range)

    @property
    def fvalue(self) -> float:
        return self.__value / (2.0 ** self.frac_width)
    
    @property
    def width(self) -> int:
        return self.int_width + self.frac_width + 1

    @property
    def range(self) -> tuple[int, int]:
        max_lim =  2 ** (self.width - int(self.signed_mode == 'S')) - 1
        min_lim = -2 ** (self.width - 1) * int(self.signed_mode == 'S')
        return (min_lim, max_lim)
    
    def __repr__(self) -> str:
        return f"<{self.value} ({self.fvalue:.3f}) {self.signed_mode}({self.int_width + self.frac_width},{self.frac_width})>"

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
        ret = DeFixedInt(int_width     = max(self.int_width, other.int_width) + 1,
                         frac_width    = max(self.frac_width, other.frac_width),
                         signed_mode   = self.signed_mode,
                         round_func    = self.round_func,
                         saturate_func = self.saturate_func)
        ret.value = self.fvalue + other.fvalue
        return ret
    
    def __sub__(self, other: DeFixedInt) -> DeFixedInt:
        ret = DeFixedInt(int_width     = max(self.int_width, other.int_width) + 1,
                         frac_width    = max(self.frac_width, other.frac_width),
                         signed_mode   = self.signed_mode,
                         round_func    = self.round_func,
                         saturate_func = self.saturate_func)
        ret.value = self.fvalue - other.fvalue
        return ret

    def __mul__(self, other: DeFixedInt) -> DeFixedInt:
        ret = DeFixedInt(int_width     = self.int_width + other.int_width,
                         frac_width    = self.frac_width + other.frac_width,
                         signed_mode    = self.signed_mode,
                         round_func    = self.round_func,
                         saturate_func = self.saturate_func)
        ret.value = self.fvalue * other.fvalue
        return ret
    
if __name__ == '__main__':

    a = DeFixedInt(2.05, 2, 2, round_func=round_to_even, saturate_func=saturate) 
    b = DeFixedInt(2.05, 2, 4, round_func=round_to_even, saturate_func=saturate)

    print(a)
    print(b)
    print(a + b)
    print(a - b)
    print(a * b)
    print(a < b)
    print(a > b)
    print(a == b)
