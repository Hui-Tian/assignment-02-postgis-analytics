/*
  With a query involving PWD parcels and census block groups, find the
   geo_id of the block group that contains Meyerson Hall. ST_MakePoint() 
   and functions like that are not allowed.

   Geoid = 421010369001
*/

with meyerson_hall_parcel as (
    select geometry meyerson_hall_parcel_geo 
    from parcels
    where address like '3406-46 WALNUT ST'
)
select geoid10 geo_id
from censusblock,meyerson_hall_parcel
where st_contains(geometry,meyerson_hall_parcel_geo)




