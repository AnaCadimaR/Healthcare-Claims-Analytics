CREATE OR REPLACE TABLE fraud_dataset.claims_enriched AS
SELECT 
  BeneID,
  ClaimID,
  DATE(ClaimStartDt) AS ClaimStartDt,
  DATE(ClaimEndDt) AS ClaimEndDt,
  Provider,
  
  SAFE_CAST(
    REGEXP_REPLACE(CAST(InscClaimAmtReimbursed AS STRING), r'[$\s,]', '') 
    AS INT64
  ) AS InscClaimAmtReimbursed,

  SAFE_CAST(
    NULLIF(REGEXP_REPLACE(CAST(DeductibleAmtPaid AS STRING), r'[$\s,]', ''), 'NA')
    AS INT64
  ) AS DeductibleAmtPaid,

  DATE(AdmissionDt) AS AdmissionDt,
  DATE(DischargeDt) AS DischargeDt,
  'Inpatient' AS ClaimType,
  EXTRACT(YEAR FROM DATE(ClaimStartDt)) AS claim_year,
  DATE_DIFF(DATE(DischargeDt), DATE(AdmissionDt), DAY) AS claim_duration
FROM `fraud_dataset.InPatient Data`

UNION ALL

SELECT 
  BeneID,
  ClaimID,
  DATE(ClaimStartDt),
  DATE(ClaimEndDt),
  Provider,
  SAFE_CAST(REGEXP_REPLACE(CAST(InscClaimAmtReimbursed AS STRING), r'[$\s,]', '') AS INT64),
  SAFE_CAST(NULLIF(REGEXP_REPLACE(CAST(DeductibleAmtPaid AS STRING), r'[$\s,]', ''), 'NA') AS INT64),
  NULL,
  NULL,
  'Outpatient',
  EXTRACT(YEAR FROM DATE(ClaimStartDt)),
  NULL
FROM `fraud_dataset.OutPatient Data`;
