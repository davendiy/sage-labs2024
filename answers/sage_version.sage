from tqdm import tqdm

factors_cached = [0] + [list(factor(i)) for i in range(1, 101)]
primes = [0] + [el in Primes(101) for el in range(1, 101)]


def number_optimized(partition, n, factorize=False):
    # дільники результуючого числа
    res_factors = [0 for _ in range(n+1)]
    n_backup = n
    counter = [0 for _ in range(n+1)]
    for length in partition:

        for i in range(1, n+1):    # * n!
            res_factors[i] += 1

        for i in range(1, n-length+1):   # / (n-k)!
            res_factors[i] -= 1

        res_factors[length] -= 1
        n -= length
        counter[length] += 1

    n = n_backup

    for amount in counter:
        if amount == 1 or amount == 0: continue
        for i in range(1, amount+1):
            res_factors[i] -= 1

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
            res *= pow(i, res_factors[i])
        elif res_factors[i] < 0:
            res //= pow(i, abs(res_factors[i]))

    return res, res_factors


for el in tqdm(Partitions(100), total=int(190569292)):
    number_optimized(el, 100, factorize=False)
    # print(*factors)

# print(number_optimized([98, 1, 1], 100))
