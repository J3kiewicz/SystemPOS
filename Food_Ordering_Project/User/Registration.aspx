<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="Food_Ordering_Project.User.Registration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%=lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };

        function ImagePreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#<%=imgUser.ClientID%>').prop('src', e.target.result).width(200).height(200);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="book_section layout_padding">
        <div class="container">
            <div class="heading_container text-center mb-4">
                <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="alert alert-info" />
                <asp:Label ID="lblHeaderMsg" runat="server" Text="<h2>Rejestracja użytkownika</h2>"></asp:Label>
            </div>

            <div class="form_container d-flex flex-column gap-3 mx-auto" style="max-width: 600px;">
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Imię i nazwisko jest wymagane"
                    ControlToValidate="txtName" ForeColor="Red" Display="Dynamic" SetFocusOnError="true" />
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Wprowadź imię i nazwisko"
                    ToolTip="Imię i nazwisko" />
                <asp:RegularExpressionValidator ID="revName" runat="server" ErrorMessage="Imię i nazwisko może zawierać tylko litery"
                    ForeColor="Red" Display="Dynamic" SetFocusOnError="true"
                    ValidationExpression="^[A-Za-zĄąĆćĘęŁłŃńÓóŚśŹźŻż\s\-]+$" ControlToValidate="txtName" />

                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ErrorMessage="Nazwa użytkownika jest wymagana"
                    ControlToValidate="txtUsername" ForeColor="Red" Display="Dynamic" SetFocusOnError="true" />
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Wprowadź nazwę użytkownika"
                    ToolTip="Nazwa użytkownika" />

                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ErrorMessage="Email jest wymagany"
                    ControlToValidate="txtEmail" ForeColor="Red" Display="Dynamic" SetFocusOnError="true" />
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"
                    placeholder="Wprowadź email" ToolTip="Email" />

                <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ErrorMessage="Numer telefonu jest wymagany"
                    ControlToValidate="txtMobile" ForeColor="Red" Display="Dynamic" SetFocusOnError="true" />
                <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control"
                    TextMode="SingleLine" placeholder="Wprowadź numer telefonu" ToolTip="Numer telefonu" />
                <asp:RegularExpressionValidator ID="revMobile" runat="server"
                    ErrorMessage="Numer telefonu musi mieć 9 cyfr (opcjonalnie z +48)" ForeColor="Red" Display="Dynamic"
                    SetFocusOnError="true" ValidationExpression="^(\+48)?\s?[0-9]{9}$" ControlToValidate="txtMobile" />

                <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ErrorMessage="Adres jest wymagany"
                    ControlToValidate="txtAddress" ForeColor="Red" Display="Dynamic" SetFocusOnError="true" />
                <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" CssClass="form-control"
                    placeholder="Wprowadź adres" ToolTip="Adres" />

                <asp:FileUpload ID="fuUserImage" runat="server" CssClass="form-control" ToolTip="User Image"
                    onchange="ImagePreview(this);" />

                <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control" TextMode="SingleLine"
                    placeholder="Wprowadź kod pocztowy" ToolTip="Kod pocztowy" />
                <asp:RegularExpressionValidator ID="revPostCode" runat="server"
                    ErrorMessage="Kod pocztowy musi być w formacie NN-NNN" ForeColor="Red" Display="Dynamic"
                    SetFocusOnError="true" ValidationExpression="^\d{2}-\d{3}$" ControlToValidate="txtPostCode" />

                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ErrorMessage="PIN jest wymagany"
                    ControlToValidate="txtPassword" ForeColor="Red" Display="Dynamic" SetFocusOnError="true" />
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                    placeholder="Wprowadź 4-cyfrowy PIN" TextMode="Password" ToolTip="PIN" />
                <asp:RegularExpressionValidator ID="revPassword" runat="server"
                    ErrorMessage="PIN musi składać się z dokładnie 4 cyfr" ForeColor="Red" Display="Dynamic"
                    SetFocusOnError="true" ValidationExpression="^\d{4}$" ControlToValidate="txtPassword" />

                <div class="text-center mt-4">
                    <asp:Button ID="btnRegister" runat="server" Text="Zarejestruj"
                        CssClass="btn btn-success btn-lg rounded-pill px-5 text-white" OnClick="btnRegister_Click" />
                    <asp:Label ID="lblAlreadyUser" runat="server" CssClass="d-block mt-2 text-muted" />
                </div>

                <div class="text-center mt-4">
                    <asp:Image ID="imgUser" runat="server" CssClass="img-thumbnail" Width="200" Height="200" />
                </div>
            </div>
        </div>
    </section>
</asp:Content>

