#ifndef _COLOR_DEBUG_
#define _COLOR_DEBUG_
#include <stdio.h>
#include <string>
// https://stackoverflow.com/questions/2616906/how-do-i-output-coloured-text-to-a-linux-terminal
enum class DEBUG_LEVEL
{
  INFO,
  ERROR,
  WARNING,
}

#define INFO(s) log(DEBUG_LEVEL::INFO, s);

void log(DEBUG_LEVEL l, std::string s)
{
  
}

#endif
