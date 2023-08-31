using System;
using System.Net.Http.Headers;
using System.Text;
using System.Net.Http;
using System.Web;
using System.IO;
using Newtonsoft.Json;

namespace BusMEAPI
{
    public abstract class AtApiController
    {
        static void Main(string[] args)
        {
           MakeRequest(string[] args);
        }


        /*
        * Given path https://api.at.govt.nz/gtfs/v3/routes/
        * Return JSON object
        */
        static async MakeRequest(string path)
        {
            try{
                var client = new HttpClient();
                // Request headers
                client.DefaultRequestHeaders.CacheControl = CacheControlHeaderValue.Parse("no-cache");
                client.DefaultRequestHeaders.Add("Ocp-Apim-Subscription-Key", "4fd0cce51f5448538bcaad19b3051bcf");//Change this to correct api key
                var response = await client.GetAsync(path);
                if (response != null){
                    var jsonString = await response.Content.ReadAsStringAsync();
                    return return JsonConvert.DeserializeObject<object>(jsonString);
                }
                
            }
            catch (Exception ex)
            {
                myCustomLogger.LogException(ex);
            }
            return null;
    }
}
