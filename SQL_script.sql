USE [master]
GO
/****** Object:  Database [Foodie2]    Script Date: 02.06.2025 23:33:36 ******/
CREATE DATABASE [Foodie2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Foodie2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\Foodie2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Foodie2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\Foodie2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Foodie2] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Foodie2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Foodie2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Foodie2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Foodie2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Foodie2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Foodie2] SET ARITHABORT OFF 
GO
ALTER DATABASE [Foodie2] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Foodie2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Foodie2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Foodie2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Foodie2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Foodie2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Foodie2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Foodie2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Foodie2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Foodie2] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Foodie2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Foodie2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Foodie2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Foodie2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Foodie2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Foodie2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Foodie2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Foodie2] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Foodie2] SET  MULTI_USER 
GO
ALTER DATABASE [Foodie2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Foodie2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Foodie2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Foodie2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Foodie2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Foodie2] SET QUERY_STORE = OFF
GO
USE [Foodie2]
GO
/****** Object:  UserDefinedTableType [dbo].[OrderDetails]    Script Date: 02.06.2025 23:33:36 ******/
CREATE TYPE [dbo].[OrderDetails] AS TABLE(
	[OrderNo] [varchar](max) NULL,
	[ProductId] [int] NULL,
	[Quantity] [int] NULL,
	[UserId] [int] NULL,
	[Status] [varchar](50) NULL,
	[PaymentId] [int] NULL,
	[OrderDate] [datetime] NULL
)
GO
/****** Object:  Table [dbo].[Carts]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Carts](
	[CartId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL,
	[Quantity] [int] NULL,
	[UserId] [int] NULL,
	[Comment] [varchar](50) NULL,
	[Priority] [int] NULL,
	[OrderDetailsId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CartId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[ImageUrl] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Status] [varchar](50) NULL,
	[PaymentId] [int] NULL,
	[OrderDate] [datetime] NULL,
	[TableId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment](
	[PaymentId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentMode] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PaymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Price] [decimal](18, 2) NULL,
	[ImageUrl] [varchar](max) NULL,
	[CategoryId] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[Description] [varchar](50) NULL,
	[Quantity] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tables]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tables](
	[TableId] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](50) NULL,
	[UserId] [int] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[TableId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Username] [varchar](50) NULL,
	[Mobile] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Address] [varchar](max) NULL,
	[PostCode] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[ImageUrl] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tables] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Carts]  WITH CHECK ADD FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Carts]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Carts]  WITH CHECK ADD  CONSTRAINT [FK_Carts_Orders] FOREIGN KEY([OrderDetailsId])
REFERENCES [dbo].[Orders] ([OrderDetailsId])
GO
ALTER TABLE [dbo].[Carts] CHECK CONSTRAINT [FK_Carts_Orders]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([PaymentId])
REFERENCES [dbo].[Payment] ([PaymentId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([TableId])
REFERENCES [dbo].[Tables] ([TableId])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Products]  WITH CHECK ADD FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Categories] ([CategoryId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Tables]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
/****** Object:  StoredProcedure [dbo].[Cart_Crud]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Cart_Crud]
    @Action VARCHAR(10),
    @CartId INT = NULL,
    @ProductId INT = NULL,
    @Quantity INT = NULL,
    @UserId INT = NULL,
    @OrderDetailsId INT = NULL,
    @Comment VARCHAR(50) = NULL,
    @Priority INT = 1,
    @TableId INT = NULL,
    @NewOrderDetailsId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Always use the provided UserId or default to system user
    IF @UserId IS NULL
    BEGIN
        SET @UserId = 0; -- or your system user ID
    END
    
    -- INSERT (add product to cart)
    IF @Action = 'INSERT'
    BEGIN
        -- If no OrderDetailsId but TableId is provided - find/create order
        IF @OrderDetailsId IS NULL AND @TableId IS NOT NULL
        BEGIN
            SELECT @OrderDetailsId = OrderDetailsId 
            FROM Orders 
            WHERE TableId = @TableId 
              AND Status = 'InProgress'
              AND UserId = @UserId
              
            IF @OrderDetailsId IS NULL
            BEGIN
                INSERT INTO Orders (TableId, Status, OrderDate, UserId)
                VALUES (@TableId, 'InProgress', GETDATE(), @UserId)
                
                SET @OrderDetailsId = SCOPE_IDENTITY()
            END
        END
        
        -- If still no OrderDetailsId
        IF @OrderDetailsId IS NULL
        BEGIN
            RAISERROR('No active order available', 16, 1)
            RETURN
        END
        
        -- Add/update product in cart
        DECLARE @ExistingCartId INT
        SELECT @ExistingCartId = CartId 
        FROM Carts 
        WHERE ProductId = @ProductId 
          AND OrderDetailsId = @OrderDetailsId
        
        IF @ExistingCartId IS NOT NULL
        BEGIN
            UPDATE Carts 
            SET Quantity = ISNULL(Quantity, 0) + ISNULL(@Quantity, 1),
                UserId = @UserId,
                Comment = ISNULL(@Comment, Comment)
            WHERE CartId = @ExistingCartId
        END
        ELSE
        BEGIN
            INSERT INTO Carts (ProductId, Quantity, UserId, Comment, Priority, OrderDetailsId)
            VALUES (
                @ProductId,
                ISNULL(@Quantity, 1), 
                @UserId, 
                @Comment, 
                @Priority, 
                @OrderDetailsId
            )
        END
        
        SELECT SCOPE_IDENTITY() AS CartId, @OrderDetailsId AS OrderDetailsId
    END

	 -- W sekcji SELECT
IF @Action = 'SELECT'
BEGIN
    SELECT 
        c.CartId, 
        c.ProductId, 
        p.Name, 
        p.Price, 
        p.ImageUrl,
        c.Quantity, 
        c.Comment, 
        c.Priority, 
        c.OrderDetailsId,
        p.Quantity AS PrdQty
    FROM Carts c
    INNER JOIN Products p ON c.ProductId = p.ProductId
    INNER JOIN Orders o ON c.OrderDetailsId = o.OrderDetailsId
    WHERE (c.OrderDetailsId = @OrderDetailsId OR 
          (@TableId IS NOT NULL AND c.OrderDetailsId IN 
              (SELECT OrderDetailsId FROM Orders WHERE TableId = @TableId)))
    AND o.Status = 'InProgress' -- Tylko zamówienia w trakcie
    ORDER BY c.Priority, c.CartId
END
  IF @Action = 'UPDATE'
BEGIN
    UPDATE Carts
    SET 
        Quantity = @Quantity,
        Comment = @Comment, -- Proste przypisanie bez CASE WHEN
        Priority = @Priority
    WHERE 
        ProductId = @ProductId 
        AND OrderDetailsId = @OrderDetailsId
END
    
    -- UPDATECOMMENT (tylko aktualizacja komentarza)
    IF @Action = 'UPDATECOMMENT'
    BEGIN
        UPDATE Carts
        SET Comment = @Comment
        WHERE 
            ProductId = @ProductId 
            AND OrderDetailsId = @OrderDetailsId
    END
    
    -- UPDATEQUANTITY (tylko aktualizacja ilości)
    IF @Action = 'UPDATEQUANTITY'
    BEGIN
        UPDATE Carts
        SET Quantity = @Quantity
        WHERE 
            ProductId = @ProductId 
            AND OrderDetailsId = @OrderDetailsId
    END

    IF @Action = 'DELETE'
BEGIN
    -- Nie usuwaj jeśli zamówienie jest zakończone
    IF NOT EXISTS (
        SELECT 1 FROM Orders 
        WHERE OrderDetailsId = @OrderDetailsId 
        AND Status = 'Completed'
    )
    BEGIN
        DELETE FROM Carts 
        WHERE ProductId = @ProductId 
        AND OrderDetailsId = @OrderDetailsId
    END
END

    -- GETBYID (pobierz szczegóły pozycji)
    IF @Action = 'GETBYID'
    BEGIN
        SELECT * FROM Carts 
        WHERE CartId = @CartId
    END

IF @Action = 'CLEAR'
BEGIN
    -- Nie czyść jeśli zamówienie jest zakończone
    IF NOT EXISTS (
        SELECT 1 FROM Orders 
        WHERE OrderDetailsId = @OrderDetailsId 
        AND Status = 'Completed'
    )
    BEGIN
        DELETE FROM Carts WHERE OrderDetailsId = @OrderDetailsId
    END
END
    
    -- MOVE (przenieś produkt do innego zamówienia)
    IF @Action = 'MOVE'
    BEGIN
        -- Sprawdź czy produkt istnieje w źródłowym zamówieniu
        IF NOT EXISTS (SELECT 1 FROM Carts WHERE CartId = @CartId AND OrderDetailsId = @OrderDetailsId)
        BEGIN
            RAISERROR('Product not found in source order', 16, 1)
            RETURN
        END
        
        -- Pobierz dane produktu
        DECLARE @ProdId INT, @Qty INT, @UsrId INT, @Cmnt VARCHAR(50), @Prty INT
        SELECT @ProdId = ProductId, @Qty = Quantity, @UsrId = UserId, @Cmnt = Comment, @Prty = Priority
        FROM Carts 
        WHERE CartId = @CartId
        
        -- Sprawdź czy ilość do przeniesienia jest mniejsza lub równa dostępnej
        IF @Quantity IS NOT NULL AND @Quantity > @Qty
        BEGIN
            RAISERROR('Requested quantity exceeds available quantity', 16, 1)
            RETURN
        END
        
        -- Ustaw ilość do przeniesienia (jeśli podano)
        DECLARE @QuantityToMove INT = ISNULL(@Quantity, @Qty)
        
        -- Dodaj do nowego zamówienia
        INSERT INTO Carts (ProductId, Quantity, UserId, Comment, Priority, OrderDetailsId)
        VALUES (@ProdId, @QuantityToMove, @UsrId, @Cmnt, @Prty, @NewOrderDetailsId)
        
        -- Jeśli przenosimy całą ilość - usuń ze starego zamówienia
        IF @QuantityToMove = @Qty
        BEGIN
            DELETE FROM Carts WHERE CartId = @CartId
        END
        ELSE
        BEGIN
            -- Jeśli tylko część - zmniejsz ilość w starym zamówieniu
            UPDATE Carts 
            SET Quantity = Quantity - @QuantityToMove
            WHERE CartId = @CartId
        END
        
        SELECT 1 AS Success, SCOPE_IDENTITY() AS NewCartId
    END
END
GO
/****** Object:  StoredProcedure [dbo].[Category_Crud]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Category_Crud]
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(10),
	@CategoryId INT = NULL,
	@Name VARCHAR(100) = NULL,
	@IsActive BIT = false,
	@ImageUrl VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --SELECT
    IF @Action = 'SELECT'
      BEGIN
            SELECT * FROM dbo.Categories ORDER BY CreatedDate DESC
      END
 
    --INSERT
    IF @Action = 'INSERT'
      BEGIN
            INSERT INTO dbo.Categories(Name, ImageUrl, IsActive, CreatedDate)
            VALUES (@Name, @ImageUrl, @IsActive, GETDATE())
      END
 
    --UPDATE
    IF @Action = 'UPDATE'
      BEGIN
		DECLARE @UPDATE_IMAGE VARCHAR(20)
		SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
		IF @UPDATE_IMAGE = 'NO'
			BEGIN
				UPDATE dbo.Categories
				SET Name = @Name, IsActive = @IsActive
				WHERE CategoryId = @CategoryId
			END
		ELSE
			BEGIN
				UPDATE dbo.Categories
				SET Name = @Name, ImageUrl = @ImageUrl, IsActive = @IsActive
				WHERE CategoryId = @CategoryId
			END
      END
 
    --DELETE
    IF @Action = 'DELETE'
      BEGIN
            DELETE FROM dbo.Categories WHERE CategoryId = @CategoryId
      END

	--GETBYID
    IF @Action = 'GETBYID'
      BEGIN
            SELECT * FROM dbo.Categories WHERE CategoryId = @CategoryId
      END

END

GO
/****** Object:  StoredProcedure [dbo].[ContactSp]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ContactSp]
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(10),
	@ContactId INT = NULL,
	@Name VARCHAR(50) = NULL,
	@Email VARCHAR(50) = NULL,
	@Subject VARCHAR(200) = NULL,
	@Message VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --INSERT
	IF @Action = 'INSERT'
      BEGIN
            INSERT INTO dbo.Contact(Name, Email, Subject, Message, CreatedDate)
            VALUES (@Name, @Email, @Subject, @Message, GETDATE())
      END

	--SELECT
    IF @Action = 'SELECT'
      BEGIN
            SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo],* FROM dbo.Contact
      END

	--DELETE BY ADMIN
    IF @Action = 'DELETE'
      BEGIN
            DELETE FROM dbo.Contact WHERE ContactId = @ContactId
      END

END

GO
/****** Object:  StoredProcedure [dbo].[Dashboard]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Dashboard]
    @Action VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- ACTIVE TABLES
    IF @Action = 'ACTIVETABLES'
    BEGIN
        SELECT COUNT(*) FROM dbo.Tables WHERE IsActive = 1
    END

    -- ORDERS IN PROGRESS
    IF @Action = 'INPROGRESS'
    BEGIN
        SELECT COUNT(*) FROM dbo.Orders WHERE Status = 'InProgress'
    END

    -- TODAYS ORDERS
    IF @Action = 'TODAYORDERS'
    BEGIN
        SELECT COUNT(*) FROM dbo.Orders 
        WHERE CAST(OrderDate AS DATE) = CAST(GETDATE() AS DATE)
    END

    -- TODAYS INCOME
    IF @Action = 'TODAYINCOME'
    BEGIN
        SELECT ISNULL(SUM(p.Price * c.Quantity), 0) 
        FROM Orders o
        JOIN Carts c ON o.OrderDetailsId = c.OrderDetailsId
        JOIN Products p ON c.ProductId = p.ProductId
        WHERE CAST(o.OrderDate AS DATE) = CAST(GETDATE() AS DATE)
        AND o.Status = 'Paid'
    END
END
GO
/****** Object:  StoredProcedure [dbo].[Invoice]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Invoice]
    @Action VARCHAR(20),
    @OrderDetailsId INT = NULL,
    @TableId INT = NULL,
    @Status VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- GET ALL ORDERS
    IF @Action = 'GETSTATUS'
    BEGIN
        SELECT 
            o.OrderDetailsId, 
            o.UserId,
            CONVERT(VARCHAR, o.OrderDate, 104) + ' ' + CONVERT(VARCHAR, o.OrderDate, 108) AS FormattedDate,
            o.Status,
            t.TableId,
            ISNULL(t.TableName, 'Brak') AS TableName,
            SUM(c.Quantity) AS TotalQuantity,
            SUM(p.Price * c.Quantity) AS TotalPrice,
            ISNULL(pm.PaymentMode, 'Brak') AS PaymentMode
        FROM Orders o
        LEFT JOIN Carts c ON o.OrderDetailsId = c.OrderDetailsId
        LEFT JOIN Products p ON c.ProductId = p.ProductId
        LEFT JOIN Tables t ON o.TableId = t.TableId
        LEFT JOIN Payment pm ON o.PaymentId = pm.PaymentId
        GROUP BY o.OrderDetailsId, o.UserId, o.OrderDate, o.Status, t.TableId, t.TableName, pm.PaymentMode
        ORDER BY o.OrderDate DESC
    END

    -- GET ORDER ITEMS FOR SPECIFIC ORDER
    IF @Action = 'GETORDERITEMS'
    BEGIN
        SELECT 
            p.Name,
            c.Quantity,
            p.Price
        FROM Carts c
        INNER JOIN Products p ON c.ProductId = p.ProductId
        WHERE c.OrderDetailsId = @OrderDetailsId
    END

    -- UPDATE ORDER STATUS
    IF @Action = 'UPDTSTATUS'
    BEGIN
        UPDATE Orders
        SET Status = @Status
        WHERE OrderDetailsId = @OrderDetailsId
        
        -- If order is completed, free the table
        IF @Status = 'Completed'
        BEGIN
            DECLARE @FreedTableId INT
            SELECT @FreedTableId = TableId FROM Orders WHERE OrderDetailsId = @OrderDetailsId
            
            IF @FreedTableId IS NOT NULL
                UPDATE Tables SET IsActive = 1 WHERE TableId = @FreedTableId
        END
    END
END
GO
/****** Object:  StoredProcedure [dbo].[Product_Crud]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Product_Crud]
	@Action VARCHAR(10),
	@ProductId INT = NULL,
	@Name VARCHAR(100) = NULL,
	@Price DECIMAL(18,2) = 0,
	@ImageUrl VARCHAR(MAX) = NULL,
	@CategoryId INT = NULL,
	@IsActive BIT = 0
AS
BEGIN
	SET NOCOUNT ON;

	-- SELECT all products with category name
	IF @Action = 'SELECT'
	BEGIN
		SELECT p.*, c.Name AS CategoryName
		FROM dbo.Products p
		INNER JOIN dbo.Categories c ON c.CategoryId = p.CategoryId
		ORDER BY p.CreatedDate DESC
	END

	-- INSERT new product
	ELSE IF @Action = 'INSERT'
	BEGIN
		INSERT INTO dbo.Products (Name, Price, ImageUrl, CategoryId, IsActive, CreatedDate)
		VALUES (@Name, @Price, @ImageUrl, @CategoryId, @IsActive, GETDATE())
	END

	-- UPDATE existing product
	ELSE IF @Action = 'UPDATE'
	BEGIN
		UPDATE dbo.Products
		SET Name = @Name,
			Price = @Price,
			ImageUrl = ISNULL(@ImageUrl, ImageUrl),
			CategoryId = @CategoryId,
			IsActive = @IsActive
		WHERE ProductId = @ProductId
	END

	-- DELETE product by ID
	ELSE IF @Action = 'DELETE'
	BEGIN
		DELETE FROM dbo.Products WHERE ProductId = @ProductId
	END

	-- GET product by ID
	ELSE IF @Action = 'GETBYID'
	BEGIN
		SELECT * FROM dbo.Products WHERE ProductId = @ProductId
	END

END
GO
/****** Object:  StoredProcedure [dbo].[Save_Orders]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Save_Orders]
    @OrderDetailsId INT,
    @PaymentId INT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Aktualizuj zamówienie o dane płatności
    UPDATE Orders
    SET 
        PaymentId = @PaymentId,
        UserId = @UserId,
        Status = 'Paid'
    WHERE OrderDetailsId = @OrderDetailsId
    
    -- Aktualizuj stan magazynu
    UPDATE p
    SET p.Quantity = p.Quantity - c.Quantity
    FROM Products p
    INNER JOIN Carts c ON p.ProductId = c.ProductId
    WHERE c.OrderDetailsId = @OrderDetailsId
    
    -- Zwróć potwierdzenie
    SELECT @OrderDetailsId AS OrderDetailsId
END
GO
/****** Object:  StoredProcedure [dbo].[SellingReport]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SellingReport]
	-- Add the parameters for the stored procedure here
	@FromDate DATE = NULL,
	@ToDate DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Print @FromDate
	Print @ToDate

	SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo],u.Name,u.Email,
		SUM(o.Quantity) AS TotalOrders, SUM(o.Quantity * p.Price) AS TotalPrice 
		FROM Orders o
		INNER JOIN Products p ON p.ProductId = o.ProductId
		INNER JOIN Users u ON u.UserId = o.UserId
		WHERE CAST(o.OrderDate AS DATE) BETWEEN @FromDate AND @ToDate
		GROUP BY u.Name, u.Email;	
END




GO
/****** Object:  StoredProcedure [dbo].[Table_Crud]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Table_Crud]
    @Action VARCHAR(10),
    @TableId INT = NULL,
    @TableName VARCHAR(50) = NULL,
    @UserId INT = NULL,
    @IsActive BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- SELECT (pobierz wszystkie aktywne stoliki)
    IF @Action = 'SELECT'
    BEGIN
        SELECT * FROM dbo.Tables 
        WHERE IsActive = 1 OR @IsActive IS NULL
    END
 
    -- INSERT (dodaj nowy stolik)
    IF @Action = 'INSERT'
    BEGIN
        INSERT INTO dbo.Tables(TableName, UserId, IsActive)
        VALUES (@TableName, @UserId, 1)
        
        SELECT SCOPE_IDENTITY() AS TableId
    END
 
    -- UPDATE (zmień nazwę stolika)
    IF @Action = 'UPDATE'
    BEGIN
        UPDATE dbo.Tables
        SET 
            TableName = @TableName,
            IsActive = @IsActive
        WHERE TableId = @TableId
    END
 
    -- DELETE (deaktywuj stolik)
    IF @Action = 'DELETE'
    BEGIN
        UPDATE dbo.Tables
        SET IsActive = 0
        WHERE TableId = @TableId
    END

    -- GETBYID (pobierz szczegóły stolika)
    IF @Action = 'GETBYID'
    BEGIN
        SELECT * FROM dbo.Tables 
        WHERE TableId = @TableId
    END
END
GO
/****** Object:  StoredProcedure [dbo].[User_Crud]    Script Date: 02.06.2025 23:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[User_Crud] 
    @Action VARCHAR(20),
    @UserId INT = NULL,
    @Name varchar(50) = null,
    @Username varchar(50) = null,
    @Mobile varchar(50) = null,
    @Email varchar(50) = null,
    @Address varchar(max) = null,
    @PostCode varchar(50) = null,
    @Password varchar(50) = null,
    @ImageUrl varchar(max) = null
AS
BEGIN
    SET NOCOUNT ON;

    -- SELECT FOR LOGIN BY PIN CODE (using Password column)
    IF @Action = 'SELECT_BY_PIN'
    BEGIN
        SELECT * FROM dbo.Users WHERE Password = @Password
    END

    -- Original SELECT FOR LOGIN (username/password)
    IF @Action = 'SELECT4LOGIN'
    BEGIN
        SELECT * FROM dbo.Users WHERE Username = @Username AND Password = @Password
    END

    -- SELECT FOR USER PROFILE
    IF @Action = 'SELECT4PROFILE'
    BEGIN
        SELECT * FROM dbo.Users WHERE UserId = @UserId
    END

    -- Insert (REGISTRATION) - generate random 4-digit PIN
    IF @Action = 'INSERT'
    BEGIN
        -- Generate random 4-digit PIN if not provided
        IF @Password IS NULL OR LEN(@Password) != 4 OR ISNUMERIC(@Password) = 0
        BEGIN
            SET @Password = RIGHT('0000' + CAST(CAST(RAND() * 10000 AS INT) % 10000 AS VARCHAR(4)), 4)
        END
        
        INSERT INTO dbo.Users(Name,Username,Mobile,Email,Address,PostCode,Password,ImageUrl,CreatedDate) 
        VALUES (@Name,@Username,@Mobile,@Email,@Address,@PostCode,@Password,@ImageUrl,GETDATE())
    END

    -- UPDATE USER PROFILE
    IF @Action = 'UPDATE'
    BEGIN
        DECLARE @UPDATE_IMAGE VARCHAR(20)
        SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
        IF @UPDATE_IMAGE = 'NO'
        BEGIN
            UPDATE dbo.Users
            SET Name = @Name, Username = @Username, Mobile = @Mobile, Email = @Email, 
                Address = @Address, PostCode = @PostCode
            WHERE UserId = @UserId
        END
        ELSE
        BEGIN
            UPDATE dbo.Users
            SET Name = @Name, Username = @Username, Mobile = @Mobile, Email = @Email, 
                Address = @Address, PostCode = @PostCode, ImageUrl = @ImageUrl
            WHERE UserId = @UserId
        END
    END

    -- SELECT FOR ADMIN
    IF @Action = 'SELECT4ADMIN'
    BEGIN
        SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo], UserId, Name, 
               Username, Email, CreatedDate, Password AS [PIN]
        FROM Users
    END
    
    -- DELETE BY ADMIN
    IF @Action = 'DELETE'
    BEGIN
        DELETE FROM dbo.Users WHERE UserId = @UserId
    END
    
    -- UPDATE PIN CODE (using Password parameter)
    IF @Action = 'UPDATE_PIN'
    BEGIN
        UPDATE dbo.Users
        SET Password = @Password
        WHERE UserId = @UserId
    END
END
GO
USE [master]
GO
ALTER DATABASE [Foodie2] SET  READ_WRITE 
GO
