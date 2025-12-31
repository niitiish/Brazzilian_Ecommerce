-- Table: public.raw_order_payments

-- DROP TABLE IF EXISTS public.raw_order_payments;

CREATE TABLE public.raw_order_payments
(
    order_id character varying(64) COLLATE pg_catalog."default",
    payment_sequential smallint,
    payment_type text COLLATE pg_catalog."default",
    payment_installments smallint,
    payment_value numeric(19,2)
)

