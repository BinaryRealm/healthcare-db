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
SELECT a.*
FROM appointments a, patients p
WHERE  a.patient_id = p.patient_id AND p.name = 'Thomas Moon';

/*Prescribe a medication to a patient*/

/*Provide a patient a referral to a specialized doctor*/

/*Create a new patient, and add their family history*/

/*Get all patients based on their insurance provider*/

SELECT p.patient_id, p.name
FROM patients p, insurance_covers c, insurance_providers i
WHERE p.patient_id = c.patient_id 
    AND c.provider_id = i.provider_id 
    AND i.insurance_name = 'Purple Shield';

/*Get all patients that had appointment with certain doctor in the last 7 days
 Used for COVID-19 tracing to notify patients*/
SELECT p.patient_id, p.name, a.date 
FROM patients p, appointments a, appointment_employees ae, employees e 
WHERE p.patient_id = a.patient_id 
    AND ae.app_id = a.app_id 
    AND ae.emp_id = e.emp_id 
    AND e."name" = 'Michael Prince'
    AND a."date" > current_timestamp - interval '1 week';
GROUP BY p.patient_id 

/*Get all info about a patient in a single view.
(doctor wants to get all info on patient)*/

/*Find last 3 appointments */
SELECT a.* as last_three
FROM appointments a, patients p 
WHERE a.patient_id = p.patient_id AND p."name" = 'David Smith' 
ORDER BY a."date" DESC 
LIMIT 3;

/*Find medical conditions reported in the last 3 appointments */
select mc.*
from (SELECT a.*  
	FROM appointments a, patients p 
	WHERE a.patient_id = p.patient_id AND p."name" = 'David Smith' 
	ORDER BY a."date" DESC 
	LIMIT 3) as last_three,
diagnoses d, medical_conditions mc 
where last_three.app_id = d.app_id and d.icd_code = mc.icd_code;

/*Find 2 most recent prescriptions*/
SELECT p2.*
FROM patients p, prescriptions p2 
WHERE p."name" = 'David Smith'AND p.patient_id = p2.patient_id 
ORDER BY p2.prescription_date  DESC 
LIMIT 2;

/*Get all patients who are vaccinated for a specific vaccine.*/

SELECT p.patient_id, p.name
FROM patients p, appointments a, exams e, administered_vaccines v
WHERE a.patient_id = p.patient_id
    AND e.app_id = a.app_id
    AND v.exam_id = e.exam_id
    AND v.vaccine_type = 'Tuberculosis';

/*Get all patients who were prescribed a specific drug.
In case of recall, or price jumps of brand-name */

SELECT DISTINCT p.patient_id, p.name
FROM patients p, prescriptions d
WHERE d.patient_id = p.patient_id
    AND d.drug_name = 'Albuterol';
    
/*Get contact info of a patient’s emergency contact*/


/*See the date of the most recent appointment of a patient
For front-desk appointment scheduling.*/
SELECT MAX(a.date) 
FROM patients p, appointments a 
WHERE p."name" = 'Thomas Moon' 
	AND p.patient_id = a.patient_id

/*Get health metrics (average, min, max) of patient history within a specified time range.*/
SELECT p.*, AVG(a.weight) AS avg_weight, MIN(a.weight) AS min_weight, 
    MAX(a.weight) AS max_weight, AVG(a.temperature) AS avg_temperature, 
    MIN(a.temperature) AS min_temperature, MAX(a.temperature) AS max_temperature, 
    MAX(a.height) AS height
FROM appointments a NATURAL JOIN patients p 
WHERE p."name" ='Thomas Moon' AND a."date" > current_timestamp - INTERVAL '1 year'
GROUP BY p.patient_id;

/* Find the most prescribed medications */
SELECT drug_name, count(*) AS count 
FROM prescriptions p 
GROUP BY drug_name 
ORDER BY count DESC;


/* Find all the patients with the top 5 most appointments */
SELECT count(*) AS count, p.* 
FROM appointments a, patients p
WHERE a.patient_id = p.patient_id 
GROUP BY p.patient_id 
ORDER BY count DESC
LIMIT 5;

/* Sort all patients in descending order of the number of appointments they had in the past week */
SELECT count(*) AS count, p.* 
FROM appointments a, patients p
WHERE a.patient_id = p.patient_id AND a."date" > current_timestamp - INTERVAL '1 week'
GROUP BY p.patient_id 
ORDER BY count DESC


