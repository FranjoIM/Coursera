#include <iostream>
#include <vector>
#include <algorithm>
#include <functional>

long long MPP(std::vector<long long>& numbers) {
    long long result = 0;
    std::sort(numbers.begin(), numbers.end(), std::greater<long long>());
    result = numbers[0] * numbers[1];
    return result;
}

int main() {
    int n;
    std::cin >> n;
    std::vector<long long> numbers(n);
    for (int i = 0; i < n; ++i) {
        std::cin >> numbers[i];
    }

    std::cout << MPP(numbers) << "\n";
    return 0;
}
