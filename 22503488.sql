DROP SCHEMA IF EXISTS Ordering_System;
CREATE SCHEMA Ordering_System;
USE Ordering_System;

#TASK 2c - creating tables

#CREATION OF CUSTOMER ADDRESS TABLE
CREATE TABLE customer_address(
    Customer_Address_id INT(10) NOT NULL UNIQUE AUTO_INCREMENT,
    Street_No INT(5) NOT NULL,
    Street_Name VARCHAR(40) NOT NULL,
    Suburb VARCHAR(40) NOT NULL,
    PRIMARY KEY (Customer_Address_id));

#CREATION OF CUSTOMER TABLE
CREATE TABLE customer(
    Mobile_No CHAR(10) NOT NULL UNIQUE, 
    First_Name VARCHAR(40) NOT NULL,
    Last_Name VARCHAR(40) NOT NULL,
    Customer_Address_id INT(10) NOT NULL,
    Payment_Method ENUM("Cash","Card","Cheque"),
    FOREIGN KEY (Customer_Address_id)
    REFERENCES customer_address(Customer_Address_id),
    PRIMARY KEY (Mobile_No));

#TRIGGER TO ONLY ALLOW MOBILE_NO OF LENGTH 10
delimiter $$
create trigger check_mobile_length_on_insert
before insert on customer
for each row 
begin
if(CHAR_LENGTH(new.Mobile_No)!=10) then
    signal sqlstate '22003' set message_text = 'Mobile_No must be of length 10';
    end if; 
end;
$$
delimiter ;
    
#CREATE ORDER TABLE    
CREATE TABLE orders(
    Order_id INT(10) NOT NULL UNIQUE AUTO_INCREMENT,
    Order_time TIMESTAMP NOT NULL DEFAULT current_timestamp() ,
    Mobile_No CHAR(10) NOT NULL,
    FOREIGN KEY (Mobile_No)
    REFERENCES customer(Mobile_No),    
    PRIMARY KEY (Order_id));

#CREATE EMPLOYEE_ADDRESS TABLE
CREATE TABLE employee_address(
    Employee_Address_id INT(10) NOT NULL UNIQUE AUTO_INCREMENT,
    Street_No INT(5) NOT NULL,
    Street_Name VARCHAR(40) NOT NULL,
    Suburb VARCHAR(40) NOT NULL,
    PRIMARY KEY (Employee_Address_id));

#CREATE EMPLOYEE TABLE
CREATE TABLE employee(
    Employee_id INT(10) NOT NULL UNIQUE AUTO_INCREMENT,
    Mobile_No CHAR(10) NOT NULL UNIQUE,
    First_Name VARCHAR(40) NOT NULL,
    Last_Name VARCHAR(40) NOT NULL,
    Employee_Address_id INT(10) NOT NULL,
    Is_Chef BOOLEAN NOT NULL,
    Is_Driver BOOLEAN NOT NULL,
    Base_Salary FLOAT NOT NULL,
    FOREIGN KEY (Employee_Address_id)
    REFERENCES employee_address(Employee_Address_id),
    PRIMARY KEY(Employee_id));

#CREATE ORDER_HANDLED_BY TABLE 
CREATE TABLE order_handled_by(
    Order_id INT(10) NOT NULL,
    Employee_id INT(10) NOT NULL,
    FOREIGN KEY (Order_id)
    REFERENCES orders(Order_id),
    FOREIGN KEY (Employee_id)
    REFERENCES employee(Employee_id),
    PRIMARY KEY(Order_id,Employee_id));

#CREATE PIZZA TABLE
CREATE TABLE pizza(
    Pizza_id INT(10) NOT NULL UNIQUE AUTO_INCREMENT,
    Pizza_Name VARCHAR(40) NOT NULL,
    PRIMARY KEY(Pizza_id));
  
