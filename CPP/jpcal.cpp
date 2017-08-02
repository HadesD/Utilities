/**
 * Compile:
 * g++ -std=c++1z jpcal.cpp -o jpcal && sudo cp jpcal /usr/local/bin/
 *
 * Run: jpcal 2017
 * 
 * Copyright: Dark.Hades (c) 2017
 * License: MIT
 */

#include <iostream>
#include <string>
#include <ctime>

#define APP_NAME "jpcal"

int toHeisei(int year)
{
  if (year >= 1989)
  {
    return year - 1989 + 1;
  }

  return -1;
}

int toShouwa(int year)
{
  if ((year <= 1989) && (year >= 1926))
  {
    return year - 1926 + 1;
  }

  return -1;
}

void help();

int main(int argc, char *argv[])
{
  int year;

  switch (argc)
  {
    case 2:
      {
        if (std::string(argv[1]) == "--help")
        {
          help();
          return 0;
        }
        std::string y = std::string(argv[1]);
        year = std::stoi(y);
        break;
      }

    default:
      {
        std::time_t t = time(0);
        std::tm *pTime = localtime(&t);
        year = pTime->tm_year + 1900;
        break;
      }
  }

  std::cout << "Year/年:\t" << year << std::endl;

  int heisei = toHeisei(year);
  if (heisei != -1)
  {
    std::cout << "Heisei/平成:\t" << heisei << std::endl;
  }

  int shouwa = toShouwa(year);
  if (shouwa != -1)
  {
    std::cout << "Shouwa/昭和:\t" << shouwa << std::endl;
  }

  return 0;
}

void help()
{
  std::cout << "Usage:\t" << std::string(APP_NAME) << " [OPTION] [YEAR]" << std::endl;
  std::cout << "This app will show given year to Japan 's Heisei 's year number";
}
