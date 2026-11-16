-- Creating the Provider (Hospital) Snapshot Table

CREATE TABLE raw_provider_latest (
    org_code VARCHAR(50) PRIMARY KEY,
    org_name VARCHAR(255),
    org_type VARCHAR(100),
    total_waiting_list INT,
    wait_0_18w INT,
    wait_18_26w INT,
    wait_26_40w INT,
    wait_40_52w INT,
    wait_52_65w INT,
    wait_65_78w INT,
    wait_78_104w INT,
    wait_104w_plus INT,
    wait_unknown_start INT,
    pct_within_18w DECIMAL(5,2),
    pct_over_52w DECIMAL(5,2),
    first_attendance_within_18w INT,
    waiting_first_attendance INT,
    pct_first_attendance_within_18w DECIMAL(5,2),
    new_rtt_periods INT,
    completed_pathways INT,
    completed_admitted INT,
    completed_non_admitted INT
);

-- Creating the Specialty (Department) Snapshot Table
CREATE TABLE raw_specialty_latest (
    specialty_code VARCHAR(50) PRIMARY KEY,
    specialty VARCHAR(255),
    total_waiting_list INT,
    wait_0_18w INT,
    wait_18_26w INT,
    wait_26_40w INT,
    wait_40_52w INT,
    wait_52_65w INT,
    wait_65_78w INT,
    wait_78_104w INT,
    wait_104w_plus INT,
    wait_unknown_start INT,
    pct_within_18w DECIMAL(5,2),
    pct_over_52w DECIMAL(5,2),
    first_attendance_within_18w INT,
    waiting_first_attendance INT,
    pct_first_attendance_within_18w DECIMAL(5,2),
    new_rtt_periods INT,
    completed_pathways INT,
    completed_admitted INT,
    completed_non_admitted INT
);

-- Creating the National Trend Table
CREATE TABLE raw_national_weekly (
    week_ending DATE PRIMARY KEY,
    acute_providers_submitting INT,
    providers_submitting INT,
    total_waiting_list INT,
    wait_0_18w INT,
    wait_18_26w INT,
    wait_26_40w INT,
    wait_40_52w INT,
    wait_52_65w INT,
    wait_65_78w INT,
    wait_78_104w INT,
    wait_104w_plus INT,
    wait_unknown_start INT,
    pct_within_18w NUMERIC,
    pct_over_52w NUMERIC,
    first_attendance_within_18w NUMERIC,
    waiting_first_attendance NUMERIC,
    pct_first_attendance_within_18w NUMERIC,
    new_rtt_acute_providers INT,
    new_rtt_providers INT,
    new_rtt_periods INT,
    completed_acute_providers INT,
    completed_providers INT,
    completed_pathways INT,
    completed_admitted INT,
    completed_non_admitted INT,
    net_change INT,
    waiting_list_per_provider NUMERIC
);

-- Creating the Wait Bands (Time Series) Table
CREATE TABLE raw_wait_bands_weekly_long (
    week_ending DATE,
    wait_band VARCHAR(50),
    patients INT
);

-- Creating the Referrals Source Table
CREATE TABLE raw_referrals_by_source_weekly (
    week_ending DATE PRIMARY KEY,
    acute_providers_submitting INT,
    providers_submitting INT,
    total INT,
    gp NUMERIC,
    national_screening NUMERIC,
    community_dental NUMERIC,
    optometrist NUMERIC,
    orthoptist NUMERIC,
    prosthetist NUMERIC,
    allied_health_professional NUMERIC,
    consultant NUMERIC,
    specialist_nurse NUMERIC,
    emergency_department NUMERIC,
    self_referral NUMERIC,
    other NUMERIC,
    unknown NUMERIC
);

CREATE OR REPLACE VIEW vw_clean_provider_latest AS
SELECT 
    org_code,
    org_name,
    total_waiting_list,
    
    -- Summing all the extreme waiters into one clean metric
    (COALESCE(wait_52_65w, 0) + COALESCE(wait_65_78w, 0) + 
     COALESCE(wait_78_104w, 0) + COALESCE(wait_104w_plus, 0)) AS total_over_52w,
    
    -- Dynamically recalculating the percentage to fix the NHS error
    ROUND(
        ((COALESCE(wait_52_65w, 0) + COALESCE(wait_65_78w, 0) + 
          COALESCE(wait_78_104w, 0) + COALESCE(wait_104w_plus, 0)) * 100.0) 
        / NULLIF(total_waiting_list, 0), 2
    ) AS true_pct_over_52w,

    -- Recalculating the 18-week compliance metric safely
    ROUND(
        (COALESCE(wait_0_18w, 0) * 100.0) / NULLIF(total_waiting_list, 0), 2
    ) AS true_pct_within_18w

FROM raw_provider_latest
WHERE total_waiting_list > 0;

CREATE OR REPLACE VIEW vw_clean_specialty_latest AS
SELECT 
    specialty_code,
    specialty,
    total_waiting_list,
    
    (COALESCE(wait_52_65w, 0) + COALESCE(wait_65_78w, 0) + 
     COALESCE(wait_78_104w, 0) + COALESCE(wait_104w_plus, 0)) AS total_over_52w,
    
    ROUND(
        ((COALESCE(wait_52_65w, 0) + COALESCE(wait_65_78w, 0) + 
          COALESCE(wait_78_104w, 0) + COALESCE(wait_104w_plus, 0)) * 100.0) 
        / NULLIF(total_waiting_list, 0), 2
    ) AS true_pct_over_52w

FROM raw_specialty_latest
WHERE total_waiting_list > 0;

CREATE OR REPLACE VIEW vw_trend_wait_bands AS
SELECT 
    week_ending,
    wait_band,
    SUM(COALESCE(patients, 0)) AS total_patients
FROM raw_wait_bands_weekly_long
GROUP BY week_ending, wait_band
ORDER BY week_ending ASC;


SELECT * FROM public.vw_clean_provider_latest;
SELECT * FROM public.vw_clean_specialty_latest;
SELECT * FROM public.vw_trend_wait_bands;

CREATE OR REPLACE VIEW vw_trend_inflow_outflow AS
SELECT 
    week_ending,
    SUM(COALESCE(new_rtt_periods, 0)) AS total_inflow_added,
    SUM(COALESCE(completed_pathways, 0)) AS total_outflow_treated,
    -- We calculate the net gap just in case you want to use it in a tooltip later
    SUM(COALESCE(new_rtt_periods, 0)) - SUM(COALESCE(completed_pathways, 0)) AS capacity_deficit
FROM raw_national_weekly
GROUP BY week_ending
ORDER BY week_ending ASC;

CREATE OR REPLACE VIEW vw_clean_referral_sources AS
SELECT 
    week_ending,
    SUM(COALESCE(gp, 0)) AS gp_referrals,
    SUM(COALESCE(consultant, 0)) AS consultant_referrals,
    SUM(COALESCE(emergency_department, 0)) AS a_and_e_referrals,
    SUM(COALESCE(allied_health_professional, 0)) AS allied_health_referrals,
    SUM(COALESCE(optometrist, 0)) AS optometrist_referrals,
    SUM(COALESCE(other, 0) + COALESCE(unknown, 0) + COALESCE(self_referral, 0)) AS other_unknown
FROM raw_referrals_by_source_weekly
GROUP BY week_ending
ORDER BY week_ending ASC;

SELECT * FROM public.vw_trend_inflow_outflow;
SELECT * FROM public.vw_clean_referral_sources;