#CREATE EXTRA_ITEMS TABLE  
CREATE TABLE extra_items(
    Product_Code INT(10) AUTO_INCREMENT NOT NULL UNIQUE,
    Item_Name VARCHAR(20) NOT NULL,
    Item_Description VARCHAR(50) NOT NULL,
    Manufacturer_Name VARCHAR(30) NOT NULL,
    Supplier VARCHAR(30) NOT NULL,
    Retail_price FLOAT NOT NULL,
    Cost FLOAT NOT NULL,
    PRIMARY KEY (Product_Code));   
 
#CREATE ORDERED_EXTRAS TABLE
CREATE TABLE ordered_extras(
    Order_id INT(10) NOT NULL,
    Product_Code INT(10) NOT NULL,
    Quantity INTEGER(2) NOT NULL,
    FOREIGN KEY (Order_id)
    REFERENCES orders(Order_id),
    FOREIGN KEY (Product_Code)
    REFERENCES extra_items(Product_Code),
    PRIMARY KEY (Order_id,Product_Code));
 
#CREATE INGREDIENTS TABLE
CREATE TABLE ingredients(
    Ingredient_id INT(2) NOT NULL UNIQUE AUTO_INCREMENT,
    Ingredient_Name VARCHAR(20) NOT NULL UNIQUE,
    Retail_price FLOAT NOT NULL,
    Cost FLOAT NOT NULL,
    PRIMARY KEY (Ingredient_id));

#CREATE PIZZA SIZES TABLE
CREATE TABLE sizes(
    Size_Id INT(10) NOT NULL UNIQUE AUTO_INCREMENT,
    Size_Type ENUM("Small","Medium","Large","Family","Super") NOT NULL,
    Size_Multiply_Price FLOAT(5,2) NOT NULL,
    PRIMARY KEY(Size_id));
 
#CREATE ORDER_DETAILS TABLE
CREATE TABLE order_details(
    Pizza_Ordered_id INT(10) NOT NULL AUTO_INCREMENT UNIQUE,
    Order_id INT(10) NOT NULL,
    Pizza_id INT(10) NOT NULL,
    Crust ENUM("Thin","Regular","Thick") NOT NULL,
    Size INT(10) NOT NULL,
    Pizza_Quantity INT(2) NOT NULL,
    Discount INT(2) DEFAULT 0 NOT NULL,
    Employee_id INT(10) NOT NULL, 
    FOREIGN KEY (Size)
    REFERENCES sizes(Size_Id),
    FOREIGN KEY (Pizza_id)
    REFERENCES pizza(Pizza_id),
    FOREIGN KEY (Employee_id)
    REFERENCES employee(Employee_id),
    FOREIGN KEY (Order_id)
    REFERENCES orders(Order_id),
    PRIMARY KEY (Pizza_Ordered_id));

#CREATE ORDER_EXTRA_INGREDIENTS TABLE
CREATE TABLE order_extra_ingredients(
    Pizza_Ordered_id INT(10) NOT NULL,
    Ingredient_id INT(2) NOT NULL,
    Extra_Ingredients_Quantity INT(2) NOT NULL,
    FOREIGN KEY (Pizza_Ordered_id)
    REFERENCES order_details(Pizza_Ordered_id),
    FOREIGN KEY (Ingredient_id)
    REFERENCES ingredients(Ingredient_id),
    PRIMARY KEY (Pizza_Ordered_id,Ingredient_id));

#CREATE PIZZA_INGREDIENTS TABLE
CREATE TABLE pizza_ingredients(
	Pizza_id INT(10) NOT NULL,
    Ingredient_id INT(2) NOT NULL,
    Ingredients_Quantity INT(2) NOT NULL,
    FOREIGN KEY (Pizza_id)
    REFERENCES pizza(Pizza_id),
    FOREIGN KEY (Ingredient_id)
    REFERENCES ingredients(Ingredient_id),
    PRIMARY KEY (Pizza_id,Ingredient_id));



#TASK 2d - Inserting records

