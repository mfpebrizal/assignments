WITH
  oldest AS (
    SELECT 
      gender,
      age AS max_age,
      first_name AS first_name_oldest,
      last_name AS last_name_oldest,
      ROW_NUMBER() OVER(PARTITION BY gender ORDER BY age DESC) AS number
    FROM `bigquery-public-data.thelook_ecommerce.users`
  ),
  youngest AS (
    SELECT 
      gender,
      age AS min_age,
      first_name AS first_name_youngest,
      last_name AS last_name_youngest,
      ROW_NUMBER() OVER(PARTITION BY gender ORDER BY age ASC) AS number
    FROM `bigquery-public-data.thelook_ecommerce.users`
  ),
  first_oldest AS (
    SELECT * EXCEPT(number) FROM oldest WHERE number = 1
  ),
  first_youngest AS (
    SELECT * EXCEPT(number) FROM youngest WHERE number = 1
  )
SELECT 
  gender,
  max_age,
  min_age,
  first_name_oldest,
  last_name_oldest,
  first_name_youngest,
  last_name_youngest
FROM first_oldest JOIN first_youngest USING(gender);