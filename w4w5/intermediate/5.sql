WITH
  date_range AS (
    SELECT 
      TIMESTAMP(DATE(2022, 1, 1)) AS start_date,
      TIMESTAMP_SUB(TIMESTAMP(DATE(2022, 1, 16)), INTERVAL 1 SECOND) AS end_date
    UNION ALL
    SELECT 
      TIMESTAMP(DATE(2022, 2, 1)),
      TIMESTAMP_SUB(TIMESTAMP(DATE(2022, 2, 16)), INTERVAL 1 SECOND)
    UNION ALL
    SELECT 
      TIMESTAMP(DATE(2022, 3, 1)),
      TIMESTAMP_SUB(TIMESTAMP(DATE(2022, 3, 16)), INTERVAL 1 SECOND)
    UNION ALL
    SELECT 
      TIMESTAMP(DATE(2022, 4, 1)),
      TIMESTAMP_SUB(TIMESTAMP(DATE(2022, 4, 16)), INTERVAL 1 SECOND)
  ),
  order_items AS (
    SELECT 
      product_id,
      sale_price,
      FORMAT_TIMESTAMP("%d %B %Y", TIMESTAMP(delivered_at)) as month,
      EXTRACT(MONTH FROM TIMESTAMP(delivered_at)) AS month_delivered,
      EXTRACT(YEAR FROM TIMESTAMP(delivered_at)) AS year_delivered,
      EXTRACT(DAY FROM TIMESTAMP(delivered_at)) AS day_delivered
    FROM 
      date_range AS dr
    JOIN`bigquery-public-data.thelook_ecommerce.order_items` AS oi
    ON
      TIMESTAMP(oi.delivered_at) 
      BETWEEN  
        TIMESTAMP(dr.start_date)
        AND
        TIMESTAMP(dr.end_date)
    WHERE oi.status = "Complete"
  ),
  products AS (
    SELECT 
      id AS product_id,
      category,
    FROM `bigquery-public-data.thelook_ecommerce.products`
  ),
  main AS (
    SELECT
      month AS date_month,
      category AS product_category,
      ROUND(SUM(sale_price), 2) as revenue
    FROM order_items JOIN products USING(product_id)
    GROUP BY 
      product_category,
      month,         
      year_delivered,
      month_delivered,
      day_delivered
    ORDER BY
      year_delivered DESC,
      month_delivered DESC,
      day_delivered ASC,
      product_category ASC
  )
SELECT * FROM main;
