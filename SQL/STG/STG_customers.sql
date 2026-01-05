drop table if exists tmp_customers ;
create temp table tmp_customers as 
(
select 
	cast(customer_id as varchar) customer_id,
	cast(customer_unique_id as varchar) customer_unique_id,
	cast(customer_zip_code_prefix as varchar(5)) customer_zip_code_prefix,
	cast(customer_city as varchar) customer_city,
	upper(cast(customer_state as varchar)) customer_state
from  --deduping the data for each customer_id 
	(select 
	* ,
	row_number() over (partition by customer_id order by customer_unique_id asc) as row_num --add timeconstraint if data changes
	from raw_customers) a 
where row_num = 1
);



create table STG_Customers
(
	customer_id varchar primary key not null,
	customer_unique_id varchar not null,
	customer_zip_code_prefix varchar(5),
	customer_city varchar,
	customer_state varchar
) ;

insert into STG_Customers
(Customer_id, Customer_unique_id , customer_zip_code_prefix , customer_city , customer_state)
select 
Customer_id, Customer_unique_id , customer_zip_code_prefix , customer_city , customer_state 
from tmp_customers;
 