<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Table.aspx.cs" Inherits="Food_Ordering_Project.User.Table" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
 <style>
 .table-container {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            padding: 20px;
            background: #e69c00;
        }
        .table-item {
            background-color: #ffbe33;
            color: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            height: 100px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            font-weight: bold;
            font-size: 18px;
        }
        .table-item:hover {
            background-color: #e69c00;
            transform: scale(1.05);
        }
        .table-number {
            font-size: 24px;
            margin-bottom: 5px;
        }
        .table-status {
            font-size: 14px;
            font-weight: normal;
        }
     h2 {
         padding-bottom: 50px;
         padding-top: 50px;
     }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="heading_container heading_center">
        <h2>Wybierz Stolik</h2>
    </div>
    
    <div class="table-container">
        <asp:Repeater ID="rTables" runat="server" OnItemCommand="rTables_ItemCommand">
            <ItemTemplate>
                <asp:LinkButton ID="lbTable" runat="server" CssClass="table-item" CommandName="SelectTable" CommandArgument='<%# Eval("TableId") %>'>
                    <%# GetTableStatus(Convert.ToInt32(Eval("TableId"))) %>
                </asp:LinkButton>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>