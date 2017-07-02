#include <string>

std::string str_replace(std::string search, std::string replace, std::string subject)
{
  std::string str = subject;
  size_t pos = 0;
  while((pos = str.find(search, pos)) != std::string::npos)
  {
    str.replace(pos, search.length(), replace);
    pos += replace.length();
  }
  return str;
}

// Test
#include <iostream>

int main (void)
{
  using namespace std;
  string s = "TestFalseTruetrue True, False, TRUE, TRUe, fAlse, false";
  cout << str_replace("T", "F", s);
  
  return 0;
}
