CREATE TABLE IF NOT EXISTS pharmacies (
    pharmacy_address VARCHAR(200) NOT NULL,
    pharmacy_name VARCHAR(75) NOT NULL,
    PRIMARY KEY (pharmacy_address)
);

CREATE TABLE IF NOT EXISTS patients (
    patient_id SERIAL,
    phone_number VARCHAR(50),
    birthday DATE NOT NULL,
    email VARCHAR(255) NOT NULL,
    ssn VARCHAR(11),
    address VARCHAR(200),
    name VARCHAR(75) NOT NULL,
    gender VARCHAR(50) NOT NULL,
    PRIMARY KEY (patient_id)
);

CREATE TABLE IF NOT EXISTS insurance_providers (
    provider_id SERIAL,
    insurance_name VARCHAR(75) NOT NULL,
    policy_number VARCHAR(20) NOT NULL,
    in_network BOOLEAN NOT NULL,
    PRIMARY KEY (provider_id)
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id SERIAL,
    name VARCHAR(75) NOT NULL,
    birthday DATE NOT NULL,
    salary int NOT NULL CHECK (salary >= 0),
    ssn VARCHAR(11) NOT NULL,
    role VARCHAR(50) NOT NULL,
    email VARCHAR(255),
    phone_number VARCHAR(50) NOT NULL,
    dea_number VARCHAR(9),
    medical_license_number VARCHAR(10),
    address VARCHAR(200) NOT NULL,
    gender VARCHAR(50) NOT NULL,
    PRIMARY KEY (emp_id)
);

