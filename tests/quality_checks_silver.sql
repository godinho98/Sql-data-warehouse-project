/*
-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
QUALITY CHECKS
-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Script purpose:
    This script validates the quality of data after it has been transformed 
    into the Silver layer. The goal is to ensure the data is clean, consistent, 
    and ready for downstream use (analytics, reporting, Gold layer).

Checks Included:
    - Detection of NULL or duplicate primary keys
    - Identification of leading/trailing or unwanted spaces in text fields
    - Validation of data standardization (formats, categories, labels)
    - Detection of invalid or unrealistic date values
    - Consistency checks between related columns

How to Use:
    - Execute this script immediately after loading data into the Silver layer
    - Review any returned results carefully
    - Investigate and fix issues before proceeding to the next layer
*/

-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- CHECKING 'silver.crm_cust_info'
-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-- Checking for DUPLICATES and NULLS
SELECT
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Checking for unwanted Spaces
SELECT
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Data Standardization & Consistency
SELECT
	DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT
	DISTINCT cst_marital_status
FROM silver.crm_cust_info;

-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- CHECKING 'silver.crm_prd_info'
-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-- Checking for DUPLICATES and NULLS
-- Expectation: No results
SELECT
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Checking for NULLS
-- Expectation: No results
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm IS NULL;

-- Checking for unwanted spaces
-- Expectation: No results
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Checking for negative numbers and NULLS
-- Expectation: No results
SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0  OR prd_cost IS NULL;

-- Data Standardization & Consistency
SELECT
	DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for invalid Date Orders
SELECT 
	*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- CHECKING 'silver.crm_sales_details'
-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-- Checking for NULL values
-- Expectation: No results
SELECT
	*
FROM silver.crm_sales_details
WHERE sls_ord_num IS NULL;

-- Checking for unwanted spaces
-- Expectation: No results
SELECT
	sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- Checking for Invalid Date Orders
SELECT
	*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Check Data Consistency: Sales, Quantity and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero or negative

SELECT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != (sls_quantity * sls_price)
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0;


-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- CHECKING 'silver.erp_cust_az12'
-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-- Identify invalid or Out-of-Range Dates
SELECT DISTINCT
	bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Data Standardization & Consistency
SELECT DISTINCT
	gen
FROM silver.erp_cust_az12;

-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- CHECKING 'silver.erp_loc_a101'
-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-- Data Standardization & Consistency
SELECT DISTINCT cntry FROM silver.erp_loc_a101;


-- Data checking
SELECT * FROM silver.erp_loc_a101;

-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
-- CHECKING 'silver.erp_px_cat_g1v2'
-- -=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

-- Checking if the values are matching for posterior JOIN
SELECT
	id
FROM silver.erp_px_cat_g1v2;

SELECT cat_id FROM silver.crm_prd_info;

-- Checking for unwanted Spaces
SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
SELECT DISTINCT
	cat
FROM silver.erp_px_cat_g1v2;


SELECT DISTINCT
	subcat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
	maintenance
FROM silver.erp_px_cat_g1v2;
