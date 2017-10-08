-- object: project.latest_plans | type: VIEW --
-- DROP VIEW IF EXISTS project.latest_plans CASCADE;
CREATE VIEW project.latest_plans
AS 

SELECT
   project.plan.*
   FROM project.plan
   ORDER BY version DESC
   FETCH FIRST 2 ROWS ONLY;
-- ddl-end --
ALTER VIEW project.latest_plans OWNER TO pythiaservice;
-- ddl-end --

select * from project.latest_plans;
select * from project.project;

select * from project.plan
where version IN( 
(SELECT max(version),main_no,sub_no from project.plan group by main_no,sub_no))
OR
version IN(
(select max(version)-1,main_no,sub_no from project.plan group by main_no,sub_no)
);

SELECT plan_id from (
SELECT max(version),main_no,sub_no,plan_id from project.plan group by main_no,sub_no
UNION
select max(version)-1,main_no,sub_no, plan_id from project.plan group by main_no,sub_no,plan_id
)



-- 1000/001 version 2
select * from project.plan where main_no = 1000 and sub_no = 1

-- 2
select * from project.plan where main_no = 2000 and sub_no = 1

-- 3
select * from project.plan where main_no = 2000 and sub_no = 2

select * from project.plan;
