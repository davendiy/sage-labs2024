
import sys

if len(sys.argv) > 1:
    workers = int(sys.argv[1])
    num_worker = int(sys.argv[2])
else:
    workers = 1
    num_worker = 1

i = 0
start = False
for el in Partitions(100):
    i += 1

    if start and i == num_worker:
        start = False
        print(*el)
        i = 0
    elif i == workers:
        print(*el)
        i = 0

print(-1)
