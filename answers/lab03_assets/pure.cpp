
#include <vector>
#include <map>
#include <iostream>

std::vector< std::map<int, int> > FACTORS_CACHED;
std::vector<bool> IS_PRIME(101, 0);


// заготовочка під кілька процесів
int workers;
int num_worker;


// перші 100 простих чисел і розклад всіх чисел на множники для factorize=True
void precalculate(){
    for (int N = 0; N < 101; N++){
        int i = N;
        std::map<int, int> factors;
        while (i > 1){
            for (int j = 2; j < i+1; j++){
                if (i % j == 0){
                    if (!factors.count(j)) factors[j] = 0;
                    factors[j] += 1;
                    i = i / j;
                    break;
                }
            }
        }
        FACTORS_CACHED.push_back(factors);

        bool prime = true;
        for (int j = 2; j < N; j++){
            if (N % j == 0){
                prime = false;
                break;
            }
        }
        IS_PRIME[N] = prime;
    }
}


std::vector<int> symmetric_factors(std::vector<int> &partition, int n, bool factorize){
    std::vector<int> res_factors(n+1, 0);
    std::vector<int> counter(n+1, 0);
    int n_backup = n;
    for (auto length : partition) {
        for (int i = n - length + 1; i < n+1; i++) res_factors[i] += 1;
        res_factors[length] -= 1;
        n -= length;

        counter[length]++;    // calculate Counter(partition)
    };

    for (auto const amount : counter){
        if (amount == 1 || amount == 0) continue;
        for (int i = 2; i < amount+1; i++)
            res_factors[i]--;
    }

    if (factorize){
        for (int i = 2; i < n_backup+1; i++){
            if (IS_PRIME[i]) continue;
            if (!res_factors[i]) continue;

            int i_amount = res_factors[i];
            for (auto fact : FACTORS_CACHED[i]){
                res_factors[fact.first] += fact.second * i_amount;
            }
            res_factors[i] -= i_amount;
        }
    }

    return res_factors;
}


void call_factors(std::vector<int> &a, int end, bool factorize){
    std::vector<int>::const_iterator first = a.begin();
    std::vector<int>::const_iterator last = a.begin() + end;
    std::vector<int> newVec(first, last);
    auto res = symmetric_factors(newVec, 100, factorize);
    for (auto el : res) {
        std::cout << el << ' ';
    }
    std::cout << std::endl;
}


// взято отуть: https://jeromekelleher.net/generating-integer-partitions.html
void partitions(int n, bool factorize) {

    int work_num = 0;
    bool start = true;

    std::vector<int> a(n, 0);
    int k = 1;
    int y = n - 1;
    while (k != 0) {
        int x = a[k-1] + 1;
        k -= 1;
        while (2 * x <= y) {
            a[k] = x;
            y -= x;
            k += 1;
        };
        int l = k + 1;
        while (x <= y){
            a[k] = x;
            a[l] = y;

            work_num++;

            if ((start && work_num == num_worker) || work_num == workers){
                call_factors(a, k+2, factorize);
                work_num = 0;
                start = false;
            }
            x += 1;
            y -= 1;
        }
        a[k] = x + y;
        y = x + y - 1;

        work_num++;
        if ((start && work_num == num_worker) || work_num == workers){
            call_factors(a, k+1, factorize);
            work_num = 0;
            start = false;
        }
    }
}


int main(int argc, char** argv){
    if (argc > 1){
        workers = atoi(argv[1]);
        num_worker = atoi(argv[2]);
    }
    else {
        workers = 1;
        num_worker = 0;
    }

    precalculate();
    partitions(100, false);
}
