INSERT INTO address_boundary
SELECT code, pref, name, ST_Union(geom)
FROM (
  SELECT n03_007 AS code, n03_001 AS pref,
    CASE
      WHEN n03_002 IS NOT NULL AND n03_003 IS NOT NULL AND n03_004 IS NOT NULL
        THEN n03_002 || ' ' || n03_003 || ' ' || n03_004
      WHEN n03_002 IS NOT NULL AND n03_003 IS NOT NULL
        THEN n03_002 || ' ' || n03_003
      WHEN n03_002 IS NOT NULL AND n03_004 IS NOT NULL
        THEN n03_002 || ' ' || n03_004
      WHEN n03_003 IS NOT NULL AND n03_004 IS NOT NULL
        THEN n03_003 || ' ' || n03_004
      WHEN n03_003 IS NOT NULL AND n03_004 IS NULL
        THEN n03_003
      ELSE n03_004
    END AS name,
    ST_SetSRID(geom, 4326) AS geom
  FROM :"table"
  WHERE n03_007 IS NOT NULL
) a
GROUP BY code, pref, name;
