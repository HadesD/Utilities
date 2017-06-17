using System.Net;
using System.IO;

namespace API
{
  public class Uranai
  {
    protected string _token;
    protected string _api_url;
  
    public Uranai()
    {
      this._api_url = "http://api.jugemkey.jp/api/horoscope/free/";
      
      // this.Auth();
    }
    private bool Auth()
    {
      // Auth Statements
      this._token = "";// Result token.
      return true;
    }
    public void UranaiByBirthday(string birthday)
    {
      try
      {
        WebClient client = new WebClient();
        string content = client.DownloadString(this._api_url + birthday);
        System.Console.Write(content);
      }
      catch (WebException)
      {
        return;
      }
      // return result
    }
    public string getToken()
    {
      return this._token;
    }
    static void Main(string[] args)
    {
      Uranai u = new Uranai();
      
      u.UranaiByBirthday("2017/06/01");
    }
  }
}
