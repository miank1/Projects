<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ManagerReports.aspx.cs" Inherits="ManagerReports" %>

<%@ Reference Control="~/HeaderControl.ascx" %>
<%@ Register TagPrefix="HC" TagName="HeaderControl" Src="~/HeaderControl.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <script src="Lib/jquery.min.js"></script>
    <script src="Scripts/jquery-1.7.2.min.js"></script>
    <script src="Scripts/jquery-ui-1.8.19.custom.min.js"></script>
    <link href="CSS/jquery-ui.css" rel="stylesheet" />
    <script>
        $(function () {
            $("#CalFrom").datepicker({ dateFormat: 'dd-M-yy' });
            $("#CalTo").datepicker({ dateFormat: 'dd-M-yy' });

            $("#sCalFrom").click(function () {
                $("#CalFrom").focus();
            });
            $("#sCalTo").click(function () {
                $("#CalTo").focus();
            });
        });

        

        function ValidateField() {
            var dateformat = /^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]|(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2]|(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)(?:0?2|(?:Feb))\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9]|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:1[0-2]|(?:Oct|Nov|Dec)))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/;
            if (document.getElementById("CalTo").value != "" && !$('#CalFrom').val().match(dateformat)) {
                document.getElementById("lblError").innerHTML = "Invalid From Date";
                return false;
            }
            if (document.getElementById("CalFrom").value != "" && !$('#CalTo').val().match(dateformat)) {
                document.getElementById("lblError").innerHTML = "Invalid To Date";
                return false;
            }
            return true;
        }
    </script>
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
                                        <td align="left" style="width: 25%">Associate Name : 
                                             &nbsp;<asp:DropDownList ID="ddlAssociate" Width="150px" runat="server" CssClass="dropdown">
                                             </asp:DropDownList>
                                        </td>
                                        <td align="center" style="width: 25%">From Date :
                                            <asp:TextBox ID="CalFrom" class="textbox" runat="server" Width="150px"></asp:TextBox>
                                             <span id="sCalFrom" class="fa fa-calendar"></span>
                                        </td>
                                        <td align="center" style="width: 25%">To Date :
                                            <asp:TextBox ID="CalTo" class="textbox" runat="server" Width="150px"></asp:TextBox>
                                            <span id="sCalTo" class="fa fa-calendar"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: center; color: red" colspan="4">
                                            <asp:Label ID="lblError" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr style="height: 10px"></tr>
                                    <tr>
                                        <td align="center" colspan="4">
                                            <asp:LinkButton ID="btnFilter" runat="server" CssClass="PopupButton" OnClientClick="return ValidateField();" OnClick="btnFilter_Click"><i class="fa fa-filter fa-1a5x"></i>&nbsp;&nbsp;Filter</asp:LinkButton>
                                            <asp:LinkButton ID="lnkbtnClear" runat="server" Text="clear" OnClick="lnkbtnClear_Click" CssClass="PopupButton"><i class="fa fa-times fa-1a5x"></i>&nbsp;&nbsp;Clear</asp:LinkButton>
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
                        <td style="width: 40%; color: black; text-align: right">
                            <b>
                                <asp:Label ID="lblRecordsCount" Visible="false" runat="server" Text="#.of records :  "></asp:Label></b>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <div class="GridviewDiv">

                                <asp:GridView runat="server" ID="gvquaterlyReport" AllowPaging="false" PageSize="10" AutoGenerateColumns="false" Width="99%" CssClass="nativegrid" style="margin-left:14px">
                                    <HeaderStyle CssClass="headerstyle" />
                                    <Columns>
                                        <asp:BoundField DataField="Name" HeaderText="Associate Name" />
                                        <asp:BoundField DataField="FROM_DATE" HeaderText="Start Date" />
                                        <asp:BoundField DataField="TO_DATE" HeaderText="End Date" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
