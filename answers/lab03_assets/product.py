
import sys
from tqdm import tqdm
 # import numpy as np


# заготовочка, щоб можна було потім використати кілька процесів
if len(sys.argv) > 1:
    workers = int(sys.argv[1])
    num_worker = int(sys.argv[2])
else:
    workers = 1
    num_worker = 0


full = 190569292
time = []

# tqdm дає красивий прогресбар, але йому треба знати повну кількість переборів
for _ in tqdm(range((full//workers) + 2)):

    # той самий input().split() з єолімпа
    x = list(map(int, input().split()))
    if x[0] == -1:
        break

    res = 1
    for i in range(2, 100+1):
        if x[i] > 0:
            res *= i ** x[i]

    for i in range(2, 100+1):
        # цілочисельне ділення, щоб число не перетворилось в
        # float (який має недостатню точність)
        if x[i] < 0:
            res //= i ** abs(x[i])

print(res)

