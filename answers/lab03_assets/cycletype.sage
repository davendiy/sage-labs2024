import sys
import os

from tqdm import tqdm


# стандартна пайтонівська бібліотека
import ctypes
from ctypes import CDLL


# заготовочка на кілька воркерів
if len(sys.argv) > 1:
    workers = int(sys.argv[1])
    num_worker = int(sys.argv[2])
else:
    workers = 1
    num_worker = 0


cur_dir = os.path.realpath(__file__)
cur_dir = os.path.dirname(cur_dir)

# створюємо С бібліотеку з статичного файлу
# зауваження: це platform depended штука, тобто на віндовсі буде не так
cycle_types = CDLL(cur_dir + '/cycletype.so')


# прописуємо сигнатуру функцій, бо пайтон не вміє сам її визначати
cycle_types.symmetric_factors.argtypes = (ctypes.POINTER(ctypes.c_int), ctypes.c_int, ctypes.c_int)
cycle_types.symmetric_factors.restype = ctypes.POINTER(ctypes.c_int)


def symmetric_factors(partitions: list, n: int):
    # спершу треба пайтонівський список перетворити в динамічний масив
    # для цього створюємо необхідний тип
    array_type = ctypes.c_int * int(len(partitions))

    # і перетворюємо. Тут зірочка буквально означає посилання
    c_array = array_type(*list(partitions))

    # викликаємо сішну функцію (вона сіплюсплюсна, але пайтон про це не знає)
    result = cycle_types.symmetric_factors(c_array, int(len(partitions)), int(n))
    res = 1
    for i in range(n+1):
        # res *= i ** result[i]
        if result[i] > 0:
            res *= i ** result[i]
    for i in range(n+1):
        if result[i] < 0:
            res //= i ** (-result[i])

    # звільняємо памʼять, щоб не було витоку
    cycle_types.free_array(result)
    return res


full = 190569292

start = True
n = 0
orders = {}

print(f'[*] Starting calculation for #{num_worker} worker of {workers} total.')

for part in tqdm(Partitions(100), total=int(full)):

    if (start and n == num_worker) or n == workers:
        n = 0
        start = False
        amount = symmetric_factors(part, 100)
        order = LCM(part)   # найменше спільне кратне для послідовностей
        if order not in orders:
            orders[order] = 0
        orders[order] += amount

    n += 1


with open(f'./result_worker{num_worker}.txt', 'w') as file:
    for k, v in orders.items():
        print(k, v, file=file)
