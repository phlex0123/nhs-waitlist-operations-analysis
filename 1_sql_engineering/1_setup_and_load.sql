-- ==============================================================================
-- NHS Waitlist Operations Analysis - Database Setup & Load Script
-- ==============================================================================

-- 1. Create the Database (Uncomment to execute)
-- CREATE DATABASE nhs_waitlist_db;
-- \c nhs_waitlist_db;

-- ==============================================================================
-- 2. Create Raw Tables
-- ==============================================================================

-- Provider Snapshot Table
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

-- Specialty Snapshot Table
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

-- National Trend Table
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

-- Wait Bands (Time Series) Table
CREATE TABLE raw_wait_bands_weekly_long (
    week_ending DATE,
    wait_band VARCHAR(50),
    patients INT
);

-- Referrals Source Table
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

-- ==============================================================================
-- 3. Import Data
-- Note: Replace 'C:\Your\Local\Path\' with the actual directory containing the CSVs.
-- ==============================================================================

-- COPY raw_provider_latest FROM 'C:\Your\Local\Path\raw_provider_latest.csv' DELIMITER ',' CSV HEADER;
-- COPY raw_specialty_latest FROM 'C:\Your\Local\Path\raw_specialty_latest.csv' DELIMITER ',' CSV HEADER;
-- COPY raw_national_weekly FROM 'C:\Your\Local\Path\raw_national_weekly.csv' DELIMITER ',' CSV HEADER;
-- COPY raw_wait_bands_weekly_long FROM 'C:\Your\Local\Path\raw_wait_bands_weekly_long.csv' DELIMITER ',' CSV HEADER;
-- COPY raw_referrals_by_source_weekly FROM 'C:\Your\Local\Path\raw_referrals_by_source_weekly.csv' DELIMITER ',' CSV HEADER;