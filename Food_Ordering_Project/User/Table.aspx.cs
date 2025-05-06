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
            // Tworzymy DataTable z 15 stolikami
            dt = new DataTable();
            dt.Columns.Add("TableId", typeof(int));

            // Dodajemy 15 stolików
            for (int i = 1; i <= 15; i++)
            {
                dt.Rows.Add(i);
            }

            rTables.DataSource = dt;
            rTables.DataBind();
        }

        public string GetTableStatus(int tableId)
        {
            // Sprawdzamy czy stolik ma aktywne zamówienia
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "ORDERSBYTABLE");
            cmd.Parameters.AddWithValue("@TableId", tableId);
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            DataTable dtOrders = new DataTable();
            sda.Fill(dtOrders);

            return dtOrders.Rows.Count > 0 ? "Zajęty" : "Wolny";
        }

        protected void rTables_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectTable")
            {
                int tableId = Convert.ToInt32(e.CommandArgument);

                // Sprawdzamy czy istnieje już zamówienie dla tego stolika
                con = new SqlConnection(Connection.GetConnectionString());
                cmd = new SqlCommand("Invoice", con);
                cmd.Parameters.AddWithValue("@Action", "ORDERSBYTABLE");
                cmd.Parameters.AddWithValue("@TableId", tableId);
                cmd.CommandType = CommandType.StoredProcedure;
                sda = new SqlDataAdapter(cmd);
                DataTable dtOrders = new DataTable();
                sda.Fill(dtOrders);

                int orderDetailsId = 0;

                if (dtOrders.Rows.Count > 0)
                {
                    // Jeśli istnieje zamówienie, używamy jego ID
                    orderDetailsId = Convert.ToInt32(dtOrders.Rows[0]["OrderDetailsId"]);
                }
                else
                {
                    // Jeśli nie ma zamówienia, tworzymy nowe
                    cmd = new SqlCommand("Cart_Crud", con);
                    cmd.Parameters.AddWithValue("@Action", "INSERT");
                    cmd.Parameters.AddWithValue("@TableId", tableId);
                    cmd.Parameters.AddWithValue("@ProductId", DBNull.Value);
                    cmd.Parameters.AddWithValue("@Quantity", DBNull.Value);
                    cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
                    cmd.CommandType = CommandType.StoredProcedure;

                    try
                    {
                        con.Open();
                        SqlDataReader dr = cmd.ExecuteReader();
                        if (dr.Read())
                        {
                            orderDetailsId = Convert.ToInt32(dr["OrderDetailsId"]);
                        }
                        dr.Close();
                    }
                    finally
                    {
                        con.Close();
                    }
                }

                // Przekierowujemy do Order.aspx z parametrami
                Response.Redirect($"Order.aspx?TableId={tableId}&OrderDetailsId={orderDetailsId}");
            }
        }
    }
}