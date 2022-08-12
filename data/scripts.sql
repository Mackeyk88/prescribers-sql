SELECT NPI, SUM(total_claim_count) AS total_claim
FROM prescription
GROUP BY NPI
ORDER BY total_claim DESC
-- NPI - 1881634483  total_claim_count - 99707

SELECT nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, SUM(total_claim_count) AS claim_count
FROM prescriber AS p1
INNER JOIN prescription  AS p2
ON p1.npi = p2.npi
GROUP BY nppes_provider_first_name, nppes_provider_last_org_name,specialty_description
ORDER BY claim_count DESC

SELECT specialty_description, SUM(total_claim_count) AS total_claims
FROM prescriber AS p1
INNER JOIN prescription  AS p2
ON p1.npi = p2.npi
GROUP BY specialty_description
ORDER BY total_claims DESC
-- Family Practice 9752347

SELECT specialty_description, COUNT(opioid_drug_flag) AS total_opioid_claims
FROM prescription as p1
INNER JOIN prescriber as p2
ON p1.npi = p2.npi
INNER JOIN drug AS d1
ON p1.drug_name = d1.drug_name
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description
ORDER BY total_opioid_claims DESC
-- Nurse Practitioner 9551

SELECT generic_name, SUM(total_drug_cost) AS total_cost
FROM drug as d1
INNER JOIN prescription AS p1
ON d1.drug_name = p1.drug_name
GROUP BY generic_name
ORDER BY total_cost DESC
-- Insulin Gargine, HUM.REC.AnLOG  $104,264,066.35

SELECT generic_name, ROUND((SUM(total_drug_cost/total_30_day_fill_count)/30),2) AS total_cost
FROM drug as d1
INNER JOIN prescription AS p1
ON d1.drug_name = p1.drug_name
GROUP BY generic_name
ORDER BY total_cost DESC
-- "LEDIPASVIR/SOFOSBUVIR"  $82,386.15

SELECT drug_name,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
     WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
     ELSE 'Neither' END AS drug_type
     FROM drug








