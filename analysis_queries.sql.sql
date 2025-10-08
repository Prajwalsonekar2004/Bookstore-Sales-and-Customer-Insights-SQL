

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Genre VARCHAR(100),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    City VARCHAR(100),
    Country VARCHAR(100)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Book_ID INT NOT NULL,
    Order_Date DATE NOT NULL DEFAULT CURRENT_DATE,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Total_Amount NUMERIC(10, 2) NOT NULL CHECK (Total_Amount >= 0),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID) ON DELETE CASCADE,
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID) ON DELETE CASCADE
);

SELECT * FROM Books
SELECT * FROM Customers
SELECT * FROM Orders


-- 1) Retrieve all books in the "Fiction" genre:
SELECT *
FROM Books
WHERE Genre = 'Fiction'

-- 2) Find books published after the year 1950:
SELECT *
FROM Books
WHERE Published_Year > 1950

-- 3) List all customers from the Canada:
SELECT *
FROM Customers
WHERE Country = 'Canada'

-- 4) Show orders placed in November 2023:
SELECT *
FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) AS total_stock
FROM Books

-- 6) Find the details of the most expensive book:
SELECT * 
FROM Books 
ORDER BY Price DESC 
LIMIT 1

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT *
FROM Orders
WHERE Quantity > 1

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT *
FROM Orders
WHERE Total_Amount > 20

-- 9) List all genres available in the Books table:
SELECT DISTINCT Genre
FROM Books

-- 10) Find the book with the lowest stock:
SELECT * 
FROM Books 
ORDER BY Stock

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(Total_Amount) AS total_revenue
FROM Orders

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
SELECT b.Genre, SUM(o.Quantity) AS books_sold
FROM Books b
JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Genre

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT AVG(Price) AS average_price
FROM Books
WHERE Genre = 'Fantasy'

-- 3) List customers who have placed at least 2 orders:
SELECT o.Customer_ID, c.name, COUNT(o.Order_ID) AS order_count
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.name
HAVING COUNT(Order_ID)>=2;

-- 4) Find the most frequently ordered book:
SELECT o.book_id, b.Title, COUNT(o.Order_ID) AS order_count
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY o.Book_ID, b.Title
ORDER BY order_count DESC 
LIMIT 1

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT *
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3

-- 6) Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS Total_books_sold
FROM Books b
JOIN orders o ON o.book_id = b.book_id
GROUP BY b.author

-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.total_amount > 30

-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 1

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS order_quantity,
b.stock - COALESCE(SUM(o.quantity),0) AS remaining_stock
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id

