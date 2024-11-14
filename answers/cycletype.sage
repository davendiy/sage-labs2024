import sys

from tqdm import tqdm

import ctypes
from ctypes import CDLL


if len(sys.argv) > 1:
    workers = int(sys.argv[1])
    num_worker = int(sys.argv[2])
else:
    workers = 1
    num_worker = 0


cycle_types = CDLL('cycletype.so')


cycle_types.symmetric_factors.argtypes = (ctypes.POINTER(ctypes.c_int), ctypes.c_int, ctypes.c_int)
cycle_types.symmetric_factors.restype = ctypes.POINTER(ctypes.c_int)


def symmetric_factors(partitions: list, n: int):
    array_type = ctypes.c_int * int(len(partitions))  # Define array type
    c_array = array_type(*list(partitions))            # Create C array
    result = cycle_types.symmetric_factors(c_array, int(len(partitions)), int(n))
    res = 1
    for i in range(n+1):
        # res *= i ** result[i]
        if result[i] > 0:
            res *= i ** result[i]
        elif result[i] < 0:
            res //= i ** (-result[i])

    cycle_types.free_array(result)
    return res


full = 190569292

start = False
n = 0
orders = {}

print(f'[*] Starting calculation for #{num_worker} worker of {workers} total.')

for part in tqdm(Partitions(100), total=int(full)):

    if (start and n == num_worker) or n == workers:
        n = 0
        start = False
        amount = symmetric_factors(part, 100)
        order = LCM(part)
        if order not in orders:
            orders[order] = 0
        orders[order] += amount

    n += 1


with open(f'./result_worker{num_worker}.txt', 'w') as file:
    for k, v in orders.items():
        print(k, v, file=file)
