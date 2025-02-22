--
-- PostgreSQL database dump (Structure only)
--

-- Dumped from database version 14.15 (Ubuntu 14.15-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

ALTER SCHEMA public OWNER TO postgres;

--
-- Name: etat_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.etat_type AS ENUM (
    'Planifié',
    'En cours',
    'Terminé',
    'Annulé'
);

ALTER TYPE public.etat_type OWNER TO postgres;

SET default_tablespace = '';
SET default_table_access_method = heap;

--
-- Tables structure only
--

CREATE TABLE public.certification (
    id integer NOT NULL,
    titre character varying(255) NOT NULL,
    delivrepar character varying(255)
);

ALTER TABLE public.certification OWNER TO postgres;

CREATE TABLE public.contacts (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    prenom character varying(100) NOT NULL,
    objet character varying(150) NOT NULL,
    email character varying(150) NOT NULL,
    texte text NOT NULL,
    date_submitted timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.contacts OWNER TO postgres;

CREATE TABLE public.diplome (
    id integer NOT NULL,
    titre character varying(255),
    niveau_etude character varying(255),
    delivrepar character varying(255),
    etude_id integer NOT NULL,
    annee_obtention integer,
    image_path character varying
);

ALTER TABLE public.diplome OWNER TO postgres;

CREATE TABLE public.evenement (
    id integer NOT NULL,
    titre character varying(255) NOT NULL,
    description text,
    adresse character varying(255),
    date_debut date,
    date_fin date,
    document character varying(255),
    etat public.etat_type DEFAULT 'Planifié'::public.etat_type NOT NULL
);

ALTER TABLE public.evenement OWNER TO postgres;

CREATE TABLE public.etude (
    iconpath character varying(255),
    buildingpath character varying(255)
) INHERITS (public.evenement);

ALTER TABLE public.etude OWNER TO postgres;

CREATE TABLE public.job (
    id integer NOT NULL,
    titre character varying(255) NOT NULL,
    description text NOT NULL,
    employeur character varying(255),
    adresse character varying(255),
    date_debut date NOT NULL,
    date_fin date,
    document character varying(255),
    partenaire character varying(255),
    iconpath character varying(255)
);

ALTER TABLE public.job OWNER TO postgres;

CREATE TABLE public.projet (
    partenaire character varying(255),
    iconpath character varying(255)
) INHERITS (public.evenement);

ALTER TABLE public.projet OWNER TO postgres;

--
-- Sequences
--

CREATE SEQUENCE public.certification_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.certification_id_seq OWNER TO postgres;
ALTER SEQUENCE public.certification_id_seq OWNED BY public.certification.id;

CREATE SEQUENCE public.contacts_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.contacts_id_seq OWNER TO postgres;
ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;

CREATE SEQUENCE public.diplome_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.diplome_id_seq OWNER TO postgres;
ALTER SEQUENCE public.diplome_id_seq OWNED BY public.diplome.id;

CREATE SEQUENCE public.evenement_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.evenement_id_seq OWNER TO postgres;
ALTER SEQUENCE public.evenement_id_seq OWNED BY public.evenement.id;

CREATE SEQUENCE public.jobs_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.jobs_id_seq OWNER TO postgres;
ALTER SEQUENCE public.jobs_id_seq OWNED BY public.job.id;

--
-- Constraints
--

ALTER TABLE ONLY public.certification ADD CONSTRAINT certification_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.contacts ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.diplome ADD CONSTRAINT diplome_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.evenement ADD CONSTRAINT evenement_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.job ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.projet ADD CONSTRAINT projet_pkey PRIMARY KEY (id);

--
-- Foreign keys
--

ALTER TABLE ONLY public.diplome ADD CONSTRAINT diplome_id_fkey FOREIGN KEY (id) REFERENCES public.etude(id) NOT VALID;

--
-- PostgreSQL database structure dump complete
--
