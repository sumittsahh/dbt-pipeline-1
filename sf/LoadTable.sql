----- Load Sales_Data Table -----
CREATE OR REPLACE PROCEDURE CAP_PROJECT.ACQUISITION.Load_Sales()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    MERGE INTO CAP_PROJECT.ACQUISITION.Sales_Data AS target
    USING (
        SELECT 
            $1 AS OrderDate,
            $2 AS StockDate, 
            $3 AS OrderNumber,
            $4 AS ProductKey,
            $5 AS CustomerKey,
            $6 AS TerritoryKey,
            $7 AS OrderLineItem,
            $8 AS OrderQuantity,
            MD5(CONCAT_WS('|', $3, $4, $5, $6, $7)) AS Row_Hash,
            METADATA$FILENAME AS FileName,       
            CURRENT_TIMESTAMP() AS FileLoadTime
        FROM @CAP_PROJECT.ACQUISITION.ACQ_RAW_LOAD
        (FILE_FORMAT => 'CSV_FILE_FORMAT', PATTERN => '(?i).*_Sales_Data_.*\.csv')
    ) AS source
    ON target.Row_Hash = source.Row_Hash
    WHEN MATCHED AND (
            target.OrderDate <> source.OrderDate
            OR target.StockDate <> source.StockDate
            OR target.OrderQuantity <> source.OrderQuantity
        ) THEN
    UPDATE SET 
        OrderDate = source.OrderDate,
        StockDate = source.StockDate,
        OrderQuantity = source.OrderQuantity,
        FileName = source.FileName,   
        FileLoadTime = source.FileLoadTime
    WHEN NOT MATCHED THEN
    INSERT (OrderDate, StockDate, OrderNumber, ProductKey, CustomerKey, TerritoryKey, OrderLineItem, OrderQuantity, Row_Hash, FileName, FileLoadTime)
    VALUES (source.OrderDate, source.StockDate, source.OrderNumber, source.ProductKey, source.CustomerKey, 
            source.TerritoryKey, source.OrderLineItem, source.OrderQuantity, source.Row_Hash, source.FileName, source.FileLoadTime);

    RETURN 'Data Loaded and Updated Successfully!';
END;
$$;

CREATE OR REPLACE TASK CAP_PROJECT.ACQUISITION.Load_Sales_Data
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 0 0 * * * UTC'  -- Runs Daily at Midnight UTC
AS
CALL CAP_PROJECT.ACQUISITION.Load_Sales();






