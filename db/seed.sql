--
-- PostgreSQL database dump
--

-- Dumped from database version 14.17 (Homebrew)
-- Dumped by pg_dump version 14.17 (Homebrew)

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
-- Name: etat_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.etat_type AS ENUM (
    'Planifié',
    'En cours',
    'Terminé',
    'Annulé'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: certification; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certification (
    id integer NOT NULL,
    titre character varying(255) NOT NULL,
    delivrepar character varying(255),
    annee_obtention date,
    image_path character varying(255)
);


--
-- Name: certification_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certification_id_seq OWNED BY public.certification.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    logo text,
    city character varying(120),
    country character varying(120),
    website text,
    description text,
    industry character varying(180),
    size character varying(80),
    type character varying(60) DEFAULT 'company'::character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    prenom character varying(100) NOT NULL,
    objet character varying(150) NOT NULL,
    email character varying(150) NOT NULL,
    texte text NOT NULL,
    date_submitted timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: course_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_categories (
    id integer NOT NULL,
    name character varying(180) NOT NULL,
    description text,
    display_order integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    skills_summary text
);


--
-- Name: course_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.course_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.course_categories_id_seq OWNED BY public.course_categories.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    id integer NOT NULL,
    code character varying(40) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    skills_summary text,
    category_id integer,
    display_order integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    formation_year character varying(80),
    semester character varying(80),
    hours character varying(80),
    ects character varying(160)
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- Name: diplome; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diplome (
    id integer NOT NULL,
    titre character varying(255) NOT NULL,
    niveau_etude character varying(255) NOT NULL,
    delivrepar character varying(255) NOT NULL,
    etude_id integer,
    annee_obtention date,
    image_path character varying(255)
);


--
-- Name: diplome_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.diplome_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diplome_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.diplome_id_seq OWNED BY public.diplome.id;


--
-- Name: education_courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.education_courses (
    education_id integer NOT NULL,
    course_id integer NOT NULL
);


--
-- Name: education_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.education_projects (
    education_id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: education_skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.education_skills (
    education_id integer NOT NULL,
    skill_id integer NOT NULL
);


--
-- Name: education_technologies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.education_technologies (
    education_id integer NOT NULL,
    technology_id integer NOT NULL
);


--
-- Name: educations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.educations (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    school_id integer,
    degree character varying(255),
    field character varying(255),
    description text,
    start_date date,
    end_date date,
    status character varying(40) DEFAULT 'done'::character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    display_order integer,
    context text,
    key_subjects text[] DEFAULT '{}'::text[],
    personal_contribution text,
    program_summary text,
    program_distribution text
);


--
-- Name: educations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.educations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: educations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.educations_id_seq OWNED BY public.educations.id;


--
-- Name: etude; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.etude (
    id integer NOT NULL,
    titre character varying(255) NOT NULL,
    description text NOT NULL,
    adresse character varying(255) NOT NULL,
    date_debut date NOT NULL,
    date_fin date,
    document character varying(255),
    etat public.etat_type DEFAULT 'Planifié'::public.etat_type NOT NULL,
    iconpath character varying(255),
    buildingpath character varying(255)
);


--
-- Name: etude_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.etude_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: etude_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.etude_id_seq OWNED BY public.etude.id;


--
-- Name: job; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job (
    id integer NOT NULL,
    titre character varying(255) NOT NULL,
    description text NOT NULL,
    employeur character varying(255),
    adresse character varying(255) NOT NULL,
    date_debut date NOT NULL,
    date_fin date,
    document character varying(255),
    partenaire character varying(255),
    iconpath character varying(255)
);


--
-- Name: job_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_id_seq OWNED BY public.job.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    company_id integer,
    contract_type character varying(80),
    location character varying(180),
    remote_type character varying(40),
    start_date date,
    end_date date,
    status character varying(40) DEFAULT 'done'::character varying,
    description text,
    missions text[] DEFAULT '{}'::text[],
    technologies text[] DEFAULT '{}'::text[],
    project_ids integer[] DEFAULT '{}'::integer[],
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    mission_context text,
    achievements text[] DEFAULT '{}'::text[],
    methods text[] DEFAULT '{}'::text[],
    results text,
    short_summary text,
    lab_name character varying(255),
    supervision character varying(255),
    function_title character varying(180),
    exact_dates character varying(120),
    problem_statement text,
    system_architecture text,
    technical_challenges text[] DEFAULT '{}'::text[],
    personal_contribution text,
    skills_developed text[] DEFAULT '{}'::text[],
    document_title text,
    document_url text,
    document_description text,
    company_context text,
    product_context text,
    first_year_summary text,
    first_year_tasks text[] DEFAULT '{}'::text[],
    first_year_achievements text[] DEFAULT '{}'::text[],
    first_year_tools text[] DEFAULT '{}'::text[],
    first_year_skills text[] DEFAULT '{}'::text[],
    second_year_summary text,
    second_year_tasks text[] DEFAULT '{}'::text[],
    second_year_achievements text[] DEFAULT '{}'::text[],
    second_year_tools text[] DEFAULT '{}'::text[],
    second_year_skills text[] DEFAULT '{}'::text[],
    tools text[] DEFAULT '{}'::text[],
    results_list text[] DEFAULT '{}'::text[],
    personal_contribution_list text[] DEFAULT '{}'::text[]
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: media_assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_assets (
    id integer NOT NULL,
    provider character varying(40) DEFAULT 'cloudinary'::character varying NOT NULL,
    public_id text NOT NULL,
    resource_type character varying(20) NOT NULL,
    delivery_type character varying(40) DEFAULT 'authenticated'::character varying NOT NULL,
    format character varying(40),
    version bigint,
    original_filename text,
    bytes integer,
    width integer,
    height integer,
    entity_type character varying(60) DEFAULT 'general'::character varying NOT NULL,
    alt_text text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    display_name text,
    secure_url text,
    caption text,
    duration numeric,
    CONSTRAINT media_assets_resource_type_check CHECK (((resource_type)::text = ANY ((ARRAY['image'::character varying, 'video'::character varying])::text[])))
);


--
-- Name: media_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.media_assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.media_assets_id_seq OWNED BY public.media_assets.id;


--
-- Name: project_section_media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_section_media (
    id integer NOT NULL,
    section_id integer NOT NULL,
    media_id integer NOT NULL,
    display_order integer DEFAULT 1 NOT NULL,
    display_mode character varying(60) DEFAULT 'right'::character varying NOT NULL,
    caption text,
    alt_text text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: project_section_media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_section_media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_section_media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_section_media_id_seq OWNED BY public.project_section_media.id;


--
-- Name: project_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_sections (
    id integer NOT NULL,
    project_id integer NOT NULL,
    title character varying(255) NOT NULL,
    subtitle character varying(255),
    body text,
    section_type character varying(60) DEFAULT 'text'::character varying NOT NULL,
    layout character varying(60) DEFAULT 'text_only'::character varying NOT NULL,
    display_order integer,
    is_visible boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: project_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_sections_id_seq OWNED BY public.project_sections.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    main_image text,
    images text[] DEFAULT '{}'::text[],
    short_description text,
    long_description text,
    goal text,
    features text[] DEFAULT '{}'::text[],
    technologies text[] DEFAULT '{}'::text[],
    github_url text,
    demo_url text,
    start_date date,
    end_date date,
    status character varying(40) DEFAULT 'in_progress'::character varying,
    category character varying(80),
    school_id integer,
    company_id integer,
    job_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    context text,
    architecture text,
    challenges text,
    results text,
    future_improvements text
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: projet; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projet (
    id integer NOT NULL,
    titre character varying(255) NOT NULL,
    description text NOT NULL,
    adresse character varying(255) NOT NULL,
    date_debut date NOT NULL,
    date_fin date,
    document character varying(255),
    etat public.etat_type DEFAULT 'Planifié'::public.etat_type NOT NULL,
    partenaire character varying(255),
    iconpath character varying(255)
);


--
-- Name: projet_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projet_id_seq OWNED BY public.projet.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    filename text NOT NULL,
    applied_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: schools; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schools (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    logo text,
    city character varying(120),
    country character varying(120),
    website text,
    description text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    slug character varying(255) NOT NULL
);


--
-- Name: schools_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schools_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schools_id_seq OWNED BY public.schools.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


--
-- Name: site_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.site_settings (
    id integer NOT NULL,
    setting_key character varying(120) NOT NULL,
    setting_value text,
    description text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: site_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.site_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: site_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.site_settings_id_seq OWNED BY public.site_settings.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.skills (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    category character varying(120) NOT NULL,
    icon character varying(120),
    level character varying(40),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    description text
);


--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.skills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.skills_id_seq OWNED BY public.skills.id;


--
-- Name: technologies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.technologies (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    category character varying(120),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: technologies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.technologies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: technologies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.technologies_id_seq OWNED BY public.technologies.id;


--
-- Name: utilisateurs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.utilisateurs (
    id integer NOT NULL,
    pseudo character varying(100) NOT NULL,
    mot_de_passe character varying(255) NOT NULL,
    role character varying(50) DEFAULT 'admin'::character varying NOT NULL
);


--
-- Name: utilisateurs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.utilisateurs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: utilisateurs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.utilisateurs_id_seq OWNED BY public.utilisateurs.id;


--
-- Name: certification id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certification ALTER COLUMN id SET DEFAULT nextval('public.certification_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: course_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_categories ALTER COLUMN id SET DEFAULT nextval('public.course_categories_id_seq'::regclass);


--
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- Name: diplome id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diplome ALTER COLUMN id SET DEFAULT nextval('public.diplome_id_seq'::regclass);


--
-- Name: educations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.educations ALTER COLUMN id SET DEFAULT nextval('public.educations_id_seq'::regclass);


--
-- Name: etude id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.etude ALTER COLUMN id SET DEFAULT nextval('public.etude_id_seq'::regclass);


--
-- Name: job id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job ALTER COLUMN id SET DEFAULT nextval('public.job_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: media_assets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_assets ALTER COLUMN id SET DEFAULT nextval('public.media_assets_id_seq'::regclass);


--
-- Name: project_section_media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_section_media ALTER COLUMN id SET DEFAULT nextval('public.project_section_media_id_seq'::regclass);


--
-- Name: project_sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_sections ALTER COLUMN id SET DEFAULT nextval('public.project_sections_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: projet id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projet ALTER COLUMN id SET DEFAULT nextval('public.projet_id_seq'::regclass);


--
-- Name: schools id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schools ALTER COLUMN id SET DEFAULT nextval('public.schools_id_seq'::regclass);


--
-- Name: site_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_settings ALTER COLUMN id SET DEFAULT nextval('public.site_settings_id_seq'::regclass);


--
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- Name: technologies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technologies ALTER COLUMN id SET DEFAULT nextval('public.technologies_id_seq'::regclass);


--
-- Name: utilisateurs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.utilisateurs ALTER COLUMN id SET DEFAULT nextval('public.utilisateurs_id_seq'::regclass);


--
-- Data for Name: certification; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.companies VALUES (4, 'Vignal Group', 'portfolio/private/companies/jwtyqj1fd8knk5irlwld', 'Corbas', 'France', 'https://www.vignal-group.com/', 'Vignal Group est un équipementier spécialisé dans la conception, la fabrication et la commercialisation de produits et systèmes d’éclairage et de sécurité pour véhicules. Le groupe conçoit notamment des solutions destinées aux véhicules industriels, véhicules commerciaux et véhicules off-road, avec une expertise en éclairage, signalisation, sécurité, photométrie et optique.', 'Équipement automobile, éclairage et sécurité pour véhicules', 'ETI — environ 500 à 1 000 employés', 'company', '2026-05-12 21:41:57.248282', '2026-05-12 21:41:57.248282');
INSERT INTO public.companies VALUES (3, 'LGM', 'portfolio/private/companies/csrbesnlgh9mpzkgvdyw', 'Vélizy-Villacoublay', 'France', 'https://www.lgm.group/', 'LGM Ingénierie est une filiale du groupe LGM spécialisée dans l’ingénierie électronique et logicielle, les bancs de test, l’intégration, la validation, la qualification et le traitement d’obsolescence. L’entreprise intervient notamment dans les secteurs de l’aéronautique, de la défense, de l’énergie, des transports et de l’automobile.', 'Ingénierie électronique, logiciel embarqué, validation automobile', 'Grande entreprise / groupe — environ 1 000 à 5 000 employés', 'company', '2026-05-12 21:39:22.076327', '2026-05-14 22:39:34.11338');
INSERT INTO public.companies VALUES (2, 'CNRS — Centre national de la recherche scientifique', 'portfolio/private/companies/iuzwjhzfkznzfchsjcmt', 'Paris', 'France', 'https://www.cnrs.fr/', 'Le CNRS est un organisme public français de recherche scientifique, reconnu pour ses activités dans de nombreux domaines scientifiques et technologiques. Le stage s’est déroulé au laboratoire MPQ — Matériaux et Phénomènes Quantiques, une unité mixte de recherche associant le CNRS et l’Université Paris Cité. Le pôle technique du laboratoire apporte un soutien en électronique, informatique, instrumentation, mécanique, vide et cryogénie aux équipes de recherche.', 'Recherche scientifique et instrumentation', 'Grande organisation', 'laboratory', '2026-05-12 21:37:24.315764', '2026-05-14 22:53:28.649534');


--
-- Data for Name: course_categories; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.course_categories VALUES (1, 'Bases scientifiques', 'Consolidation des bases mathématiques et statistiques nécessaires à la modélisation, à l’analyse et à la résolution de problèmes d’ingénierie.', 1, '2026-05-13 18:31:09.686475', '2026-05-13 18:31:09.686475', NULL);
INSERT INTO public.course_categories VALUES (2, 'Informatique, logiciel et systèmes embarqués', 'Formation solide en informatique fondamentale, développement logiciel, architecture des systèmes, bases de données, réseaux, systèmes d’exploitation et systèmes embarqués temps réel.', 2, '2026-05-13 18:31:09.686475', '2026-05-13 18:31:09.686475', NULL);
INSERT INTO public.course_categories VALUES (3, 'Robotique, capteurs et automatique', 'Cours orientés robotique, perception, capteurs, contrôle, automatique avancée et systèmes intelligents.', 3, '2026-05-13 18:31:09.686475', '2026-05-13 18:31:09.686475', NULL);
INSERT INTO public.course_categories VALUES (4, 'Données, optimisation et technologies avancées', 'Approfondissement en optimisation, simulation, recherche d’information, technologies avancées et informatique quantique.', 4, '2026-05-13 18:31:09.686475', '2026-05-13 18:31:09.686475', NULL);
INSERT INTO public.course_categories VALUES (5, 'Entreprise, société et communication', 'Ouverture aux dimensions sociales, juridiques, éthiques, organisationnelles et sociétales du métier d’ingénieur.', 5, '2026-05-13 18:31:09.686475', '2026-05-13 18:31:09.686475', NULL);
INSERT INTO public.course_categories VALUES (6, 'Anglais et communication internationale', 'Progression en anglais académique, scientifique et professionnel, avec travail sur l’oral, l’écrit et l’interaction.', 6, '2026-05-13 18:31:09.686475', '2026-05-13 18:31:09.686475', NULL);
INSERT INTO public.course_categories VALUES (7, 'Apprentissage en entreprise', 'Validation des périodes en entreprise, montée en autonomie, analyse des situations professionnelles et construction du métier cible.', 7, '2026-05-13 18:31:09.686475', '2026-05-13 18:31:09.686475', NULL);
INSERT INTO public.course_categories VALUES (8, 'Électronique et systèmes électroniques', 'Enseignements centrés sur l’analyse, la conception et la validation de circuits électroniques analogiques et numériques, avec une progression vers des systèmes plus rapides et plus complexes.', 101, '2026-05-13 18:52:15.591699', '2026-05-13 18:52:15.591699', 'Électronique, analyse de circuits, composants électroniques, électronique analogique, électronique numérique, signaux électriques, mesures, instrumentation, schématique électronique, validation électronique.');
INSERT INTO public.course_categories VALUES (9, 'Automatisme, microcontrôleurs et informatique embarquée', 'Enseignements liés aux systèmes automatisés, à la commande, aux microcontrôleurs et à l’utilisation de Linux dans un contexte d’informatique embarquée.', 102, '2026-05-13 18:52:15.591699', '2026-05-13 18:52:15.591699', 'Automatisme, microcontrôleurs, informatique embarquée, Linux, Linux embarqué, GPIO, entrées/sorties, timers, interruptions, ADC, PWM, programmation embarquée, C embarqué, commande de systèmes.');
INSERT INTO public.course_categories VALUES (10, 'Énergie électrique et physique appliquée', 'Enseignements portant sur les grandeurs physiques, l’énergie électrique, la conversion d’énergie et l’application des principes physiques aux systèmes électriques et électroniques.', 103, '2026-05-13 18:52:15.591699', '2026-05-13 18:52:15.591699', 'Énergie électrique, physique appliquée, conversion d’énergie, mesures physiques, systèmes électriques, modélisation, expérimentation, analyse de résultats.');
INSERT INTO public.course_categories VALUES (11, 'Génie logiciel, informatique industrielle et réseaux', 'Enseignements orientés programmation, développement logiciel, informatique industrielle et réseaux utilisés dans les environnements techniques.', 104, '2026-05-13 18:52:15.591699', '2026-05-13 18:52:15.591699', 'C, programmation, algorithmique, développement logiciel, génie logiciel, tests, informatique industrielle, réseaux industriels, supervision, protocoles, communication machine.');
INSERT INTO public.course_categories VALUES (12, 'Mathématiques et outils scientifiques', 'Enseignements destinés à consolider les outils mathématiques et logiciels nécessaires à l’analyse, la modélisation et la résolution de problèmes techniques.', 105, '2026-05-13 18:52:15.591699', '2026-05-13 18:52:15.591699', 'Mathématiques appliquées, modélisation, calcul scientifique, simulation, analyse de données, résolution de problèmes, préparation aux écoles d’ingénieurs.');
INSERT INTO public.course_categories VALUES (13, 'Robotique, projets techniques et SAE', 'Mises en situation et projets techniques permettant d’appliquer les connaissances en électronique, automatisme, informatique, robotique et systèmes embarqués.', 106, '2026-05-13 18:52:15.591699', '2026-05-13 18:52:15.591699', 'Robotique, projets techniques, SAE, intégration système, électronique, automatisme, C, programmation, capteurs, actionneurs, tests, validation, conception, travail en équipe, documentation technique.');
INSERT INTO public.course_categories VALUES (14, 'Communication, anglais et projet professionnel', 'Enseignements liés à la communication écrite et orale, à l’anglais technique, à la vie professionnelle et à la construction du projet personnel.', 107, '2026-05-13 18:52:15.591699', '2026-05-13 18:52:15.591699', 'Communication, anglais technique, rédaction, présentation orale, projet professionnel, insertion, valorisation du parcours, autonomie.');
INSERT INTO public.course_categories VALUES (15, 'Stage, portfolio et professionnalisation', 'Éléments de professionnalisation visant à valoriser les compétences acquises, construire un portfolio technique et appliquer les savoirs dans un contexte professionnel.', 108, '2026-05-13 18:52:15.591699', '2026-05-13 18:52:15.591699', 'Portfolio, valorisation professionnelle, documentation, expérience professionnelle, stage, autonomie, synthèse du parcours, application des compétences techniques.');
INSERT INTO public.course_categories VALUES (16, 'Sciences pour l’ingénieur', 'Enseignements destinés à consolider les bases scientifiques nécessaires à la modélisation, l’optimisation, l’analyse statistique et la compréhension des systèmes d’ingénierie.', 201, '2026-05-13 19:05:53.561656', '2026-05-13 19:05:53.561656', 'Mathématiques pour l’ingénieur, modélisation, optimisation, statistiques, probabilités, physique appliquée, systèmes de communication, analyse scientifique.');
INSERT INTO public.course_categories VALUES (17, 'Sciences et techniques pour les transitions', 'Enseignements centrés sur les enjeux environnementaux, numériques et énergétiques, avec une approche orientée transition écologique, sobriété, écoconception et technologies durables.', 202, '2026-05-13 19:05:53.561656', '2026-05-13 19:05:53.561656', 'Écoconception, analyse du cycle de vie, environnement numérique, transition énergétique, développement durable, IA, cybersécurité, traitement de données, mesure environnementale.');
INSERT INTO public.course_categories VALUES (18, 'Projet multidisciplinaire et fil rouge', 'Enseignements et projets permettant de mettre en pratique les compétences techniques à travers des réalisations progressives, multidisciplinaires et professionnalisantes.', 203, '2026-05-13 19:05:53.561656', '2026-05-13 19:05:53.561656', 'Microcontrôleurs, développement embarqué, projet fil rouge, IHM, Android, LabVIEW, ingénierie dirigée par les modèles, propriété intellectuelle, travail en équipe, gestion de projet.');
INSERT INTO public.course_categories VALUES (19, 'Architectures, électroniques et systèmes embarqués', 'Enseignements centrés sur l’électronique analogique et numérique, les capteurs, les architectures embarquées, les systèmes asservis, les microprocesseurs, l’électronique de commande et la compatibilité électromagnétique.', 204, '2026-05-13 19:05:53.561656', '2026-05-13 19:05:53.561656', 'Électronique analogique, électronique numérique, capteurs, conditionnement de signal, architectures numériques, microprocesseurs, HIL, systèmes asservis, CEM, moteurs électriques, électronique de commande.');
INSERT INTO public.course_categories VALUES (20, 'Informatique, logiciels embarqués et IA', 'Enseignements centrés sur la programmation, les logiciels embarqués, les systèmes critiques, le temps réel, l’intelligence artificielle embarquée, la vision et le traitement d’images.', 205, '2026-05-13 19:05:53.561656', '2026-05-13 19:05:53.561656', 'Logiciel embarqué, systèmes temps réel, logiciels critiques, IA embarquée, vision embarquée, traitement d’images, Android, algorithmique, programmation, validation logicielle.');
INSERT INTO public.course_categories VALUES (21, 'Réseaux, sécurité et fiabilité des systèmes embarqués', 'Enseignements centrés sur les réseaux, la sécurité, la cryptographie, la validation, les méthodes formelles et la qualification des systèmes embarqués.', 206, '2026-05-13 19:05:53.561656', '2026-05-13 19:05:53.561656', 'Réseaux de terrain, cybersécurité, cryptographie, sécurité embarquée, méthodes formelles, validation, qualification système, sûreté de fonctionnement.');
INSERT INTO public.course_categories VALUES (22, 'Technologies des systèmes embarqués', 'Enseignements liés aux technologies matérielles, procédés intégrés, communication sans fil, modélisation industrielle et analyse des marchés des systèmes embarqués.', 207, '2026-05-13 19:05:53.561656', '2026-05-13 19:05:53.561656', 'Technologies intégrées, salle blanche, communication sans fil, modélisation de systèmes électroniques industriels, produits et marchés, R&D, systèmes embarqués industriels.');
INSERT INTO public.course_categories VALUES (23, 'Anglais, management et sciences humaines', 'Enseignements liés à l’anglais, à la communication professionnelle, au management, à l’innovation, au droit, aux sciences humaines, à la RSE et à la compréhension de l’entreprise.', 208, '2026-05-13 19:05:53.561656', '2026-05-13 19:05:53.561656', 'Anglais technique, communication professionnelle, management de projet, innovation, stratégie, négociation, droit, finances, RSE, management interculturel.');
INSERT INTO public.course_categories VALUES (24, 'Séquence professionnelle et alternance', 'Périodes en entreprise permettant d’appliquer les compétences acquises à l’école, de développer une posture professionnelle et de progresser sur des missions techniques réelles.', 209, '2026-05-13 19:05:53.561656', '2026-05-13 19:05:53.561656', 'Alternance, expérience professionnelle, autonomie, mission technique, rapport professionnel, soutenance, tutorat, analyse de situation, compétences métier.');


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.courses VALUES (1, 'AC01', 'Révision d’analyse et d’algèbre', 'Consolidation des bases scientifiques pour la modélisation mathématique et la résolution numérique : systèmes linéaires, calcul matriciel, fonctions à plusieurs variables, intégrales, équations différentielles.', 'Analyse mathématique, algèbre linéaire, modélisation, calcul numérique.', 1, 1, '2026-05-13 18:31:09.68763', '2026-05-13 18:31:09.68763', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (2, 'AC04', 'Méthodes statistiques pour l’ingénieur', 'Statistiques appliquées avec raisonnement statistique, tests d’hypothèses, régression linéaire, estimation ponctuelle et intervalles de confiance.', 'Statistiques, régression linéaire, tests statistiques, analyse de données.', 1, 2, '2026-05-13 18:31:09.68763', '2026-05-13 18:31:09.68763', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (3, 'AI01', 'Algorithmique et structure de données', 'Structures de données de base et algorithmes associés : complexité, structures linéaires, arbres, tris, graphes, tables de hachage.', 'Algorithmique, complexité, structures de données, graphes, tables de hachage.', 2, 1, '2026-05-13 18:31:09.688875', '2026-05-13 18:31:09.688875', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (4, 'AI02', 'Intelligence artificielle : représentation des connaissances', 'Introduction aux concepts de base de l’intelligence artificielle, représentation des connaissances, raisonnement, programmation symbolique et fonctionnelle, réseaux sémantiques, ontologies et logiques de description.', 'IA symbolique, représentation des connaissances, raisonnement, ontologies.', 2, 2, '2026-05-13 18:31:09.688875', '2026-05-13 18:31:09.688875', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (5, 'AI03', 'Méthodes de vérification et validation de logiciels', 'Vérification et validation logicielle, tests fonctionnels et structurels, tests statiques, dynamiques et unitaires.', 'Test logiciel, validation, vérification, qualité logicielle.', 2, 3, '2026-05-13 18:31:09.688875', '2026-05-13 18:31:09.688875', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (6, 'AI05', 'Architecture des réseaux', 'Étude des réseaux informatiques, architectures, protocoles, Internet TCP/IP, réseaux locaux, réseaux sans fil et interconnexion.', 'Réseaux, TCP/IP, architecture réseau, protocoles, LAN, Wi-Fi.', 2, 4, '2026-05-13 18:31:09.688875', '2026-05-13 18:31:09.688875', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (7, 'AI16', 'Conception et développement web', 'Technologies et langages web pour concevoir et développer des applications client/serveur sécurisées et éco-responsables : HTTP, DOM, JavaScript, Ajax, programmation serveur, PHP.', 'Développement web, client/serveur, JavaScript, HTTP, sécurité web, éco-conception.', 2, 5, '2026-05-13 18:31:09.688875', '2026-05-13 18:31:09.688875', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (8, 'AI22', 'Programmation et conception orientées objets', 'Concepts et outils de programmation orientée objet : C++, classes, encapsulation, héritage, design patterns, Qt, UML.', 'POO, C++, UML, design patterns, Qt, conception logicielle.', 2, 6, '2026-05-13 18:31:09.688875', '2026-05-13 18:31:09.688875', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (9, 'AI23', 'Conception de bases de données relationnelles et non relationnelles', 'Conception de bases relationnelles, modèle conceptuel, création et interrogation de bases, transactions, SGBD, bases non relationnelles.', 'SQL, modélisation de données, SGBD, bases relationnelles, NoSQL, transactions.', 2, 7, '2026-05-13 18:31:09.688875', '2026-05-13 18:31:09.688875', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (10, 'AI26', 'Systèmes d’exploitation des concepts à la programmation', 'Architecture des systèmes d’exploitation : processus, interruptions, appels système, multitâche, synchronisation, mémoire virtuelle, multithreading, ordonnancement, interblocage, sécurité et API UNIX.', 'Systèmes d’exploitation, UNIX, processus, threads, mémoire virtuelle, concurrence, C système.', 2, 8, '2026-05-13 18:31:09.688875', '2026-05-13 18:31:09.688875', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (11, 'AI39', 'Systèmes informatiques temps réel et développement embarqué', 'Mise en œuvre de systèmes embarqués avec contraintes temporelles : développement barebones, noyaux temps réel, ordonnancement, synchronisation, systèmes d’exploitation embarqués et multitâche temps réel.', 'Systèmes embarqués, temps réel, C, RTOS, ordonnancement, synchronisation.', 2, 9, '2026-05-13 18:31:09.688875', '2026-05-13 18:31:09.688875', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (12, 'AI06', 'Capteurs pour les systèmes intelligents', 'Principes de mesure et capteurs : ultrasons, caméras, télémètres, accéléromètres, LiDAR, IMU et encodeurs. Mise en pratique avec une plateforme robotique TurtleBot, ROS et Python.', 'Capteurs, robotique, ROS, Python, LiDAR, IMU, vision, systèmes intelligents.', 3, 1, '2026-05-13 18:31:09.689227', '2026-05-13 18:31:09.689227', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (13, 'AI40', 'Automatique pour la robotique', 'Automatique avancée pour robots mobiles, drones, véhicules intelligents et humanoïdes. Contrôle temps réel, observateurs, autonomie décisionnelle, planification, commande optimale, filtre de Kalman et modélisation robotique.', 'Automatique, robotique, drones, commande optimale, observateurs, filtre de Kalman, contrôle non linéaire.', 3, 2, '2026-05-13 18:31:09.689227', '2026-05-13 18:31:09.689227', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (14, 'AI09', 'Méthodes et outils pour l’optimisation et la simulation', 'Modélisation mathématique et résolution de problèmes d’optimisation combinatoire, programmation linéaire, programmation par contraintes, simulation, heuristiques et solveurs spécialisés.', 'Optimisation combinatoire, simulation, programmation linéaire, heuristiques, solveurs.', 4, 1, '2026-05-13 18:31:09.689477', '2026-05-13 18:31:09.689477', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (15, 'AI29', 'Informatique quantique', 'Concepts de l’informatique quantique : qubits, registres, intrication, portes quantiques, algorithmes de recherche, transformée de Fourier quantique, factorisation et cryptographie.', 'Informatique quantique, qubits, algorithmes quantiques, cryptographie.', 4, 2, '2026-05-13 18:31:09.689477', '2026-05-13 18:31:09.689477', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (16, 'AI31', 'Indexation et recherche d’information', 'Gestion de bases documentaires, indexation de documents, découverte d’index à partir du contenu, traitement automatique des langues et text-mining.', 'Recherche d’information, indexation, NLP/TAL, text-mining, bases documentaires.', 4, 3, '2026-05-13 18:31:09.689477', '2026-05-13 18:31:09.689477', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (17, 'AE01', 'Période d’apprentissage en entreprise — année 1', 'Validation des périodes passées en entreprise pendant la première année de branche.', 'Expérience professionnelle, intégration en entreprise, application des compétences techniques.', 7, 1, '2026-05-13 18:31:09.689739', '2026-05-13 18:31:09.689739', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (18, 'AE02', 'Période d’apprentissage en entreprise — année 2', 'Validation des périodes passées en entreprise pendant la deuxième année de branche. L’UV met en avant l’autonomie, le métier cible, les compétences et l’analyse des situations professionnelles.', 'Autonomie, analyse de situations professionnelles, compétences métier, montée en responsabilité.', 7, 2, '2026-05-13 18:31:09.689739', '2026-05-13 18:31:09.689739', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (19, 'LH12', 'Anglais niveau II', 'Niveau B1. Compréhension, expression et interaction en anglais à partir d’articles, documents audio/vidéo, entretiens, débats et exposés.', 'Anglais B1, compréhension orale et écrite, expression orale, communication professionnelle.', 6, 1, '2026-05-13 18:31:09.689931', '2026-05-13 18:31:09.689931', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (20, 'LH13', 'Anglais niveau III', 'Niveau B2 nécessaire à la délivrance du diplôme d’ingénieur. Travail sur compréhension, expression et interaction en anglais avec supports presse, audio, vidéo, débats et exposés.', 'Anglais B2, anglais courant et professionnel, rédaction, exposés, débats.', 6, 2, '2026-05-13 18:31:09.689931', '2026-05-13 18:31:09.689931', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (21, 'LH14', 'Anglais niveau IV', 'Présentation claire et détaillée de sujets scientifiques, développement d’arguments et conclusion structurée d’une intervention.', 'Anglais scientifique, anglais technique, présentation orale, communication technique.', 6, 3, '2026-05-13 18:31:09.689931', '2026-05-13 18:31:09.689931', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (22, 'LH16', 'Anglais professionnel', 'Anglais formel et informel, CV, profil professionnel en ligne, lettre de motivation, négociation, diversité culturelle et générationnelle en entreprise et prise de parole.', 'Anglais professionnel, CV anglais, négociation, communication interculturelle, prise de parole.', 6, 4, '2026-05-13 18:31:09.689931', '2026-05-13 18:31:09.689931', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (23, 'SH02', 'Épistémologie et philosophie', 'Outils conceptuels pour comprendre la dynamique des connaissances scientifiques, les relations entre connaissance, information, organisation, cognition, technologie, ainsi que les débats sur travail, technique, valeurs et éthique professionnelle.', 'Éthique de l’ingénieur, philosophie des sciences, recul critique, technologie et société.', 5, 1, '2026-05-13 18:31:09.690291', '2026-05-13 18:31:09.690291', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (24, 'SH10', 'Sociologie du monde de l’entreprise : organisations, travail, capitalismes', 'Fondamentaux de la sociologie du monde économique : fonctionnement réel des organisations, structuration des marchés, rapport au travail, sociologie des organisations, du travail et économique.', 'Sociologie des organisations, compréhension de l’entreprise, travail, marchés, rôle de l’ingénieur.', 5, 2, '2026-05-13 18:31:09.690291', '2026-05-13 18:31:09.690291', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (25, 'SH40', 'Les risques entre technique et société', 'Étude des risques climatiques, météorologiques, technologiques et politiques ; analyse de la production et diffusion des connaissances sur les risques ; cartographie, analyse spatiale, webmapping, datavisualisation et SIG.', 'Gestion des risques, risques technologiques, SIG, cartographie, analyse spatiale, datavisualisation.', 5, 3, '2026-05-13 18:31:09.690291', '2026-05-13 18:31:09.690291', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (26, 'SH42', 'La pluralité du droit dans l’activité de l’ingénieur', 'Notions juridiques utiles à l’ingénieur : système judiciaire français, droit des contrats, responsabilité, droit du travail, propriété intellectuelle et industrielle, brevets.', 'Droit de l’ingénieur, contrats, responsabilité, droit du travail, propriété intellectuelle, brevets.', 5, 4, '2026-05-13 18:31:09.690291', '2026-05-13 18:31:09.690291', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (27, 'EG1R109E', 'Électronique S1', 'Introduction aux bases de l’électronique, à l’analyse de circuits, aux composants électroniques et aux premiers montages analogiques ou numériques. Cette matière permet de comprendre le comportement des signaux et des composants utilisés dans les systèmes électriques et électroniques.', 'Électronique, analyse de circuits, composants électroniques, signaux électriques, mesures, schématique électronique.', 8, 1, '2026-05-13 18:52:15.596907', '2026-05-13 18:52:15.596907', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (28, 'EG1R208E', 'Électronique S2', 'Approfondissement des notions d’électronique vues au premier semestre, avec étude de circuits électroniques, mesures, validation expérimentale et compréhension du fonctionnement de systèmes électroniques plus complets.', 'Électronique analogique, électronique numérique, mesures électriques, validation de circuits, instrumentation, oscilloscope, multimètre.', 8, 2, '2026-05-13 18:52:15.596907', '2026-05-13 18:52:15.596907', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (29, 'EG1R308E', 'Électronique S3', 'Étude avancée des circuits électroniques dans un contexte de systèmes industriels et embarqués. Cette matière renforce la capacité à analyser, dimensionner, tester et valider des fonctions électroniques.', 'Conception électronique, analyse de circuits, tests électroniques, oscilloscope, validation fonctionnelle, schématique électronique.', 8, 3, '2026-05-13 18:52:15.596907', '2026-05-13 18:52:15.596907', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (30, 'EG1R310E', 'Électronique rapide S3', 'Étude de phénomènes liés aux signaux rapides, aux temps de commutation, aux contraintes de transmission, aux perturbations et aux comportements dynamiques des circuits électroniques.', 'Signaux rapides, intégrité du signal, commutation, électronique haute vitesse, mesures temporelles, oscilloscope.', 8, 4, '2026-05-13 18:52:15.596907', '2026-05-13 18:52:15.596907', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (31, 'EG1R410E', 'Électronique rapide S4', 'Approfondissement de l’électronique rapide et des contraintes associées aux circuits fonctionnant avec des temps de réponse courts. Cette matière permet de mieux comprendre les phénomènes de commutation, de propagation et de perturbation dans les systèmes électroniques.', 'Électronique rapide, signaux, mesures, perturbations, validation électronique, analyse de signaux.', 8, 5, '2026-05-13 18:52:15.596907', '2026-05-13 18:52:15.596907', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (32, 'EG1R107E', 'Automatisme S1', 'Introduction aux systèmes automatisés, à la logique de commande, aux capteurs, actionneurs et séquences de fonctionnement utilisées dans les systèmes industriels.', 'Automatisme, logique de commande, capteurs, actionneurs, systèmes industriels, analyse fonctionnelle.', 9, 1, '2026-05-13 18:52:15.600608', '2026-05-13 18:52:15.600608', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (33, 'EG1R206E', 'Automatisme et microcontrôleurs S2', 'Étude des systèmes automatisés et des microcontrôleurs pour piloter des entrées/sorties, gérer des séquences, acquérir des informations et commander des systèmes électroniques ou industriels.', 'Automatisme, microcontrôleurs, GPIO, entrées/sorties, timers, interruptions, ADC, PWM, programmation embarquée, C embarqué, commande de systèmes.', 9, 2, '2026-05-13 18:52:15.600608', '2026-05-13 18:52:15.600608', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (34, 'EG1R306E', 'Automatique S3', 'Étude des systèmes dynamiques, de la modélisation et de la commande de systèmes physiques. Cette matière permet d’aborder les notions d’asservissement, de stabilité et de contrôle.', 'Automatique, asservissement, modélisation, stabilité, commande, systèmes dynamiques, analyse de systèmes.', 9, 3, '2026-05-13 18:52:15.600608', '2026-05-13 18:52:15.600608', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (35, 'EG1R307_LINUX_E', 'Linux et informatique embarquée S3', 'Introduction à l’utilisation de Linux dans un contexte technique et embarqué. Cette matière permet de manipuler un environnement système, des commandes, des outils de développement et des notions utiles à l’informatique embarquée.', 'Linux, Linux embarqué, informatique embarquée, système d’exploitation, ligne de commande, développement embarqué, programmation bas niveau.', 9, 4, '2026-05-13 18:52:15.600608', '2026-05-13 18:52:15.600608', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (36, 'EG1R121E', 'Énergie et physique appliquée S1', 'Étude des grandeurs physiques et électriques nécessaires à la compréhension des systèmes énergétiques, électroniques et industriels.', 'Énergie, physique appliquée, électricité, grandeurs physiques, systèmes électriques, mesures physiques.', 10, 1, '2026-05-13 18:52:15.601732', '2026-05-13 18:52:15.601732', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (37, 'EG1R221E', 'Énergie et physique appliquée S2', 'Approfondissement des phénomènes physiques et énergétiques appliqués aux systèmes électriques et électroniques. Cette matière permet de relier les notions théoriques aux mesures et applications techniques.', 'Physique appliquée, énergie électrique, mesures, systèmes électriques, modélisation physique, expérimentation.', 10, 2, '2026-05-13 18:52:15.601732', '2026-05-13 18:52:15.601732', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (38, 'EG1SEP2E', 'SAE Énergie et Physique S2', 'Mise en situation pratique autour de problématiques liées à l’énergie et à la physique appliquée. L’objectif est d’utiliser les connaissances théoriques pour analyser, mesurer et valider un système réel.', 'Énergie, mesures physiques, expérimentation, analyse de résultats, validation, travail en équipe.', 10, 3, '2026-05-13 18:52:15.601732', '2026-05-13 18:52:15.601732', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (39, 'EG1R108E', 'Génie logiciel S1', 'Introduction à la programmation, à la structuration du code, à la logique algorithmique et aux méthodes de développement logiciel appliquées à des problèmes techniques.', 'C, programmation, algorithmique, structuration du code, développement logiciel, logique informatique.', 11, 1, '2026-05-13 18:52:15.601938', '2026-05-13 18:52:15.601938', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (40, 'EG1R207E', 'Génie logiciel S2', 'Approfondissement du développement logiciel avec mise en œuvre de programmes plus structurés, de méthodes de conception et d’outils de développement.', 'C, développement logiciel, programmation, algorithmique, conception logicielle, tests, résolution de problèmes.', 11, 2, '2026-05-13 18:52:15.601938', '2026-05-13 18:52:15.601938', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (41, 'EG1SIN2E', 'SAE Informatique S2', 'Mise en pratique des compétences informatiques à travers un projet ou une situation d’apprentissage intégrant programmation, traitement de données ou développement d’outils logiciels.', 'C, programmation, projet informatique, développement logiciel, résolution de problèmes, tests, documentation.', 11, 3, '2026-05-13 18:52:15.601938', '2026-05-13 18:52:15.601938', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (42, 'EG1R307_RES_E', 'Réseaux de l’informatique industrielle S3', 'Étude des réseaux utilisés dans les environnements industriels pour permettre la communication entre équipements, systèmes embarqués, automates, capteurs et outils de supervision.', 'Réseaux industriels, communication machine, protocoles, supervision, systèmes distribués, bus de communication, protocoles industriels.', 11, 4, '2026-05-13 18:52:15.601938', '2026-05-13 18:52:15.601938', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (44, 'EGR204E', 'Mathématiques S2', 'Approfondissement des outils mathématiques utiles à l’analyse, la modélisation et la résolution de problèmes techniques en génie électrique et informatique industrielle.', 'Mathématiques appliquées, modélisation, analyse, calcul scientifique.', 12, 2, '2026-05-13 18:52:15.602249', '2026-05-13 18:52:15.602249', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (45, 'EG1R304E', 'Outil mathématique S3', 'Utilisation d’outils mathématiques pour analyser des systèmes, résoudre des problèmes techniques et accompagner la modélisation de phénomènes électriques, électroniques ou industriels.', 'Outils mathématiques, modélisation, calcul, analyse de systèmes.', 12, 3, '2026-05-13 18:52:15.602249', '2026-05-13 18:52:15.602249', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (46, 'EG1R404E', 'Outils mathématiques et logiciels S4', 'Utilisation combinée d’outils mathématiques et logiciels pour résoudre des problèmes techniques, simuler des systèmes et analyser des résultats.', 'Outils mathématiques, logiciels techniques, simulation, analyse de données, modélisation.', 12, 4, '2026-05-13 18:52:15.602249', '2026-05-13 18:52:15.602249', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (47, 'S3_OPT_MATHS', 'Option Mathématiques expertes / poursuite d’études', 'Cours complémentaire destiné à renforcer les bases mathématiques en vue d’une poursuite d’études, notamment en école d’ingénieurs.', 'Mathématiques avancées, raisonnement scientifique, préparation école d’ingénieurs, modélisation.', 12, 5, '2026-05-13 18:52:15.602249', '2026-05-13 18:52:15.602249', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (48, 'EG1S107E', 'SAE Automatisme S1', 'Projet de mise en situation autour de l’automatisme, permettant d’appliquer les notions de logique de commande, de séquencement et d’analyse de systèmes automatisés.', 'Automatisme, logique de commande, projet technique, analyse fonctionnelle, validation, travail en équipe.', 13, 1, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (49, 'EG1S109E', 'SAE Électronique S1', 'Projet pratique d’électronique permettant d’appliquer les connaissances en circuits, composants et mesures.', 'Électronique, montage, mesures, validation, expérimentation, tests électroniques.', 13, 2, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (50, 'EG1SR01', 'SAE Robot S1', 'Projet robotique de première année permettant d’appliquer des notions d’électronique, d’automatisme, de programmation et de conception de système.', 'Robotique, électronique, automatisme, C, programmation, intégration système, capteurs, actionneurs.', 13, 3, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (51, 'EG1SR01EC', 'SAE Robot Concevoir S1', 'Mise en œuvre d’une démarche de conception autour d’un système robotique : analyse du besoin, choix techniques, conception et validation.', 'Conception, robotique, cahier des charges, choix techniques, projet en équipe, documentation technique.', 13, 4, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (52, 'EG1SR01EV', 'SAE Robot Vérifier S1', 'Vérification du fonctionnement d’un système robotique à travers des tests, mesures et validations fonctionnelles.', 'Tests, validation, robotique, mesures, diagnostic, validation fonctionnelle.', 13, 5, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (53, 'EG1SEL2E', 'SAE Électronique et robotique S2', 'Projet intégrant des notions d’électronique et de robotique, avec mise en œuvre de circuits, de capteurs, d’actionneurs ou de programmes de commande.', 'Électronique, robotique, capteurs, actionneurs, programmation, C, intégration, tests.', 13, 6, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (54, 'EG1SAE3E_ROB', 'SAE Robotique S3', 'Projet robotique avancé permettant de mobiliser les compétences en électronique, informatique embarquée, automatisme et intégration système.', 'Robotique, systèmes embarqués, électronique, automatisme, programmation, C embarqué, tests, intégration système.', 13, 7, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (55, 'EG1SAE4E_ROB', 'SAE Robotique S4', 'Projet robotique de semestre 4 visant à approfondir la conception, l’intégration, le test et la validation d’un système robotique.', 'Robotique, intégration système, validation, conception, projet technique, travail en équipe, documentation.', 13, 8, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (56, 'EG1SPT1E', 'Projets tutorés S1', 'Premiers projets techniques réalisés en équipe pour appliquer les connaissances vues en formation et développer une démarche de projet.', 'Projet technique, travail en équipe, organisation, documentation, présentation.', 13, 9, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (57, 'EG1SPT2E', 'Projets tutorés S2', 'Réalisation de projets techniques plus avancés permettant de mobiliser les compétences en électronique, informatique, automatisme ou énergie.', 'Gestion de projet, conception, réalisation, tests, documentation technique, travail en équipe.', 13, 10, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (58, 'EG1SPT3E', 'Projets tutorés S3', 'Projet technique de semestre 3 permettant d’approfondir la démarche d’ingénierie, l’analyse du besoin, la conception et la validation d’une solution.', 'Projet technique, conception, validation, autonomie, travail en équipe, documentation technique.', 13, 11, '2026-05-13 18:52:15.602485', '2026-05-13 18:52:15.602485', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (59, 'EG1R101E', 'Anglais S1', 'Développement des compétences en compréhension et expression anglaise dans un contexte général et technique.', 'Anglais, compréhension écrite, expression orale, vocabulaire technique.', 14, 1, '2026-05-13 18:52:15.602838', '2026-05-13 18:52:15.602838', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (60, 'EG1R201E', 'Anglais S2', 'Approfondissement de l’anglais appliqué aux situations professionnelles et techniques.', 'Anglais technique, communication professionnelle, expression orale, rédaction.', 14, 2, '2026-05-13 18:52:15.602838', '2026-05-13 18:52:15.602838', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (61, 'EG1R301E', 'Anglais S3', 'Utilisation de l’anglais dans des contextes techniques, académiques et professionnels.', 'Anglais technique, communication, présentation orale, compréhension professionnelle.', 14, 3, '2026-05-13 18:52:15.602838', '2026-05-13 18:52:15.602838', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (62, 'EG1R401E', 'Anglais S4', 'Renforcement de l’anglais professionnel et technique, utile pour la poursuite d’études et l’intégration dans un environnement international.', 'Anglais professionnel, anglais technique, communication orale, rédaction.', 14, 4, '2026-05-13 18:52:15.602838', '2026-05-13 18:52:15.602838', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (63, 'EG1R102E', 'Culture et Communication S1', 'Développement de la communication écrite et orale, de la synthèse, de l’expression et de la capacité à présenter un travail technique.', 'Communication, rédaction, synthèse, présentation orale, argumentation.', 14, 5, '2026-05-13 18:52:15.602838', '2026-05-13 18:52:15.602838', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (64, 'EG1R202E', 'Culture et Communication S2', 'Approfondissement des compétences de communication dans un contexte universitaire et professionnel.', 'Communication professionnelle, rédaction, présentation, expression orale.', 14, 6, '2026-05-13 18:52:15.602838', '2026-05-13 18:52:15.602838', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (65, 'EG1R302E', 'Culture et Communication S3', 'Travail sur la communication technique, la rédaction professionnelle et la présentation de projets.', 'Communication technique, rédaction professionnelle, présentation de projet.', 14, 7, '2026-05-13 18:52:15.602838', '2026-05-13 18:52:15.602838', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (66, 'EG1R402E', 'Culture et Communication, Vie de l’entreprise, PPP S4', 'Préparation à l’environnement professionnel, à la compréhension de l’entreprise, à la communication professionnelle et à la valorisation du parcours.', 'Communication professionnelle, vie de l’entreprise, projet professionnel, insertion, valorisation des compétences.', 14, 8, '2026-05-13 18:52:15.602838', '2026-05-13 18:52:15.602838', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (67, 'EG1R105E', 'Projet Personnel et Professionnel S1', 'Construction progressive du projet professionnel, réflexion sur les compétences, les objectifs de poursuite d’études et les métiers visés.', 'Projet professionnel, orientation, autonomie, réflexion parcours, insertion.', 14, 9, '2026-05-13 18:52:15.602838', '2026-05-13 18:52:15.602838', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (68, 'EG1R205E', 'Projet Personnel et Professionnel S2', 'Approfondissement du projet professionnel et préparation à la poursuite d’études ou à l’insertion professionnelle.', 'Projet professionnel, poursuite d’études, autonomie, communication professionnelle.', 14, 10, '2026-05-13 18:52:15.602838', '2026-05-13 18:52:15.602838', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (69, 'EG1SPO1E', 'Portfolio S1', 'Mise en valeur des compétences acquises, des travaux réalisés et de la progression dans la formation.', 'Portfolio, valorisation des compétences, documentation, réflexion personnelle.', 15, 1, '2026-05-13 18:52:15.604047', '2026-05-13 18:52:15.604047', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (70, 'EG1SPO2E', 'Portfolio S2', 'Poursuite de la construction du portfolio de compétences et mise en avant des réalisations techniques.', 'Portfolio, compétences, documentation, présentation du parcours.', 15, 2, '2026-05-13 18:52:15.604047', '2026-05-13 18:52:15.604047', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (71, 'EG1SPO4E', 'Portfolio S4', 'Finalisation et valorisation des compétences développées pendant la formation, en lien avec les projets, le stage et la poursuite d’études.', 'Portfolio, valorisation professionnelle, compétences techniques, synthèse du parcours.', 15, 3, '2026-05-13 18:52:15.604047', '2026-05-13 18:52:15.604047', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (72, 'EG1STG4E_ESE', 'Stage S4', 'Expérience professionnelle permettant d’appliquer les compétences acquises en formation dans un environnement réel, technique ou industriel.', 'Expérience professionnelle, autonomie, application des compétences, travail en entreprise, rapport technique.', 15, 4, '2026-05-13 18:52:15.604047', '2026-05-13 18:52:15.604047', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (73, 'EG1R104E', 'Mathématiques S1', 'Bases mathématiques nécessaires à l’analyse des systèmes électriques, électroniques et automatisés.', 'Mathématiques appliquées, calcul, modélisation, résolution de problèmes.', 12, 1, '2026-05-13 18:55:59.56466', '2026-05-13 18:55:59.56466', NULL, NULL, NULL, NULL);
INSERT INTO public.courses VALUES (74, 'ESIEE_SCI_01', 'Outils mathématiques pour la modélisation', 'Étude des outils mathématiques nécessaires à la modélisation de systèmes physiques, électroniques et informatiques dans un contexte d’ingénierie.', 'Mathématiques appliquées, modélisation, analyse de systèmes, calcul scientifique.', 16, 1, '2026-05-13 19:05:53.564988', '2026-05-13 19:05:53.564988', '1re année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sciences pour l’ingénieur — 3 ECTS');
INSERT INTO public.courses VALUES (75, 'ESIEE_SCI_02', 'Fondamentaux de mathématiques pour l’ingénieur 1', 'Renforcement des fondamentaux mathématiques nécessaires à l’analyse, au raisonnement scientifique et à la résolution de problèmes d’ingénierie.', 'Mathématiques pour l’ingénieur, raisonnement scientifique, calcul, résolution de problèmes.', 16, 2, '2026-05-13 19:05:53.564988', '2026-05-13 19:05:53.564988', '1re année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sciences pour l’ingénieur — 3 ECTS');
INSERT INTO public.courses VALUES (76, 'ESIEE_SCI_03', 'Méthodes d’optimisation', 'Introduction aux méthodes d’optimisation utilisées pour formuler, analyser et résoudre des problèmes techniques ou industriels.', 'Optimisation, modélisation, résolution de problèmes, méthodes numériques.', 16, 3, '2026-05-13 19:05:53.564988', '2026-05-13 19:05:53.564988', '1re année', 'Semestre 2', '30 h', 'Inclus dans le bloc Sciences pour l’ingénieur — 3 ECTS');
INSERT INTO public.courses VALUES (77, 'ESIEE_SCI_04', 'Fondamentaux de mathématiques pour l’ingénieur 2', 'Approfondissement des notions mathématiques utiles à la modélisation, à l’analyse de systèmes et à la résolution de problèmes scientifiques.', 'Mathématiques appliquées, modélisation, analyse, calcul scientifique.', 16, 4, '2026-05-13 19:05:53.564988', '2026-05-13 19:05:53.564988', '1re année', 'Semestre 2', '30 h', 'Inclus dans le bloc Sciences pour l’ingénieur — 3 ECTS');
INSERT INTO public.courses VALUES (78, 'ESIEE_SCI_05', 'Statistiques et probabilités', 'Étude des probabilités et statistiques appliquées à l’analyse de données, à l’incertitude, à la modélisation et à la prise de décision en ingénierie.', 'Statistiques, probabilités, analyse de données, incertitude, modélisation.', 16, 5, '2026-05-13 19:05:53.564988', '2026-05-13 19:05:53.564988', '2e année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sciences pour l’ingénieur — 3 ECTS');
INSERT INTO public.courses VALUES (79, 'ESIEE_SCI_06', 'Fondements des systèmes de communication', 'Introduction aux principes scientifiques et techniques des systèmes de communication utilisés dans les systèmes électroniques et numériques.', 'Systèmes de communication, signal, transmission, réseaux, communication numérique.', 16, 6, '2026-05-13 19:05:53.564988', '2026-05-13 19:05:53.564988', '2e année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sciences pour l’ingénieur — 3 ECTS');
INSERT INTO public.courses VALUES (80, 'ESIEE_TR_01', 'Écoconception et analyse du cycle de vie', 'Étude des principes d’écoconception et d’analyse du cycle de vie afin d’évaluer l’impact environnemental d’un produit ou d’un système technique.', 'Écoconception, analyse du cycle de vie, développement durable, impact environnemental, conception responsable.', 17, 1, '2026-05-13 19:05:53.567102', '2026-05-13 19:05:53.567102', '1re année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sciences et techniques pour la transition — 3 ECTS');
INSERT INTO public.courses VALUES (81, 'ESIEE_TR_02', 'Environnement numérique de l’ingénieur', 'Découverte de l’environnement numérique de travail de l’ingénieur, des outils numériques et des méthodes utilisées pour concevoir, documenter, analyser et collaborer.', 'Outils numériques, environnement d’ingénierie, documentation, collaboration, méthodes de travail.', 17, 2, '2026-05-13 19:05:53.567102', '2026-05-13 19:05:53.567102', '1re année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sciences et techniques pour la transition — 3 ECTS');
INSERT INTO public.courses VALUES (82, 'ESIEE_TR_03', 'Physique pour la transition énergétique', 'Étude des principes physiques liés à l’énergie, aux systèmes énergétiques et aux enjeux de transition énergétique.', 'Physique appliquée, transition énergétique, énergie, systèmes physiques, modélisation.', 17, 3, '2026-05-13 19:05:53.567102', '2026-05-13 19:05:53.567102', '1re année', 'Semestre 2', '30 h', 'Inclus dans le bloc Sciences et techniques pour la transition — 3 ECTS');
INSERT INTO public.courses VALUES (83, 'ESIEE_TR_04', 'Algorithmique et programmation pour l’ingénieur', 'Introduction à l’algorithmique et à la programmation appliquées aux problématiques d’ingénierie.', 'Algorithmique, programmation, résolution de problèmes, structuration du code, logique informatique.', 17, 4, '2026-05-13 19:05:53.567102', '2026-05-13 19:05:53.567102', '1re année', 'Semestre 2', '30 h', 'Inclus dans le bloc Sciences et techniques pour la transition — 3 ECTS');
INSERT INTO public.courses VALUES (84, 'ESIEE_TR_05', 'Introduction aux réseaux, à la sécurité et à la cybersécurité', 'Introduction aux réseaux informatiques, aux principes de sécurité numérique et aux enjeux de cybersécurité dans les systèmes connectés.', 'Réseaux, cybersécurité, sécurité informatique, protocoles, systèmes connectés.', 17, 5, '2026-05-13 19:05:53.567102', '2026-05-13 19:05:53.567102', '2e année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sciences et techniques pour les transitions — 3 ECTS');
INSERT INTO public.courses VALUES (85, 'ESIEE_TR_06', 'Traitement et analyse de données', 'Méthodes de collecte, traitement, analyse et interprétation de données dans un contexte scientifique et technique.', 'Analyse de données, traitement de données, statistiques appliquées, visualisation, interprétation.', 17, 6, '2026-05-13 19:05:53.567102', '2026-05-13 19:05:53.567102', '2e année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sciences et techniques pour les transitions — 3 ECTS');
INSERT INTO public.courses VALUES (86, 'ESIEE_TR_07', 'Dérèglement climatique et pollutions 1 : modèles, impacts', 'Étude des modèles, impacts et enjeux liés au dérèglement climatique et aux pollutions.', 'Développement durable, climat, modélisation, analyse d’impact, transition écologique.', 17, 7, '2026-05-13 19:05:53.567102', '2026-05-13 19:05:53.567102', '2e année', 'Semestre 2', '30 h', 'Inclus dans le bloc Sciences et techniques pour les transitions — 3 ECTS');
INSERT INTO public.courses VALUES (87, 'ESIEE_TR_08', 'Introduction à l’IA', 'Introduction aux concepts fondamentaux de l’intelligence artificielle et à ses applications dans les systèmes numériques et industriels.', 'Intelligence artificielle, apprentissage automatique, analyse de données, algorithmique, modélisation.', 17, 8, '2026-05-13 19:05:53.567102', '2026-05-13 19:05:53.567102', '2e année', 'Semestre 2', '30 h', 'Inclus dans le bloc Sciences et techniques pour les transitions — 3 ECTS');
INSERT INTO public.courses VALUES (88, 'ESIEE_TR_09', 'Du capteur au cloud : mesure pour l’environnement', 'Étude d’une chaîne complète de mesure environnementale, depuis l’acquisition par capteur jusqu’à la transmission et l’exploitation des données dans le cloud.', 'Capteurs, acquisition de données, objets connectés, cloud, mesure environnementale, traitement de données.', 17, 9, '2026-05-13 19:05:53.567102', '2026-05-13 19:05:53.567102', '3e année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sciences et techniques pour les transitions — 3 ECTS');
INSERT INTO public.courses VALUES (89, 'ESIEE_TR_10', 'Dérèglement climatique et pollutions 2 : atelier DD', 'Atelier de développement durable appliqué notamment aux transports et aux véhicules électriques, avec analyse des enjeux environnementaux et techniques.', 'Développement durable, RSE, véhicules électriques, analyse d’impact, transition énergétique.', 17, 10, '2026-05-13 19:05:53.567102', '2026-05-13 19:05:53.567102', '3e année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sciences et techniques pour les transitions — 3 ECTS');
INSERT INTO public.courses VALUES (90, 'ESIEE_PRJ_01', 'Microcontrôleurs 1', 'Première approche des microcontrôleurs, de leur programmation et de leur utilisation pour piloter des entrées/sorties et réaliser des fonctions embarquées simples.', 'Microcontrôleurs, C embarqué, GPIO, programmation bas niveau, électronique embarquée.', 18, 1, '2026-05-13 19:05:53.567928', '2026-05-13 19:05:53.567928', '1re année', 'Semestre 1', '30 h', '2 ECTS');
INSERT INTO public.courses VALUES (91, 'ESIEE_PRJ_02', 'Microcontrôleurs 2', 'Approfondissement de la programmation des microcontrôleurs et de l’intégration de fonctions embarquées plus avancées.', 'Microcontrôleurs, timers, interruptions, ADC, PWM, programmation embarquée, intégration matérielle/logicielle.', 18, 2, '2026-05-13 19:05:53.567928', '2026-05-13 19:05:53.567928', '1re année', 'Semestre 2', '30 h', '2 ECTS');
INSERT INTO public.courses VALUES (92, 'ESIEE_PRJ_03', 'IHM / Android', 'Conception d’interfaces homme-machine et développement d’applications Android dans le cadre de projets techniques.', 'IHM, Android, interface utilisateur, développement mobile, ergonomie.', 18, 3, '2026-05-13 19:05:53.567928', '2026-05-13 19:05:53.567928', '2e année', 'Semestre 1', '20 h', 'Inclus dans le bloc Projet multidisciplinaire — 2 ECTS');
INSERT INTO public.courses VALUES (93, 'ESIEE_PRJ_04', 'Atelier LabVIEW', 'Utilisation de LabVIEW pour l’acquisition de données, la mesure, l’automatisation ou le pilotage de systèmes.', 'LabVIEW, acquisition de données, instrumentation, automatisation, mesure.', 18, 4, '2026-05-13 19:05:53.567928', '2026-05-13 19:05:53.567928', '2e année', 'Semestre 1', '10 h', 'Inclus dans le bloc Projet multidisciplinaire — 2 ECTS');
INSERT INTO public.courses VALUES (94, 'ESIEE_PRJ_05', 'Ingénierie dirigée par les modèles', 'Introduction à l’ingénierie dirigée par les modèles pour concevoir, structurer et générer des systèmes logiciels ou techniques à partir de modèles abstraits.', 'Modélisation, ingénierie dirigée par les modèles, architecture logicielle, conception système.', 18, 5, '2026-05-13 19:05:53.567928', '2026-05-13 19:05:53.567928', '2e année', 'Semestre 2', '30 h', '2 ECTS');
INSERT INTO public.courses VALUES (95, 'ESIEE_PRJ_06', 'Fil rouge', 'Projet long permettant de mobiliser les compétences acquises en électronique, logiciel embarqué, systèmes physiques, management de projet et validation autour d’une réalisation technique complète.', 'Projet d’ingénierie, systèmes embarqués, conception, intégration, validation, travail en équipe, documentation technique.', 18, 6, '2026-05-13 19:05:53.567928', '2026-05-13 19:05:53.567928', '3e année', 'Semestre 1', '125 h', 'Inclus dans le bloc Projet multidisciplinaire — 8 ECTS');
INSERT INTO public.courses VALUES (96, 'ESIEE_PRJ_07', 'Brevet / Propriété intellectuelle', 'Introduction aux notions de propriété intellectuelle, brevet, protection de l’innovation et valorisation technique.', 'Propriété intellectuelle, brevet, innovation, protection technique, valorisation.', 18, 7, '2026-05-13 19:05:53.567928', '2026-05-13 19:05:53.567928', '3e année', 'Semestre 1', '15 h', 'Inclus dans le bloc Projet multidisciplinaire — 8 ECTS');
INSERT INTO public.courses VALUES (97, 'ESIEE_ARCH_01', 'Électronique numérique', 'Étude des circuits logiques, des architectures numériques et des principes de conception électronique numérique.', 'Électronique numérique, logique combinatoire, logique séquentielle, architectures numériques, circuits logiques.', 19, 1, '2026-05-13 19:05:53.568421', '2026-05-13 19:05:53.568421', '1re année', 'Semestre 1', '24 h', 'Inclus dans le bloc Architectures & Électroniques embarquées — 4 ECTS');
INSERT INTO public.courses VALUES (98, 'ESIEE_ARCH_02', 'Électronique analogique', 'Étude des circuits analogiques, du conditionnement de signal, des composants électroniques et des fonctions d’acquisition.', 'Électronique analogique, composants électroniques, conditionnement de signal, mesures, acquisition.', 19, 2, '2026-05-13 19:05:53.568421', '2026-05-13 19:05:53.568421', '1re année', 'Semestre 1', '28 h', 'Inclus dans le bloc Architectures & Électroniques embarquées — 4 ECTS');
INSERT INTO public.courses VALUES (99, 'ESIEE_ARCH_03', 'Systèmes asservis, HIL', 'Étude des systèmes asservis et introduction aux approches Hardware-in-the-Loop pour tester et valider des systèmes commandés.', 'Systèmes asservis, HIL, automatique, validation, commande, tests.', 19, 3, '2026-05-13 19:05:53.568421', '2026-05-13 19:05:53.568421', '1re année', 'Semestre 1', '28 h', 'Inclus dans le bloc Architectures & Électroniques embarquées — 4 ECTS');
INSERT INTO public.courses VALUES (100, 'ESIEE_ARCH_04', 'Capteurs et électronique de conditionnement', 'Étude des capteurs et des circuits de conditionnement permettant d’adapter les signaux mesurés à une chaîne d’acquisition.', 'Capteurs, conditionnement de signal, électronique analogique, acquisition, mesures physiques.', 19, 4, '2026-05-13 19:05:53.568421', '2026-05-13 19:05:53.568421', '1re année', 'Semestre 2', '28 h', 'Inclus dans le bloc Architectures & Électroniques embarquées — 4 ECTS');
INSERT INTO public.courses VALUES (101, 'ESIEE_ARCH_05', 'Architectures numériques', 'Étude des architectures numériques utilisées dans les systèmes embarqués et électroniques.', 'Architectures numériques, logique numérique, systèmes embarqués, architecture matérielle.', 19, 5, '2026-05-13 19:05:53.568421', '2026-05-13 19:05:53.568421', '1re année', 'Semestre 2', '24 h', 'Inclus dans le bloc Architectures & Électroniques embarquées — 4 ECTS');
INSERT INTO public.courses VALUES (102, 'ESIEE_ARCH_06', 'Physique appliquée', 'Application des principes physiques aux systèmes électroniques, capteurs, mesures et systèmes embarqués.', 'Physique appliquée, systèmes physiques, mesures, modélisation, électronique.', 19, 6, '2026-05-13 19:05:53.568421', '2026-05-13 19:05:53.568421', '1re année', 'Semestre 2', '28 h', 'Inclus dans le bloc Architectures & Électroniques embarquées — 4 ECTS');
INSERT INTO public.courses VALUES (103, 'ESIEE_ARCH_07', 'Systèmes asservis, HIL', 'Approfondissement des systèmes asservis et des méthodes de validation Hardware-in-the-Loop pour systèmes embarqués.', 'Systèmes asservis, HIL, validation système, commande, modélisation.', 19, 7, '2026-05-13 19:05:53.568421', '2026-05-13 19:05:53.568421', '2e année', 'Semestre 1', '30 h', 'Inclus dans le bloc Électroniques embarqués avancées — 4 ECTS');
INSERT INTO public.courses VALUES (104, 'ESIEE_ARCH_08', 'Microprocesseur avancé', 'Étude avancée des microprocesseurs, de leur architecture et de leur intégration dans les systèmes embarqués.', 'Microprocesseurs, architecture processeur, systèmes embarqués, programmation bas niveau.', 19, 8, '2026-05-13 19:05:53.568421', '2026-05-13 19:05:53.568421', '2e année', 'Semestre 1', '20 h', 'Inclus dans le bloc Électroniques embarqués avancées — 4 ECTS');
INSERT INTO public.courses VALUES (105, 'ESIEE_ARCH_09', 'Compatibilité électromagnétique', 'Étude des perturbations électromagnétiques, de leur propagation, de leur impact sur les systèmes électroniques et des règles de conception associées.', 'CEM, compatibilité électromagnétique, perturbations, intégrité du signal, conception électronique.', 19, 9, '2026-05-13 19:05:53.568421', '2026-05-13 19:05:53.568421', '2e année', 'Semestre 1', '20 h', 'Inclus dans le bloc Électroniques embarqués avancées — 4 ECTS');
INSERT INTO public.courses VALUES (106, 'ESIEE_ARCH_10', 'Moteurs électriques et électroniques de commande', 'Étude des moteurs électriques, de leur commande et des circuits électroniques associés à la conversion et au pilotage d’énergie.', 'Moteurs électriques, électronique de commande, PWM, électronique de puissance, conversion d’énergie.', 19, 10, '2026-05-13 19:05:53.568421', '2026-05-13 19:05:53.568421', '2e année', 'Semestre 2', '30 h', 'Inclus dans le bloc Ingénierie des systèmes embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (107, 'ESIEE_SW_01', 'Système temps réel', 'Étude des systèmes soumis à des contraintes temporelles, avec notions d’ordonnancement, tâches, interruptions, synchronisation et déterminisme.', 'Temps réel, RTOS, ordonnancement, tâches, interruptions, synchronisation, déterminisme.', 20, 1, '2026-05-13 19:05:53.568945', '2026-05-13 19:05:53.568945', '2e année', 'Semestre 2', '28 h', 'Inclus dans le bloc Ingénierie des systèmes embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (108, 'ESIEE_SW_02', 'Objets connectés', 'Étude de systèmes connectés combinant capteurs, électronique, logiciel embarqué et communication réseau.', 'Objets connectés, IoT, capteurs, communication, logiciel embarqué, acquisition de données.', 20, 2, '2026-05-13 19:05:53.568945', '2026-05-13 19:05:53.568945', '2e année', 'Semestre 2', '22 h', 'Inclus dans le bloc Ingénierie des systèmes embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (109, 'ESIEE_SW_03', 'Particularités des transports aéronautiques, guidés et automobiles', 'Étude des contraintes propres aux systèmes embarqués utilisés dans les transports aéronautiques, guidés et automobiles.', 'Systèmes embarqués critiques, transport, contraintes industrielles, sûreté de fonctionnement, validation.', 20, 3, '2026-05-13 19:05:53.568945', '2026-05-13 19:05:53.568945', '3e année', 'Semestre 1', '24 h', 'Inclus dans le bloc Logiciels embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (110, 'ESIEE_SW_04', 'Logiciels critiques temps réel embarqué', 'Développement et validation de logiciels embarqués soumis à des contraintes temps réel et de criticité.', 'Logiciels critiques, temps réel embarqué, validation logicielle, sûreté, programmation embarquée.', 20, 4, '2026-05-13 19:05:53.568945', '2026-05-13 19:05:53.568945', '3e année', 'Semestre 1', '24 h', 'Inclus dans le bloc Logiciels embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (111, 'ESIEE_SW_05', 'IA embarquée', 'Étude des méthodes d’intelligence artificielle adaptées aux systèmes embarqués et aux contraintes de ressources.', 'IA embarquée, machine learning embarqué, optimisation, contraintes mémoire, traitement embarqué.', 20, 5, '2026-05-13 19:05:53.568945', '2026-05-13 19:05:53.568945', '3e année', 'Semestre 1', '22 h', 'Inclus dans le bloc Logiciels embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (112, 'ESIEE_SW_06', 'Vision, traitement d’images embarquées', 'Étude des méthodes de vision et de traitement d’images intégrées dans des systèmes embarqués.', 'Vision embarquée, traitement d’images, acquisition, filtrage, analyse d’images, systèmes embarqués.', 20, 6, '2026-05-13 19:05:53.568945', '2026-05-13 19:05:53.568945', '3e année', 'Semestre 1', '25 h', 'Inclus dans le bloc Logiciels embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (113, 'ESIEE_SEC_01', 'Réseaux de terrain', 'Étude des réseaux utilisés dans les systèmes industriels et embarqués pour connecter capteurs, actionneurs, contrôleurs et calculateurs.', 'Réseaux de terrain, protocoles industriels, communication embarquée, systèmes distribués.', 21, 1, '2026-05-13 19:05:53.569213', '2026-05-13 19:05:53.569213', '2e année', 'Semestre 2', '20 h', 'Inclus dans le bloc Ingénierie des systèmes embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (114, 'ESIEE_SEC_02', 'Cryptographie', 'Étude des principes de cryptographie utilisés pour sécuriser les communications, les données et les systèmes numériques.', 'Cryptographie, sécurité, chiffrement, protocoles sécurisés, protection des données.', 21, 2, '2026-05-13 19:05:53.569213', '2026-05-13 19:05:53.569213', '3e année', 'Semestre 1', '26 h', 'Inclus dans le bloc Sécurité et fiabilité des systèmes embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (115, 'ESIEE_SEC_03', 'Sécurité des applications embarquées', 'Étude des vulnérabilités, menaces et méthodes de sécurisation propres aux applications embarquées.', 'Sécurité embarquée, cybersécurité, applications embarquées, analyse de vulnérabilités, protection système.', 21, 3, '2026-05-13 19:05:53.569213', '2026-05-13 19:05:53.569213', '3e année', 'Semestre 1', '24 h', 'Inclus dans le bloc Sécurité et fiabilité des systèmes embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (116, 'ESIEE_SEC_04', 'Méthodes formelles', 'Introduction aux méthodes formelles permettant de spécifier, vérifier et valider rigoureusement le comportement de systèmes critiques.', 'Méthodes formelles, vérification, validation, spécification, systèmes critiques.', 21, 4, '2026-05-13 19:05:53.569213', '2026-05-13 19:05:53.569213', '3e année', 'Semestre 1', '24 h', 'Inclus dans le bloc Sécurité et fiabilité des systèmes embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (117, 'ESIEE_SEC_05', 'Validation et qualification système', 'Étude des méthodes de validation, qualification et vérification de systèmes embarqués dans un contexte industriel.', 'Validation système, qualification, tests, vérification, sûreté de fonctionnement, documentation technique.', 21, 5, '2026-05-13 19:05:53.569213', '2026-05-13 19:05:53.569213', '3e année', 'Semestre 1', '30 h', 'Inclus dans le bloc Sécurité et fiabilité des systèmes embarqués — 5 ECTS');
INSERT INTO public.courses VALUES (118, 'ESIEE_TECH_01', 'Process et technologies intégrées', 'Découverte des procédés et technologies intégrées, notamment en environnement salle blanche, utilisés dans la fabrication de composants et systèmes électroniques.', 'Technologies intégrées, salle blanche, microtechnologies, procédés industriels, fabrication électronique.', 22, 1, '2026-05-13 19:05:53.569455', '2026-05-13 19:05:53.569455', '3e année', 'Semestre 1', '30 h', 'Inclus dans le bloc Technologies des systèmes embarqués — 6 ECTS');
INSERT INTO public.courses VALUES (119, 'ESIEE_TECH_02', 'Communication sans fil', 'Étude des principes de communication sans fil utilisés dans les systèmes embarqués et connectés.', 'Communication sans fil, radiofréquence, protocoles, systèmes connectés, transmission.', 22, 2, '2026-05-13 19:05:53.569455', '2026-05-13 19:05:53.569455', '3e année', 'Semestre 1', '24 h', 'Inclus dans le bloc Technologies des systèmes embarqués — 6 ECTS');
INSERT INTO public.courses VALUES (120, 'ESIEE_TECH_03', 'Modélisation de systèmes électroniques industriels', 'Modélisation de systèmes électroniques industriels pour analyser, simuler et concevoir des solutions embarquées complexes.', 'Modélisation, systèmes électroniques industriels, simulation, conception système, analyse.', 22, 3, '2026-05-13 19:05:53.569455', '2026-05-13 19:05:53.569455', '3e année', 'Semestre 1', '40 h', 'Inclus dans le bloc Technologies des systèmes embarqués — 6 ECTS');
INSERT INTO public.courses VALUES (121, 'ESIEE_TECH_04', 'Produits - Marchés - Perspectives', 'Analyse des produits, marchés et perspectives liés aux technologies des systèmes embarqués.', 'Analyse marché, innovation, stratégie produit, technologies embarquées, veille technologique.', 22, 4, '2026-05-13 19:05:53.569455', '2026-05-13 19:05:53.569455', '3e année', 'Semestre 1', '18 h', 'Inclus dans le bloc Technologies des systèmes embarqués — 6 ECTS');
INSERT INTO public.courses VALUES (122, 'ESIEE_HUM_01', 'Anglais 1', 'Développement des compétences en anglais dans un contexte académique, professionnel et technique.', 'Anglais, compréhension, expression orale, communication technique.', 23, 1, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '1re année', 'Semestre 1', '30 h', '1 ECTS');
INSERT INTO public.courses VALUES (123, 'ESIEE_HUM_02', 'Compétences & Carrières S1', 'Développement des compétences professionnelles, réflexion sur le parcours, les objectifs et l’insertion dans le monde de l’entreprise.', 'Projet professionnel, compétences, carrière, insertion, communication.', 23, 2, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '1re année', 'Semestre 1', '12 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 2 ECTS');
INSERT INTO public.courses VALUES (124, 'ESIEE_HUM_03', 'Projet d’intégration', 'Projet visant à faciliter l’intégration dans la formation, le travail en équipe et la compréhension des attentes de l’école.', 'Travail en équipe, intégration, communication, organisation.', 23, 3, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '1re année', 'Semestre 1', '14 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 2 ECTS');
INSERT INTO public.courses VALUES (125, 'ESIEE_HUM_04', 'Découverte de l’entreprise', 'Découverte du fonctionnement de l’entreprise, de ses métiers, de son organisation et de ses enjeux.', 'Entreprise, organisation, management, culture professionnelle.', 23, 4, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '1re année', 'Semestre 1', '16 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 2 ECTS');
INSERT INTO public.courses VALUES (126, 'ESIEE_HUM_05', 'Anglais 2', 'Approfondissement de l’anglais technique et professionnel.', 'Anglais technique, communication professionnelle, rédaction, expression orale.', 23, 5, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '1re année', 'Semestre 2', '30 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (127, 'ESIEE_HUM_06', 'Compétences & Carrières S2', 'Poursuite de la construction du projet professionnel et valorisation des compétences.', 'Projet professionnel, valorisation des compétences, communication, insertion.', 23, 6, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '1re année', 'Semestre 2', '10 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (128, 'ESIEE_HUM_07', 'Management de projet', 'Introduction aux méthodes de management de projet, à l’organisation, au suivi et au pilotage d’activités techniques.', 'Management de projet, organisation, planification, suivi, travail en équipe.', 23, 7, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '1re année', 'Semestre 2', '16 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (129, 'ESIEE_HUM_08', 'Finances et structures des coûts', 'Introduction aux notions financières et aux structures de coûts dans un contexte d’entreprise et de projet.', 'Finances, coûts, gestion, entreprise, prise de décision.', 23, 8, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '1re année', 'Semestre 2', '16 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (130, 'ESIEE_HUM_09', 'Anglais 3', 'Renforcement de l’anglais appliqué aux contextes techniques, professionnels et internationaux.', 'Anglais professionnel, anglais technique, communication, présentation orale.', 23, 9, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '2e année', 'Semestre 1', '30 h', '1 ECTS');
INSERT INTO public.courses VALUES (131, 'ESIEE_HUM_10', 'Compétences & Carrières S3', 'Développement de la posture professionnelle et des compétences liées à la carrière.', 'Carrière, compétences professionnelles, communication, projet professionnel.', 23, 10, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '2e année', 'Semestre 1', '10 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 2 ECTS');
INSERT INTO public.courses VALUES (132, 'ESIEE_HUM_11', 'Improvisation théâtrale', 'Exercices d’expression orale, d’aisance relationnelle et de communication à travers l’improvisation.', 'Expression orale, communication, aisance, prise de parole.', 23, 11, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '2e année', 'Semestre 1', '6 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 2 ECTS');
INSERT INTO public.courses VALUES (133, 'ESIEE_HUM_12', 'Management de l’innovation technologique / Stratégie d’entreprise / Économie de l’innovation', 'Enseignement au choix portant sur l’innovation, la stratégie d’entreprise ou l’économie de l’innovation.', 'Innovation, stratégie, créativité, économie, management.', 23, 12, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '2e année', 'Semestre 1', '14 h', 'Inclus dans le bloc Être innovant et créatif');
INSERT INTO public.courses VALUES (134, 'ESIEE_HUM_13', 'Négocier et vendre / Recruter un équipier / Diriger et décider', 'Enseignement au choix visant à développer des compétences de communication, de négociation, de recrutement ou de prise de décision.', 'Négociation, communication, décision, management, leadership.', 23, 13, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '2e année', 'Semestre 1', '12 h', 'Inclus dans le bloc Être communicant et négociateur');
INSERT INTO public.courses VALUES (135, 'ESIEE_HUM_14', 'Anglais 4', 'Approfondissement de l’anglais professionnel et technique.', 'Anglais professionnel, anglais technique, rédaction, expression orale.', 23, 14, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '2e année', 'Semestre 2', '30 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (136, 'ESIEE_HUM_15', 'Compétences & Carrières S4', 'Valorisation des compétences, préparation à l’évolution professionnelle et structuration du parcours d’ingénieur.', 'Carrière, valorisation, projet professionnel, communication.', 23, 15, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '2e année', 'Semestre 2', '12 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (137, 'ESIEE_HUM_16', 'Introduction au droit', 'Introduction aux notions juridiques utiles à l’ingénieur et à l’activité en entreprise.', 'Droit, responsabilité, entreprise, contrats, propriété intellectuelle.', 23, 16, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '2e année', 'Semestre 2', '12 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (138, 'ESIEE_HUM_17', 'Simulation de gestion d’entreprise / Simulation de gestion de projet', 'Mise en situation autour de la gestion d’entreprise ou de projet afin de comprendre les décisions économiques, organisationnelles et stratégiques.', 'Gestion d’entreprise, gestion de projet, stratégie, prise de décision, management.', 23, 17, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '2e année', 'Semestre 2', '18 h', 'Inclus dans le bloc Business game');
INSERT INTO public.courses VALUES (139, 'ESIEE_HUM_18', 'Anglais 5', 'Renforcement de la communication en anglais dans un contexte professionnel, technique et international.', 'Anglais professionnel, anglais technique, communication internationale, présentation.', 23, 18, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '3e année', 'Semestre 1', '30 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (140, 'ESIEE_HUM_19', 'Compétences & Carrières S5', 'Préparation à l’entrée dans la vie professionnelle, valorisation du parcours et consolidation de la posture d’ingénieur.', 'Carrière, insertion professionnelle, communication, posture ingénieur.', 23, 19, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '3e année', 'Semestre 1', '20 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (141, 'ESIEE_HUM_20', 'Management interculturel', 'Étude des enjeux de collaboration, communication et management dans des contextes multiculturels.', 'Management interculturel, communication internationale, collaboration, diversité culturelle.', 23, 20, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '3e année', 'Semestre 1', '10 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (142, 'ESIEE_HUM_21', 'Sciences sociales autour des enjeux DD et RSE', 'Analyse des enjeux de développement durable, de responsabilité sociétale des entreprises et de leur impact sur les organisations.', 'RSE, développement durable, sciences sociales, responsabilité, entreprise.', 23, 21, '2026-05-13 19:05:53.569922', '2026-05-13 19:05:53.569922', '3e année', 'Semestre 1', '12 h', 'Inclus dans le bloc Anglais, management et sciences humaines — 3 ECTS');
INSERT INTO public.courses VALUES (143, 'ESIEE_ALT_01', 'Séquence professionnelle S1', 'Période professionnelle en entreprise permettant de découvrir l’environnement industriel, les missions techniques et l’organisation du travail en alternance.', 'Alternance, entreprise, intégration, observation, compétences professionnelles.', 24, 1, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '1re année', 'Semestre 1', 'Non applicable', '15 ECTS');
INSERT INTO public.courses VALUES (144, 'ESIEE_ALT_02', 'Exercices d’alternance S1', 'Travaux liés à l’analyse de l’expérience en entreprise et à la formalisation des compétences développées pendant l’alternance.', 'Analyse professionnelle, rédaction, retour d’expérience, posture d’apprenti ingénieur.', 24, 2, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '1re année', 'Semestre 1', 'Non applicable', 'Inclus dans le bloc professionnel S1');
INSERT INTO public.courses VALUES (145, 'ESIEE_ALT_03', 'Séquence professionnelle S2', 'Période professionnelle en entreprise permettant de poursuivre la montée en compétences sur des missions techniques.', 'Alternance, mission technique, autonomie, intégration en équipe, compétences métier.', 24, 3, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '1re année', 'Semestre 2', 'Non applicable', '15 ECTS');
INSERT INTO public.courses VALUES (146, 'ESIEE_ALT_04', 'Rapport de situation professionnelle', 'Rédaction d’un rapport permettant de présenter le contexte professionnel, l’entreprise, les missions réalisées et les compétences développées.', 'Rédaction technique, analyse de mission, synthèse, communication professionnelle.', 24, 4, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '1re année', 'Semestre 2', 'Non applicable', 'Inclus dans le bloc professionnel S2');
INSERT INTO public.courses VALUES (147, 'ESIEE_ALT_05', 'Soutenance du rapport de situation professionnelle', 'Présentation orale du rapport de situation professionnelle devant un jury ou des encadrants.', 'Présentation orale, soutenance, communication, argumentation.', 24, 5, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '1re année', 'Semestre 2', 'Non applicable', 'Inclus dans le bloc professionnel S2');
INSERT INTO public.courses VALUES (148, 'ESIEE_ALT_06', 'Animation du tutorat S2', 'Suivi et échanges entre l’apprenti, l’école et l’entreprise afin d’accompagner la progression professionnelle.', 'Tutorat, suivi professionnel, communication, progression.', 24, 6, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '1re année', 'Semestre 2', 'Non applicable', 'Inclus dans le bloc professionnel S2');
INSERT INTO public.courses VALUES (149, 'ESIEE_ALT_07', 'Séquence professionnelle S3', 'Poursuite de l’alternance avec montée en responsabilité et application des compétences techniques en entreprise.', 'Alternance, autonomie, montée en responsabilité, mission technique, compétences métier.', 24, 7, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '2e année', 'Semestre 1', 'Non applicable', '15 ECTS');
INSERT INTO public.courses VALUES (150, 'ESIEE_ALT_08', 'Études scientifiques et techniques', 'Travail d’analyse technique et scientifique en lien avec les missions réalisées en entreprise.', 'Analyse technique, démarche scientifique, documentation, résolution de problèmes.', 24, 8, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '2e année', 'Semestre 2', 'Non applicable', 'Inclus dans le bloc professionnel S4');
INSERT INTO public.courses VALUES (151, 'ESIEE_ALT_09', 'Séquence professionnelle S4', 'Période professionnelle en entreprise centrée sur des missions techniques plus avancées et professionnalisantes.', 'Alternance, autonomie, mission technique, responsabilité, intégration professionnelle.', 24, 9, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '2e année', 'Semestre 2', 'Non applicable', '15 ECTS');
INSERT INTO public.courses VALUES (152, 'ESIEE_ALT_10', 'Rapport de mission technique', 'Rédaction d’un rapport détaillant une mission technique réalisée en entreprise, ses objectifs, méthodes, résultats et apports.', 'Rapport technique, analyse de mission, documentation, synthèse, validation.', 24, 10, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '2e année', 'Semestre 2', 'Non applicable', 'Inclus dans le bloc professionnel S4');
INSERT INTO public.courses VALUES (153, 'ESIEE_ALT_11', 'Soutenance du rapport de mission technique', 'Présentation orale d’une mission technique réalisée en entreprise, avec mise en avant du contexte, des choix techniques et des résultats.', 'Soutenance, communication orale, argumentation technique, présentation.', 24, 11, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '2e année', 'Semestre 2', 'Non applicable', 'Inclus dans le bloc professionnel S4');
INSERT INTO public.courses VALUES (154, 'ESIEE_ALT_12', 'Animation du tutorat S4', 'Suivi de l’alternance et accompagnement de la progression de l’apprenti ingénieur entre école et entreprise.', 'Tutorat, progression professionnelle, communication, analyse réflexive.', 24, 12, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '2e année', 'Semestre 2', 'Non applicable', 'Inclus dans le bloc professionnel S4');
INSERT INTO public.courses VALUES (155, 'ESIEE_ALT_13', 'Séquence professionnelle et alternance', 'Période professionnelle de dernière année permettant de consolider les compétences d’ingénieur, d’approfondir les missions techniques et de préparer la transition vers le métier cible.', 'Alternance, autonomie, responsabilité, mission d’ingénieur, professionnalisation, compétences métier.', 24, 13, '2026-05-13 19:05:53.570481', '2026-05-13 19:05:53.570481', '3e année', 'Semestre 1', 'Non applicable', 'À compléter selon les données disponibles');


--
-- Data for Name: diplome; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: education_courses; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.education_courses VALUES (6, 1);
INSERT INTO public.education_courses VALUES (6, 2);
INSERT INTO public.education_courses VALUES (6, 3);
INSERT INTO public.education_courses VALUES (6, 4);
INSERT INTO public.education_courses VALUES (6, 5);
INSERT INTO public.education_courses VALUES (6, 6);
INSERT INTO public.education_courses VALUES (6, 7);
INSERT INTO public.education_courses VALUES (6, 8);
INSERT INTO public.education_courses VALUES (6, 9);
INSERT INTO public.education_courses VALUES (6, 10);
INSERT INTO public.education_courses VALUES (6, 11);
INSERT INTO public.education_courses VALUES (6, 12);
INSERT INTO public.education_courses VALUES (6, 13);
INSERT INTO public.education_courses VALUES (6, 14);
INSERT INTO public.education_courses VALUES (6, 15);
INSERT INTO public.education_courses VALUES (6, 16);
INSERT INTO public.education_courses VALUES (6, 17);
INSERT INTO public.education_courses VALUES (6, 18);
INSERT INTO public.education_courses VALUES (6, 19);
INSERT INTO public.education_courses VALUES (6, 20);
INSERT INTO public.education_courses VALUES (6, 21);
INSERT INTO public.education_courses VALUES (6, 22);
INSERT INTO public.education_courses VALUES (6, 23);
INSERT INTO public.education_courses VALUES (6, 24);
INSERT INTO public.education_courses VALUES (6, 25);
INSERT INTO public.education_courses VALUES (6, 26);
INSERT INTO public.education_courses VALUES (5, 27);
INSERT INTO public.education_courses VALUES (5, 28);
INSERT INTO public.education_courses VALUES (5, 29);
INSERT INTO public.education_courses VALUES (5, 30);
INSERT INTO public.education_courses VALUES (5, 31);
INSERT INTO public.education_courses VALUES (5, 32);
INSERT INTO public.education_courses VALUES (5, 33);
INSERT INTO public.education_courses VALUES (5, 34);
INSERT INTO public.education_courses VALUES (5, 35);
INSERT INTO public.education_courses VALUES (5, 36);
INSERT INTO public.education_courses VALUES (5, 37);
INSERT INTO public.education_courses VALUES (5, 38);
INSERT INTO public.education_courses VALUES (5, 39);
INSERT INTO public.education_courses VALUES (5, 40);
INSERT INTO public.education_courses VALUES (5, 41);
INSERT INTO public.education_courses VALUES (5, 42);
INSERT INTO public.education_courses VALUES (5, 44);
INSERT INTO public.education_courses VALUES (5, 45);
INSERT INTO public.education_courses VALUES (5, 46);
INSERT INTO public.education_courses VALUES (5, 47);
INSERT INTO public.education_courses VALUES (5, 48);
INSERT INTO public.education_courses VALUES (5, 49);
INSERT INTO public.education_courses VALUES (5, 50);
INSERT INTO public.education_courses VALUES (5, 51);
INSERT INTO public.education_courses VALUES (5, 52);
INSERT INTO public.education_courses VALUES (5, 53);
INSERT INTO public.education_courses VALUES (5, 54);
INSERT INTO public.education_courses VALUES (5, 55);
INSERT INTO public.education_courses VALUES (5, 56);
INSERT INTO public.education_courses VALUES (5, 57);
INSERT INTO public.education_courses VALUES (5, 58);
INSERT INTO public.education_courses VALUES (5, 59);
INSERT INTO public.education_courses VALUES (5, 60);
INSERT INTO public.education_courses VALUES (5, 61);
INSERT INTO public.education_courses VALUES (5, 62);
INSERT INTO public.education_courses VALUES (5, 63);
INSERT INTO public.education_courses VALUES (5, 64);
INSERT INTO public.education_courses VALUES (5, 65);
INSERT INTO public.education_courses VALUES (5, 66);
INSERT INTO public.education_courses VALUES (5, 67);
INSERT INTO public.education_courses VALUES (5, 68);
INSERT INTO public.education_courses VALUES (5, 69);
INSERT INTO public.education_courses VALUES (5, 70);
INSERT INTO public.education_courses VALUES (5, 71);
INSERT INTO public.education_courses VALUES (5, 72);
INSERT INTO public.education_courses VALUES (5, 73);
INSERT INTO public.education_courses VALUES (7, 143);
INSERT INTO public.education_courses VALUES (7, 144);
INSERT INTO public.education_courses VALUES (7, 145);
INSERT INTO public.education_courses VALUES (7, 146);
INSERT INTO public.education_courses VALUES (7, 147);
INSERT INTO public.education_courses VALUES (7, 148);
INSERT INTO public.education_courses VALUES (7, 149);
INSERT INTO public.education_courses VALUES (7, 150);
INSERT INTO public.education_courses VALUES (7, 151);
INSERT INTO public.education_courses VALUES (7, 152);
INSERT INTO public.education_courses VALUES (7, 153);
INSERT INTO public.education_courses VALUES (7, 154);
INSERT INTO public.education_courses VALUES (7, 155);
INSERT INTO public.education_courses VALUES (7, 97);
INSERT INTO public.education_courses VALUES (7, 98);
INSERT INTO public.education_courses VALUES (7, 99);
INSERT INTO public.education_courses VALUES (7, 100);
INSERT INTO public.education_courses VALUES (7, 101);
INSERT INTO public.education_courses VALUES (7, 102);
INSERT INTO public.education_courses VALUES (7, 103);
INSERT INTO public.education_courses VALUES (7, 104);
INSERT INTO public.education_courses VALUES (7, 105);
INSERT INTO public.education_courses VALUES (7, 106);
INSERT INTO public.education_courses VALUES (7, 122);
INSERT INTO public.education_courses VALUES (7, 123);
INSERT INTO public.education_courses VALUES (7, 124);
INSERT INTO public.education_courses VALUES (7, 125);
INSERT INTO public.education_courses VALUES (7, 126);
INSERT INTO public.education_courses VALUES (7, 127);
INSERT INTO public.education_courses VALUES (7, 128);
INSERT INTO public.education_courses VALUES (7, 129);
INSERT INTO public.education_courses VALUES (7, 130);
INSERT INTO public.education_courses VALUES (7, 131);
INSERT INTO public.education_courses VALUES (7, 132);
INSERT INTO public.education_courses VALUES (7, 133);
INSERT INTO public.education_courses VALUES (7, 134);
INSERT INTO public.education_courses VALUES (7, 135);
INSERT INTO public.education_courses VALUES (7, 136);
INSERT INTO public.education_courses VALUES (7, 137);
INSERT INTO public.education_courses VALUES (7, 138);
INSERT INTO public.education_courses VALUES (7, 139);
INSERT INTO public.education_courses VALUES (7, 140);
INSERT INTO public.education_courses VALUES (7, 141);
INSERT INTO public.education_courses VALUES (7, 142);
INSERT INTO public.education_courses VALUES (7, 90);
INSERT INTO public.education_courses VALUES (7, 91);
INSERT INTO public.education_courses VALUES (7, 92);
INSERT INTO public.education_courses VALUES (7, 93);
INSERT INTO public.education_courses VALUES (7, 94);
INSERT INTO public.education_courses VALUES (7, 95);
INSERT INTO public.education_courses VALUES (7, 96);
INSERT INTO public.education_courses VALUES (7, 74);
INSERT INTO public.education_courses VALUES (7, 75);
INSERT INTO public.education_courses VALUES (7, 76);
INSERT INTO public.education_courses VALUES (7, 77);
INSERT INTO public.education_courses VALUES (7, 78);
INSERT INTO public.education_courses VALUES (7, 79);
INSERT INTO public.education_courses VALUES (7, 113);
INSERT INTO public.education_courses VALUES (7, 114);
INSERT INTO public.education_courses VALUES (7, 115);
INSERT INTO public.education_courses VALUES (7, 116);
INSERT INTO public.education_courses VALUES (7, 117);
INSERT INTO public.education_courses VALUES (7, 107);
INSERT INTO public.education_courses VALUES (7, 108);
INSERT INTO public.education_courses VALUES (7, 109);
INSERT INTO public.education_courses VALUES (7, 110);
INSERT INTO public.education_courses VALUES (7, 111);
INSERT INTO public.education_courses VALUES (7, 112);
INSERT INTO public.education_courses VALUES (7, 118);
INSERT INTO public.education_courses VALUES (7, 119);
INSERT INTO public.education_courses VALUES (7, 120);
INSERT INTO public.education_courses VALUES (7, 121);
INSERT INTO public.education_courses VALUES (7, 80);
INSERT INTO public.education_courses VALUES (7, 81);
INSERT INTO public.education_courses VALUES (7, 82);
INSERT INTO public.education_courses VALUES (7, 83);
INSERT INTO public.education_courses VALUES (7, 84);
INSERT INTO public.education_courses VALUES (7, 85);
INSERT INTO public.education_courses VALUES (7, 86);
INSERT INTO public.education_courses VALUES (7, 87);
INSERT INTO public.education_courses VALUES (7, 88);
INSERT INTO public.education_courses VALUES (7, 89);


--
-- Data for Name: education_projects; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: education_skills; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: education_technologies; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.education_technologies VALUES (5, 2);
INSERT INTO public.education_technologies VALUES (5, 3);
INSERT INTO public.education_technologies VALUES (5, 7);
INSERT INTO public.education_technologies VALUES (5, 8);
INSERT INTO public.education_technologies VALUES (5, 4);
INSERT INTO public.education_technologies VALUES (5, 9);
INSERT INTO public.education_technologies VALUES (5, 13);
INSERT INTO public.education_technologies VALUES (5, 16);
INSERT INTO public.education_technologies VALUES (5, 15);
INSERT INTO public.education_technologies VALUES (5, 14);
INSERT INTO public.education_technologies VALUES (5, 12);
INSERT INTO public.education_technologies VALUES (5, 11);


--
-- Data for Name: educations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.educations VALUES (6, 'Bachelor en Science et Technologie', 4, 'Bachelor en Science et Technologie', 'Sciences, technologie et informatique', 'Formation scientifique et technologique suivie à l’Université de Technologie de Compiègne, avec une orientation initiale vers l’ingénierie informatique généraliste. Ce parcours m’a permis de renforcer mes compétences en informatique, mathématiques, sciences de l’ingénieur, développement logiciel et méthodologie de projet. Il m’a également permis de consolider ma capacité à analyser des problèmes techniques, concevoir des solutions logicielles et travailler sur des projets à dimension scientifique et technologique.', '2023-08-31', '2025-06-30', 'done', '2026-05-12 21:20:39.193746', '2026-05-12 21:22:02.261514', 2, 'La formation UTC renforce mon socle en informatique, mathématiques, systèmes, robotique et technologies avancées. Elle complète mon parcours GEII en élargissant mes compétences vers l’algorithmique, les bases de données, les réseaux, les systèmes d’exploitation, l’optimisation, la robotique, le temps réel et l’analyse critique du rôle de l’ingénieur.', '{}', NULL, 'Le programme suivi à l’UTC m’a permis de structurer un socle scientifique et informatique solide, avec des UV en algorithmique, programmation orientée objet, systèmes d’exploitation, bases de données, réseaux, systèmes temps réel, robotique, optimisation, anglais et sciences humaines.', NULL);
INSERT INTO public.educations VALUES (5, 'DUT Génie Électrique et Informatique Industrielle', 3, 'DUT GEII — Génie Électrique et Informatique Industrielle', 'Électronique, informatique industrielle et systèmes embarqués', 'Formation universitaire technologique orientée vers l’électronique, l’électrotechnique, l’automatisme, l’informatique industrielle et les systèmes embarqués. Ce parcours m’a permis de développer des compétences solides en programmation, microcontrôleurs, mesures électriques, traitement du signal, automatisation et conception de systèmes électroniques. Grâce aux travaux pratiques et aux projets techniques, j’ai renforcé ma capacité à analyser, concevoir, programmer et tester des systèmes électroniques et informatiques industriels.', '2021-08-29', '2023-06-28', 'done', '2026-05-12 21:17:17.799848', '2026-05-13 14:48:14.552063', 3, 'Le parcours GEII — Électronique et Systèmes Embarqués à l’IUT de Cachan m’a permis d’acquérir des bases solides en électronique, électrotechnique, automatisme, informatique industrielle et systèmes embarqués. La formation s’est appuyée sur des enseignements théoriques, des travaux pratiques, des projets tutorés et des SAE autour de la robotique, de l’électronique, de l’énergie, des microcontrôleurs et des réseaux industriels. Elle a constitué une étape déterminante dans mon orientation vers les systèmes embarqués, la conception électronique et la validation de systèmes techniques.', '{}', NULL, NULL, NULL);
INSERT INTO public.educations VALUES (7, 'Diplôme d’ingénieur — Systèmes embarqués', 5, 'Diplôme d’ingénieur', 'Systèmes embarqués, électronique et électrotechnique ', 'Formation d’ingénieur spécialisée en systèmes embarqués, orientée vers la conception de systèmes électroniques et informatiques intégrés. Ce cursus me permet de développer des compétences avancées en électronique, programmation bas niveau, microcontrôleurs, architecture matérielle/logicielle, systèmes temps réel, bus de communication et conception de cartes électroniques. Cette formation s’inscrit dans mon objectif de devenir ingénieur en systèmes embarqués, avec une capacité à concevoir, développer, tester et intégrer des solutions techniques complètes.', '2025-09-22', '2028-08-01', 'in_progress', '2026-05-12 21:23:25.198435', '2026-05-12 21:23:25.198435', 1, 'Cette formation d’ingénieur en systèmes embarqués s’inscrit dans mon objectif de devenir ingénieur capable de concevoir, développer, intégrer et valider des systèmes électroniques et logiciels embarqués. Elle relie les sciences de l’ingénieur, l’électronique, le logiciel embarqué, le temps réel, les capteurs, les réseaux de terrain, la sécurité et l’expérience en entreprise.', '{}', NULL, 'La formation d’ingénieur en systèmes embarqués à ESIEE Paris combine des enseignements scientifiques, électroniques, informatiques et professionnels. Le programme associe cours, travaux dirigés, travaux pratiques, projets multidisciplinaires et missions en entreprise. Il permet de développer des compétences en électronique embarquée, microcontrôleurs, logiciel embarqué, temps réel, capteurs, systèmes physiques, réseaux de terrain, sécurité, validation, innovation et management de projet.', 'Ingénierie embarquée, transitions, R&D : 22,5%
Informatique & logiciels embarqués : 20,2%
Sciences humaines, anglais & management : 20,2%
Électronique, capteurs & systèmes physiques : 19,1%
Sciences de l’ingénieur, mathématiques et physique : 10,1%
Projet fil rouge : 7,9%');
INSERT INTO public.educations VALUES (4, 'Baccalauréat général — Mathématiques & Sciences de l’Ingénieur', 2, 'Baccalauréat général — Mention Bien', 'Sciences, mathématiques et sciences de l’ingénieur', 'Formation générale à dominante scientifique, avec les spécialités Mathématiques et Sciences de l’Ingénieur en terminale, ainsi que Physique-Chimie suivie en première. Ce parcours m’a permis d’acquérir de solides bases en raisonnement scientifique, modélisation, analyse de systèmes, mathématiques appliquées et démarche d’ingénierie. L’obtention du baccalauréat avec mention Bien valorise la rigueur et le sérieux développés durant cette formation.', '2018-08-31', '2021-06-11', 'done', '2026-05-12 21:14:31.47555', '2026-05-12 21:21:49.77121', 4, NULL, '{}', NULL, NULL, NULL);


--
-- Data for Name: etude; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.etude VALUES (6, 'Parcours initial', 'Entrée de départ pour les tests et le développement local.', 'Local', '2024-01-01', '2024-12-31', NULL, 'Terminé', NULL, NULL);


--
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.jobs VALUES (4, 'Apprenti Ingénieur en Logiciel Embarqué', 4, 'apprenticeship', 'Corbas, France', 'no', '2025-12-01', '2028-08-01', 'in_progress', 'Alternance au sein du département Recherche & Développement de Vignal Group, dans l’équipe électronique. La mission porte sur le développement et l’évaluation d’une carte Buck intégrant un microcontrôleur STM32C011, afin d’étudier la pertinence de microcontrôleurs STMicroelectronics pour de futures applications électroniques du groupe. Cette expérience combine électronique de puissance, développement embarqué, prototypage, tests laboratoire et modélisation de commande.', '{"Intégration au département R&D électronique de Vignal Group.","Étude du fonctionnement d’un convertisseur Buck synchronisé avec MOSFETs","gate driver et PWM complémentaires.","Prise en main d’une carte Buck intégrant un microcontrôleur STM32C011.","Évaluation des capacités du microcontrôleur STM32C011 pour des applications électroniques embarquées.","Configuration du microcontrôleur avec STM32CubeMX : timers",PWM,ADC,DMA,"GPIO et fonctions de surveillance.","Génération de PWM complémentaires avec insertion de dead-time pour la commande de puissance.","Mise en place d’acquisitions analogiques via ADC et DMA.","Implémentation du principe de surveillance des mesures avec watchdogs ADC / analog watchdog.",Compilation,"programmation et débogage du firmware avec IAR Embedded Workbench et sonde SEGGER J-Link.","Validation des premières briques logicielles sur carte d’évaluation avant passage sur la carte Buck finale.","Participation au prototypage électronique : dépôt de pâte à braser","placement de composants et refusion au four.","Réalisation de tests et mesures en laboratoire avec alimentations","oscilloscopes et multimètres.","Début de modélisation du convertisseur Buck sous MATLAB/Simulink pour préparer une commande PI/PID de régulation de tension."}', '{STM32C011,STM32CubeMX,"STM32 HAL","IAR Embedded Workbench","SEGGER J-Link",J-Flash,"C embarqué","PWM complémentaires",Dead-time,ADC,DMA,"Analog watchdog",Timers,GPIO,"Convertisseur Buck","Électronique de puissance",MOSFET,"Gate driver",PID,PI,MATLAB,Simulink,Oscilloscope,"Alimentation de laboratoire",Multimètre,"Prototypage électronique","Four de refusion","Soudure CMS","Tests laboratoire"}', '{}', '2026-05-12 21:53:57.173863', '2026-05-12 21:53:57.173863', NULL, '{}', '{}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{}', NULL, '{}', NULL, NULL, NULL, NULL, NULL, NULL, '{}', '{}', '{}', '{}', NULL, '{}', '{}', '{}', '{}', '{}', '{}', '{}');
INSERT INTO public.jobs VALUES (2, 'Apprenti Développeur Systèmes Embarqués', 3, 'apprenticeship', 'Vélizy-Villacoublay, France', 'no', '2023-08-01', '2025-08-31', 'done', 'Alternance de deux ans chez LGM Ingénierie dans un environnement automobile, centrée sur la validation logicielle embarquée, les tests unitaires en C, les tests sur cible et la validation de calculateurs automobiles. Cette expérience m’a permis de travailler sur OCEAN, une pile de protocoles embarqués utilisée pour la communication entre calculateurs, puis d’élargir mon périmètre vers les tests physiques CAN/LIN, l’analyse d’incidents, la traçabilité et l’automatisation de rapports avec Python/Django.', '{"Validation logicielle embarquée sur OCEAN.","Développement et exécution de tests unitaires en C avec IBM Rational Test RealTime.","Analyse de diagrammes fonctionnels, conditions logiques, boucles et scénarios de test.","Validation de calculateurs automobiles et tests physiques CAN/LIN.","Tests sur cible, analyse des résultats et qualification logicielle embarquée.","Analyse d’incidents, rédaction de rapports de validation et rapports qualité.","Automatisation de rapports et de la traçabilité avec Python/Django."}', '{C,Python,Django,SQL,"Logiciel embarqué","Systèmes embarqués",OCEAN,"Piles de protocoles","Tests unitaires","Tests sur cible","IBM Rational Test RealTime",RTRT,MC/DC,"Cycle en V",Stubs,"Test harness","Test suites","Test cases",ECU,"Calculateurs automobiles",CAN,"CAN FD",LIN,LVDS,J1939,UDS,OBD,"Diagnostic automobile","Protocoles embarqués",CANoe,Oscilloscope,Multimètre,"Bancs de test","Validation fonctionnelle","Tests physiques","Analyse de trames",Traçabilité,"Documentation technique","Amélioration continue"}', '{}', '2026-05-12 21:47:38.873845', '2026-05-14 22:39:34.11338', 'Alternance en environnement automobile, sur le logiciel embarqué, les protocoles de communication et la validation de calculateurs. Le produit central : OCEAN, une pile de protocoles embarquée et configurable qui permet aux calculateurs (ECU) de communiquer sur différents réseaux.', '{"Mise en œuvre de tests avec stubs, test harness, test suites et génération de rapports.","Utilisation de CANoe et d’instruments de mesure pour analyser des communications et comportements calculateurs.","Contribution à l’automatisation de rapports et au suivi des campagnes de validation.","Amélioration de procédures de test, de documentation et de traçabilité."}', '{"Travail dans le cycle en V avec vérification des fonctions par rapport aux spécifications et diagrammes.","Analyse des chemins d’exécution, conditions simples ou combinées, boucles et scénarios de test.","Recherche de couverture MC/DC pour les fonctions critiques.","Tests reproductibles, documentés et exploitables par les équipes de développement, validation, qualité et méthodes.","Remontée structurée des anomalies et écarts de documentation.","Amélioration continue des procédures de test, de reporting et de traçabilité."}', 'Une progression de la découverte d''OCEAN et des tests unitaires vers la validation de calculateurs, les tests sur cible, l''analyse d''incidents et l''automatisation — dans un cadre industriel automobile où qualité, traçabilité et rigueur documentaire sont essentielles.', 'Validation logicielle embarquée, tests de calculateurs automobiles, tests unitaires en C et automatisation de la traçabilité.', 'ENPS — Embedded Networks Products & Services', 'Groupe LGM', 'Apprenti Développeur / Ingénieur Systèmes Embarqués', 'août 2023 — août 2025', NULL, NULL, '{"Erreurs liées à la gestion mémoire|Problème : certaines erreurs apparaissaient lorsque des pointeurs ou structures n’étaient pas correctement initialisés dans les cas de test.|Cause : certains paramètres de fonctions étaient des pointeurs initialisés à NULL ou sans zone mémoire valide.|Solution : création de variables locales adaptées, puis initialisation des pointeurs avec l’adresse de ces variables dans les blocs de test.|Compétences : C, pointeurs, gestion mémoire, débogage, tests unitaires, analyse d’erreurs.","Incohérences entre diagrammes et code|Problème : certains diagrammes fonctionnels ne correspondaient plus au comportement réel du code.|Cause : le code avait parfois évolué sans mise à jour du diagramme associé.|Solution : création d’un ticket sur l’outil de suivi interne basé sur Redmine, explication de l’écart, modification du diagramme dans Neness, puis envoi des corrections sur GitLab avec Fork.|Compétences : analyse d’anomalies, Redmine, Neness, GitLab, Fork, documentation technique, communication technique, vérification fonctionnelle."}', 'Cette expérience m’a fait passer d’une approche principalement logicielle et unitaire à une vision plus complète de la validation automobile, intégrant logiciel embarqué, cible matérielle, communication réseau, qualité, traçabilité et outillage interne.', '{C,Python,Django,SQL,"Logiciel embarqué","Systèmes embarqués","Validation logicielle","Vérification logicielle","Tests unitaires","Tests sur cible","IBM Rational Test RealTime",RTRT,MC/DC,"Cycle en V",OCEAN,"Piles de protocoles",ECU,"Calculateurs automobiles",CAN,"CAN FD",LIN,"Diagnostic automobile",CANoe,Oscilloscope,Multimètre,"Bancs de test",Stubs,"Test harness","Analyse de diagrammes",Redmine,Neness,GitLab,Fork,"Analyse d’incidents","Rapports de validation",Traçabilité,"Documentation technique","Amélioration continue","Collaboration transverse"}', 'Rapport professionnel — Première année d’apprentissage LGM Ingénierie', NULL, 'Rapport détaillant le contexte de LGM Ingénierie, la Business Line ENPS, le produit OCEAN, la découverte du laboratoire de validation, la méthodologie de tests unitaires avec IBM Rational Test RealTime, les difficultés rencontrées et les résultats de la première année d’alternance.', 'LGM Ingénierie (groupe LGM) conçoit de l''électronique et du logiciel embarqués : bancs de test, intégration, validation, qualification — pour l''aéronautique, la défense, l''énergie, les transports et l''automobile. J''étais dans la Business Line ENPS (Embedded Networks Products & Services), sur les réseaux embarqués et la validation de calculateurs.', 'OCEAN permet la communication entre calculateurs automobiles via plusieurs protocoles (CAN, CAN FD, LIN, LVDS, J1939). Il gère la transmission, la réception, le diagnostic et les échanges réseau, à travers des drivers, des couches de transport, des services de diagnostic et une couche d''abstraction de l''OS. Mon travail visait la conformité entre spécifications, diagrammes et comportement réel du code.', 'Montée en compétence sur OCEAN, le cycle en V et la validation logicielle. J''ai réalisé plus de 200 tests unitaires sur les fonctions d''OCEAN avec IBM Rational Test RealTime, en vérifiant la conformité aux diagrammes fonctionnels et aux spécifications — certains modules simples, d''autres demandant plusieurs jours d''analyse (complexité, dépendances, incohérences diagrammes/code).', '{"Découvrir le laboratoire de validation, les calculateurs automobiles et les couches basses.","Comprendre le rôle des ECU et la communication entre calculateurs.","Analyser des diagrammes fonctionnels et identifier les chemins d’exécution.","Créer des cas de test unitaires avec IBM Rational Test RealTime.","Mettre en place les stubs, test harness, test suites et ressources de test.","Analyser les résultats et générer des rapports exploitables.","Remonter les incohérences entre diagrammes et code via l’outil interne basé sur Redmine."}', '{"Mise en place d’environnements de test structurés avec Test_Resources, External_Includes, Report, Stubs, Test_Cases, Test_Harness, Test_Suites, Unit_Under_Test et Unit_Dependencies.","Application d’une méthodologie de couverture MC/DC pour vérifier l’influence indépendante des conditions logiques.","Création de variables locales et initialisation correcte de pointeurs pour résoudre des erreurs de gestion mémoire dans les tests.","Identification et documentation d’écarts entre diagrammes fonctionnels et comportement réel du code."}', '{C,"IBM Rational Test RealTime",RTRT,GitLab,Fork,Redmine,Neness,"Pack Office"}', '{"Tests unitaires","Couverture MC/DC","Test cases","Test suites","Test harness",Stubs,C,Pointeurs,"Gestion mémoire","Analyse de diagrammes","Vérification logicielle","Validation logicielle","Cycle en V","Rigueur méthodologique"}', 'Élargissement vers une approche système : validation de calculateurs et tests sur cible en C, analyse des communications CAN/LIN avec CANoe, oscilloscope, multimètre et bancs de test. J''ai aussi contribué à l''analyse d''incidents, aux rapports qualité, à l''amélioration des procédures et au développement d''outils Python/Django pour automatiser les rapports et la traçabilité.', '{"Participer à la validation de calculateurs automobiles.","Réaliser des tests physiques sur bus CAN et LIN.","Observer et analyser les communications avec CANoe.","Utiliser oscilloscopes, multimètres et bancs de test.","Développer et exécuter des tests unitaires et des tests sur cible en C.","Analyser les écarts et incidents détectés pendant les campagnes de test.","Automatiser des rapports de validation et améliorer la traçabilité avec Python/Django.","Contribuer à la documentation, aux procédures de test et à l’amélioration continue."}', '{"Participation à la validation de calculateurs automobiles selon les spécifications.","Analyse de communications CAN/LIN et de trames avec CANoe.","Exécution de tests sur cible et génération de rapports de validation.","Contribution à des rapports qualité et à l’analyse d’incidents.","Développement d’outils internes Python/Django pour réduire les tâches répétitives et améliorer le reporting technique.","Amélioration de la lisibilité des résultats et de la traçabilité des essais."}', '{C,Python,Django,SQL,"IBM Rational Test RealTime",CANoe,Oscilloscope,Multimètre,"Bancs de test",GitLab,Fork,Redmine}', '{"Validation de calculateurs","Tests sur cible","Tests physiques",CAN,LIN,"Analyse de trames","Diagnostic automobile","Qualification logicielle",Automatisation,Reporting,Traçabilité,"Documentation technique","Rapports qualité","Amélioration continue","Collaboration transverse"}', '{C,Python,Django,SQL,"IBM Rational Test RealTime",RTRT,CANoe,Oscilloscope,Multimètre,"Bancs de test",GitLab,Fork,Redmine,Neness,Git,"Pack Office"}', '{"Réalisation de plus de 200 tests unitaires sur différents modules d’OCEAN.","Montée en compétence sur IBM Rational Test RealTime.","Compréhension des protocoles CAN/LIN et du fonctionnement des calculateurs automobiles.","Participation à la validation de calculateurs.","Utilisation de CANoe et d’instruments de mesure.","Contribution à des rapports de validation et qualité.","Automatisation de rapports avec Python/Django.","Amélioration de la traçabilité et des procédures de test."}', '{"Compréhension du cycle en V.","Rigueur dans la validation logicielle.","Montée en compétence en logiciel embarqué automobile.","Progression en analyse de code C.","Meilleure capacité à diagnostiquer des anomalies.","Amélioration de la communication technique.","Capacité à travailler avec des équipes R&D, qualité, méthodes et validation."}');
INSERT INTO public.jobs VALUES (3, 'Stagiaire Systèmes Embarqués & Électronique', 2, 'internship', 'Paris, France', 'no', '2023-04-17', '2023-06-23', 'done', 'Stage en électronique et systèmes embarqués au laboratoire MPQ — Université Paris Cité — CNRS, orienté instrumentation scientifique. Le projet portait sur la conception et le prototypage d’un système de mesure et de transmission radiofréquence de températures pour des salles d’expériences, avec cartes maître/esclave, capteurs, microcontrôleurs, routage PCB, firmware embarqué et validation expérimentale.', '{"Étudier les schémas électroniques existants et la documentation technique des composants.","Analyser l’architecture maître/esclave du système de mesure.","Concevoir et router des circuits imprimés sous Ultiboard à partir de schémas Multisim.","Préparer les fichiers de fabrication Gerber et Drill.","Assembler et souder des composants traversants et CMS.","Développer et valider les fonctions firmware sur Arduino Pro Mini / ATmega328P.","Programmer les capteurs DHT22, thermistance et PT100.","Configurer l’AD7709 et le module RF SI4432 via SPI.","Mettre en œuvre un contrôle CRC pour fiabiliser les échanges.","Migrer progressivement les fonctions vers le microcontrôleur PIC18F26J11.","Réaliser des tests fonctionnels avec multimètre, oscilloscope, alimentation de laboratoire et bancs de test.","Documenter les choix techniques, les essais, les problèmes rencontrés et les solutions."}', '{C,C++,Arduino,"Programmation embarquée","Programmation bas niveau",Registres,Interruptions,Timers,ATmega328P,"Arduino Pro Mini",PIC18F26J11,"MPLAB IDE",Microcontrôleurs,Multisim,Ultiboard,ViewMate,PCB,"Routage PCB","Conception électronique",Gerber,Drill,DRC,"Plans de masse",CMS,Soudure,Câblage,PT100,"Thermistance CTN","DHT22 / AM2302",AD7709,"ADC / CAN","Acquisition analogique","Acquisition numérique",Calibration,"Mesure de température","Humidité relative",SPI,RF,SI4432,RadioHead,CRC,GFSK,"Transmission radiofréquence",Oscilloscope,Multimètre,"Alimentation de laboratoire","Bancs de test","Validation fonctionnelle",Diagnostic,"Documentation technique"}', '{}', '2026-05-12 21:49:09.114278', '2026-05-14 22:53:28.649534', 'Régulation en température de salles d''expériences au laboratoire : les fluctuations thermiques perturbent les dispositifs optiques sensibles (alignements de faisceaux laser, cavités optiques). Objectif : mesurer la température en plusieurs points d''une salle, transmettre les mesures sans fil vers une unité maître, et préparer une future régulation par vannes/électrovannes.', '{"Étude des schémas électroniques sous Multisim, analyse des composants et compréhension de l’architecture maître/esclave.","Routage PCB sous Ultiboard avec placement des composants, modification manuelle des pistes, plans de masse, vérification DRC, export Gerber/Drill et contrôle ViewMate.","Assemblage et câblage de prototypes avec soudure de composants traversants et CMS, vérification des alimentations et correction de défauts de soudure.","Validation firmware sur Arduino Pro Mini : DHT22, thermistance via CAN interne, PT100 via AD7709, SPI, calcul de température, RF SI4432 avec RadioHead et CRC.","Préparation de la migration vers PIC18F26J11 : MPLAB IDE, registres, broches, timers, interruptions, SPI et adaptation des fonctions capteurs/RF.","Tests et débogage : reset Arduino/PIC, stabilité RF, alimentation, courant, capacité des pistes et observation de signaux SPI à l’oscilloscope."}', '{"Lecture de datasheets et analyse de schémas électroniques.","Prototypage progressif avec validation fonction par fonction.","Tests de continuité, mesures électriques et diagnostic matériel.","Documentation des essais, problèmes rencontrés et solutions.","Validation expérimentale sur cartes câblées."}', 'Un projet d''instrumentation scientifique complet, du besoin au prototype validé : architecture maître/esclave, routage et préparation de cartes, assemblage de prototypes, acquisition multi-capteurs, communication RF entre cartes, migration vers PIC18F26J11 et rédaction d''un rapport technique complet.', 'Régulation en température de salles d’expériences — instrumentation scientifique, électronique embarquée et communication radiofréquence.', 'Laboratoire MPQ — Matériaux et Phénomènes Quantiques', 'Université Paris Cité — CNRS', 'Assistant Ingénieur', '17/04/2023 au 23/06/2023', 'Concevoir et valider un prototype électronique mesurant la température avec plusieurs types de capteurs, puis transmettant les données de façon fiable par radiofréquence vers une carte maître. Contraintes : acquisition analogique et numérique, communication RF, routage de cartes maître/esclave, assemblage traversant + CMS, migration Arduino → PIC18F26J11, et diagnostic de pannes matérielles et logicielles.', 'Architecture maître/esclave. Les cartes esclaves mesurent la température en plusieurs points (thermistance CTN 10 kΩ, PT100, DHT22/AM2302) via le CAN interne 10 bits, un AD7709 16 bits, une liaison numérique pour le DHT22 et le SPI (AD7709 + module RF SI4432). Les mesures sont transmises par radiofréquence à une carte maître, qui prépare le traitement côté PC et sert de base à une future régulation thermique par actionneurs.', '{"Problème de téléversement Arduino|Problème : impossible de téléverser le programme vers l’Arduino Pro Mini.|Cause identifiée : la broche reset était maintenue à 0 V à cause d’un mauvais câblage du bouton poussoir.|Solution : vérification des tensions, analyse de la broche reset, correction du bouton poussoir et validation du téléversement.|Compétences : diagnostic électronique, datasheet, multimètre, débogage matériel.","Instabilité du module RF|Problème : la transmission radiofréquence fonctionnait par intermittence.|Cause suspectée : problème matériel ou alimentation du module RF.|Solution : mesure de la tension, passage sur alimentation de laboratoire, observation de la consommation, vérification de la capacité des pistes et ajout de câbles de plus grande section.|Compétences : radiofréquence, alimentation, mesure de courant, validation PCB.","Réinitialisation du PIC18F26J11|Problème : les programmes téléversés sur le PIC18F26J11 ne s’exécutaient pas.|Cause identifiée : la broche MCLR était maintenue à 0 V, gardant le microcontrôleur en reset permanent.|Solution : modification du câblage du bouton reset, ajout d’une résistance de tirage et validation du fonctionnement.|Compétences : PIC18F26J11, MCLR, reset, schéma électronique, debug firmware/hardware.","Soudure de composants CMS|Problème : difficultés de soudure CMS avec pastilles décollées, composants fragiles et soudures insuffisantes.|Solution : progression au câblage CMS avec lunettes binoculaires, lampe loupe, brucelles et station de soudage, puis réalisation d’une seconde carte fonctionnelle.|Compétences : soudure CMS, prototypage, assemblage électronique, rigueur expérimentale."}', 'Ma première expérience professionnelle significative en électronique et systèmes embarqués : instrumentation scientifique, prototypage électronique, rigueur de test, mesure et documentation. Elle a confirmé mon intérêt pour les systèmes embarqués et la validation de systèmes techniques.', '{"Systèmes embarqués",Électronique,"Conception PCB","Routage PCB",C,C++,Arduino,PIC18F26J11,"MPLAB IDE",Microcontrôleurs,SPI,Radiofréquence,SI4432,Capteurs,PT100,Thermistance,DHT22,AD7709,"Acquisition de données","ADC / CAN",CRC,"Soudure CMS",Câblage,Oscilloscope,Multimètre,"Validation fonctionnelle","Diagnostic électronique","Documentation technique","Instrumentation scientifique"}', NULL, NULL, 'Rapport détaillant le contexte du stage, l’architecture du système, la conception des cartes électroniques, le développement firmware, les capteurs utilisés, la communication radiofréquence, les phases de débogage et les résultats obtenus.', NULL, NULL, NULL, '{}', '{}', '{}', '{}', NULL, '{}', '{}', '{}', '{}', '{}', '{}', '{}');


--
-- Data for Name: media_assets; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.media_assets VALUES (3, 'cloudinary', 'portfolio/private/schools/fedsfbpendhojnqnc1tw', 'image', 'authenticated', 'png', 1778610680, 'Durzy_logo.png', 84954, 800, 375, 'schools', NULL, '2026-05-12 20:31:21.541724', '2026-05-12 20:31:38.3151', 'logo_durzy', NULL, NULL, NULL);
INSERT INTO public.media_assets VALUES (7, 'cloudinary', 'portfolio/private/schools/icdrfgrpjdjs6ad3r3h5', 'image', 'authenticated', 'avif', 1778610755, 'UTC_logo.png.avif', 22830, 568, 284, 'schools', NULL, '2026-05-12 20:32:36.848067', '2026-05-12 20:32:36.848067', 'logo_utc', NULL, NULL, NULL);
INSERT INTO public.media_assets VALUES (8, 'cloudinary', 'portfolio/private/schools/qojnfffiwqmivbcpofq0', 'image', 'authenticated', 'jpg', 1778610782, 'ESIEE_Paris_logo.jpg', 205923, 2048, 1366, 'schools', NULL, '2026-05-12 20:33:03.636847', '2026-05-12 20:33:03.636847', 'logo_esiee', NULL, NULL, NULL);
INSERT INTO public.media_assets VALUES (9, 'cloudinary', 'portfolio/private/projects/ktss8csa7symci9jv4qo', 'image', 'authenticated', 'png', 1778610801, 'IUT_Cachan_logo.png', 15547, 512, 114, 'projects', NULL, '2026-05-12 20:33:21.699793', '2026-05-12 20:33:21.699793', 'logo_cachan', NULL, NULL, NULL);
INSERT INTO public.media_assets VALUES (10, 'cloudinary', 'portfolio/private/companies/iuzwjhzfkznzfchsjcmt', 'image', 'authenticated', 'png', 1778614394, 'CNRS_logo.png', 158714, 900, 700, 'companies', NULL, '2026-05-12 21:33:15.931697', '2026-05-12 21:33:15.931697', 'CNRS_logo', NULL, NULL, NULL);
INSERT INTO public.media_assets VALUES (11, 'cloudinary', 'portfolio/private/companies/csrbesnlgh9mpzkgvdyw', 'image', 'authenticated', 'png', 1778614410, 'LGM_logo.png', 3784, 340, 142, 'companies', NULL, '2026-05-12 21:33:31.369244', '2026-05-12 21:33:31.369244', 'lcm_logo', NULL, NULL, NULL);
INSERT INTO public.media_assets VALUES (12, 'cloudinary', 'portfolio/private/companies/jwtyqj1fd8knk5irlwld', 'image', 'authenticated', 'png', 1778614428, 'Vignal_logo.jpg', 21815, 552, 149, 'companies', NULL, '2026-05-12 21:33:49.906833', '2026-05-12 21:33:49.906833', 'Vignal_logo', NULL, NULL, NULL);
INSERT INTO public.media_assets VALUES (13, 'cloudinary', 'portfolio/private/projects/p28iywiwx45iwvrfppnd', 'image', 'authenticated', 'png', 1778616123, 'came.png', 191551, 500, 500, 'projects', NULL, '2026-05-12 22:02:04.545373', '2026-05-12 22:02:04.545373', 'logo_portfolio', NULL, NULL, NULL);
INSERT INTO public.media_assets VALUES (15, 'cloudinary', 'portfolio/private/profile/hp7v57d9atzloiukmmaw', 'image', 'authenticated', 'jpg', 1778882428, 'IMG_3249.JPG', 496119, 1200, 1800, 'profile', NULL, '2026-05-16 00:00:28.723813', '2026-05-16 00:00:28.723813', 'Photo de profil accueil', NULL, NULL, NULL);


--
-- Data for Name: project_section_media; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: project_sections; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.project_sections VALUES (3, 3, 'Ma contribution : carte moteur simple', NULL, 'Ma partie principale du projet consistait à concevoir la carte moteur simple. Cette carte avait pour rôle de piloter les moteurs du robot à partir des informations fournies par les cartes capteurs et du programme embarqué. Elle devait permettre d’actionner les moteurs de manière fiable afin que le robot puisse avancer, tourner, corriger sa trajectoire et suivre la ligne.', 'step', 'media_right', 3, false, '2026-05-16 13:46:13.857252', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (1, 3, 'Contexte et cahier des charges', NULL, 'Chaque année à l’IUT de Cachan, le Gamel Trophy permet aux étudiants de concevoir un robot autonome appelé “gamelle”. L’objectif est de créer un robot rapide, fiable et conforme au cahier des charges, capable de suivre une piste, contourner les plots, détecter les raccourcis et franchir l’arrivée correctement.

Le robot devait :
- être construit avec des composants imposés ;
- démarrer lorsque le jack est retiré ;
- suivre la piste de manière autonome ;
- contourner les plots ;
- éviter les collisions ;
- détecter les raccourcis ;
- faire tomber la première barre d’arrivée sans toucher la seconde.', 'step', 'media_right', 1, false, '2026-05-16 13:46:13.857252', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (2, 3, 'Organisation du projet en équipe', NULL, 'Le projet a été réalisé en équipe de quatre étudiants. Pour optimiser le temps de développement, les tâches ont été réparties entre les membres du groupe autour des cartes capteurs et moteurs.

Répartition :
- carte capteur parallèle ;
- carte capteur série ;
- carte moteur simple ;
- carte moteur amplifiée.

Ma contribution principale : conception et réalisation de la carte moteur simple.', 'step', 'media_left', 2, false, '2026-05-16 13:46:13.857252', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (4, 3, 'Conception électronique', NULL, 'La conception a commencé par un schéma réalisé sur papier, puis validé avant d’être reproduit sous KiCad. Les composants nécessaires ont été intégrés dans le schéma : résistances, diodes, alimentation, connecteurs et éléments nécessaires au pilotage des moteurs.

Après la schématisation, le PCB a été conçu sous KiCad. Cette phase a demandé de placer correctement les composants, d’éviter les croisements de pistes, de respecter les règles de routage et d’obtenir une carte propre, lisible et fabricable.', 'architecture', 'media_left', 4, false, '2026-05-16 13:46:13.857252', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (5, 3, 'Fabrication et assemblage de la carte', NULL, 'Après validation du PCB, la carte a été fabriquée puis préparée manuellement. Les étapes comprenaient le perçage, l’insertion des composants, la soudure et les premières vérifications électriques.

Cette étape m’a permis de découvrir les contraintes concrètes de fabrication d’une carte électronique, notamment la précision nécessaire au perçage, l’importance du sens des composants et la qualité de la soudure.', 'step', 'media_right', 5, false, '2026-05-16 13:46:13.857252', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (6, 3, 'Tests et validation électronique', NULL, 'Plusieurs tests ont été réalisés avant d’intégrer la carte dans le robot :
- test de continuité ;
- test d’isolation ;
- test statique ;
- test fonctionnel.

Le test de continuité permettait de vérifier que les connexions prévues étaient bien présentes. Le test d’isolation permettait de vérifier l’absence de courts-circuits. Le test statique consistait à alimenter la carte en 12 V et à vérifier les tensions attendues au voltmètre. Enfin, le test fonctionnel permettait de vérifier que la carte pouvait effectivement commander les moteurs.', 'challenge', 'media_left', 6, false, '2026-05-16 13:46:13.857252', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (7, 3, 'Programmation du robot', NULL, 'La programmation du robot a été réalisée en C++. Plusieurs fonctions ont été développées pour gérer le comportement du robot :
- lecture de la valeur du potentiomètre pour ajuster la vitesse ;
- marche et arrêt avec automate à trois états ;
- lecture des capteurs de ligne ;
- commande des moteurs gauche et droit ;
- correction de trajectoire ;
- suivi de ligne avec automate à cinq états ;
- détection de raccourcis avec automate à huit états.

La logique de suivi de ligne reposait sur l’état des capteurs. Les moteurs étaient ajustés selon la position du robot par rapport à la bande blanche, afin de corriger la trajectoire en temps réel.', 'code', 'media_right', 7, false, '2026-05-16 13:46:13.857252', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (8, 3, 'Stratégie de suivi de ligne et raccourcis', NULL, 'Le robot devait suivre la ligne tout en limitant les oscillations. Pour cela, un automate d’états a été utilisé afin d’adapter la trajectoire selon les valeurs détectées par les capteurs.

La détection des raccourcis était une partie stratégique du projet. L’objectif était de distinguer un vrai raccourci d’un simple croisement, notamment en vérifiant l’absence de piste sur la droite du robot. Cette logique devait permettre au robot de gagner du temps sans quitter le circuit.', 'architecture', 'media_left', 8, false, '2026-05-16 13:46:13.857252', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (9, 3, 'Résultats', NULL, 'Le robot a réussi à suivre la piste et à participer au Gamel Trophy. Il s’est qualifié pour les phases finales avec un chrono de 46 secondes. L’équipe a ensuite été éliminée au premier tour de la phase finale face à un robot plus performant.

Résultat :
- robot fonctionnel ;
- qualification en phase finale ;
- chrono : 46 s ;
- validation de la carte moteur ;
- expérience complète de conception, réalisation, test et compétition.', 'result', 'media_right', 9, false, '2026-05-16 13:46:13.857252', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (10, 3, 'Bilan personnel', NULL, 'Ce projet m’a permis de découvrir toutes les étapes d’un projet électronique et robotique : analyse du cahier des charges, conception de carte, routage PCB, fabrication, soudure, tests, programmation et intégration. Il m’a aussi permis de développer ma rigueur, mon autonomie, ma capacité à résoudre des problèmes techniques et mon travail en équipe.

Ce projet a été une première expérience marquante dans la conception d’un système embarqué complet, associant électronique, logiciel et mécanique.', 'result', 'media_bottom', 10, false, '2026-05-16 13:46:13.857252', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (11, 4, 'Un monorepo, trois applications', 'Mobile, backend et back-office', 'Le dépôt MakasiFit regroupe trois applications que je développe ensemble :
- L''app mobile Flutter/Dart (package "joyfit") : riverpod pour l''état, dio pour l''API, go_router pour la navigation, fl_chart pour les graphiques de progression et flutter_body_atlas pour l''atlas musculaire.
- Le backend FastAPI (environ 338 fichiers Python) découpé en une trentaine de modules métier, avec SQLAlchemy 2 asynchrone, Alembic (63 migrations) et PostgreSQL/pgvector.
- Le back-office web React 18 + Vite + MUI, dédié à l''administration, à la modération et aux statistiques, qui pointe sur l''API.
Cette organisation me permet de garder une cohérence forte entre les contrats d''API, le mobile et l''outillage d''admin.', 'architecture', 'text_only', 1, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (12, 4, 'Écosystème JoyTrain', 'Trois dépôts liés', 'JoyTrain fait partie d''un ensemble de trois projets que je conçois comme un produit unique :
- L''application JoyTrain (ce dépôt MakasiFit) : l''app mobile Flutter et son backend FastAPI, qui portent toute l''expérience utilisateur.
- Bora : le moteur RAG/IA, hébergé dans le dépôt séparé RAG_JoyTrain (joytrain_rag_collector). C''est lui qui alimente le coach conversationnel ; le backend l''appelle en HTTP/SSE depuis le worker pour répondre aux questions de l''utilisateur.
- Le site vitrine, dans le dépôt joytrain-website, qui présente le produit publiquement.
Dans le docker-compose de production, le service RAG est d''ailleurs construit directement depuis le dépôt RAG_JoyTrain et tourne aux côtés du backend, ce qui matérialise le lien technique entre les trois projets.', 'text', 'text_only', 2, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (13, 4, 'Bora, le coach IA data-aware', 'RAG, worker asynchrone et streaming', 'Bora est le coach IA de JoyTrain. Pour ne jamais bloquer l''API pendant les appels longs, je l''exécute dans un worker arq (file de jobs Redis), séparé du process web.
- Le worker interroge le moteur RAG externe et tente d''abord un streaming SSE ; si l''endpoint de streaming n''existe pas, il bascule sur un pseudo-streaming de repli.
- Les tokens générés sont poussés vers le mobile en temps réel via WebSocket, relayés sur un canal Redis pub/sub pour fonctionner en multi-instance.
- Bora s''appuie sur le contexte personnel de l''utilisateur pour les questions personnelles, et sert aussi à générer des programmes d''entraînement.
- Un système de quotas et d''entitlements encadre l''usage (limites gratuites vs premium) avec remboursement du quota en cas d''échec.', 'step', 'text_only', 3, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (14, 4, 'Scan de repas et nutrition Ciqual', 'Vision multimodale et recherche vectorielle', 'Le scan de repas combine plusieurs briques :
- Un modèle de vision analyse la photo (Gemini 2.5 Flash par défaut, avec replis Mistral et Ollama qwen2.5vl), avec garde-fous sur le type et la taille d''image.
- Les libellés détectés sont vectorisés par des embeddings bge-m3 calculés en local via Ollama, puis appariés aux ingrédients par recherche vectorielle pgvector — sans envoyer de données à un service externe pour cette étape.
- Le catalogue d''ingrédients et les valeurs nutritionnelles proviennent en grande partie de la base alimentaire française Ciqual 2020, importée via des scripts dédiés, avec préservation des codes et constituants bruts pour la traçabilité.
L''utilisateur obtient ainsi une estimation des macros à partir d''une simple photo.', 'step', 'text_only', 4, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (15, 4, 'Offline-first et idempotence', 'Robustesse réseau côté mobile et serveur', 'L''app est pensée pour fonctionner sans réseau, ce qui m''a demandé un travail particulier sur la fiabilité des écritures :
- Côté Flutter, une file d''écriture durable (Outbox, stockée en drift/SQLite) enregistre chaque mutation faite hors-ligne ; un moteur de synchronisation la draine au retour réseau, avec gestion de dépendances entre opérations et id temporaires locaux.
- Côté FastAPI, chaque opération porte une clé d''idempotence (UUID) stable. Une route personnalisée (IdempotentRoute) mémorise (user, clé) → réponse sérialisée : tout rejeu renvoie la réponse à l''identique sans ré-exécuter le handler, et expose les id des entités imbriquées (ex. les séries d''un workout) pour permettre au client de remapper ses id temporaires.
Résultat : pas de doublon, pas de perte de données, même si une réponse réseau est perdue.', 'challenge', 'text_only', 5, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (16, 4, 'Déploiement auto-hébergé en UE', 'Docker Compose, Caddy et CD GitHub Actions', 'Toute la stack tourne sur une VM OVH en UE, orchestrée par Docker Compose :
- Caddy fait office de reverse-proxy avec HTTPS automatique (Let''s Encrypt) sur api.joytrain.app et admin.joytrain.app ; seuls les ports 80/443 sont exposés, tout le reste communique sur le réseau Docker privé.
- Les services : backend, worker arq, back-office admin, service RAG, Ollama (embeddings bge-m3), deux PostgreSQL pgvector (app et RAG) et Redis.
- Le CD GitHub Actions lance d''abord les tests (Flutter + pytest sur une base Postgres pgvector éphémère), puis, sur la branche principale et uniquement si le backend/deploy a changé, déploie par SSH.
- Le script deploy.sh est idempotent : build des images, migrations Alembic dans un conteneur jetable avant bascule, seeds additifs qui préservent les éditions admin, reload explicite de Caddy et healthcheck actif sur /health.
Le choix UE et la non-fuite de données perso (Sentry sans PII, médias privés signés) traduisent une prise en compte du RGPD.', 'result', 'text_only', 6, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (17, 5, 'Le pipeline de bout en bout', 'De l''URL au vecteur interrogeable', 'Bora est organisé en étapes scriptées et indépendantes, ce qui rend chaque maillon testable et rejouable :
- Validation des sources : validate_sources.py contrôle le fichier sources.json avec Pydantic avant toute collecte.
- Collecte : collect_rag_sources.py télécharge chaque ressource (retries, délai configurable), vérifie optionnellement le robots.txt, déduplique par sha256 et détecte PDF vs HTML.
- Extraction : PyMuPDF pour les PDF, trafilatura (avec repli BeautifulSoup) pour le HTML.
- Chunking : découpage en fenêtres de ~1200 caractères avec 180 de recouvrement, sur des frontières propres.
- Export : export_for_pgvector.py génère un JSONL { source_id, chunk_index, text, metadata }.
- Embeddings + import : embed_and_import_pgvector.py vectorise et insère dans PostgreSQL/pgvector.
- Recherche : search_rag.py (sémantique) et hybrid_search.py (hybride BM25 + vectoriel).', 'step', 'text_only', 1, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (18, 5, 'Embeddings et stockage vectoriel', 'BAAI/bge-m3 local + PostgreSQL/pgvector', 'Le choix s''est porté sur un modèle d''embedding open source, multilingue et exécutable en local, pour ne dépendre d''aucune API payante :
- Modèle : BAAI/bge-m3, 1024 dimensions, chargé via sentence-transformers et normalisé à l''encodage.
- Matériel : une fonction resolve_device choisit automatiquement CUDA, puis MPS (Apple Silicon), sinon CPU.
- Abstraction : une interface EmbeddingProvider permet de basculer vers OpenAI en option (Ollama est réservé mais non implémenté), le provider local restant le défaut.
- Base : table avec une colonne embedding vector(1024), des colonnes typées (source_id, title, url, publisher, topic, category...), un champ metadata JSONB, des index B-tree sur source_id/topic/category et un index GIN sur metadata.
- Robustesse : la dimension est validée à chaque étape pour éviter toute incohérence entre le modèle et le schéma.', 'architecture', 'text_only', 2, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (19, 5, 'Recherche hybride BM25 + vectorielle', 'Reciprocal Rank Fusion pour capter le sens ET les termes exacts', 'La recherche purement sémantique passe parfois à côté de termes rares mais décisifs. La recherche hybride combine deux signaux puis les fusionne :
- Sémantique : pgvector classe les chunks par distance cosinus (opérateur <=>) sur l''embedding de la requête.
- Lexical : un BM25Okapi (rank-bm25) est calculé en mémoire sur les champs title, publisher, topic, category et text.
- Fusion : les deux classements sont combinés par Reciprocal Rank Fusion avec une constante de lissage rrf_k=60.
Ce mélange rattrape les requêtes contenant des termes exacts comme créatine, leucine, 1RM, caféine ou les noms d''organismes, là où le vectoriel seul est moins précis. La sortie est disponible en format lisible ou en JSON directement exploitable par une application.', 'challenge', 'text_only', 3, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (20, 5, 'Collecte data-aware et éthique', 'Licences, robots.txt et zéro contournement', 'Construire une base de connaissances à partir de sources externes impose un cadre légal strict, modélisé dans le code :
- Chaque source porte un access_status et un license_status (open_access, check_before_use, reference_only...).
- Quand la licence l''impose, manual_review_required passe automatiquement à true via un validateur Pydantic.
- can_redistribute reste à false par défaut tant qu''une licence ne l''autorise pas explicitement.
- Le collecteur respecte le robots.txt (urllib.robotparser, option --respect-robots) et marque les URL interdites en skipped_robots_txt.
- Refus des pages à paywall détecté, aucun contournement de paywall, de DRM ni d''authentification, et pas de scraping agressif (délai configurable entre requêtes).
Les sources visées couvrent des références reconnues : OMS, ACSM, NSCA, CDC, OpenStax, NIH, ISSN, IOC.', 'text', 'text_only', 4, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (21, 5, 'Traçabilité, évaluation et reproductibilité', 'Manifest, recall@k et Docker', 'Chaque exécution laisse une trace exploitable et la qualité de récupération est mesurable :
- manifest.json (un item par source avec status, sha256, chemins, nombre de chunks), summary.json (statistiques globales) et errors.json.
- Sur le lot de référence, la collecte a produit 546 chunks à partir des documents collectés avec succès (OMS, ISSN, OpenStax et une source ACSM en revue manuelle), les autres sources étant tracées en erreur.
- evaluate_retrieval.py calcule un recall@k sur un petit jeu de questions fitness étiquetées (catégories, sujets, mots-clés attendus).
- L''import est idempotent : id UUID5 stable, contrainte UNIQUE(source_id, chunk_index), ON CONFLICT et détection d''une table existante de dimension différente.
- PostgreSQL + pgvector tournent via Docker Compose (image pgvector/pgvector:pg16), pour un environnement reproductible.', 'result', 'text_only', 5, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (22, 5, 'Écosystème JoyTrain', 'Trois projets liés autour du coach sportif', 'Bora ne vit pas seul : il est le moteur de connaissance d''un ensemble de trois projets pensés comme complémentaires.
- L''application JoyTrain : l''app mobile (Flutter) et son backend, où l''utilisateur final dialogue avec le coach sportif.
- Bora : ce projet, le moteur RAG / IA qui fournit au coach des réponses ancrées dans des sources fitness, nutrition et santé fiables et citables.
- Le site vitrine JoyTrain : la présence web qui présente le produit.
Dans cet ensemble, Bora joue le rôle de couche de connaissance : conçu comme un service de récupération autonome, alimenté par des sources de référence, il est destiné à être interrogé par le backend du coach pour enrichir ses réponses sans hallucination.', 'text', 'text_only', 6, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (23, 6, 'Une vitrine sans build, par choix', 'Approche statique assumée', 'J''ai délibérément écarté tout framework et toute chaîne d''outils : le site est constitué de fichiers HTML servis tels quels, sans étape de compilation ni dépendance npm à installer.

- Le styling repose sur Tailwind CSS chargé via son CDN officiel (cdn.tailwindcss.com), complété d''un bloc <style> embarqué pour les composants sur-mesure.
- La palette de marque est définie en variables CSS (--brand orange #FF5E3A, --bora violet #9B5DE5, --cyan, --green), réutilisée partout via Tailwind et le CSS custom.
- La typographie Inter vient de Google Fonts, avec preconnect pour accélérer le chargement.
- Le seul JavaScript est inline : aucun bundle, aucun runtime. Résultat : un hébergement statique gratuit, rapide et sans maintenance technique.', 'architecture', 'text_only', 1, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (24, 6, 'Montrer une app pas encore publiée, sans tricher', 'Vraies captures dans un cadre CSS', 'Le défi central était de présenter l''application de façon crédible alors qu''elle n''est pas encore en ligne, en m''interdisant toute maquette inventée.

- Les sept captures utilisées sont de vrais écrans de l''app, normalisés en écran seul (540×1170, sans cadre d''appareil) puis insérés dans un cadre de téléphone entièrement reconstruit en CSS (classe .device).
- Chaque slot d''image a un visuel de repli : un attribut onerror retire l''image manquante pour laisser apparaître un placeholder positionné dessous, ce qui évite toute case vide.
- Les écrans sans capture propre disponible (fil social, analyse d''un repas par photo) sont décrits uniquement par du texte, jamais illustrés par un faux écran.', 'challenge', 'text_only', 2, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (25, 6, 'Des animations sans la moindre librairie', 'Keyframes CSS + IntersectionObserver', 'Le rendu vivant de la page est obtenu sans aucune bibliothèque d''animation.

- Des blobs en arrière-plan flottent en continu via une keyframe CSS (float), et des badges flottants oscillent avec une keyframe bob, le tout décalé dans le temps par animation-delay.
- L''apparition progressive des sections au scroll repose sur un unique IntersectionObserver en JavaScript natif : chaque élément portant la classe .reveal reçoit la classe .in quand il entre dans le viewport, déclenchant une transition d''opacité et de translation, puis cesse d''être observé.
- Le défilement est lissé en CSS (scroll-behavior: smooth) et la mise en page reste entièrement responsive grâce aux grilles et breakpoints de Tailwind.', 'step', 'text_only', 3, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (26, 6, 'Pages légales prêtes pour les stores', 'Confidentialité RGPD, CGU, contact', 'Au-delà du marketing, le site existe surtout pour fournir les pages légales exigées par Apple et Google avant la publication d''une application.

- confidentialite.html : politique de confidentialité conforme au RGPD, qui décrit fidèlement les données réellement collectées par l''app (compte, profil, données de bien-être, entraînement, nutrition, compléments) et les droits associés.
- cgu.html : conditions générales d''utilisation, incluant un avertissement santé et une clause de règles de communauté en « tolérance zéro ».
- contact.html : points de contact dédiés (support, demandes RGPD, modération/signalement, presse & partenariats).
- Ces documents sont des modèles fidèles au comportement réel de l''app mais comportent encore des champs à compléter et doivent être validés juridiquement avant mise en ligne.', 'text', 'text_only', 4, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (27, 6, 'Déploiement Netlify et domaine', 'Statique, HTTPS forcé, en-têtes de sécurité', 'Le déploiement est piloté par un fichier netlify.toml minimal mais complet.

- publish = "." : le dossier racine est servi directement, sans build.
- Une redirection 301 forcée envoie www.joytrain.app vers le domaine canonique joytrain.app.
- Des en-têtes de sécurité de base sont appliqués à toutes les routes : X-Frame-Options (SAMEORIGIN), X-Content-Type-Options (nosniff) et Referrer-Policy (strict-origin-when-cross-origin).
- Le domaine joytrain.app a été retenu car joytrain.com est pris depuis 1999, et l''extension .app force nativement le HTTPS, cohérent avec l''API de l''app (api.joytrain.app). La réservation du domaine et la mise en ligne restent à effectuer.', 'result', 'text_only', 5, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (28, 6, 'Écosystème JoyTrain', 'Trois projets liés autour de la marque', 'Ce site vitrine n''est qu''une des trois briques d''un même produit. Les trois projets sont conçus pour fonctionner ensemble :

- L''application JoyTrain : l''app mobile Flutter (et son backend) qui réunit musculation, cardio, routines de mobilité et nutrition, avec scan de repas par photo et suivi des records. C''est le cœur du produit, et le site en montre les vrais écrans.
- Bora : le moteur RAG/IA qui alimente le coach intégré à l''application. C''est lui qui produit les réponses rédigées, sourcées et affichées en streaming, ainsi que la génération de programmes — le site présente Bora dans une section dédiée.
- JoyTrain — Site vitrine (ce projet) : la couche web publique, qui assure la présence marketing et héberge les pages légales nécessaires à la publication de l''app sur les stores.

Le site fait donc le lien entre l''app et son public, en s''appuyant sur l''identité de marque commune (logo, palette, icône) partagée par les trois projets.', 'text', 'text_only', 6, false, '2026-06-23 21:51:15.164954', '2026-06-23 23:27:11.938716');
INSERT INTO public.project_sections VALUES (35, 7, 'Buy & Hold : tout miser sur la hausse', NULL, 'Acheter et garder, c''est le réflexe de départ : on parie que le prix va monter. Quand le marché grimpe, on gagne ; quand il s''effondre — et la crypto s''effondre fort, parfois −70 % —, on encaisse toute la chute.

Sur un cycle complet, c''est un grand huit éprouvant, et souvent moins rentable qu''on ne l''imagine : sur 2021-2026, l''achat simple a même fait moins bien que la Bourse classique, pour un risque bien plus grand.', 'La base', 'text_only', 1, true, '2026-06-24 00:24:01.328976', '2026-06-24 00:24:01.328976');
INSERT INTO public.project_sections VALUES (36, 7, 'Le hedge : une assurance anti-krach', NULL, 'Le hedge, c''est une assurance pour ton portefeuille. On suit une moyenne mobile du prix : quand le prix passe en dessous (signe de faiblesse), on se met à l''abri en stablecoin ; quand il repasse au-dessus, on rachète.

Résultat : on évite l''essentiel des krachs, au prix de quelques faux signaux. Le hedge ne cherche pas à gagner plus — il cherche à perdre moins quand ça tourne mal. Et c''est ça qui change tout : tu investis, tu es protégé, et tu n''as plus à surveiller.', 'La protection', 'text_only', 2, true, '2026-06-24 00:24:01.328976', '2026-06-24 00:24:01.328976');
INSERT INTO public.project_sections VALUES (37, 7, 'Le carry : un revenu régulier, quel que soit le marché', NULL, 'Le carry, c''est le « loyer » d''une position : un revenu qu''on touche juste en la détenant, grâce à un écart de rendement — indépendamment de la hausse ou de la baisse.

En crypto, on détient au comptant et on vend un contrat à terme de la même valeur : on devient neutre au prix et on encaisse le financement. Lent mais régulier, peu volatil — la brique tranquille du portefeuille.', 'Le revenu', 'text_only', 3, true, '2026-06-24 00:24:01.328976', '2026-06-24 00:24:01.328976');


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.projects VALUES (4, 'JoyTrain — Application fitness, nutrition & coach IA', 'joytrain', 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333777/portfolio/images/projects/joytrain/appicon.png', '{https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333778/portfolio/images/projects/joytrain/screen-accueil.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333779/portfolio/images/projects/joytrain/screen-seance-muscu.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333780/portfolio/images/projects/joytrain/screen-programme.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333780/portfolio/images/projects/joytrain/screen-cardio.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333781/portfolio/images/projects/joytrain/screen-routine.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333783/portfolio/images/projects/joytrain/screen-nutrition.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333784/portfolio/images/projects/joytrain/screen-bora.png}', 'Une application mobile fitness, nutrition et coach IA que j''ai imaginée, développée et déployée seul — du concept au produit en ligne, bêta avant les stores.', 'Une application mobile fitness, nutrition et coach IA que j''ai imaginée, développée et déployée seul — du concept au produit en ligne, bêta avant les stores.', 'Concevoir un produit mobile complet et abouti, du premier croquis à la mise en ligne, en maîtrisant seul toute la chaîne, du mobile au serveur.', '{"Suivi d''entraînement complet : exercices, programmes, cardio et records personnels","Coach IA conversationnel « Bora » propulsé par l''API Mistral (IA européenne), qui répond et génère des séances sur mesure","Scan d''un repas par photo pour estimer automatiquement les apports","Journal nutrition adossé à une vraie base alimentaire et ses macros","Couche sociale : amis, posts, messagerie et notifications en temps réel","Mode hors-ligne : on enregistre ses séances sans réseau, tout se synchronise ensuite","Graphiques de progression et atlas musculaire interactif","Prête pour les stores (TestFlight iOS et Google Play)"}', '{Flutter,Dart,Riverpod,dio,go_router,drift,fl_chart,FastAPI,Python,"SQLAlchemy 2",Alembic,PostgreSQL,pgvector,Redis,arq,Ollama,bge-m3,Gemini,Mistral,React,Vite,MUI,"Docker Compose",Caddy,"GitHub Actions",Sentry}', NULL, 'https://joytrain.app', '2026-04-15', NULL, 'beta', 'mobile', NULL, NULL, NULL, '2026-06-23 21:51:15.164954', '2026-06-24 22:44:05.991306', 'Je fais du sport régulièrement et je cherchais une app qui réunisse tout au même endroit : entraînements, nutrition, progression. Rien ne me convenait, alors je l''ai construite pour moi. En avançant, j''ai vu qu''elle avait un vrai potentiel, assez aboutie pour être partagée. JoyTrain est née comme ça : d''un besoin personnel devenu un produit.', 'App mobile en Flutter, API en Python (FastAPI) et back-office d''administration en React, le tout pensé hors-ligne et temps réel. Le coach IA s''appuie sur un moteur RAG et le scan de repas sur un modèle de vision. JoyTrain forme un écosystème complet : l''app, le moteur RAG « Bora » et un site vitrine. Je l''ai déployée moi-même sur serveur via Docker, avec HTTPS automatique et déploiement continu.', NULL, 'J''ai porté JoyTrain de bout en bout, seul : penser l''expérience, développer le mobile et le serveur, intégrer l''IA, déployer sur mon VPS (Docker, HTTPS) et préparer la bêta avant les stores.', NULL);
INSERT INTO public.projects VALUES (2, 'Portfolio personnel', 'portfolio-personnel', '/images/came.png', '{}', 'Mon portfolio : un site vitrine complet que je gère moi-même, de la page d''accueil jusqu''au formulaire de contact.', 'Mon portfolio : un site vitrine complet que je gère moi-même, de la page d''accueil jusqu''au formulaire de contact.', 'Rassembler en un seul site mon profil, mes projets et mon parcours, avec un espace privé pour tout gérer en autonomie.', '{"Un site public immersif : accueil, projets, parcours, compétences, contact","Un espace d''administration privé pour tout gérer sans toucher au code","Ajout, modification et suppression des projets, études et expériences","Gestion des images et vidéos directement depuis l''interface","Un formulaire de contact qui m''envoie les messages par e-mail","Des fiches projet détaillées avec médias et descriptions riches","Un accès admin protégé par mot de passe sécurisé"}', '{Node.js,Express,EJS,JavaScript,PostgreSQL,SQL,"Bootstrap 5",Sass,Cloudinary,express-session,connect-pg-simple,CSRF,bcrypt,Multer,Nodemailer,Jest,Supertest,Docker,Caddy,Git}', NULL, NULL, '2024-12-31', NULL, 'in_progress', 'web', NULL, NULL, NULL, '2026-05-12 21:58:54.939443', '2026-06-24 00:01:21.645176', 'Je voulais un endroit clair pour présenter qui je suis, ce que je fais et ce que j''ai réalisé, à toute personne qui souhaite mieux me connaître. Et pouvoir tout mettre à jour moi-même — ajouter un projet, modifier mon parcours, changer une image — sans jamais retoucher au code.', 'Application web complète en Node.js / Express, vues EJS et base PostgreSQL structurée, avec médias hébergés sur Cloudinary. La sécurité repose sur des sessions persistées, une protection CSRF, des mots de passe hachés (bcrypt) et une limitation des tentatives. Le tout pensé pour un déploiement Docker auto-hébergé.', NULL, 'Ce projet montre que je livre une application web de bout en bout : l''interface publique que voit le client, le back-office qui la pilote, la base de données qui la structure et le déploiement qui la met en ligne. Un seul interlocuteur, du design à la mise en production.', NULL);
INSERT INTO public.projects VALUES (6, 'JoyTrain — Site vitrine', 'joytrain-site-vitrine', 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333789/portfolio/images/projects/joytrain-site-vitrine/og-image.png', '{https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333790/portfolio/images/projects/joytrain-site-vitrine/screen-accueil.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333790/portfolio/images/projects/joytrain-site-vitrine/screen-nutrition.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333791/portfolio/images/projects/joytrain-site-vitrine/screen-bora.png}', 'Le site vitrine de l''application JoyTrain : rapide, soigné et responsive, pensé pour présenter le produit et donner envie de l''installer.', 'Le site vitrine de l''application JoyTrain : rapide, soigné et responsive, pensé pour présenter le produit et donner envie de l''installer.', 'Donner à JoyTrain une vitrine claire et crédible : présenter les fonctionnalités avec de vrais écrans, donner envie d''installer l''app, et fournir les pages légales nécessaires à sa publication sur les stores.', '{"Une landing claire qui présente l''app et ses fonctionnalités en un coup d''œil","De vraies captures de l''app mises en valeur dans un cadre de téléphone élégant","Des animations discrètes au scroll qui rendent la page vivante sans l''alourdir","100% responsive : impeccable du mobile au grand écran","Chargement quasi instantané, sans superflu","Pages confidentialité, CGU et contact conformes RGPD","Une identité de marque cohérente : couleurs, logo, typographie soignée","Optimisé pour le partage social et le référencement"}', '{HTML5,CSS3,JavaScript,"Tailwind CSS (CDN)","Google Fonts (Inter)",SVG,"IntersectionObserver API","CSS Keyframes","CSS Custom Properties","Open Graph",Netlify,netlify.toml,Git}', NULL, 'https://joytrain.app', '2026-06-04', NULL, 'in_progress', 'web', NULL, NULL, NULL, '2026-06-23 21:51:15.164954', '2026-06-24 22:44:05.991306', 'Une bonne application sans page qui la présente, c''est personne qui l''installe. JoyTrain, l''app de coaching sportif, avait besoin d''une vitrine où l''on comprend en un coup d''œil ce que fait le produit, et où l''on trouve les pages légales exigées par l''App Store et Google Play. Je voulais un site rapide et propre, qui inspire confiance dès la première seconde. C''est l''une des trois briques de l''écosystème JoyTrain (l''app, le moteur de coaching IA Bora, et ce site vitrine).', 'Site 100% statique en HTML5 et Tailwind CSS, sans build ni dépendance lourde : ultra-rapide et facile à héberger. Les animations reposent sur de simples keyframes CSS et l''IntersectionObserver natif. Déploiement statique avec HTTPS forcé et en-têtes de sécurité de base.', NULL, 'Une vitrine légère, rapide et soignée, livrée en quelques fichiers et sans maintenance technique. Le projet montre que je sais concevoir un site qui présente clairement un produit, donne envie d''agir, et reste irréprochable sur la performance comme sur la conformité légale.', NULL);
INSERT INTO public.projects VALUES (5, 'Bora — Moteur RAG du coach IA JoyTrain', 'bora-rag-joytrain', 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333784/portfolio/images/projects/bora-rag-joytrain/coach.png', '{https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333785/portfolio/images/projects/bora-rag-joytrain/pipeline.svg}', 'Le moteur d''IA qui fait répondre le coach JoyTrain à partir de vraies sources reconnues, au lieu d''inventer.', 'Le moteur d''IA qui fait répondre le coach JoyTrain à partir de vraies sources reconnues, au lieu d''inventer.', 'Donner au coach IA de JoyTrain une base de connaissances fiable et citable, pour qu''il réponde sur l''entraînement et la nutrition en s''appuyant sur de vraies sources plutôt que d''improviser.', '{"Réponses appuyées sur de vraies sources reconnues (santé, nutrition, science)","Retrouve l''information la plus pertinente pour chaque question posée","Tient compte du contexte de l''utilisateur pour mieux cibler la réponse","Recherche hybride : comprend le sens ET retrouve les termes techniques exacts","Chaque réponse reste rattachée à sa source d''origine","Génération via l''API Mistral — une IA européenne, plutôt qu''un modèle propriétaire américain","Brique IA de l''écosystème JoyTrain (app + moteur Bora + site vitrine)"}', '{Python,BAAI/bge-m3,sentence-transformers,PyTorch,PostgreSQL,pgvector,psycopg,Pydantic,trafilatura,PyMuPDF,BeautifulSoup,lxml,rank-bm25,"Reciprocal Rank Fusion",NumPy,"Docker Compose",python-slugify,tqdm,python-dotenv,requests}', NULL, 'https://joytrain.app', '2026-05-26', NULL, 'in_progress', 'ai', NULL, NULL, NULL, '2026-06-23 21:51:15.164954', '2026-06-24 22:44:05.991306', 'Un coach IA n''a de valeur que si on peut lui faire confiance. Pour JoyTrain, je refusais que les conseils fitness et nutrition reposent sur des informations inventées par le modèle. J''ai donc construit un moteur qui va d''abord chercher la réponse dans de vraies références (organismes de santé, publications scientifiques) avant de répondre. L''utilisateur reçoit une réponse ancrée dans des sources réelles, pas une affirmation sortie de nulle part.', 'Le moteur collecte des documents de référence, les découpe et les indexe. Le sens du texte est capté par des embeddings open source (bge-m3) stockés dans une base vectorielle PostgreSQL/pgvector. La recherche combine mots-clés et sens, fusionnés pour ne rater ni un terme précis comme « créatine » ni une formulation différente. La génération de la réponse finale est confiée à l''API Mistral (IA européenne).', NULL, 'Bora prouve que je sais concevoir une IA fiable et traçable : elle s''appuie sur de vraies sources plutôt que d''halluciner, et chaque réponse reste rattachée à son origine. Le pipeline fonctionne de bout en bout — base de connaissances auto-hébergée pour la recherche, puis génération via l''API Mistral (IA européenne). Un vrai gage de maîtrise, de qualité et de traçabilité.', NULL);
INSERT INTO public.projects VALUES (7, 'MManima — Gestion de crypto-actifs & ML quantitatif', 'mmanima', 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333792/portfolio/images/projects/mmanima/logo.png', '{https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333793/portfolio/images/projects/mmanima/backtest.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333794/portfolio/images/projects/mmanima/strategie.svg}', 'Une appli qui rend l''investissement crypto tenable : au lieu de parier sur le sens du marché, elle protège ton capital des krachs — tu places ton argent et tu peux ne plus le surveiller.', 'Une appli qui rend l''investissement crypto tenable : au lieu de parier sur le sens du marché, elle protège ton capital des krachs — tu places ton argent et tu peux ne plus le surveiller.', 'Rendre l''investissement crypto serein et tenable : protéger le capital des effondrements et générer un rendement régulier, sans pari directionnel ni surveillance permanente.', '{"Protection automatique anti-krach : une couverture (hedge) te met à l''abri quand le marché plonge","Carry : un revenu régulier capté sans parier sur le sens du marché","Investis et oublie : plus besoin de surveiller les cours en permanence","Suivi en temps réel de ton portefeuille Binance (spot, futures, épargne)","Alertes techniques personnalisables (RSI, MACD, Bollinger, moyennes mobiles)","Simulation et backtests pour tester une stratégie avant d''engager le moindre euro","Connexion sécurisée à ton compte, clés API chiffrées"}', '{Python,FastAPI,SQLAlchemy,Alembic,PostgreSQL,Redis,APScheduler,Pydantic,"JWT (python-jose)","Fernet (cryptography)","Firebase Cloud Messaging","Binance API",Flutter,Dart,fl_chart,k_chart_plus,PyTorch,"Temporal Fusion Transformer (TFT)",CNN-LSTM,LightGBM,Optuna,MLflow,scikit-learn,pandas,CCXT,yfinance,Telethon,Docker,"Docker Compose"}', NULL, NULL, '2025-02-26', NULL, 'in_progress', 'ai', NULL, NULL, NULL, '2026-06-23 21:51:15.164954', '2026-06-24 22:44:05.991306', 'Soyons honnêtes : personne ne sait vraiment où va le marché. Chercher à le prédire, c''est parier — et le parieur perd sur la durée. Je voulais l''inverse : investir en crypto sans y passer mes journées et sans jouer à la loterie. L''idée de MManima est simple : ne pas deviner le marché, mais s''en protéger. Une couverture automatique qui sort des krachs, et du carry qui rapporte régulièrement. Tu investis, et tu peux passer à autre chose.', 'Une app mobile (Flutter) connectée à un backend (FastAPI + PostgreSQL + Redis) relié à Binance. À côté, un vrai laboratoire de machine learning (PyTorch, modèles TFT et CNN-LSTM, backtests rigoureux) qui m''a servi à trancher une question simple : peut-on prédire le marché ? La réponse, mesurée honnêtement, est non — ce qui a orienté tout le produit vers la protection plutôt que la prédiction.', NULL, 'Le fond du sujet : prédire le marché est quasi impossible, et s''y essayer revient à parier — un jeu perdant sur le long terme. La valeur est ailleurs : se protéger. Sur un backtest 2021-2026 (panier BTC/ETH/XRP/SOL, données Binance réelles, frais inclus), la crypto couverte a fait +34 %/an, contre +10 %/an en achat simple et +12 %/an pour le S&P 500, en évitant l''essentiel du krach 2022 (voir le graphe). À lire comme un résultat sur une période passée favorable, pas une promesse — mais le principe tient : investir, être protégé, et ne plus avoir à regarder.', NULL);
INSERT INTO public.projects VALUES (8, 'Base mobile robotique — Hackathon IUT Cachan', 'base-mobile-robot-hackathon', 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333798/portfolio/images/projects/base-mobile-robot-hackathon/robot-reel.png', '{https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333799/portfolio/images/projects/base-mobile-robot-hackathon/carte-mere.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333800/portfolio/images/projects/base-mobile-robot-hackathon/carte-mere-reelle.jpg,https://res.cloudinary.com/portfolio-hezuko/video/upload/v1782333802/portfolio/images/projects/base-mobile-robot-hackathon/suivi-objet.mp4,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333803/portfolio/images/projects/base-mobile-robot-hackathon/asservissement-pid.png,https://res.cloudinary.com/portfolio-hezuko/video/upload/v1782333804/portfolio/images/projects/base-mobile-robot-hackathon/asservissement.mp4,https://res.cloudinary.com/portfolio-hezuko/video/upload/v1782333806/portfolio/images/projects/base-mobile-robot-hackathon/ultrason.mp4,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333807/portfolio/images/projects/base-mobile-robot-hackathon/synoptique.png}', 'Une base mobile robotique pédagogique conçue de A à Z avec mon équipe à l''IUT de Cachan : carte mère sur-mesure, sept types de capteurs et asservissement PID, destinée aux TP et à la coupe de robotique GEII.', 'Une base mobile robotique pédagogique conçue de A à Z avec mon équipe à l''IUT de Cachan : carte mère sur-mesure, sept types de capteurs et asservissement PID, destinée aux TP et à la coupe de robotique GEII.', 'Livrer une base mobile fiable et facile à programmer, équipée des capteurs imposés et pilotable sans fil, pour que de futurs étudiants apprennent la robotique dessus.', '{}', '{"STM32 Nucleo F429ZI",C++,"ARM mbed","Altium Designer",SolidWorks,"Qt Creator",MikroBUS,SPI,UART,I2C,"Bluetooth HC-06","Caméra Pixy","Encodeur AS5047P","Ultrason VMA306","Magnétomètre BMM150","Capteur optique CNY70","Driver moteur IFX9021","Asservissement PID",Odométrie}', NULL, NULL, '2022-09-01', '2023-06-30', 'done', 'robotics', 3, NULL, NULL, '2026-06-24 18:29:10.800069', '2026-06-24 22:44:05.991306', 'Projet de fin de cycle à l''IUT de Cachan, dans la continuité de notre année : concevoir un robot mobile complet qui servirait d''outil pédagogique aux étudiants suivants (travaux pratiques et coupe de robotique GEII). On a commencé par de la rétro-ingénierie d''un robot existant pour le comprendre à fond — électronique, mécanique, programmation — avant de le refaire et de l''améliorer. Un vrai projet d''équipe (à trois) qui m''a plongé dans le système embarqué de bout en bout.', 'Le cœur est un Nucleo STM32 F429ZI relié à une carte mère que nous avons conçue (Altium), exposant des emplacements MikroBUS standardisés. Chaque fonction est un module : encodeurs AS5047P (SPI) pour l''odométrie, ultrasons VMA306, caméra Pixy, boussole BMM150, capteurs de ligne CNY70, et deux étages de puissance IFX9021 pour les moteurs. Le tout est programmé en C++ (mbed), avec un asservissement PID en boucle fermée sur les encodeurs et une interface Qt pour le pilotage.', 'Le plus délicat a été l''asservissement : obtenir un déplacement précis a demandé de régler le correcteur PID à partir du retour vitesse des encodeurs, puis d''enchaîner avec des profils de vitesse en trapèze pour des trajectoires propres.', 'Une base mobile fonctionnelle et complète — elle suit un objet, suit une ligne, évite les obstacles et se pilote sans fil — prête à servir de support de TP et pour la coupe GEII. Le projet m''a fait toucher à toute la chaîne embarquée : électronique, PCB, mécanique, firmware et asservissement, en équipe.', NULL);
INSERT INTO public.projects VALUES (3, 'Robot suiveur de ligne — Gamel Trophy', 'robot-suiveur-de-ligne-gamel-trophy', 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333766/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-rendu.jpg', '{https://res.cloudinary.com/portfolio-hezuko/video/upload/v1782333768/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-en-action.mp4,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333769/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/vue-c.jpg,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333771/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/pcb-carte-moteur.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333772/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-1.jpg,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333772/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/schema-kicad.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333773/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/vue-a.jpg,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333774/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/schema-synoptique.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333774/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-5.jpg,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333775/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-2.jpg,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333776/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-3.jpg,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333776/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-4.jpg,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333777/portfolio/images/projects/robot-suiveur-de-ligne-gamel-trophy/vue-b.jpg}', 'Un robot autonome qui suit une ligne tout seul, conçu de A à Z avec mon équipe pour une compétition de robotique.', 'Un robot autonome qui suit une ligne tout seul, conçu de A à Z avec mon équipe pour une compétition de robotique.', 'Construire de zéro un robot autonome capable de suivre une piste, repérer les raccourcis et la parcourir le plus vite possible, en équipe et dans les délais imposés.', '{"Robot qui démarre et roule en totale autonomie","Suivi de ligne fluide, sans partir dans tous les sens","Détection des raccourcis pour gagner du temps sur le circuit","Carte électronique maison, conçue et fabriquée de bout en bout","Réglage de la vitesse à la volée selon la piste","Robot validé sur le terrain, en conditions de course réelles"}', '{C++,KiCad,"Routage PCB","Électronique embarquée",Soudure,"Carte moteur","Capteurs CNY70","Moteurs DC","Automate d''états",Robotique,"Tests et validation","Travail en équipe"}', NULL, NULL, '2021-09-01', '2022-06-30', 'done', 'robotics', 3, NULL, NULL, '2026-05-16 13:46:13.857252', '2026-06-24 22:44:05.991306', 'C''était mon initiation à l''électronique embarquée et au C++, au tout début de mes études. Avec mon équipe à l''IUT, on s''est lancé un vrai défi : concevoir un robot capable de courir seul sur une piste pour une compétition. Pas de tutoriel, juste un cahier des charges, une deadline et l''envie de voir notre machine franchir la ligne d''arrivée.', 'J''ai pris en charge la carte moteur de bout en bout : schéma et routage du circuit imprimé sous KiCad, gravure, soudure, puis tests au multimètre. Côté logiciel, j''ai programmé le robot en C++ : lecture des capteurs et automates d''états pour le suivi de ligne et la détection des raccourcis. Du premier croquis jusqu''au robot qui roule.', NULL, 'Le robot a fonctionné et s''est qualifié en phase finale avec un chrono de 46 secondes. Au-delà du résultat, ce projet prouve que je sais mener une réalisation technique complète, du matériel au logiciel, en équipe et jusqu''au bout.', NULL);
INSERT INTO public.projects VALUES (9, 'Système embarqué sans fil sur PIC — Stage au laboratoire MPQ', 'systeme-embarque-pic-stage-mpq', 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333808/portfolio/images/projects/systeme-embarque-pic-stage-mpq/carte-reelle.png', '{https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333808/portfolio/images/projects/systeme-embarque-pic-stage-mpq/carte-reelle-verso.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333809/portfolio/images/projects/systeme-embarque-pic-stage-mpq/pcb-routage.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333810/portfolio/images/projects/systeme-embarque-pic-stage-mpq/pcb-top.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333810/portfolio/images/projects/systeme-embarque-pic-stage-mpq/pcb-bottom.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333811/portfolio/images/projects/systeme-embarque-pic-stage-mpq/pcb-inner1.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333812/portfolio/images/projects/systeme-embarque-pic-stage-mpq/pcb-inner2.png,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333812/portfolio/images/projects/systeme-embarque-pic-stage-mpq/module-rf-si4432.jpg,https://res.cloudinary.com/portfolio-hezuko/image/upload/v1782333813/portfolio/images/projects/systeme-embarque-pic-stage-mpq/arduino-prototype.png}', 'Stage en laboratoire de recherche (CNRS / MPQ) : j''ai conçu une carte électronique sans fil de mesure de température pour des salles d''expériences quantiques — du schéma au PCB multicouche, du prototype Arduino jusqu''au PIC.', 'Stage en laboratoire de recherche (CNRS / MPQ) : j''ai conçu une carte électronique sans fil de mesure de température pour des salles d''expériences quantiques — du schéma au PCB multicouche, du prototype Arduino jusqu''au PIC.', 'Concevoir un système embarqué sans fil capable de mesurer précisément la température de plusieurs salles et de transmettre les données de façon fiable, sur une carte robuste pensée pour un usage en laboratoire.', '{}', '{PIC18F26J11,"Microchip MPLAB",Arduino,"Langage C",Multisim,Ultiboard,"PCB multicouche","Radiofréquence (RF)",CRC,SPI,UART,DHT22,Thermistance,"Sonde PT100","Étalonnage capteurs","PPS (Peripheral Pin Select)"}', NULL, NULL, '2023-04-01', '2023-07-31', 'done', 'robotics', 3, NULL, NULL, '2026-06-24 18:29:10.800069', '2026-06-24 22:44:05.991306', 'Stage de 2e année (IUT de Cachan) au pôle technique du laboratoire MPQ — Matériaux et Phénomènes Quantiques, une unité de recherche CNRS / Université Paris Cité. La mission : fiabiliser la mesure de température des salles d''expériences, où la précision est critique pour la physique quantique. Un vrai projet de terrain, du besoin réel jusqu''à une carte fonctionnelle livrée au labo.', 'Le système repose sur un microcontrôleur Microchip PIC18F26J11 (réaffectation de broches PPS pour optimiser le routage) qui lit plusieurs capteurs de température (DHT22, thermistance, PT100) et transmet les mesures par radiofréquence avec un contrôle CRC. J''ai d''abord prototypé et validé toute la chaîne sous Arduino, puis migré l''ensemble vers le PIC sous MPLAB. La carte a été étudiée sous Multisim, routée en multicouche sous Ultiboard, puis fabriquée, câblée et déboguée.', 'La migration d''Arduino vers le PIC a été le vrai défi : reprendre toute la logique (lecture des capteurs, RF, CRC) sur une cible bien moins assistée, en réglant des problèmes concrets de bas niveau — appel de courant et stabilité du module RF, reset du microcontrôleur, téléversement.', 'Une carte de mesure de température sans fil fonctionnelle, livrée au laboratoire pour fiabiliser ses salles d''expériences. Le stage m''a fait vivre tout le cycle d''un produit embarqué en contexte recherche : étude des datasheets, schéma, routage PCB multicouche, programmation Arduino puis PIC, étalonnage et débogage matériel.', NULL);


--
-- Data for Name: projet; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.schools VALUES (2, 'Lycée Durzy', 'portfolio/private/schools/fedsfbpendhojnqnc1tw', 'Villemandeur', 'France', 'https://www.lyceedurzy.com', 'Description
Lycée général, technologique et professionnel situé à Villemandeur, spécialisé notamment dans les formations scientifiques, technologiques et industrielles. J’y ai développé mes bases en sciences, en technologies et en méthodologie de travail, ce qui m’a permis de construire progressivement mon parcours vers les systèmes embarqués et l’ingénierie.', '2026-05-12 20:36:36.698573', '2026-05-12 21:10:22.823246', 'lyc-e-durzy-2');
INSERT INTO public.schools VALUES (3, 'IUT de Cachan — Université Paris-Saclay', 'portfolio/private/projects/ktss8csa7symci9jv4qo', 'Cachan', 'France', 'https://www.iut-cachan.universite-paris-saclay.fr/', 'Institut Universitaire de Technologie rattaché à l’Université Paris-Saclay, l’IUT de Cachan propose des formations techniques et professionnalisantes orientées vers les domaines du Génie Électrique et Informatique Industrielle, ainsi que du Génie Mécanique et Productique. Cette formation m’a permis de consolider mes compétences en électronique, informatique industrielle, systèmes automatisés et technologies embarquées, tout en développant une approche pratique à travers les travaux pratiques, les projets et l’apprentissage en environnement technique.  ', '2026-05-12 20:38:59.822714', '2026-05-12 21:10:19.782954', 'iut-de-cachan-universit-paris-saclay-3');
INSERT INTO public.schools VALUES (4, 'Université de Technologie de Compiègne — UTC', 'portfolio/private/schools/icdrfgrpjdjs6ad3r3h5', 'Compiègne', 'France', 'https://www.utc.fr/', 'Grande école d’ingénieurs et établissement public d’enseignement supérieur situé à Compiègne, l’UTC propose des formations scientifiques et technologiques avec une forte orientation vers l’innovation, l’ingénierie et la recherche. J’y ai suivi un parcours initialement orienté vers un diplôme d’ingénieur en informatique généraliste, avant d’obtenir un Bachelor en Science et Technologie. Cette expérience m’a permis de renforcer mes bases en sciences, en informatique, en méthodes d’ingénierie et en résolution de problèmes techniques. L’UTC indique proposer notamment des formations d’ingénieur, de master, de doctorat et un bachelor dans son offre de formation', '2026-05-12 20:45:53.853186', '2026-05-12 20:45:53.853186', 'universit-de-technologie-de-compi-gne-utc-4');
INSERT INTO public.schools VALUES (5, 'ESIEE Paris', 'portfolio/private/schools/qojnfffiwqmivbcpofq0', 'Noisy-le-Grand', 'France', 'https://www.esiee.fr/', 'École d’ingénieurs située à Noisy-le-Grand, ESIEE Paris forme des ingénieurs dans les domaines du numérique, de l’électronique, de l’informatique, des systèmes embarqués, de l’intelligence artificielle, de la cybersécurité et de l’innovation technologique. J’y suis un cursus d’ingénieur orienté vers les systèmes embarqués, avec un objectif de développement de compétences avancées en électronique, programmation bas niveau, microcontrôleurs, architecture matérielle/logicielle et conception de systèmes intelligents.', '2026-05-12 20:48:33.710377', '2026-05-12 21:26:08.910307', 'esiee-paris-5');


--
-- Data for Name: site_settings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.site_settings VALUES (8, 'linkedin_url', 'https://www.linkedin.com/in/henocmukumbi', 'Lien vers le profil LinkedIn public', '2026-05-12 20:01:08.256869', '2026-05-12 20:01:08.256869');
INSERT INTO public.site_settings VALUES (10, 'legal_site_name', 'Portfolio Henoc Mukumbi', 'Nom du site affiche dans les mentions legales', '2026-05-12 20:01:08.256869', '2026-05-12 20:01:08.256869');
INSERT INTO public.site_settings VALUES (11, 'legal_publisher_name', 'Henoc Mukumbi', 'Editeur du site', '2026-05-12 20:01:08.256869', '2026-05-12 20:01:08.256869');
INSERT INTO public.site_settings VALUES (13, 'legal_publication_director', 'Henoc Mukumbi', 'Directeur de la publication', '2026-05-12 20:01:08.256869', '2026-05-12 20:01:08.256869');
INSERT INTO public.site_settings VALUES (14, 'legal_hosting_provider', 'Hebergeur a completer avant mise en production', 'Nom de l hebergeur utilise en production', '2026-05-12 20:01:08.256869', '2026-05-12 20:01:08.256869');
INSERT INTO public.site_settings VALUES (16, 'legal_hosting_website', '', 'Site web officiel de l hebergeur', '2026-05-12 20:01:08.256869', '2026-05-12 20:01:08.256869');
INSERT INTO public.site_settings VALUES (18, 'legal_retention_contact', 'Les messages de contact sont conserves le temps necessaire au traitement de la demande, puis supprimes ou archives selon leur utilite.', 'Duree de conservation des messages de contact', '2026-05-12 20:01:08.256869', '2026-05-12 20:01:08.256869');
INSERT INTO public.site_settings VALUES (19, 'legal_last_updated', '12 mai 2026', 'Date de derniere mise a jour des pages legales', '2026-05-12 20:01:08.256869', '2026-05-12 20:01:08.256869');
INSERT INTO public.site_settings VALUES (2, 'contact_email', 'h.mukumbi100@gmail.com', 'Email public de contact', '2026-05-12 11:44:06.982407', '2026-05-12 20:13:34.15871');
INSERT INTO public.site_settings VALUES (7, 'github_url', 'https://github.com/Hezuko', 'Lien vers le profil GitHub public', '2026-05-12 20:01:08.256869', '2026-05-12 20:13:40.306526');
INSERT INTO public.site_settings VALUES (17, 'legal_data_controller', 'Henoc Mukumbi', 'Responsable du traitement des donnees personnelles', '2026-05-12 20:01:08.256869', '2026-05-12 20:13:45.634184');
INSERT INTO public.site_settings VALUES (15, 'legal_hosting_address', 'Adresse de l hebergeur a completer', 'Adresse officielle de l hebergeur', '2026-05-12 20:01:08.256869', '2026-05-12 20:13:51.135387');
INSERT INTO public.site_settings VALUES (12, 'legal_publisher_status', 'Particulier - a adapter si le site est rattache a une activite professionnelle', 'Statut legal de l editeur', '2026-05-12 20:01:08.256869', '2026-05-12 20:14:04.687704');
INSERT INTO public.site_settings VALUES (6, 'profile_about', NULL, 'Texte de presentation plus complet affiche sur la page d accueil', '2026-05-12 20:01:08.256869', '2026-05-12 20:14:18.716189');
INSERT INTO public.site_settings VALUES (4, 'profile_name', 'Henoc MUKUMBI', 'Nom affiche dans la navigation, l accueil et le footer', '2026-05-12 20:01:08.256869', '2026-05-12 20:14:30.977619');
INSERT INTO public.site_settings VALUES (3, 'profile_photo', 'portfolio/private/profile/hp7v57d9atzloiukmmaw', 'Media prive utilise comme photo de profil sur la page d accueil', '2026-05-12 12:46:06.016377', '2026-05-16 00:00:48.796775');
INSERT INTO public.site_settings VALUES (5, 'profile_tagline', 'Ingénieur systèmes embarqués. Je conçois l''électronique et le logiciel qui tourne dessus — du circuit imprimé au cloud.', 'Phrase d accroche de la page d accueil', '2026-05-12 20:01:08.256869', '2026-05-12 20:01:08.256869');
INSERT INTO public.site_settings VALUES (9, 'cv_url', 'https://hezuko.github.io/resume/resume.pdf', 'Lien vers le CV PDF', '2026-05-12 20:01:08.256869', '2026-05-12 20:01:08.256869');
INSERT INTO public.site_settings VALUES (1, 'profile_title', 'Ingénieur architecte en systèmes embarqués', 'Titre principal affiche sur le portfolio', '2026-05-12 11:44:06.982407', '2026-05-12 11:44:06.982407');


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.skills VALUES (1, 'JavaScript', 'Frontend', 'js', 'avance', '2026-05-12 11:44:06.982148', '2026-05-12 11:44:06.982148', NULL);
INSERT INTO public.skills VALUES (2, 'Node.js', 'Backend', 'node', 'avance', '2026-05-12 11:44:06.982148', '2026-05-12 11:44:06.982148', NULL);
INSERT INTO public.skills VALUES (4, 'PostgreSQL', 'Base de donnees', 'database', 'intermediaire', '2026-05-12 11:44:06.982148', '2026-05-12 11:44:06.982148', NULL);
INSERT INTO public.skills VALUES (5, 'Docker', 'DevOps', 'docker', 'intermediaire', '2026-05-12 11:44:06.982148', '2026-05-12 11:44:06.982148', NULL);
INSERT INTO public.skills VALUES (6, 'Git', 'Outils', 'git', 'avance', '2026-05-12 11:44:06.982148', '2026-05-12 11:44:06.982148', NULL);
INSERT INTO public.skills VALUES (91, 'Test UX', 'Outils', 'test', 'intermediaire', '2026-06-27 08:10:23.409528', '2026-06-27 08:10:23.409528', NULL);
INSERT INTO public.skills VALUES (93, 'Test UX', 'Outils', 'test', 'intermediaire', '2026-06-27 08:10:50.433264', '2026-06-27 08:10:50.433264', NULL);
INSERT INTO public.skills VALUES (95, 'Test UX', 'Outils', 'test', 'intermediaire', '2026-06-27 08:17:04.17077', '2026-06-27 08:17:04.17077', NULL);
INSERT INTO public.skills VALUES (97, 'Test UX', 'Outils', 'test', 'intermediaire', '2026-06-27 08:29:11.65069', '2026-06-27 08:29:11.65069', NULL);
INSERT INTO public.skills VALUES (99, 'Test UX', 'Outils', 'test', 'intermediaire', '2026-06-27 08:34:11.418121', '2026-06-27 08:34:11.418121', NULL);
INSERT INTO public.skills VALUES (3, 'Express', 'Backend', 'express', 'avance', '2026-05-12 11:44:06.982148', '2026-05-12 23:14:42.268941', NULL);
INSERT INTO public.skills VALUES (101, 'Test UX', 'Outils', 'test', 'intermediaire', '2026-06-27 08:35:28.723481', '2026-06-27 08:35:28.723481', NULL);


--
-- Data for Name: technologies; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.technologies VALUES (1, 'C', 'Langage', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (4, 'Electronique', 'Matiere', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (5, 'Microcontroleurs', 'Electronique', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (6, 'FPGA', 'Electronique', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (7, 'VHDL', 'Langage', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (8, 'Automatisme', 'Matiere', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (9, 'Mathematiques', 'Matiere', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (10, 'Physique', 'Matiere', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (11, 'Systemes embarques', 'Systeme', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (12, 'Linux embarque', 'Systeme', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (13, 'CAN', 'Protocole', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (14, 'UART', 'Protocole', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (15, 'SPI', 'Protocole', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (16, 'I2C', 'Protocole', '2026-05-12 21:02:16.920871', '2026-05-12 21:02:16.920871');
INSERT INTO public.technologies VALUES (17, 'KiCad', 'Outil', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (18, 'PCB', 'Electronique', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (19, 'Routage PCB', 'Electronique', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (20, 'Schématique électronique', 'Electronique', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (21, 'Électronique', 'Electronique', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (22, 'Carte moteur', 'Electronique', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (23, 'Soudure', 'Electronique', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (24, 'Perçage PCB', 'Electronique', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (25, 'Tests de continuité', 'Outil', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (26, 'Test d’isolation', 'Outil', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (27, 'Test statique', 'Outil', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (28, 'Test fonctionnel', 'Outil', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (29, 'Ohmmètre', 'Outil', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (30, 'Voltmètre', 'Outil', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (31, 'Générateur de signaux', 'Outil', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (2, 'C++', 'Langage', '2026-05-12 21:02:16.920871', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (33, 'Robotique', 'Systeme', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (34, 'Robot suiveur de ligne', 'Systeme', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (35, 'Capteurs CNY70', 'Electronique', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (36, 'Moteurs DC', 'Electronique', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (37, 'Potentiomètre', 'Electronique', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (38, 'Automate d’états', 'Systeme', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (39, 'Suivi de ligne', 'Systeme', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (40, 'Détection de raccourcis', 'Systeme', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (41, 'Travail en équipe', 'Autre', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (42, 'Gestion de projet technique', 'Autre', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (43, 'Documentation technique', 'Autre', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (44, 'Tests et validation', 'Outil', '2026-05-16 13:46:13.857252', '2026-05-16 13:46:13.857252');
INSERT INTO public.technologies VALUES (45, 'Dart', 'Langage', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (3, 'Python', 'Langage', '2026-05-12 21:02:16.920871', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (47, 'Flutter', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (48, 'Riverpod', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (49, 'dio', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (50, 'drift', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (51, 'FastAPI', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (52, 'SQLAlchemy 2', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (53, 'Alembic', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (54, 'arq', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (55, 'React', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (56, 'Vite', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (57, 'MUI', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (58, 'Caddy', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (59, 'Sentry', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (60, 'PostgreSQL', 'Systeme', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (61, 'pgvector', 'Systeme', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (62, 'Redis', 'Systeme', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (63, 'Docker Compose', 'Systeme', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (64, 'GitHub Actions', 'Systeme', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (65, 'Ollama', 'Systeme', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (66, 'WebSocket', 'Protocole', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (67, 'bge-m3', 'Autre', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (68, 'Gemini', 'Autre', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (69, 'Mistral', 'Autre', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (70, 'BAAI/bge-m3', 'Autre', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (71, 'sentence-transformers', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (72, 'PyTorch', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (73, 'psycopg', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (74, 'Pydantic', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (75, 'trafilatura', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (76, 'PyMuPDF', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (77, 'BeautifulSoup', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (78, 'lxml', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (79, 'rank-bm25', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (80, 'Reciprocal Rank Fusion', 'Autre', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (81, 'RAG', 'Autre', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (82, 'NumPy', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (83, 'robots.txt', 'Protocole', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (84, 'HTML5', 'Langage', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (85, 'CSS3', 'Langage', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (86, 'JavaScript', 'Langage', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (87, 'Tailwind CSS', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (88, 'Google Fonts (Inter)', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (89, 'SVG', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (90, 'IntersectionObserver API', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (91, 'CSS Keyframes', 'Systeme', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (92, 'CSS Custom Properties', 'Systeme', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (93, 'Open Graph', 'Protocole', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (94, 'Netlify', 'Systeme', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (95, 'Git', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (96, 'SQLAlchemy', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (97, 'APScheduler', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (98, 'fl_chart', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (99, 'k_chart_plus', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (100, 'LightGBM', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (101, 'Optuna', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (102, 'MLflow', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (103, 'scikit-learn', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (104, 'CCXT', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (105, 'Telethon', 'Outil', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (106, 'Temporal Fusion Transformer (TFT)', 'Autre', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (107, 'CNN-LSTM', 'Autre', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (108, 'Firebase Cloud Messaging', 'Systeme', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (109, 'JWT', 'Protocole', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (110, 'Binance API', 'Protocole', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');
INSERT INTO public.technologies VALUES (111, 'Fernet (cryptography)', 'Autre', '2026-06-23 21:51:15.164954', '2026-06-23 21:51:15.164954');


--
-- Name: certification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.certification_id_seq', 1, true);


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.companies_id_seq', 4, true);


--
-- Name: contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contacts_id_seq', 13, true);


--
-- Name: course_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.course_categories_id_seq', 24, true);


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.courses_id_seq', 155, true);


--
-- Name: diplome_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.diplome_id_seq', 1, true);


--
-- Name: educations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.educations_id_seq', 7, true);


--
-- Name: etude_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.etude_id_seq', 7, true);


--
-- Name: job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.job_id_seq', 1, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.jobs_id_seq', 4, true);


--
-- Name: media_assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.media_assets_id_seq', 15, true);


--
-- Name: project_section_media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.project_section_media_id_seq', 1, false);


--
-- Name: project_sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.project_sections_id_seq', 37, true);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.projects_id_seq', 9, true);


--
-- Name: projet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.projet_id_seq', 1, true);


--
-- Name: schools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schools_id_seq', 5, true);


--
-- Name: site_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.site_settings_id_seq', 19, true);


--
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.skills_id_seq', 119, true);


--
-- Name: technologies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.technologies_id_seq', 111, true);


--
-- Name: utilisateurs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.utilisateurs_id_seq', 56, true);


--
-- Name: certification certification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certification
    ADD CONSTRAINT certification_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: course_categories course_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_categories
    ADD CONSTRAINT course_categories_name_key UNIQUE (name);


--
-- Name: course_categories course_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_categories
    ADD CONSTRAINT course_categories_pkey PRIMARY KEY (id);


--
-- Name: courses courses_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_code_key UNIQUE (code);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: diplome diplome_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diplome
    ADD CONSTRAINT diplome_pkey PRIMARY KEY (id);


--
-- Name: education_courses education_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_courses
    ADD CONSTRAINT education_courses_pkey PRIMARY KEY (education_id, course_id);


--
-- Name: education_projects education_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_projects
    ADD CONSTRAINT education_projects_pkey PRIMARY KEY (education_id, project_id);


--
-- Name: education_skills education_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_skills
    ADD CONSTRAINT education_skills_pkey PRIMARY KEY (education_id, skill_id);


--
-- Name: education_technologies education_technologies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_technologies
    ADD CONSTRAINT education_technologies_pkey PRIMARY KEY (education_id, technology_id);


--
-- Name: educations educations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.educations
    ADD CONSTRAINT educations_pkey PRIMARY KEY (id);


--
-- Name: etude etude_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.etude
    ADD CONSTRAINT etude_pkey PRIMARY KEY (id);


--
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: media_assets media_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_assets
    ADD CONSTRAINT media_assets_pkey PRIMARY KEY (id);


--
-- Name: media_assets media_assets_public_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_assets
    ADD CONSTRAINT media_assets_public_id_key UNIQUE (public_id);


--
-- Name: project_section_media project_section_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_section_media
    ADD CONSTRAINT project_section_media_pkey PRIMARY KEY (id);


--
-- Name: project_sections project_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_sections
    ADD CONSTRAINT project_sections_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects projects_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_slug_key UNIQUE (slug);


--
-- Name: projet projet_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projet
    ADD CONSTRAINT projet_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (filename);


--
-- Name: schools schools_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: site_settings site_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_settings
    ADD CONSTRAINT site_settings_pkey PRIMARY KEY (id);


--
-- Name: site_settings site_settings_setting_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_settings
    ADD CONSTRAINT site_settings_setting_key_key UNIQUE (setting_key);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: technologies technologies_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technologies
    ADD CONSTRAINT technologies_name_key UNIQUE (name);


--
-- Name: technologies technologies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technologies
    ADD CONSTRAINT technologies_pkey PRIMARY KEY (id);


--
-- Name: utilisateurs utilisateurs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_pkey PRIMARY KEY (id);


--
-- Name: utilisateurs utilisateurs_pseudo_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_pseudo_key UNIQUE (pseudo);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_session_expire" ON public.session USING btree (expire);


--
-- Name: project_section_media_section_media_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX project_section_media_section_media_unique ON public.project_section_media USING btree (section_id, media_id);


--
-- Name: project_sections_project_title_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX project_sections_project_title_unique ON public.project_sections USING btree (project_id, lower((title)::text));


--
-- Name: schools_slug_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX schools_slug_unique ON public.schools USING btree (slug);


--
-- Name: courses courses_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.course_categories(id) ON DELETE SET NULL;


--
-- Name: education_courses education_courses_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_courses
    ADD CONSTRAINT education_courses_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;


--
-- Name: education_courses education_courses_education_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_courses
    ADD CONSTRAINT education_courses_education_id_fkey FOREIGN KEY (education_id) REFERENCES public.educations(id) ON DELETE CASCADE;


--
-- Name: education_projects education_projects_education_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_projects
    ADD CONSTRAINT education_projects_education_id_fkey FOREIGN KEY (education_id) REFERENCES public.educations(id) ON DELETE CASCADE;


--
-- Name: education_projects education_projects_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_projects
    ADD CONSTRAINT education_projects_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: education_skills education_skills_education_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_skills
    ADD CONSTRAINT education_skills_education_id_fkey FOREIGN KEY (education_id) REFERENCES public.educations(id) ON DELETE CASCADE;


--
-- Name: education_skills education_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_skills
    ADD CONSTRAINT education_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id) ON DELETE CASCADE;


--
-- Name: education_technologies education_technologies_education_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_technologies
    ADD CONSTRAINT education_technologies_education_id_fkey FOREIGN KEY (education_id) REFERENCES public.educations(id) ON DELETE CASCADE;


--
-- Name: education_technologies education_technologies_technology_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.education_technologies
    ADD CONSTRAINT education_technologies_technology_id_fkey FOREIGN KEY (technology_id) REFERENCES public.technologies(id) ON DELETE CASCADE;


--
-- Name: educations educations_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.educations
    ADD CONSTRAINT educations_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE SET NULL;


--
-- Name: jobs jobs_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;


--
-- Name: project_section_media project_section_media_media_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_section_media
    ADD CONSTRAINT project_section_media_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media_assets(id) ON DELETE CASCADE;


--
-- Name: project_section_media project_section_media_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_section_media
    ADD CONSTRAINT project_section_media_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.project_sections(id) ON DELETE CASCADE;


--
-- Name: project_sections project_sections_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_sections
    ADD CONSTRAINT project_sections_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: projects projects_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE SET NULL;


--
-- Name: projects projects_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE SET NULL;


--
-- Name: projects projects_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.schools(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