#Inserting records into customer_address table
INSERT INTO customer_address(Street_No,Street_Name,Suburb) VALUES (4,"Yellow Street","Manjimup");
INSERT INTO customer_address(Street_No,Street_Name,Suburb) VALUES (9,"Munt Street","Bassendean");
INSERT INTO customer_address(Street_No,Street_Name,Suburb) VALUES (45,"Cresant Street","Kingsley");
INSERT INTO customer_address(Street_No,Street_Name,Suburb) VALUES (7,"Healy Close","Hamersley");
INSERT INTO customer_address(Street_No,Street_Name,Suburb) VALUES (21,"Brad Circle","Apple Cross");
INSERT INTO customer_address(Street_No,Street_Name,Suburb) VALUES (88,"Bland Street","Joondalup");
INSERT INTO customer_address(Street_No,Street_Name,Suburb) VALUES (12,"Creaney Rise","Bassendean");
INSERT INTO customer_address(Street_No,Street_Name,Suburb) VALUES (87,"Aquinas Rise","Bentley");
INSERT INTO customer_address(Street_No,Street_Name,Suburb) VALUES (99,"Joma Bend","Balga");
INSERT INTO customer_address(Street_No,Street_Name,Suburb) VALUES (2,"Goollelal Road","Woodvale");

#Inserting records into customer table
INSERT INTO customer VALUES ("0456599353","Henry","Bate",1,"Cash");
INSERT INTO customer VALUES ("0456594035","Bard","Kreedy",2,"Card");
INSERT INTO customer VALUES ("0456584035","Kenny","Richy",3,"Cheque");
INSERT INTO customer VALUES ("0451594037","Qulan","Crosby",4,"Card");
INSERT INTO customer VALUES ("0456594135","Justin","Lane",5,"Cheque");
INSERT INTO customer VALUES ("0476594035","Wesley","Graham",6,"Cash");
INSERT INTO customer VALUES ("0456595035","Emma","Wills",7,"Card");
INSERT INTO customer VALUES ("0469595035","Ben","Kile",8,"Cash");
INSERT INTO customer VALUES ("0456743235","Holly","Smith",9,"Card");
INSERT INTO customer VALUES ("0456126535","Keelie","James",10,"Cheque");

#Inserting records into orders table
INSERT INTO orders(Mobile_No) VALUES ("0456599353");
INSERT INTO orders(Mobile_No) VALUES ("0456594035");
INSERT INTO orders(Mobile_No) VALUES ("0456584035");
INSERT INTO orders(Mobile_No) VALUES ("0451594037");
INSERT INTO orders(Mobile_No) VALUES ("0456594135");
INSERT INTO orders(Mobile_No) VALUES ("0476594035");
INSERT INTO orders(Mobile_No) VALUES ("0456595035");
INSERT INTO orders(Mobile_No) VALUES ("0469595035");
INSERT INTO orders(Mobile_No) VALUES ("0456743235");
INSERT INTO orders(Mobile_No) VALUES ("0456126535");

#Inserting records into employee_address table
INSERT INTO employee_address(Street_No,Street_Name,Suburb) VALUES (4,"Willow Street","Albany");
INSERT INTO employee_address(Street_No,Street_Name,Suburb) VALUES (88,"Fleet Street","Padbury");
INSERT INTO employee_address(Street_No,Street_Name,Suburb) VALUES (21,"Bond Street","Woodvale");
INSERT INTO employee_address(Street_No,Street_Name,Suburb) VALUES (4,"Dimension Street","Balcatta");
INSERT INTO employee_address(Street_No,Street_Name,Suburb) VALUES (26,"Wellington Street","Perth");
INSERT INTO employee_address(Street_No,Street_Name,Suburb) VALUES (78,"Park Lane","Como");
INSERT INTO employee_address(Street_No,Street_Name,Suburb) VALUES (54,"Rivin Loop","Bayswater");
INSERT INTO employee_address(Street_No,Street_Name,Suburb) VALUES (15,"Mellow Circle","Bunbury");
INSERT INTO employee_address(Street_No,Street_Name,Suburb) VALUES (56,"Mellow Circle","Bunbury");
INSERT INTO employee_address(Street_No,Street_Name,Suburb) VALUES (78,"Blue Road","Rockingham");

