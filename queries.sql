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


/*Get all appointments that a patient has had at this practice.*/
SELECT *
FROM appointments a, patients p
WHERE  a.patient_id = p.patient_id AND p.name = "John Smith";

/*Prescribe a medication to a patient*/

/*Provide a patient a referral to a specialized doctor*/

/*Create a new patient, and add their family history*/

/*Get all patients based on their insurance provider*/

SELECT p.patient_id, p.name
FROM patients p, insurance_covers c, insurance_providers i
WHERE p.patient_id = c.patient_id 
    AND c.provider_id = i.provider_id 
    AND i.insurance_name = "Unitedhealth Group";

/*Get all patients that had appointment with certain doctor in the last 7 days
 Used for COVID-19 tracing to notify patients*/

/*Get all info about a patient in a single view.
(doctor wants to get all info on patient)*/

/*Get all patients who are vaccinated for a specific vaccine.*/

/*Get all patients who were prescribed a specific drug.
In case of recall, or price jumps of brand-name */

/*Get contact info of a patient’s emergency contact*/

/*See the date of the most recent appointment of a patient
For front-desk appointment scheduling.*/

/*Get health metrics (average, min, max) of patient history within a specified time range.*/
