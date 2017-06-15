namespace API
{
  public class Uranai
  {
    protected string _token;
    protected string _api_url;
  
    public Uranai()
    {
      this._api_url = "https://api.example.com/v1/uranai/";
      
      // this.Auth();
    }
    private bool Auth()
    {
      // Auth Statements
      this._token = "";// Result token.
      return true;
    }
    public /* string|array_type */ UranaiByBirthday(int birthday)
    {
      // return result
    }
    public string getToken()
    {
      return this._token;
    }
  }
}
