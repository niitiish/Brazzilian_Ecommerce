-- check entries having enocding issues
select  * from raw_geolocation
where geolocation_city ~ '[£¢¥€±×÷¹²³]';

drop table if exists tmp_geolocation ;
create temp table tmp_geolocation as
(
	select *, case when geolocation_city ~ '[£¢¥€±×÷¹²³]' then 1 else 0 end encode_flag
	from raw_geolocation
);

select count(*) from tmp_geolocation where encode_flag = 1 ; -- check before making changes 

-- update based on present data available
update tmp_geolocation
set geolocation_city = 'São Paulo' , encode_flag = 0 where geolocation_zip_code_prefix = '04728' ;

update tmp_geolocation
set geolocation_city = 'Maceió' ,encode_flag = 0 where geolocation_zip_code_prefix = '57010' ;

-- check again the counts of flags

select * from tmp_geolocation where encode_flag = 1 ; 

-- choosing Zip as grain 
drop table if exists tmp_geolocation_final ; 
create TEMP TABLE tmp_geolocation_final as
(select 
	geolocation_zip_code_prefix , 
	AVG(geolocation_lat) geolocation_lat , 
	AVG(geolocation_lng) geolocation_lng , 
	mode() within GROUP( order by geolocation_city) geolocation_city , 
	mode() within group(order by geolocation_state) geolocation_state
from tmp_geolocation 
group by geolocation_zip_code_prefix) ;

-- Preparing STG
drop table if exists stg_geolocation ;

create table STG_Geolocation
(
geolocation_zip_code_prefix varchar(5) Primary Key not null,
geolocation_lat float,
geolocation_lng float,
geolocation_city varchar,
geolocation_state varchar
) ;

insert into STG_geolocation
(geolocation_zip_code_prefix, geolocation_lat , geolocation_lng , geolocation_city , geolocation_state)
select 
	geolocation_zip_code_prefix, geolocation_lat , geolocation_lng , geolocation_city , geolocation_state
from 
	tmp_geolocation_final;

-- Matching if STG has unique zip code from raw and we're not losing any grain
select count(*) from STG_geolocation ; 
select count(distinct geolocation_zip_code_prefix) from raw_geolocation ;