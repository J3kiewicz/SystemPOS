using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Ordering_Project.Admin
{
    public partial class Products : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["breadCrum"] = "Product";
                if (Session["admin"] == null)
                {
                    Response.Redirect("../User/Default.aspx");
                }
                else
                {
                    getProducts();
                }
            }
            lblMsg.Visible = false;
        }

        private void getProducts()
        {
            try
            {
                con = new SqlConnection(Connection.GetConnectionString());
                cmd = new SqlCommand("Product_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "SELECT");
                cmd.CommandType = CommandType.StoredProcedure;
                sda = new SqlDataAdapter(cmd);
                dt = new DataTable();
                sda.Fill(dt);
                rProduct.DataSource = dt;
                rProduct.DataBind();
            }
            catch (Exception ex)
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Błąd podczas ładowania produktów: " + ex.Message;
                lblMsg.CssClass = "alert alert-danger";
            }
        }

        protected void btnAddOrUpdate_Click(object sender, EventArgs e)
        {
            string imagePath = string.Empty;
            bool isValidToExecute = false;
            int productId = Convert.ToInt32(hdnId.Value);

            try
            {
                con = new SqlConnection(Connection.GetConnectionString());
                cmd = new SqlCommand("Product_Crud", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Action", productId == 0 ? "INSERT" : "UPDATE");
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@Price", txtPrice.Text.Trim());
                cmd.Parameters.AddWithValue("@CategoryId", ddlCategories.SelectedValue);
                cmd.Parameters.AddWithValue("@IsActive", cbIsActive.Checked);

                if (fuProductImage.HasFile)
                {
                    if (Utils.IsValidExtension(fuProductImage.FileName))
                    {
                        Guid obj = Guid.NewGuid();
                        string fileExtension = Path.GetExtension(fuProductImage.FileName);
                        imagePath = "Images/Product/" + obj.ToString() + fileExtension;
                        fuProductImage.PostedFile.SaveAs(Server.MapPath("~/Images/Product/") + obj.ToString() + fileExtension);
                        cmd.Parameters.AddWithValue("@ImageUrl", imagePath);
                        isValidToExecute = true;
                    }
                    else
                    {
                        lblMsg.Visible = true;
                        lblMsg.Text = "Proszę wybrać obrazek w formacie .jpg, .jpeg lub .png";
                        lblMsg.CssClass = "alert alert-danger";
                        return;
                    }
                }
                else
                {
                    // Jeśli aktualizacja i nie wybrano nowego obrazka, zachowaj istniejący
                    if (productId > 0)
                    {
                        cmd.Parameters.AddWithValue("@ImageUrl", imgProduct.ImageUrl.Replace("../", ""));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@ImageUrl", DBNull.Value);
                    }
                    isValidToExecute = true;
                }

                if (isValidToExecute)
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    lblMsg.Visible = true;
                    lblMsg.Text = $"Produkt {(productId == 0 ? "dodany" : "zaktualizowany")} pomyślnie!";
                    lblMsg.CssClass = "alert alert-success";
                    getProducts();
                    clear();
                }
            }
            catch (Exception ex)
            {
                lblMsg.Visible = true;
                lblMsg.Text = "Błąd: " + ex.Message;
                lblMsg.CssClass = "alert alert-danger";
            }
            finally
            {
                con.Close();
            }
        }

        protected void rProduct_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblMsg.Visible = false;
            if (e.CommandName == "edit")
            {
                try
                {
                    con = new SqlConnection(Connection.GetConnectionString());
                    cmd = new SqlCommand("Product_Crud", con);
                    cmd.Parameters.AddWithValue("@Action", "GETBYID");
                    cmd.Parameters.AddWithValue("@ProductId", e.CommandArgument);
                    cmd.CommandType = CommandType.StoredProcedure;
                    sda = new SqlDataAdapter(cmd);
                    dt = new DataTable();
                    sda.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        txtName.Text = dt.Rows[0]["Name"].ToString();
                        txtPrice.Text = dt.Rows[0]["Price"].ToString();
                        ddlCategories.SelectedValue = dt.Rows[0]["CategoryId"].ToString();
                        cbIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"]);
                        imgProduct.ImageUrl = string.IsNullOrEmpty(dt.Rows[0]["ImageUrl"].ToString())
                            ? "../Images/No_image.png"
                            : "../" + dt.Rows[0]["ImageUrl"].ToString();
                        imgProduct.Height = 200;
                        imgProduct.Width = 200;
                        hdnId.Value = dt.Rows[0]["ProductId"].ToString();
                        btnAddOrUpdate.Text = "Zaktualizuj";
                    }
                }
                catch (Exception ex)
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Błąd podczas ładowania produktu: " + ex.Message;
                    lblMsg.CssClass = "alert alert-danger";
                }
            }
            else if (e.CommandName == "delete")
            {
                try
                {
                    con = new SqlConnection(Connection.GetConnectionString());
                    cmd = new SqlCommand("Product_Crud", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Action", "DELETE");
                    cmd.Parameters.AddWithValue("@ProductId", e.CommandArgument);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    lblMsg.Visible = true;
                    lblMsg.Text = "Produkt usunięty pomyślnie!";
                    lblMsg.CssClass = "alert alert-success";
                    getProducts();
                }
                catch (Exception ex)
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Błąd: " + ex.Message;
                    lblMsg.CssClass = "alert alert-danger";
                }
                finally
                {
                    con.Close();
                }
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            clear();
        }

        private void clear()
        {
            txtName.Text = string.Empty;
            txtPrice.Text = string.Empty;
            ddlCategories.ClearSelection();
            cbIsActive.Checked = false;
            imgProduct.ImageUrl = "../Images/No_image.png";
            hdnId.Value = "0";
            btnAddOrUpdate.Text = "Dodaj";
        }
    }
}