/*

Query efficiency.
Inner join order 1st. tmp - the smaller set (only max or second highest value)
2nd the whole plan -table.  

Index - main_no

UNION ALL is faster than UNION and since we can't have duplicate rows it can be used
*/

-- View: project.latest_plans

-- DROP VIEW project.latest_plans;

CREATE OR REPLACE VIEW project.latest_plans AS 
 SELECT p1.plan_id,
    p1.project_id,
    p1.main_no,
    p1.sub_no,
    p1.version,
    p1.url,
    p1.approved,
    p1.created_at,
    p1.created_by,
    p1.updated_at,
    p1.updated_by
   FROM ( SELECT max(p2.version) AS maxversion,
            p2.main_no,
            p2.sub_no
           FROM project.plan p2
          GROUP BY p2.main_no, p2.sub_no) tmp
     JOIN project.plan p1 ON p1.main_no = tmp.main_no AND p1.sub_no = tmp.sub_no AND p1.version = tmp.maxversion
UNION ALL
 SELECT p1.plan_id,
    p1.project_id,
    p1.main_no,
    p1.sub_no,
    p1.version,
    p1.url,
    p1.approved,
    p1.created_at,
    p1.created_by,
    p1.updated_at,
    p1.updated_by
   FROM ( SELECT max(p2.version) - 1 AS maxversion,
            p2.main_no,
            p2.sub_no
           FROM project.plan p2
          GROUP BY p2.main_no, p2.sub_no) tmp
     JOIN project.plan p1 ON p1.main_no = tmp.main_no AND p1.sub_no = tmp.sub_no AND p1.version = tmp.maxversion;

ALTER TABLE project.latest_plans
  OWNER TO pythiaservice;
  
  -- DROP INDEX project.mainno_ind;

CREATE INDEX mainno_ind
  ON project.plan
  USING btree
  (main_no);


