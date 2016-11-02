<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TeamGrouping.aspx.cs" Inherits="TeamGrouping" %>

<%@ Reference Control="~/HeaderControl.ascx" %>
<%@ Register TagPrefix="HC" TagName="HeaderControl" Src="~/HeaderControl.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <script src="Lib/jquery-1.4.3.min.js"></script>
    <script type="text/javascript"> $fb = jQuery.noConflict();</script>
    <script src="Scripts/jquery.fancybox-1.3.4.pack.js"></script>
    <script src="Lib/jquery.min.js"></script>
    <script type="text/javascript">
        function ChangeToTextBox() {
            $("#ddlTeam").hide();
            $("#txtTeamName").show();
            return true;
        }
        function ChangeToDropDown() {
            $("#ddlTeam").show();
            $("#txtTeamName").hide();
            return true;
        }

        function getListBoxSelections(listBoxId, Description, msg) {
            var listBoxRef = document.getElementById(listBoxId);
            var functionReturn = '';

            for (var i = 0; i < listBoxRef.options.length; i++) {
                if (listBoxRef.options[i].selected) {

                    if (functionReturn.length > 0)
                        functionReturn += ',';
                    functionReturn += listBoxRef.options[i].value;
                }
            }
            if (functionReturn == "") {
                document.getElementById(listBoxId).focus();
                alert(Description)
                return false;
            }
            else {
                if (msg != "") {
                    return MgsYesNo(msg);
                }
                else {
                    return true;
                }

            }
        }

        function MgsYesNo(msg) {
            var x = confirm(msg);
            if (x == true) {
                return true;
            }
            else {
                return false;
            }
        }

        function ValidateFields() {
            var VacationCnt = document.getElementById("txtVacationCount").value;
            var SplitVacationCnt = document.getElementById("txtSpilOutVacationCount").value;
            if ($("#txtTeamName").is(":visible") && !$("#ddlTeam").is(":visible")) {
                if (document.getElementById("txtVacationCount").value == null || document.getElementById("txtVacationCount").value == "") {
                    document.getElementById("lblError").innerHTML = "Team Name and Vacation Count should not be left blank";
                    return false;
                }
            }
            if ($("#ddlTeam").is(":visible")) {
                if ($("select[name='ddlTeam'] option:selected").index() == 0) {
                    document.getElementById("lblError").innerHTML = "Please select Team Name to view team details";
                    return false;
                }
            }
            if (!($.isNumeric(VacationCnt) && Math.floor(VacationCnt) == VacationCnt) || VacationCnt == null || VacationCnt == "") {
                document.getElementById("lblError").innerHTML = "Vacation Count should be an numeric value";
                return false;
            }
            if (document.getElementById("txtSpilOutVacationCount").value != "") {
                if (!($.isNumeric(SplitVacationCnt) && Math.floor(SplitVacationCnt) == SplitVacationCnt)) {
                    document.getElementById("lblError").innerHTML = "Carry forwarded Vacation Count should be an numeric value";
                    return false;
                }
                if (Number(SplitVacationCnt) > Number(VacationCnt)) {
                    document.getElementById("lblError").innerHTML = "Carry forwarded vacation count should be less than vacation count";
                    return false;
                }
            }
            return true;
        }

    </script>
    <script type="text/javascript">
        function Open(uri, width, height) {
            $fb(document).ready(function () {
                $fb.fancybox({
                    'padding': '4',
                    'width': width,
                    'height': height,
                    'autoScale': true,
                    'overlayOpacity': .7,
                    'transitionIn': 'none',
                    'transitionOut': 'none',
                    'type': 'iframe',
                    'overlayColor': '#000000',
                    'href': uri,
                    'hideOnOverlayClick': false,
                    'hideOnContentClick': false,
                    'enableEscapeButton': false,
                    'titleShow': true
                });
            });
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
                                                <asp:Label ID="Label2" runat="server" Text="Team Grouping"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <br />
                                <table border="0" cellpadding="0" cellspacing="0" width="95%">
                                    <tr align="center" style="width: 100%;">
                                        <td align="left" style="width: 10%"></td>
                                       
                                        <td align="right">Team Name : 
                                             <span style="color: #FF0000; font-weight: bold">*</span>
                                             &nbsp;<asp:DropDownList ID="ddlTeam" Width="150px" runat="server" AutoPostBack="true"  CssClass="dropdown" OnSelectedIndexChanged="ddlTeam_SelectIndexChanged">
                                             </asp:DropDownList>
                                            <asp:TextBox ID="txtTeamName" runat="server" CssClass="textbox" Visible="false"></asp:TextBox>
                                        </td>
                                        <td style="width: 3%"></td>
                                        <td align="left">

                                            <asp:LinkButton ID="lnkbtnAdd" runat="server" Text="Add" OnClick="lnbtnAdd_Click" CssClass="PopupButton"><i class="fa fa-plus-square fa-1a5x"></i>&nbsp;&nbsp;Add</asp:LinkButton>
                                            <asp:LinkButton ID="lnkbtnDelete" runat="server" OnClick="lnkbtnDelete_Click" Text="Delete" CssClass="PopupButton"><i class="fa fa-trash-o fa-1a5x"></i>&nbsp;&nbsp;Delete</asp:LinkButton>
                                            <asp:LinkButton ID="lnkbtnClear" Enabled="false" runat="server" Text="clear" OnClick="lnkbtnClear_Click" CssClass="PopupButtonDisabled"><i class="fa fa-times fa-1a5x"></i>&nbsp;&nbsp;Clear</asp:LinkButton>
                                        </td>
                                    </tr>
                                    <tr style="height: 10px"></tr>
                                    <tr>
                                        <td align="left" style="width: 10%"></td>
                                        <td align="right">Vacation Count : 
                                             <span style="color: #FF0000; font-weight: bold">*</span>
                                             &nbsp;<asp:TextBox ID="txtVacationCount" CssClass="textbox" runat="server"></asp:TextBox>
                                        </td>
                                        <td style="width: 3%"></td>
                                        <td></td>
                                    </tr>
                                    <tr style="height: 10px"></tr>
                                    <tr>
                                        <td align="left" style="width: 10%"></td>
                                        <td align="right">Carry forwarded Vacation Count : 
                                             <asp:TextBox ID="txtSpilOutVacationCount" CssClass="textbox" runat="server"></asp:TextBox>
                                        </td>
                                        <td style="width: 3%"></td>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
                <br />
                <table style="width: 100%;" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="text-align: center; color: red">
                            <asp:Label ID="lblError" runat="server"></asp:Label>
                        </td>
                    </tr>
                    </table>
                    

                    <table border="0" cellpadding="0" cellspacing="0" width="99%" style="float:right">
                        <tr>
                            <td  class="td_label">&nbsp;<asp:Label Text="Available Associates" runat="server" ID="lblAvailableAssociates" />
                                 <asp:LinkButton Text="" runat="server" ID="lnkbtnChangeTeam" style="float:right" OnClientClick="return getListBoxSelections('lstAvailable','Please select an Associate from available Associates list.','');"
                                                ToolTip="Change Associate Team" OnClick="lnkbtnChangeTeam_Click"><i class="IconColor fa fa-user fa-3x"></i></asp:LinkButton>
                            </td>
                            <td></td>
                            <td  class="td_label">&nbsp;<asp:Label Text="Selected Associates" runat="server" ID="lblSelectedAssociates" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 10%;">
                                <table width="100%" border="0px" cellpadding="0" cellspacing="0" class="">
                                    <tr>
                                        <td>
                                            <div class="dropDownListDiv">
                                                <asp:ListBox ID="lstAvailable" Height="300px" Width="100%" CssClass="listbox" SelectionMode="Multiple"
                                                    runat="server"></asp:ListBox>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <%--<td style="width: 1px;"></td>--%>
                            <td style="width: 2%; vertical-align: middle">
                                <table align="center" height="100%">
                                    <tr>
                                        <td>&nbsp;&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;
                                        </td>
                                    </tr>
                                    <tr style="height: 30px">
                                        <td>
                                            <asp:LinkButton Text="" runat="server" ID="btnAdd" ToolTip="Assign Associates" OnClick="btnAdd_Click"
                                                CssClass="PopupButton" Height="18px" Width="12px">&nbsp;<i class="fa fa-angle-right fa-1a5x"></i></asp:LinkButton>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:LinkButton Text="" runat="server" ID="btnRemove" 
                                                OnClick="btnRemove_Click" ToolTip="Unassign Associates" CssClass="PopupButton" Height="18px" Width="12px">&nbsp;<i class="fa fa-angle-left fa-1a5x"></i></asp:LinkButton>
                                    </tr>
                                    <tr style="height: 30px">
                                        <td>&nbsp;
                                        </td>
                                    </tr>
                                    <tr style="height: 30px">
                                        <td>&nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                    </tr>
                                </table>
                            </td>
                            </td>
                        <td style="width: 10%">
                            <table width="100%" border="0px" cellpadding="0" cellspacing="0" class="">
                                <tr>
                                    <td>
                                        <div class="dropDownListDiv">
                                            <asp:ListBox ID="lstSelected" Height="300px" Width="100%" CssClass="listbox" SelectionMode="Multiple"
                                                runat="server"></asp:ListBox>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        </tr>
                    </table>
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr style="height:5px"></tr>
                        <tr>
                            <td align="left">
                                <span style="color:red;font-size:9pt;font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Associates highlighted in red color represents manager</span>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:LinkButton ID="lnkbtnSubmit" runat="server" OnClientClick="Javascript:return ValidateFields();" Text="Save" OnClick="lnkbtnSubmit_Click" CssClass="PopupButton"><i class="fa fa-floppy-o fa-1a5x"></i>&nbsp;&nbsp;Submit</asp:LinkButton>
                                <asp:LinkButton ID="lnkbtnCancel" runat="server" Text="Cancel" OnClick="lnkCancel_Click" CssClass="PopupButton"><i class="fa fa-times-circle fa-1a5x"></i>&nbsp;&nbsp;Cancel</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
            </div>
        </div>
    </form>
</body>
</html>
