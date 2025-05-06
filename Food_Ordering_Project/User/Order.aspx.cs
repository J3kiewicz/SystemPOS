using System;
using System.Data;
using System.Data.SqlClient;
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
        private int CurrentTableId
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

            InitializeOrderData(); // Wywołuj zawsze, nie tylko przy !IsPostBack

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
                    // Jeśli OrderDetailsId nie było w URL, znajdź istniejące zamówienie
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

                // Debug info
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
                AddToCart(Convert.ToInt32(e.CommandArgument));
            }
        }
        protected void AddToCart(int productId)
        {
            // Pobierz aktualne wartości z sesji lub parametrów URL
            CurrentTableId = Request.QueryString["TableId"] != null
                ? Convert.ToInt32(Request.QueryString["TableId"])
                : 0;

            CurrentOrderDetailsId = Request.QueryString["OrderDetailsId"] != null
                ? Convert.ToInt32(Request.QueryString["OrderDetailsId"])
                : 0;

            // Debugowanie - sprawdź wartości
            System.Diagnostics.Debug.WriteLine($"TableId: {CurrentTableId}, OrderDetailsId: {CurrentOrderDetailsId}");

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
                    cmd.Parameters.AddWithValue("@TableId", CurrentTableId); // Dodane

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Aktualizuj OrderDetailsId jeśli procedura zwróciła nową wartość
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

        private int GetCartItemQuantity(int productId)
        {
            con = new SqlConnection(Connection.GetConnectionString());
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

        private void InsertNewCartItem(int productId)
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Cart_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "INSERT");
            cmd.Parameters.AddWithValue("@ProductId", productId);
            cmd.Parameters.AddWithValue("@Quantity", 1);
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
            cmd.Parameters.AddWithValue("@OrderDetailsId", CurrentOrderDetailsId);
            cmd.CommandType = CommandType.StoredProcedure;

            try
            {
                con.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                ShowMessage("Error - " + ex.Message, "danger");
            }
            finally
            {
                con.Close();
            }
        }

        private void UpdateCartItemQuantity(int productId, int newQuantity)
        {
            Utils utils = new Utils();
            bool isUpdated = utils.updateCartQuantity(newQuantity, productId,
                Convert.ToInt32(Session["userId"]), CurrentOrderDetailsId);

            if (!isUpdated)
            {
                ShowMessage("Failed to update item quantity", "danger");
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
            }
        }

        private void RemoveCartItem(int productId)
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Cart_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "DELETE");
            cmd.Parameters.AddWithValue("@ProductId", productId);
            cmd.Parameters.AddWithValue("@OrderDetailsId", CurrentOrderDetailsId);
            cmd.CommandType = CommandType.StoredProcedure;

            try
            {
                con.Open();
                cmd.ExecuteNonQuery();
                getCartItems();
                ShowMessage("Item removed from cart!", "warning");
            }
            catch (Exception ex)
            {
                ShowMessage("Error - " + ex.Message, "danger");
            }
            finally
            {
                con.Close();
            }
        }
        //private void UpdateUI()
        //{
        //    bool hasTable = CurrentTableId > 0;
        //    lblTableNumber.Text = hasTable ? $"Stolik nr {CurrentTableId}" : "Nie wybrano stolika";
        //    pnlOrderActions.Visible = hasTable;

        //    if (hasTable)
        //    {
        //        getCartItems();
        //    }
        //}
        private void UpdateCart()
        {
            bool hasError = false;

            for (int item = 0; item < rCartItem.Items.Count; item++)
            {
                if (rCartItem.Items[item].ItemType == ListItemType.Item ||
                    rCartItem.Items[item].ItemType == ListItemType.AlternatingItem)
                {
                    TextBox quantity = rCartItem.Items[item].FindControl("txtQuantity") as TextBox;
                    HiddenField productId = rCartItem.Items[item].FindControl("hdnProductId") as HiddenField;

                    if (int.TryParse(quantity.Text, out int newQuantity) && productId != null)
                    {
                        Utils utils = new Utils();
                        bool isUpdated = utils.updateCartQuantity(
                            newQuantity,
                            Convert.ToInt32(productId.Value),
                            Convert.ToInt32(Session["userId"]),
                            CurrentOrderDetailsId);

                        if (!isUpdated) hasError = true;
                    }
                }
            }

            getCartItems();
            ShowMessage(hasError ? "Some items failed to update" : "Cart updated successfully!",
                       hasError ? "danger" : "success");
        }

        private void CheckoutOrder()
        {
            if (ValidateStockAvailability())
            {
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
                        ShowMessage($"Item '{productName.Text}' is out of stock!", "warning");
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
                    var footer = new LiteralControl("<tr><td colspan='5'><b>Your Cart is empty.</b><a href='Menu.aspx' class='badge badge-info ml-2'>Continue Shopping</a></td></tr></tbody></table>");
                    container.Controls.Add(footer);
                }
            }
        }
    }
}