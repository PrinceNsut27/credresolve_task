-- ==============================================================================
-- 02_CLEANING.SQL — PRODUCTION CLEANSING & HARMONIZATION LAYER
-- Project: Collections Analytics Data Platform
-- Phase: 1 (Data Quality, Forensics & Golden Dataset)
-- Description: Performs entity resolution, deduplication, surrogate key standardization,
--              status filtering, and timezone harmonization across all operational tables.
-- ==============================================================================

-- 1. Clean Borrowers Dimension (Entity Resolution & Deduplication)
-- Logic: Remove exact duplicates; resolve multi-record collisions by selecting
--        the latest updated_at record per borrower_id.
CREATE OR REPLACE VIEW clean_borrowers_view AS
WITH ranked_borrowers AS (
    SELECT 
        borrower_id,
        name,
        COALESCE(phone, 'UNKNOWN') AS phone,
        COALESCE(email, 'UNKNOWN') AS email,
        city,
        state,
        created_at,
        updated_at,
        ROW_NUMBER() OVER (
            PARTITION BY borrower_id 
            ORDER BY updated_at DESC, created_at DESC
        ) AS rn
    FROM stg_borrowers
)
SELECT 
    borrower_id,
    name,
    phone,
    email,
    city,
    state,
    created_at,
    updated_at
FROM ranked_borrowers
WHERE rn = 1;

-- 2. Clean Agents Dimension (SCD / Historical State Resolution)
-- Logic: Select the latest updated_at record per agent_id; correct joined_at vs updated_at inversion.
CREATE OR REPLACE VIEW clean_agents_view AS
WITH ranked_agents AS (
    SELECT 
        agent_id,
        employee_code,
        agent_name,
        vendor_id,
        team,
        status,
        joined_at,
        updated_at,
        CASE 
            WHEN joined_at > updated_at THEN updated_at 
            ELSE joined_at 
        END AS joined_at_clean,
        ROW_NUMBER() OVER (
            PARTITION BY agent_id 
            ORDER BY updated_at DESC
        ) AS rn
    FROM stg_agents
)
SELECT 
    agent_id,
    employee_code,
    agent_name,
    vendor_id,
    team,
    status,
    joined_at_clean AS joined_at,
    updated_at
FROM ranked_agents
WHERE rn = 1;

-- 3. Clean Accounts Master
-- Logic: Deduplicate on account_id; tag unlinked borrower_ids.
CREATE OR REPLACE VIEW clean_accounts_view AS
SELECT 
    account_id,
    COALESCE(borrower_id, 'UNKNOWN_BORROWER') AS borrower_id,
    loan_type,
    principal_amount,
    outstanding_amount,
    dpd,
    risk_segment,
    status,
    opened_at,
    timezone,
    schema_version
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY opened_at ASC) AS rn
    FROM stg_accounts
) a
WHERE rn = 1;

-- 4. Clean Calls Transaction Table
-- Logic: Deduplicate on call_id; impute null agent_id with 'SYSTEM_IVR'; tag answer status.
CREATE OR REPLACE VIEW clean_calls_view AS
SELECT 
    call_id,
    account_id,
    borrower_id,
    event_at,
    COALESCE(agent_id, 'SYSTEM_IVR') AS agent_id,
    campaign_id,
    direction,
    vendor_id,
    call_status,
    duration_sec,
    timezone,
    CASE WHEN call_status = 'ANSWERED' THEN 1 ELSE 0 END AS is_answered
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY call_id ORDER BY event_at ASC) AS rn
    FROM stg_calls
) c
WHERE rn = 1;

-- 5. Clean Call Dispositions
-- Logic: Deduplicate on disposition_id; standardize PROMISE_TO_PAY -> PTP; tag Right Party Contact (RPC).
CREATE OR REPLACE VIEW clean_call_dispositions_view AS
SELECT 
    disposition_id,
    account_id,
    borrower_id,
    event_at,
    call_id,
    agent_id,
    CASE 
        WHEN disposition_code = 'PROMISE_TO_PAY' THEN 'PTP' 
        ELSE disposition_code 
    END AS disposition_code_clean,
    disposition_version,
    CASE 
        WHEN disposition_code IN ('PTP', 'PROMISE_TO_PAY', 'CALLBACK', 'DISPUTE', 'REFUSED', 'PAID') THEN 1 
        ELSE 0 
    END AS is_rpc
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY disposition_id ORDER BY event_at ASC) AS rn
    FROM stg_call_dispositions
) cd
WHERE rn = 1;

