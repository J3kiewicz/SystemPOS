<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Order.aspx.cs" Inherits="Food_Ordering_Project.User.Order" %>
<%@ Import Namespace="Food_Ordering_Project" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>

    .btn-split-bill {
    border: 2px solid #6c757d !important; /* Kolor obramowania dopasowany do stylu przycisku */
    border-radius: 4px; /* Zaokrąglenie rogów */
    transition: all 0.3s ease; /* Efekt przejścia */
}

.btn-split-bill:hover {
    border-color: #5a6268; /* Ciemniejszy kolor obramowania przy najechaniu */
    background-color: #f8f9fa; /* Lekkie podświetlenie tła */
}
    .comment-edit-container {
    display: flex;
    align-items: center;
    gap: 5px;
    margin-top: 5px;
}

.comment-input {
    flex-grow: 1;
    min-width: 150px;
}

.cart-comment {
    font-size: 12px;
    color: #666;
    font-style: italic;
    margin-top: 3px;
}
        .table-info {
            background-color: #ffbe33; 
            color: white; 
            padding: 15px; 
            text-align: center; 
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .order-actions {
            margin-top: 10px;
        }
        .btn-change-table {
            background-color: #6c757d;
            color: white;
            margin-right: 10px;
        }
        .btn-complete-order {
            background-color: #28a745;
            color: white;
        }
        .product-comment {
            margin-top: 10px;
            width: 100%;
        }
        .cart-comment {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            font-style: italic;
        }
        .comment-input {
            width: 100%;
            margin-top: 5px;
            padding: 5px;
            font-size: 12px;
        }
    </style>
    <script>

      
        $(document).ready(function () {
            $('.filters_menu li').click(function () {
  
                $('.filters_menu li').removeClass('active');
          
                $(this).addClass('active');

       
                var filterValue = $(this).attr('data-filter');
                var categoryId = $(this).attr('data-id');

                $('.grid .all').hide();
                $('.grid').find('div' + filterValue).show(); 


            });
        });
        window.onload = function () {
            setTimeout(function () {
                var msg = document.getElementById("<%=lblMsg.ClientID %>");
                if (msg) msg.style.display = "none";
            }, 5000);
        };

        function showSplitBillModal() {
            $('#splitBillModal').modal('show');
        }


        $(document).ready(function () {
            $('.btn-split-bill').click(function (e) {
                e.preventDefault();
                __doPostBack('<%= lbSplitBill.UniqueID %>', '');
    });
        });

    
        function addProductToCart(event, productId) {
            event.preventDefault();
 
            __doPostBack('<%= rProducts.UniqueID %>', 'addToCart$' + productId);

   
            var box = event.target.closest('.box');
            box.classList.add('added-to-cart');
            setTimeout(function () {
                box.classList.remove('added-to-cart');
            }, 1000);
        }

    </script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="table-info">
        <h3>
            <asp:Label ID="lblTableNumber" runat="server" Text="Nie wybrano stolika"></asp:Label>
        </h3>
        <div class="order-actions">

            <asp:LinkButton ID="lbBackToTables" runat="server" OnClick="lbBackToTables_Click" 
                CssClass="btn btn-sm btn-change-table">
                <i class="fas fa-arrow-left"></i> Zmień stolik
            </asp:LinkButton>
<asp:LinkButton ID="lbSplitBill" runat="server" OnClick="lbSplitBill_Click" 
    CssClass="btn btn-sm btn-split-bill" CausesValidation="false">
    <i class="fas fa-cut"></i> Podziel rachunek
</asp:LinkButton>
            <asp:LinkButton ID="lbCompleteOrder" runat="server" OnClick="lbCompleteOrder_Click" 
                CssClass="btn btn-sm btn-complete-order">
                <i class="fas fa-check"></i> Zakończ zamówienie
            </asp:LinkButton>
        </div>
    </div>
       <div style="width:100%;">
        <asp:Panel ID="MainPanel" runat="server" style="float:left; width:60%;">
            <section class="food_section layout_padding" width: 100%; height:100%; background-repeat:no-repeat; 
                background-size: contain; background-attachment:fixed; background-position:left">
                <div class="container">
                    <div class="heading_container heading_center">
                        <div class="align-self-end">
                            <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
                        </div>
                     
                    </div>

                    <ul class="filters_menu">
                        <li class="active" data-filter="*" data-id="0">Wszystkie</li>
                        <asp:Repeater ID="rCategories" runat="server">
                            <ItemTemplate>
                                <li data-filter=".<%# LowerCase(Eval("Name")) %>" data-id="<%# Eval("CategoryId") %>"><%# Eval("Name") %></li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>

                    <div class="filters-content">
                        <div class="row grid">
                            <asp:Repeater ID="rProducts" runat="server" OnItemCommand="rProducts_ItemCommand">
                                <ItemTemplate>
                                    <div class="col-sm-6 col-lg-4 all <%# LowerCase(Eval("CategoryName")) %>">
                                        <div class="box">
                                            <div>
                                                                           <div class="img-box">
                                <asp:LinkButton runat="server" CommandName="addToCart" 
                                                CommandArgument='<%# Eval("ProductId") %>'
                                                CssClass="product-image-link">
                                    <img src="<%# Utils.GetImageUrl( Eval("ImageUrl")) %>" alt="">
                                </asp:LinkButton>
                            </div>
                                                <div class="detail-box">
                                                    <h5><%# Eval("Name") %></h5>
                                                    <div class="options">
                                                        <h6>zł<%# Eval("Price") %></h6>
                                                        
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </section>
        </asp:Panel>
        
        <asp:Panel ID="SidePanel" runat="server" style="float:right; width:40%;">
            <section class="book_section layout_padding">
                <div class="container">
                    <div class="heading_container">
                        <div class="align-self-end">
                            <asp:Label ID="Label1" runat="server" Visible="false"></asp:Label>
                        </div>
                        <h2>Rachunek</h2>
                    </div>
                </div>
                <div class="container">
                    <asp:Repeater ID="rCartItem" runat="server" OnItemCommand="rCartItem_ItemCommand"
                        OnItemDataBound="rCartItem_ItemDataBound">
                        <HeaderTemplate>
                            <table class="table data-table-export table-responsive-sm nowrap">
                                <thead>
                                    <tr>
                                        <th class="table-plus">Nazwa</th>
                                        <th>Cena</th>
                                        <th>Ilość</th>
                                        <th>Razem</th>
                                        <th class="datatable-nosort"></th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="table-plus">
                                    <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                    <!-- Wyświetlanie komentarza -->
                                    <div class="cart-comment">
                                        <asp:Label ID="lblComment" runat="server" Text='<%# Eval("Comment") %>' Visible='<%# !string.IsNullOrEmpty(Eval("Comment").ToString()) %>'></asp:Label>

                                    </div>
                                    
    <div class="comment-edit-container" style="display: flex; margin-top: 5px;">
<asp:TextBox ID="txtComment" runat="server" 
    Text='<%# Eval("Comment") %>'
    CssClass="comment-input"
    onkeydown="if(event.keyCode==13){event.preventDefault(); updateCartWithComment(this);}"
    data-productid='<%# Eval("ProductId") %>' />
                                                                            <asp:LinkButton ID="lbUpdateCart" runat="server" CommandName="updateCart" CssClass="btn btn-warning">
                                        <i class="fa fa-save mr-2"></i>
                                    </asp:LinkButton>
        </div>
                                </td>
                                        <td>zł<asp:Label ID="lblPrice" runat="server" Text='<%# Eval("Price") %>'></asp:Label>
            <!-- DODAJ TUTAJ hdnCartId -->
            <asp:HiddenField ID="hdnCartId" runat="server" Value='<%# Eval("CartId") %>' />
            <asp:HiddenField ID="hdnProductId" runat="server" Value='<%# Eval("ProductId") %>' />
            <asp:HiddenField ID="hdnQuantity" runat="server" Value='<%# Eval("Quantity") %>' />
            <asp:HiddenField ID="hdnPrdQuantity" runat="server" Value='<%# Eval("PrdQty") %>' />
        </td>
                                <td>
                                    <div class="product__details__option">
                                        <div class="quantity">
                                            <div class="pro-qty">
                                                <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" Text='<%# Eval("Quantity") %>'></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ForeColor="Red"
                                                    Font-Size="Small" ValidationExpression="[1-9]*" ControlToValidate="txtQuantity" Display="Dynamic"
                                                    SetFocusOnError="true" ErrorMessage="Ilość nie może być mniejsza niż 1" EnableClientScript="true">*</asp:RegularExpressionValidator>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td>zł<asp:Label ID="lblTotalPrice" runat="server"></asp:Label></td>
                                <td>
                                    <asp:LinkButton ID="lnkDelete" Text="Usuń" runat="server" CommandName="remove" CommandArgument='<%# Eval("ProductId") %>'
                                        OnClientClick="return confirm('Czy na pewno chcesz usunąć ten produkt z koszyka?');">
                                        <i class="fa fa-close"></i>
                                    </asp:LinkButton>
                                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ForeColor="Red" DisplayMode="SingleParagraph" Font-Bold="true"
                                        HeaderText="Błąd" ShowSummary="true" />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            <tr>
                                <td colspan="3"></td>
                                <td class="pl-lg-5"><b>Suma końcowa:</b></td>
                                <td><b>zł<% Response.Write(Session["grndTotalPrice"]); %></b></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td colspan="2" class="continue__btn">
                                    
                                </td>
                                <td colspan="2">
                                </td>
                                <td colspan="2">
                                </td>

                            </tr>
                            </tbody>
                            </table>

                        </FooterTemplate>

                    </asp:Repeater>
                </div>
            </section>
        </asp:Panel>

        
        <div style="clear:both;"></div>
    </div>

<div class="modal fade" id="splitBillModal" tabindex="-1" role="dialog" aria-labelledby="splitBillModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="splitBillModalLabel">Przenieś pozycje</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6>Produkty w obecnym rachunku:</h6>
                        <div class="checkbox-list">
                            
                            <asp:Repeater ID="rProductsToSplit" runat="server" OnItemDataBound="rProductsToSplit_ItemDataBound">
                                <ItemTemplate>
                                    <div class="product-item">
                                        <div class="form-check">
                                            <asp:CheckBox ID="cbSelectProduct" runat="server" CssClass="form-check-input" />
                                            <label class="form-check-label">
                                                <asp:Literal ID="ltProductName" runat="server" Text='<%# Eval("Name") %>'></asp:Literal>
                                            </label>
                                        </div>
                                        <div class="quantity-control">
                                            <span class="quantity-label">Ilość:</span>
                                            <asp:TextBox ID="txtSplitQuantity" runat="server" TextMode="Number" 
                                                min="1" CssClass="form-control form-control-sm" 
                                                Text='<%# Eval("Quantity") %>'></asp:TextBox>
                                            <asp:HiddenField ID="hdnMaxQuantity" runat="server" Value='<%# Eval("Quantity") %>' />
                                            <asp:HiddenField ID="hdnCartId" runat="server" Value='<%# Eval("CartId") %>' />
                                            <asp:HiddenField ID="hdnProductId" runat="server" Value='<%# Eval("ProductId") %>' />
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                 
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label>Wybierz stolik docelowy:</label>
                            <asp:DropDownList ID="ddlTargetTable" runat="server" CssClass="form-control" DataTextField="TableId" DataValueField="TableId">
                            </asp:DropDownList>
                        </div>
                        
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Anuluj</button>
                <asp:Button ID="btnConfirmSplit" runat="server" Text="Potwierdź podział" CssClass="btn btn-primary" OnClick="btnConfirmSplit_Click" />
            </div>
        </div>
    </div>
</div>

</asp:Content>
