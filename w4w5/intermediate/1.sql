
WITH
  orders AS(
    SELECT
      EXTRACT(MONTH FROM TIMESTAMP(delivered_at)) AS month_number,
      EXTRACT(YEAR FROM TIMESTAMP(delivered_at)) AS year_number,
      FORMAT_TIMESTAMP("%B %Y", TIMESTAMP(delivered_at)) AS month,
      COUNT(DISTINCT user_id) AS total_users,
      COUNT(DISTINCT order_id) AS total_orders,
    FROM `bigquery-public-data.thelook_ecommerce.orders`
    WHERE 
      status = "Complete"
      AND (
        TIMESTAMP(delivered_at) BETWEEN 
          TIMESTAMP('2019-01-01')
        AND 
          TIMESTAMP_SUB(TIMESTAMP('2022-05-01'), INTERVAL 1 SECOND)
      )
    GROUP BY 1, 2, 3
    ORDER BY 2, 1
  )
SELECT * EXCEPT(month_number, year_number)
FROM orders;