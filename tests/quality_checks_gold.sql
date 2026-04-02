/*
===============================================================================
Gold Layer – Data Quality Validation
===============================================================================
Purpose:
    This script validates the integrity and reliability of the Gold layer, 
    ensuring that the analytical model (Star Schema) is consistent and 
    trustworthy for reporting and decision-making.

Validation Scope:
    - Uniqueness of surrogate keys in dimension tables
    - Referential integrity between fact and dimension tables
    - Consistency of relationships defined in the data model
    - Detection of missing or orphaned records

How to use:
    - Execute these checks after the Gold layer has been created or refreshed
    - All queries are expected to return zero rows unless an issue is present
    - Investigate and resolve any inconsistencies before exposing data to end users
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  