----- Load Customers_Data Table ----- 
CREATE OR REPLACE PROCEDURE CAP_PROJECT.ACQUISITION.Load_Customers()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    MERGE INTO CAP_PROJECT.ACQUISITION.Customers_Data AS target
    USING (
        SELECT 
            $1 AS CustomerKey,
            $2 AS Prefix,
            $3 AS FirstName,
            $4 AS LastName,
            $5 AS BirthDate,  
            $6 AS MaritalStatus,
            $7 AS Gender,
            $8 AS EmailAddress,
            $9 AS AnnualIncome,
            $10 AS TotalChildren,
            $11 AS EducationLevel,
            $12 AS Occupation,
            $13 AS HomeOwner,
            MD5(CONCAT_WS('|', $1, $8)) AS Row_Hash,
            METADATA$FILENAME AS FileName,       
            CURRENT_TIMESTAMP() AS FileLoadTime
        FROM @CAP_PROJECT.ACQUISITION.ACQ_RAW_LOAD
        (FILE_FORMAT => 'CSV_FILE_FORMAT', PATTERN => '(?i).*_Customers_.*\.csv')
    ) AS source
    ON target.Row_Hash = source.Row_Hash
    WHEN MATCHED AND (
            target.Prefix <> source.Prefix
            OR target.FirstName <> source.FirstName
            OR target.LastName <> source.LastName
            OR target.BirthDate <> source.BirthDate
            OR target.MaritalStatus <> source.MaritalStatus
            OR target.Gender <> source.Gender
            OR target.EmailAddress <> source.EmailAddress
            OR target.AnnualIncome <> source.AnnualIncome
            OR target.TotalChildren <> source.TotalChildren
            OR target.EducationLevel <> source.EducationLevel
            OR target.Occupation <> source.Occupation
            OR target.HomeOwner <> source.HomeOwner
        ) THEN
    UPDATE SET 
        Prefix = source.Prefix,
        FirstName = source.FirstName,
        LastName = source.LastName,
        BirthDate = source.BirthDate,
        MaritalStatus = source.MaritalStatus,
        Gender = source.Gender,
        EmailAddress = source.EmailAddress,
        AnnualIncome = source.AnnualIncome,
        TotalChildren = source.TotalChildren,
        EducationLevel = source.EducationLevel,
        Occupation = source.Occupation,
        HomeOwner = source.HomeOwner,
        FileName = source.FileName,   
        FileLoadTime = source.FileLoadTime
    WHEN NOT MATCHED THEN
    INSERT (CustomerKey, Prefix, FirstName, LastName, BirthDate, MaritalStatus, Gender, EmailAddress,  
            AnnualIncome, TotalChildren, EducationLevel, Occupation, HomeOwner, Row_Hash, FileName, FileLoadTime)
    VALUES (source.CustomerKey, source.Prefix, source.FirstName, source.LastName, source.BirthDate,  
            source.MaritalStatus, source.Gender, source.EmailAddress, source.AnnualIncome,  
            source.TotalChildren, source.EducationLevel, source.Occupation, source.HomeOwner,  
            source.Row_Hash, source.FileName, source.FileLoadTime);

    RETURN 'Data Loaded and Updated Successfully!';
END;
$$;

CREATE OR REPLACE TASK CAP_PROJECT.ACQUISITION.Load_Customers_Data
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 0 0 * * * UTC' 
AS
CALL CAP_PROJECT.ACQUISITION.Load_Customers();






----- Load Returns_Data Table ----- 
CREATE OR REPLACE PROCEDURE CAP_PROJECT.ACQUISITION.Load_Returns()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    MERGE INTO CAP_PROJECT.ACQUISITION.RETURNS_DATA AS target
    USING (
        SELECT 
            TRY_TO_DATE($1, 'DD/MM/YYYY') AS ReturnDate,  
            $2 AS TerritoryKey,
            $3 AS ProductKey,
            $4 AS ReturnQuantity,
            MD5(CONCAT_WS('|', $1, $2, $3)) AS Row_Hash,
            METADATA$FILENAME AS FileName,       
            CURRENT_TIMESTAMP() AS FileLoadTime
        FROM @CAP_PROJECT.ACQUISITION.ACQ_RAW_LOAD
        (FILE_FORMAT => 'CSV_FILE_FORMAT', PATTERN => '(?i).*_Returns_.*\.csv')
    ) AS source
    ON target.Row_Hash = source.Row_Hash
    WHEN MATCHED AND (
            target.ReturnQuantity <> source.ReturnQuantity
        ) THEN
    UPDATE SET 
        ReturnQuantity = source.ReturnQuantity,
        FileName = source.FileName,   
        FileLoadTime = source.FileLoadTime
    WHEN NOT MATCHED THEN
    INSERT (ReturnDate, TerritoryKey, ProductKey, ReturnQuantity, Row_Hash, FileName, FileLoadTime)
    VALUES (source.ReturnDate, source.TerritoryKey, source.ProductKey, source.ReturnQuantity, source.Row_Hash, source.FileName, source.FileLoadTime);

    RETURN 'Data Loaded and Updated Successfully!';
END;
$$;

CREATE OR REPLACE TASK CAP_PROJECT.ACQUISITION.Load_Returns_Data
WAREHOUSE = COMPUTE_WH 
SCHEDULE = 'USING CRON 0 0 * * * UTC'  
AS
CALL CAP_PROJECT.ACQUISITION.Load_Returns();





