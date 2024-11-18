

start = False
i = 0
for el in Partitions(100):
    print(*el)

    i += 1
    if i == 10000:
        break

print(-1)
