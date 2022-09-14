WITH
  cohort_items AS (
    SELECT
      user_id,
      MIN(DATE_TRUNC(DATE(created_at), MONTH)) AS cohort_month,
    from `bigquery-public-data.thelook_ecommerce.orders`
    GROUP BY user_id
  ),
  user_order_activities AS (
    SELECT
      user_id,
      DATE_DIFF(
        DATE_TRUNC(DATE(created_at), MONTH),
        cohort_month,
        MONTH
      ) AS month_number,
    FROM `bigquery-public-data.thelook_ecommerce.orders` AS orders
    LEFT JOIN cohort_items USING(user_id)
    GROUP BY 1, 2
    -- ORDER BY user_id
  ),
  cohort_size as (
    SELECT 
      cohort_month,
      COUNT(cohort_month) as num_users
    FROM cohort_items
    GROUP BY cohort_month
    ORDER BY cohort_month
  ),
  retention_table AS (
    SELECT
      C.cohort_month,
      A.month_number,
      COUNT(1) AS num_users
    FROM user_order_activities A
    LEFT JOIN cohort_items C USING(user_id)
    GROUP BY 1, 2
    -- ORDER BY 1, 2
  )
SELECT
  B.cohort_month,
  S.num_users AS cohort_size,
  B.month_number,
  B.num_users AS total_users,
FROM retention_table B
LEFT JOIN cohort_size S USING(cohort_month)
WHERE B.cohort_month IS NOT NULL
ORDER BY 1, 3