/* Most popular insurance provider */
SELECT
  count(*),
  ip.*
FROM
  insurance_covers ic
  JOIN insurance_providers ip using(provider_id)
GROUP BY
  ip.provider_id
ORDER BY
  count(*) DESC
LIMIT
  5


/* Doctors with most app in last  7 days */
SELECT
  count(*),
  e.*
FROM
  patients p,
  appointments a,
  appointment_employees ae,
  employees e
WHERE
  p.patient_id = a.patient_id
  AND ae.app_id = a.app_id
  AND ae.emp_id = e.emp_id
  AND a."date" > current_timestamp - interval '1 week'
GROUP BY
  e.emp_id
ORDER BY
  count(*) DESC
LIMIT
  5



/* Most common vaccination */
SELECT
  count(*),
  i.*
FROM
  immunized_patients ip
  JOIN immunizations i ON ip.immun_id = i.immunization_id
GROUP BY
  i.immunization_id
ORDER BY
  count(*) DESC
LIMIT
  5



/* most popular prescriptions */
SELECT
  count(*),
  d.drug_name
FROM
  prescriptions d
GROUP BY
  d.drug_name
ORDER BY
  count(*) DESC
LIMIT
  5



/*most emergency contacts*/
SELECT
  count(*),
  p.*
FROM
  patients p
  JOIN emergency_contacts c using(patient_id)
GROUP BY
  p.patient_id
ORDER BY
  count(*) DESC
LIMIT
  5
