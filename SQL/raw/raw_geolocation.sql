-- Table: public.raw_geolocation

-- DROP TABLE IF EXISTS public.raw_geolocation;

CREATE TABLE public.raw_geolocation
(
    geolocation_zip_code_prefix character varying(50) COLLATE pg_catalog."default",
    geolocation_lat double precision,
    geolocation_lng double precision,
    geolocation_city character varying(100) COLLATE pg_catalog."default",
    geolocation_state character varying(50) COLLATE pg_catalog."default"
)
