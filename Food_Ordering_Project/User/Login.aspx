<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Food_Ordering_Project.User.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .pin-container {
            display: flex;
            justify-content: center;
            margin: 20px 0;
        }
        .pin-digit {
            width: 50px;
            height: 60px;
            font-size: 24px;
            text-align: center;
            margin: 0 5px;
            border: 2px solid #ddd;
            border-radius: 5px;
        }
        .numpad {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            max-width: 300px;
            margin: 0 auto;
        }
        .numpad-btn {
            padding: 15px;
            font-size: 18px;
            border: none;
            border-radius: 50%;
            background: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s;
        }
        .numpad-btn:hover {
            background: #e9ecef;
            transform: scale(1.05);
        }
        .numpad-btn:active {
            transform: scale(0.95);
        }
        .submit-btn {
            grid-column: span 3;
            padding: 10px;
            border-radius: 25px;
            background: #28a745;
            color: white;
            font-weight: bold;
        }
        .clear-btn {
            background: #dc3545;
            color: white;
        }
    </style>
    <script>
        function appendDigit(digit) {
            const pinInputs = document.querySelectorAll('.pin-digit');
            for (let i = 0; i < pinInputs.length; i++) {
                if (pinInputs[i].value === '') {
                    pinInputs[i].value = digit;
                    if (i < pinInputs.length - 1) pinInputs[i + 1].focus();
                    break;
                }
            }
            updateHiddenField();
        }

        function clearPin() {
            const pinInputs = document.querySelectorAll('.pin-digit');
            pinInputs.forEach(input => {
                input.value = '';
            });
            pinInputs[0].focus();
            updateHiddenField();
        }

        function updateHiddenField() {
            const pinInputs = document.querySelectorAll('.pin-digit');
            let pin = '';
            pinInputs.forEach(input => {
                pin += input.value;
            });
            document.getElementById('<%= hfPassword.ClientID %>').value = pin;
        }

        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%=lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);

            document.querySelector('.pin-digit').focus();
        };

        function moveToNext(current, nextId) {
            if (current.value.length === 1) {
                document.getElementById(nextId).focus();
                updateHiddenField();
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <section class="book_section layout_padding">
        <div class="container">
            <div class="heading_container">
                <div class="align-self-end">
                    <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
                </div>
                <h2>Login with PIN</h2>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="form_container text-center">
                        <img id="userLogin" src="../Images/login.jpg" alt="" class="img-thumbnail" style="max-height: 400px;"/>                  
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form_container">
                        <div class="text-center mb-4">
                            <p>Enter your 4-digit PIN code</p>
                        </div>
                        
                        <div class="pin-container">
                            <asp:TextBox ID="txtPin1" runat="server" CssClass="pin-digit" MaxLength="1" onkeyup="moveToNext(this, 'txtPin2')" autocomplete="off" />
                            <asp:TextBox ID="txtPin2" runat="server" CssClass="pin-digit" MaxLength="1" onkeyup="moveToNext(this, 'txtPin3')" autocomplete="off" />
                            <asp:TextBox ID="txtPin3" runat="server" CssClass="pin-digit" MaxLength="1" onkeyup="moveToNext(this, 'txtPin4')" autocomplete="off" />
                            <asp:TextBox ID="txtPin4" runat="server" CssClass="pin-digit" MaxLength="1" autocomplete="off" />
                            <asp:HiddenField ID="hfPassword" runat="server" />
                        </div>

                        <div class="numpad mt-4">
                            <button type="button" class="numpad-btn" onclick="appendDigit('1')">1</button>
                            <button type="button" class="numpad-btn" onclick="appendDigit('2')">2</button>
                            <button type="button" class="numpad-btn" onclick="appendDigit('3')">3</button>
                            <button type="button" class="numpad-btn" onclick="appendDigit('4')">4</button>
                            <button type="button" class="numpad-btn" onclick="appendDigit('5')">5</button>
                            <button type="button" class="numpad-btn" onclick="appendDigit('6')">6</button>
                            <button type="button" class="numpad-btn" onclick="appendDigit('7')">7</button>
                            <button type="button" class="numpad-btn" onclick="appendDigit('8')">8</button>
                            <button type="button" class="numpad-btn" onclick="appendDigit('9')">9</button>
                            <button type="button" class="numpad-btn clear-btn" onclick="clearPin()">C</button>
                            <button type="button" class="numpad-btn" onclick="appendDigit('0')">0</button>
                            <asp:Button ID="btnLogin" runat="server" Text="LOGIN" CssClass="numpad-btn submit-btn" OnClick="btnLogin_Click" />
                        </div>

                        <div class="text-center mt-3">
                            <span class="text-info">New User? <a href="Registration.aspx" class="badge badge-info">Register here..</a></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>