#Inserting records into employee table
INSERT INTO employee(Mobile_No,First_Name,Last_Name,Employee_Address_id,Is_Chef,Is_Driver,Base_Salary) VALUES ("0487659234","Kathy","Bowste",1,TRUE,FALSE,1549);
INSERT INTO employee(Mobile_No,First_Name,Last_Name,Employee_Address_id,Is_Chef,Is_Driver,Base_Salary) VALUES ("0434659234","Mel","West",2,TRUE,TRUE,1649);
INSERT INTO employee(Mobile_No,First_Name,Last_Name,Employee_Address_id,Is_Chef,Is_Driver,Base_Salary) VALUES ("0487651234","George","Bowste",3,TRUE,TRUE,1749);
INSERT INTO employee(Mobile_No,First_Name,Last_Name,Employee_Address_id,Is_Chef,Is_Driver,Base_Salary) VALUES ("0487234234","Kevin","Frazer",4,FALSE,TRUE,1549);
INSERT INTO employee(Mobile_No,First_Name,Last_Name,Employee_Address_id,Is_Chef,Is_Driver,Base_Salary) VALUES ("0494559234","Ben","Hughes",5,TRUE,FALSE,1949);
INSERT INTO employee(Mobile_No,First_Name,Last_Name,Employee_Address_id,Is_Chef,Is_Driver,Base_Salary) VALUES ("0487596724","Sally","Gray",6,TRUE,TRUE,1849);
INSERT INTO employee(Mobile_No,First_Name,Last_Name,Employee_Address_id,Is_Chef,Is_Driver,Base_Salary) VALUES ("0487683167","Keith","Brown",7,FALSE,TRUE,2049);
INSERT INTO employee(Mobile_No,First_Name,Last_Name,Employee_Address_id,Is_Chef,Is_Driver,Base_Salary) VALUES ("0487785434","Leighton","Harvey",8,TRUE,FALSE,1849);
INSERT INTO employee(Mobile_No,First_Name,Last_Name,Employee_Address_id,Is_Chef,Is_Driver,Base_Salary) VALUES ("0487562434","Emma","Louise",9,TRUE,TRUE,1849);
INSERT INTO employee(Mobile_No,First_Name,Last_Name,Employee_Address_id,Is_Chef,Is_Driver,Base_Salary) VALUES ("0487486234","Bray","Hodge",10,FALSE,TRUE,1849);

#Insert records into order_handled_by table
INSERT INTO order_handled_by(Order_id,Employee_id) VALUES(1,2);
INSERT INTO order_handled_by(Order_id,Employee_id) VALUES(2,3);
INSERT INTO order_handled_by(Order_id,Employee_id) VALUES(3,4);
INSERT INTO order_handled_by(Order_id,Employee_id) VALUES(4,2);
INSERT INTO order_handled_by(Order_id,Employee_id) VALUES(5,4);
INSERT INTO order_handled_by(Order_id,Employee_id) VALUES(6,3);
INSERT INTO order_handled_by(Order_id,Employee_id) VALUES(7,6);
INSERT INTO order_handled_by(Order_id,Employee_id) VALUES(8,6);
INSERT INTO order_handled_by(Order_id,Employee_id) VALUES(9,7);
INSERT INTO order_handled_by(Order_id,Employee_id) VALUES(10,9);

#Inserting records into pizza table
INSERT INTO pizza(Pizza_Name) VALUES ("Meat Lovers");
INSERT INTO pizza(Pizza_Name) VALUES ("Vegetarian");
INSERT INTO pizza(Pizza_Name) VALUES ("Hawaaian");
INSERT INTO pizza(Pizza_Name) VALUES ("Cheese Supreme");
INSERT INTO pizza(Pizza_Name) VALUES ("Pepperoni");
INSERT INTO pizza(Pizza_Name) VALUES ("New Yorker");
INSERT INTO pizza(Pizza_Name) VALUES ("Peri Peri Chicken");
INSERT INTO pizza(Pizza_Name) VALUES ("BBQ");
INSERT INTO pizza(Pizza_Name) VALUES ("Supreme");
INSERT INTO pizza(Pizza_Name) VALUES ("Bacon & Chorizo");

