
#include <vector>
#include <iostream>


extern "C"{
    int* symmetric_factors(int *partition, int size, int n){
        int* res_factors = new int[n+1];
        int* counter = new int[n+1];
        int n_backup = n;
        for (int length_num = 0; length_num < size; length_num++) {
            int length = partition[length_num];
            for (int i = n - length + 1; i < n+1; i++) res_factors[i] += 1;
            res_factors[length] -= 1;
            n -= length;
            counter[length]++;    // calculate Counter(partition)
        };

        for (int len = 0; len < n_backup + 1; len++){
            int amount = counter[len];
            if (amount == 1 || amount == 0) continue;
            for (int i = 2; i < amount+1; i++)
                res_factors[i]--;
        }

        return res_factors;
    }

    void free_array(int* array){
        delete[] array;
    }
}


int main(int argc, char *argv[]){

    while (1){
        int* partition = new int[101];
        int all = 0;
        int size = 0;
        while (all < 100) {
            int tmp;
            size++;
            std::cin >> tmp;
            if (tmp < 0) {
                std::cout << -1 << std::endl;
                exit(0);
            };
            partition[size-1] = tmp;
            all += tmp;
        }
        // std::cout << "starting calc for partition of size " << partition.size() << std::endl;
        auto res = symmetric_factors(partition, size, 100);

        // std::cout << res << std::endl;
        for (int i = 0; i < 101; i++) std::cout << res[i] << ' ';
        std::cout << std::endl;
    }

}
