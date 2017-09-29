#include <iostream>

int zellerWeekday(const int &d, const int &m, const int &y)
{
  if (m == 1)
  {
    
  }
  int wd = (5 * y / 4 - y / 100 + y / 400 + (26 * m + 16) / 10 + d) % 7;
}

int main()
{
  int d;
  int m;
  int y;
  
  
  
  return 0;
}
