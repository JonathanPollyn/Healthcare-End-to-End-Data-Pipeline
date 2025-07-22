CREATE DATABASE PatientCentricHealthcare;
GO

USE PatientCentricHealthcare;
GO

CREATE SCHEMA ClinicalData AUTHORIZATION dbo;
GO


CREATE TABLE ClinicalData.INSURANCE (
    insurance_id INT PRIMARY KEY NOT NULL,
    insurance_company VARCHAR(100) NOT NULL,
    plan_type VARCHAR(50) NOT NULL,
    group_number VARCHAR(50) NOT NULL,
	LoadDt datetime NOT NULL
);

CREATE TABLE ClinicalData.PROVIDERS (
    provider_id INT PRIMARY KEY NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    license_number VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    clinic_location VARCHAR(100) NOT NULL,
	LoadDt datetime NOT NULL
);

CREATE TABLE ClinicalData.PATIENTS (
    patient_id INT PRIMARY KEY NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    emergency_contact_name VARCHAR(100) NULL,
    emergency_contact_phone VARCHAR(50) NULL,
    insurance_id INT NULL,
	LoadDt datetime NOT NULL,
	FOREIGN KEY (insurance_id) REFERENCES ClinicalData.INSURANCE(insurance_id)
);


CREATE TABLE ClinicalData.APPOINTMENTS (
    appointment_id INT PRIMARY KEY NOT NULL,
    patient_id INT NULL,
    provider_id INT NULL ,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    reason_for_visit VARCHAR(100) NULL,
    status VARCHAR(20),
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
	LoadDt datetime NOT NULL
    FOREIGN KEY (patient_id) REFERENCES ClinicalData.PATIENTS(patient_id),
    FOREIGN KEY (provider_id) REFERENCES ClinicalData.PROVIDERS(provider_id)
);


CREATE TABLE ClinicalData.OUTPATIENT_VISIT (
    visit_id INT PRIMARY KEY NOT NULL,
    patient_id INT NULL,
    provider_id INT NULL,
    visit_date DATE NOT NULL,
    chief_complaint VARCHAR(50) NULL,
	amount_paid DECIMAL(10,2) NOT NULL,
    clinical_notes VARCHAR(1000) NULL,
    visit_summary VARCHAR(1000) NULL,
    follow_up_required VARCHAR(20) NULL,
	LoadDt datetime NOT NULL
    FOREIGN KEY (patient_id) REFERENCES ClinicalData.PATIENTS(patient_id),
    FOREIGN KEY (provider_id) REFERENCES ClinicalData.PROVIDERS(provider_id),
);

CREATE TABLE ClinicalData.INPATIENT_STAYS (
    admission_id INT PRIMARY KEY NOT NULL,
    patient_id INT NULL,
    provider_id INT NULL,
    admit_date DATE NOT NULL,
    discharge_date DATE NULL,
	amount_paid DECIMAL(10,2) NOT NULL,
    ward VARCHAR(50) NULL,
    room_number VARCHAR(10) NOT NULL,
    bed_number VARCHAR(10) NOT NULL,
    admitting_diagnosis VARCHAR(200) NOT NULL,
    discharge_summary VARCHAR(1000) NOT NULL,
    length_of_stay INT NOT NULL,
	LoadDt datetime NOT NULL
    FOREIGN KEY (patient_id) REFERENCES ClinicalData.PATIENTS(patient_id),
    FOREIGN KEY (provider_id) REFERENCES ClinicalData.PROVIDERS(provider_id)
);

CREATE TABLE ClinicalData.MEDICATION (
    medication_id INT PRIMARY KEY NOT NULL,
    patient_id INT NULL,
    provider_id INT NULL,
    drug_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    route VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    instructions VARCHAR(1000) NULL,
	LoadDt datetime NOT NULL
    FOREIGN KEY (patient_id) REFERENCES ClinicalData.PATIENTS(patient_id),
    FOREIGN KEY (provider_id) REFERENCES ClinicalData.PROVIDERS(provider_id)
);

CREATE TABLE ClinicalData.PHARMACY (
    pharmacy_id INT PRIMARY KEY NOT NULL,
    medication_id INT NULL,
    pharmacist_id INT NULL,
    dispensed_date DATE NOT NULL,
    quantity_dispensed INT NOT NULL,
    refill_allowed INT NOT NULL,
    stock_quantity INT NOT NULL,
    location VARCHAR(100) NULL,
	LoadDt datetime NOT NULL
    FOREIGN KEY (medication_id) REFERENCES ClinicalData.MEDICATION(medication_id),
    FOREIGN KEY (pharmacist_id) REFERENCES ClinicalData.PROVIDERS(provider_id)
);



CREATE TABLE ClinicalData.DIAGNOSES (
    diagnosis_id INT PRIMARY KEY NOT NULL,
    patient_id INT NULL,
    visit_id INT NULL,
    icd_code VARCHAR(20) NOT NULL,
    diagnosis_description  VARCHAR(2000) NULL,
    diagnosis_date DATE NOT NULL,
    provider_id INT NULL,
	LoadDt datetime NOT NULL
    FOREIGN KEY (patient_id) REFERENCES ClinicalData.PATIENTS(patient_id),
    FOREIGN KEY (visit_id) REFERENCES ClinicalData.OUTPATIENT_VISIT(visit_id),
    FOREIGN KEY (provider_id) REFERENCES ClinicalData.PROVIDERS(provider_id)
);

CREATE TABLE ClinicalData.LAB_RESULTS (
    lab_result_id INT PRIMARY KEY NOT NULL,
    patient_id INT NULL,
    visit_id INT NULL,
    test_name VARCHAR(100) NOT NULL,
    result_value VARCHAR(50) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    reference_range VARCHAR(50) NULL,
    test_date DATE NOT NULL,
    provider_id INT NULL,
	LoadDt datetime NOT NULL
    FOREIGN KEY (patient_id) REFERENCES ClinicalData.PATIENTS(patient_id),
    FOREIGN KEY (visit_id) REFERENCES ClinicalData.OUTPATIENT_VISIT(visit_id),
    FOREIGN KEY (provider_id) REFERENCES ClinicalData.PROVIDERS(provider_id)
);

CREATE TABLE ClinicalData.VITAL_SIGNS (
    vitals_id INT PRIMARY KEY NOT NULL,
    visit_id INT NULL,
    temperature DECIMAL(4,1) NOT NULL,
    heart_rate INT NOT NULL,
    blood_pressure_systolic INT NOT NULL,
    blood_pressure_diastolic INT NOT NULL,
    respiratory_rate INT NOT NULL,
    oxygen_saturation INT NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    height VARCHAR(10) NOT NULL,
    bmi DECIMAL(4,1) NOT NULL,
    recorded_at DATETIME NOT NULL,
	LoadDt datetime NOT NULL
    FOREIGN KEY (visit_id) REFERENCES ClinicalData.OUTPATIENT_VISIT(visit_id)
);