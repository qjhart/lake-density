-- This sql creates a table of lake density parameters, as well as a geojson file of the final results.
CREATE INDEX lakes_gix ON lakes USING GIST (boundary);
CREATE INDEX counties_gix ON counties USING GIST (boundary);

create table co_lakes as
select c.gid as c_gid,l.gid as l_gid,
st_area(st_intersection(c.boundary,l.boundary)) as area
from counties c join lakes l on st_intersects(c.boundary,l.boundary);

create or replace view county_lake_summary as
with s as (
 select c_gid as gid,count(*),sum(area) as lake
 from co_lakes cl join lakes l on (cl.l_gid=l.gid)
 where l.type='perennial'
 group by c_gid
)
select
'06'||c.ansi as ansi,c.name,count,
(lake/10000)::integer as lake_ha,
(st_area(boundary)/10000)::integer as county_ha,
(10000*lake/st_area(boundary))::integer as "%*10000",
from s join counties c using (gid);

create or replace view county_lake_summary_p as
select s.*,c.boundary
from county_lake_summary s join counties c using (name)
order by ansi

\COPY (select * from county_lake_summary order by ansi) to county_lake_summary.csv with csv header
\COPY (select s.*,st_asKML(boundary) from county_lake_summary s join counties c using (name) order by ansi) to county_lake_summary_p.csv wi
th csv header
