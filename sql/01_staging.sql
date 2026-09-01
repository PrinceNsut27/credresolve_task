-- ==============================================================================
-- 01_STAGING.SQL — PRODUCTION STAGING LAYER DDL & INGESTION
-- Project: Collections Analytics Data Platform
-- Phase: 1 (Data Quality, Forensics & Golden Dataset)
-- Description: Creates raw staging tables with explicit data contracts, preserving
--              raw source payloads before downstream cleansing and harmonization.
-- ==============================================================================

-- 1. Accounts Master Staging
CREATE TABLE IF NOT EXISTS stg_accounts (
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64),
    loan_type VARCHAR(32) NOT NULL,
    principal_amount NUMERIC(15, 2) NOT NULL,
    outstanding_amount NUMERIC(15, 2) NOT NULL,
    dpd INTEGER NOT NULL,
    risk_segment VARCHAR(16) NOT NULL,
    status VARCHAR(32) NOT NULL,
    opened_at TIMESTAMP NOT NULL,
    timezone VARCHAR(32) NOT NULL,
    schema_version VARCHAR(16) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Borrowers Master Staging
CREATE TABLE IF NOT EXISTS stg_borrowers (
    borrower_id VARCHAR(64) NOT NULL,
    name VARCHAR(255),
    phone VARCHAR(64),
    email VARCHAR(255),
    city VARCHAR(128),
    state VARCHAR(128),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Agents Master Staging
CREATE TABLE IF NOT EXISTS stg_agents (
    agent_id VARCHAR(64) NOT NULL,
    employee_code VARCHAR(64) NOT NULL,
    agent_name VARCHAR(255) NOT NULL,
    vendor_id VARCHAR(64) NOT NULL,
    team VARCHAR(64) NOT NULL,
    status VARCHAR(32) NOT NULL,
    joined_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Agent Sessions Staging
CREATE TABLE IF NOT EXISTS stg_agent_sessions (
    session_id VARCHAR(64) NOT NULL,
    agent_id VARCHAR(64) NOT NULL,
    login_at TIMESTAMP NOT NULL,
    logout_at TIMESTAMP NOT NULL,
    channel VARCHAR(32) NOT NULL,
    device_id VARCHAR(64) NOT NULL,
    timezone VARCHAR(32) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Campaigns Configuration Staging
CREATE TABLE IF NOT EXISTS stg_campaigns (
    campaign_id VARCHAR(64) NOT NULL,
    campaign_name VARCHAR(255) NOT NULL,
    channel VARCHAR(32) NOT NULL,
    strategy_version VARCHAR(32) NOT NULL,
    start_at TIMESTAMP NOT NULL,
    end_at TIMESTAMP NOT NULL,
    target_definition VARCHAR(128) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Daily Targeting Allocation Staging
CREATE TABLE IF NOT EXISTS stg_daily_targeting (
    target_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    campaign_id VARCHAR(64) NOT NULL,
    target_date DATE NOT NULL,
    priority INTEGER NOT NULL,
    recommended_channel VARCHAR(32) NOT NULL,
    status VARCHAR(32) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Calls Master Staging
CREATE TABLE IF NOT EXISTS stg_calls (
    call_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64) NOT NULL,
    event_at TIMESTAMP NOT NULL,
    agent_id VARCHAR(64),
    campaign_id VARCHAR(64) NOT NULL,
    direction VARCHAR(16) NOT NULL,
    vendor_id VARCHAR(64) NOT NULL,
    call_status VARCHAR(32) NOT NULL,
    duration_sec INTEGER NOT NULL,
    timezone VARCHAR(32),
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Call Attempts Staging
CREATE TABLE IF NOT EXISTS stg_call_attempts (
    attempt_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64) NOT NULL,
    event_at TIMESTAMP NOT NULL,
    call_id VARCHAR(64) NOT NULL,
    agent_id VARCHAR(64) NOT NULL,
    attempt_no INTEGER NOT NULL,
    vendor_id VARCHAR(64),
    attempt_status VARCHAR(32) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Call Dispositions Staging
CREATE TABLE IF NOT EXISTS stg_call_dispositions (
    disposition_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64) NOT NULL,
    event_at TIMESTAMP NOT NULL,
    call_id VARCHAR(64) NOT NULL,
    agent_id VARCHAR(64) NOT NULL,
    disposition_code VARCHAR(64) NOT NULL,
    disposition_version VARCHAR(32) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. WhatsApp Digital Events Staging
CREATE TABLE IF NOT EXISTS stg_whatsapp_events (
    whatsapp_event_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64) NOT NULL,
    event_at TIMESTAMP NOT NULL,
    message_id VARCHAR(64) NOT NULL,
    event_type VARCHAR(32) NOT NULL,
    template_code VARCHAR(64) NOT NULL,
    provider_id VARCHAR(64) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. SMS Digital Events Staging
CREATE TABLE IF NOT EXISTS stg_sms_events (
    sms_event_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64) NOT NULL,
    event_at TIMESTAMP NOT NULL,
    message_id VARCHAR(64) NOT NULL,
    event_type VARCHAR(32) NOT NULL,
    template_code VARCHAR(64) NOT NULL,
    provider_id VARCHAR(64) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. Field Operations Visits Staging
CREATE TABLE IF NOT EXISTS stg_field_visits (
    visit_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64) NOT NULL,
    event_at TIMESTAMP NOT NULL,
    agent_id VARCHAR(64) NOT NULL,
    visit_type VARCHAR(32) NOT NULL,
    outcome VARCHAR(32) NOT NULL,
    latitude NUMERIC(10, 6),
    longitude NUMERIC(10, 6),
    scheduled_at TIMESTAMP,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 13. Promises to Pay (PTP) Commitments Staging
CREATE TABLE IF NOT EXISTS stg_promises_to_pay (
    ptp_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64) NOT NULL,
    event_at TIMESTAMP NOT NULL,
    agent_id VARCHAR(64) NOT NULL,
    promised_amount NUMERIC(15, 2) NOT NULL,
    promised_date TIMESTAMP NOT NULL,
    status VARCHAR(32) NOT NULL,
    source VARCHAR(32) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 14. Financial Payments Transactions Staging
CREATE TABLE IF NOT EXISTS stg_payments (
    payment_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64) NOT NULL,
    event_at TIMESTAMP NOT NULL,
    payment_reference VARCHAR(128),
    amount NUMERIC(15, 2) NOT NULL,
    payment_status VARCHAR(32) NOT NULL,
    payment_method VARCHAR(32) NOT NULL,
    provider_id VARCHAR(64) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 15. Vendor Telephony Configuration Staging
CREATE TABLE IF NOT EXISTS stg_vendor_telephony (
    vendor_id VARCHAR(64) NOT NULL,
    vendor_name VARCHAR(128) NOT NULL,
    vendor_account_id VARCHAR(64) NOT NULL,
    timezone VARCHAR(32) NOT NULL,
    status VARCHAR(32) NOT NULL,
    schema_version VARCHAR(16) NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 16. Grievance Complaints Staging
CREATE TABLE IF NOT EXISTS stg_complaints (
    complaint_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64) NOT NULL,
    event_at TIMESTAMP NOT NULL,
    complaint_type VARCHAR(64) NOT NULL,
    severity VARCHAR(32) NOT NULL,
    status VARCHAR(32) NOT NULL,
    source VARCHAR(32) NOT NULL,
    resolution_at TIMESTAMP,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 17. Account Lifecycle State History Staging
CREATE TABLE IF NOT EXISTS stg_account_status_history (
    history_id VARCHAR(64) NOT NULL,
    account_id VARCHAR(64) NOT NULL,
    borrower_id VARCHAR(64) NOT NULL,
    event_at TIMESTAMP NOT NULL,
    status VARCHAR(32) NOT NULL,
    changed_by VARCHAR(64) NOT NULL,
    source VARCHAR(32) NOT NULL,
    recorded_at TIMESTAMP NOT NULL,
    _staged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
