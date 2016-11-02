<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DashBoard.aspx.cs" Inherits="DashBoard" %>

<%@ Reference Control="~/HeaderControl.ascx" %>
<%@ Register TagPrefix="HC" TagName="HeaderControl" Src="~/HeaderControl.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <script src="Lib/jquery.min.js"></script>
    <script src="Scripts/fullcalendar.min.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
        google.load("visualization", "1", { packages: ["corechart"] });
        google.setOnLoadCallback(drawChart);
        function drawChart() {
            var options = {
                title: 'Team Grouping',
                is3D: true,
                width: 800,
            };
            $.ajax({
                type: "POST",
                url: "Dashboard.aspx/GetChartData",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    var data = google.visualization.arrayToDataTable(r.d);
                    var chart = new google.visualization.PieChart($("#chart")[0]);
                    chart.draw(data, options);
                },
                failure: function (r) {
                },
                error: function (r) {
                }
            });
        }
    </script>
    <script type="text/javascript">
        function initialize() {
            drawChart();
        };
    </script>

    <script>
        var chartData; // global variable for hold chart data
        google.load("visualization", "1", { packages: ["corechart"] });
        // Here We will fill chartData
        $(document).ready(function () {

            $.ajax({
                url: "Dashboard.aspx/GetBarChartData",
                data: "",
                dataType: "json",
                type: "POST",
                contentType: "application/json; chartset=utf-8",
                success: function (data) {
                    chartData = data.d;
                },
                error: function () {
                }
            }).done(function () {
                // after complete loading data
                google.setOnLoadCallback(drawChart);
                drawChart();
            });
        });
        function drawChart() {
            var data = google.visualization.arrayToDataTable(chartData);

            var options = {
                title: "Quartely Report",
                pointSize: 7,

            };

            var barChart = new google.visualization.ColumnChart(document.getElementById('bargraph'));
            barChart.draw(data, options);

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

                <div>
                    <div>
                        <table width="99%" border="0" cellpadding="0" cellspacing="0" align="center">
                            <tr>
                                <td class="td_control">
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
                                                    <asp:Label ID="lblhide" runat="server" Visible="false"></asp:Label>
                                                </td>
                                                <td align="left" style="width: 50%">Associate ID : 
                                             &nbsp;<asp:DropDownList ID="ddlAssociate" Width="150px" runat="server" CssClass="dropdown">
                                             </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center" colspan="3">
                                                    <asp:LinkButton ID="btnFilter" runat="server" CssClass="PopupButton" OnClick="btnFilter_Click" OnClientClick="initialize();"><i class="fa fa-filter fa-1a5x"></i>&nbsp;&nbsp;Filter</asp:LinkButton>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <table width="100%">
                    <tr>
                        <td>
                            <div id="chart" style="width: 500px; height: 500px;">
                            </div>
                        </td>
                        <td width="5%"></td>
                        <td>
                            <div id="bargraph" style="width: 500px; height: 500px;">
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
