----- Load Sales_Data Table -----
CREATE OR REPLACE PROCEDURE CAP_PROJECT.Acquisition.Load_Sales_Data()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    COPY INTO CAP_PROJECT.Acquisition.Sales_Data
    FROM @CAP_PROJECT.Acquisition.CP_LOADDATA
    PATTERN = '(?i).*_sales_data_.*\.csv'
    FILE_FORMAT = (FORMAT_NAME = 'CSV_FILE_FORMAT')
    ON_ERROR = 'CONTINUE';
    RETURN 'Data load completed successfully';
END;
$$;


CREATE OR REPLACE TASK CAP_PROJECT.Acquisition.Load_Sales_Data_Task
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 0 0 * * * UTC' 
AS
CALL CAP_PROJECT.Acquisition.Load_Sales_Data();




----- Load Customers_Data Table ----- 
CREATE OR REPLACE PROCEDURE CAP_PROJECT.Acquisition.Load_Customers_Data()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    COPY INTO CAP_PROJECT.Acquisition.Customers_Data
    FROM @CAP_PROJECT.Acquisition.CP_LOADDATA
    PATTERN = '(?i).*_Customers_.*\.csv'
    FILE_FORMAT = (FORMAT_NAME = 'CSV_FILE_FORMAT')
    ON_ERROR = 'CONTINUE';
    RETURN 'Data load completed successfully';
END;
$$;


CREATE OR REPLACE TASK CAP_PROJECT.Acquisition.Load_Customers_Data_Task
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 0 0 * * * UTC' 
AS
CALL CAP_PROJECT.Acquisition.Load_Customers_Data();




----- Load Returns_Data Table ----- 
CREATE OR REPLACE PROCEDURE CAP_PROJECT.Acquisition.Load_Returns_Data()
RETURNS STRING
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
BEGIN
    COPY INTO CAP_PROJECT.Acquisition.Returns_Data
    FROM @CAP_PROJECT.Acquisition.CP_LOADDATA
    PATTERN = '(?i).*_Customers_.*\.csv'
    FILE_FORMAT = (FORMAT_NAME = 'CSV_FILE_FORMAT')
    ON_ERROR = 'CONTINUE';
    RETURN 'Data load completed successfully';
END;
$$;


CREATE OR REPLACE TASK CAP_PROJECT.Acquisition.Load_Customers_Data_Task
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 0 0 * * * UTC' 
AS
CALL CAP_PROJECT.Acquisition.Load_Customers_Data();



