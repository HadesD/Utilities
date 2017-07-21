// Giai thua
// Use Recursive
// O(n)
int factorial(int n)
{
    if (n == 1)
    {
        return 1;
    }
    
    return factorial(n - 1) * n;
}

#include <iostream>                                                     

using namespace std;

int main()
{
  cout <<  factorial(4);
  
  return 0;
} 
