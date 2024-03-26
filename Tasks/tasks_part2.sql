INSERT INTO Bookings (CustomerID, BookingDate, TableNum)
VALUES
(1, '2024-10-10 00:00:00', 1),
(3, '2024-11-12 00:00:00', 3),
(2, '2024-10-11 00:00:00', 2),
(1, '2024-10-13 00:00:00', 2);

CREATE PROCEDURE IF NOT EXISTS CheckBooking(IN DT DATE, IN tablen INT, OUT str varchar(100))
BEGIN
	DECLARE is_avalible bool DEFAULT true;
	SELECT false as found_record INTO is_avalible
	FROM LittleLemonDB.Bookings
	WHERE BookingDate=DT and TableNum=tablen;
	IF is_avalible is true THEN
		SET str=CONCAT('Table ',CAST(tablen as char),' is avalible');
	ELSE
		SET str=CONCAT('Table ',CAST(tablen as char),' is already booked');
	END IF;
END

CALL CheckBooking('2024-11-12',3,@c);
SELECT @c;


CREATE PROCEDURE IF NOT EXISTS AddValidBooking(IN DT DATE, IN tablen INT, IN custId INT, OUT str varchar(100))
BEGIN
	DECLARE is_avalible bool DEFAULT true;
	SELECT false as found_record INTO is_avalible
	FROM LittleLemonDB.Bookings
	WHERE BookingDate=DT and TableNum=tablen;
	START TRANSACTION;
	INSERT INTO LittleLemonDB.Bookings (CustomerID, BookingDate, TableNum)
	VALUES (custId, DT, tablen);
	IF is_avalible is true THEN
		COMMIT;
		SET str=CONCAT('Table ',CAST(tablen as char),' successfully booked');
	ELSE
		ROLLBACK;
		SET str=CONCAT('Table ',CAST(tablen as char),' is already booked - booking cancelled ');
	END IF;
END

CALL AddValidBooking('2024-11-12',3,3,@c);
SELECT @c;


CREATE PROCEDURE IF NOT EXISTS AddBooking(IN DT DATE, IN tablen INT, IN custId INT, OUT str varchar(100))
BEGIN
	DECLARE is_avalible bool DEFAULT true;
	SELECT false as found_record INTO is_avalible
	FROM LittleLemonDB.Bookings
	WHERE BookingDate=DT and TableNum=tablen;
	IF is_avalible is true THEN
		START TRANSACTION;
		INSERT INTO LittleLemonDB.Bookings (CustomerID, BookingDate, TableNum)
		VALUES (custId, DT, tablen);
		COMMIT;
		SET str='New booking added';
	ELSE
		SET str=CONCAT('Table ',CAST(tablen as char),' is already booked');
	END IF;
END

CALL AddBooking('2024-11-13',3,3,@c);
SELECT @c;

CREATE PROCEDURE IF NOT EXISTS UpdateBooking(IN bID INT, IN DT DATE, OUT str varchar(100))
BEGIN
	DECLARE is_avalible bool DEFAULT false;
	SELECT true as found_record INTO is_avalible
	FROM LittleLemonDB.Bookings
	WHERE BookID=bID;
	IF is_avalible is true THEN
		START TRANSACTION;
		UPDATE LittleLemonDB.Bookings SET BookingDate=DT WHERE BookID=bID;
		COMMIT;
		SET str=CONCAT('Booking ',CAST(bID as char),' updated');
	ELSE
		SET str=CONCAT('Booking ',CAST(bID as char),' is not exists');
	END IF;
END

CALL UpdateBooking(9,'2024-11-10',@c);
SELECT @c;


CREATE PROCEDURE IF NOT EXISTS CancelBooking(IN bID INT, OUT str varchar(100))
BEGIN
	DECLARE is_avalible bool DEFAULT false;
	SELECT true as found_record INTO is_avalible
	FROM LittleLemonDB.Bookings
	WHERE BookID=bID;
	IF is_avalible is true THEN
		START TRANSACTION;
		DELETE FROM LittleLemonDB.Bookings WHERE BookID=bID;
		COMMIT;
		SET str=CONCAT('Booking ',CAST(bID as char),' cancelled');
	ELSE
		SET str=CONCAT('Booking ',CAST(bID as char),' is not exists');
	END IF;
END

CALL CancelBooking(16,@c);
SELECT @c;