from tqdm import tqdm

factors_cached = [0] + [list(factor(i)) for i in range(1, 101)]
primes = [0] + [el in Primes(101) for el in range(1, 101)]


def number_optimized(partition, n, factorize=False):
    # дільники результуючого числа
    res_factors = [0 for _ in range(n+1)]
    n_backup = n
    counter = [0 for _ in range(n+1)]
    for length in partition:

        for i in range(n-length+1, n+1):    # * n! / (n-k)!
            res_factors[i] += 1

        res_factors[length] -= 1
        n -= length
        counter[length] += 1

    n = n_backup

    for amount in counter:
        if amount == 1 or amount == 0: continue
        for i in range(1, amount+1):
            res_factors[i] -= 1

    # варіант з розкладанням на прості множники, щоб більше скоротити. Працює довше
    if factorize:
        for i in range(2, n+1):
            if primes[i]: continue
            if not res_factors[i]: continue

            i_amount = res_factors[i]
            for fact, f_amount in factors_cached[i]:
                res_factors[fact] += f_amount * i_amount
            res_factors[i] -= i_amount
    res = 1
    for i in range(2, n+1):
        if res_factors[i] > 0:
            res *= i ** res_factors[i]

    for i in range(2, n+1):
        if res_factors[i] < 0:

            # використовуємо цілочисельне ділення, бо результат точно буде цілим числом
            # робимо це другим циклом, оскільки великі дільники можуть розкладатись на менші
            res //= i ** (-res_factors[i])

    return res, res_factors


if __name__ == '__main__':
    import numpy as np
    import time

    res = []

    for _ in range(100):
        el = Partitions(100).random_element()
        t = time.time()
        number_optimized(partition=el, n=100)
        res.append(time.time() - t)

    print(f'elapsed: {np.mean(res):.5f}s +- {np.std(res):.5f}')

    mean_hours = (np.mean(res) * 190569292) / 3600
    std_hours = np.std(res) * 190569292 / 3600
    print(f'estimated time: {mean_hours:.2f}h +- {std_hours:.2f}h')

    for el in tqdm(Partitions(100), total=int(Partitions(100).cardinality())):
        number_optimized(el, 100)

# for el in tqdm(Partitions(100), total=int(190569292)):
#     number_optimized(el, 100, factorize=False)
    # print(*factors)

# print(number_optimized([98, 1, 1], 100))
