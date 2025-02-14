/* Action 1: Create schema named healthcare. Create tables using diabetic_data.csv.
 *  Import 3 csv files, which is the original diabetic_data.csv file split into categories
 * 	- Patient information
 * 	- General medical information
 * 	- Diabetic medical information
 * 
 * The primary key for all 3 tables is the encounter id, since it is unique. It cannot be patient nbr (AKA patient id)
 * since there are many patients that are re-admitted and have the same patient nbr # for multiple visits. */

/* Check that all tables have imported properly and can be queried */
SELECT *
FROM patientinfo p ;

SELECT *
FROM generalmed g ;

SELECT *
FROM diabetes d ;

/* All 3 tables have the same # of rows when queried and the same # of rows as what was in the excel/csv file. Import successful. */

/* Action 2: Calculate total number of patient encounters in dataset */
SELECT COUNT(patient_nbr) AS patient_encounters
FROM patientinfo p ;
	-- Total encounters is 101,766.
	-- Although, this includes duplicate patients since some have been re-admitted. What about unique patient encounters?
SELECT COUNT(DISTINCT patient_nbr) AS unique_patient_encounters
FROM patientinfo p ;
	-- Total unique patient encounters is 71,518.

/* Action 3: Identify the top 10 most frequent diagnoses in the dataset */
SELECT diag_1, COUNT(diag_1) AS diag1_count, ROW_NUMBER() OVER (ORDER BY COUNT(diag_1) DESC) AS ranking
FROM generalmed g 
GROUP BY diag_1
ORDER BY COUNT(diag_1) DESC ;

SELECT diag_2, COUNT(diag_2) AS diag2_count, ROW_NUMBER() OVER (ORDER BY COUNT(diag_2) DESC) AS rank
FROM generalmed g 
GROUP BY diag_2
ORDER BY COUNT(diag_2) DESC ;

SELECT diag_3, COUNT(diag_3) AS diag3_count, ROW_NUMBER() OVER (ORDER BY COUNT(diag_3) DESC) AS rank
FROM generalmed g 
GROUP BY diag_3
ORDER BY COUNT(diag_3) DESC ;

/* Action 4: Calculate average length of hospital stay for each admission type */
SELECT admission_type_id, ROUND(AVG(time_in_hospital),0) AS avg_time_hosp
FROM patientinfo p 
GROUP BY admission_type_id
ORDER BY admission_type_id ASC ;
	/* The average time spent in the hospital ranges from 3-5 days. Admission type id's 
	 * 2, 6, and 7 have the highest averages, with 5 days spent in the hospital on average. */

/* What is the average time in the hospital according to specialty medicine? */
SELECT g.medical_specialty, ROUND(AVG(p.time_in_hospital),0) AS avg_time_hosp
FROM patientinfo p 
LEFT JOIN generalmed g ON p.patient_nbr = g.patient_nbr 
WHERE g.medical_specialty <> '?' -- EXCLUDING '?' since they ARE LIKE N/As
GROUP BY g.medical_specialty 
ORDER BY ROUND(AVG(p.time_in_hospital),0) DESC ;
	/* The 2 specialties with the highest average times in the hospital are both related to pediatrics.
	 * One being related to allergies & the other pulmonology (lungs). */

/* Is there anything to learn about average time in the hospital by age?
 * It seems likely that the older someone is, the longer they would be in the
 * hospital since they are more likely to need medical attention. */
SELECT age, ROUND(AVG(time_in_hospital),0) AS avg_time_hosp  
FROM patientinfo p 
GROUP BY age 
ORDER BY ROUND(AVG(time_in_hospital),0) DESC ;
	/* As expected, the older age ranges on average spend more time in the hospital. Overall
	 * there seems to be a positive trend with age ranges and average time spent in the hospital. */

/* Action 5: Determine the number of readmitted patients and the percentage of total encounters that they represent. */
SELECT COUNT(readmitted) as readmitted_count 
FROM diabetes d
WHERE readmitted = '>30' OR '<30'

SELECT (35545/101766)

/* Action 6: Identify the age distribution of patients */
SELECT age, COUNT(DISTINCT patient_nbr) AS age_count 
FROM patientinfo p
GROUP BY age 
	/* Large uptick in the number of patients in the age groups [50-60), [60-70), [70-80), [80-90). This would make sense
	 * as health deteriorates with age. */

/* What is the count of people who have been re-admited grouped by age? */
SELECT age, COUNT(DISTINCT patient_nbr) re_admitted_patient_count
FROM patientinfo p 
WHERE readmitted IS NOT 'NO'
GROUP BY age 
	/* Similar relationship here with age and patient count as seen in previous table. */


/* Action 7: Identify the most common procedures performed during patient encounters */

/* Action 8: Calculate average num. of medications prescribed for patients in each age group */
SELECT p.age, ROUND(AVG(g.num_medications),0) AS avg_med_count
FROM patientinfo p
LEFT JOIN generalmed g ON p.patient_nbr = g.patient_nbr 
GROUP BY p.age 
ORDER BY ROUND(AVG(g.num_medications),0) DESC ;
	/* The average number of medications for the age groups mainly ranges from the low to high teens, with the exception of
	 * age groups 0-20, that fall below 10 average meds. The 3 highest groups are 50-80, all at 17 average meds or higher. */

/* Could there be a positive relationship between average num. of medication and the number of procedures a patient
 * receives during their visit? */
SELECT num_lab_procedures, ROUND(AVG(num_medications),0) AS avg_med_count
FROM generalmed g 
GROUP BY num_lab_procedures 
ORDER BY ROUND(AVG(num_medications),0) DESC ;
	/* Seems as if there could possibly be a weak relationship at the very least. For lower number of lab procedures, there is usually
	 * a lower average of total meds and it seems to increase steadily as the number of lab procedures increase. */

/* Could there be a positive relationship between average num. of medication and the number of diagnoses a patient
 * receives during their visit? */
SELECT number_diagnoses , ROUND(AVG(num_medications),0) AS avg_med_count
FROM generalmed g 
GROUP BY number_diagnoses 
ORDER BY ROUND(AVG(num_medications),0) DESC ;
	/* There seems to be a strong positive relationship between the number of diagnoses a patient has and the average amount 
	 * of medication taken. */

/* Action 9: Identify the distribution of readmission rates across diff. payer codes */
/* Exclude patients who aren't re-admitted */
SELECT COUNT(readmitted) AS readmitted_count, payer_code 
FROM patientinfo p
WHERE readmitted IS NOT 'NO'
GROUP BY payer_code 
ORDER BY COUNT(DISTINCT patient_nbr) DESC;
	/* By a significant amount, the payercode MC has the second highest amount of uses for re-admitted patients. It almost reaches 16K,
	 * while the next highest payer code doesn't even break 3,000. The top payercode is actually an unknown one. It would be interesting
	 * to know if the '?' means they did not pay/if the balance is still outstanding. */

/* Within the MC payer code, what does the age distribution look like? */
SELECT COUNT(readmitted) AS readmitted_count, payer_code, age 
FROM patientinfo p 
WHERE readmitted IS NOT 'NO'
GROUP BY payer_code, age
HAVING payer_code = 'MC' ;
	/* The majority of the age group that makes up patients using the MC payer code, is the [70-80) age range, folowed by
	 * [80-90) in second & [60-70) in third. It could be that MC is a health insurance company mainly targeted toward the elderly.*/





























