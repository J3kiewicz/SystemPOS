<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="OrderStatus.aspx.cs" Inherits="Food_Ordering_Project.Admin.OrderStatus" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        /*For disappearing alert message*/
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%=lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };

        function toggleDetails(detailsId) {
            var details = document.getElementById(detailsId);
            if (details.style.display === "none") {
                details.style.display = "table-row";
            } else {
                details.style.display = "none";
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pcoded-inner-content pt-0">
        <div class="align-self-end">
            <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
        </div>
        <!-- Main-body start -->
        <div class="main-body">
            <div class="page-wrapper">
                <!-- Page body start -->
                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                </div>
                                <div class="card-block">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <h4 class="sub-title">Historia zamówień</h4>
                                            <div class="card-block table-border-style">
                                                <div class="table-responsive">
                                                    <asp:Repeater ID="rOrderStatus" runat="server" OnItemCommand="rOrderStatus_ItemCommand" OnItemDataBound="rOrderStatus_ItemDataBound">
                                                        <HeaderTemplate>
                                                            <table class="table data-table-export table-hover nowrap">
                                                                <thead>
                                                                    <tr>
                                                                        <th>ID Zamówienia</th>
                                                                        <th>ID Użytkownika</th>
                                                                        <th>Data</th>
                                                                        <th>Status</th>
                                                                        <th>Stolik</th>
                                                                        <th>Ilość produktów</th>
                                                                        <th>Suma</th>
                                                                        <th>Płatność</th>
                                                                        <th class="datatable-nosort">Akcje</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td><%# Eval("OrderDetailsId") %></td>
                                                                <td><%# Eval("UserId") %></td>
                                                                <td><%# Eval("FormattedDate") %></td>
                                                                <td>
                                                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'
                                                                        CssClass='<%# GetStatusBadgeClass(Eval("Status").ToString()) %>'>
                                                                    </asp:Label>
                                                                </td>
                                                                <td><%# "Stolik " + Eval("TableName") %></td>
                                                                <td><%# Eval("TotalQuantity") %></td>
                                                                <td><%# Eval("TotalPrice", "{0:C}") %></td>
                                                                <td><%# Eval("PaymentMode") %></td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkDetails" Text="Szczegóły" runat="server" CssClass="badge badge-info"
                                                                        CommandArgument='<%# Eval("OrderDetailsId") %>' CommandName="details">
                                                                        <i class="ti-eye"></i>
                                                                    </asp:LinkButton>
                                                                </td>
                                                            </tr>
                                                            <tr id="details_<%# Eval("OrderDetailsId") %>" style="display:none;">
                                                                <td colspan="9">
                                                                    <div class="order-details">
                                                                        <h5>Szczegóły zamówienia #<%# Eval("OrderDetailsId") %></h5>
                                                                        <asp:Repeater ID="rOrderItems" runat="server">
                                                                            <HeaderTemplate>
                                                                                <table class="table table-bordered">
                                                                                    <thead>
                                                                                        <tr>
                                                                                            <th>Produkt</th>
                                                                                            <th>Ilość</th>
                                                                                            <th>Cena jednostkowa</th>
                                                                                            <th>Suma</th>
                                                                                        </tr>
                                                                                    </thead>
                                                                                    <tbody>
                                                                            </HeaderTemplate>
                                                                            <ItemTemplate>
                                                                                <tr>
                                                                                    <td><%# Eval("Name") %></td>
                                                                                    <td><%# Eval("Quantity") %></td>
                                                                                    <td><%# Eval("Price", "{0:C}") %></td>
                                                                                    <td><%# (Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity")), "{0:C}") %></td>
                                                                                </tr>
                                                                            </ItemTemplate>
                                                                            <FooterTemplate>
                                                                                    </tbody>
                                                                                </table>
                                                                            </FooterTemplate>
                                                                        </asp:Repeater>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </tbody>
                                                            </table>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Page body end -->
            </div>
        </div>
    </div>
</asp:Content>