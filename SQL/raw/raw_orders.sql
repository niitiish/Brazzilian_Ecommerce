-- Table: public.raw_orders

-- DROP TABLE IF EXISTS public.raw_orders;

CREATE TABLE public.raw_orders
(
    order_id character varying(64) COLLATE pg_catalog."default",
    customer_id character varying(64) COLLATE pg_catalog."default",
    order_status text COLLATE pg_catalog."default",
    order_purchase_timestamp timestamp with time zone,
    order_approved_at timestamp with time zone,
    order_delivered_carrier_date timestamp with time zone,
    order_delivered_customer_date timestamp with time zone,
    order_estimated_delivery_date timestamp with time zone
)
