/* HOW TO FIND ALL PARENT (SUB)CATEGORIES A CONDITION 'R94118' IS A PART OF */
WITH RECURSIVE search_graph(icd_code, parent_code, name, depth) AS (
    SELECT g.icd_code, g.parent_code, g.name, 1
    FROM medical_conditions g
    where g.icd_code ='R94118'
  UNION ALL
    SELECT g.icd_code, g.parent_code, g.name, sg.depth + 1
    FROM medical_conditions g, search_graph sg
    WHERE g.icd_code  = sg.parent_code
) CYCLE icd_code SET is_cycle USING path
SELECT * FROM search_graph;

/* Previous query but without unnecessary cycle detection */
WITH RECURSIVE search_graph(icd_code, parent_code, name, depth) AS (
    SELECT g.icd_code, g.parent_code, g.name, 1
    FROM medical_conditions g
    where g.icd_code ='R94118'
  UNION ALL
    SELECT g.icd_code, g.parent_code, g.name, sg.depth + 1
    FROM medical_conditions g, search_graph sg
    WHERE g.icd_code  = sg.parent_code
)
SELECT * FROM search_graph order by depth;

/* HOW TO FIND ALL CHILDREN SUB(CATEGORIES)/CODES THE CURRENT (SUB)CATEGORY 'R93' HAS */
WITH RECURSIVE search_graph(icd_code, parent_code, name, depth) AS (
    SELECT g.icd_code, g.parent_code, g.name, 1
    FROM medical_conditions g
    where g.icd_code = 'R93'
  UNION ALL
    SELECT g.icd_code, g.parent_code, g.name, sg.depth + 1
    FROM medical_conditions g, search_graph sg
    WHERE sg.icd_code = g.parent_code 
) CYCLE icd_code SET is_cycle USING path
SELECT * FROM search_graph;


/* Previous query but without unnecessary cycle detection */
WITH RECURSIVE search_graph(icd_code, parent_code, name, depth) AS (
    SELECT g.icd_code, g.parent_code, g.name, 1
    FROM medical_conditions g
    where g.icd_code = 'R93'
  UNION ALL
    SELECT g.icd_code, g.parent_code, g.name, sg.depth + 1
    FROM medical_conditions g, search_graph sg
    WHERE sg.icd_code = g.parent_code 
)
SELECT * FROM search_graph order by depth;