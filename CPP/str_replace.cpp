#include <string>

std::string str_replace(std::string search, std::string replace, std::string &subject)
{
  size_t pos = 0;
  while ((pos = str.find(search, pos)) != std::string::npos)
  {
    str.replace(pos, search.length(), replace);
    pos += replace.length();
  }
  return subject;
}

#include <vector>
std::string str_replace(std::vector<std::string> searches, std::string replace, std::string &subject)
{
  for (std::string search : searches)
  {
    size_t pos = 0;
    while ((pos = str.find(search, pos)) != std::string::npos)
    {
      subject.replace(pos, search.length(), replace);
      pos += replace.length();
    }
  }
  return subject;
}

std::string str_replace(std::vector<std::string> searches, std::vector<std::string> replaces, std::string &subject)
{
  for (int i = 0; i < searches.size(); i++)
  {
    std::string replace;
    if (replaces.size() > i)
    {
      replace = replaces.at(i);
    }
    size_t pos = 0;
    while ((pos = subject.find(searches.at(i), pos)) != std::string::npos)
    {
      subject.replace(pos, searches.at(i).length(), replace);
      pos += replace.length();
    }
  }
  return subject;
}

// Test
#include <iostream>

int main (void)
{
  using namespace std;
  string s = "TestFalseTruetrue True, False, TRUE, TRUe, fAlse, false";
  
  cout << str_replace("T", "F", s) << endl;
  
  vector<string> search = {",", " "};
  cout << str_replace(search, "_", s) << endl;
  
  return 0;
}
// Result:
// FestFalseFruetrue Frue, False, FRUE, FRUe, fAlse, false
// TestFalseTruetrue_True__False__TRUE__TRUe__fAlse__false
