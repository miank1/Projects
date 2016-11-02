<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VacationPlanner.aspx.cs" Inherits="VacationPlanner" %>

<%@ Reference Control="~/HeaderControl.ascx" %>
<%@ Register TagPrefix="HC" TagName="HeaderControl" Src="~/HeaderControl.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <link href="CSS/fullcalendar.css" rel="stylesheet" />

    <script src="Lib/jquery-1.4.3.min.js"></script>
    <script type="text/javascript"> $fb = jQuery.noConflict();</script>
    <script src="Scripts/jquery.fancybox-1.3.4.pack.js"></script>
    <script src="Lib/jquery.min.js"></script>
    <script src="Lib/moment.min.js"></script>
    <script src="Scripts/fullcalendar.min.js"></script>
    <script>
        var startDate;
        var endDate;
        $(document).ready(function () {
            $.ajax({
                type: "POST",
                url: "VacationPlanner.aspx/LoadHolidays",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    showCalendar(response);
                },
            });
           
        });

        function showCalendar(response) {
            clearError();
            $('#calendar').fullCalendar({
                header: {
                    WeekMode: 'liquid',
                    weekends: false,
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month'
                },
                eventDurationEditable: false,
                eventStartEditable: false,
                height: 550,
                navLinks: true,
                selectable: true,
                editable: true,
                events: $.map(response.d, function (item, i) {
                    var event = new Object();
                    event.id = item.Id;
                    event.start = new Date(item.startDate);
                    event.end = new Date(item.EndDate);
                    event.title = item.Occasion;
                    event.allDay = true;
                    event.color = "#F59535";
                    return event;
                }),
                select: function (start, end, callback) {
                    if (Math.round(Math.abs((end) - (start)) / 8.64e7) > 1) {
                        return;
                    }
                    startDate = start;
                    endDate = end;
                    openDialog("", "");
                },
                eventRender: function (event, element) {
                        element.append("<span class='closeon'><i class='fa fa-times fa-1a5x'></i></span>");
                        element.find(".closeon").click(function () {
                            RemoveEvents(event.id);
                        })
                        element.bind('dblclick', function () {
                        openDialog(event.title, event.id);
                    });
                },
                dayRender: function (date, cell) {
                    var date = new Date(date);
                    var n = date.getDay();
                    if (n == 6 || n == 0) {
                        $(cell).css('background-color', '#DCDCDC');
                    }
                }
            });
        }

        function openDialog(Ocassion, ID) {
            clearError();
            document.getElementById('txtOcassion').value = Ocassion;
            document.getElementById('hdnID').value = ID;
            if (Ocassion != "")
                document.getElementById('hdnAction').value = 'E';
            else
                document.getElementById('hdnAction').value = 'A';

            $fb(document).ready(function () {
                $fb.fancybox({
                    'padding': '4',
                    'width': 650 + 'px',
                    'height': 50 + '%',
                    'autoScale': false,
                    'overlayOpacity': .7,
                    'transitionIn': 'none',
                    'transitionOut': 'none',
                    'overlayColor': '#000000',
                    'href': '#dialog',
                    'hideOnOverlayClick': false,
                    'hideOnContentClick': false,
                    'enableEscapeButton': false
                });
            });
        }

        function closeFancybox() {
            var vOcassion = document.getElementById('txtOcassion').value;
            if (vOcassion == "") {
                $('#trWarning').css({ 'display': '' });
                document.getElementById("lblWarning").innerHTML = "";
                document.getElementById("lblWarningValue").innerHTML = "*Ocaasion name should not be left blank";
                return;
            }
             

            if (document.getElementById('hdnAction').value == 'A') {
                $.ajax({
                    type: "POST",
                    url: "VacationPlanner.aspx/AddHolidays",
                    data: '{startDate: "' + startDate + '", endDate: "' + endDate + '",ocassion: "' + vOcassion + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var eventsList = [];
                        $.map(response.d, function (item, i) {
                            if (item.Error == "Duplicate") {
                                document.getElementById("lblError").innerHTML = "Holiday cannot applied twice on the same day";
                                return;
                            }
                            var eventsList = [];
                            eventsList.push({
                                id: item.Id,
                                start: new Date(item.startDate),
                                end: new Date(item.EndDate),
                                title: item.Occasion,
                                //color: '#F59535',
                                allDay: true
                            });
                            
                            $('#calendar').fullCalendar('addEventSource', eventsList);
                        });
                    },
                    failure: function (response) {
                    }
                });
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "VacationPlanner.aspx/UpdateHoliday",
                    data: '{Ocassion: "' + vOcassion + '",  ID: ' + document.getElementById('hdnID').value + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var eventsList = [];
                        $.map(response.d, function (item, i) {
                            eventsList.push({
                                id: item.Id,
                                start: new Date(item.startDate),
                                end: new Date(item.EndDate),
                                title: item.Occasion,
                                allDay: true
                                //color: '#F59535'
                            });
                        });
                        $('#calendar').fullCalendar('removeEvents', document.getElementById('hdnID').value);
                        $('#calendar').fullCalendar('addEventSource', eventsList);
                        document.getElementById('hdnID').value = "";
                    },
                    failure: function (response) {
                    }
                });

            }
            $fb.fancybox.close();
        }

        function RemoveEvents(id) {
            if (confirm("Are you sure to delete ?")) {
                $.ajax({
                    type: "POST",
                    url: "VacationPlanner.aspx/RemoveHolidays",
                    data: '{ID: ' + id + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        $('#calendar').fullCalendar('removeEvents', id);
                    },
                });
            }
        }
        
        function clearError() {
            document.getElementById("lblError").innerHTML = ""
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="DivHeader">
            <HC:HeaderControl ID="ucHdrCtr" runat="server" />
        </div>
        <div id="divBody" class="SectionGroup">
            <div id="stickyheader" class="DivOuterx1" style="min-height: 600px">
                <div class="Div_FilterOuterStyle" style="min-height: 600px">
                    <table style="width: 100%;" cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="width:20%"></td>
                            <td style="text-align:right;color:red"> <asp:Label ID="lblError" runat="server">
                                </td>
                            <td style="width:40%;color:black; text-align:right">
                               <b> <asp:Label ID="lblVacation" runat="server" Text="#.of Holidays : 0 "></asp:Label></b>
                            </td>
                        </tr>
                        <tr align="center" style="width: 100%;">
                            <td align="center" colspan="3">
                                <div id="calendar" runat="server">
                                </div>
                            </td>
                        </tr>
                    </table>
                    <br />
                    </asp:Label>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td style="width:48%">
                                 <span style="height: 8px; color: #F59535" class="fa fa-square">
                                    Holidays
                                </span>
                            </td>
                            <td align="left">
                                <asp:LinkButton ID="lnkbtnSubmit" runat="server" Text="Submit" OnClick="lnkbtnSubmit_Click" CssClass="PopupButton"><i class="fa fa-floppy-o fa-1a5x"></i>&nbsp;&nbsp;Submit</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div>
        </div>
        <div style="display: none">
            <div id="dialog" style="border: 3px solid #999999; width: 450px; height: 150px;">
                <div align="right" style="width: 98%; height: 25px;" class="PopupButton PageHeader">
                    <table width="100%">
                        <tr>
                            <td class="" style="text-align: center; margin-left: 5px; font-weight: bold; font-size: 15px; color: White">Ocassion Details
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="sub_control">
                    <table width="100%">
                        <tr>
                            <td align="left" style="color: #FF0000; font-weight: bold" width="2%">*</td>
                            <td style="text-align: left; color: black" width="27%">Ocassion Name :
                            </td>
                            
                            <td>
                                <asp:TextBox runat="server" ID="txtOcassion" CssClass="td_control" Width="90%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr id="trWarning" style="display:none;height:10px">
                            <td style="text-align: left; color: red" colspan ="2">
                                <asp:Label ID="lblWarning" runat="server" Text=""></asp:Label>
                            </td>
                            <td style="text-align: left; color: red">
                                <asp:Label ID="lblWarningValue" Width="90%" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
                <div align="center" style="margin-bottom: 5px;">
                    <%--     <input id="igtbl_reOkBtn" class="PopupButton" runat="server"  style="width:50px;" onclick="udgTooltip_UpdateCell"
                                                                                        type="button" value="Save">&nbsp;--%>
                    <%--<asp:LinkButton runat="server" CssClass="PopupButton" Text="Save" ID="btnsave" OnClientClick="closeFancybox();"><i class="fa fa-floppy-o fa-1a5x"></i>&nbsp;&nbsp;Save</asp:LinkButton>--%>&nbsp;
                          <input id="btnSave" style="width: 50px;" class="PopupButton" onclick="closeFancybox();"
                              type="button" value="Save">
                </div>
            </div>
        </div>
        <input type="hidden" value="A" id="hdnAction" />
        <input type="hidden" value="" id="hdnID" />
    </form>
</body>
</html>
