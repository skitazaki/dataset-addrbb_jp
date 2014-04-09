SELECT n03_001, n03_002, n03_003, n03_004, n03_007, count(*) AS cnt
FROM :"table"
WHERE n03_007 IN (
  SELECT code
  FROM (
    SELECT n03_001, n03_002, n03_003, n03_004, n03_007 AS code, count(*) AS cnt
    FROM :"table"
    GROUP BY n03_001, n03_002, n03_003, n03_004, n03_007
  ) a
  GROUP BY code
  HAVING count(*) > 1
)
GROUP BY n03_001, n03_002, n03_003, n03_004, n03_007
ORDER BY n03_007, n03_002, n03_003, n03_004
;