#Inserting records into extra_items table
INSERT INTO extra_items(Item_Name,Item_Description,Manufacturer_Name,Supplier,Retail_price,Cost) VALUES ("Coke","Cold Beverage","Coca-Cola","2UDirect",2.00,1.10);
INSERT INTO extra_items(Item_Name,Item_Description,Manufacturer_Name,Supplier,Retail_price,Cost) VALUES ("Picnic","Confectionary","Cadbury","Warehouse Direct",1.50,0.97);
INSERT INTO extra_items(Item_Name,Item_Description,Manufacturer_Name,Supplier,Retail_price,Cost) VALUES ("Beef Jerky","Snack Item","Father Lambs","2UDirect",5.49,1.10);
INSERT INTO extra_items(Item_Name,Item_Description,Manufacturer_Name,Supplier,Retail_price,Cost) VALUES ("Sprite","Cold Beverage","Coca-Cola","Drinks Frenzy",2.00,1.16);
INSERT INTO extra_items(Item_Name,Item_Description,Manufacturer_Name,Supplier,Retail_price,Cost) VALUES ("Gummy Bears","Confectionary","Haribo","2UDirect",3.46,2.10);
INSERT INTO extra_items(Item_Name,Item_Description,Manufacturer_Name,Supplier,Retail_price,Cost) VALUES ("Water","Beverage","Coca-Cola","Drinks Frenzy",2.51,1.07);
INSERT INTO extra_items(Item_Name,Item_Description,Manufacturer_Name,Supplier,Retail_price,Cost) VALUES ("Garlic Bread","Snack Item","Garlic Fiesta","2UDirect",7.63,4.10);
INSERT INTO extra_items(Item_Name,Item_Description,Manufacturer_Name,Supplier,Retail_price,Cost) VALUES ("Chips","Snack Item","McCains","Warehouse Direct",4.00,3.10);
INSERT INTO extra_items(Item_Name,Item_Description,Manufacturer_Name,Supplier,Retail_price,Cost) VALUES ("Doughnuts","Snack Item","Krispy Kreme","2UDirect",6.42,4.14);
INSERT INTO extra_items(Item_Name,Item_Description,Manufacturer_Name,Supplier,Retail_price,Cost) VALUES ("Solo","Cold Beverage","Coca-Cola","Drinks Frenzy",2.00,1.20);

#Inserting records into ordered_extras table
INSERT INTO ordered_extras(Order_id,Product_Code,Quantity) VALUES (1,2,2);
INSERT INTO ordered_extras(Order_id,Product_Code,Quantity) VALUES (1,1,2);
INSERT INTO ordered_extras(Order_id,Product_Code,Quantity) VALUES (2,5,2);
INSERT INTO ordered_extras(Order_id,Product_Code,Quantity) VALUES (3,3,2);
INSERT INTO ordered_extras(Order_id,Product_Code,Quantity) VALUES (4,7,2);
INSERT INTO ordered_extras(Order_id,Product_Code,Quantity) VALUES (6,2,2);
INSERT INTO ordered_extras(Order_id,Product_Code,Quantity) VALUES (8,2,2);
INSERT INTO ordered_extras(Order_id,Product_Code,Quantity) VALUES (5,3,2);
INSERT INTO ordered_extras(Order_id,Product_Code,Quantity) VALUES (7,4,2);

#Inserting records into ingredients table
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Tomato Paste",5.00,2.00);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Cheese",2.00,1.33);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Avocado",1.00,0.57);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Sausage",3.00,1.83);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Mushrooms",1.00,0.39);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Onions",1.00,0.30);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Pepperoni",2.30,1.56);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Chicken",2.00,0.97);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Pineapple",0.80,0.10);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Ham",2.50,1.79);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Olives",1.00,0.53);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Chilli Flakes",0.95,0.23);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Artichokes",2.50,1.33);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Jalepeno",2.00,1.68);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Capsicum",1.54,0.89);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Beef",3.00,2.10);
INSERT INTO ingredients(Ingredient_Name,Retail_price,Cost) VALUES ("Bacon",2.34,1.56);

