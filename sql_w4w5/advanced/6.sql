WITH
  order_items AS (
    SELECT
      product_id,
      delivered_at,
      ROUND(SUM(sale_price), 2) as total_sale_price,
      COUNT(order_id) as num_of_order
    FROM `bigquery-public-data.thelook_ecommerce.order_items`
    WHERE 
      status = "Complete"
      AND (
        TIMESTAMP(delivered_at) BETWEEN 
          TIMESTAMP('2019-01-01')
        AND 
          TIMESTAMP_SUB(TIMESTAMP(DATE '2022-05-01'), INTERVAL 1 SECOND)
      )
    GROUP BY 
      product_id,
      delivered_at
  ),
  products AS (
    SELECT 
      id,
      category,
    FROM `bigquery-public-data.thelook_ecommerce.products`
  ),
  revenue AS (
    SELECT
      FORMAT_TIMESTAMP("%B %Y", TIMESTAMP(order_items.delivered_at)) as month,
      EXTRACT(MONTH FROM TIMESTAMP(order_items.delivered_at)) AS month_delivered,
      EXTRACT(YEAR FROM TIMESTAMP(order_items.delivered_at)) AS year_delivered,
      category AS product_category,
      ROUND(SUM(total_sale_price), 2) AS revenue_amount,
      SUM(num_of_order) as total_order
    FROM order_items JOIN products ON order_items.product_id = products.id
    GROUP BY
      month,
      product_category,
      month_delivered,
      year_delivered
    ORDER BY
      year_delivered DESC,
      month_delivered DESC
  )
SELECT 
  month,
  product_category,
  -- Uncomment if you need to see total order of each months and its previous
  /*
  total_order,
  LAG(total_order)
    OVER(product_category_window) AS last_month_total_order,
  */
  ROUND(
    (
      (
        total_order - 
        LAG(total_order)
          OVER(product_category_window)
      ) / LAG(total_order)
          OVER(product_category_window)
    )
    ,2
  ) AS order_growth_in_percent,
  -- Uncomment if you need to see total revenue of each months and its previous
  /*
  revenue_amount,
  LAG(revenue_amount)
    OVER(product_category_window) AS last_month_revenue,
  */
  ROUND(
    (
      (
        revenue_amount - 
        LAG(revenue_amount)
          OVER(product_category_window)
      ) / LAG(revenue_amount)
          OVER(product_category_window)
    )
    ,2
  ) AS revenue_growth_in_percent
FROM revenue
-- Uncomment and edit if you need to see per product category
/*
WHERE product_category = "Jeans"
*/
WINDOW product_category_window AS (
  PARTITION BY product_category
  ORDER BY 
    year_delivered ASC,
    month_delivered ASC,
    product_category
)
ORDER BY
  year_delivered DESC,
  month_delivered ASC,
  product_category;