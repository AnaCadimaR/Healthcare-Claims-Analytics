-- KPI 1: DATASET
SELECT
  COUNT(*) AS total_claims,
  COUNT(DISTINCT Provider) AS total_providers,
  COUNT(DISTINCT BeneID) AS total_beneficiaries
FROM fraud_dataset.claims_enriched;

-- KPI 2: Amount of Money per Claim Type
SELECT 
  ClaimType,
  SUM(InscClaimAmtReimbursed) AS total_reimbursement,
  AVG(InscClaimAmtReimbursed) AS avg_claim
FROM fraud_dataset.claims_enriched
GROUP BY ClaimType
ORDER BY total_reimbursement DESC;

SELECT *
FROM fraud_dataset.claims_enriched


-- KPI 3: Top Providers
SELECT Provider,
COUNT(*) AS claims,
SUM(InscClaimAmtReimbursed) AS reimbursement
FROM fraud_dataset.claims_enriched
GROUP BY Provider
ORDER BY reimbursement DESC
LIMIT 10;

-- KPI 4: How much time does it take to close claim transactions?
SELECT ClaimType,
ROUND(AVG(claim_duration),2) AS avg_days,
MIN(claim_duration) AS min_days,
MAX(claim_duration) AS max_days
FROM fraud_dataset.claims_enriched
WHERE claim_duration IS NOT NULL
GROUP BY ClaimType;
