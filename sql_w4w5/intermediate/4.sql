WITH
  order_items AS (
    SELECT 
      product_id,
      sale_price,
      FORMAT_TIMESTAMP("%B %Y", TIMESTAMP(delivered_at)) as month,
      EXTRACT(MONTH FROM TIMESTAMP(delivered_at)) AS month_delivered,
      EXTRACT(YEAR FROM TIMESTAMP(delivered_at)) AS year_delivered
    FROM `bigquery-public-data.thelook_ecommerce.order_items`
    WHERE status = "Complete"
  ),
  products AS (
    SELECT
      id AS product_id,
      cost,
      name
    FROM `bigquery-public-data.thelook_ecommerce.products`
  ),
  sales_info AS (
    SELECT
      month,
      * EXCEPT( 
        sale_price,
        cost,
        month
      ),
      SUM(ROUND(sale_price, 2)) AS sales,
      SUM(ROUND(cost, 2)) AS product_cost,
      SUM(ROUND(sale_price - cost, 2)) AS profit,
    FROM order_items JOIN products USING(product_id)
    GROUP BY
      month,
      name,
      year_delivered,
      month_delivered,
      product_id
  ),
  ranks AS (
    SELECT 
      * EXCEPT(
        year_delivered,
        month_delivered
      ),
      RANK() OVER (
        PARTITION BY month 
        ORDER BY profit DESC
      ) AS rank_per_month
    FROM sales_info
    ORDER BY
      year_delivered ASC,
      month_delivered ASC,
      profit DESC
  )
SELECT * FROM ranks
WHERE
  rank_per_month <= 5;