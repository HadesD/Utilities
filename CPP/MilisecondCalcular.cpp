#include <iostream>
#include <ctime>
#include <ratio>
#include <chrono>

//using namespace std::chrono;

int main ()
{

  std::chrono::high_resolution_clock::time_point t1 = std::chrono::high_resolution_clock::now();
  
  for (int i = 0; i < 1000; i++)
  {
    std::cout << "1";
  }
  
  std::cout << std::endl;

  std::chrono::high_resolution_clock::time_point t2 = std::chrono::high_resolution_clock::now();

  std::chrono::duration<double, std::milli> time_span = t2 - t1;

  std::cout << "It took me " << time_span.count() << " milliseconds.";
  std::cout << std::endl;

  return 0;
}
