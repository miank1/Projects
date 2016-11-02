<%@ Control Language="C#" AutoEventWireup="true" CodeFile="HeaderControl.ascx.cs" Inherits="HeaderControl" %>
<head id-="head1" runat="server">
    <meta http-equiv="Page-Enter" content="blendTrans(Duration=0)" />
    <meta http-equiv="Page-Exit" content="blendTrans(Duration=0)" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
    <meta http-equiv='X-UA-Compatible' content='IE=8' />
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <link href="CSS/font-awesome.css" rel="stylesheet" />
    <link href="CSS/PageStyles.css" rel="stylesheet" />
    <link href="CSS/style.css" rel="stylesheet" />
    <link href="CSS/LoginStyles.css" rel="stylesheet" />
    <link href="CSS/jquery.fancybox-1.3.4.css" rel="stylesheet" />
    <script type="text/javascript">
        $('body').click(function (evt) {
            var _blankTarget = $(evt.target).attr('class') === undefined;
            if (_blankTarget == true) {

                $('#dMenu').animate({ left: '-130px' });
            }
            if (evt.target.id == "divSlideButton") {
                if ($('#dMenu').css("left") == '0px')
                    $('#dMenu').animate({ left: '-130px' });
                else
                    $('#dMenu').animate({ left: '0px' });
            }
            else if ($(evt.target).attr('class') == "hideallulli" ||
                     $(evt.target).attr('class').match("^CLICK_BLOCK_HDR_MENU") ||
                     $(evt.target).attr('class') == 'ImageButton1' ||
                     $(evt.target).attr('class') == 'ImageButton1Alt') {
                $('#dMenu').animate({ left: '0px' });
            }
            else {
                $('#dMenu').animate({ left: '-130px' });
            }
        });
    </script>
    <script>
        function ShowMenu() {
            $('#MainMenuDiv').show();
        }
    </script>

    <style>
        body {
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
    </style>
</head>
<body style="width: 100%; background-color: #F4F4F4;" id="HeaderControlBody">
    <div id="Mainheader" style="width: 100%; margin: 0px auto; text-align: center">
        <div id="stickyMainheader" style="width: 100%; margin: 0px auto; text-align: center">
            <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; padding: 0px; margin: 0px;"
                id="tblMainHeader" runat="server">
                <tr class="PageHeader" style="background-color: #389BEF; height: 60px">
                    <td align="left" style="padding-left: 20px; width: 20px; padding-right: 0px;">
                        <i class="fa fa-calendar fa-5x" style="color: #FFFFFF"></i>
                          
                    </td>
                    <td align="left" style="padding-left: -50px; width: 300px;"></td>
                    <td width="50%" align="center">
                        <asp:Label ID="lblHeading" runat="server" CssClass="PageHeaderText" Text="Vacation Tracker"></asp:Label>
                    </td>
                    <td width="25%" align="right" class="td_padding" style="color: #FFFFFF; padding-right: 20px; font-size: 15px;"></a><a id="logout" onclick="ClearSessions" title="Logout" href="<%=strVirtualPath%>/login.aspx" style="cursor: pointer;">
                        <i class="fa fa fa-power-off fa-3x" style="color: #FFFFFF"></i></a>
                    </td>
                </tr>
            </table>
            <div class="PageSubHeader">
                <table cellpadding="0" cellspacing="0" style="width: 100%;">
                    <tr align="left">
                        <td style="width: 45%; padding-left: 5px;">
                            <div class="Div_spanOuter">
                                <span class="BodyHeaderText">
                                    <asp:Label ID="lblSubHeader" runat="server" CssClass="Label_HeaderStyle_Align" Text=""></asp:Label></span>
                            </div>
                        </td>
                        <td style="width: 55%; padding-right: 10px; vertical-align: middle;" align="right">
                            <span class="UserHeaderText">
                                <asp:Label ID="lblUserName" runat="server" Style="vertical-align: bottom;"></asp:Label></span> &nbsp;
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="DivSlideContentx" id="MainMenuDiv" style="padding: 0px; margin: 0px;display:none;">
        <table cellpadding="5px;" cellspacing="0" id="dMenu" style="left: -130px; width: 100px; height: 100px; max-height: 300px; margin: 0px; padding: 0px; position: fixed; top: 15%; z-index: 1000;">
            <tr>
                <td style="padding: 0px; margin: 0px;" width="20%">
                    <div id="SectionGrp" class="SectionGroup" runat="server" style="border-color: #389BEF; background-color: #F9F9F9; padding: 0px; margin: 0px; border-width: 3px; border-color: #389BEF; border-top-style: solid; border-right-style: solid; border-bottom-style: solid; border-radius: 0px 5px 5px 0px; min-width: 125px; min-height: 352px;">
                        <table class="SectionGroup1" id="tblMenu" runat="server" cellspacing="0">
                        </table>
                    </div>
                </td>
                <td valign="top" style="padding: 0px; margin: 0px;">
                    <div title="Menu" class="DivSlideButton1" id="divSlideButton" style="cursor: pointer; margin-left: -5px; margin-top: 8px; color: White; height: 0; width: 20px; border-bottom: 20px solid #414141; border-left: 10px solid transparent; text-shadow: 1px 2.5px 5px #0D5FA2; border-right: 10px solid transparent; transform: rotate(90deg); -webkit-transform: rotate(90deg); -moz-transform: rotate(90deg); -o-transform: rotate(90deg); -ms-transform: rotate(90deg); padding-bottom: 3px; padding-left: 0px; font-size: large;">
                        :::
                    </div>
                </td>
            </tr>
        </table>
    </div>
</body>
