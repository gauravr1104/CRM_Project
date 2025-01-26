create table Customers(
   Customer_ID INT Primary Key,
   First_Name VARCHAR (50),
   Last_Name VARCHAR (50),
   Email VARCHAR (100),
   Phone_Number VARCHAR (15),
   Address VARCHAR (255),
   Assigned_SalesRep_ID INT,
   Customer_Join_Date DATE,
   Foreign Key (Assigned_SalesRep_ID) references SalesRepresentatives(SalesRep_ID)  
)




create table Leads(
   Lead_ID int Primary Key,
   First_Name VARCHAR( 50),
   Last_Name VARCHAR( 50),
   Email VARCHAR(100),
   Phone_Number VARCHAR(15),
   Address VARCHAR(255),
   Source VARCHAR(100),
   Status VARCHAR(50),
   Notes TEXT,
   Lead_Creation_Date Date
)


CREATE TABLE SalesRepresentatives(
   SalesRep_ID INT Primary Key,
   First_Name VARCHAR(50),
   Last_Name VARCHAR(50),
   Email VARCHAR(100),
   Phone_Number VARCHAR(15),
   Department VARCHAR(100)
)

CREATE TABLE Products(
   Product_ID int Primary Key,
   Product_Name VARCHAR(100),
   Description TEXT,
   Price DECIMAL(10, 2),
   Quantity_in_Stock INT
)

CREATE TABLE  ORDERS(
   Order_ID INT Primary Key,
   Customer_ID INT ,
   Order_Date DATE,
   Total_Amount DECIMAL(10, 2),
   foreign key (Customer_ID) references Customers(Customer_ID)
)


CREATE TABLE Order_Items(
   Order_Item_ID INT Primary Key,
   Order_ID INT,
   Product_ID INT,
   Quantity INT,
   Unit_Price DECIMAL(10, 2),
   Foreign Key (Order_ID = o.Order_ID) references Orders(Order_ID),
   Foreign Key (Product_ID) references Products(Product_ID)
   )

CREATE TABLE  Interactions(
   Interaction_ID INT Primary Key,
   Lead_ID INT ,
   SalesRep_ID INT ,
   Interaction_Date DATE,
   Interaction_Type VARCHAR(50),
   Outcome VARCHAR(100),
   Notes TEXT,
   Foreign Key (Lead_ID) references Leads(Lead_ID),
   Foreign Key (SalesRep_ID) references SalesRepresentatives(SalesRep_ID)
  )


  CREATE TABLE Tasks(
   Task_ID INT Primary Key,
   Description TEXT,
   Due_Date DATE,
   Status VARCHAR(50),
   Priority VARCHAR (50),
   Assigned_To int,
   Foreign Key (Assigned_To) references SalesRepresentatives(SalesRep_ID)

   )




create view CRM_DATA as (
select c.Customer_ID,c.First_Name as cust_First_Name,c.Last_Name as cust_Last_Name,
c.Email as cust_Email,c.Phone_Number as cust_Phone_Number,
c.Address,c.Assigned_SalesRep_ID,c.Customer_Join_Date,
o.Order_ID,o.Order_Date,o.Total_Amount,
s.SalesRep_ID,s.First_Name,s.Last_Name,s.Email,s.Phone_Number,
t.Task_ID,t.Description as task_Description,t.Due_Date,t.Status as task_status,t.Priority,t.Assigned_To,
oi.Order_Item_ID,oi.Product_ID,oi.Quantity,oi.Unit_Price,
p.Product_Name,p.Description,p.Price,p.Quantity_in_Stock,
i.Interaction_ID,i.Lead_ID,i.Interaction_Date,i.Interaction_Type,i.Outcome,i.Notes as i_notes,
l.Source,l.Status,l.Notes,l.Lead_Creation_Date
from Customers as c
LEFT join
orders as o 
on c.Customer_ID = o.Customer_ID
LEFT join
SalesRepresentatives as s
on c.Assigned_SalesRep_ID = s.SalesRep_ID
LEFT join 
Tasks as t
on t.Assigned_To = s.SalesRep_ID
LEFT join 
Order_Items as oi
on oi.Order_ID = o.Order_ID
LEFT join
Products as p
on p.Product_ID = oi.Product_ID
LEFT join 
Interactions as i
on i.SalesRep_ID = s.SalesRep_ID
LEFT join
Leads as l
on l.Lead_ID = i.Lead_ID )



CREATE OR REPLACE FUNCTION update_final_view()
RETURNS TRIGGER AS $$
BEGIN
    
    RAISE NOTICE 'Final View Updated Successfully.';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_customers
AFTER INSERT OR UPDATE OR DELETE ON Customers
FOR EACH ROW
EXECUTE FUNCTION update_final_view();

CREATE TRIGGER trigger_lead
AFTER INSERT OR UPDATE OR DELETE ON Leads
FOR EACH ROW
EXECUTE FUNCTION update_final_view();

CREATE TRIGGER trigger_orders
AFTER INSERT OR UPDATE OR DELETE ON Orders
FOR EACH ROW
EXECUTE FUNCTION update_final_view();

CREATE TRIGGER trigger_order_items
AFTER INSERT OR UPDATE OR DELETE ON Order_Items
FOR EACH ROW
EXECUTE FUNCTION update_final_view();

CREATE TRIGGER trigger_interactions
AFTER INSERT OR UPDATE OR DELETE ON Interactions
FOR EACH ROW
EXECUTE FUNCTION update_final_view();

CREATE TRIGGER trigger_tasks
AFTER INSERT OR UPDATE OR DELETE ON Tasks
FOR EACH ROW
EXECUTE FUNCTION update_final_view();

CREATE TRIGGER trigger_products
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION update_final_view();

CREATE TRIGGER trigger_salesrepresentatives
AFTER INSERT OR UPDATE OR DELETE ON salesrepresentatives
FOR EACH ROW
EXECUTE FUNCTION update_final_view();
















  














