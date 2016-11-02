<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Manager.aspx.cs" Inherits="Manager" %>

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
    <script src="Scripts/jquery-1.7.2.min.js"></script>
    <script src="Scripts/jquery-ui-1.8.19.custom.min.js"></script>
    <%--<script src="Scripts/jquery-1.11.1.js">
    </script>--%><%--<script src="Scripts/jquery-ui-1.11.1.js"></script>--%>
    <%--<script src="Scripts/jquery-2.1.1.js"></script>--%>
    <script src="Scripts/jquery-ui.multidatespicker.js"></script>
    <script type="text/javascript"> $cl = jQuery.noConflict();</script>
    <link href="CSS/jquery-ui.css" rel="stylesheet" />

    <script>
        var startDate;
        var endDate;
        var Approved = "N";
        $(document).ready(function () {
            $.ajax({
                type: "POST",
                url: "Manager.aspx/LoadVacations",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    showCalendar(response);
                },
            });

        });
        $cl(function () {
            $cl("#txtDates").multiDatesPicker({
                dateFormat: 'dd-mm-yy'
               // beforeShowDay: $cl.datepicker.noWeekends
            });

            $cl("#stxtDates").click(function () {
                $cl("#txtDates").focus();
            });
        });

        function showCalendar(response) {
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
                height: 550,
                navLinks: true,
                selectable: false,
                editable: true,
                events: $.map(response.d, function (item, i) {
                    var bExits = false;
                    if (vacList.length > 0) {
                        vacList.filter(function (e) {
                            bExits = (e.title == item.AssocName && String(e.start) == String(new Date(item.mFromDate)) && String(e.end) == String(new Date(item.mToDate)));
                        });
                    }
                    if (!bExits) {
                        var event = new Object();
                        event.id = item.ID;
                        event.start = new Date(item.mFromDate);
                        event.end = new Date(item.mToDate);
                        event.title = item.AssocName;
                        event.allDay = true;
                        event.Approved = item.Approved;
                        event.Holiday = false;
                        if (item.Approved == "Y") {
                            event.color = "#5fba7d";
                        }
                        if (item.Approved == "P" || item.Approved == "F" || item.Approved == "R") {
                            event.color = "#B33A3A";
                        }
                        event.vacation = item.Title;
                        event.Reason = item.Reason;
                        event.PTO = item.AsscPTOBal;
                        event.bSplilBalance = item.bSplilBalance;

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
                    element.bind('dblclick', function () {
                        if (event.Approved != "N")
                            Approved = event.Approved;
                        openDialog(event.title, event.vacation, event.Reason, event.id, event.Approved, event.holiday, event.PTO, event.bSplilBalance, event.start, event.end);
                    });
                    if (mEventList.length > 0) {
                        for (var iEvent = 0; iEvent < mEventList.length; iEvent++) {
                            if (!$('.fc-day[data-date="' + mEventList[iEvent].Date + '"]').hasClass('Approved') && !$('.fc-day[data-date="' + mEventList[iEvent].Date + '"]').hasClass('Rejected'))
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
                url: "Manager.aspx/AddHolidays",
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
        $(function () {
            $('#ddlStatus').change(function () {
                hideComments();
            });
        });

        function hideComments() {
            if (document.getElementById("ddlStatus").selectedIndex == 1) {
                $("#txtComments").removeAttr('disabled', 'disabled');
            }
            else {
                $("#txtComments").val("");
                $("#txtComments").attr('disabled', 'disabled');
            }
        }


        Date.prototype.addDays = function (days) {
            this.setDate(this.getDate() + parseInt(days));
            return this;
        };

        Date.prototype.addDays = function (days) {
            var dat = new Date(this.valueOf())
            dat.setDate(dat.getDate() + days);
            return dat;
        }

        function getDates(startDate, stopDate) {
            var dateArray = new Array();
            var currentDate = startDate;
            while (currentDate <= stopDate) {
                dateArray.push(new Date(currentDate))
                currentDate = currentDate.addDays(1);
            }
            return dateArray;
        }

        var daysRange = [];
        function openDialog(Name, Title, Reason, ID, Approved, Holiday, PTO, SpilBalance, StartDate, EndDate) {
            if (Holiday)
                return;
            document.getElementById('lblName').innerHTML = Name;
            document.getElementById('txtTitle').value = Title;
            document.getElementById('txtReason').value = Reason;
            document.getElementById('hdnID').value = ID;

            var diffDays = EndDate.diff(StartDate, 'days');
            daysRange = [];
            if (diffDays > 1) {
                $('#trDate').show();
                $('#dialog').height('448px');
                var tEndDate = new Date(EndDate);
                tEndDate = tEndDate.getTime() - (1 * 24 * 60 * 60 * 1000);
                daysRange = getDates(new Date(StartDate), new Date(tEndDate));
                $cl("#txtDates").multiDatesPicker("destroy");
                $cl('#txtDates').multiDatesPicker('resetDates', 'disabled');
                $cl("#txtDates").multiDatesPicker(
                    {
                        dateFormat: 'dd-mm-yy',
                        beforeShowDay: function (date) {
                            if (new Date(date) >= new Date(StartDate).getTime() - (1 * 24 * 60 * 60 * 1000) && new Date(date) <= new Date(tEndDate)) {
                                return [true, "special"];
                            }
                            else {
                                return [false, "special"];
                            }
                        },
                        addDates: daysRange,
                    }
                );
            }
            else {
                $('#trDate').hide();
                $('#dialog').height('430px');
            }

            if (SpilBalance) {
                $("#trPTO").show();
                document.getElementById('lblVacation').innerHTML = "<b>PTO Balance : <font color='red'>" + PTO + "</font></b>";
            }
            else {
                $("#trPTO").hide();
                document.getElementById('lblVacation').innerHTML = "<b>PTO Balance : " + PTO + "</b>";
            }

            if (Approved == "P" || Approved == "F" || Approved == "R" || Approved == "Y" || Approved == "1" || Approved == "2" || Approved == "3" || Approved == "4") {
                if (Approved == "R" || Approved == "2") {
                    document.getElementById("ddlStatus").selectedIndex = 1;
                }
                if (Approved == "P" || Approved == "3") {
                    document.getElementById("ddlStatus").selectedIndex = 2;
                }
                if (Approved == "F" || Approved == "4") {
                    document.getElementById("ddlStatus").selectedIndex = 3;
                }

                if (Approved == "Y" || Approved == "1") {
                    document.getElementById("ddlStatus").selectedIndex = 0;
                }
            }
            else {
                document.getElementById("ddlStatus").selectedIndex = 0;
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
                hideComments();
            });
        }

        function closeFancybox() {
            var vStatus = $("select[name='ddlStatus'] option:selected").val();
            var vComments = document.getElementById('txtComments').value;
            var vDates = "";
            if ($("#trDate").is(":visible")) {
                vDates = document.getElementById('txtDates').value;
            }

            $.ajax({
                type: "POST",
                url: "Manager.aspx/UpdateVacation",
                data: '{Status: "' + vStatus + '",ID: ' + document.getElementById('hdnID').value + ',Comments :"' + vComments + '",Dates : "' + vDates + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var eventsList = [];
                    $.map(response.d, function (item, i) {
                        eventsList.push({
                            id: item.ID,
                            start: new Date(item.mFromDate),
                            end: new Date(item.mToDate),
                            title: item.AssocName,
                            allDay: true,
                            Approved: item.Approved,
                            Reason: item.Reason,
                            holiday: false,
                            vacation: item.Title,
                            PTO: item.AsscPTOBal,
                            bSplilBalance: item.bSplilBalance,
                            color: (item.Approved == "1") ? "#5fba7d" : '#B33A3A'
                        });
                        var start = new Date(item.mFromDate);
                        var end = new Date(item.mToDate);
                        var diffDays = Math.round(Math.abs((end.getTime() - start.getTime()) / (24 * 60 * 60 * 1000)));
                        if (diffDays > 1) {
                               eventsList[i].color = "#800080";
                        }

                        var selectedDays = document.getElementById('txtDates').value.split(',');
                        for (var iDays = 0; iDays < selectedDays.length ; iDays++) {
                            var from = selectedDays[iDays].split('-');
                            selectedDays[iDays] = String(new Date(from[2], from[1] - 1, from[0]));
                        }

                        for (var iDates = 0; iDates < daysRange.length ; iDates++) {
                            var dExists = selectedDays.indexOf(String(daysRange[iDates]));
                            $('.fc-day[data-date="' + formatDate(daysRange[iDates]) + '"]').attr("class", $('.fc-day[data-date="' + formatDate(daysRange[iDates]) + '"]').attr("class").replace(" Approved", ""));
                            $('.fc-day[data-date="' + formatDate(daysRange[iDates]) + '"]').attr("class", $('.fc-day[data-date="' + formatDate(daysRange[iDates]) + '"]').attr("class").replace(" Rejected", ""));
                            if (dExists != -1)
                                $('.fc-day[data-date="' + formatDate(daysRange[iDates]) + '"]').addClass(($("select[name='ddlStatus'] option:selected").val() == "1") ? "Approved" : "Rejected");
                            else if (dExists == -1 && $("select[name='ddlStatus'] option:selected").val() == "1")
                                $('.fc-day[data-date="' + formatDate(daysRange[iDates]) + '"]').addClass("Rejected");
                            else if (dExists == -1 && $("select[name='ddlStatus'] option:selected").val() != "1")
                                $('.fc-day[data-date="' + formatDate(daysRange[iDates]) + '"]').addClass("Approved");
                        }
                    });
                    $('#calendar').fullCalendar('removeEvents', document.getElementById('hdnID').value);
                    $('#calendar').fullCalendar('addEventSource', eventsList);
                    document.getElementById('hdnID').value = "";
                    Approved = "N";
                   
                },
                failure: function (response) {
                }
            });
            $fb.fancybox.close();
        }
        function formatDate(date) {
            var d = new Date(date),
                month = '' + (d.getMonth() + 1),
                day = '' + d.getDate(),
                year = d.getFullYear();

            if (month.length < 2) month = '0' + month;
            if (day.length < 2) day = '0' + day;

            return [year, month, day].join('-');
        }
      

    </script>
    <style>
         .Rejected {box-shadow:inset 0 0 10px Red}
        .Approved {
            box-shadow:inset 0 0 10px Green
        }
        .Pending {
             box-shadow:inset 0 0 10px #3a87ad
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
            <div id="dialog" style="border: 3px solid #999999; width: 450px; height: 430px;">
                <div align="right" style="width: 98%; height: 25px;" class="PopupButton PageHeader">
                    <table width="100%">
                        <tr>
                            <td class="" style="text-align: center; margin-left: 5px; font-weight: bold; font-size: 15px; color: White">Vacation Details
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="sub_control">
                    <table width="100%">
                        <tr>
                            <td style="text-align: right; color: black">
                                <asp:Label ID="lblVacation" runat="server" Text="PTO Balance :"> </asp:Label>
                            </td>
                        </tr>
                    </table>
                    <table width="100%">
                        <tr>
                            <td style="text-align: left; color: black" width="25%">Name :
                            </td>

                            <td>
                                <asp:Label runat="server" ID="lblName" CssClass="td_control" Width="90%"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; color: black" width="25%">Title :
                            </td>

                            <td>
                                <asp:TextBox runat="server" ID="txtTitle" Enabled="false" CssClass="td_control" Width="90%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; color: black" width="25%">Reason :
                            </td>

                            <td>
                                <asp:TextBox runat="server" ID="txtReason" CssClass="td_control" TextMode="MultiLine" Enabled="false"
                                    Width="90%" Height="90px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr id="trDate">
                            <td style="text-align: left; color: black" width="25%">Dates :
                            </td>
                            <td>
                                <asp:TextBox ID="txtDates" class="textbox" runat="server" Width="150px"></asp:TextBox>
                                <span id="stxtDates" class="fa fa-calendar"></span>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; color: black" width="25%">[Approve / Reject] :
                                <span style="color: #FF0000; font-weight: bold">*</span>
                            </td>

                            <td>
                                <asp:DropDownList runat="server" ID="ddlStatus" CssClass="dropdown" Width="93%">
                                    <asp:ListItem Value="1">Approved</asp:ListItem>
                                    <asp:ListItem Value="2">Rejected</asp:ListItem>
                                    <asp:ListItem Value="3">Rejected : Less PTO Balance</asp:ListItem>
                                    <asp:ListItem Value="4">Rejected : Too Frequent</asp:ListItem>

                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; color: black" width="25%">Comments :
                            </td>

                            <td>
                                <asp:TextBox runat="server" ID="txtComments" CssClass="td_control" TextMode="MultiLine" Enabled="false"
                                    Width="90%" Height="90px"></asp:TextBox>
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
                <table>
                    <tr id="trPTO">
                        <td colspan="2">
                            <span style="color: red; font-size: 9pt; font-weight: bold">PTO Balance in red color indicates leaves are eligible for carry forward.</span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <input type="hidden" value="" id="hdnID" />
    </form>
</body>
</html>
