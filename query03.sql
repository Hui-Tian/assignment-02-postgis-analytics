/*
  Using the Philadelphia Water Department Stormwater Billing 
  Parcels dataset, pair each parcel with its closest bus stop.
  The final result should give the parcel address, bus stop name, 
  and distance apart in meters. Order by distance (largest on top).
*/



alter table parcels
    add column the_geom geometry;

update parcels
    set the_geom =  ST_Transform(the_geom, 32129);

create index parcels_geo_index 
on parcels 
using gist (the_geom);

select
  p.address,
  s.stop_name,
  distance_m
from
  parcels as p
cross join LATERAL
  (select stop_name, the_geom, st_distance(geometry(s.the_geom), geometry(p.geometry)) as distance_m
   from septa_bus_stops s
   order by 2
   limit 1) as s
   limit 10

   
