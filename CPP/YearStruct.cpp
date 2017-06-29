/*
 * Year struct that allow you get the days list of
 * month, 
 */

#include <vector>

struct Year
{
  int year;
  
  Year(int y)
  {
    year = y;
  }
  
  vector<int> getDays(int month)
  {

    vector<int> day_list;

    for (int i=1; i<= getLastDayOfMonth(month); i++)
    {
      day_list.push_back(i);
    }
    
    return day_list;
  }
  
  int getLastDayOfMonth(int month)
  {
    int days_in_month[2][12] = [
      {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
      {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    ];

    return days_in_month[month-1];
  }
  
  int getWeekday(int day, int month)
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
