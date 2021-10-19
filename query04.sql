/*
  Using the shapes.txt file from GTFS bus feed, find the two routes with 
  the longest trips. In the final query, give the trip_headsign that corresponds 
  to the shape_id of this route and the length of the trip.
*/



alter table septa_bus_shapes
    add column the_geom geometry;

update septa_bus_shapes
    set the_geom = st_transform(st_setsrid(st_makepoint(shape_pt_lon,shape_pt_lat), 4326), 32129);


select shape_id trip_headsign,
    st_length(
        st_makeline(
            the_geom
            order by shape_pt_sequence
        )
    ) trip_length
from septa_bus_shapes
group by shape_id
limit 10