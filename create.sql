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

/*
CREATE TABLE IF NOT EXISTS prescriptions (

);

CREATE TABLE IF NOT EXISTS referrals (
    
);

CREATE TABLE IF NOT EXISTS immunizations (
    
);

CREATE TABLE IF NOT EXISTS immunized_by (
    
);

CREATE TABLE IF NOT EXISTS employees (
    
);

CREATE TABLE IF NOT EXISTS diagnoses (
    
);

CREATE TABLE IF NOT EXISTS exams (
    
);

CREATE TABLE IF NOT EXISTS blood_exams (
    
);

CREATE TABLE IF NOT EXISTS covid_exams (
    
);

CREATE TABLE IF NOT EXISTS vaccine_administrations (
    
);

CREATE TABLE IF NOT EXISTS relatives (
    
);

CREATE TABLE IF NOT EXISTS relative_conditions (
    
);

CREATE TABLE IF NOT EXISTS experiencing (
    
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

CREATE TABLE IF NOT EXISTS conducted_by (
    
);

CREATE TABLE IF NOT EXISTS specialized_labs (
    
);

CREATE TABLE IF NOT EXISTS covered_by (
    
);

CREATE TABLE IF NOT EXISTS medical_conditions (
    
);

CREATE TABLE IF NOT EXISTS emp_immunizations (
    
);
*/