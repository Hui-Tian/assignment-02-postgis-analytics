/*
  With a query, find out how many census block groups Penn's main campus 
  fully contains. Discuss which dataset you chose for defining Penn's 
  campus.
  
  number:23

  I found the shapfile of UPenn from the Open Data Philly. Here below is the link to the file.
    https://www.opendataphilly.org/dataset/philadelphia-universities-and-colleges/resource/1e37f5f0-6212-4cb4-9d87-261b58ae01c4 
  I selected campus area, geoid and name from two table, and join them with 
  "st_contains" command. At last, I got the number of the tracts contained in the UPenn campus.
*/


with upenn as (
    SELECT *
    from university
    where name='University of Pennsylvania'
),

census as (SELECT c.geoid10,
       u.name
FROM censusblock AS c
JOIN upenn AS u
ON st_contains(c.geometry, u.geometry)
ORDER BY geoid10)

SELECT 
  COUNT ( DISTINCT geoid10 ) AS "num_of_tracts"
FROM census