using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Ordering_Project.Admin
{
    public partial class OrderStatus : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["breadCrum"] = "Historia zamówień";
                if (Session["admin"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
                else
                {
                    GetAllOrders();
                }
            }
        }

        public string GetStatusBadgeClass(string status)
        {
            switch (status)
            {
                case "Completed":
                    return "badge badge-success";
                case "InProgress":
                    return "badge badge-warning";
                case "Pending":
                    return "badge badge-primary";
                case "Cancelled":
                    return "badge badge-danger";
                default:
                    return "badge badge-secondary";
            }
        }

        private void GetAllOrders()
        {
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "GETSTATUS");
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);

            rOrderStatus.DataSource = dt;
            rOrderStatus.DataBind();
        }

        protected void rOrderStatus_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "details")
            {
                string script = $"toggleDetails('details_{e.CommandArgument}');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "toggleDetails", script, true);
            }
        }

        protected void rOrderStatus_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                int orderDetailsId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "OrderDetailsId"));
                Repeater rOrderItems = (Repeater)e.Item.FindControl("rOrderItems");

                if (rOrderItems != null)
                {
                    con = new SqlConnection(Connection.GetConnectionString());
                    cmd = new SqlCommand("Invoice", con);
                    cmd.Parameters.AddWithValue("@Action", "GETORDERITEMS");
                    cmd.Parameters.AddWithValue("@OrderDetailsId", orderDetailsId);
                    cmd.CommandType = CommandType.StoredProcedure;
                    sda = new SqlDataAdapter(cmd);
                    dt = new DataTable();
                    sda.Fill(dt);

                    rOrderItems.DataSource = dt;
                    rOrderItems.DataBind();
                }
            }
        }
    }
}