/*
  What are the bottom five neighborhoods according to your accessibility 
  metric?

  I used the quantity of bus_stops_accessible per km^2 to measure the bottom five 
neighborhoods. They are 1	Bartram Village，Port Richmond, West Torresdale, 4	Navy Yard
and Airport.
*/
  
with neighborhood_acc_count as (
	SELECT p.listname neighborhood_name, p.shape_area,
       count(*) filter(where wheelchair_boarding = 1) as num_bus_stops_accessible
    FROM nb_philly as p
    JOIN septa_bus_stops as s
    ON ST_Contains(ST_transform(p.geometry, 32129), ST_transform(s.the_geom, 32129))
GROUP BY 1,2)

select neighborhood_name, num_bus_stops_accessible,
       (num_bus_stops_accessible)/shape_area * 1e6 as accessibility_metric1
	   FROM neighborhood_acc_count
	   ORDER BY accessibility_metric1 
	   ASC
	   LIMIT 5