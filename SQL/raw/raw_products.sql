-- Table: public.raw_products

-- DROP TABLE IF EXISTS public.raw_products;

CREATE TABLE public.raw_products
(
    product_id character varying(64) COLLATE pg_catalog."default",
    product_category_name text COLLATE pg_catalog."default",
    product_name_length integer,
    product_description_length integer,
    product_photos_qty smallint,
    product_weight_g integer,
    product_length_cm integer,
    product_height_cm integer,
    product_width_cm integer
)

