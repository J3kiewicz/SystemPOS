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
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "ORDERSBYTABLE");
            cmd.Parameters.AddWithValue("@TableId", tableId);
            cmd.CommandType = CommandType.StoredProcedure;

            try
            {
                con.Open();
                var result = cmd.ExecuteScalar();
                return result != null ? "Zajęty" : "Wolny";
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
    }
}