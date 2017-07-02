/*
 * Year struct that allow you get the days list of
 * month, 
 */

#include <vector>
#include <time.h>

struct Year
{
  int year;
  
  Year(int y)
  {
    year = y;
  }
  
  // If year is Leap (29 days in Feb)
  bool isLeapYear(/*int year*/)
  {
    return ((year % 4 == 0) && (year % 100 == 0)) || (year % 400 == 0);
  }
  
  // Get list days in the month
  std::vector<int> getDaysOfMonth(int month)
  {
    std::vector<int> day_list;

    for (int i=1; i<=getLastDayOfMonth(month); i++)
    {
      day_list.push_back(i);
    }
    
    return day_list;
  }
  
  int getLastDayOfMonth(int month)
  {
    int days_in_month[2][12] = {
      {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
      {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    };
    
    int type = 0;
    
    if (isLeapYear())
    {
      type = 1;
    }

    return days_in_month[type][month-1];
  }
  
  int getWeekday(int month, int day)
  {
    tm time_struct;
    time_struct = {};
    time_struct.tm_year = year - 1900;
    time_struct.tm_mon = month-1;
    time_struct.tm_mday = day;
    time_struct.tm_hour = 12;    //  To avoid any doubts about summer time, etc.
    mktime( &time_struct );
 
    return time_struct.tm_wday;
  }
};
