#ifndef _COLOR_DEBUG_
#define _COLOR_DEBUG_
#include <stdio.h>
#include <string>
enum class DEBUG_TYPE
{
  INFO,
  ERROR,
  WARNING,
}

#define INFO(s) log(DEBUG_TYPE::INFO, s);


#endif
