--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Debian 16.3-1.pgdg120+1)
-- Dumped by pg_dump version 16.3 (Debian 16.3-1.pgdg120+1)

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

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: announcement_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.announcement_types AS ENUM (
    'Basic',
    'Practicum',
    'Inhall',
    'Asistant'
);


ALTER TYPE public.announcement_types OWNER TO postgres;

--
-- Name: days; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.days AS ENUM (
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
);


ALTER TYPE public.days OWNER TO postgres;

--
-- Name: roles; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.roles AS ENUM (
    'student',
    'assistant',
    'laborant',
    'lecturer',
    'minlab'
);


ALTER TYPE public.roles OWNER TO postgres;

--
-- Name: semester; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.semester AS ENUM (
    'Ganjil',
    'Genap'
);


ALTER TYPE public.semester OWNER TO postgres;

--
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status AS ENUM (
    'Pending',
    'Paid'
);


ALTER TYPE public.status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: academic_years; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.academic_years (
    id character varying(20) NOT NULL,
    name text NOT NULL,
    semester public.semester NOT NULL,
    created_at text NOT NULL,
    updated_at text NOT NULL,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE public.academic_years OWNER TO postgres;

--
-- Name: activation_subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activation_subjects (
    activation_id character varying(20) NOT NULL,
    subject_id character varying(20) NOT NULL
);


ALTER TABLE public.activation_subjects OWNER TO postgres;

--
-- Name: activations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activations (
    id character varying(20) NOT NULL,
    "user" character varying(15) NOT NULL,
    total_payment numeric NOT NULL,
    status public.status NOT NULL,
    created_at text NOT NULL,
    updated_at text,
    academic_year character varying(20) NOT NULL,
    verifier character varying(15) DEFAULT NULL::character varying
);


ALTER TABLE public.activations OWNER TO postgres;

--
-- Name: announcements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcements (
    id character varying(25) NOT NULL,
    type public.announcement_types NOT NULL,
    title character varying(100) NOT NULL,
    body text NOT NULL,
    created_at text NOT NULL,
    updated_at text,
    author character varying(15) NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.announcements OWNER TO postgres;

--
-- Name: authentications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authentications (
    token text NOT NULL
);


ALTER TABLE public.authentications OWNER TO postgres;

--
-- Name: collaborations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collaborations (
    id character varying(25) NOT NULL,
    subject_class character varying(20) NOT NULL,
    assistant character varying(15) NOT NULL,
    author character varying(15) NOT NULL,
    created_at text NOT NULL
);


ALTER TABLE public.collaborations OWNER TO postgres;

--
-- Name: meeting_presences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meeting_presences (
    meeting_id character varying(20) NOT NULL,
    user_id character varying(15) NOT NULL,
    user_device text NOT NULL,
    user_ip text NOT NULL,
    submitted_at text NOT NULL,
    is_attended boolean DEFAULT false
);


ALTER TABLE public.meeting_presences OWNER TO postgres;

--
-- Name: pgmigrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pgmigrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    run_on timestamp without time zone NOT NULL
);


ALTER TABLE public.pgmigrations OWNER TO postgres;

--
-- Name: pgmigrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pgmigrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pgmigrations_id_seq OWNER TO postgres;

--
-- Name: pgmigrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pgmigrations_id_seq OWNED BY public.pgmigrations.id;


--
-- Name: practicum_meetings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.practicum_meetings (
    id character varying(20) NOT NULL,
    subject_class character varying(20) NOT NULL,
    meeting_name character varying(50) NOT NULL,
    created_at text NOT NULL,
    updated_at text,
    author character varying(15),
    token character varying(15),
    is_opened boolean DEFAULT false
);


ALTER TABLE public.practicum_meetings OWNER TO postgres;

--
-- Name: practicum_registrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.practicum_registrations (
    id character varying(20) NOT NULL,
    student character varying(15) NOT NULL,
    practicum_class character varying(20) NOT NULL,
    created_at text NOT NULL,
    updated_at text NOT NULL
);


ALTER TABLE public.practicum_registrations OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id character varying(20) NOT NULL,
    session character varying(2) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: subject_classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject_classes (
    id character varying(20) NOT NULL,
    subject_id character varying(20) NOT NULL,
    subject_class character varying(1) NOT NULL,
    day public.days NOT NULL,
    session character varying(20) NOT NULL,
    quota numeric(2,0) NOT NULL,
    created_at text NOT NULL,
    updated_at text NOT NULL,
    author character varying(15) NOT NULL
);


ALTER TABLE public.subject_classes OWNER TO postgres;

--
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    id character varying(20) NOT NULL,
    subject_code character varying(10) NOT NULL,
    subject_name text NOT NULL,
    credit character varying(1) NOT NULL,
    semester character varying(1) NOT NULL,
    lecturer character varying(15) NOT NULL,
    created_at text NOT NULL,
    updated_at text NOT NULL,
    author character varying(15) NOT NULL,
    academic_year character varying(20) NOT NULL
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_profiles (
    id character varying(20) NOT NULL,
    "user" character varying(15) NOT NULL,
    total_sks numeric(3,0),
    color_code character varying(7)
);


ALTER TABLE public.user_profiles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id character varying(15) NOT NULL,
    nim character varying(10) NOT NULL,
    password text,
    fullname text NOT NULL,
    role public.roles NOT NULL,
    created_at text NOT NULL,
    updated_at text NOT NULL,
    is_first_login boolean DEFAULT false NOT NULL,
    email text
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: pgmigrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pgmigrations ALTER COLUMN id SET DEFAULT nextval('public.pgmigrations_id_seq'::regclass);


--
-- Data for Name: academic_years; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.academic_years (id, name, semester, created_at, updated_at, is_active) FROM stdin;
ac-4z6imB	2024/2025	Ganjil	2024-10-31T01:44:04.200Z	2024-10-31T01:44:04.200Z	t
\.


--
-- Data for Name: activation_subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activation_subjects (activation_id, subject_id) FROM stdin;
\.


--
-- Data for Name: activations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activations (id, "user", total_payment, status, created_at, updated_at, academic_year, verifier) FROM stdin;
\.


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (id, type, title, body, created_at, updated_at, author, is_deleted) FROM stdin;
\.


--
-- Data for Name: authentications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authentications (token) FROM stdin;
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6InVzZXItS3NURnVxMUR4ciIsInJvbGUiOiJsYWJvcmFudCIsImlhdCI6MTczMDMzOTA0MSwiZXhwIjoxNzMwMzQyNjQxfQ.pYbKqnm8ojfnfWTPh5zGtVBj7kOFxbcaNVcqOsMQ5Y4
\.


--
-- Data for Name: collaborations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collaborations (id, subject_class, assistant, author, created_at) FROM stdin;
\.


--
-- Data for Name: meeting_presences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meeting_presences (meeting_id, user_id, user_device, user_ip, submitted_at, is_attended) FROM stdin;
\.


--
-- Data for Name: pgmigrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pgmigrations (id, name, run_on) FROM stdin;
1	1725759482225_create-table-users	2024-10-31 01:33:52.245452
2	1725759594637_create-table-authentications	2024-10-31 01:33:52.245452
3	1725759681389_create-table-academic-years	2024-10-31 01:33:52.245452
4	1725759833249_create-table-subjects	2024-10-31 01:33:52.245452
5	1725759892734_01_create-table-sessions	2024-10-31 01:33:52.245452
6	1725759892734_02_create-table-subject-class	2024-10-31 01:33:52.245452
7	1725760497744_create-table-activations	2024-10-31 01:33:52.245452
8	1725760789447_create-table-practicum-registrations	2024-10-31 01:33:52.245452
9	1725780261169_create-table-activation-subjects	2024-10-31 01:33:52.245452
10	1726239675737_create-table-announcements	2024-10-31 01:33:52.245452
11	1726240056336_create-table-collaborations	2024-10-31 01:33:52.245452
12	1726240375743_create-table-user-profiles	2024-10-31 01:33:52.245452
13	1727398762726_create-table-practicum-meetings	2024-10-31 01:33:52.245452
14	1727399135853_create-table-meeting-presences	2024-10-31 01:33:52.245452
15	1727749430859_add-column-is-active	2024-10-31 01:33:52.245452
16	1727830661695_create-column-token-on-table-practicum-meetings	2024-10-31 01:33:52.245452
17	1728025337899_create-column-is-attended	2024-10-31 01:33:52.245452
18	1728071792054_add-column-isopened-to-table-practicum-meetings	2024-10-31 01:33:52.245452
\.


--
-- Data for Name: practicum_meetings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.practicum_meetings (id, subject_class, meeting_name, created_at, updated_at, author, token, is_opened) FROM stdin;
\.


--
-- Data for Name: practicum_registrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.practicum_registrations (id, student, practicum_class, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, session, start_time, end_time) FROM stdin;
session-52afhYvKzn	1	07:00:00	08:40:00
session--A_PG9gVUy	2	08:45:00	10:25:00
session-yyXxZR_FRi	3	10:25:00	12:05:00
session-OQ8tC75LvT	4	12:30:00	14:10:00
session-hlcwy8r9cZ	5	14:15:00	16:10:00
session-OqjJDY7loJ	6	16:10:00	17:50:00
\.


--
-- Data for Name: subject_classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subject_classes (id, subject_id, subject_class, day, session, quota, created_at, updated_at, author) FROM stdin;
class-oR3FLElXwF	subject-TsX1ASs6jTw	A	Thursday	session-OQ8tC75LvT	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-Bg_Quq2ow_	subject-5dVg5SFW3zF	A	Friday	session-52afhYvKzn	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-HVwKyv-r8o	subject-5dVg5SFW3zF	B	Friday	session--A_PG9gVUy	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-AmfXhMhgQI	subject-5dVg5SFW3zF	C	Thursday	session-hlcwy8r9cZ	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-QY0v34dOuN	subject-5dVg5SFW3zF	D	Friday	session-hlcwy8r9cZ	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-VMOITbaY9q	subject-p3e4L43iC5d	A	Wednesday	session--A_PG9gVUy	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-8bbUHWk82Y	subject-p3e4L43iC5d	B	Wednesday	session-yyXxZR_FRi	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-yclo8Ed1HZ	subject-p3e4L43iC5d	C	Wednesday	session-OQ8tC75LvT	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-aiDybO1_r7	subject-p3e4L43iC5d	D	Wednesday	session-hlcwy8r9cZ	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-HDeMK4UoPm	subject-WSgm4API-c0	A	Thursday	session-52afhYvKzn	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-aACZohECqV	subject-881uq5V-Ook	A	Wednesday	session-52afhYvKzn	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-Mg9nm3OJNr	subject-rbO69Bzr7nw	C	Thursday	session-yyXxZR_FRi	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-OEJ2cSEGZ6	subject-rbO69Bzr7nw	A	Wednesday	session-OQ8tC75LvT	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-s_2ZJU7zPR	subject-rbO69Bzr7nw	D	Thursday	session-OQ8tC75LvT	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-WL92sdcNRc	subject-rbO69Bzr7nw	B	Wednesday	session-hlcwy8r9cZ	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-qFP1BqhuUC	subject-PuwS08tfEmC	B	Tuesday	session-yyXxZR_FRi	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-enfD3A4wPa	subject-PuwS08tfEmC	C	Tuesday	session-OQ8tC75LvT	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-LTyCSBXvBY	subject-PuwS08tfEmC	A	Tuesday	session-hlcwy8r9cZ	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-QgGfRG-euj	subject-PuwS08tfEmC	D	Tuesday	session-OqjJDY7loJ	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-A0ZNwCXDHW	subject-FwsGpDznwe7	C	Thursday	session--A_PG9gVUy	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-3kuKLn8Jtq	subject-FwsGpDznwe7	E	Wednesday	session--A_PG9gVUy	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-gOVOZAE5I9	subject-FwsGpDznwe7	A	Tuesday	session-yyXxZR_FRi	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-kwkQrC-L7C	subject-FwsGpDznwe7	B	Wednesday	session-yyXxZR_FRi	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-wKKMA1d7Vx	subject-FwsGpDznwe7	D	Tuesday	session-OQ8tC75LvT	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-YWnIWtZ9rd	subject-DqRa2Lj_044	A	Tuesday	session-52afhYvKzn	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-ScEEXJ4Nol	subject-IBW_UE1kgul	D	Tuesday	session-52afhYvKzn	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-f7v1L_yDms	subject-IBW_UE1kgul	B	Friday	session--A_PG9gVUy	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-RTEFWVQYSd	subject-IBW_UE1kgul	C	Thursday	session--A_PG9gVUy	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-NmY4OFVxxg	subject-IBW_UE1kgul	E	Friday	session-OQ8tC75LvT	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-Drwy5AkDNc	subject-IBW_UE1kgul	A	Thursday	session-yyXxZR_FRi	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-Ka_zXEJRXP	subject-LS0bLggabXp	A	Monday	session--A_PG9gVUy	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-Bhpsl6BtaP	subject-LS0bLggabXp	B	Monday	session-yyXxZR_FRi	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-ahSizYv484	subject-LS0bLggabXp	C	Monday	session-OQ8tC75LvT	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-C2zaoke2aO	subject-LS0bLggabXp	D	Monday	session-hlcwy8r9cZ	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
class-A3MvmscLgE	subject-LS0bLggabXp	E	Monday	session-OqjJDY7loJ	38	2024-10-31T09:14:16.Z	2024-10-31T09:14:16.Z	user-KsTFuq1Dxr
\.


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subjects (id, subject_code, subject_name, credit, semester, lecturer, created_at, updated_at, author, academic_year) FROM stdin;
subject-5dVg5SFW3zF	231610331	Dasar Pemrograman	3	1	user-CopnWMOKrS	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
subject-FwsGpDznwe7	231630531	Sistem Basis Data	3	3	user-iSNA8ApXdx	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
subject-IBW_UE1kgul	231630631	Statistika dan Probabilitas	3	3	user-CopnWMOKrS	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
subject-LS0bLggabXp	231630831	Teknologi Web	3	3	user-yxg3lX6quP	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
subject-WSgm4API-c0	231670631	Keamanan Syber	3	7	user-_8IYltguid	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
subject-881uq5V-Ook	231671031	Multimedia Online	3	5	user-PeCKnkAJ8r	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
subject-rbO69Bzr7nw	231650631	Penambangan Data	3	5	user-CopnWMOKrS	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
subject-p3e4L43iC5d	231650231	Infrastruktur TI untuk Organisasi	3	5	user-PeCKnkAJ8r	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
subject-DqRa2Lj_044	231671631	Sistem Informasi Geografis	3	7	user-C3q2knLDgN	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
subject-PuwS08tfEmC	231650731	Pengujian dan Penjaminan Mutu Perangkat Lunak	3	5	user-yxg3lX6quP	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
subject-TsX1ASs6jTw	231640131	Arsitektur Enterprise	3	7	user-9tEOHSVQDZ	2024-10-31T09:04:59.Z	2024-10-31T09:04:59.Z	user-KsTFuq1Dxr	ac-4z6imB
\.


--
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_profiles (id, "user", total_sks, color_code) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, nim, password, fullname, role, created_at, updated_at, is_first_login, email) FROM stdin;
user-CxdOPakwyh	2100016097		Nicko Berli Pradio Utama	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-83Y9Y6oItm	2111016057		Ilham Julaiman	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-HkIArxAhCF	2100016096		Zulfan Faizun Najib	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-v688D_toYn	1900016010		Arief Maulana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-VqlgFEpff7	1900016040		Sarfa	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-2CMw5EjN6Q	1900016173		Agus Nugraha	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-3Ox1bHUKuP	1900016181		Mohammad Anhar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-UKyTWr9IPL	1900016193		Maruf Aliansyah Rumatiga	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-OD2Lq4nV3x	1900016201		Pega Vilova	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-60bqoLBFHP	2000016023		Muhammad Ahal Aisar Rizq	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-6VgPeTPlXO	2000016033		Doddy Prastya	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-FI_Q2Oo3Wn	2000016036		Muhammad Rivaldo	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-wbo8HSY9M4	2000016039		Argo Ndaru Husada	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-IvRatoCjaa	2000016043		Rahmat Ilham Murni	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-l8wILd18SH	2000016058		Rafid Raihan Rabbani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-0rufAlEfJP	2000016070		M Febryan Pramudya	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-dG_fHbVji1	2000016081		Mhd Rizky Akbar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-O4jPuFfBo3	2000016090		Thoriq Azis Hakim El Karim	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-GWgKdBrjcf	2000016099		Muhammad Alahudin Azhar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-9vsXaurDPD	2000016111		Muhammad Nizar Taufiqurahman	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Ye7ZcIGI-w	2000016117		Muhammad Ragil Gari Mukti	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-vrr7CsXhzL	2000016140		Adista Putra Suyatno	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Zs1J1tWpWe	2000016141		Nur Hidayah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-fbhlPvMRZz	2011016066		Raihan Firdaus Wilii	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-l280VhJO-2	2100016004		Wartono	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-QUD2t7xxs5	2100016006		Yustia Muhamad Iqbal	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-owgBuwj4Ja	2100016008		Muhammad Abduh	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-sPRIgDD1vC	2100016009		Yuliana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user--LRss4B228	2100016013		Rafi Ariq Witaqi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-iBUcHj-O93	2100016014		A. Romadhon	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-qpUyPDhPbV	2100016015		Muhammad Naufal Bagaskara	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-NS3qBbchTg	2100016017		Paras Septa	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-RKhCvH7kzb	2100016018		Izzani Fathur Rizky Arifin	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-E7u3YgizwW	2100016020		Giga Jundan Al Huda	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-3NFc_3MYLd	2100016022		Andeyan Maulana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-so2TcT2YOx	2100016025		Muhammad Fachri Hussaini	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-QmW1r2etmK	2100016027		Farida Regina Maharani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-YmaoIpROtc	2100016028		Muhammad Ibnu A	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-z2ygD0QrY6	2100016029		Alvin Yusuf W	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Jqv-PSBdQR	2100016031		Niar Rahmati	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-MfUzngqpxe	2100016033		Muhammad Alfi Muharom	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-XvJC4-bq9d	2100016035		Helen Kayla Sabina Putri Mahendra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-nD26KzM1S5	2100016036		Hanif Amrin Rasyada	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-xov__gTfxz	2100016038		Muhamad Fauzan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-XuBgsAagdm	2100016042		Aninda Putri Ardhana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Epyg_AWB_8	2100016044		Wahyu Yudha Saputra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-kWDsnrJHY_	2100016045		M Ali Mahsun	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-K_xXaJPnb6	2100016060		Ilham Fahmi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-TmiKzbdv9p	2100016062		Gemilang Tirto Ismoyo Santoso	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-1BcfMWdOti	2100016067		Ega Saputra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-9lQMZw6_5X	2100016068		Mesge Bayutara	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-A6yOllwzfH	2100016071		Nur Afi Ardiansyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-AU9zwrPPwc	2100016074		Muslim Safiq	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-dA79dHHfZu	2100016075		Hasna Dhiya Azzahra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-2s4tKlCLM-	2100016076		Dinda Dyah Puspita	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-PPoXfwV99l	2100016082		Fikri Ariansyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-U_0mh_ydhh	2100016084		Hardicka Faturrahman Nugradiono	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-_UZfFQ6byz	2100016085		Muhammad Khrisna	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-6XlgKlDNIO	2100016095		Ana Mufaizah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Bc6XAeZZ5a	2100016098		Intan Aprilia Yudianto	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-aChuQTiFLt	2100016100		Retdsu Apriyansah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-al_RLc3Umk	2100016102		Rico Aji Herlambang	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-jGrg4Rn3f-	2100016104		Abrar Aji Hudayana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-_X4diSga-N	2100016106		Verra Anton Putri	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-guGSmFZYGx	2100016118		Agustinus Pantoro Inti Prasetyo	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-cHQty4a2a9	2100016122		Kafa Nurfadhila	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-V-lMAKPqqz	2100016124		Muhammad Ilham	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-VPEF-zdNQF	2100016127		M Alfarizi Sidiq Rizki	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-t35TvEOAlr	2111016048		Fadli Muzaki	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-IRURqaayK3	2111016050		Anna Maulina	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-GjD8Hwp-dP	2111016052		Nur Fadlilah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-XYJVM3FHU-	2111016053		Zahra Putri Azizah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-FsiZ2dkr0X	2115016108		Balqis Hikmatullah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-NnDHd5q5AJ	2200016001		Adinda Putri Anggraeny Cinta Asmarany Da Silva Ong	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-G4v_MXb06R	2200016002		Ira Hardina	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-zglAZXwPqh	2200016003		Muhammad Gia Vega Nuur Ash Shaff	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-JGkFRfJfxq	2200016004		Weka Hayu Pratista	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-z-x4XrySvF	2200016005		Siti Fatimah Nur Cahya	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-vjvv5uSNWE	2200016006		Ikhsan Bayu Nugroho	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-4qNEdMq9Ce	2200016008		M.Rizkiansyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-jnYZJw7nut	2200016011		Rizky Ayu Bibit Septianie	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-AfQ2owClH4	2200016012		Rizal Mahardika	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-dzS2mWlwMK	2200016013		Muhammad Husaini A Hasan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-xecG0mBM-m	2200016015		Ibnu Kholilu Rahman	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-9KWJmJDK5b	2200016016		Fajar Teguh Permana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-muZ6eS8uIx	2200016017		Elisa Qurrota Ayuni	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-SCc8gn1eDy	2200016018		Mufamum Tamyiz	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-WNAG8E0eDV	2200016020		Debie Riani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-RAf0O9o3sM	2200016021		Irfan Zaenal Arifin	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-f0NTZwphhG	2200016022		Ardan Jaya Arnawa	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-QdlIZh9oYT	2200016023		Candra Valentino	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-WpA1mLV7nO	2200016024		Ruwaeda Wenno	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-mi6VXrQagk	2200016025		M.Subki	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-sUSYSBd0ct	2200016030		Kerfin Aprian	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ns6ivzwcoa	2200016032		Nisa Nur Fadiah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-FfRrSyKCjQ	2200016033		Naufal Fadhlullah Akbar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-up6lCc0eXM	2200016036		Fauzan Budi Attala	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-50txAAgnyb	2200016042		Ahmad Miftahul Huda	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-K10ejk264J	2200016043		Nabhan Surya Permana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-RIwqnQCQIL	2200016044		Rismayanti	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-SRnuWC07_8	2200016045		Ratnasari	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-XphADCznUh	2200016046		Wafiqah Al Atsariyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-7m-J6S-UKP	2200016048		Muhammad Farid Bayu Hadi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-B4S101swG6	2200016049		Elok	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-evBg1CPyKU	2200016052		Veri Riswanto	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ljF2v7GEAs	2200016054		Milzamulhaq	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-mTstpX19pr	2200016055		Laksana Yoga K	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-li5kV6fImG	2200016058		Akmal Irfansyahir	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-R-cfx05bKH	2200016059		Oba Ilo Takbir	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-d-Soh-lBqC	2200016060		Zalfaa Nabilah Nasywah Hajar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-V8NEEbLjL7	2200016061		Faiz Ahmad Yasir Maula	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-jqM0LgNOPu	2200016062		Alfin Nur Muflihin Farhatani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ZTWwQOA2W_	2200016063		Agung Febriansyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Rs0w-Tcw9q	2200016065		Pimpin Dwi Wibowo	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-SWF69JMXio	2200016066		Siti Najwa Rodja	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-vDVWDPMRPz	2200016069		Nurul Aswad Ngabalin	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-aKzcan2DHH	2200016071		Heliosa Atmaja	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-s7rLsIH1uD	2200016073		Yuliana Putri Lestari	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-mIHoTE1Tho	2200016074		Dini Oktivani Nugroho	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ufTMAJzD9V	2200016075		Irfan Rahmadani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-pQrWxQlDJW	2200016076		Azrian Ramadhan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-beX9UN_ZS-	2200016077		Desfian Femas Maulana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-JBnbKsGoQc	2200016078		Moh Haikal Saleh Hamizid	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Qyb3FgJbGO	2200016080		Reza Nagita Nurhazizah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-HZayPTRLVJ	2200016081		Fadillah Al Kautsar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-mAwQAJvA-P	2200016082		Syaila Suryani Ananta	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-2Jr4sInZuH	2200016083		Rizky Farid Alhabani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-NPmAfS753w	2200016084		Eki Riswan Nawawi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-MZBf78ZF0h	2200016085		Zalfa Anazal Adam	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-DscjrSTVJx	2200016086		Lintang Cahya Maharani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-mvP3pKeVtX	2200016088		Muhammad Abdul Jabbar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-vte9Onx5BZ	2200016089		Heltrizulfikar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-r1tt5KF48S	2200016091		Lilia Dewi Ariyanti	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-NMqMHGeIXn	2200016092		Ayyub Abdurrahman	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-NyMsSKPIe4	2200016093		Dianra Aulisyah Tanjung	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-z7lxfXhwFW	2200016094		Reza Diva Alfiansyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-FkCrhwx8UI	2200016095		Muhammad Ichsan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-kfAghEB9oo	2200016096		Saad Zaaghi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-zsF-ivIgGY	2200016097		Dwi Julian Daffa	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Uv6TRNimmA	2200016099		Ricky Tri Budianto	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-e0HzRCnb-j	2200016100		Kumara Fawwas Abhista	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-rXpYc96b_W	2200016102		Muhammad Adib Farhan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-YogcxisUCz	2200016104		Nadia Farah Adiba	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-AFFxF2zZdJ	2200016105		Azimatul Chamidah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-PZg8Tg1Mjz	2200016106		Zahra Agustina	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-yOm3nX2kYl	2200016107		Salma Faradisa Hasan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-FsWir01g85	2200016108		Hanif Auzan Abdillah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-4X4M4Wua0F	2200016110		Muhammad Haikal Saputra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-UtDNDYItdH	2200016111		Agil Firli Gunawan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Ke-xdOS9uz	2200016112		Iman Abdurrohman	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-fb9Mql0bJc	2200016113		Sulci Suharmi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-2d_E59EA6e	2200016114		Aan Dwi Saputra W	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-6P03C-e5-u	2200016115		Adella Caesar Diniartika	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-0oF2lbE6q8	2200016116		Asti Sulistio	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-may_uk0s0c	2200016118		Novia Nirwana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-_dVKLEiGPD	2200016119		Nur Rila Ammalia	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ya3Z32E3_W	2200016122		Zul Fauzi Hanif	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-bXM6KwU6--	2200016123		Finaz Rama Arhan Carni	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-w3sQwpzYhk	2200016124		Ceysha Anindita	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-y2wBw-recG	2200016125		Icca Firstika Wibowo	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-c4SRmGWQi3	2200016126		Syavira Satriani Lestari	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-IDFrT1GuWX	2200016127		Ernandiya Badriatul Khusniyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-gyT_hfss_H	2200016129		Dita Prayuniarti	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-8kmpSrh0fE	2200016131		Alex Arif Setiawan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-82sILY5Zth	2200016132		Ahmad Reza Al Fakarani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-9gu77EoskT	2200016133		Eka Putri Pertiwi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Mw5Lga9s04	2200016137		Shevabey Rahman	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Ll_TFTcXbD	2200016138		Dewi Larasati	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-oREFZO2hmN	2200016139		Muhamad Arif	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-HSp14KNTfP	2200016140		Deli Efrida	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-IoFZ_Wp-05	2200016143		Muh Asrul	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-hV_rxE7sdk	2200016148		Izzuddin Hammam Ulhaq	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-nfglDmOQjb	2200016149		Helfrans Herlando	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-TqhG5BTABU	2200016150		Irsyad Rizqullah Shafwan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-duV3Rfaspl	2200016151		Aminudin Setya Wibawa	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-xw04lKrUUh	2200016152		Akbar Febrian Amar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-9nd2_absYg	2211016028		Sasangka Bagaskara	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-VvBE2VWnCk	2211016029		Nadia Arina Nabila Shofa	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-VEZPnZr_xy	2211016031		Miftahul Rizqha	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-yA_BLYmZ9X	2211016035		Marhama Hasana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Dw5WXmH31J	2215016134		Muhammad Zauro Asshowabi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-8wPMg4J_g_	2215016135		Taufan Ali	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-eUTYn3Xccd	2215016136		Rismayanti Catur Saputri	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Ub1r5k4PNp	2300016003		Aprian Arvisa Mangga	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Sf9EsWy1wL	2300016005		Saiful Nur Aziz	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ukGA7mwh8s	2300016007		Luthfi Komara	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-dZZk0_Wbaj	2300016009		Almirza Putra Linarta	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-vfvOeeDdeh	2300016012		Muhammad Ridhp Adriano	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-lLLZMYEhze	2300016013		Taufik Bagas Anjaya	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-woCF4sK2gT	2300016014		Suri Linda Wati	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Zex-Vl5irR	2300016015		Devin Bagas Pratama	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-iA2kDAGxSZ	2300016016		Muhammad Fitrialdy Indrawan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-8pO1IWaapc	2300016017		Rifki Abdullah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-QYioovLopJ	2300016018		Naufal Fadhli Adyatma	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Y3OBhMeR6I	2300016020		Novalita Rahmadhani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-QkkJmpjshE	2300016021		Adam Bimantara	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-QopoBYqNO3	2300016023		Adinda Hasna Aulia	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ZiZ1YD37fO	2300016024		Naiya Agiva	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-jOe6NPwDPj	2300016025		Fernanda Rahmansyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ycggMcSQQ7	2300016026		Fikri Ihsan Nurzaki	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-tdWywk8bea	2300016028		Riska Ayu Kusumaningrum	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-0inhMuh1Xi	2300016029		Mohd. Haikal	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-oVAKiY9uRx	2300016031		Mohammad Arief Gunadi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-zoAjzuy0JB	2300016032		Raja Zhafif Raditya Harahap	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-m3Vto1y3ET	2300016033		Linda Fitriani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-3JEmcChss5	2300016034		Pramudinhaq Fratavni	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-b9KVTLVXIR	2300016035		Alvindra Ramadhan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-6__mbSEdYM	2300016036		Muhammad Daffa Aqila Ulayya	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-uVpDCdm7rn	2300016037		Muhammad Ghifaro Sandy Wibowo	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-HM6u30uQfh	2300016039		Lina Sapitri	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-tIGGC4lpNh	2300016041		Rini Tri Ariska	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-qDOyiZlcSc	2300016042		Syafiq Fahrizal Rozaq	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-drP3JyC4TC	2300016043		Bintang Raif Fauzan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-cV_okHbctD	2300016045		Muhammad Ibnu Zappriliannur Syadin	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-0HqZ1s8-p_	2300016046		Safarudin	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-9Z-V5OqKOm	2300016047		Viranti Deratia Akbari	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ntHGHmM2pI	2300016048		Jeandrie Fitoy	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-OW7NyJefwM	2300016049		Cinta Fatwa Aulia Nur Fadhilah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-5ywDiENwBc	2300016050		Hendrian Yudha Pratama	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-DYzcW-nOcp	2300016051		Satria	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-wsYsHg961f	2300016053		Ardiansyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ptMJtbJ2JD	2300016054		Adelia Rahma Saputri	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-a6ts8tAytJ	2300016055		Mhd Rafy Firdaus	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-IWhrGTF54y	2300016057		Wahyu Hardiyantara	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-vEoOnP5_Uj	2300016059		Davin Vergian Rizapratama	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-PVGePbaKh7	2300016062		Sagara Imam Samudra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-HsU__3CbNL	2300016063		Faturahman Dwi Saputra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-SQP3Hpdrc8	2300016064		Yuniasari	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-P0ggWsy9pZ	2300016065		M Syukron	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-9mLZjtacVC	2300016066		Khalish Ajhar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-8hW5MRb5WL	2300016067		Lingga Bangun Laksana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Am6yJfPDzy	2300016068		Muhamad Bintang	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ur-oxH0RHq	2300016070		Tiens Vicky FaΓÇÖZiah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-TO_FR5RgcC	2300016071		Fenzy Septia Marthanti	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-xRVBTqLldc	2300016072		Zahrah Salsabila Dhia Ichsandi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-tksdtUElHc	2300016073		Muhammad Annaafi Putra Syabani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-GunO3Dz4NO	2300016074		Lalu Atwi Suparman	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-bSRGEm2wgi	2300016077		Jovan Prasetyo Wibisono	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Mh-TJCllUu	2300016078		Dzaky Abdurrahman Tsani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-xM2hxp9v2Y	2300016079		Rohmah Mufidah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-DCxjWJfcZI	2300016080		Nafisah Fathimatus Zahra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-hmcTfapdjL	2300016081		Rohid Ade Pratama	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-uu5iT9QAVN	2300016082		Rizky Darma Surya	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-U5-fHPMPBe	2300016083		Muhammad Faiz Rabbany	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user--AWYN6feg-	2300016084		Salsabila Azzahra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-2Nq_xdSaRE	2300016085		Akbar Yudho Intiyo	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-6al8KAKYAm	2300016086		Rifal Siammaseang	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-yrzKcgHKJv	2300016087		Mohammad Rafli Hajat Negara	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-NGFqCzyaSX	2300016088		Ahmad Taufik Hidayat	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-BAAvjD6uLl	2300016089		Keysha Najla Tabitha	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user--NePfX7trM	2300016091		Az Zikra Farras Arsyaputra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-W__83g2msH	2300016092		Agustin Salsabilla	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-pqUu7_PeXl	2300016093		Lutfiah Aulia	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-3XtZUqgZhd	2300016096		Kanza Cahya Pratama	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-pjTy2QTH0F	2300016097		Amanah Oktamiarni	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-0pBtadbmvC	2300016098		Muhammad Alif	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-pnvUO5fcrG	2300016099		Elicia Melani Putri Ayunindya	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-VL7BQPTJ62	2300016101		Farhan Zhuri Parmestu	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-weezvB-Tix	2300016102		Burhanudinn Subekti	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-D3avIIc7xe	2300016104		Andang Purwanto	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ykg14x3JUt	2300016105		Achmad Wildan Adila El Hakim	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-IIaFumT_65	2300016107		Lily Putri Andini	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-PSm7Wuej2f	2300016108		Adri Ihwan Hidayah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-4m2FjqiDP9	2300016109		Muhammad Nabil Niode	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-sxf4Cksw_T	2300016110		Faiqah Gusmarianty	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-llG2QJKVzM	2300016112		Rusniyati Rumodar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-AUeeRLJ_id	2300016113		Faradis Putra Aditia Assagaf	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-mDsnc9vHPw	2300016114		Listiana Meilani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-3eso5P5Uh9	2300016115		Aminah Alfi Zuriah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-bVxxcw54C8	2300016117		Grahita Humaira Nasywa Putri	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-tQ3TRvjCGz	2300016118		Indi Nuraeni	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-4ugV0F3AMW	2300016119		Ahmad Rosady	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-QD7M24EVYB	2300016120		Andini Oktapiani Ramadhan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-is2G4uTq93	2300016121		I Wayan Dibia Wiraatmaja	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ZhsvexlXEZ	2300016122		Fhika Fezya Amesha	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-0DoVGgbuss	2300016123		M Riski Al Munawar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Cosq6cY8mW	2300016124		Rizki Yoga Pratama	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-6pa7YKWfif	2300016126		Habib Al Wasil	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-1_mKNLmYFD	2300016127		HAFIDZ SHANDY YAHYA	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-dkjVYYRgT6	2300016128		Falisa Alfiani Heriansyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-H9hedqllSy	2300016129		Yoga Pangestu	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-d9K1Q_34z-	2300016130		Muhammad Zhaqy Wilson	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-g8Px445cC6	2300016131		Aidh Fadhol Alkhairi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Gy8ysnHMQM	2300016133		Bintang Deprian	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-_D-3cerQrt	2300016134		M.Aldi Fathurroji	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-VjCoX5zJY3	2300016135		Aliya Qurrota Ayun	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-hFo9LhlVau	2300016136		Danesta Dhafin	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-dKSSPGynSd	2300016137		Moh Dzikry Pradana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-oQ7XKL3Ipp	2300016138		Audila Khasna Nauroh	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-FD_4l8mfGH	2300016139		Azkha Adyaksa Raif	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-_cpqckqHhX	2300016140		Mahesa Yoga	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-jzQmJzB--A	2300016141		Turki Alfaen Damanik	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-lsY3QRTp-p	2300016142		Yoga Adi Pamungkas	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-gKv3Z6YN7P	2300016143		Rafi Amrullah Al-Baihaqi Gunawan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-KZz7RnkJNI	2300016145		Nazala Furqon	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Sv-bmwO3pk	2300016147		Muhammad Dzakwan Afif	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-WRuoYHM-gB	2300016148		Adi Arwan Syah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-R0Ibg9Jcnv	2300016149		Rachmad Eka Putra Ramadhan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Hpjp9V7bpZ	2300016150		Ahmad Haidar Zaidan Ammar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-GpMV7FGxDA	2300016151		Heri Arista	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-c160_ObIxM	2300016152		Bayu Milhan Khoirudin	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-mkRGNbmP07	2300016153		Raya Ripki Ramdani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ET8yXI_sT4	2300016154		Marwinda	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-cAKYrNtTRt	2300016155		Annas Fatihur Rahman	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-CIY7wj5O72	2300016156		M. Yusuf Ardabili	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-QduDJDtu7H	2300016157		Jhoyce Augusthia Rhaffael	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-8ONYcuEIeq	2300016158		Mada Ihsan Wicaksono	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-P1RKL_7TjA	2300017075		Aufa Dzaki Alfitra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-AKg5Ms6hod	2311016058		Muhammad Zidan Assyafi Saputra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-EpLBsg_6Gk	2311016061		Naufal Adna Garibaldi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Zjc-444TQK	2315016160		Rahadian Candra Vima Yoga	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-26C1Tz5Bge	2315016161		Dewi Maharani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Cqd3Q5Lkvh	2338016159		Faishal Abyan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-STvUKelOsS	2400016001		Sofa Chasani Wibisono	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-u0dIhOmtyy	2400016002		Grandy Tangguh Heldiyan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-JD4Lq0kM4r	2400016003		Dini Nur Aulia	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-5RIQeYD0--	2400016005		Andika	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user--2ogUhQMBi	2400016006		Arjuna	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-1iPh8wp3sj	2400016008		Bahaudin Gustantowi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-4NQDxV59wH	2400016010		Muhammad Zidan Awwalu Naja	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-t1PQW1Y4jC	2400016011		Ridho Kurniawan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-oI3c-PYOFp	2400016012		Meylani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-qKmujSaq7d	2400016013		Ichasia Nazahrani Widian	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-2M1neXp9Oj	2400016014		Herissa Zaskia Larasati	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-EDke5w_PX_	2400016015		Abdul Hakim	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-aQqsD4SnUA	2400016016		Idien Bahran	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-dyzVn-Q5XA	2400016018		Ariani Putri Andini	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-9X5zfiu_OO	2400016019		Farah Amaliya Isrofah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-dX2sKM5lUh	2400016020		Naedhiah Mokessa Della	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-6al0V9XCa3	2400016021		Putri Miftakhul Jannah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-oocjgI5TA-	2400016022		Aditya Sapta Pratama	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-PATHXS7YdU	2400016023		Zulfah Alfa Sanah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-CAWmPArZ7G	2400016025		Zulfan Haidar Hammam	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-1Zfj-diYcM	2400016026		Andrean Dwi Julyan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-TgN6toRFKH	2400016028		Salsa Khaerunnisa	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-nh-tyXK_hl	2400016030		Dimaz Nugraha Putra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-fBVNqRcwV4	2400016031		Vitasari	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ylm4BeqZuO	2400016032		Sri Hanifah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-jWs8r5Y2r0	2400016034		Muhammad Fadhlan Al-Falaq	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-0WCbHmlEaM	2400016035		Yoga Wahyu Prabowo	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-_vwkl9cA0J	2400016037		Edi Wiyono	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-5y6Psf3tRS	2400016038		Muhammad Lexi Athaillah Najih	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-st7LYOd1LJ	2400016039		Ahmad Zaki Muafa	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-kAgBDq21Qw	2400016040		Alfiardi Yuangga Saputra	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-H7QUcqSif7	2400016041		Nur Mahmudi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-RB9M426jVL	2400016043		Riza Annafila Balqis	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-CQgt9O4Vhn	2400016044		Adrian Fathir Firmansyah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-IBOfmLPhpC	2400016046		Fikri Ilham	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-HFy-xOj2WS	2400016048		Muhammad Zaky Hafizan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-4QHwLoXjif	2400016049		Fadil Muhammad	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-PFVN2xfTZt	2400016050		Dimas Nicky Budi Prasetyo	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-yEc04Cohgk	2400016051		Kesya Alleta Arizona	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-fBoBW8NdI-	2400016052		M.Raihan Najwa	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-TzRqREoBdi	2400016053		Pandu Kartika Dewa	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-CxtJwlRSa1	2400016054		Citra Gita Nirmala Sully	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-zz1pfKgxCp	2400016055		Aldi Mustarih	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-f-b6B4x_ZU	2400016057		Hafidz Abdul Rouf	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ggrEV3XSoy	2400016058		Alvia Fatma Suttawati	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-YueabNRaN0	2400016059		Muhammad Harsha	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-LFLL3WtSbD	2400016060		Devi Puspa Rosalinda	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-UAwcOsG8dd	2400016062		Odisea Ega Dero Dzakiy	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-6K1s0OvIfr	2400016063		Rizka Maliza	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-BeObFP_M7F	2400016064		Laura Olivia	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-LTdPZlp52P	2400016065		M Wildan Ahsan Fathurrozak	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-5YWiVm9G3-	2400016066		Liviya Afriani Pratama	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-RSovtr0aWj	2400016067		Imam Faqih Masduqi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-yI6AXzrcfp	2400016068		Ahmad Fauzan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-JchETAdDOJ	2400016069		Anggraeni Putri Hartadi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-bnKva2XZu2	2400016070		Dadan Julianto	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-XRa5de3lBF	2400016071		Dyah Amarruli	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-BBV5TZy1Vj	2400016072		Sintya Gati Hananingtyas	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-g8v1s0T49X	2400016073		Muhammad Fauzi Al Bukhari	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-BCyhZVi-S7	2400016074		Varsi Karuniawati	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-PfZ5Yl1nCd	2400016075		Helen Noya	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-pmElaC_VKP	2400016076		M Ryan Grandis	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-wRz7gH50J3	2400016077		Abil Sabilillah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Xc32nPBmWt	2400016078		Fiky Ramahdani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-3Te_OQFZDF	2400016079		Rosiana Abdullah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-x7qmtWGKQw	2400016081		Franchisco Dabutar	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-zzBNB7mcHk	2400016082		Muhammad Hanzhalah Nala	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-UEz1X9qKlz	2400016083		Rifa Ananda Wahyuri	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-j_iAAvvkQa	2400016084		Yoleta Aisha Setyorini	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-rzdrM2aIxL	2400016085		Farhan Hanif El - Zaki	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-t7l50bgo1g	2400016087		Muhammad Harits Arrozzaq	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-nzxMPUc8-N	2400016088		Royan Junda Prastowo Wicaksono	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-WRMwEWlTSP	2400016089		Ahmad Raka Putra Pratama	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-AmfdJMfq_I	2400016090		Akmaliyah Hidayatul Jannah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-UNdpWVHQge	2400016091		Zakwan Diaul Ikhsan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-As5iu7zz_d	2400016092		Nova Syafa Calista	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-8Z2AjjUI-w	2400016093		Kanaya Ailsa Sudarjono	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-oiy5CCC8Ql	2400016095		Neil Melikah Fitri Sum	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-ZYb_2LPF8F	2400016096		Rafi Yudistira Prasetyo	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-HxrX9tiaxD	2400016097		Fatiya Dwi Putri Sandya Pongolou	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-hUmS6ZB-yT	2400016098		Dama Palerian	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-mSe6zSQJCm	2400016103		Denta Wijaya	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-CdDcyLm8j7	2400016104		Dini Mutmainah Gafur	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-aTSQNJ-eHp	2411016033		Fairuz Farah Mukti	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-5NVeVY2VDo	2411016036		Yusuf Ariffandi	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-nbnfenJ3HT	2415016099		Erika Ayu Febrianti	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-itPJkvMQIE	2415016100		Dio Lutvi Andre	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-IfNJY0CFW0	2415016101		Frizi Al Husaini	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Efm-CQ3MmF	2415016102		Suci Sulistyowati	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-WKSL8FQJsP	2438016017		M. Anang Alief Al Ikhsan Setiawan	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-3whwNaDOzR	2438016047		Nazwa Meilany Fauziah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-GZp2rLIFIr	2438016086		Achmad Nur Alamsah	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-0L_KSf5ver	AR		Arif Rahman	lecturer	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-PeCKnkAJ8r	MWH		Mursid Wahyu Hananto	lecturer	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-yxg3lX6quP	FRD		Farid Suryanto	lecturer	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-9tEOHSVQDZ	SHN		Sri Handayaningsih	lecturer	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-C3q2knLDgN	SUP		Suprihatin	lecturer	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-iSNA8ApXdx	TWR		Tawar	lecturer	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-CopnWMOKrS	ITR		Iwan Tri Riyadi Yanto	lecturer	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-_8IYltguid	IRD		Imam Riadi	lecturer	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-vcETQJGkiC	2200016056		Laksana Yoga K	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-_UfwSZwMN9	2100016037		Almeyda Alfianto	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Z9HWsDUEcv	2111016049		Thoriqin Maulana Ishaq 	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-Nv3l3yiBpk	2100016001		Dila Erisma Septiana	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-R8G5FK5l8t	2100016091		Siska Anggita	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-4H3FdsijCK	2115016112		SYAFRILLAH NAJJAR	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-dsWdewaO4a	2100016091		Siska Anggita	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-_Et_NYdz1s	2100016051		Nur Wahyu Suci Rahayu	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-MzZCO5DDyQ	2100016055		Lala Indriani Rahman	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-k_eVkxWyMh	2100016119		Wulan Ajianti	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-gE_U2Un6BY	2100016012		Fhira Triana Maulani	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-1d9lzgInts	2100016099		Adelia Siska Ayu	student	2024-10-31T08:40:59.Z	2024-10-31T08:40:59.Z	f	
user-KsTFuq1Dxr	laboran2	$2b$10$CiiLj5iAbtFO5WB4Gd8KTeqk7tgZ.y.NugG1PlrqLRkzs3PQOsy8q	Djoko Imam	laborant	2024-10-31T01:42:57.822Z	2024-10-31T01:42:57.822Z	f	email@gmail.com
user-n3p1QKb0dy	1611016083	$2b$10$rjqkSLkO7cmK0StB3LSrf.TBAhRGguqAhWk2AzRV5LXHLyW6/fUHS	Imam Samudra Pasang	student	2024-10-31T01:43:28.576Z	2024-10-31T01:43:28.576Z	f	katanya@gmail.com
\.


