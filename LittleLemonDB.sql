-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customers` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(200) NOT NULL,
  `Phone` INT NOT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE INDEX `CustomerID_UNIQUE` (`CustomerID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `BookID` INT NOT NULL AUTO_INCREMENT,
  `Customers_CustomerID` INT NOT NULL,
  `BookingDate` DATETIME NOT NULL,
  `TableNuumber` INT NOT NULL,
  PRIMARY KEY (`BookID`),
  UNIQUE INDEX `BookID_UNIQUE` (`BookID` ASC) VISIBLE,
  INDEX `fk_Bookings_Customers1_idx` (`Customers_CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_Bookings_Customers1`
    FOREIGN KEY (`Customers_CustomerID`)
    REFERENCES `LittleLemonDB`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Employees` (
  `EmployeeID` INT NOT NULL AUTO_INCREMENT,
  `FirstName` VARCHAR(100) NOT NULL,
  `LastName` VARCHAR(100) NOT NULL,
  `Role` VARCHAR(100) NOT NULL,
  `Salary` INT NOT NULL,
  PRIMARY KEY (`EmployeeID`),
  UNIQUE INDEX `EmployeeID_UNIQUE` (`EmployeeID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Delivery_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Delivery_status` (
  `Delivery_statusID` INT NOT NULL AUTO_INCREMENT,
  `DeliveryDate` DATETIME NOT NULL,
  `Status` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`Delivery_statusID`),
  UNIQUE INDEX `Order_delivery_statusID_UNIQUE` (`Delivery_statusID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `OrderID` INT NOT NULL AUTO_INCREMENT,
  `Customers_CustomerID` INT NULL,
  `Bookings_BookID` INT NULL,
  `Employees_EmployeeID` INT NULL,
  `Delivery_status_Delivery_statusID` INT NULL,
  `OrderDate` DATETIME NOT NULL,
  `TotalCost` DECIMAL NOT NULL,
  PRIMARY KEY (`OrderID`),
  UNIQUE INDEX `OrderID_UNIQUE` (`OrderID` ASC) VISIBLE,
  INDEX `fk_Orders_Customers_idx` (`Customers_CustomerID` ASC) VISIBLE,
  INDEX `fk_Orders_Bookings1_idx` (`Bookings_BookID` ASC) VISIBLE,
  INDEX `fk_Orders_Employees1_idx` (`Employees_EmployeeID` ASC) VISIBLE,
  INDEX `fk_Orders_Order_delivery_status1_idx` (`Delivery_status_Delivery_statusID` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Customers`
    FOREIGN KEY (`Customers_CustomerID`)
    REFERENCES `LittleLemonDB`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Bookings1`
    FOREIGN KEY (`Bookings_BookID`)
    REFERENCES `LittleLemonDB`.`Bookings` (`BookID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Employees1`
    FOREIGN KEY (`Employees_EmployeeID`)
    REFERENCES `LittleLemonDB`.`Employees` (`EmployeeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Order_delivery_status1`
    FOREIGN KEY (`Delivery_status_Delivery_statusID`)
    REFERENCES `LittleLemonDB`.`Delivery_status` (`Delivery_statusID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `MenuID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NOT NULL,
  `Type` VARCHAR(20) NOT NULL,
  `Cost` DECIMAL NOT NULL,
  `Description` VARCHAR(500) NULL,
  PRIMARY KEY (`MenuID`),
  UNIQUE INDEX `MenuID_UNIQUE` (`MenuID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Checklist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Checklist` (
  `ChecklistID` INT NOT NULL AUTO_INCREMENT,
  `Orders_OrderID` INT NOT NULL,
  `Menu_MenuID` INT NOT NULL,
  `Quantity` INT NOT NULL,
  PRIMARY KEY (`ChecklistID`),
  UNIQUE INDEX `ChecklistID_UNIQUE` (`ChecklistID` ASC) VISIBLE,
  INDEX `fk_Checklist_Menu1_idx` (`Menu_MenuID` ASC) VISIBLE,
  INDEX `fk_Checklist_Orders1_idx` (`Orders_OrderID` ASC) VISIBLE,
  CONSTRAINT `fk_Checklist_Menu1`
    FOREIGN KEY (`Menu_MenuID`)
    REFERENCES `LittleLemonDB`.`Menu` (`MenuID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Checklist_Orders1`
    FOREIGN KEY (`Orders_OrderID`)
    REFERENCES `LittleLemonDB`.`Orders` (`OrderID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
