-- Table: public.raw_customers

-- DROP TABLE IF EXISTS public.raw_customers;

CREATE public.raw_customers
(
    customer_id character varying(64) COLLATE pg_catalog."default",
    customer_unique_id character varying(64) COLLATE pg_catalog."default",
    customer_zip_code_prefix character varying(32) COLLATE pg_catalog."default",
    customer_city character varying(50) COLLATE pg_catalog."default",
    customer_state character varying(50) COLLATE pg_catalog."default"
)