--
-- Name: pgmigrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pgmigrations_id_seq', 18, true);


--
-- Name: academic_years academic_years_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.academic_years
    ADD CONSTRAINT academic_years_pkey PRIMARY KEY (id);


--
-- Name: activations activations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activations
    ADD CONSTRAINT activations_pkey PRIMARY KEY (id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: collaborations collaborations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaborations
    ADD CONSTRAINT collaborations_pkey PRIMARY KEY (id);


--
-- Name: pgmigrations pgmigrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pgmigrations
    ADD CONSTRAINT pgmigrations_pkey PRIMARY KEY (id);


--
-- Name: practicum_meetings practicum_meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practicum_meetings
    ADD CONSTRAINT practicum_meetings_pkey PRIMARY KEY (id);


--
-- Name: practicum_registrations practicum_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practicum_registrations
    ADD CONSTRAINT practicum_registrations_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: subject_classes subject_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_classes
    ADD CONSTRAINT subject_classes_pkey PRIMARY KEY (id);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: activation_subjects activation_subjects.activation_id_to_activations.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activation_subjects
    ADD CONSTRAINT "activation_subjects.activation_id_to_activations.id" FOREIGN KEY (activation_id) REFERENCES public.activations(id) ON DELETE CASCADE;


--
-- Name: activation_subjects activation_subjects.subject_id_to_subjects.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activation_subjects
    ADD CONSTRAINT "activation_subjects.subject_id_to_subjects.id" FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- Name: activations activations.user_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activations
    ADD CONSTRAINT "activations.user_to_users.id" FOREIGN KEY ("user") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: activations activations.verifier_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activations
    ADD CONSTRAINT "activations.verifier_to_users.id" FOREIGN KEY (verifier) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: announcements announcements.author_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT "announcements.author_to_users.id" FOREIGN KEY (author) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: collaborations collaborations.assistant_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaborations
    ADD CONSTRAINT "collaborations.assistant_to_users.id" FOREIGN KEY (assistant) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: collaborations collaborations.author_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaborations
    ADD CONSTRAINT "collaborations.author_to_users.id" FOREIGN KEY (author) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: collaborations collaborations.subject_class_to_subject_classes.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collaborations
    ADD CONSTRAINT "collaborations.subject_class_to_subject_classes.id" FOREIGN KEY (subject_class) REFERENCES public.subject_classes(id) ON DELETE CASCADE;


--
-- Name: activations fk_activations.academic_year_to_academic_years.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activations
    ADD CONSTRAINT "fk_activations.academic_year_to_academic_years.id" FOREIGN KEY (academic_year) REFERENCES public.academic_years(id) ON DELETE CASCADE;


--
-- Name: subject_classes fk_subject_classes.author_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_classes
    ADD CONSTRAINT "fk_subject_classes.author_to_users.id" FOREIGN KEY (author) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: subject_classes fk_subject_classes.session_to_sessions.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_classes
    ADD CONSTRAINT "fk_subject_classes.session_to_sessions.id" FOREIGN KEY (session) REFERENCES public.sessions(id) ON DELETE CASCADE;


--
-- Name: subject_classes fk_subject_classes.subject_id_to_subjects.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_classes
    ADD CONSTRAINT "fk_subject_classes.subject_id_to_subjects.id" FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- Name: subjects fk_subjects.academic_year_to_academic_years.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT "fk_subjects.academic_year_to_academic_years.id" FOREIGN KEY (academic_year) REFERENCES public.academic_years(id) ON DELETE CASCADE;


--
-- Name: subjects fk_subjects.author_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT "fk_subjects.author_to_users.id" FOREIGN KEY (author) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: subjects fk_subjects.lecturer_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT "fk_subjects.lecturer_to_users.id" FOREIGN KEY (lecturer) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: meeting_presences meeting_presences.meeting_id_to_practicum_meetings.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting_presences
    ADD CONSTRAINT "meeting_presences.meeting_id_to_practicum_meetings.id" FOREIGN KEY (meeting_id) REFERENCES public.practicum_meetings(id) ON DELETE CASCADE;


--
-- Name: meeting_presences meeting_presences.user_id_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeting_presences
    ADD CONSTRAINT "meeting_presences.user_id_to_users.id" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: practicum_meetings practicum_meetings.author_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practicum_meetings
    ADD CONSTRAINT "practicum_meetings.author_to_users.id" FOREIGN KEY (author) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: practicum_meetings practicum_meetings.subject_class_to_subject_classes.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practicum_meetings
    ADD CONSTRAINT "practicum_meetings.subject_class_to_subject_classes.id" FOREIGN KEY (subject_class) REFERENCES public.subject_classes(id) ON DELETE CASCADE;


--
-- Name: practicum_registrations practicum_registrations.practicum_class_to_subject_classes.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practicum_registrations
    ADD CONSTRAINT "practicum_registrations.practicum_class_to_subject_classes.id" FOREIGN KEY (practicum_class) REFERENCES public.subject_classes(id) ON DELETE CASCADE;


--
-- Name: practicum_registrations practicum_registrations.student_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.practicum_registrations
    ADD CONSTRAINT "practicum_registrations.student_to_users.id" FOREIGN KEY (student) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_profiles user_profiles.user_to_users.id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT "user_profiles.user_to_users.id" FOREIGN KEY ("user") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

