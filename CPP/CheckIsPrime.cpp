#include <iostream>

bool isPrime(int n)
{
    if (n < 2)
    {
        return false;
    }
    
    return true;
}


// Test
#include <limits.h>
int main(void)
{
    using namespace std;
    int from = 1;//INT_MIN;
    int to = 100;//INT_MAX;
    for (int i=from; i<=to; i++)
    {
        cout << i << " " << isPrime(i) << endl;
    }
    
    return 0;
}
