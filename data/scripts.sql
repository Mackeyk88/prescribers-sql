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

SELECT specialty_description, SUM(total_claim_count) AS total_opioid_claims
FROM prescription as p1
INNER JOIN prescriber as p2
ON p1.npi = p2.npi
INNER JOIN drug AS d1
ON p1.drug_name = d1.drug_name
WHERE opioid_drug_flag = 'Y'
GROUP BY specialty_description
ORDER BY total_opioid_claims DESC
-- Nurse Practitioner 900

SELECT specialty_description, (total_claim_count / 
    (SELECT total_claim_count
    FROM prescription AS p1
    INNER JOIN drug AS d1
    ON p1.drug_name = d1.drug_name
    WHERE opioid_drug_flag = 'Y')) AS subq
FROM prescription AS p1
INNER JOIN drug AS d1
ON p1.drug_name = d1.drug_name 
INNER JOIN prescriber AS p2
ON p1.npi = p2.npi



SELECT generic_name, SUM(total_drug_cost) AS total_cost
FROM drug as d1
INNER JOIN prescription AS p1
ON d1.drug_name = p1.drug_name
GROUP BY generic_name
ORDER BY total_cost DESC
-- Insulin Gargine, HUM.REC.AnLOG  $104,264,066.35

-- SELECT generic_name, ROUND((SUM(total_drug_cost/total_30_day_fill_count)/30),2) AS total_cost
-- FROM drug as d1
-- INNER JOIN prescription AS p1
-- ON d1.drug_name = p1.drug_name
-- GROUP BY generic_name
-- ORDER BY total_cost DESC
-- -- "LEDIPASVIR/SOFOSBUVIR"  $82,386.15

-- SELECT generic_name, ROUND(SUM((total_drug_cost)/total_day_supply),2) AS total_cost
-- FROM drug as d1
-- INNER JOIN prescription AS p1
-- ON d1.drug_name = p1.drug_name
-- GROUP BY generic_name
-- ORDER BY total_cost DESC



SELECT drug_name,
CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
     WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
     ELSE 'Neither' END AS drug_type
     FROM drug


SELECT subq.drug_type, CAST(SUM(total_drug_cost) as money) AS total_cost
FROM 
    (SELECT drug_name,
        CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
        WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
        ELSE 'Neither' END AS drug_type
        FROM drug) AS subq
LEFT JOIN prescription
ON subq.drug_name = prescription.drug_name
WHERE drug_type = 'opioid' OR drug_type = 'antibiotic' 
GROUP BY subq.drug_type
ORDER BY total_cost DESC
-- Opioid Total Cost - "$105,080,626.37"
-- Antibiotic Total Cost - "$38,435,121.26"

SELECT state, COUNT(DISTINCT cbsa) AS number_of_cbsa
FROM fips_county AS fc
INNER JOIN cbsa AS cb
ON fc.fipscounty = cb.fipscounty
WHERE state = 'TN'
GROUP BY state
-- 10

SELECT cbsa, SUM(population) AS total_pop
FROM cbsa AS cb
INNER JOIN population AS pop
ON cb.fipscounty = pop.fipscounty
INNER JOIN fips_county AS fc
ON cb.fipscounty = fc.fipscounty
WHERE state = 'TN'
GROUP BY cbsa
ORDER BY total_pop DESC
-- Highest Total pop - "34980"  1830410
-- Smallest Total pop - "34100"  116352

SELECT county, cbsa, SUM(population) AS total_pop
FROM fips_county AS fc
LEFT JOIN cbsa AS cb
ON fc.fipscounty = cb.fipscounty
LEFT JOIN population AS pop
ON fc.fipscounty = pop.fipscounty
WHERE TRUE
AND cb.cbsa IS NULL AND state = 'TN' 
GROUP BY county, cbsa
ORDER BY total_pop DESC
-- Sevier 95523

SELECT drug_name, total_claim_count
FROM prescription
WHERE total_claim_count >= 3000
                 
SELECT p1.drug_name, p1.total_claim_count, d1.opioid_drug_flag
FROM prescription AS p1
INNER JOIN drug AS d1
ON p1.drug_name = d1.drug_name
WHERE total_claim_count >= 3000 AND opioid_drug_flag = 'Y'

SELECT nppes_provider_first_name, nppes_provider_last_org_name, p1.drug_name, p1.total_claim_count, d1.opioid_drug_flag
FROM prescription AS p1
INNER JOIN drug AS d1
ON p1.drug_name = d1.drug_name
INNER JOIN prescriber AS p2
ON p1.npi = p2.npi
WHERE total_claim_count >= 3000 AND opioid_drug_flag = 'Y'

SELECT specialty_description, npi, drug_name
FROM prescriber AS p1
CROSS JOIN drug AS d1
WHERE nppes_provider_city = 'NASHVILLE' AND opioid_drug_flag = 'Y' AND specialty_description = 'Pain Management'