CREATE TABLE IF NOT EXISTS prescriptions (
    prescription_id SERIAL,
    emp_id INT NOT NULL CHECK (emp_id >= 0),
    patient_id INT NOT NULL CHECK (patient_id >= 0),
    drug_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    dose VARCHAR(50) NOT NULL,
    refills INT NOT NULL CHECK (refills >= 0),
    instructions TEXT,
    prescription_date TIMESTAMPTZ NOT NULL,
    pharmacy_address VARCHAR(150) NOT NULL,
    PRIMARY KEY (prescription_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (pharmacy_address) REFERENCES pharmacies(pharmacy_address)
);

CREATE TABLE IF NOT EXISTS relatives (
    relative_id SERIAL,
    patient_id INT NOT NULL CHECK (patient_id >= 0),
    relative_type VARCHAR(30) NOT NULL,
    additional_notes TEXT,
    PRIMARY KEY (relative_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS referrable_doctors (
    ref_doctor_id SERIAL,
    name VARCHAR(75) NOT NULL,
    specialization VARCHAR(100),
    phone_number VARCHAR(50),
    PRIMARY KEY (ref_doctor_id)
);

CREATE TABLE IF NOT EXISTS referrals (
    ref_id SERIAL,
    emp_id INT NOT NULL CHECK (emp_id >= 0),
    ref_doctor_id INT NOT NULL CHECK (ref_doctor_id >= 0),
    patient_id INT NOT NULL CHECK (patient_id >= 0),
    PRIMARY KEY (ref_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (ref_doctor_id) REFERENCES referrable_doctors(ref_doctor_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);


CREATE TABLE IF NOT EXISTS immunizations (
    immunization_id SERIAL,
    immunization_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (immunization_id)
);

CREATE TABLE IF NOT EXISTS immunized_patients (
    immun_id INT NOT NULL CHECK (immun_id >= 0),
    patient_id INT NOT NULL CHECK (patient_id >= 0),
    PRIMARY KEY (immun_id, patient_id),
    FOREIGN KEY (immun_id) REFERENCES immunizations(immunization_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE IF NOT EXISTS medical_conditions (
    icd_code VARCHAR(7) NOT NULL,
    name VARCHAR(255) NOT NULL,
    parent_code VARCHAR(7),
    PRIMARY KEY (icd_code),
    FOREIGN KEY (parent_code) REFERENCES medical_conditions(icd_code)
);


CREATE TABLE IF NOT EXISTS appointments (
    app_id SERIAL,
    patient_id int NOT NULL,
    room_number VARCHAR(6),
    date TIMESTAMP NOT NULL,
    blood_pressure VARCHAR(7) NOT NULL,
    weight real NOT NULL,
    /* Specifying precision of numeric doesn't save space */
    height NUMERIC NOT NULL,
    temperature NUMERIC NOT NULL,
    notes TEXT,
    PRIMARY KEY (app_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE IF NOT EXISTS tests (
    test_id SERIAL,
    test_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (test_id)
);

CREATE TABLE IF NOT EXISTS archived_files (
    file_id SERIAL,
    patient_id INT,
    emp_id INT,
    file_name VARCHAR(255) NOT NULL,
    /* TODO: IMPLEMENT file_blob  */
    s3_id VARCHAR(255) NOT NULL,
    PRIMARY KEY (file_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE IF NOT EXISTS lab_reports (
    report_id SERIAL,
    icd_code VARCHAR(7) NOT NULL,
    file_id INT,
    app_id INT,
    result_info TEXT,
    PRIMARY KEY (report_id),
    FOREIGN KEY (app_id) REFERENCES appointments(app_id),
    FOREIGN KEY (file_id) REFERENCES archived_files(file_id)
);

CREATE TABLE IF NOT EXISTS exams (
    exam_id SERIAL,
    report_id INT NOT NULL,
    app_id INT NOT NULL,
    comment TEXT,
    PRIMARY KEY (exam_id),
    FOREIGN KEY (report_id) REFERENCES lab_reports(report_id),
    FOREIGN KEY (app_id) REFERENCES appointments(app_id)
);

CREATE TABLE IF NOT EXISTS blood_exams (
    exam_id INT,
    blood_type VARCHAR(3) NOT NULL,
    blood_sugar VARCHAR(12) NOT NULL,
    PRIMARY KEY (exam_id),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id)
);

CREATE TABLE IF NOT EXISTS covid_exams (
    exam_id INT,
    test_type VARCHAR(20) NOT NULL,
    is_positive BOOLEAN,
    PRIMARY KEY (exam_id),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id)
);

CREATE TABLE IF NOT EXISTS administered_vaccines (
    exam_id INT,
    vaccine_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (exam_id),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id)
);


CREATE TABLE IF NOT EXISTS specialized_labs (
    lab_id SERIAL,
    phone_number VARCHAR(50),
    address VARCHAR(200),
    lab_name VARCHAR(200),
    PRIMARY KEY (lab_id)
);

CREATE TABLE IF NOT EXISTS relative_conditions (
    relative_id INT,
    icd_code VARCHAR(7) NOT NULL,
    PRIMARY KEY (relative_id, icd_code),
    FOREIGN KEY (relative_id) REFERENCES relatives(relative_id) ON DELETE CASCADE,
    FOREIGN KEY (icd_code) REFERENCES medical_conditions(icd_code)
);

CREATE TABLE IF NOT EXISTS diagnoses (
    emp_id INT,
    patient_id INT,
    app_id INT,
    icd_code VARCHAR(7),
    comment TEXT,
    PRIMARY KEY (emp_id, patient_id, app_id, icd_code),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (app_id) REFERENCES appointments(app_id),
    FOREIGN KEY (icd_code) REFERENCES medical_conditions(icd_code)
);

CREATE TABLE IF NOT EXISTS appointment_medical_conditions (
    app_id INT,
    icd_code VARCHAR(7),
    comment TEXT,
    PRIMARY KEY (app_id, icd_code),
    FOREIGN KEY (app_id) REFERENCES appointments(app_id),
    FOREIGN KEY (icd_code) REFERENCES medical_conditions(icd_code)
);

CREATE TABLE IF NOT EXISTS report_creators (
    report_id	INT,
    lab_id	INT,
    PRIMARY KEY (report_id, lab_id),
    FOREIGN KEY (report_id) REFERENCES lab_reports(report_id),
    FOREIGN KEY (lab_id) REFERENCES specialized_labs(lab_id)
);

CREATE TABLE IF NOT EXISTS insurance_covers (
    provider_id	INT,
    patient_id	INT,
    member_id	VARCHAR(12) NOT NULL,
    group_number	VARCHAR(12) NOT NULL,
    policy_holder_name	VARCHAR(75) NOT NULL,
    PRIMARY KEY (provider_id, patient_id),
    FOREIGN KEY (provider_id) REFERENCES insurance_providers(provider_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE IF NOT EXISTS immunized_employees (
    immun_id	INT,
    emp_id	INT,
    PRIMARY KEY (immun_id, emp_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (immun_id) REFERENCES immunizations(immunization_id)
);

CREATE TABLE IF NOT EXISTS accepted_tests (
    test_id	INT,
    lab_id	INT,
    PRIMARY KEY (test_id, lab_id),
    FOREIGN KEY (test_id) REFERENCES tests(test_id),
    FOREIGN KEY (lab_id) REFERENCES specialized_labs(lab_id)
);

CREATE TABLE IF NOT EXISTS appointment_employees (
    emp_id	INT,
    app_id	INT,
    PRIMARY KEY (emp_id, app_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (app_id) REFERENCES appointments(app_id)
);

CREATE TABLE IF NOT EXISTS emergency_contacts (
  name VARCHAR(75) NOT NULL,
  patient_id INT NOT NULL CHECK (patient_id >= 0),
  phone_1 VARCHAR(50) NOT NULL,
  phone_2 VARCHAR(50),
  PRIMARY KEY (name, patient_id),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);