using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Ordering_Project.User
{
    public partial class Order : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;
        decimal grandTotal = 0;

        public int CurrentTableId
        {
            get => ViewState["CurrentTableId"] != null ? (int)ViewState["CurrentTableId"] : 0;
            set => ViewState["CurrentTableId"] = value;
        }

        private int CurrentOrderDetailsId
        {
            get => ViewState["CurrentOrderDetailsId"] != null ? (int)ViewState["CurrentOrderDetailsId"] : 0;
            set => ViewState["CurrentOrderDetailsId"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            InitializeOrderData();

            if (!IsPostBack)
            {
                LoadPageData();
            }
        }

        private void InitializeOrderData()
        {
            if (!string.IsNullOrEmpty(Request.QueryString["TableId"]))
            {
                CurrentTableId = Convert.ToInt32(Request.QueryString["TableId"]);
                lblTableNumber.Text = $"Stolik nr {CurrentTableId}";

                if (!string.IsNullOrEmpty(Request.QueryString["OrderDetailsId"]))
                {
                    CurrentOrderDetailsId = Convert.ToInt32(Request.QueryString["OrderDetailsId"]);
                }
                else
                {
                    using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
                    {
                        con.Open();
                        SqlCommand cmd = new SqlCommand(
                            @"SELECT TOP 1 OrderDetailsId 
                      FROM Orders 
                      WHERE TableId = @TableId 
                        AND Status = 'InProgress' 
                        AND UserId = @UserId",
                            con);
                        cmd.Parameters.AddWithValue("@TableId", CurrentTableId);
                        cmd.Parameters.AddWithValue("@UserId", Convert.ToInt32(Session["userId"]));

                        object result = cmd.ExecuteScalar();
                        CurrentOrderDetailsId = result != null ? Convert.ToInt32(result) : 0;
                    }
                }

                System.Diagnostics.Debug.WriteLine($"Initialized - TableId: {CurrentTableId}, OrderDetailsId: {CurrentOrderDetailsId}");
            }
        }

        private void LoadPageData()
        {
            getCategories();
            getProducts();
            getCartItems();
        }

        void getCategories()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Select * from Categories where IsActive = 1", con);
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            rCategories.DataSource = dt;
            rCategories.DataBind();
        }

        void getProducts()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Select p.*,c.Name as CategoryName from Products p inner join Categories c on c.CategoryId = p.CategoryId where p.IsActive = 1", con);
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            rProducts.DataSource = dt;
            rProducts.DataBind();
        }

        public string LowerCase(object obj)
        {
            return obj.ToString().ToLower();
        }

        protected void rProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "addToCart")
            {
                TextBox txtComment = (TextBox)e.Item.FindControl("txtProductComment");
                string comment = txtComment != null ? txtComment.Text.Trim() : null;
                AddToCart(Convert.ToInt32(e.CommandArgument), comment);
            }
        }

        protected void AddToCart(int productId, string comment = null)
        {
            CurrentTableId = Request.QueryString["TableId"] != null
                ? Convert.ToInt32(Request.QueryString["TableId"])
                : 0;

            CurrentOrderDetailsId = Request.QueryString["OrderDetailsId"] != null
                ? Convert.ToInt32(Request.QueryString["OrderDetailsId"])
                : 0;

            if (CurrentTableId <= 0 || CurrentOrderDetailsId <= 0)
            {
                ShowMessage("Proszę najpierw wybrać stolik", "danger");
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("Cart_Crud", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Action", "INSERT");
                    cmd.Parameters.AddWithValue("@ProductId", productId);
                    cmd.Parameters.AddWithValue("@Quantity", 1);
                    cmd.Parameters.AddWithValue("@UserId", Convert.ToInt32(Session["userId"]));
                    cmd.Parameters.AddWithValue("@OrderDetailsId", CurrentOrderDetailsId);
                    cmd.Parameters.AddWithValue("@TableId", CurrentTableId);
                    cmd.Parameters.AddWithValue("@Comment", !string.IsNullOrEmpty(comment) ? (object)comment : DBNull.Value);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            if (reader["OrderDetailsId"] != DBNull.Value)
                            {
                                CurrentOrderDetailsId = Convert.ToInt32(reader["OrderDetailsId"]);
                            }
                            ShowMessage("Produkt dodany do koszyka", "success");
                        }
                    }
                    getCartItems();
                }
            }
            catch (Exception ex)
            {
                ShowMessage($"Błąd: {ex.Message}", "danger");
            }
        }

        private void getCartItems()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Cart_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT");
            cmd.Parameters.AddWithValue("@OrderDetailsId", CurrentOrderDetailsId);
            cmd.Parameters.AddWithValue("@TableId", CurrentTableId);
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            rCartItem.DataSource = dt;

            if (dt.Rows.Count == 0)
            {
                rCartItem.FooterTemplate = null;
                rCartItem.FooterTemplate = new CustomTemplate(ListItemType.Footer);
            }

            rCartItem.DataBind();
        }

        protected void rCartItem_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "remove":
                    RemoveCartItem(Convert.ToInt32(e.CommandArgument));
                    break;
                case "updateCart":
                    UpdateCart();
                    break;
                case "checkout":
                    CheckoutOrder();
                    break;
                case "increase":
                    UpdateQuantity(Convert.ToInt32(e.CommandArgument), 1);
                    break;
                case "decrease":
                    UpdateQuantity(Convert.ToInt32(e.CommandArgument), -1);
                    break;
            }
        }

        private void UpdateQuantity(int productId, int change)
        {
            int currentQuantity = GetCartItemQuantity(productId);
            int newQuantity = currentQuantity + change;

            if (newQuantity < 1)
            {
                RemoveCartItem(productId);
                return;
            }

            UpdateCartItemQuantity(productId, newQuantity);
            getCartItems();
        }

        private int GetCartItemQuantity(int productId)
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                cmd = new SqlCommand("Cart_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "GETBYID");
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.Parameters.AddWithValue("@OrderDetailsId", CurrentOrderDetailsId);
                cmd.CommandType = CommandType.StoredProcedure;
                sda = new SqlDataAdapter(cmd);
                dt = new DataTable();
                sda.Fill(dt);
                return dt.Rows.Count > 0 ? Convert.ToInt32(dt.Rows[0]["Quantity"]) : 0;
            }
        }

        private void UpdateCartItemQuantity(int productId, int newQuantity)
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                try
                {
                    con.Open();
                    cmd = new SqlCommand("Cart_Crud", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Action", "UPDATEQUANTITY");
                    cmd.Parameters.AddWithValue("@ProductId", productId);
                    cmd.Parameters.AddWithValue("@Quantity", newQuantity);
                    cmd.Parameters.AddWithValue("@OrderDetailsId", CurrentOrderDetailsId);
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error updating quantity: " + ex.Message, "danger");
                }
            }
        }

        

        private void RemoveCartItem(int productId)
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                try
                {
                    con.Open();
                    cmd = new SqlCommand("Cart_Crud", con);
                    cmd.Parameters.AddWithValue("@Action", "DELETE");
                    cmd.Parameters.AddWithValue("@ProductId", productId);
                    cmd.Parameters.AddWithValue("@OrderDetailsId", CurrentOrderDetailsId);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.ExecuteNonQuery();
                    getCartItems();
                    ShowMessage("Produkt usunięty z koszyka!", "warning");
                }
                catch (Exception ex)
                {
                    ShowMessage("Błąd - " + ex.Message, "danger");
                }
            }
        }

        private void UpdateCart()
        {
            bool hasError = false;

            foreach (RepeaterItem item in rCartItem.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    TextBox quantity = item.FindControl("txtQuantity") as TextBox;
                    TextBox comment = item.FindControl("txtComment") as TextBox;
                    HiddenField productId = item.FindControl("hdnProductId") as HiddenField;

                    if (productId != null && int.TryParse(quantity?.Text, out int newQuantity))
                    {
                        try
                        {
                            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
                            {
                                con.Open();
                                cmd = new SqlCommand("Cart_Crud", con);
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.AddWithValue("@Action", "UPDATE");
                                cmd.Parameters.AddWithValue("@ProductId", Convert.ToInt32(productId.Value));
                                cmd.Parameters.AddWithValue("@Quantity", newQuantity);
                                cmd.Parameters.AddWithValue("@OrderDetailsId", CurrentOrderDetailsId);
                                cmd.Parameters.AddWithValue("@Comment", !string.IsNullOrEmpty(comment?.Text) ? (object)comment.Text : DBNull.Value);
                                cmd.ExecuteNonQuery();
                            }
                        }
                        catch
                        {
                            hasError = true;
                        }
                    }
                }
            }

            getCartItems();
            ShowMessage(hasError ? "Nie udało się zaktualizować niektórych produktów" : "Koszyk zaktualizowany pomyślnie!",
                       hasError ? "danger" : "success");
        }

        private void CheckoutOrder()
        {
            if (ValidateStockAvailability())
            {
                // Zapisujemy wszystkie zmiany przed przejściem do płatności
                UpdateCart();

                // Oznaczamy zamówienie jako zakończone
                using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
                {
                    con.Open();
                    cmd = new SqlCommand("UPDATE Orders SET Status = 'Completed' WHERE OrderDetailsId = @OrderDetailsId", con);
                    cmd.Parameters.AddWithValue("@OrderDetailsId", CurrentOrderDetailsId);
                    cmd.ExecuteNonQuery();
                }

                Response.Redirect($"Payment.aspx?OrderDetailsId={CurrentOrderDetailsId}&TableId={CurrentTableId}");
            }
        }

        private bool ValidateStockAvailability()
        {
            foreach (RepeaterItem item in rCartItem.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    HiddenField cartQuantity = item.FindControl("hdnQuantity") as HiddenField;
                    HiddenField productQuantity = item.FindControl("hdnPrdQuantity") as HiddenField;
                    Label productName = item.FindControl("lblName") as Label;

                    if (Convert.ToInt32(cartQuantity.Value) > Convert.ToInt32(productQuantity.Value))
                    {
                        ShowMessage($"Produkt '{productName.Text}' jest niedostępny w żądanej ilości!", "warning");
                        return false;
                    }
                }
            }
            return true;
        }

        protected void rCartItem_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Label totalPrice = e.Item.FindControl("lblTotalPrice") as Label;
                Label productPrice = e.Item.FindControl("lblPrice") as Label;
                TextBox quantity = e.Item.FindControl("txtQuantity") as TextBox;

                decimal calTotalPrice = Convert.ToDecimal(productPrice.Text) * Convert.ToDecimal(quantity.Text);
                totalPrice.Text = calTotalPrice.ToString();
                grandTotal += calTotalPrice;
            }

            Session["grndTotalPrice"] = grandTotal;
        }

        protected void lbBackToTables_Click(object sender, EventArgs e)
        {
            // Zapisujemy zmiany przed powrotem do listy stolików
            UpdateCart();
            Response.Redirect("Table.aspx");
        }

        protected void lbCompleteOrder_Click(object sender, EventArgs e)
        {
            CheckoutOrder();
        }

        private void ShowMessage(string message, string type)
        {
            lblMsg.Visible = true;
            lblMsg.Text = message;
            lblMsg.CssClass = $"alert alert-{type}";
        }

        private sealed class CustomTemplate : ITemplate
        {
            private ListItemType ListItemType { get; set; }

            public CustomTemplate(ListItemType type)
            {
                ListItemType = type;
            }

            public void InstantiateIn(Control container)
            {
                if (ListItemType == ListItemType.Footer)
                {
                   
                }
            }
        }
        protected void lbSplitBill_Click(object sender, EventArgs e)
        {
            if (CurrentOrderDetailsId <= 0)
            {
                ShowMessage("Proszę najpierw utworzyć zamówienie", "warning");
                return;
            }

            LoadProductsForSplitting();
            LoadAvailableTables();

            ScriptManager.RegisterStartupScript(this, this.GetType(), "showSplitModal",
                "$(function() { $('#splitBillModal').modal('show'); });", true);
        }

        protected void rProductsToSplit_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                TextBox txtQuantity = (TextBox)e.Item.FindControl("txtSplitQuantity");
                HiddenField hdnMaxQuantity = (HiddenField)e.Item.FindControl("hdnMaxQuantity");

                if (txtQuantity != null && hdnMaxQuantity != null)
                {
                    txtQuantity.Attributes["max"] = hdnMaxQuantity.Value;
                }
            }
        }

        private void LoadProductsForSplitting()
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT c.CartId, p.Name, c.Quantity, c.ProductId
            FROM Carts c
            INNER JOIN Products p ON c.ProductId = p.ProductId
            WHERE c.OrderDetailsId = @OrderDetailsId", con);
                cmd.Parameters.AddWithValue("@OrderDetailsId", CurrentOrderDetailsId);

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);

                rProductsToSplit.DataSource = dt;
                rProductsToSplit.DataBind();
            }
        }


        private void LoadAvailableTables()
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT t.TableId 
            FROM Tables t
            LEFT JOIN Orders o ON t.TableId = o.TableId AND o.Status = 'InProgress'
            WHERE o.OrderDetailsId IS NULL OR o.OrderDetailsId = @CurrentOrderId
            ORDER BY t.TableId", con);
                cmd.Parameters.AddWithValue("@CurrentOrderId", CurrentOrderDetailsId);

                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                sda.Fill(dt);

                ddlTargetTable.DataSource = dt;
                ddlTargetTable.DataBind();

                // Dodaj opcję dla nowego stolika
                ddlTargetTable.Items.Insert(0, new ListItem("-- Wybierz stolik --", "0"));
            }
        }

        protected void btnConfirmSplit_Click(object sender, EventArgs e)
        {
            int targetTableId;

            // Sprawdź czy wybrano istniejący stolik czy nowy
            if (ddlTargetTable.SelectedValue != "0" && !string.IsNullOrEmpty(ddlTargetTable.SelectedValue))
            {
                targetTableId = Convert.ToInt32(ddlTargetTable.SelectedValue);
            }
            else if (!string.IsNullOrEmpty(txtNewTableNumber.Text))
            {
                targetTableId = Convert.ToInt32(txtNewTableNumber.Text);
            }
            else
            {
                ShowMessage("Proszę wybrać stolik docelowy lub podać nowy numer", "danger");
                return;
            }

            // Utwórz nowe zamówienie
            int newOrderId = CreateNewOrder(targetTableId);

            // Przenieś wybrane produkty
            MoveProductsToNewOrder(newOrderId);

            // Odśwież stronę
            Response.Redirect($"Order.aspx?TableId={CurrentTableId}&OrderDetailsId={CurrentOrderDetailsId}");
        }

        private int CreateNewOrder(int tableId)
        {
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(
                    @"INSERT INTO Orders (TableId, Status, OrderDate, UserId)
              VALUES (@TableId, 'InProgress', GETDATE(), @UserId);
              SELECT SCOPE_IDENTITY();", con);
                cmd.Parameters.AddWithValue("@TableId", tableId);
                cmd.Parameters.AddWithValue("@UserId", Convert.ToInt32(Session["userId"]));

                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }


        private void MoveProductsToNewOrder(int newOrderId)
        {
            List<CartItemToMove> itemsToMove = new List<CartItemToMove>();

            // Zbierz informacje o produktach do przeniesienia
            foreach (RepeaterItem item in rProductsToSplit.Items)
            {
                CheckBox cbSelect = (CheckBox)item.FindControl("cbSelectProduct");
                if (cbSelect != null && cbSelect.Checked)
                {
                    TextBox txtQuantity = (TextBox)item.FindControl("txtSplitQuantity");
                    HiddenField hdnCartId = (HiddenField)item.FindControl("hdnCartId");
                    HiddenField hdnProductId = (HiddenField)item.FindControl("hdnProductId");
                    HiddenField hdnMaxQuantity = (HiddenField)item.FindControl("hdnMaxQuantity");

                    int quantityToMove = Convert.ToInt32(txtQuantity.Text);
                    int maxQuantity = Convert.ToInt32(hdnMaxQuantity.Value);

                    if (quantityToMove <= 0 || quantityToMove > maxQuantity)
                    {
                        ShowMessage($"Nieprawidłowa ilość dla produktu", "danger");
                        return;
                    }

                    itemsToMove.Add(new CartItemToMove
                    {
                        CartId = Convert.ToInt32(hdnCartId.Value),
                        ProductId = Convert.ToInt32(hdnProductId.Value),
                        Quantity = quantityToMove,
                        MaxQuantity = maxQuantity
                    });
                }
            }

            if (itemsToMove.Count == 0)
            {
                ShowMessage("Nie wybrano żadnych produktów do przeniesienia", "warning");
                return;
            }

            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                con.Open();
                SqlTransaction transaction = con.BeginTransaction();

                try
                {
                    foreach (var item in itemsToMove)
                    {
                        // 1. Dodaj produkt do nowego zamówienia
                        SqlCommand insertCmd = new SqlCommand(
                            @"INSERT INTO Carts (ProductId, Quantity, UserId, OrderDetailsId)
                      VALUES (@ProductId, @Quantity, @UserId, @NewOrderId)", con, transaction);
                        insertCmd.Parameters.AddWithValue("@ProductId", item.ProductId);
                        insertCmd.Parameters.AddWithValue("@Quantity", item.Quantity);
                        insertCmd.Parameters.AddWithValue("@UserId", Convert.ToInt32(Session["userId"]));
                        insertCmd.Parameters.AddWithValue("@NewOrderId", newOrderId);
                        insertCmd.ExecuteNonQuery();

                        // 2. Aktualizuj ilość w starym zamówieniu
                        if (item.Quantity == item.MaxQuantity)
                        {
                            // Usuń cały produkt jeśli przenosimy wszystko
                            SqlCommand deleteCmd = new SqlCommand(
                                @"DELETE FROM Carts 
                          WHERE CartId = @CartId", con, transaction);
                            deleteCmd.Parameters.AddWithValue("@CartId", item.CartId);
                            deleteCmd.ExecuteNonQuery();
                        }
                        else
                        {
                            // Zmniejsz ilość
                            SqlCommand updateCmd = new SqlCommand(
                                @"UPDATE Carts 
                          SET Quantity = Quantity - @Quantity 
                          WHERE CartId = @CartId", con, transaction);
                            updateCmd.Parameters.AddWithValue("@Quantity", item.Quantity);
                            updateCmd.Parameters.AddWithValue("@CartId", item.CartId);
                            updateCmd.ExecuteNonQuery();
                        }
                    }

                    transaction.Commit();
                    ShowMessage($"Pomyślnie podzielono rachunek. Nowe zamówienie: {newOrderId}", "success");
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    ShowMessage($"Błąd podczas przenoszenia produktów: {ex.Message}", "danger");
                }
            }
        }


        // Klasa pomocnicza do przechowywania informacji o produktach do przeniesienia
        public class CartItemToMove
        {
            public int CartId { get; set; }
            public int ProductId { get; set; }
            public int Quantity { get; set; }
            public int MaxQuantity { get; set; }
        }

    }
}