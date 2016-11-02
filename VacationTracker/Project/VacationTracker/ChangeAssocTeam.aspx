<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangeAssocTeam.aspx.cs" Inherits="ChangeAssocTeam" %>

<%@ Reference Control="~/HeaderControl.ascx" %>
<%@ Register TagPrefix="HC" TagName="HeaderControl" Src="~/HeaderControl.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <script src="Lib/jquery.min.js"></script>
    <script src="Scripts/fullcalendar.min.js"></script>
     <link href="CSS/font-awesome.css" rel="stylesheet" />
    <link href="CSS/PageStyles.css" rel="stylesheet" />
    <link href="CSS/style.css" rel="stylesheet" />
    <link href="CSS/LoginStyles.css" rel="stylesheet" />
    <script>
         function Close() {
             self.parent.document.forms[0].submit();
         }
    </script> 
</head>
<body>
    <form id="form1" runat="server">
       <div style="width:100%;">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr style="margin: 3px; width:98%;height:30px; background-color: #333333">
                <td style="width:8%" align="center">&nbsp;
                   <i class="IconColorLight fa fa-user fa-3x"></i>
                </td>
                <td style="width:90%; color: #FFFFFF; font-size: large; font-family: Calibri; font-weight: bold;" 
                    align="center">
                   Change Associate Team
                </td>
                <td style="width:3%" align="center">
                    
                </td>
            </tr>
            <tr>
                <td colspan="3" align="center">
                    <table style="width:90%" >
                        <tr style="height:15px">
                            <td ></td>
                        </tr>
                        <tr class="td_label" align="center">
                                
                            <td align="center">
                                &nbsp;Assign Team&nbsp;&nbsp;&nbsp;&nbsp; 
                                <asp:DropDownList ID="ddlTeam" runat="server" CssClass="dropdown" Width="50%">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr style="height:10px;">
                            <td></td>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:LinkButton ID="btnAssign" runat="server" Text="Assign" CssClass="PopupButton" onclick="btnAssign_Click"><i class="fa fa-user fa-1a5x"></i>&nbsp;&nbsp;Assign</asp:LinkButton>&nbsp;
                                <%--<input type="button" id="btnCancel" onclick="parent.$fb.fancybox.close();" value="Cancel" class="PopupButton" style="width:70px;"/>--%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
