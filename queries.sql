/* HOW TO FIND ALL PARENT (SUB)CATEGORIES A CONDITION 'R94118' IS A PART OF */
WITH RECURSIVE search_graph(icd_code, parent_code, name, is_code, depth) AS (
    SELECT mc.icd_code, mc.parent_code, mc.name, mc.is_code, 1
    FROM medical_conditions mc
    where mc.icd_code ='R94118'
  UNION ALL
    SELECT mc.icd_code, mc.parent_code, mc.name, mc.is_code, sg.depth + 1
    FROM medical_conditions mc, search_graph sg
    WHERE mc.icd_code = sg.parent_code
)
SELECT * FROM search_graph order by depth;


/* HOW TO FIND ALL CHILDREN SUB(CATEGORIES)/CODES THE CURRENT (SUB)CATEGORY 'R93' HAS */
WITH RECURSIVE search_graph(icd_code, parent_code, name, is_code, depth) AS (
    SELECT mc.icd_code, mc.parent_code, mc.name, mc.is_code, 1
    FROM medical_conditions mc
    where mc.icd_code = 'R048'
  UNION ALL
    SELECT mc.icd_code, mc.parent_code, mc.name, mc.is_code, sg.depth + 1
    FROM medical_conditions mc, search_graph sg
    WHERE sg.icd_code = mc.parent_code 
)
SELECT * FROM search_graph order by depth;

/*Get all appointments that a patient has had at this practice.*/
SELECT a.*
FROM appointments a, patients p
WHERE  a.patient_id = p.patient_id AND p.name = 'Thomas Moon';

/*Prescribe a medication to a patient*/
INSERT INTO prescriptions (prescription_id, emp_id, patient_id, drug_name, quantity, dose, refills, instructions, prescription_date, pharmacy_address)
VALUES (DEFAULT, 1, 2, 'Tylenol', 100, '500 mg', 1, 'Take when headache', '2022-04-25 11:32:30+00', '16401 Erin Inlet\nPhillipstad, AL 58261');

/*Provide a patient a referral to a specialized doctor*/
INSERT INTO referrals (emp_id, ref_doctor_id, patient_id)
VALUES (19, 7, 25);

/* Get recently frequent patients (More than 5 appointments in the past week)*/
SELECT p.patient_id, p.name	
FROM patients p JOIN appointments a USING(patient_id) 
WHERE a."date" > current_timestamp - interval '1 week'
GROUP BY p.patient_id
HAVING count(*) > 5;

/*Create a new patient, and add their family history*/

WITH pid AS (
	INSERT INTO patients (address, birthday, email, gender, name, patient_id, phone_number, ssn) 
	VALUES ('1600 Pennsylvania Avenue NW, Washington, DC 20500', '1900-11-14', 'test@test.com', 'Male', 'Bill Bob', DEFAULT, '(604)876-1234', '123-78-8888')
	RETURNING patient_id
	),
	rid AS(
		INSERT INTO relatives (additional_notes, patient_id, relative_id, relative_type)
		VALUES ('History of cancer', (select patient_id from pid), DEFAULT, 'father'),
		('History of stroke', (select patient_id from pid), DEFAULT, 'mother')
		RETURNING relative_id
	)
INSERT INTO relative_conditions (icd_code, relative_id)
VALUES ('R6884', (SELECT relative_id FROM rid LIMIT 1)),
	   ('R40211', (SELECT relative_id FROM rid LIMIT 1)),
	   ('R87614', (SELECT relative_id FROM rid LIMIT 1 OFFSET 1)),
	   ('R297', (SELECT relative_id FROM rid LIMIT 1 OFFSET 1));


/*Get all patients based on their insurance provider*/

SELECT p.patient_id, p.name
FROM patients p, insurance_covers c, insurance_providers i
WHERE p.patient_id = c.patient_id 
    AND c.provider_id = i.provider_id 
    AND i.insurance_name = 'Purple Shield';

/*Get all patients that had appointment with certain doctor in the last 7 days
 Used for COVID-19 tracing to notify patients*/
SELECT DISTINCT(p.patient_id), p.name, a.date 
FROM patients p, appointments a, appointment_employees ae, employees e 
WHERE p.patient_id = a.patient_id 
    AND ae.app_id = a.app_id 
    AND ae.emp_id = e.emp_id 
    AND e."name" = 'Nathan Benjamin'
    AND a."date" > current_timestamp - interval '1 week';
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
WHERE p."name" = 'David Smith'
  AND p.patient_id = p2.patient_id 
ORDER BY p2.prescription_date  DESC 
LIMIT 2;

/*Get all patients who are vaccinated for a specific vaccine.*/
SELECT p.patient_id, p.name
FROM patients p, appointments a, exams e, administered_vaccines v
WHERE a.patient_id = p.patient_id
    AND e.app_id = a.app_id
    AND v.exam_id = e.exam_id
    AND v.vaccine_type = 'Poliovirus';

/* IMPROVED VACCINATION because it accounts for vaccinations that occurr outside practice  */
SELECT p.*
FROM immunized_patients ip 
	JOIN patients p USING(patient_id)
	JOIN immunizations i ON ip.immun_id = i.immunization_id 
	WHERE i.immunization_type = 'Poliovirus';

/*Get all patients who were prescribed a specific drug.
In case of recall, or price jumps of brand-name */
SELECT DISTINCT p.patient_id, p.name
FROM patients p, prescriptions d
WHERE d.patient_id = p.patient_id
    AND d.drug_name = 'Albuterol';
    
/*Get contact info of a patient’s emergency contact*/
SELECT c.name, c.phone_1, c.phone_2
FROM patients p, emergency_contacts c
WHERE p.patient_id = c.patient_id
    AND p.name = 'Barbara Jones';

/*See the date of the most recent appointment of a patient
For front-desk appointment scheduling.*/
SELECT MAX(a.date) 
FROM patients p, appointments a 
WHERE p."name" = 'Chelsea Cantu' 
	AND p.patient_id = a.patient_id;

/*Get health metrics (average, min, max) of patient history within a specified time range.*/
SELECT p.*, AVG(a.weight) AS avg_weight, MIN(a.weight) AS min_weight, 
    MAX(a.weight) AS max_weight, AVG(a.temperature) AS avg_temperature, 
    MIN(a.temperature) AS min_temperature, MAX(a.temperature) AS max_temperature, 
    MAX(a.height) AS height
FROM appointments a NATURAL JOIN patients p 
WHERE p."name" ='Amanda Zavala' AND a."date" > current_timestamp - INTERVAL '1 year'
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
ORDER BY count DESC;