#Inserting records into sizes table
INSERT INTO sizes(Size_Type,Size_Multiply_Price) VALUES ("Small",1);
INSERT INTO sizes(Size_Type,Size_Multiply_Price) VALUES ("Medium",1.5);
INSERT INTO sizes(Size_Type,Size_Multiply_Price) VALUES ("Large",2);
INSERT INTO sizes(Size_Type,Size_Multiply_Price) VALUES ("Family",2.5);
INSERT INTO sizes(Size_Type,Size_Multiply_Price) VALUES ("Super",3);

#Inserting records into order_details table
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (1,1,"Thin",2,1,5,1);
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (2,1,"Regular",3,2,5,2);
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (3,2,"Thick",1,2,10,2);
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (4,2,"Thin",4,2,0,3);
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (5,5,"Regular",5,1,0,9);
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (6,3,"Thin",1,1,5,9);
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (7,3,"Regular",4,5,7,8);
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (8,8,"Thin",2,1,5,6);
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (9,9,"Thick",2,1,0,5);
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (10,2,"Regular",1,2,0,5);
INSERT INTO order_details(Order_id,Pizza_id,Crust,Size,Pizza_Quantity,Discount,Employee_id) VALUES (2,4,"Regular",3,2,0,3);

#Inserting records into order_extra_ingredients
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (1,2,1);
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (2,9,1);
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (2,2,1);
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (2,3,1);
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (3,2,1);
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (3,3,2);
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (5,2,2);
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (7,4,2);
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (7,2,1);
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (9,16,1);
INSERT INTO order_extra_ingredients(Pizza_Ordered_id,Ingredient_id,Extra_Ingredients_Quantity) VALUES (9,2,1);

