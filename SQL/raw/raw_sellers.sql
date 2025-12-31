-- Table: public.raw_sellers

-- DROP TABLE IF EXISTS public.raw_sellers;

CREATE TABLE public.raw_sellers
(
    seller_id character varying(64) COLLATE pg_catalog."default",
    seller_zip_code_prefix character varying(32) COLLATE pg_catalog."default",
    seller_city character varying(50) COLLATE pg_catalog."default",
    seller_state character varying(50) COLLATE pg_catalog."default"
)

