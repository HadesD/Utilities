#include <iostream>
#include <vector>

using namespace std;

// Settings
namespace settings
{
  int calendar_of = 2017;
  int max_cols = 3;
  namespace birthday
  {
    int day = 20;
    int month = 3;
  }
}

// Year struct by HaiLe
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

    for (int i=1; i<= getLastDay(month); i++)
    {
      day_list.push_back(i);
    }
    
    return day_list;
  }
  
  int getLastDay(int month)
  {
    // ２月まだ計算していない
    int days_in_month[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    
    return days_in_month[month-1];
  }
  
  int getDayWeek(int day, int month)
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

vector<string> month_name(int month)
{
  vector<string> name = {"\t", "\t", "\t", to_string(month)+"月\t", "\t", "\t", "\t"};
  return name;
}

vector<string> dayweek_name(int month)
{
  vector<string> name = { "日\t","月\t", "火\t", "水\t", "木\t", "金\t", "土\t", };
  return name;
}

vector<vector<string>> days(int y, int m)
{
  vector<vector<string>> rs;
  
  Year year = Year::Year(y);
  
  // Header of month
  rs.push_back(month_name(m));
  rs.push_back(dayweek_name(m));
  
  // Days of month
  vector<string> week_line;
  int first_monthday_pos = year.getDayWeek(1, m);
  for (int i=0; i<first_monthday_pos; i++)
  {
    week_line.push_back("\t");
  }
  for (auto d : year.getDays(m))
  {
    string day = to_string(d);
    if (d == settings::birthday::day && m == settings::birthday::month)
    {
      day = "*"+day+"*";
    }
    week_line.push_back(day+"\t");
    if (year.getDayWeek(d, m) == 6)
    {
      rs.push_back(week_line);
      week_line.clear();
    }
  }
  
  int last_monthday_pos = year.getDayWeek(year.getLastDay(m), m);
  while (last_monthday_pos < 6)
  {
    week_line.push_back("\t");
    last_monthday_pos++;
  }
  rs.push_back(week_line);
  if (rs.size() < 8)
  {
    rs.push_back({"\t", "\t", "\t", "\t", "\t", "\t", "\t"});
  }
  
  return rs;
}

int main(void)
{
  // Build month
  int month = 12;
  int cols = settings::max_cols;
  int rows = month / cols;
  
  int start_month = 1;
  for (int cur_row=1; cur_row<=rows; cur_row++)
  {
    int to_max_month = start_month + cols;
    for (int line=0; line<8; line++)
    {
      for (int cur_month=start_month; cur_month<to_max_month; cur_month++)
      {
        vector<string> days_list = days(settings::calendar_of, cur_month).at(line);
        for (int cur_row_of_line=0; cur_row_of_line<days_list.size(); cur_row_of_line++)
        {
          cout << days_list.at(cur_row_of_line);
        }
      }
      cout << endl;
    }
    start_month = cur_row * cols + 1;
    cout << endl;
  }
  
  return 0;
}
