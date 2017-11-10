--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.3

-- Started on 2017-11-10 08:47:18

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE pythia;
--
-- TOC entry 3087 (class 1262 OID 16390)
-- Name: pythia; Type: DATABASE; Schema: -; Owner: pythiaservice
--

CREATE DATABASE pythia WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE pythia OWNER TO pythiaservice;

\connect pythia

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 16399)
-- Name: project; Type: SCHEMA; Schema: -; Owner: pythiaservice
--

CREATE SCHEMA project;


ALTER SCHEMA project OWNER TO pythiaservice;

--
-- TOC entry 1 (class 3079 OID 13308)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3090 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = project, pg_catalog;

--
-- TOC entry 578 (class 1247 OID 16939)
-- Name: status_enum; Type: TYPE; Schema: project; Owner: pythiaservice
--

CREATE TYPE status_enum AS ENUM (
    'WAITING_FOR_APPROVAL',
    'APPROVED',
    'REVERTED'
);


ALTER TYPE status_enum OWNER TO pythiaservice;

--
-- TOC entry 197 (class 1255 OID 16931)
-- Name: deleteall(); Type: FUNCTION; Schema: project; Owner: pythiaservice
--

CREATE FUNCTION deleteall() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
delete from project.sister_project;
delete from project.ptext;
delete from project.plan;
delete from project.project;
END$$;


ALTER FUNCTION project.deleteall() OWNER TO pythiaservice;

SET search_path = public, pg_catalog;

--
-- TOC entry 196 (class 1255 OID 16930)
-- Name: deleteall(); Type: FUNCTION; Schema: public; Owner: pythiaservice
--

CREATE FUNCTION deleteall() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
Delete from project.sister_project;
END$$;


ALTER FUNCTION public.deleteall() OWNER TO pythiaservice;

--
-- TOC entry 195 (class 1255 OID 16929)
-- Name: deleteclient(); Type: FUNCTION; Schema: public; Owner: pythiaservice
--

CREATE FUNCTION deleteclient() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
Delete from project.sister_project;
END$$;


ALTER FUNCTION public.deleteclient() OWNER TO pythiaservice;

SET search_path = pg_catalog;

--
-- TOC entry 2887 (class 2605 OID 16964)
-- Name: CAST (character varying AS project.status_enum); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (character varying AS project.status_enum) WITH INOUT AS IMPLICIT;


SET search_path = project, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 193 (class 1259 OID 16980)
-- Name: plan; Type: TABLE; Schema: project; Owner: pythiaservice
--

CREATE TABLE plan (
    plan_id bigint NOT NULL,
    project_id bigint,
    main_no smallint,
    sub_no smallint,
    version smallint,
    pdf_url character varying,
    xml_url character varying,
    status status_enum,
    created_at timestamp with time zone,
    created_by character varying,
    updated_at timestamp with time zone,
    updated_by character varying,
    deleted boolean,
    maintenance_duty boolean,
    street_management_decision timestamp with time zone
);


ALTER TABLE plan OWNER TO pythiaservice;

--
-- TOC entry 194 (class 1259 OID 16994)
-- Name: latest_plans; Type: VIEW; Schema: project; Owner: pythiaservice
--

CREATE VIEW latest_plans AS
 SELECT p1.plan_id,
    p1.project_id,
    p1.main_no,
    p1.sub_no,
    p1.version,
    p1.pdf_url,
    p1.xml_url,
    p1.status,
    p1.created_at,
    p1.created_by,
    p1.updated_at,
    p1.updated_by,
    p1.deleted,
    p1.maintenance_duty,
    p1.street_management_decision
   FROM (( SELECT max(p2.version) AS maxversion,
            p2.main_no,
            p2.sub_no
           FROM plan p2
          WHERE (p2.deleted = false)
          GROUP BY p2.main_no, p2.sub_no) tmp
     JOIN plan p1 ON (((p1.main_no = tmp.main_no) AND (p1.sub_no = tmp.sub_no) AND (p1.version = tmp.maxversion))))
UNION ALL
 SELECT p1.plan_id,
    p1.project_id,
    p1.main_no,
    p1.sub_no,
    p1.version,
    p1.pdf_url,
    p1.xml_url,
    p1.status,
    p1.created_at,
    p1.created_by,
    p1.updated_at,
    p1.updated_by,
    p1.deleted,
    p1.maintenance_duty,
    p1.street_management_decision
   FROM (( SELECT (max(p2.version) - 1) AS maxversion,
            p2.main_no,
            p2.sub_no
           FROM plan p2
          WHERE (p2.deleted = false)
          GROUP BY p2.main_no, p2.sub_no) tmp
     JOIN plan p1 ON (((p1.main_no = tmp.main_no) AND (p1.sub_no = tmp.sub_no) AND (p1.version = tmp.maxversion))));


