<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Reports.aspx.cs" Inherits="Reports" %>

<%@ Reference Control="~/HeaderControl.ascx" %>
<%@ Register TagPrefix="HC" TagName="HeaderControl" Src="~/HeaderControl.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <script src="Lib/jquery.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="DivHeader">
            <HC:HeaderControl ID="ucHdrCtr" runat="server" />
        </div>
        <div id="Div1" class="SectionGroup">
            <div class="Div_FilterOuterStyle">
                <table width="99%" border="0" cellpadding="0" cellspacing="0" align="center">
                    <tr>
                        <td class="td_control" colspan="3">
                            <div class="Div_OuterLayer" style="border-top: 0px; border-top-style: none;">
                                <div id="div2" class="PanelHeader" style="margin: 5px 0px 0px -1px;">
                                    <table style="width: 100%; height: 93%;" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="PanelHeaderText" style="width: 100%; text-align: left; padding-top: 0px;"
                                                valign="middle">
                                                <asp:Label ID="Label2" runat="server" Text="Filter Report"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <br />
                                <table border="0" cellpadding="0" cellspacing="0" width="95%">
                                    <tr align="center" style="width: 100%;">
                                        <td align="left" style="width: 10%"></td>
                                        <td align="center" style="width: 50%">Year : 
                                             &nbsp;<asp:DropDownList ID="ddlYear" Width="150px" runat="server" CssClass="dropdown">
                                             </asp:DropDownList>
                                        </td>
                                        <td align="left" style="width: 50%">Associate ID : 
                                             &nbsp;<asp:DropDownList ID="ddlAssociate" Width="150px" runat="server" CssClass="dropdown">
                                             </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr style="height: 10px"></tr>
                                    <tr>
                                        <td align="center" colspan="3">
                                            <asp:LinkButton ID="btnFilter" runat="server" CssClass="PopupButton" OnClick="btnFilter_Click"><i class="fa fa-filter fa-1a5x"></i>&nbsp;&nbsp;Filter</asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
                <br />
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td style="width: 40%; color: black; text-align: right; padding-right:9px">
                            <b>
                                <asp:Label ID="lblPTO" runat="server" Visible="false" Text="Vacation Balance :  "></asp:Label></b>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <div class="GridviewDiv">

                                <asp:GridView runat="server" ID="gvquaterlyReport" AllowPaging="false" PageSize="10" AutoGenerateColumns="false" Width="99%" CssClass="nativegrid">
                                    <HeaderStyle CssClass="headerstyle" />
                                    <Columns>
                                        <asp:BoundField DataField="quater" HeaderText="Quater" />
                                        <asp:BoundField DataField="startDate" HeaderText="Start Date" />
                                        <asp:BoundField DataField="endDate" HeaderText="End Date" />
                                        <asp:BoundField DataField="workingDays" HeaderText="Working Days" />
                                        <asp:BoundField DataField="vacations" HeaderText="Vacations" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                               <span id="spPTO" runat="server" visible="false" style="color:red;font-size:9pt;font-weight:bold">&nbsp;&nbsp;PTO Balance in red color indicates leaves are eligible for carry forward.</span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
