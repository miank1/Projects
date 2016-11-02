<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TeamPlanner.aspx.cs" Inherits="TeamPlanner" %>

<%@ Reference Control="~/HeaderControl.ascx" %>
<%@ Register TagPrefix="HC" TagName="HeaderControl" Src="~/HeaderControl.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <%--<link href="CSS/fullcalendar.css" rel="stylesheet" />

    <script src="Lib/jquery-1.4.3.min.js"></script>
    <script type="text/javascript"> $fb = jQuery.noConflict();</script>
    <script src="Scripts/jquery.fancybox-1.3.4.pack.js"></script>--%>
    <script src="Lib/jquery.min.js"></script>
    <%-- <script src="Lib/moment.min.js"></script>
    <script src="Scripts/fullcalendar.min.js"></script>--%>
    <script>
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="DivHeader">
            <HC:HeaderControl ID="ucHdrCtr" runat="server" />
        </div>
        <div id="divBody" class="SectionGroup">
            <div id="stickyheader" class="DivOuterx1">
                <div class="Div_FilterOuterStyle" style="min-height: 600px">
                    <table style="width: 100%;" cellpadding="0" cellspacing="0">
                        <tr align="center" style="width: 100%;">
                            <td align="center">
                                <div class="form-group">
                                    <asp:Label ID="lbl_TeamName" runat="server">Team Name</asp:Label>
                                    <asp:TextBox ID="txt_TeamName" runat="server" placeholder="TeamName" CssClass="form-control"></asp:TextBox>
                                    <asp:Button ID="btn_Add" CssClass="btn btn-default" runat="server" OnClientClick="enable()" BackColor="#00cc00" Text="Add" />
                                    <asp:Button ID="btn_View" CssClass="btn btn-default" runat="server" BackColor="#3399ff" Text="View" />
                                </div>
                                <div class="form-group">
                                    <asp:Label ID="lbl_Holidays" runat="server">Holidays Assigned</asp:Label>
                                    <asp:TextBox ID="txt_Holidays" runat="server" CssClass="form-control" placeholder="No of Holidays"></asp:TextBox>
                                </div>
                                <div class="form-group">
                                    <div class="checkbox">
                                        <asp:CheckBoxList ID="chk_AssociateList" runat="server" AutoPostBack="true" RepeatColumns="0" RepeatLayout="OrderedList">
                                        </asp:CheckBoxList>
                                        <asp:CheckBoxList ID="CheckBoxList1" runat="server" AutoPostBack="true" RepeatColumns="0" RepeatLayout="OrderedList">
                                        </asp:CheckBoxList>
                                    </div>
                                    <div class="checkbox">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <asp:Button ID="btn_Save" runat="server" Text="Save" OnClick="btn_Save_Click" />
                                </div>
                                <div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
