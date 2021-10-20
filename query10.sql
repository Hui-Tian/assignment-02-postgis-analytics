/*
  Design a question to give more contextual information to rail stops 
  to fill the stop_desc field in a GTFS feed. 
  I gathered information of each rail stop , which includes distance 
  and direction to each address in the parcel dataset. Then I summarize
  the description and fill the stop_desc field.
*/

-- Add a column on septa_bus_stops for the geometry transformed in to 32129

alter table septa_rail_stops
    add column geom_32129 geometry(Point, 32129);
update septa_rail_stops
    set geom_32129 = ST_Transform(ST_SetSRID(ST_MakePoint(stop_lon, stop_lat), 4326), 32129);

-- Add a column on parcels for the geometry transformed into 32129; 

alter table parcels
    add column geom_32129 geometry(MultiPolygon, 32129);
update parcels
    set geom_32129 = ST_Transform(geometry, 32129);

-- Add indexes on both 32129 geometry fields

create index septa_rail_stops__geom_32129__idx
    on septa_rail_stops
    using gist (geom_32129);
create index parcels__geom_32129__idx
    on parcels
    using gist (geom_32129);

-- Gather info on each rail stop and summarize descriptions.

with

stop_infos as (
    select
        s.*,
        closest_parcels.address,
        closest_parcels.direction_r,
        closest_parcels.distance_m,
        ST_SetSRID(ST_MakePoint(s.stop_lon, s.stop_lat), 4326) as stop_geom,
        closest_parcels.the_geom as parcel_geom
    from septa_rail_stops as s
    cross join lateral (
        select
            address,
            st_azimuth(st_centroid(p.geom_32129), s.geom_32129) as direction_r,
            st_distance(p.geom_32129, s.geom_32129) as distance_m,
            the_geom
        from parcels as p
        order by p.geom_32129 <-> s.geom_32129
        limit 1
    ) as closest_parcels  
)

select
    stop_id,
    stop_name,
    'You can find stop #' || stop_id || ' a distance of ' || round(distance_m::numeric, 2) || ' meters to the ' || case
        when direction_r < pi() / 8 then 'east'
        when direction_r < 3 * pi() / 8 then 'north-east'
        when direction_r < 5 * pi() / 8 then 'north'
        when direction_r < 7 * pi() / 8 then 'north-west'
        when direction_r < 9 * pi() / 8 then 'west'
        when direction_r < 11 * pi() / 8 then 'south-west'
        when direction_r < 13 * pi() / 8 then 'south'
        when direction_r < 15 * pi() / 8 then 'south-east'
        else 'east'
    end || ' of ' || address as stop_desc,
    stop_lon,
    stop_lat
from stop_infos





