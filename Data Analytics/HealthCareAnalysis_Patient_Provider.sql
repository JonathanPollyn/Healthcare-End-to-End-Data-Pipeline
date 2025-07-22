 /********** Part 1  ******************
--Patient focused view
--Identify Patients who have Inpatient Visits or Outpatient visits  
--Using a CTE to accomplish this and create a table that will be loaded into PowerBI
 */

--drop table if exists dbo.IP_OP_Final;

with IP_OP as 
(
--Inpatient patients only 
Select distinct
	p.patient_id,
	p.first_name Member_First_Name,
	p.last_name Member_Last_Name,
	cast (p.date_of_birth as date) as DOB,
	case when gender = 'Male' then 'M' else 'F' end as Gender,
	DATEDIFF(year, p.date_of_birth, cast(GETDATE() as date)) as Age,
	insurance_company as Payer,
	plan_type,
	cast (ip.admit_date as date) as DOS,
	concat (p.patient_id, '/', cast (ip.admit_date as date)) as patient_dos_key, --this key uniquely identifies each member per date of service. Used to calculate metrics such as avg cost per visit as a member might have more than 1 visit per year
	ip.length_of_stay,
	case when length_of_stay <= 3 then 'Short Stay (1-3)'
		when length_of_stay between 4 and 7 then 'Moderate Stay (4-7)'
		when length_of_stay between 8 and 14 then 'Long Stay (8-14)'
		else 'Extended Stay (15+)'
	end as LOS_Bucket,
	ip.Admitting_Diagnosis,
	Null as Chief_Complaint,
	cast(ip.amount_paid as money) as Paid_Amount,
	'Inpatient' as Service_Type,
	concat (pro.license_number,' - ',pro.last_name,', ',pro.first_name) as Provider_Name
 from ClinicalData.PATIENTS p 
 left join ClinicalData.INSURANCE i on p.insurance_id = i.insurance_id --get insurance information
 inner join ClinicalData.INPATIENT_STAYS ip on p.patient_id = ip.patient_id --Inpatient stays
 left join ClinicalData.PROVIDERS pro on ip.provider_id = pro.provider_id --get provider information
 union all
 --Outpatient patients only 
 select distinct
	p.Patient_id,
	p.first_name Member_First_Name,
	p.last_name Member_Last_Name,
	cast (p.date_of_birth as date) as DOB,
	case when gender = 'Male' then 'M' else 'F' end as Gender,
	DATEDIFF(year, p.date_of_birth, cast(GETDATE() as date)) as Age,
	insurance_company as Payer,
	plan_type,
	cast (op.visit_date as date) as DOS,
	concat (p.patient_id, '/', cast (op.visit_date as date)) as patient_dos_key,
	'0' as length_of_stay, --Outpatients don't have length of stay, as they aren't admitted. This metric won't apply to them
	'N/A' as LOS_Bucket,
	Null as Admitting_Diagnosis,
	op.Chief_Complaint,
	cast(op.amount_paid as money) as Paid_Amount,
	'Outpatient' as Service_Type,
	concat (pro.license_number,' - ',pro.last_name,', ',pro.first_name) as Provider_Name
 from ClinicalData.PATIENTS p 
 left join ClinicalData.INSURANCE i on p.insurance_id = i.insurance_id --get insurance information
 inner join ClinicalData.OUTPATIENT_VISIT op on p.patient_id = op.patient_id --Outpatients
 left join ClinicalData.PROVIDERS pro on op.provider_id = pro.provider_id --get provider information
 )
 ,  
 --added a flag to identify members who were admitted for more than one condition (Multiple Conditions) for the year
 MC_Pacients as 
 (
 select distinct 
	patient_id,
	DATEPART (year, admit_date) as Year_of_Service,
	count(distinct Admitting_Diagnosis) as Dx_Count
 from ClinicalData.INPATIENT_STAYS
 group by patient_id,
	DATEPART (year, admit_date)
)
--final output
 select a.*,
	--create an age group bucket 
	case when age between 0 and 1 then 'Infant'
		when age between 2 and 4 then 'Toddler'
		when age between 5 and 12 then 'Child'
		when age between 13 and 19 then 'Teenager'
		when age between 20 and 39 then 'Young Adult'
		when age between 40 and 59 then 'Middle-Aged Adult'
		when age >= 60 then 'Senior'
	end as Age_Group,
	case when b.Dx_Count > 1 then 'Yes' else 'No' end as MC_Patient 
 into IP_OP_Final --table that will be loaded into PowerBI
 from IP_OP a 
 left join MC_Pacients b on a.patient_id = b.patient_id
		and DATEPART(year, a.DOS) = b.Year_of_Service
 order by a.patient_id, dos desc
 ;

 ---newly created table 
   Select *
	from dbo.IP_OP_Final
 order by patient_id, dos desc
 ;

 /*******Part 2 *************************
--Provider Centric View
--This data will be used to show some metrics from the Providers lens on how they manage patients in office based on appointments
--These metrics will be independent of the Inpatient/Outpatients visits
*/

--drop table if exists dbo.Provider_DIM;

select distinct 
	p.provider_id,
	concat (p.license_number,' - ',p.last_name,', ',p.first_name) as Provider_Name,
	specialty,
	clinic_location,
	a.appointment_date,
	a.patient_id,
	pat.first_name Member_First_Name,
	pat.last_name Member_Last_Name,
	pat.gender,
	DATEDIFF(year, pat.date_of_birth, cast(GETDATE() as date)) as Age,
	a.reason_for_visit,
	a.status,
	insurance_company as Payer,
	plan_type,
	1 as Appointments --this field is used to calculate all records/appointments (regardless of status)
into Provider_DIM --table that will be loaded into PowerBI
from ClinicalData.PROVIDERS p 
left join ClinicalData.APPOINTMENTS a on p.provider_id = a.provider_id
left join ClinicalData.PATIENTS pat on a.patient_id = pat.patient_id --have to left join to this table first as a path to get to insurance table below
left join ClinicalData.INSURANCE i on pat.insurance_id = i.insurance_id --grab insurance information
order by patient_id, appointment_date desc
;

--final table
select * from dbo.Provider_DIM
order by patient_id, appointment_date desc
;

 

