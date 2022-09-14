WITH
  orders AS (
    SELECT 
      EXTRACT(MONTH FROM TIMESTAMP(delivered_at)) AS month_number,
      EXTRACT(YEAR FROM TIMESTAMP(delivered_at)) AS year_number,
      FORMAT_TIMESTAMP("%B %Y", TIMESTAMP(delivered_at)) AS month_year,
      order_id,
      user_id,
    FROM `bigquery-public-data.thelook_ecommerce.orders` 
    WHERE
      status = "Complete"
      AND
      TIMESTAMP(delivered_at)
        BETWEEN 
          TIMESTAMP('2019-01-01') 
        AND 
          TIMESTAMP_SUB(TIMESTAMP('2022-05-01'), INTERVAL 1 SECOND)
  ),
  order_items AS (
    SELECT 
      order_id,
      SUM(sale_price) AS total_amount_orders,
    FROM `bigquery-public-data.thelook_ecommerce.order_items` 
    WHERE
      status = "Complete"
      AND
      TIMESTAMP(delivered_at)
        BETWEEN 
          TIMESTAMP(DATE '2019-01-01') 
        AND 
          TIMESTAMP_SUB(TIMESTAMP('2022-05-01'), INTERVAL 1 SECOND)
    GROUP BY order_id
  )
SELECT 
  orders.month_year,
  ROUND(AVG(order_items.total_amount_orders), 2) AS aov,
  COUNT(DISTINCT orders.user_id) AS distinct_users,
FROM orders LEFT OUTER JOIN order_items USING(order_id)
GROUP BY
  orders.month_year, 
  orders.year_number,
  orders.month_number
ORDER BY 
  orders.year_number,
  orders.month_number;