/*DATA PREP*/

INSERT INTO Menu (MenuItemID, Name, Type, Cost)
VALUES
(1, 'Olives','Starters',20),
(2, 'Flatbread','Starters', 20),
(3, 'Minestrone', 'Starters', 32),
(4, 'Tomato bread','Starters', 32),
(5, 'Falafel', 'Starters', 28),
(6, 'Hummus', 'Starters', 20),
(7, 'Greek salad', 'Main Courses', 60),
(8, 'Bean soup', 'Main Courses', 48),
(9, 'Pizza', 'Main Courses', 60),
(10, 'Greek yoghurt','Desserts', 28),
(11, 'Ice cream', 'Desserts', 24),
(12, 'Cheesecake', 'Desserts', 16),
(13, 'Athens White wine', 'Drinks', 100),
(14, 'Corfu Red Wine', 'Drinks', 120),
(15, 'Turkish Coffee', 'Drinks', 40),
(16, 'Kabasa', 'Main Courses', 68);


INSERT INTO Employees (EmployeeID, FirstName, LastName, Role, Salary) 
VALUES
(1,'Mario', 'Gollini','Manager','70000'),
(2,'Adrian', 'Gollini','Assistant Manager','65000'),
(3,'Giorgos', 'Dioudis','Head Chef','50000'),
(4,'Fatma', 'Kaya','Assistant Chef','45000'),
(5,'Elena', 'Salvai','Head Waiter','40000'),
(6,'John', 'Millar','Receptionist','35000');


INSERT INTO Customers (CustomerID, Name, Phone)
VALUES
(1, 'Anna', 1112223344),
(2, 'Joakim', 2223334455),
(3, 'Vanessa', 3334445566),
(4, 'Marcos', 4445556677);


INSERT INTO Delivery_status (Delivery_statusID, Dt, Status)
VALUES
(1, now(), 'Done'),
(2, now(), 'In process');

INSERT INTO Bookings (BookID, CustomerID, BookingDate, TableNum)
VALUES
(1, 1, now(),1),
(2, 2, now(), 2),
(3, 4, now(), 3);

INSERT INTO Orders (OrderID, EmployeeID, CustomerID, Delivery_statusID, OrderDate, FactTableNum, TotalCost)
VALUES
(1, 4, 2, NULL, now(), 1, 344),
(2, 3, 1,    1,    now(), 3, 148),
(3, 3, 2,    NULL, now(), 2, 148),
(4, 5, 3,    2,    now(), 1, 160),
(5, 6, 4,    NULL, now(), 4, 172);

INSERT INTO LittleLemonDB.`Check` (OrderID, MenuItemID, Quantity)
VALUES
(1, 14, 2),
(1, 15, 1),
(1, 3, 1),
(1, 4, 1),
(2, 1, 1),
(2, 2, 1),
(2, 7, 1),
(2, 8, 1),
(3, 1, 2),
(3, 7, 1),
(3, 8, 1),
(4, 7, 2),
(4, 15, 1),
(5, 1, 2),
(5, 7, 1),
(5, 8, 1),
(5, 11, 1);


/*VIEW*/
/*Task 1*/
CREATE VIEW OrdersView as
SELECT o.OrderID, sum(c.Quantity) as Quantity, sum(m.Cost*c.Quantity) as TotalCost
FROM Orders o 
JOIN `Check` c on c.OrderID = o.OrderID
JOIN Menu m on m.MenuItemID = c.MenuItemID
Group by o.OrderID 
HAVING sum(c.Quantity)>2;

Select * from OrdersView;

/*Task 2*/
SELECT cust.CustomerID, cust.Name, o.OrderID, SUM(m.Cost*c.Quantity) TotalCost, GROUP_CONCAT(m.Name) list  
FROM Orders o
JOIN `Check` c on c.OrderID = o.OrderID
JOIN Menu m on m.MenuItemID = c.MenuItemID
LEFT JOIN Customers cust on cust.CustomerID = o.CustomerID
GROUP BY cust.CustomerID, cust.Name, o.OrderID
HAVING sum(m.Cost*c.Quantity)>150;

/*Task 3*/
SELECT Name
FROM Menu
WHERE MenuItemID = ANY (SELECT MenuItemID 
						FROM `Check` 
						GROUP BY MenuItemID 
						HAVING count(MenuItemID)>2);

/*PROCEDURES*/

/*Task 1*/
CREATE PROCEDURE IF NOT EXISTS GetMaxQuantity()
SELECT sum(Quantity) maxQuantity
FROM `Check` 
GROUP BY OrderID
ORDER BY sum(Quantity) DESC
LIMIT 1;

CALL GetMaxQuantity();

/*Task 2*/
PREPARE GetOrderDetail FROM 'SELECT c.OrderID, 
								sum(c.Quantity) as Quantity, 
								sum(m.Cost*c.Quantity) as TotalCost 
							FROM LittleLemonDB.Check c 
							JOIN LittleLemonDB.Menu m on m.MenuItemID = c.MenuItemID 
							WHERE c.OrderID=? 
							GROUP BY c.OrderID';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

/*Task 3*/
CREATE PROCEDURE IF NOT EXISTS CancelOrder(IN oid BIGINT, OUT str varchar(100))
BEGIN
	DELETE FROM LittleLemonDB.Check WHERE OrderID=oid;
	DELETE FROM LittleLemonDB.Orders WHERE OrderID=oid;
	COMMIT;
	SET str=CONCAT('Order ',CAST(oid as char),' is cancelled');
END

CALL CancelOrder(5,@c);
SELECT @c;

/*DATA BACK*/

INSERT INTO Orders (OrderID, EmployeeID, CustomerID, Delivery_statusID, OrderDate, FactTableNum, TotalCost)
VALUES
(5, 6, 4,    NULL, now(), 4, 172);

INSERT INTO LittleLemonDB.`Check` (OrderID, MenuItemID, Quantity)
VALUES
(5, 1, 2),
(5, 7, 1),
(5, 8, 1),
(5, 11, 1);