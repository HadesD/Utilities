#include <vector>
#include <string>
#include <sstream>

std::vector<std::string> str_split(const std::string &str, const char delimiter)
{
  std::vector<std::string> internal;
  std::stringstream ss(str); // Turn the string into a stream.
  std::string tok;
  
  while(std::getline(ss, tok, delimiter))
  {
    internal.push_back(tok);
  }
  
  return internal;
}

// I don't recommend using the std namespace in production code.
// For ease of reading here.

#include <iostream>

int main(/* int argc, char *argv[] */) {
  std::string myCSV = "one,two,three,four";
  std::vector<std::string> sep = str_split(myCSV, ',');

  // If using C++11 (which I recommend)
  /* for(const std::string &t : sep)
   *  cout << t << endl;
   */
   
  for(std::size_t i = 0; i < sep.size(); ++i)
    std::cout << sep[i] << std::endl;
}
