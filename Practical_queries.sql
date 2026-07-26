CREATE OR REPLACE TABLE FRUIT_OPTIONS(FRUIT_ID NUMBER,
FRUIT_NAME VARCHAR(25));

----creating file format to remove extra characters-----
create file format smoothies.public.two_headerrow_pct_delim
  type = CSV,
  skip_header = 2,
  field_delimiter = '%',
  trim_space = TRUE
;

---Query the data which is sitting in stage before loading into the table---
SELECT $1, $2
FROM @SMOOTHIES.PUBLIC.MY_UPLOADED_FILES/fruits_available_for_smoothies.txt
(FILE_FORMAT => SMOOTHIES.PUBLIC.TWO_HEADERROW_PCT_DELIM);

---- load data into target table --------
COPY INTO smoothies.public.fruit_options
FROM @smoothies.public.my_uploaded_files
FILES = ('fruits_available_for_smoothies.txt')
FILE_FORMAT = (FORMAT_NAME = smoothies.public.two_headerrow_pct_delim)
ON_ERROR = ABORT_STATEMENT
VALIDATION_MODE = RETURN_ERRORS;
PURGE = TRUE;

--- Reorder Columns During the COPY INTO LOAD----------
COPY INTO smoothies.public.fruit_options
FROM (SELECT $2 AS fruit_id, $1 AS fruit_name
FROM @smoothies.public.my_uploaded_files/fruits_available_for_smoothies.txt)
FILE_FORMAT = (FORMAT_NAME = smoothies.public.two_headerrow_pct_delim)
ON_ERROR = ABORT_STATEMENT
PURGE = TRUE;