ALTER TABLE latest_plans OWNER TO pythiaservice;

--
-- TOC entry 188 (class 1259 OID 16749)
-- Name: plan_serial; Type: SEQUENCE; Schema: project; Owner: pythiaservice
--

CREATE SEQUENCE plan_serial
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE plan_serial OWNER TO pythiaservice;

--
-- TOC entry 190 (class 1259 OID 16764)
-- Name: pmap_serial; Type: SEQUENCE; Schema: project; Owner: pythiaservice
--

CREATE SEQUENCE pmap_serial
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE pmap_serial OWNER TO pythiaservice;

--
-- TOC entry 187 (class 1259 OID 16747)
-- Name: proj_serial; Type: SEQUENCE; Schema: project; Owner: pythiaservice
--

CREATE SEQUENCE proj_serial
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE proj_serial OWNER TO pythiaservice;

--
-- TOC entry 186 (class 1259 OID 16729)
-- Name: project; Type: TABLE; Schema: project; Owner: pythiaservice
--

CREATE TABLE project (
    project_id bigint NOT NULL,
    hansu_project_id character varying,
    main_no smallint,
    name character varying,
    description character varying,
    completed boolean,
    created_at timestamp with time zone,
    created_by character varying,
    updated_at timestamp with time zone,
    updated_by character varying
);


ALTER TABLE project OWNER TO pythiaservice;

--
-- TOC entry 191 (class 1259 OID 16912)
-- Name: ptex_serial; Type: SEQUENCE; Schema: project; Owner: pythiaservice
--

CREATE SEQUENCE ptex_serial
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE ptex_serial OWNER TO pythiaservice;

--
-- TOC entry 192 (class 1259 OID 16914)
-- Name: ptext; Type: TABLE; Schema: project; Owner: pythiaservice
--

CREATE TABLE ptext (
    text_id bigint NOT NULL,
    plan_id bigint,
    url character varying,
    approved boolean,
    created_at timestamp with time zone,
    created_by character varying,
    updated_at timestamp with time zone,
    updated_by character varying,
    ptext character varying
);


ALTER TABLE ptext OWNER TO pythiaservice;

--
-- TOC entry 189 (class 1259 OID 16759)
-- Name: sister_project; Type: TABLE; Schema: project; Owner: pythiaservice
--

CREATE TABLE sister_project (
    id bigint NOT NULL,
    project_id bigint,
    sister_project_id bigint
);


ALTER TABLE sister_project OWNER TO pythiaservice;

--
-- TOC entry 2963 (class 2606 OID 16987)
-- Name: plan planid_pri; Type: CONSTRAINT; Schema: project; Owner: pythiaservice
--

ALTER TABLE ONLY plan
    ADD CONSTRAINT planid_pri PRIMARY KEY (plan_id);


--
-- TOC entry 2957 (class 2606 OID 16763)
-- Name: sister_project project_pri; Type: CONSTRAINT; Schema: project; Owner: pythiaservice
--

ALTER TABLE ONLY sister_project
    ADD CONSTRAINT project_pri PRIMARY KEY (id);


--
-- TOC entry 2955 (class 2606 OID 16736)
-- Name: project projectid_pri; Type: CONSTRAINT; Schema: project; Owner: pythiaservice
--

ALTER TABLE ONLY project
    ADD CONSTRAINT projectid_pri PRIMARY KEY (project_id);


--
-- TOC entry 2960 (class 2606 OID 16921)
-- Name: ptext ptext_pri; Type: CONSTRAINT; Schema: project; Owner: pythiaservice
--

ALTER TABLE ONLY ptext
    ADD CONSTRAINT ptext_pri PRIMARY KEY (text_id);


--
-- TOC entry 2961 (class 1259 OID 16988)
-- Name: plan_id; Type: INDEX; Schema: project; Owner: pythiaservice
--

CREATE INDEX plan_id ON plan USING btree (plan_id);


--
-- TOC entry 2953 (class 1259 OID 16745)
-- Name: project_index; Type: INDEX; Schema: project; Owner: pythiaservice
--

CREATE INDEX project_index ON project USING btree (project_id);


--
-- TOC entry 2958 (class 1259 OID 16927)
-- Name: ptext_ind; Type: INDEX; Schema: project; Owner: pythiaservice
--

CREATE INDEX ptext_ind ON ptext USING btree (text_id);


--
-- TOC entry 2964 (class 2606 OID 16778)
-- Name: sister_project project_fkey; Type: FK CONSTRAINT; Schema: project; Owner: pythiaservice
--

ALTER TABLE ONLY sister_project
    ADD CONSTRAINT project_fkey FOREIGN KEY (project_id) REFERENCES project(project_id) MATCH FULL;


--
-- TOC entry 3089 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: Pythia
--

GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2017-11-10 08:47:29

--
-- PostgreSQL database dump complete
--

