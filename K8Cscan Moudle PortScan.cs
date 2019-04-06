using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Text.RegularExpressions;
using System.Net.Sockets;
//Cscan 3.1 PortScan Moudle
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
                if (K8CheckPort(ip, 21))
                    Console.Write(ip + "\t21 Open\r\n");
                if (K8CheckPort(ip, 80))
                    Console.Write(ip + "\t80 Open\r\n");
                if (K8CheckPort(ip, 1433))
                    Console.Write(ip + "\t1433 Open\r\n");
                if (K8CheckPort(ip, 3306))
                    Console.Write(ip + "\t3306 Open\r\n");
                if (K8CheckPort(ip, 1521))
                    Console.Write(ip + "\t1521 Open\r\n");
                if (K8CheckPort(ip, 3389))
                    Console.Write(ip + "\t3389 Open\r\n");
            }

            return "";
        }

        private static bool K8CheckPort(string ip, int Port)
        {
            //int Port = 21;
            IPAddress scanip = IPAddress.Parse(ip);
            IPEndPoint point = new IPEndPoint(scanip, Port);
            try
            {
                TcpClient tcp = new TcpClient();
                tcp.Connect(point);
                //Console.WriteLine(scanip + "\t" + Port + "\tOpen");
                return true;
            }
            catch (Exception ex)
            {
                //Console.WriteLine(scanip + "\t" + Port + "\tClose");
                return false;
            }
        }

    }
}
