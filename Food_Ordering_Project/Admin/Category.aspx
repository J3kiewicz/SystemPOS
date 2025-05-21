<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Category.aspx.cs" Inherits="Food_Ordering_Project.Admin.Category" %>
<%@ Import Namespace="Food_Ordering_Project" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%=lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };
    </script>
    <script>
        function ImagePreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#<%=imgCategory.ClientID%>').prop('src', e.target.result)
                        .width(200)
                        .height(200);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="pcoded-inner-content pt-0">
        <div class="align-self-end">
            <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
        </div>

        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header">
                                    <h4 class="sub-title">Zarządzanie kategoriami</h4>
                                </div>
                                <div class="card-block">
                                    <div class="row">
                                        <div class="col-sm-6 col-md-4 col-lg-4">
                                            <h5 class="mb-3">Dodaj / Edytuj kategorię</h5>
                                            <div class="form-group">
                                                <label>Nazwa kategorii</label>
                                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control"
                                                    placeholder="Wprowadź nazwę kategorii" required></asp:TextBox>
                                                <asp:HiddenField ID="hdnId" runat="server" Value="0" />
                                            </div>

                                            <div class="form-group">
                                                <label>Obraz kategorii</label>
                                                <asp:FileUpload ID="fuCategoryImage" runat="server" CssClass="form-control" onchange="ImagePreview(this);" />
                                            </div>

                                            <div class="form-check pl-4 pb-3">
                                                <asp:CheckBox ID="cbIsActive" runat="server" Text="&nbsp; Aktywna" CssClass="form-check-input" />
                                            </div>

                                            <div class="pb-4">
                                                <asp:Button ID="btnAddOrUpdate" runat="server" Text="Dodaj" CssClass="btn btn-success"
                                                    OnClick="btnAddOrUpdate_Click" />
                                                &nbsp;
                                                <asp:Button ID="btnClear" runat="server" Text="Wyczyść" CssClass="btn btn-secondary"
                                                    OnClick="btnClear_Click" CausesValidation="false" />
                                            </div>

                                            <div>
                                                <asp:Image ID="imgCategory" runat="server" CssClass="img-thumbnail" />
                                            </div>
                                        </div>

                                        <div class="col-sm-6 col-md-8 col-lg-8">
                                            <h5 class="mb-3">Lista kategorii</h5>
                                            <div class="card-block table-border-style">
                                                <div class="table-responsive">
                                                    <asp:Repeater ID="rCategpry" runat="server" OnItemCommand="rCategpry_ItemCommand"
                                                        OnItemDataBound="rCategpry_ItemDataBound">
                                                        <HeaderTemplate>
                                                            <table class="table data-table-export table-hover nowrap">
                                                                <thead>
                                                                    <tr>
                                                                        <th class="table-plus">Nazwa</th>
                                                                        <th>Obraz</th>
                                                                        <th>Aktywna</th>
                                                                        <th>Data utworzenia</th>
                                                                        <th class="datatable-nosort">Akcja</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td class="table-plus"><%# Eval("Name") %></td>
                                                                <td>
                                                                    <img width="40" src="<%# Utils.GetImageUrl(Eval("ImageUrl")) %>" alt='<%# Eval("ImageUrl") %>' />
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="lblIsActive" runat="server" Text='<%# Eval("IsActive").ToString() == "True" ? "Tak" : "Nie" %>'></asp:Label>
                                                                </td>
                                                                <td><%# Eval("CreatedDate") %></td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkEdit" Text="Edytuj" runat="server" CssClass="badge badge-primary"
                                                                        CommandArgument='<%# Eval("CategoryId") %>' CommandName="edit">
                                                                        <i class="ti-pencil"></i>
                                                                    </asp:LinkButton>
                                                                    <asp:LinkButton ID="lnkDelete" Text="Usuń" runat="server" CommandName="delete"
                                                                        CssClass="badge bg-danger" CommandArgument='<%# Eval("CategoryId") %>'
                                                                        OnClientClick="return confirm('Czy na pewno chcesz usunąć tę kategorię?');">
                                                                        <i class="ti-trash"></i>
                                                                    </asp:LinkButton>
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
                                    </div> <!-- row -->
                                </div>
                            </div>
                        </div>
                    </div> <!-- row -->
                </div> <!-- page-body -->
            </div> <!-- page-wrapper -->
        </div> <!-- main-body -->
    </div> <!-- inner-content -->
</asp:Content>
