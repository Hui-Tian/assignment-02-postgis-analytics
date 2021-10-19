/*
  Using the shapes.txt file from GTFS bus feed, find the two routes with 
  the longest trips. In the final query, give the trip_headsign that corresponds 
  to the shape_id of this route and the length of the trip.


trip_headsign
double precision
trip_length
double precision
1	266311	15445.022598533462
2	266312	10044.302723523808
3	266313	15445.022598533462
4	266314	11149.19555001167
5	266315	10982.949704950272
6	266316	11082.62674632245
7	266317	15445.022598533462
8	266318	10044.302723523808
9	266319	850.1272722607503
10	266320	10982.949704950272

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