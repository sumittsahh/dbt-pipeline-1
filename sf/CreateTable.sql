----- Create Sales_Data Table -----
CREATE or replace TABLE Sales_Data( 
    OrderDate VARCHAR , 
    StockDate VARCHAR , 
    OrderNumber VARCHAR , 
    ProductKey NUMBER(38, 0) , 
    CustomerKey NUMBER(38, 0) , 
    TerritoryKey NUMBER(38, 0) , 
    OrderLineItem NUMBER(38, 0) , 
    OrderQuantity NUMBER(38, 0) ,
    Row_Hash STRING,
    FileName STRING,
    FileLoadTime TIMESTAMP
);



----- Create Customers_Data Table -----
CREATE or replace TABLE Customers_Data ( 
    CustomerKey STRING , 
    Prefix VARCHAR , 
    FirstName VARCHAR , 
    LastName VARCHAR , 
    BirthDate VARCHAR , 
    MaritalStatus VARCHAR , 
    Gender VARCHAR , 
    EmailAddress VARCHAR , 
    AnnualIncome NUMBER(38, 0) , 
    TotalChildren NUMBER(38, 0) , 
    EducationLevel VARCHAR , 
    Occupation VARCHAR , 
    HomeOwner BOOLEAN ,
    Row_Hash STRING,
    FileName STRING,
    FileLoadTime TIMESTAMP
);




----- Create Returns_Data Table -----
CREATE or replace TABLE Returns_Data ( 
    ReturnDate VARCHAR , 
    TerritoryKey NUMBER(38, 0) , 
    ProductKey NUMBER(38, 0) , 
    ReturnQuantity NUMBER(38, 0) ,
    Row_Hash STRING,
    FileName STRING,
    FileLoadTime TIMESTAMP
);


----- Create Products_Data Table -----
CREATE OR REPLACE TABLE PRODUCTS_DATA (
    ProductKey INT,
    ProductSubcategoryKey INT,
    ProductSKU VARCHAR(50),
    ProductName VARCHAR(100),
    ModelName VARCHAR(100),
    ProductDescription VARCHAR(255),
    ProductColor VARCHAR(50),
    ProductSize VARCHAR(10),
    ProductStyle VARCHAR(10),
    ProductCost FLOAT,
    ProductPrice FLOAT,
    Row_Hash STRING,
    FileName STRING,
    FileLoadTime TIMESTAMP
);

