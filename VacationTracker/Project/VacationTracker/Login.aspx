<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<%@ Reference Control="~/HeaderControl.ascx" %>
<%@ Register TagPrefix="HC" TagName="HeaderControl" Src="~/HeaderControl.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <script src="Lib/jquery.min.js"></script>
    <link href="CSS/font-awesome.css" rel="stylesheet" />
    <link href="CSS/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="CSS/Styles.css" rel="stylesheet" />
    <script>
    </script>
</head>
<body style="background-color: white; background-repeat: repeat;">
    <form id="form1" runat="server" defaultbutton="btnSubmit">
        <div id="stickyMainheader" style="width: 100%; margin: 0px auto; text-align: center">
            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; padding: 0px; margin: 0px;"
                id="tblMainHeader" runat="server">
                <tr class="PageHeader" style="background-color: #389BEF; height: 60px">
                    <td align="left" style="padding-left: 20px; width: 20px; padding-right: 0px;">
                        <%--<i class="fa fa-calendar fa-5x" style="color: #FFFFFF"></i>--%>
                    </td>
                    <td width="11%" style="padding-left:4px;padding-top:3px">
                     <img src="images/CernerLogo.png" height="150px"/>
                     </td>
                    <td align="left" style="padding-left: -50px; width: 300px;"></td>
                    <td width="50%" align="center">
                        <asp:Label ID="lblHeading" runat="server" CssClass="PageHeaderText" Text="Vacation Tracker"></asp:Label>
                    </td>
                    <td width="25%" align="right" class="td_padding" style="color: #FFFFFF; padding-right: 20px; font-size: 15px;"></td>
                </tr>
            </table>
        </div>
        <div style="width: 500px;" class="SectionGroup">
            <div class="SectionHeader">
                USER LOGIN
            </div>
            <div class="SectionContent" style="height: 200px;">
                <table style="width: 100%; margin-top: 0px; height: 95%;">
                    <tr>
                        <td align="right">
                            <label style="font: 12pt; font-size: 18px; cursor: text">
                                User Name</label>
                        </td>
                        <td align="center">
                            <asp:TextBox ID="txtUserName" runat="server" CssClass="textbox"></asp:TextBox>
                    </tr>
                    <tr>
                        <td align="right">
                            <label style="font: 12pt; font-size: 18px; cursor: text">
                                Password</label>
                        </td>
                        <td align="center">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="textbox" TextMode="Password"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            <label style="font: 12pt; font-size: 18px; cursor: text">
                                Role</label>
                        </td>
                        <td align="center">
                            <asp:DropDownList ID="ddlRole" runat="server" class="dropdown" Width="220px">
                                <asp:ListItem>Associate</asp:ListItem>
                                <asp:ListItem>Manager</asp:ListItem>
                                <asp:ListItem>Administrator</asp:ListItem>
                        </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:LinkButton ID="btnSubmit" runat="server" CssClass="DefaultButton fa fa-arrow-circle-right fa-2x" Text="   Submit" Width="125px"
                                ForeColor="White" Height="30px" Style="padding-left: 1%; padding-top: 4px; text-decoration: solid;" OnClick="btnSubmit_Click">
                            </asp:LinkButton>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <div id="divMessage"  runat="server" style="height: 15px; line-height: 15px">
                                <asp:Label ID="lblError" runat="server"  CssClass="Errorlabel" Style="vertical-align: bottom;color:red;">Invalid Login information please try again.</asp:Label>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
