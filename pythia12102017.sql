-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.8.2
-- PostgreSQL version: 9.5
-- Project Site: pgmodeler.com.br
-- Model Author: ---

-- object: pythiaservice | type: ROLE --
-- DROP ROLE IF EXISTS pythiaservice;
CREATE ROLE pythiaservice WITH 
	CREATEDB
	CREATEROLE
	LOGIN
	UNENCRYPTED PASSWORD 'pythiaservice';
-- ddl-end --

-- Appended SQL commands --
GRANT CONNECT, CREATE
ON DATABASE pythia TO pythiaservice;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA project TO pythiaservice;
-- ddl-end --


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: new_database | type: DATABASE --
-- -- DROP DATABASE IF EXISTS new_database;
-- CREATE DATABASE new_database
-- ;
-- -- ddl-end --
-- 

-- object: project | type: SCHEMA --
-- DROP SCHEMA IF EXISTS project CASCADE;
CREATE SCHEMA project;
-- ddl-end --
ALTER SCHEMA project OWNER TO pythiaservice;
-- ddl-end --

SET search_path TO pg_catalog,public,project;
-- ddl-end --

-- object: project.project | type: TABLE --
-- DROP TABLE IF EXISTS project.project CASCADE;
CREATE TABLE project.project(
	project_id bigint NOT NULL,
	hansu_project_id varchar,
	main_no smallint,
	name varchar,
	description varchar,
	completed boolean,
	created_at timestamptz,
	created_by varchar,
	updated_at timestamptz,
	updated_by varchar,
	CONSTRAINT projectid_pri PRIMARY KEY (project_id)

);
-- ddl-end --
ALTER TABLE project.project OWNER TO pythiaservice;
-- ddl-end --

CREATE TYPE status_enum AS ENUM ('WAITING_FOR_APPROVAL', 'APPROVED', 'REVERTED');

-- object: project.plan | type: TABLE --
-- DROP TABLE IF EXISTS project.plan CASCADE;
CREATE TABLE project.plan(
	plan_id bigint NOT NULL,
	project_id bigint,
	main_no smallint,
	sub_no smallint,
	version smallint,
	url varchar,
	plan_status project.status_enum,
	created_at timestamptz,
	created_by varchar,
	updated_at timestamptz,
	updated_by varchar,
	deleted boolean,
	CONSTRAINT planid_pri PRIMARY KEY (plan_id)

);
-- ddl-end --
ALTER TABLE project.plan OWNER TO pythiaservice;
-- ddl-end --

-- object: project_index | type: INDEX --
-- DROP INDEX IF EXISTS project.project_index CASCADE;
CREATE INDEX project_index ON project.project
	USING btree
	(
	  project_id
	);
-- ddl-end --

-- object: plan_id | type: INDEX --
-- DROP INDEX IF EXISTS project.plan_id CASCADE;
CREATE INDEX plan_id ON project.plan
	USING btree
	(
	  plan_id
	);
-- ddl-end --

-- object: project.proj_serial | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS project.proj_serial CASCADE;
CREATE SEQUENCE project.proj_serial
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE project.proj_serial OWNER TO pythiaservice;
-- ddl-end --

-- object: project.plan_serial | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS project.plan_serial CASCADE;
CREATE SEQUENCE project.plan_serial
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE project.plan_serial OWNER TO pythiaservice;
-- ddl-end --

-- object: project.ptext | type: TABLE --
-- DROP TABLE IF EXISTS project.ptext CASCADE;
CREATE TABLE project.ptext(
	text_id bigint NOT NULL,
	ptext varchar,
	plan_id bigint,
	url varchar,
	approved boolean,
	created_at timestamptz,
	created_by varchar,
	updated_at timestamptz,
	updated_by varchar,
	CONSTRAINT ptext_pri PRIMARY KEY (text_id)

);
-- ddl-end --
ALTER TABLE project.ptext OWNER TO pythiaservice;
-- ddl-end --

-- object: project.sister_project | type: TABLE --
-- DROP TABLE IF EXISTS project.sister_project CASCADE;
CREATE TABLE project.sister_project(
	id bigint NOT NULL,
	project_id bigint,
	sister_project_id bigint,
	CONSTRAINT project_pri PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE project.sister_project OWNER TO pythiaservice;
-- ddl-end --

-- object: project.pmap_serial | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS project.pmap_serial CASCADE;
CREATE SEQUENCE project.pmap_serial
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE project.pmap_serial OWNER TO pythiaservice;
-- ddl-end --

-- object: project.ptex_serial | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS project.ptex_serial CASCADE;
CREATE SEQUENCE project.ptex_serial
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE project.ptex_serial OWNER TO pythiaservice;
-- ddl-end --

-- object: project.latest_plans | type: VIEW --
-- DROP VIEW IF EXISTS project.latest_plans CASCADE;
CREATE VIEW project.latest_plans
AS 

SELECT
   project.plan.*;
-- ddl-end --
ALTER VIEW project.latest_plans OWNER TO postgres;
-- ddl-end --

-- Appended SQL commands --
SELECT * FROM project.latest_plans
ORDER BY project.latest_plans.version DESC
FETCH FIRST 2 ROWS ONLY;
-- ddl-end --

-- object: projecid_for | type: CONSTRAINT --
-- ALTER TABLE project.plan DROP CONSTRAINT IF EXISTS projecid_for CASCADE;
ALTER TABLE project.plan ADD CONSTRAINT projecid_for FOREIGN KEY (project_id)
REFERENCES project.project (project_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: plan_fkey | type: CONSTRAINT --
-- ALTER TABLE project.ptext DROP CONSTRAINT IF EXISTS plan_fkey CASCADE;
ALTER TABLE project.ptext ADD CONSTRAINT plan_fkey FOREIGN KEY (plan_id)
REFERENCES project.plan (plan_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: project_fkey | type: CONSTRAINT --
-- ALTER TABLE project.sister_project DROP CONSTRAINT IF EXISTS project_fkey CASCADE;
ALTER TABLE project.sister_project ADD CONSTRAINT project_fkey FOREIGN KEY (project_id)
REFERENCES project.project (project_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


