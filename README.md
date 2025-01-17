# Assignment 02: PostGIS Analytics

**Due: Oct 11, 2021 by 11:59pm ET**

## Submission Instructions

1. Fork this repository to your GitHub account.

2. Write a query to answer each of the questions below. Your queries should produce results in the format specified. Write your query in a SQL file corresponding to the question number (e.g. a file named _query06.sql_ for the answer to question #6). Each SQL file should contain a single `SELECT` query (though it may include other queries before the select if you need to do things like create indexes or update columns). Some questions include a request for you to discuss your methods. Update this README file with your answers in the appropriate place.

3. There are several datasets that are prescribed for you to use in this assignment. Your datasets should be named:
  * septa_bus_stops ([SEPTA GTFS](http://www3.septa.org/developer/))
  * septa_bus_shapes ([SEPTA GTFS](http://www3.septa.org/developer/))
  * septa_rail_stops ([SEPTA GTFS](http://www3.septa.org/developer/))
  * phl_pwd_parcels ([OpenDataPhilly](https://opendataphilly.org/dataset/pwd-stormwater-billing-parcels))
  * census_block_groups ([OpenDataPhilly](https://opendataphilly.org/dataset/census-block-groups))
  * census_population ([Census Explorer](https://data.census.gov/cedsci/table?t=Populations%20and%20People&g=0500000US42101%241500000&y=2010&d=DEC%20Summary%20File%201&tid=DECENNIALSF12010.P1))

4. Submit a pull request with your answers. You can continue to push changes to your repository up until the due date, and those changes will be visible in your pull request.

**Note, I take logic for solving problems into account when grading. When in doubt, write your thinking for solving the problem even if you aren't able to get a full response.**

## Questions

Setup: I simplified the names of the datasets when importing into Postgres. The query will display "Census_Block_Groups_2010" as "censusblock", "Neighborhoods_Philadelphia" as "nb_philly", "Universities_Colleges" as "university", and change "PWD_PARCELS" as "parcels". The rest will be as same name as the original ones. For your convinience, I also shared the data folder in google drive, which you can find it here. https://drive.google.com/drive/folders/1AISIzHTx48DD8sClL_bvvzf_ZUaw3DSm?usp=sharing

1. Which bus stop has the largest population within 800 meters? As a rough estimation, consider any block group that intersects the buffer as being part of the 800 meter buffer.

The stop in Passyunk Av & 15th St has the largest population of 50867.

2. Which bus stop has the smallest population within 800 meters?

The stop in Charter Rd & Norcom Rd has the smallest population of 2.

  **The queries to #1 & #2 should generate relations with a single row, with the following structure:**

  ```sql
  (
      stop_name text, -- The name of the station
      estimated_pop_800m integer, -- The population within 800 meters
      the_geom geometry(Point, 4326) -- The geometry of the bus stop
  )
  ```

3. Using the Philadelphia Water Department Stormwater Billing Parcels dataset, pair each parcel with its closest bus stop. The final result should give the parcel address, bus stop name, and distance apart in meters. Order by distance (largest on top).

Please see query 3.


  **Structure:**
  ```sql
  (
      address text,  -- The address of the parcel
      stop_name text,  -- The name of the bus stop
      distance_m double precision  -- The distance apart in meters
  )
  ```

4. Using the _shapes.txt_ file from GTFS bus feed, find the **two** routes with the longest trips. In the final query, give the `trip_headsign` that corresponds to the `shape_id` of this route and the length of the trip.

trip_headsign   trip_length

1    266311    15445.022598533462
2    266312    10044.302723523808
3    266313    15445.022598533462
4    266314    11149.19555001167
5    266315    10982.949704950272
6    266316    11082.62674632245
7    266317    15445.022598533462
8    266318    10044.302723523808
9    266319    850.1272722607503
10    266320    10982.949704950272

  **Structure:**
  ```sql
  (
      trip_headsign text,  -- Headsign of the trip
      trip_length double precision  -- Length of the trip in meters
  )
  ```

5. Rate neighborhoods by their bus stop accessibility for wheelchairs. Use Azavea's neighborhood dataset from OpenDataPhilly along with an appropriate dataset from the Septa GTFS bus feed. Use the [GTFS documentation](https://gtfs.org/reference/static/) for help. Use some creativity in the metric you devise in rating neighborhoods. Describe your accessibility metric:

  **Description:**  I used the quantity of bus_stops_accessible per km^2 of neighborhood 
  as the metric of rating neighborhoods by their bus stop accessibility 
  for wheelchairs.

6. What are the _top five_ neighborhoods according to your accessibility metric?

I used the quantity of bus_stops_accessible per km^2 to measure the top five 
neighborhoods. They are Washington Square West，Newbold, Spring Garden, Hawthorne
and Francisville.

7. What are the _bottom five_ neighborhoods according to your accessibility metric?

I used the quantity of bus_stops_accessible per km^2 to measure the bottom five 
neighborhoods. They are 1    Bartram Village，Port Richmond, West Torresdale, 4    Navy Yard
and Airport.

  **Both #6 and #7 should have the structure:**
  ```sql
  (
    neighborhood_name text,  -- The name of the neighborhood
    accessibility_metric ...,  -- Your accessibility metric value
    num_bus_stops_accessible integer,
    num_bus_stops_inaccessible integer
  )
  ```

8. With a query, find out how many census block groups Penn's main campus fully contains. Discuss which dataset you chose for defining Penn's campus.

number:23

I found the shapfile of UPenn from the Open Data Philly. Here below is the link to the file. "https://www.opendataphilly.org/dataset/philadelphia-universities-and-colleges/resource/1e37f5f0-6212-4cb4-9d87-261b58ae01c4 "I selected campus area, geoid and name from two table, and join them with "st_contains" command. At last, I got the number of the tracts contained in the UPenn campus.


  **Structure (should be a single value):**
  ```sql
  (
      count_block_groups integer
  )
  ```

9. With a query involving PWD parcels and census block groups, find the `geo_id` of the block group that contains Meyerson Hall. ST_MakePoint() and functions like that are not allowed.

 Geoid = 421010369001
  **Structure (should be a single value):**
  ```sql
  (
      geo_id text
  )
  ```

10. You're tasked with giving more contextual information to rail stops to fill the `stop_desc` field in a GTFS feed. Using any of the data sets above, PostGIS functions (e.g., `ST_Distance`, `ST_Azimuth`, etc.), and PostgreSQL string functions, build a description (alias as `stop_desc`) for each stop. Feel free to supplement with other datasets (must provide link to data used so it's reproducible), and other methods of describing the relationships. PostgreSQL's `CASE` statements may be helpful for some operations.

       I gathered information of each rail stop , which includes distance and direction to each address in the parcel dataset. Then I summarize the description and fill the stop_desc field. Please see details in query 10. 


  **Structure:**
  ```sql
  (
      stop_id integer,
      stop_name text,
      stop_desc text,
      stop_lon double precision,
      stop_lat double precision
  )
  ```

  As an example, your `stop_desc` for a station stop may be something like "37 meters NE of 1234 Market St" (that's only an example, feel free to be creative, silly, descriptive, etc.)

  **Tip when experimenting:** Use subqueries to limit your query to just a few rows to keep query times faster. Once your query is giving you answers you want, scale it up. E.g., instead of `FROM tablename`, use `FROM (SELECT * FROM tablename limit 10) as t`.
