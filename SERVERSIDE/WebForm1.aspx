<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication1.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>lab 9</title>
   
    <link href="style/Styles.css" rel="stylesheet" />
    
</head>
<body>
    <header>
        <img src="images/logo.gif" /></header>
    <form id="form1" runat="server">
        <div>
            <div>
                <asp:Label ID="Label1" runat="server" Text="Amount:"></asp:Label>
                <asp:TextBox ID="txtAmount" runat="server" CssClass="entry" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="amtValidator" runat="server" ControlToValidate="txtAmount" ErrorMessage="Must enter a value"></asp:RequiredFieldValidator>
            </div>
            <div>
                <asp:Label ID="Label2" runat="server" Text="Annual Interest Rate:"></asp:Label>
                <asp:DropDownList ID="ddlRate" runat="server" ></asp:DropDownList>
            </div>
            <div>
                <asp:Label ID="Label3" runat="server" Text="Number of Years:"></asp:Label>
                <asp:TextBox ID="txtYears" runat="server" CssClass="entry"></asp:TextBox>
                <asp:RequiredFieldValidator ID="yearsValidator" runat="server"  ControlToValidate="txtYears" ErrorMessage="Must enter a value"></asp:RequiredFieldValidator>
                <div>
                <asp:Label ID="Label4" runat="server" Text="Monthly payment"></asp:Label>
                <asp:TextBox ID="txtTotal" runat="server" ReadOnly="true"></asp:TextBox>
               
            </div>
            </div>
            <asp:Button ID="buttonCalc" runat="server" Text="Calculate" CssClass="button" OnClick="btnCalc_Click" />
            <asp:Button ID="buttonClear" runat="server" Text="Clear" CssClass="button" OnClick="clearButton_Click" />
        </div>
    </form>
</body>
</html>
