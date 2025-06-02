<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Food_Ordering_Project.User.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        :root {
            --primary-color: #FFD700; /* Żółty */
            --secondary-color: #FFC000; /* Ciemniejszy żółty */
            --dark-color: #000000; /* Czarny */
            --light-color: #F8F8F8; /* Jasnoszary */
            --accent-color: #333333; /* Ciemnoszary */
        }
        
        body {
            background-color: var(--light-color);
        }
        
        .login-container {
            display: flex;
            min-height: 80vh;
            align-items: center;
            justify-content: center;
            background-color: var(--light-color);
        }
        
        .login-card {
            width: 100%;
            max-width: 900px;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            display: flex;
            border: 2px solid var(--dark-color);
        }

        
        .login-image {
            flex: 1;
            background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), 
                        url('https://bing.com/th/id/BCO.b82010e9-13f7-4260-95e3-9ec51b564f84.png');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            color: var(--primary-color);
        }
        
        .login-image h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
        }
        
        .login-image p {
            font-size: 1.1rem;
            color: white;
        }
        
        .login-form {
            flex: 1;
            padding: 3rem;
            background: white;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }
        
        .form-header h2 {
            color: var(--dark-color);
            font-size: 2rem;
            margin-bottom: 0.5rem;
            font-weight: bold;
        }
        
        .form-header p {
            color: var(--accent-color);
            opacity: 0.9;
        }
        
        .pin-container {
            display: flex;
            justify-content: center;
            margin: 30px 0;
            gap: 15px;
        }
        
        .pin-digit {
            width: 60px;
            height: 70px;
            font-size: 28px;
            text-align: center;
            border: 2px solid var(--dark-color);
            border-radius: 10px;
            transition: all 0.3s;
            color: var(--dark-color);
            font-weight: bold;
        }
        
        .pin-digit:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 215, 0, 0.3);
            outline: none;
        }
        
        .numpad {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            max-width: 350px;
            margin: 0 auto;
        }
        
        .numpad-btn {
            padding: 18px;
            font-size: 20px;
            border: 2px solid var(--dark-color);
            border-radius: 50%;
            background: white;
            cursor: pointer;
            transition: all 0.3s;
            color: var(--dark-color);
            font-weight: bold;
        }
        
        .numpad-btn:hover {
            background: var(--primary-color);
            transform: translateY(-2px);
            border-color: var(--primary-color);
        }
        
        .numpad-btn:active {
            transform: translateY(0);
        }
        
        .submit-btn {
            grid-column: span 3;
            padding: 15px;
            border-radius: 50px;
            background: var(--dark-color);
            color: var(--primary-color);
            font-weight: bold;
            letter-spacing: 1px;
            margin-top: 10px;
            transition: all 0.3s;
            border: 2px solid var(--dark-color);
        }
        
        .submit-btn:hover {
            background: var(--primary-color);
            color: var(--dark-color);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .clear-btn {
            background: var(--dark-color);
            color: var(--primary-color);
        }
        
        .clear-btn:hover {
            background: var(--primary-color);
            color: var(--dark-color);
        }
        
        .message-alert {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            transition: all 0.5s;
            background-color: var(--dark-color);
            color: var(--primary-color);
            border: 1px solid var(--primary-color);
            padding: 15px;
            border-radius: 5px;
        }
        
        @media (max-width: 768px) {
            .login-card {
                flex-direction: column;
            }
            
            .login-image {
                padding: 1.5rem;
            }
            
            .pin-digit {
                width: 50px;
                height: 60px;
                font-size: 24px;
            }
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

    <div class="login-container">
        <div class="login-card">
            <div class="login-image">
                <div>
                    <h2>Witaj!</h2>
                    <p>Zaloguj się, aby aby przejść dalej</p>
                </div>
            </div>
            
            <div class="login-form">
                <div class="form-header">
                    <h2>Logowanie</h2>
                    <p>Wprowadź swój kod PIN</p>
                </div>
                
                <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="message-alert"></asp:Label>
                
                <div class="pin-container">
                    <asp:TextBox ID="txtPin1" runat="server" CssClass="pin-digit" MaxLength="1" onkeyup="moveToNext(this, 'txtPin2')" autocomplete="off" />
                    <asp:TextBox ID="txtPin2" runat="server" CssClass="pin-digit" MaxLength="1" onkeyup="moveToNext(this, 'txtPin3')" autocomplete="off" />
                    <asp:TextBox ID="txtPin3" runat="server" CssClass="pin-digit" MaxLength="1" onkeyup="moveToNext(this, 'txtPin4')" autocomplete="off" />
                    <asp:TextBox ID="txtPin4" runat="server" CssClass="pin-digit" MaxLength="1" autocomplete="off" />
                    <asp:HiddenField ID="hfPassword" runat="server" />
                </div>

                <div class="numpad">
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
                    <asp:Button ID="btnLogin" runat="server" Text="ZALOGUJ SIĘ" CssClass="numpad-btn submit-btn" OnClick="btnLogin_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>