#include <string>
#include <regex>

bool preg_match(
  const std::string &pattern, 
  const std::string &subject, 
  std::smatch &matches
  )
{
  std::regex reg(pattern);
  
  if (std::regex_search(subject, matches, reg))
  {
    return true;
  }
  return false;
}

// Test
#include <iostream>
using namespace std;
int main(void)
{
  smatch m;
  preg_match("(\\d+)", "123sdflk", m);
  cout << m[1];
}
