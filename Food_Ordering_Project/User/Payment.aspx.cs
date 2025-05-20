using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Food_Ordering_Project.User
{
    public partial class Payment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }
        protected void CompletePayment(string paymentMode)
        {
            // Pobierz ID zamówienia i stolika z sesji lub query string
            int orderDetailsId = Session["CurrentOrderDetailsId"] != null ?
                (int)Session["CurrentOrderDetailsId"] :
                (Request.QueryString["OrderDetailsId"] != null ?
                    Convert.ToInt32(Request.QueryString["OrderDetailsId"]) : 0);

            int tableId = Session["CurrentTableId"] != null ?
                (int)Session["CurrentTableId"] :
                (Request.QueryString["TableId"] != null ?
                    Convert.ToInt32(Request.QueryString["TableId"]) : 0);

            if (orderDetailsId == 0 || tableId == 0)
            {
                ShowError("Brak aktywnego zamówienia! Proszę wrócić do wyboru stolika.");
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
                {
                    con.Open();
                    using (SqlTransaction transaction = con.BeginTransaction())
                    {
                        try
                        {
                            // 1. Sprawdź czy zamówienie istnieje i nie jest zakończone
                            SqlCommand checkCmd = new SqlCommand(
                                @"SELECT 1 FROM Orders 
                          WHERE OrderDetailsId = @OrderDetailsId 
                          AND TableId = @TableId
                          AND (Status IS NULL OR Status != 'Completed')",
                                con, transaction);
                            checkCmd.Parameters.AddWithValue("@OrderDetailsId", orderDetailsId);
                            checkCmd.Parameters.AddWithValue("@TableId", tableId);

                            if (checkCmd.ExecuteScalar() == null)
                            {
                                throw new Exception("Aktywne zamówienie nie istnieje lub zostało już zakończone");
                            }

                            // 2. Dodaj płatność (POPRAWIONE - zgodnie ze strukturą tabeli)
                            SqlCommand paymentCmd = new SqlCommand(
                                @"INSERT INTO Payment (PaymentMode) 
                          OUTPUT INSERTED.PaymentId 
                          VALUES (@Mode)",
                                con, transaction);
                            paymentCmd.Parameters.AddWithValue("@Mode", paymentMode);
                            int paymentId = (int)paymentCmd.ExecuteScalar();

                            // 3. Zaktualizuj status zamówienia
                            SqlCommand orderCmd = new SqlCommand(
                                @"UPDATE Orders SET 
                            Status = 'Completed',
                            PaymentId = @PaymentId,
                            OrderDate = GETDATE() -- Używamy OrderDate zamiast CompletionDate
                          WHERE OrderDetailsId = @OrderDetailsId",
                                con, transaction);
                            orderCmd.Parameters.AddWithValue("@OrderDetailsId", orderDetailsId);
                            orderCmd.Parameters.AddWithValue("@PaymentId", paymentId);

                            if (orderCmd.ExecuteNonQuery() == 0)
                            {
                                throw new Exception("Nie udało się zaktualizować zamówienia");
                            }

                            // 4. Zwolnij stolik
                            SqlCommand tableCmd = new SqlCommand(
                                @"UPDATE Tables SET IsActive = 1 
                          WHERE TableId = @TableId",
                                con, transaction);
                            tableCmd.Parameters.AddWithValue("@TableId", tableId);
                            tableCmd.ExecuteNonQuery();

                            transaction.Commit();

                            // 5. Wyczyść sesję i przekieruj
                            Session["CurrentOrderDetailsId"] = null;
                            Session["CurrentTableId"] = null;

                            ScriptManager.RegisterStartupScript(this, GetType(), "paymentComplete",
                                @"alert('Płatność zakończona pomyślnie! Dane zamówienia zostały zachowane.');
                          setTimeout(function(){ window.location = 'Table.aspx'; }, 1000);",
                                true);
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            ShowError($"Błąd płatności: {ex.Message}");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError($"Błąd systemu: {ex.Message}");
            }
        }
        private void ShowError(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showerror",
                $"alert('{message.Replace("'", "\\'")}');", true);
        }

        protected void btnCard_Click(object sender, EventArgs e) => CompletePayment("card");
        protected void btnCash_Click(object sender, EventArgs e) => CompletePayment("cash");
    }
}