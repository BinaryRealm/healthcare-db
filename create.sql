CREATE TABLE IF NOT EXISTS pharmacies (
    pharmacy_address VARCHAR(150) NOT NULL,
    pharmacy_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (pharmacy_address)
);

CREATE TABLE IF NOT EXISTS patients (
    patient_id INT NOT NULL CHECK (patient_id >= 0),
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
    insurance_name VARCHAR(75) NOT NULL,
    policy_number VARCHAR(20) NOT NULL,
    in_network BOOLEAN NOT NULL,
    PRIMARY KEY (insurance_name)
);

CREATE TABLE IF NOT EXISTS employees (
    emp_id INT NOT NULL CHECK (emp_id >= 0),
    name VARCHAR(75) NOT NULL,
    birthday DATE NOT NULL,
    salary DECIMAL(10) NOT NULL CHECK (salary >= 0),
    ssn VARCHAR(11) NOT NULL,
    role VARCHAR(50) NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    dea_number VARCHAR(9)  NOT NULL,
    medical_license_numner VARCHAR(10) NOT NULL,
    address VARCHAR(200) NOT NULL,
    gender VARCHAR(50) NOT NULL,
    PRIMARY KEY (emp_id)
);

CREATE TABLE IF NOT EXISTS prescriptions (
    prescription_id INT NOT NULL CHECK (prescription_id >= 0),
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
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

CREATE TABLE IF NOT EXISTS relatives (
    relative_id INT NOT NULL CHECK (relative_id >= 0),
    patient_id INT NOT NULL CHECK (patient_id >= 0),
    relative_type VARCHAR(30) NOT NULL,
    additional_notes TEXT,
    PRIMARY KEY (relative_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);


CREATE TABLE IF NOT EXISTS referrals (
    ref_id INT NOT NULL CHECK (ref_id >= 0),
    emp_id INT NOT NULL CHECK (emp_id >= 0),
    ref_doctor_id INT NOT NULL CHECK (ref_doctor_id >= 0),
    patient_id INT NOT NULL CHECK (patient_id >= 0),
    PRIMARY KEY (ref_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (ref_doctor_id) REFERENCES referrable_doctors(ref_doctor_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);


CREATE TABLE IF NOT EXISTS immunizations (
    immunization_id INT NOT NULL CHECK (immunization_id >= 0),
    immunization_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (immunization_id),
);

CREATE TABLE IF NOT EXISTS immunized_patients (
    immun_id INT NOT NULL CHECK (immun_id >= 0),
    patient_id INT NOT NULL CHECK (patient_id >= 0),
    PRIMARY KEY (immun_id, patient_id),
    FOREIGN KEY (immun_id) REFERENCES immunizations(immunization_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

/*
CREATE TABLE IF NOT EXISTS diagnoses (
    
);

CREATE TABLE IF NOT EXISTS exams (
    
);

CREATE TABLE IF NOT EXISTS blood_exams (
    
);

CREATE TABLE IF NOT EXISTS covid_exams (
    
);

CREATE TABLE IF NOT EXISTS administered_vaccines (
    
);

CREATE TABLE IF NOT EXISTS relative_conditions (
    
);

CREATE TABLE IF NOT EXISTS appointment_medical_conditions (
    
);

CREATE TABLE IF NOT EXISTS archived_files (
    
);

CREATE TABLE IF NOT EXISTS appointments (
    
);

CREATE TABLE IF NOT EXISTS referrable_doctors (
    
);

CREATE TABLE IF NOT EXISTS medical_condition_categories (
    
);

CREATE TABLE IF NOT EXISTS lab_reports (
    
);

CREATE TABLE IF NOT EXISTS report_creators (
    
);

CREATE TABLE IF NOT EXISTS specialized_labs (
    
);

CREATE TABLE IF NOT EXISTS insurance_covers (
    
);

CREATE TABLE IF NOT EXISTS medical_conditions (
    
);

CREATE TABLE IF NOT EXISTS immunized_employees (
    
);

CREATE TABLE IF NOT EXISTS accepted_tests (
    
);

CREATE TABLE IF NOT EXISTS tests (
    
);

CREATE TABLE IF NOT EXISTS appointment_employees (
    
);

*/