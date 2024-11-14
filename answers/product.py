
import sys
from tqdm import tqdm


if len(sys.argv) > 1:
    workers = int(sys.argv[1])
    num_worker = int(sys.argv[2])
else:
    workers = 1
    num_worker = 1


full = 190569292


for _ in tqdm(range((full//workers) + 2)):
    x = list(map(int, input().split()))
    if x[0] == -1:
        exit(0)

    res = 1
    for i in range(2, 100+1):
        if x[i] > 0:
            res *= i ** x[i]

        # exclude division and cast into float
        elif x[i] < 0:
            res //= pow(i, abs(x[i]))