-- 6. Clean Financial Payments Ledger (SUCCESS Only)
-- Logic: Filter strictly for payment_status = 'SUCCESS'; deduplicate on payment_id to eliminate
--        gross financial recovery overstatement.
CREATE OR REPLACE VIEW clean_payments_success_view AS
SELECT 
    payment_id,
    account_id,
    borrower_id,
    event_at,
    payment_reference,
    amount,
    payment_status,
    payment_method,
    provider_id
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY payment_id ORDER BY event_at ASC) AS rn
    FROM stg_payments
    WHERE payment_status = 'SUCCESS'
) p
WHERE rn = 1;

-- 7. Clean Financial Payments Ledger (All Settlement Statuses for Forensic Audit)
CREATE OR REPLACE VIEW clean_payments_all_status_view AS
SELECT 
    payment_id,
    account_id,
    borrower_id,
    event_at,
    payment_reference,
    amount,
    payment_status,
    payment_method,
    provider_id,
    CASE WHEN payment_status = 'SUCCESS' THEN 1 ELSE 0 END AS is_success,
    CASE WHEN payment_status = 'FAILED' THEN 1 ELSE 0 END AS is_failed,
    CASE WHEN payment_status = 'PENDING' THEN 1 ELSE 0 END AS is_pending,
    CASE WHEN payment_status = 'REVERSED' THEN 1 ELSE 0 END AS is_reversed
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY payment_id ORDER BY event_at ASC) AS rn
    FROM stg_payments
) p
WHERE rn = 1;

-- 8. Clean Digital Channels (WhatsApp & SMS)
CREATE OR REPLACE VIEW clean_whatsapp_events_view AS
SELECT 
    whatsapp_event_id,
    account_id,
    borrower_id,
    event_at,
    message_id,
    event_type,
    template_code,
    provider_id,
    CASE WHEN event_type = 'SENT' THEN 1 ELSE 0 END AS is_sent,
    CASE WHEN event_type = 'DELIVERED' THEN 1 ELSE 0 END AS is_delivered,
    CASE WHEN event_type = 'READ' THEN 1 ELSE 0 END AS is_read,
    CASE WHEN event_type = 'PAYMENT_CLICK' THEN 1 ELSE 0 END AS is_click
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY whatsapp_event_id ORDER BY event_at ASC) AS rn
    FROM stg_whatsapp_events
) wa
WHERE rn = 1;

CREATE OR REPLACE VIEW clean_sms_events_view AS
SELECT 
    sms_event_id,
    account_id,
    borrower_id,
    event_at,
    message_id,
    event_type,
    template_code,
    provider_id,
    CASE WHEN event_type = 'SENT' THEN 1 ELSE 0 END AS is_sent,
    CASE WHEN event_type = 'DELIVERED' THEN 1 ELSE 0 END AS is_delivered,
    CASE WHEN event_type = 'CLICKED' THEN 1 ELSE 0 END AS is_click
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY sms_event_id ORDER BY event_at ASC) AS rn
    FROM stg_sms_events
) sms
WHERE rn = 1;

-- 9. Clean Field Visits
CREATE OR REPLACE VIEW clean_field_visits_view AS
SELECT 
    visit_id,
    account_id,
    borrower_id,
    event_at,
    agent_id,
    visit_type,
    outcome,
    latitude,
    longitude,
    COALESCE(scheduled_at, event_at) AS scheduled_at_clean,
    CASE WHEN outcome IN ('CONTACTED', 'PTP', 'PAID', 'REFUSED') THEN 1 ELSE 0 END AS is_contacted,
    CASE WHEN outcome = 'PTP' THEN 1 ELSE 0 END AS is_ptp,
    CASE WHEN outcome = 'PAID' THEN 1 ELSE 0 END AS is_paid
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY visit_id ORDER BY event_at ASC) AS rn
    FROM stg_field_visits
) fv
WHERE rn = 1;

-- 10. Clean Promises to Pay
CREATE OR REPLACE VIEW clean_promises_to_pay_view AS
SELECT 
    ptp_id,
    account_id,
    borrower_id,
    event_at,
    agent_id,
    promised_amount,
    promised_date,
    status,
    source,
    CASE WHEN status = 'KEPT' THEN 1 ELSE 0 END AS is_kept,
    CASE WHEN status = 'BROKEN' THEN 1 ELSE 0 END AS is_broken
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY ptp_id ORDER BY event_at ASC) AS rn
    FROM stg_promises_to_pay
) ptp
WHERE rn = 1;

-- 11. Clean Account Status History
CREATE OR REPLACE VIEW clean_account_status_history_view AS
SELECT 
    history_id,
    account_id,
    borrower_id,
    event_at,
    status,
    changed_by,
    source,
    recorded_at
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY history_id ORDER BY event_at ASC) AS rn
    FROM stg_account_status_history
) ash
WHERE rn = 1;
