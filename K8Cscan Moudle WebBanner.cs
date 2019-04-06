using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Text.RegularExpressions;

namespace CscanDLL
{
    public class scan
    {
        public static string run(string ip)
        {
            if (string.IsNullOrEmpty(ip))
                return "";
            else
            {
                string hostName = "";
                //string urlTitle = "";
                //try
                //{
                //    hostName = "[" + System.Net.Dns.GetHostByAddress(ip).HostName.ToString() + "]";
                //    //urlTitle = GetTitle(getHtml("http://" + ip, 2));
                //}
                //catch (Exception)
                //{
                //    hostName = "[               ]";
                //    //urlTitle = "";
                //}

                //return ip;
                //return System.Net.Dns.GetHostByAddress(ip).HostName;
                //192.11.22.10    Microsoft-IIS/10.0      IIS Windows
                //192.11.22.1     H3C-Miniware-Webs       ER3200G2系统管理
                //return ip + "\t" + getURLbanner(ip) + "\t" + GetTitle(getHtml("http://" + ip,2));
                return ip + "\t" + hostName + "\t[" + getURLbanner(ip) + "]\t[" + GetTitle(getHtml("http://" + ip, 2)) + "]";
                //return ip + "\t" + System.Net.Dns.GetHostByAddress(ip).HostName;
            
            
            }

        }

        private static string getURLbanner(string url)
        {
            ////HttpWebResponse res;
            if (!url.ToLower().Contains("https://") && !url.ToLower().Contains("http://"))
                url = "http://" + url;

            try
            {
                var req = (HttpWebRequest)WebRequest.CreateDefault(new Uri(url));
                req.Method = "HEAD";
                req.Timeout = 1000;
                var res = (HttpWebResponse)req.GetResponse();

                if (res.StatusCode == HttpStatusCode.OK || res.StatusCode == HttpStatusCode.Forbidden || res.StatusCode == HttpStatusCode.Redirect || res.StatusCode == HttpStatusCode.MovedPermanently)
                {
                    return res.Server;
                }

                //res.Close();

                return res.Server;
            }
            catch (WebException ex)
            {
                return "";
            }
        }

        private static string GetTitle(string html)
        {
            if (html.Contains("<hTmlKErRor>"))
            {
                //return html.Replace("<hTmlKErRor>", "");
                return "";
            }

            //以下正则 云- 会显示乱码 比如 <title>百度云-登录</title>  
            //string pattern = @"(?si)<title(?:\s+(?:""[^""]*""|'[^']*'|[^""'>])*)?>(?<title>.*?)</title>";
            //return Regex.Match(html, pattern).Groups["title"].Value.Trim();
            //建立获取网页标题正则表达式  

            //String regex = @"<title>.+</title>";

            // https://kgopen.baidu.com/index 中断发现源码里是\n
            //<title>
            //     百度知识图谱开放平台  (这个带换行的)
            //</title>

            html = html.Replace("<br>", "");
            html = html.Replace("<BR>", "");
            html = html.Replace("\r\n", "");
            html = html.Replace("&nbsp;", " ");
            html = html.Replace("\n", "").Trim();

            //思科特征 <title id="page_title">Sign in to Cisco Finesse</title>
            String regex = @"<title.+</title>";//所以得这样截取才能截到标题

            String title = Regex.Match(html, regex).ToString();
            title = Regex.Replace(title, @"[\""]+", "");

            title = title.TrimStart('<');

            string regex2 = @">.+</title>";

            string title2 = Regex.Match(title, regex2).ToString();
            title2 = title2.TrimStart('>').Replace("</title>", "").Trim();

            if (title2.Length > 50) //截取长度 超过50的可能截取出错了
                return title2.Substring(0, 50);

            return title2;

        }

        private static string getHtml(string url, int codingType)
        {

            try
            {
                if (!url.ToLower().Contains("https://") && !url.ToLower().Contains("http://"))
                    url = "http://" + url;
                WebClient myWebClient = new WebClient();
                if (url.ToLower().Contains("https://"))
                {
                    System.Net.ServicePointManager.ServerCertificateValidationCallback +=
    delegate(object sender, System.Security.Cryptography.X509Certificates.X509Certificate certificate,
             System.Security.Cryptography.X509Certificates.X509Chain chain,
             System.Net.Security.SslPolicyErrors sslPolicyErrors)
    {
        return true; // **** Always accept
    };

                }

                byte[] myDataBuffer = myWebClient.DownloadData(url);
                //return Encoding.Default.GetString(myDataBuffer);
                string strWebData = System.Text.Encoding.Default.GetString(myDataBuffer);

                //自动识别编码  不一定有<meta  比如 百度开放平台 content="text/html; charset=gbk">
                //Match charSetMatch = Regex.Match(strWebData, "<meta([^>]*)charset=(\")?(.*)?\"", RegexOptions.IgnoreCase | RegexOptions.Multiline);
                Match charSetMatch = Regex.Match(strWebData, "(.*)charset=(\")?(.*)?\"", RegexOptions.IgnoreCase | RegexOptions.Multiline);

                string webCharSet = charSetMatch.Groups[3].Value.Trim().ToLower();

                if (webCharSet != "gb2312" && webCharSet != "gbk")
                {
                    webCharSet = "utf-8";
                }

                if (System.Text.Encoding.GetEncoding(webCharSet) != System.Text.Encoding.Default)
                {
                    strWebData = System.Text.Encoding.GetEncoding(webCharSet).GetString(myDataBuffer);
                }



                //if (codingType == 1)
                //    return Encoding.Unicode.GetString(myDataBuffer);
                //else if (codingType == 2)
                //    return Encoding.Default.GetString(myDataBuffer);//GBK 936
                //else if (codingType == 3)
                //    return Encoding.UTF8.GetString(myDataBuffer);//65501

                return strWebData;

            }
            catch (Exception ex)
            {
                //Console.WriteLine(url + " " + ex.Message);
                return "<hTmlKErRor>" + ex.Message;
            }

            return "";
        }

    }
}
