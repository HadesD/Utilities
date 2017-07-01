#include <math.h>

bool isPrime(int n)
{
    if (n <= 1)
    {
        return false;
    }
    
    if (n == 2)
    {
        return true;
    }
    
    if ((n > 2) && ((n % 2) == 0))
    {
        return false;
    }
    
    int to_max = sqrt(n);
    for (int i=3; i<=to_max; i+=2)
    {
        if ((n % i) == 0)
        {
            if ((n % i) == 0)
            {
                return false;
            }
        }
    }
    
    return true;
}


// Test
#include <iostream>
#include <limits.h>
#include <ctime>
int main(void)
{
    using namespace std;
    int from = 0;
    int to = 10;
    const long double t0 = time(0)*1000;
    for (int i=from; i<=to; i++)
    {
        cout << i << " " << isPrime(i) << endl;
    }
    const long double t = time(0)*1000;
    cout << (t-t0);
    
    return 0;
}
