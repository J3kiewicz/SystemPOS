<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Table.aspx.cs" Inherits="Food_Ordering_Project.User.Table" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --primary-yellow: #FFD700;
            --dark-yellow: #FFC000;
            --black: #000000;
            --light-gray: #F8F8F8;
            --dark-gray: #333333;
        }
        
        .tables-section {
            padding: 60px 0;
            background-color: var(--light-gray);
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 50px;
            color: var(--black);
            font-weight: 700;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            display: block;
            width: 80px;
            height: 4px;
            background: var(--primary-yellow);
            margin: 15px auto 0;
        }
        
        .tables-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 25px;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .table-card {
            background: white;
            border-radius: 12px;
            padding: 25px 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border: 2px solid var(--black);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 120px;
        }
        
        .table-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            border-color: var(--primary-yellow);
        }
        
        .table-number {
            font-size: 28px;
            font-weight: 700;
            color: var(--black);
            margin-bottom: 8px;
        }
        
        .table-status {
            font-size: 14px;
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: 600;
        }
        
        .status-available {
            background-color: #28a745;
            color: white;
        }
        
        .status-occupied {
            background-color: #dc3545;
            color: white;
        }
        
        .status-reserved {
            background-color: #ffc107;
            color: var(--black);
        }
        
        @media (max-width: 768px) {
            .tables-container {
                grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
                gap: 15px;
            }
            
            .table-card {
                height: 100px;
                padding: 20px 10px;
            }
            
            .table-number {
                font-size: 24px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <section class="tables-section">
        <div class="container">
            <h2 class="section-title">Wybierz Stolik</h2>
            
            <div class="tables-container">
                <asp:Repeater ID="rTables" runat="server" OnItemCommand="rTables_ItemCommand">
                    <ItemTemplate>
                        <asp:LinkButton ID="lbTable" runat="server" CssClass="table-card" CommandName="SelectTable" CommandArgument='<%# Eval("TableId") %>'>
                            <div class="table-number">Stolik <%# Eval("TableId") %></div>
                            <div class='table-status <%# GetStatusClass(GetTableStatus(Convert.ToInt32(Eval("TableId")))) %>'>
                                <%# GetTableStatus(Convert.ToInt32(Eval("TableId"))) %>
                            </div>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>
</asp:Content>