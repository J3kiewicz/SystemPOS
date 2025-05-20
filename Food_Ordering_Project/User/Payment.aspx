<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" 
    CodeBehind="Payment.aspx.cs" Inherits="Food_Ordering_Project.User.Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>

    .container {
        max-width: 600px;
        margin: auto;
        padding: 20px;
        background-color: #f8f9fa;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    .btn {
        width: 100%;
        padding: 15px;
        font-size: 18px;
    }

    .btn-primary {
        background-color: #ffbe33;
        border-color: black;
    }

    .btn-success {
        background-color: #ffbe33;
        border-color: black;

   
       
    }
</style>
    <div class="container text-center mt-5">
        <h3 class="mb-4">Wybierz metodę płatności</h3>
        
        <div class="row justify-content-center">
            <div class="col-md-4 mb-3">
                <asp:Button ID="btnCard" runat="server" Text="Karta" 
                    CssClass="btn btn-primary btn-lg btn-block" OnClick="btnCard_Click" />
            </div>
            <div class="col-md-4 mb-3">
                <asp:Button ID="btnCash" runat="server" Text="Gotówka" 
                    CssClass="btn btn-success btn-lg btn-block" OnClick="btnCash_Click" />
            </div>
        </div>
    </div>
</asp:Content>