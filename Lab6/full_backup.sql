--
-- PostgreSQL database dump
--

\restrict xeodhpkmeQ2xYyZoKnkd1GWauSZ8bha3U7zBiuB4KOZGie6D3w9KEQCAZnJ7dGf

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- Name: address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address (
    address_id uuid NOT NULL,
    street character varying(255),
    postal_code character varying(20),
    customer_id uuid
);


ALTER TABLE public.address OWNER TO postgres;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    category_id uuid NOT NULL,
    name character varying(100),
    description text
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: city_directory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.city_directory (
    postal_code character varying(20) NOT NULL,
    city character varying(100) NOT NULL,
    country character varying(100) NOT NULL
);


ALTER TABLE public.city_directory OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customer_id uuid NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    email character varying(255),
    phone character varying(50)
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    order_id uuid NOT NULL,
    order_date timestamp without time zone,
    status character varying(50),
    customer_id uuid,
    address_id uuid
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    order_item_id uuid NOT NULL,
    quantity integer,
    unit_price numeric(10,2),
    order_id uuid,
    product_id uuid
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    payment_id uuid NOT NULL,
    amount numeric(10,2),
    paid_at timestamp without time zone,
    order_id uuid,
    method_id uuid NOT NULL
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_method (
    method_id uuid DEFAULT gen_random_uuid() NOT NULL,
    method_name character varying(50) NOT NULL
);


ALTER TABLE public.payment_method OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id uuid NOT NULL,
    name character varying(150),
    description text,
    price numeric(10,2),
    stock_quantity integer,
    category_id uuid,
    supplier_id uuid
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier (
    supplier_id uuid NOT NULL,
    name character varying(150),
    contact_email character varying(255)
);


ALTER TABLE public.supplier OWNER TO postgres;

--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
8bffea23-0358-49dd-9634-cd87d8e11f5b	e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855	2025-12-10 21:14:25.114334+02	0_init		\N	2025-12-10 21:14:25.114334+02	0
\.


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.address (address_id, street, postal_code, customer_id) FROM stdin;
acd6ea30-65bf-4426-963d-413f8774196c	123 Main St	10001	e5495c8f-0d60-459b-9c3b-3dd156a7a442
fc53656b-7a4c-4a6b-ae71-7c295e93d7b4	45 Park Ave	90001	4e8d2da7-8953-4464-8abc-20d8bf3f4997
46bdb195-954d-4f68-8c01-e66b8c53eb98	9 Baker St	NW1 6XE	06f29866-79ba-4e92-be79-aadc6564301c
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (category_id, name, description) FROM stdin;
60ebcbb4-d04c-45e7-bf11-571c486717b3	Electronics	Devices and gadgets
495f7a98-47a0-477d-85af-8e8f0b9ac3b9	Books	Printed and digital reading materials
33dc4698-08b5-4d65-b543-cd91397e2fb4	Clothing	Men and women apparel
\.


