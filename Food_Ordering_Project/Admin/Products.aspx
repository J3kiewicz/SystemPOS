<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="Food_Ordering_Project.Admin.Products" %>
<%@ Import Namespace="Food_Ordering_Project" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        window.onload = function () {
            setTimeout(function () {
                document.getElementById("<%=lblMsg.ClientID %>").style.display = "none";
            }, 5000);
        };

        function ImagePreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#<%=imgProduct.ClientID%>').prop('src', e.target.result).width(200).height(200);
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
                                <div class="card-header"></div>
                                <div class="card-block">
                                    <div class="row">
                                        <div class="col-sm-6 col-md-4 col-lg-4">
                                            <h4 class="sub-title">Produkt</h4>
                                            <div class="form-group">
                                                <label>Nazwa produktu</label>
                                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control"
                                                    placeholder="Wprowadź nazwę produktu"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ForeColor="Red"
                                                    ErrorMessage="Nazwa jest wymagana" SetFocusOnError="true" Display="Dynamic"
                                                    ControlToValidate="txtName" />
                                                <asp:HiddenField ID="hdnId" runat="server" Value="0" />
                                            </div>

                                            <div class="form-group">
                                                <label>Cena produktu (zł)</label>
                                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control"
                                                    placeholder="Wprowadź cenę produktu"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="reqFVIsActive" runat="server" ForeColor="Red"
                                                    ErrorMessage="Cena jest wymagana" SetFocusOnError="true" Display="Dynamic"
                                                    ControlToValidate="txtPrice" />
                                                <asp:RegularExpressionValidator ID="regexPrice" runat="server" ForeColor="Red"
                                                    ErrorMessage="Cena musi być liczbą dziesiętną" SetFocusOnError="true" Display="Dynamic"
                                                    ValidationExpression="^\d{0,8}(\.\d{1,4})?$" ControlToValidate="txtPrice" />
                                            </div>

                                            <div class="form-group">
                                                <label>Zdjęcie produktu</label>
                                                <asp:FileUpload ID="fuProductImage" runat="server" CssClass="form-control"
                                                    onchange="ImagePreview(this);" />
                                            </div>

                                            <div class="form-group">
                                                <label>Kategoria produktu</label>
                                                <asp:DropDownList ID="ddlCategories" CssClass="form-control" runat="server"
                                                    DataSourceID="SqlDataSource1" DataTextField="Name" DataValueField="CategoryId"
                                                    AppendDataBoundItems="true">
                                                    <asp:ListItem Value="0">Wybierz kategorię</asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ForeColor="Red"
                                                    ErrorMessage="Kategoria jest wymagana" SetFocusOnError="true" Display="Dynamic"
                                                    ControlToValidate="ddlCategories" InitialValue="0" />
                                                <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                                    ConnectionString="<%$ ConnectionStrings:cs %>"
                                                    SelectCommand="SELECT [CategoryId], [Name] FROM [Categories]" />
                                            </div>

                                            <div class="form-check pl-4">
                                                <asp:CheckBox ID="cbIsActive" runat="server" Text="&nbsp; Aktywny" CssClass="form-check-input" />
                                            </div>

                                            <div class="pb-5">
                                                <asp:Button ID="btnAddOrUpdate" runat="server" Text="Dodaj" CssClass="btn btn-success"
                                                    OnClick="btnAddOrUpdate_Click" />
                                                &nbsp;
                                                <asp:Button ID="btnClear" runat="server" Text="Wyczyść" CssClass="btn btn-secondary"
                                                    OnClick="btnClear_Click" CausesValidation="false" />
                                            </div>

                                            <div>
                                                <asp:Image ID="imgProduct" runat="server" CssClass="img-thumbnail" />
                                            </div>
                                        </div>

                                        <div class="col-sm-6 col-md-8 col-lg-8 mobile-inputs">
                                            <h4 class="sub-title">Lista produktów</h4>
                                            <div class="card-block table-border-style">
                                                <div class="table-responsive">
                                                    <asp:Repeater ID="rProduct" runat="server" OnItemCommand="rProduct_ItemCommand">
                                                        <HeaderTemplate>
                                                            <table class="table data-table-export table-hover nowrap">
                                                                <thead>
                                                                    <tr>
                                                                        <th class="table-plus">Nazwa</th>
                                                                        <th>Zdjęcie</th>
                                                                        <th>Cena (zł)</th>
                                                                        <th>Kategoria</th>
                                                                        <th>Aktywny</th>
                                                                        <th>Data utworzenia</th>
                                                                        <th>Akcje</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td class="table-plus"><%# Eval("Name") %></td>
                                                                <td>
                                                                    <img width="40" src="<%# Utils.GetImageUrl(Eval("ImageUrl")) %>" 
                                                                         alt='<%# Eval("ImageUrl") %>' />
                                                                </td>
                                                                <td><%# Eval("Price") %></td>
                                                                <td><%# Eval("CategoryName") %></td>
                                                                <td><%# Eval("IsActive").ToString() == "True" ? "Tak" : "Nie" %></td>
                                                                <td><%# Eval("CreatedDate") %></td>
                                                                <td>
                                                                    <asp:LinkButton ID="lnkEdit" Text="Edytuj" runat="server" CssClass="badge badge-primary"
                                                                        CommandArgument='<%# Eval("ProductId") %>' CommandName="edit"
                                                                        CausesValidation="false"><i class="ti-pencil"></i></asp:LinkButton>
                                                                    <asp:LinkButton ID="lnkDelete" Text="Usuń" runat="server" CommandName="delete"
                                                                        CssClass="badge bg-danger" CommandArgument='<%# Eval("ProductId") %>'
                                                                        OnClientClick="return confirm('Czy na pewno chcesz usunąć ten produkt?');"
                                                                        CausesValidation="false"><i class="ti-trash"></i></asp:LinkButton>
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
                    </div>
                </div> <!-- page-body -->
            </div>
        </div>
    </div>
</asp:Content>
