<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Order.aspx.cs" Inherits="Food_Ordering_Project.User.Order" %>
<%@ Import Namespace="Food_Ordering_Project" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>

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

        // Obsługa kliknięcia kategorii
        $(document).ready(function () {
            $('.filters_menu li').click(function () {
                // Usuń klasę active ze wszystkich elementów
                $('.filters_menu li').removeClass('active');
                // Dodaj klasę active do klikniętego elementu
                $(this).addClass('active');

                // Pobierz wartość filtra
                var filterValue = $(this).attr('data-filter');
                var categoryId = $(this).attr('data-id');

                // Filtruj produkty
                $('.grid .all').hide();
                $('.grid').find('div' + filterValue).show(); // Dodaj 'div' przed filtrem
       
                // Możesz też wysłać to do serwera, jeśli potrzebujesz
                // __doPostBack('', categoryId);
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

        // Handle the button click
        $(document).ready(function () {
            $('.btn-split-bill').click(function (e) {
                e.preventDefault();
                __doPostBack('<%= lbSplitBill.UniqueID %>', '');
    });
        });

        // Funkcja do dodawania produktów do koszyka
        function addProductToCart(event, productId) {
            event.preventDefault();
            // Symuluj kliknięcie przycisku dodania do koszyka
            __doPostBack('<%= rProducts.UniqueID %>', 'addToCart$' + productId);

    // Efekt wizualny
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
            <section class="food_section layout_padding" style="background-image: url('../Images/chefCap3.png'); width: 100%; height:100%; background-repeat:no-repeat; 
                background-size: contain; background-attachment:fixed; background-position:left">
                <div class="container">
                    <div class="heading_container heading_center">
                        <div class="align-self-end">
                            <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
                        </div>
                        <h2>Nasze Menu</h2>
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
                                                    <p><%# Eval("Description") %></p>
                                                    
                                                    <div class="options">
                                                        <h6>₹<%# Eval("Price") %></h6>
                                                        <asp:LinkButton ID="lbAddToCart" runat="server" CommandName="addToCart" 
                                                            CommandArgument='<%# Eval("ProductId") %>'>
                                                            <svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 456.029 456.029" style="enable-background: new 0 0 456.029 456.029;" xml:space="preserve">
                                                                <g>
                                                                    <g>
                                                                        <path d="M345.6,338.862c-29.184,0-53.248,23.552-53.248,53.248c0,29.184,23.552,53.248,53.248,53.248
                                                                    c29.184,0,53.248-23.552,53.248-53.248C398.336,362.926,374.784,338.862,345.6,338.862z" />
                                                                    </g>
                                                                </g>
                                                                <g>
                                                                    <g>
                                                                        <path d="M439.296,84.91c-1.024,0-2.56-0.512-4.096-0.512H112.64l-5.12-34.304C104.448,27.566,84.992,10.67,61.952,10.67H20.48
                                                                    C9.216,10.67,0,19.886,0,31.15c0,11.264,9.216,20.48,20.48,20.48h41.472c2.56,0,4.608,2.048,5.12,4.608l31.744,216.064
                                                                    c4.096,27.136,27.648,47.616,55.296,47.616h212.992c26.624,0,49.664-18.944,55.296-45.056l33.28-166.4
                                                                    C457.728,97.71,450.56,86.958,439.296,84.91z" />
                                                                    </g>
                                                                </g>
                                                                <g>
                                                                    <g>
                                                                        <path d="M215.04,389.55c-1.024-28.16-24.576-50.688-52.736-50.688c-29.696,1.536-52.224,26.112-51.2,55.296
                                                                    c1.024,28.16,24.064,50.688,52.224,50.688h1.024C193.536,443.31,216.576,418.734,215.04,389.55z" />
                                                                    </g>
                                                                </g>
                                                            </svg>
                                                        </asp:LinkButton>
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
                        <h2>Twój koszyk</h2>
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
<asp:TextBox ID="txtComment" runat="server" 
    Text='<%# Eval("Comment") %>'
    CssClass="comment-input"
    onkeydown="if(event.keyCode==13){event.preventDefault(); updateCartWithComment(this);}"
    data-productid='<%# Eval("ProductId") %>' />
                                </td>
                                <td>₹<asp:Label ID="lblPrice" runat="server" Text='<%# Eval("Price") %>'></asp:Label>
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
                                <td>₹<asp:Label ID="lblTotalPrice" runat="server"></asp:Label></td>
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
                                <td><b>₹<% Response.Write(Session["grndTotalPrice"]); %></b></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td colspan="2" class="continue__btn">
                                    
                                </td>
                                <td colspan="2">
                                    <asp:LinkButton ID="lbUpdateCart" runat="server" CommandName="updateCart" CssClass="btn btn-warning">
                                        <i class="fa fa-refresh mr-2"></i>Aktualizuj koszyk
                                    </asp:LinkButton>
                                </td>
                                <td colspan="2">
                                    <asp:LinkButton ID="lbCheckout" runat="server" CommandName="checkout" CssClass="btn btn-success">
                                        Zamów<i class="fa fa-arrow-circle-right ml-2"></i>
                                    </asp:LinkButton>
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
                <h5 class="modal-title" id="splitBillModalLabel">Podziel rachunek</h5>
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
                        <div class="form-group">
                            <label>Lub utwórz nowy rachunek na:</label>
                            <asp:TextBox ID="txtNewTableNumber" runat="server" CssClass="form-control" placeholder="Wpisz numer nowego stolika"></asp:TextBox>
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