--
-- Data for Name: city_directory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.city_directory (postal_code, city, country) FROM stdin;
90001	Los Angeles	USA
10001	New York	USA
NW1 6XE	London	UK
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (customer_id, first_name, last_name, email, phone) FROM stdin;
e5495c8f-0d60-459b-9c3b-3dd156a7a442	Alice	Johnson	alice.johnson@example.com	+1234567890
4e8d2da7-8953-4464-8abc-20d8bf3f4997	Bob	Smith	bob.smith@example.com	+0987654321
06f29866-79ba-4e92-be79-aadc6564301c	Carol	Miller	carol.miller@example.com	+1122334455
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."order" (order_id, order_date, status, customer_id, address_id) FROM stdin;
5ee6321f-5d53-4dee-8ebd-724f9b39bb78	2025-11-15 17:10:37.530545	Pending	e5495c8f-0d60-459b-9c3b-3dd156a7a442	acd6ea30-65bf-4426-963d-413f8774196c
515e2db9-4c80-45c7-aa96-417158435485	2025-11-15 17:10:37.530545	Completed	4e8d2da7-8953-4464-8abc-20d8bf3f4997	fc53656b-7a4c-4a6b-ae71-7c295e93d7b4
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_item (order_item_id, quantity, unit_price, order_id, product_id) FROM stdin;
e3a08a15-7ac8-42e7-9e09-173207be9ff0	1	799.99	5ee6321f-5d53-4dee-8ebd-724f9b39bb78	72cbbfc8-5ba5-4c0f-9185-5b8692b2f4ea
44f937ce-e545-47d5-92eb-eb054cb32058	1	19.99	515e2db9-4c80-45c7-aa96-417158435485	881a5e54-09a9-4449-ae9e-01d15b83ca27
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (payment_id, amount, paid_at, order_id, method_id) FROM stdin;
c846ab1a-48ae-4a1f-b3b1-5ddb760ae616	19.99	2025-11-15 17:10:37.530545	515e2db9-4c80-45c7-aa96-417158435485	167a59ab-d824-422c-8349-7cf592f8c876
\.


--
-- Data for Name: payment_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_method (method_id, method_name) FROM stdin;
167a59ab-d824-422c-8349-7cf592f8c876	Credit Card
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (product_id, name, description, price, stock_quantity, category_id, supplier_id) FROM stdin;
72cbbfc8-5ba5-4c0f-9185-5b8692b2f4ea	Smartphone X	Latest generation smartphone	799.99	50	60ebcbb4-d04c-45e7-bf11-571c486717b3	13539719-785e-4025-b4bf-95d8b9477c38
881a5e54-09a9-4449-ae9e-01d15b83ca27	Novel: The Lost City	Adventure fiction book	19.99	200	495f7a98-47a0-477d-85af-8e8f0b9ac3b9	daba0fd3-7941-4742-a664-da5a64f8f15e
e6ad7741-e449-46fe-9920-7d3a5ddcaee8	Leather Jacket	Genuine leather jacket	249.50	30	33dc4698-08b5-4d65-b543-cd91397e2fb4	84c32d29-ab00-476a-9326-829a33b896d3
\.


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier (supplier_id, name, contact_email) FROM stdin;
13539719-785e-4025-b4bf-95d8b9477c38	TechCorp	sales@techcorp.com
daba0fd3-7941-4742-a664-da5a64f8f15e	BookWorld	contact@bookworld.com
84c32d29-ab00-476a-9326-829a33b896d3	FashionPro	support@fashionpro.com
\.


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- Name: city_directory city_directory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city_directory
    ADD CONSTRAINT city_directory_pkey PRIMARY KEY (postal_code);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (order_item_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (order_id);


--
-- Name: payment_method payment_method_method_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method
    ADD CONSTRAINT payment_method_method_name_key UNIQUE (method_name);


--
-- Name: payment_method payment_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method
    ADD CONSTRAINT payment_method_pkey PRIMARY KEY (method_id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (supplier_id);


--
-- Name: address address_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: address fk_address_city; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT fk_address_city FOREIGN KEY (postal_code) REFERENCES public.city_directory(postal_code);


--
-- Name: payment fk_payment_method; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT fk_payment_method FOREIGN KEY (method_id) REFERENCES public.payment_method(method_id);


--
-- Name: order order_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address(address_id);


--
-- Name: order order_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: order_item order_item_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- Name: order_item order_item_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- Name: payment payment_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_order_id_fkey FOREIGN KEY (order_id) REFERENCES public."order"(order_id);


--
-- Name: product product_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(category_id);


--
-- Name: product product_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.supplier(supplier_id);


--
-- PostgreSQL database dump complete
--

\unrestrict xeodhpkmeQ2xYyZoKnkd1GWauSZ8bha3U7zBiuB4KOZGie6D3w9KEQCAZnJ7dGf

