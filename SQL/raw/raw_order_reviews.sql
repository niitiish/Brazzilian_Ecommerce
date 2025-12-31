-- Table: public.raw_order_reviews

-- DROP TABLE IF EXISTS public.raw_order_reviews;

CREATE TABLE public.raw_order_reviews
(
    review_id character varying(64) COLLATE pg_catalog."default",
    order_id character varying(64) COLLATE pg_catalog."default",
    review_score smallint,
    review_comment_title text COLLATE pg_catalog."default",
    review_comment_message text COLLATE pg_catalog."default",
    review_creation_date timestamp with time zone,
    review_answer_timestamp timestamp with time zone
)
