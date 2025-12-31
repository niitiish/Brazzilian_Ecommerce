-- Table: public.raw_order_items

-- DROP TABLE IF EXISTS public.raw_order_items;

CREATE TABLE public.raw_order_items
(
    order_id character varying(64) COLLATE pg_catalog."default",
    order_item_id integer,
    product_id character varying(64) COLLATE pg_catalog."default",
    seller_id character varying(64) COLLATE pg_catalog."default",
    shipping_limit_date timestamp with time zone,
    price numeric(19,2),
    freight_value numeric(19,2)
)

