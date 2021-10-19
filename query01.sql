/*
  Which bus stop has the largest population within 800 meters? As a rough
  estimation, consider any block group that intersects the buffer as being part
  of the 800 meter buffer.
*/


alter table septa_bus_stops
    add column the_geom geometry(Point, 4326);

update septa_bus_stops
    set the_geom = st_setsrid(st_makepoint(stop_lon, stop_lat), 4326);
    
create index septa_bus_stops__the_geom__32129__idx
    on septa_bus_stops
    using GiST (ST_Transform(the_geom, 32129));

ALTER TABLE censusblock
ADD COLUMN the_geom geometry;

update censusblock
set the_geom = st_transform(geometry,32129);

select * from census_population
limit 5

select * from censusblock
limit 5

select * from septa_bus_stops
limit 5

with septa_bus_stop_block_groups as (
    select
        s.stop_id,
        '1500000US' || bg.geoid10 as geo_id
    from septa_bus_stops as s
    join censusblock as bg
        on ST_DWithin(
            ST_Transform(s.the_geom, 32129),
            ST_Transform(bg.the_geom, 32129),
            800
        )
),

septa_bus_stop_surrounding_population as (
    select
        stop_id,
        sum(total) as estimated_pop_800m
    from septa_bus_stop_block_groups as s
    join census_population as p on geo_id=id
    group by stop_id
)

select
    stop_name,
    estimated_pop_800m,
    st_transform (the_geom,4326) the_geom

from septa_bus_stop_surrounding_population
join septa_bus_stops using (stop_id)
order by estimated_pop_800m desc
limit 1


