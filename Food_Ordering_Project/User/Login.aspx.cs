using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Ordering_Project.User
{
    public partial class Login : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        // Deklaracje kontrolek
        protected TextBox txtPin1;
        protected TextBox txtPin2;
        protected TextBox txtPin3;
        protected TextBox txtPin4;
        protected HiddenField hfPassword;
        protected Label lblMsg;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userId"] != null)
            {
                Response.Redirect("Table.aspx");
            }

            // Ensure ContentPlaceHolder1 is properly referenced
            ContentPlaceHolder contentPlaceHolder = (ContentPlaceHolder)this.Master.FindControl("ContentPlaceHolder1");

            if (contentPlaceHolder != null)
            {
                // Initialize controls within the ContentPlaceHolder
                txtPin1 = (TextBox)contentPlaceHolder.FindControl("txtPin1");
                txtPin2 = (TextBox)contentPlaceHolder.FindControl("txtPin2");
                txtPin3 = (TextBox)contentPlaceHolder.FindControl("txtPin3");
                txtPin4 = (TextBox)contentPlaceHolder.FindControl("txtPin4");
                hfPassword = (HiddenField)contentPlaceHolder.FindControl("hfPassword");
                lblMsg = (Label)contentPlaceHolder.FindControl("lblMsg");
            }
            else
            {
                throw new Exception("ContentPlaceHolder1 not found in the Master Page.");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // Pobieramy PIN z pól tekstowych
            string pin = txtPin1.Text + txtPin2.Text + txtPin3.Text + txtPin4.Text;

            if (string.IsNullOrEmpty(pin) || pin.Length != 4)
            {
                ShowError("Please enter a 4-digit PIN code");
                return;
            }

            // Check for admin PIN (e.g., 0000)
            if (pin == "0000")
            {
                Session["admin"] = "Admin";
                Response.Redirect("../Admin/Dashboard.aspx");
                return;
            }

            // Check for user PIN in database
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("User_Crud", con);
            cmd.Parameters.AddWithValue("@Action", "SELECT_BY_PIN");
            cmd.Parameters.AddWithValue("@Password", pin);
            cmd.CommandType = CommandType.StoredProcedure;

            try
            {
                sda = new SqlDataAdapter(cmd);
                dt = new DataTable();
                sda.Fill(dt);

                if (dt.Rows.Count == 1)
                {
                    Session["username"] = dt.Rows[0]["Username"].ToString();
                    Session["userId"] = dt.Rows[0]["UserId"];
                    Response.Redirect("Table.aspx");
                }
                else
                {
                    ShowError("Invalid PIN code. Please try again.");
                    ClearPin();
                }
            }
            catch (Exception ex)
            {
                ShowError("Error during login: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            lblMsg.Visible = true;
            lblMsg.Text = message;
            lblMsg.CssClass = "alert alert-danger";
        }

        private void ClearPin()
        {
            txtPin1.Text = "";
            txtPin2.Text = "";
            txtPin3.Text = "";
            txtPin4.Text = "";
            txtPin1.Focus();
        }
    }
}