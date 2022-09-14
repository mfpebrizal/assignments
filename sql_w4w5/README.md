# Week 4 & Week 5 Assignments

Using **SQL** in **BigQuery** to solve the issue discussed below.


Database: [thelook_ecommerce](https://console.cloud.google.com/marketplace/product/bigquery-public-data/thelook-ecommerce)

Questions (**Intermediate**):

1. Create a query to get the total users who completed the order and total orders per month. **Please use time frame from Jan 2019 until Apr 2022**. Expected output:
    - Month
    - Total users
    - Total orders
2. Create a query to get average order value and total number of unique users, grouped by month. **Please use time frame from Jan 2019 until Apr 2022**. Expected output:
    - Moth-Year
    - AOV (Revenue per order)
    - Distinct users
3. Find the first and last name of users from the youngest and oldest age of each gender. Expected output:
    - Gender
    - Youngest age
    - Oldest age
    - First name
    - Last name
4. Get the top 5 most profitable product and its profit detail breakdown by month. Expected output:
    - Month
    - Product id
    - Product name
    - Sales
    - Cost
    - Profit
    - Rank per month
5. Create a query to get Month to Date of total revenue in each product categories of past 3 months (current date **15 April 2022**), breakdown by date. Expected output:
    - Date (in date format)
    - Product categories
    - Revenue

Questions (**Advance**):

6. Find monthly growth of TPO (# of completed orders) and TPV (# of revenue) in percentage breakdown by product categories, ordered by time descendingly. After analyzing the monthly growth, is there any interesting insight that we can get? Expected output:
    - Month
    - Categories
    -  Order Growth
7. Create monthly retention cohorts (the groups, or cohorts, can be defined based upon the date that a user purchased a product) and then how many of them (%) coming back for the following months in 2019-2022. After analyzing the retention cohort, is there any interesting insight that we can get? Expected output:
    - Month
    - M (# of users in current month)
    - M1 (# of users in following months)
    - M2 (# of users in following two months)
    - M3 (# of users in following three months)
