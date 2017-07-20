#include <iostream>                                                     
#include <chrono>
#include <thread>

// using namespace std;

int main()
{
  unsigned int sec = 1;
  
  for (int i = 1; i <= 100; i++)
  {
    std::cout << "\r"; // Back to start of line
    
    std::cout << i << "% completed: ";                                  

    std::cout << "[";

    std::cout << std::string(i, '|');
    
    std::cout << std::string(100-i, ' ');
    
    std::cout << "]";

    std::cout.flush();
  
    std::this_thread::sleep_for(std::chrono::milliseconds(500*sec));
  } 
  
  std::cout << std::endl << "Completed" << std::endl;
  
  return 0;
} 
