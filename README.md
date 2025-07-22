
# Healthcare Data Platform Project

This repository provides an end-to-end walkthrough of a healthcare data platform encompassing data engineering, data analytics, and a forthcoming machine learning component. This is part of an educational webinar series focused on practical data science applications using healthcare-related datasets.

> **Disclaimer**: The data used in this project does **not** include any Protected Health Information (PHI) or Personally Identifiable Information (PII), and it is **not** affiliated with any real-world healthcare provider or organization.

---

## 🔁 ETL (Extract, Transform, Load)

This section contains the pipeline used to ingest, clean, and prepare healthcare data using SQL Server Integration Services (SSIS) and schema design.

### Contents:
- **Data/**: Raw data files used for transformation.
- **SSIS Package/**: Contains SSIS project for automating ETL operations.
- **ER Diagram**: Entity-Relationship diagram for database structure.
- **healthcare_schema - Create Scripts.sql**: SQL scripts to create tables and schemas for the PatientCentricDB.

---

## 📊 Data Analytics

This module focuses on the transformation and visualization of healthcare data to extract insights for reporting and decision-making.

### Contents:
- **HealthCare Analysis.pbix**: Power BI report dashboard providing visual insights into patient-provider interactions and outcomes.
- **HealthCareAnalysis_Patient_Provider.sql**: SQL queries used for data extraction and analytics.
- **PatientCentricDB/**: Contains structured healthcare datasets for querying and reporting.

---

## 🤖 Machine Learning (Coming Soon)

This section will implement a machine learning model to **predict diabetes** risk among patients using structured health records. The model will be deployed using **Streamlit** to provide a user-friendly interface for inference.

---

## 🧠 Learning Objectives

- Design healthcare data pipelines using SSIS and SQL.
- Build meaningful data models and dashboards using Power BI.
- Apply predictive analytics using Python and Streamlit (in development).

---

## 📂 Repository Structure

```
/ETL
    /Data
    /SSIS Package
    ER Diagram
    healthcare_schema - Create Scripts.sql

/Data Analytics
    HealthCare Analysis.pbix
    HealthCareAnalysis_Patient_Provider.sql
    /PatientCentricDB

/Machine Learning
    (Coming Soon: Streamlit app for Diabetes Prediction)
```

---

## 📌 License

This project is intended for educational use. No commercial or clinical use is authorized without the author's explicit consent.

---
## 📬 Contact

For questions, feedback, or collaboration inquiries, feel free to reach out:

- **Name**: Jonathan Pollyn  
- **Email**: j.pollyn@gmail.com
- **LinkedIn**: https://www.linkedin.com/in/jonathan-ibifubara-pollyn-ms-ds-8482a1110/
- **GitHub**: https://github.com/JonathanPollyn/
---
## 🙌 Acknowledgments

Thanks to all webinar participants and contributors exploring the intersection of data engineering, analytics, and machine learning in healthcare.

Special thanks to Anthony Waweru for his insightful presentation on on the PowerBI, which added significant value to this project.
