using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Ordering_Project.User
{
    public partial class Table : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userId"] == null)
                {
                    Response.Redirect("Login.aspx");
                }
                else
                {
                    LoadTables();
                }
            }
        }

        private void LoadTables()
        {
            // Pobieramy rzeczywiste stoliki z bazy zamiast tworzyć sztuczne
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("SELECT TableId, TableName FROM Tables WHERE IsActive = 1", con);
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            rTables.DataSource = dt;
            rTables.DataBind();
        }

        public string GetTableStatus(int tableId)
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand(@"
        SELECT 
            t.TableId,
            t.TableName,
            SUM(p.Price * c.Quantity) AS TotalAmount,
            COUNT(c.CartId) AS ItemCount
        FROM Tables t
        LEFT JOIN Orders o ON t.TableId = o.TableId AND o.Status = 'InProgress'
        LEFT JOIN Carts c ON o.OrderDetailsId = c.OrderDetailsId
        LEFT JOIN Products p ON c.ProductId = p.ProductId
        WHERE t.TableId = @TableId
        GROUP BY t.TableId, t.TableName", con);
            cmd.Parameters.AddWithValue("@TableId", tableId);

            try
            {
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string busyClass = reader.IsDBNull(2) ? "" : "busy";
                        string statusHtml = $"<div class='table-selector-item {busyClass}'>" +
                                          $"<div class='table-selector-name'>Stolik {reader["TableId"]}</div>";

                        if (!reader.IsDBNull(2)) // Jeśli TotalAmount nie jest NULL (czyli jest rachunek)
                        {
                            statusHtml += $"<div class='table-selector-info table-selector-status-busy'>Rachunek: {Convert.ToDecimal(reader["TotalAmount"]):C}</div>";
                                         
                        }
                        else
                        {
                            statusHtml += "<div class='table-selector-info table-selector-status-free'>Wolny</div>";
                        }

                        statusHtml += "</div>";
                        return statusHtml;
                    }
                    return "<div class='table-selector-item'><div class='table-selector-name'>Błąd</div></div>";
                }
            }
            finally
            {
                con.Close();
            }
        }
        private int _currentTableId = 0;
        private int _currentOrderId = 0;

        // Zmodyfikuj rTables_ItemCommand
        protected void rTables_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectTable")
            {
                _currentTableId = Convert.ToInt32(e.CommandArgument);
                int userId = Convert.ToInt32(Session["userId"]);

                using (con = new SqlConnection(Connection.GetConnectionString()))
                {
                    cmd = new SqlCommand(
                        @"IF EXISTS (SELECT 1 FROM Orders WHERE TableId = @TableId AND Status = 'InProgress')
                  BEGIN
                      SELECT OrderDetailsId FROM Orders WHERE TableId = @TableId AND Status = 'InProgress'
                  END
                  ELSE
                  BEGIN
                      INSERT INTO Orders (TableId, Status, OrderDate, UserId)
                      VALUES (@TableId, 'InProgress', GETDATE(), @UserId)
                      SELECT SCOPE_IDENTITY()
                  END", con);

                    cmd.Parameters.AddWithValue("@TableId", _currentTableId);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    con.Open();
                    _currentOrderId = Convert.ToInt32(cmd.ExecuteScalar());
                    con.Close();
                }

                Session["SelectedTableId"] = _currentTableId;
                Session["SelectedOrderId"] = _currentOrderId;
                Response.Redirect($"Order.aspx?TableId={_currentTableId}&OrderDetailsId={_currentOrderId}");
            }
        }

        protected void rTables_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                int tableId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "TableId"));
                HyperLink hlTable = (HyperLink)e.Item.FindControl("hlTable");
                Label lblStatus = (Label)e.Item.FindControl("lblStatus");

                // Sprawdź czy stolik ma aktywne zamówienie
                using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"SELECT TOP 1 o.Status 
                  FROM Orders o 
                  WHERE o.TableId = @TableId 
                  ORDER BY o.OrderDate DESC", con);
                    cmd.Parameters.AddWithValue("@TableId", tableId);

                    con.Open();
                    string status = cmd.ExecuteScalar()?.ToString();

                    if (status == "InProgress")
                    {
                        lblStatus.Text = "Zajęty";
                        lblStatus.CssClass = "badge badge-danger";
                        hlTable.NavigateUrl = $"Order.aspx?TableId={tableId}";
                    }
                    else
                    {
                        lblStatus.Text = "Wolny";
                        lblStatus.CssClass = "badge badge-success";
                        hlTable.NavigateUrl = $"Order.aspx?TableId={tableId}&NewOrder=1";
                    }
                }
            }
        }
    }
}