#Insert records into pizza_ingredients table
#INPUT DATE FOR PIZZA 1
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (1,1,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (1,2,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (1,4,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (1,17,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (1,10,1);
#INPUT DATE FOR PIZZA 2
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (2,1,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (2,2,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (2,3,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (2,5,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (2,6,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (2,11,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (2,13,1);
#INPUT DATE FOR PIZZA 3
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (3,1,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (3,2,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (3,9,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (3,10,1);
#INPUT DATE FOR PIZZA 4
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (4,1,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (4,2,2);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (4,6,1);
#INPUT DATE FOR PIZZA 5
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (5,1,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (5,2,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (5,6,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (5,7,1);
#INPUT DATE FOR PIZZA 6
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (6,1,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (6,2,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (6,6,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (6,8,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (6,12,1);
#INPUT DATE FOR PIZZA 7
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (7,1,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (7,2,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (7,8,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (7,14,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (7,16,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (7,17,1);
#INPUT DATE FOR PIZZA 8
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (8,1,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (8,2,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (8,4,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (8,8,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (8,11,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (8,14,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (8,15,1);
#INPUT DATE FOR PIZZA 9
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (9,1,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (9,2,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (9,4,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (9,7,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (9,12,1);
#INPUT DATE FOR PIZZA 10
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (10,1,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (10,2,2);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (10,4,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (10,12,1);
INSERT INTO pizza_ingredients(Pizza_id,Ingredient_id,Ingredients_Quantity) VALUES (10,17,1);

#Part 3

#QUERY  for Task 3a
SELECT *
FROM employee
WHERE Is_Chef=TRUE AND Is_Driver=TRUE
GROUP BY Employee_id;

#Query for Task 3b
SELECT *,IFNULL(round(SUM(Pizza_Revenue+Extras_Revenue+Extra_Ingredients_Revenue),2),0) AS Total_Revenue
FROM( 
	#Get revenue from sales of pizza
	SELECT Suburb,IFNULL(round(SUM(Size_Multiply_Price*Pizza_Quantity*Retail_price*Ingredients_Quantity*((100-Discount)/100)),2),0) AS Pizza_Revenue
		FROM customer_address ca LEFT JOIN customer c
		ON c.Customer_Address_id = ca.Customer_Address_id 
		LEFT JOIN orders o ON c.Mobile_No=o.Mobile_No
		LEFT JOIN order_details od ON o.Order_id=od.Order_id
		LEFT JOIN sizes ON od.Size=sizes.Size_Id
		LEFT JOIN pizza p ON od.Pizza_id=p.Pizza_id
		LEFT JOIN pizza_ingredients pi ON p.Pizza_id=pi.Pizza_id
		LEFT JOIN ingredients i ON pi.Ingredient_id=i.Ingredient_id
		GROUP BY (Suburb)) Pizza
NATURAL JOIN 
	#Get revenue from sales of extras
	(SELECT Suburb, IFNULL(round(SUM((Quantity)*Retail_price),2),0) AS Extras_Revenue
		FROM customer_address ca LEFT JOIN customer c
		on ca.Customer_Address_id = c.Customer_Address_id 
		LEFT JOIN orders o ON c.Mobile_No=o.Mobile_No
		LEFT JOIN ordered_extras oe ON o.Order_id=oe.Order_id
		LEFT JOIN extra_items ei ON oe.Product_Code=ei.Product_Code
		GROUP BY(Suburb)) Extra_Sides
NATURAL JOIN
		#Get sales from sales of extra ingredients
		(SELECT Suburb,IFNULL(round(SUM(Extra_Ingredients_Quantity*ingredients.Retail_price*Pizza_Quantity),2),0) AS Extra_Ingredients_Revenue
		FROM customer_address LEFT JOIN customer ON customer_address.Customer_Address_id = customer.Customer_Address_id 
		LEFT JOIN orders ON customer.Mobile_No=orders.Mobile_No
		LEFT JOIN order_details ON orders.Order_id=order_details.Order_id
		LEFT JOIN pizza ON order_details.Pizza_id=pizza.Pizza_id  
		LEFT JOIN order_extra_ingredients ON order_details.Pizza_Ordered_id=order_extra_ingredients.Pizza_Ordered_id
		LEFT JOIN ingredients ON order_extra_ingredients.Ingredient_id=ingredients.Ingredient_id
		GROUP BY (Suburb)) Extra_Ingredients 
#Group query by suburb and order by total_revenue
GROUP BY Suburb
ORDER BY Total_Revenue DESC;

    
#Task 3c
DROP PROCEDURE IF EXISTS SuburbBestCustomer;
DELIMITER //
CREATE PROCEDURE SuburbBestCustomer() 
BEGIN
SELECT *
FROM(
SELECT *,IFNULL(round(MAX(Spent_On_Extras+Spent_On_Pizza+Spent_On_Extra_Ingredients),2),0) AS Total_Spent
FROM(
#Customers spent on extras
SELECT customer.First_Name,customer.Last_Name,Suburb,customer.Mobile_No, IFNULL(round(SUM(Quantity*Retail_price),2),0) AS Spent_on_Extras
	FROM customer_address LEFT JOIN customer
	ON customer_address.Customer_Address_id = customer.Customer_Address_id 
	LEFT JOIN orders ON customer.Mobile_No=orders.Mobile_No
	LEFT JOIN ordered_extras ON orders.Order_id=ordered_extras.Order_id
	LEFT JOIN extra_items ON ordered_extras.Product_Code=extra_items.Product_Code
	GROUP BY(customer.Mobile_No)) EXTRAS
    NATURAL JOIN (
#Customers spent on pizza
SELECT customer.First_Name,customer.Last_Name,Suburb,customer.Mobile_No, IFNULL(round(SUM(((100-Discount)/100)*(Pizza_Quantity*Size_Multiply_Price*(Ingredients_Quantity*Retail_price))),2),0) AS Spent_On_Pizza
	FROM customer_address LEFT JOIN customer
	ON customer_address.Customer_Address_id = customer.Customer_Address_id 
	LEFT JOIN orders ON customer.Mobile_No=orders.Mobile_No
	LEFT JOIN order_details ON orders.Order_id=order_details.Order_id
	LEFT JOIN sizes ON sizes.Size_Id=order_details.Size
	LEFT JOIN pizza ON order_details.Pizza_id=pizza.Pizza_id
    LEFT JOIN pizza_ingredients pi ON pizza.Pizza_id=pi.Pizza_id
    LEFT JOIN ingredients i ON pi.Ingredient_id=i.Ingredient_id
	GROUP BY (customer.Mobile_No)) PIZZA
    NATURAL JOIN (
#Customers spent on extra ingredients
SELECT customer.First_Name,customer.Last_Name,Suburb,customer.Mobile_No,IFNULL(SUM(Extra_Ingredients_Quantity*ingredients.Retail_price*Pizza_Quantity),0) AS Spent_On_Extra_Ingredients
	FROM customer_address LEFT JOIN customer
	ON customer_address.Customer_Address_id = customer.Customer_Address_id 
	LEFT JOIN orders ON customer.Mobile_No=orders.Mobile_No
	LEFT JOIN order_details ON orders.Order_id=order_details.Order_id
	LEFT JOIN pizza ON order_details.Pizza_id=pizza.Pizza_id
	LEFT JOIN order_extra_ingredients ON order_details.Pizza_Ordered_id=order_extra_ingredients.Pizza_Ordered_id
	LEFT JOIN ingredients ON order_extra_ingredients.Ingredient_id=ingredients.Ingredient_id
	GROUP BY (customer.Mobile_No)) EXTRA_ING
GROUP BY Mobile_No
ORDER BY Total_Spent DESC) ORDERED
GROUP BY Suburb;
			
END//
DELIMITER ;

CALL SuburbBestCustomer();

#Task 3d 
#Ingredients not selected as extras by customers
SELECT DISTINCT Ingredient_Name AS Ingredients_Not_Selected_As_Extras
FROM ingredients LEFT JOIN order_extra_ingredients 
ON order_extra_ingredients.Ingredient_id=ingredients.Ingredient_id
WHERE order_extra_ingredients.Extra_Ingredients_Quantity IS NULL;

#Task 3e
DROP VIEW IF EXISTS EmployeeSalary;
CREATE VIEW EmployeeSalary AS
SELECT *,round(SUM(Deliveries_Made_Income+Pizzas_Made_Income+Base_Salary),2) AS Total_Income
FROM(
SELECT Employee_id,First_Name,Last_Name,Base_Salary,IFNULL(round(Pizza_Made_Income,2),0) AS Pizzas_Made_Income,
IFNULL(round(SUM(2*Deliveries_Made),2),0) AS Deliveries_Made_Income
FROM ( SELECT e.Employee_id,SUM(0.5*Pizza_Quantity) AS Pizza_Made_Income
		FROM employee e LEFT JOIN order_details od
		ON e.Employee_id=od.Employee_id
		GROUP BY e.Employee_id) p
NATURAL JOIN (SELECT e.Employee_id,COUNT(oh.Employee_id) AS Deliveries_Made
				FROM employee e LEFT JOIN order_handled_by oh
				ON e.Employee_id=oh.Employee_id
				GROUP BY e.Employee_id) e
NATURAL JOIN employee
GROUP BY Employee_id) t
GROUP BY Employee_id;

SELECT * FROM EmployeeSalary;

#Task 3f
SELECT Ingredient_Name,round(SUM(Pizza_Quantity*(Ingredients_Quantity*(Retail_price-Cost))),2) AS Profit
FROM order_details od JOIN pizza p
ON od.Pizza_id=p.Pizza_id
JOIN pizza_ingredients pi ON p.Pizza_id=pi.Pizza_id
JOIN ingredients i ON pi.Ingredient_id=i.Ingredient_id
GROUP BY Ingredient_Name
ORDER BY Profit DESC
LIMIT 10;


    
    
    
