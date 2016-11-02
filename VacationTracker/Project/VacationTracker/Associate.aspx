<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Associate.aspx.cs" Inherits="Associate" %>

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
    <script src="Scripts/push_notification.js"></script>
    <script>
        var startDate;
        var endDate;
        var Approved = "N";
        $(document).ready(function () {
            $.ajax({
                type: "POST",
                url: "Associate.aspx/LoadVacations",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    showCalendar(response);
                },
            });
            LoadNotifications();
        });

        
        function fnNotify(item) {
            $.notify("Notifications", {
                icon: "images/Calendar.JPG",
                title: "Leave Status",
                body: item
            });
        }
        function LoadNotifications() {
            $.ajax({
                type: "POST",
                url: "Associate.aspx/LoadNotifications",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $.each(response.d, function (index, item) {
                        setTimeout(function () {   //calls click event after a certain time
                            fnNotify(item);
                        }, 100);
                    });
                },
            });
        }

        function showCalendar(response) {
            clearError();
            var vacList = [];
            var mEventList = [];
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
                height: 530,
                navLinks: true,
                selectable: true,
                editable: true,
                events: $.map(response.d, function (item, i) {
                    var bExits = false;
                    if (vacList.length > 0) {
                        vacList.filter(function (e) {
                            bExits = (e.title == item.Title && String(e.start) == String(new Date(item.mFromDate)) && String(e.end) == String(new Date(item.mToDate)));
                        });
                    }
                    if (!bExits) {
                        var event = new Object();
                        event.id = item.ID;
                        event.start = new Date(item.mFromDate);
                        event.end = new Date(item.mToDate);
                        event.title = item.Title;
                        event.allDay = true;
                        event.Approved = item.Approved;
                        event.Holiday = false;
                        if (item.Approved == "Y") {
                            event.color = "#5fba7d";
                        }
                        if (item.Approved == "P" || item.Approved == "F" || item.Approved == "R") {
                            event.color = "#B33A3A";
                        }
                        event.Reason = item.Reason;
                        event.Comments = item.Comments;
                        event.AssocView = item.AssocView;
                        var start = new Date(item.mFromDate);
                        var end = new Date(item.mToDate);
                        var diffDays = Math.round(Math.abs((end.getTime() - start.getTime()) / (24 * 60 * 60 * 1000)));
                        if (diffDays > 1) {
                            mEventList.push({
                                Date: item.FromDate,
                                Class: (item.Approved == "Y") ? 'Approved' : (item.Approved == "N") ? '' : 'Rejected'
                            });
                            if (item.Approved != "N")
                                event.color = "#800080";
                        }
                        vacList.push(event);
                        return event;
                    }
                    else {
                        mEventList.push({
                            Date: item.FromDate,
                            Class: (item.Approved == "Y") ? 'Approved' : (item.Approved == "N") ? '' : 'Rejected'
                        });
                    }
                }),
                select: function (start, end, callback) {
                    startDate = start;
                    endDate = end;
                    var date = new Date(start);
                    var n = date.getDay();
                    if (n == 6 || n == 0) {
                        return;
                    }
                    openDialog("", "");
                },
                eventRender: function (event, element) {
                    if (event.Approved == 'N' && event.AssocView == 'Y') {
                        element.append("<span class='closeon'><i class='fa fa-times fa-1a5x'></i></span>");
                        element.find(".closeon").click(function () {
                            RemoveEvents(event.id);
                        })
                    }
                    if (event.AssocView == 'Y') {
                        element.bind('dblclick', function () {
                            if (event.Approved != "N")
                                Approved = event.Approved;
                            openDialog(event.title, event.Reason, event.id, event.Approved, event.holiday, event.Comments);
                        });
                    }
                    if (mEventList.length > 0) {
                        for (var iEvent = 0; iEvent < mEventList.length; iEvent++) {
                            $('.fc-day[data-date="' + mEventList[iEvent].Date + '"]').addClass(mEventList[iEvent].Class);
                        }
                    }
                },
                dayRender: function (date, cell) {
                    var date = new Date(date);
                    var n = date.getDay();
                    if (n == 6 || n == 0) {
                        $(cell).css('background-color', '#DCDCDC');
                        $(cell).attr('cursor', 'disabled');
                    }
                }
            });
            LoadHolidays();
        }

        function LoadHolidays() {
            $.ajax({
                type: "POST",
                url: "Associate.aspx/AddHolidays",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $.map(response.d, function (item, i) {
                        var eventsList = [];
                        eventsList.push({
                            start: new Date(item.startDate),
                            end: new Date(item.EndDate),
                            title: item.Occasion,
                            holiday: true,
                            color: '#F59535',
                            allDay: true,
                        });
                        $('#calendar').fullCalendar('addEventSource', eventsList);
                    });
                },
                failure: function (response) {
                }
            });
        }

        function openDialog(Title, Reason, ID, Approved, Holiday, Comments) {
            clearError();
            if (Holiday)
                return;
            document.getElementById('txtTitle').value = Title;
            document.getElementById('txtReason').value = Reason;
            document.getElementById('hdnID').value = ID;
            if (Title != "" && Reason != "")
                document.getElementById('hdnAction').value = 'E';
            else
                document.getElementById('hdnAction').value = 'A';

            if (Approved == "P" || Approved == "F" || Approved == "Y" || Approved == "R") {
                $('#trWarning').css({ 'display': '' });
                document.getElementById("lblWarning").innerHTML = "Rejected Reason :";
                if (Approved == "P") {
                    document.getElementById("lblWarningValue").innerHTML = "Less PTO Balance";
                    $("#txtTitle").removeAttr('disabled', 'disabled');
                    $("#txtReason").removeAttr('disabled', 'disabled');
                    document.getElementById("txtComments").innerHTML = "";
                    $("#trComments").hide();
                    $("#btnSave").show();
                    $("#dialog").height("225px");
                }
                if (Approved == "F") {
                    document.getElementById("lblWarningValue").innerHTML = "Too Frequent";
                    $("#txtTitle").removeAttr('disabled', 'disabled');
                    $("#txtReason").removeAttr('disabled', 'disabled');
                    document.getElementById("txtComments").innerHTML = "";
                    $("#trComments").hide();
                    $("#btnSave").show();
                    $("#dialog").height("225px");
                }
                if (Approved == "R") {
                    $('#trWarning').css({ 'display': 'none' });
                    $("#txtTitle").attr('disabled', 'disabled');
                    $("#txtReason").attr('disabled', 'disabled');
                    document.getElementById("txtComments").innerHTML = Comments;
                    $("#trComments").show();
                    $("#btnSave").hide();
                    $("#dialog").height("325px");
                }
                if (Approved == "Y") {
                    $('#trWarning').css({ 'display': 'none' });
                    $("#txtTitle").attr('disabled', 'disabled');
                    $("#txtReason").attr('disabled', 'disabled');
                    document.getElementById("txtComments").innerHTML = "";
                    $("#trComments").hide();
                    $("#btnSave").hide();
                    $("#dialog").height("225px");
                }
            }
            else {
                $('#trWarning').css({ 'display': 'none' });
                $("#txtTitle").removeAttr('disabled', 'disabled');
                $("#txtReason").removeAttr('disabled', 'disabled');
                document.getElementById("txtComments").innerHTML = "";
                $("#trComments").hide();
                $("#btnSave").show();
                $("#dialog").height("225px");
            }

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
            var vTitle = document.getElementById('txtTitle').value;
            var vReason = document.getElementById('txtReason').value;
            if (vTitle == "" || vReason == "") {
                $('#trWarning').css({ 'display': '' });
                document.getElementById("lblWarning").innerHTML = "";
                document.getElementById("lblWarningValue").innerHTML = "*Title and Reason should not be left blank";
                return;
            }

            if (document.getElementById('hdnAction').value == 'A') {
                $.ajax({
                    type: "POST",
                    url: "Associate.aspx/AddVacation",
                    data: '{Title: "' + vTitle + '", Reason: "' + vReason + '",  startDate: "' + startDate + '", endDate: "' + endDate + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var eventsList = [];
                        $.map(response.d, function (item, i) {
                            if (item.Error == "Duplicate") {
                                document.getElementById("lblError").innerHTML = "Vacation cannot applied twice on the same day";
                                return;
                            }
                            if (item.Error == "Holiday") {
                                document.getElementById("lblError").innerHTML = "Vacation cannot applied on holidays";
                                return;
                            }
                            eventsList.push({
                                id: item.ID,
                                start: new Date(item.mFromDate),
                                end: new Date(item.mToDate),
                                title: item.Title,
                                allDay: true,
                                Approved: item.Approved,
                                Reason: item.Reason,
                                Comments: item.Comments,
                                holiday: false,
                                AssocView: item.AssocView
                            });
                        });
                        $('#calendar').fullCalendar('addEventSource', eventsList);
                    },
                    failure: function (response) {
                    }
                });
            }
            else {
                $.ajax({
                    type: "POST",
                    url: "Associate.aspx/UpdateVacation",
                    data: '{Title: "' + vTitle + '", Reason: "' + vReason + '",  ID: ' + document.getElementById('hdnID').value + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var eventsList = [];
                        $.map(response.d, function (item, i) {
                            eventsList.push({
                                id: item.ID,
                                start: new Date(item.mFromDate),
                                end: new Date(item.mToDate),
                                title: item.Title,
                                allDay: true,
                                Approved: item.Approved,
                                Reason: item.Reason,
                                Comments: item.Comments,
                                holiday: false,
                                color: (Approved != "N") ? '#B33A3A' : "",
                                AssocView: item.AssocView
                            });
                        });
                        $('#calendar').fullCalendar('removeEvents', document.getElementById('hdnID').value);
                        $('#calendar').fullCalendar('addEventSource', eventsList);
                        document.getElementById('hdnID').value = "";
                        Approved = "N";
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
                    url: "Associate.aspx/Removevacation",
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
    <style>
        .Rejected {
            box-shadow: inset 0 0 10px Red;
        }

        .Approved {
            box-shadow: inset 0 0 10px Green;
        }

        .Pending {
            box-shadow: inset 0 0 10px #3a87ad;
        }
    </style>
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
                        <tr>
                            <td style="width: 20%"></td>
                            <td style="text-align: right; color: red">
                                <asp:Label ID="lblError" runat="server">
                            </td>
                            <td style="width: 40%; color: black; text-align: right">
                                <b>
                                    <asp:Label ID="lblPTO" runat="server" Text="PTO Balance :  "></asp:Label></b>
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
                            <td style="width: 48%">
                                <span style="height: 8px; color: #3a87ad" class="fa fa-square">
                                    Pending
                                </span>
                                <span style="height: 8px; color: #5fba7d" class="fa fa-square">
                                    Approved
                                </span>
                                <span style="height: 8px; color: #B33A3A" class="fa fa-square">
                                    Rejected
                                </span>
                                <span style="height: 8px; color: #800080" class="fa fa-square">
                                    Multiple
                                </span>
                                <span style="height: 8px; color: #F59535" class="fa fa-square">
                                    Holidays
                                </span>
                                <br />
                                <span id="spPTO" runat="server" style="color: red; font-size: 9pt; font-weight: normal">PTO Balance in red color indicates leaves are eligible for carry forward.</span>
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
            <div id="dialog" style="border: 3px solid #999999; width: 450px; height: 325px;">
                <div align="right" style="width: 98%; height: 25px;" class="PopupButton PageHeader">
                    <table width="100%">
                        <tr>
                            <td class="" style="text-align: center; margin-left: 5px; font-weight: bold; font-size: 15px; color: White">Vacation Reason
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="sub_control">
                    <table width="100%">
                        <tr>
                            <td align="left" style="color: #FF0000; font-weight: bold" width="2%">*</td>
                            <td style="text-align: left; color: black" width="25%">Title :
                            </td>

                            <td>
                                <asp:TextBox runat="server" ID="txtTitle" CssClass="td_control" Width="90%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="color: #FF0000; font-weight: bold" width="2%">*</td>
                            <td style="text-align: left; color: black" width="25%">Reason :
                            </td>

                            <td>
                                <asp:TextBox runat="server" ID="txtReason" CssClass="td_control" TextMode="MultiLine"
                                    Width="90%" Height="90px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr id="trComments">
                            <td align="left" style="color: #FF0000; font-weight: bold" width="2%"></td>
                            <td style="text-align: left; color: black" width="25%">Comments :
                            </td>

                            <td>
                                <asp:TextBox runat="server" ID="txtComments" CssClass="td_control" TextMode="MultiLine" Enabled="false"
                                    Width="90%" Height="90px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr id="trWarning" style="display: none; height: 10px">
                            <td style="text-align: left; color: red" colspan="2">
                                <asp:Label ID="lblWarning" runat="server" Text=""></asp:Label>
                            </td>
                            <td style="text-align: left; color: red">
                                <asp:Label ID="lblWarningValue" Width="90%" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>
                <div align="center" style="margin-bottom: 5px;">
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
