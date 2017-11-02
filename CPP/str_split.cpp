#include <vector>
#include <string>

std::vector<std::string> split(const std::string &s, const char delim)
{
  unsigned int i = 0;
  auto pos = s.find(delim);
  std::vector<std::string> v;
  while (pos != std::string::npos) {
    v.emplace_back(s.substr(i, pos-i));
    i = ++pos;
    pos = s.find(delim, pos);
  }
  if (pos == std::string::npos)
  {
     v.emplace_back(s.substr(i, s.length()));
  }
  
  return v;
}

// I don't recommend using the std namespace in production code.
// For ease of reading here.

#include <iostream>

int main(/* int argc, char *argv[] */) {
  std::string myCSV = "one,two,three,four";
  std::vector<std::string> sep = split(myCSV, ',');

  // If using C++11 (which I recommend)
  /* for(const std::string &t : sep)
   *  cout << t << endl;
   */
   
  for(std::size_t i = 0; i < sep.size(); ++i)
    std::cout << sep[i] << std::endl;
}
