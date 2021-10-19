/*
  Rate neighborhoods by their bus stop accessibility for wheelchairs. 
  Use Azavea's neighborhood dataset from OpenDataPhilly along with an 
  appropriate dataset from the Septa GTFS bus feed. Use the GTFS documentation 
  for help. Use some creativity in the metric you devise in rating neighborhoods. 
  Describe your accessibility metric:
*/

alter table nb_philly
    add column the_geom geometry;

update nb_philly
    set the_geom =  ST_Transform(the_geom, 32129);

    


