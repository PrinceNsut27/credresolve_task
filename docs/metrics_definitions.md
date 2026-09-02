# Recovery Metrics & Measurement Framework

**Project**: Collections Recovery Analytics Platform  
**Phase**: 2 — Recovery Performance Measurement Layer & Claim Validation  
**Status**: APPROVED & ACTIVE  

---

## 1. Executive Summary & Measurement Philosophy

This framework establishes the mathematical, operational, and structural definitions for all recovery performance metrics. Every metric is anchored to a defined analytical grain, explicit numerator, defensible denominator, and governed attribution window to prevent measurement manipulation, survivorship bias, and metric duplication.

---

## 2. Master Performance Population & Denominator Rules

### 2.1 The Fixed Master Portfolio (Primary Denominator)
- **Definition**: All **30,000 unique loan accounts** present in `clean_accounts`.
- **Governing Principle**: **Denominators must never shrink simply because an account was uncontacted, delinquent, or written off.**
- **Rationale**: Shrinking the denominator to only "engaged" or "attempted" accounts creates severe selection bias, falsely inflating conversion and recovery rates.

### 2.2 Reconstructed Point-in-Time Status (Secondary Portfolio Filter)
- **Definition**: The active delinquent population as of month-end derived from `clean_account_status_history` (`pit_status IN ('ACTIVE', 'DELINQUENT', 'PTP', 'NPA')`).
- **Use Case**: Used specifically for tracking delinquency migration and bucket transition rates.

---

## 3. Comprehensive Metric Definitions

### 3.1 Contact Rate (Omnichannel & Voice)

#### A. Omnichannel Contact Rate
- **Business Meaning**: Percentage of attempted accounts successfully contacted across any channel (Voice answered, Field contacted, WhatsApp clicked, SMS clicked).
- **Numerator**: Unique accounts with `is_contacted_any_channel = 1` in the analysis month.
- **Denominator**: Unique accounts with at least one outreach attempt across any channel during the month (`attempted_accounts`).
- **Grain**: `account_id × analysis_month`.
- **Mathematical Formula**:
  $$\text{Omnichannel Contact Rate} = \frac{\text{Contacted Accounts}}{\text{Attempted Accounts}} \times 100$$
- **Duplicate Treatment**: Multiple touches per account count as **1 contacted account**.

#### B. Voice Contact Rate
- **Business Meaning**: Percentage of dialed accounts where at least one voice call was answered.
- **Numerator**: Unique accounts with `answered_calls > 0` (`call_status == 'ANSWERED'`).
- **Denominator**: Unique accounts with at least one call attempt (`total_calls > 0`).
- **Formula**:
  $$\text{Voice Contact Rate} = \frac{\text{Accounts with Answered Call}}{\text{Accounts Dialed}} \times 100$$

---

### 3.2 Right Party Contact (RPC) Rate
- **Business Meaning**: Percentage of contacted accounts where an agent spoke directly to the decision-maker / borrower.
- **Numerator**: Unique accounts with at least one RPC disposition (`is_rpc_any_channel = 1`, comprising dispositions `PTP`, `CALLBACK`, `DISPUTE`, `REFUSED`, `PAID`).
- **Denominator**: Unique accounts successfully contacted (`contacted_accounts`).
- **Grain**: `account_id × analysis_month`.
- **Formula**:
  $$\text{RPC Rate} = \frac{\text{RPC Accounts}}{\text{Contacted Accounts}} \times 100$$
- **Taxonomy Normalization**: Legacy `PROMISE_TO_PAY` is harmonized into `PTP`. Administrative codes (`NO_CONTACT`, `WRONG_NUMBER`) are excluded from RPC.

---

### 3.3 Promise-to-Pay (PTP) Rate
- **Business Meaning**: Conversion efficiency of Right Party Contacts into concrete payment commitments.
- **Numerator**: Unique accounts creating at least one valid PTP commitment during the month (`has_ptp = 1`).
- **Denominator**: Unique accounts with Right Party Contact (`rpc_accounts`).
- **Grain**: `account_id × analysis_month`.
- **Formula**:
  $$\text{PTP Rate} = \frac{\text{PTP Accounts}}{\text{RPC Accounts}} \times 100$$

---

### 3.4 PTP Kept Rate (Fulfillment Rate)
- **Business Meaning**: Percentage of negotiated PTP commitments that resulted in full or partial payment fulfillment on or before the promised date.
- **Numerator**: PTP events with status `KEPT` (`is_kept = 1`).
- **Denominator**: Total eligible PTP commitment events created during the month (`total_ptp_events`).
- **Grain**: `ptp_id` (Event Grain) aggregated to `analysis_month`.
- **Formula**:
  $$\text{PTP Kept Rate} = \frac{\text{Kept PTP Commitments}}{\text{Total PTP Commitments}} \times 100$$
- **Payment Verification**: Linked to `clean_payments` where `payment_status == 'SUCCESS'` and payment date is within $\pm 3$ days of `promised_date`.

---

### 3.5 Valid Recovery Amount (Net Collections)
- **Business Meaning**: Total actual cash collected and settled in the bank ledger during the calendar month.
- **Numerator**: $\sum \text{amount}$ from `clean_payments` where `payment_status == 'SUCCESS'` and `payment_id` is deduplicated.
- **Denominator**: None (Absolute monetary metric in INR).
- **Exclusions**: 
  - `FAILED` transactions (₹283.5M excluded)
  - `PENDING` transactions (₹194.9M excluded)
  - `REVERSED` / Chargeback transactions (₹97.4M excluded)
  - Ingestion Duplicate `SUCCESS` payments (₹25.9M excluded)
- **Formula**:
  $$\text{Valid Recovery Amount} = \sum_{i \in \text{Clean Success}} \text{amount}_i$$

---

### 3.6 Account Recovery Rate
- **Business Meaning**: Proportion of the portfolio that successfully made at least one settled payment during the month.
- **Numerator**: Unique accounts with `success_payment_count > 0` (`has_success_payment = 1`).
- **Denominator**: Total Fixed Master Accounts ($30,000$).
- **Formula**:
  $$\text{Portfolio Account Recovery Rate} = \frac{\text{Recovered Accounts}}{30,000} \times 100$$

---

### 3.7 Recovery Per Account

#### A. Recovery per Portfolio Account (Macro Yield)
- **Formula**:
  $$\text{Recovery / Portfolio Account} = \frac{\text{Valid Recovery Amount}}{30,000}$$

#### B. Recovery per Recovered Account (Average Payer Ticket Size)
- **Formula**:
  $$\text{Recovery / Recovered Account} = \frac{\text{Valid Recovery Amount}}{\text{Recovered Accounts}}$$

---

### 3.8 Recovery Per Agent-Hour (Workforce Productivity)
- **Business Meaning**: Net financial recovery generated per productive agent work hour.
- **Numerator**: Total Valid Recovery Amount (INR) in the month.
- **Denominator**: Total Productive Agent Session Hours in the month from `clean_agent_sessions` ($\sum (\text{logout\_at} - \text{login\_at})$ in hours).
- **Formula**:
  $$\text{Recovery / Agent-Hour} = \frac{\text{Valid Recovery Amount}}{\text{Total Agent Hours}}$$
- **Validation**: Zero/negative session durations were audited (0 found; mean session length 5.26 hours).

---

### 3.9 Month-over-Month (MoM) Growth Rate
- **Formula**:
  $$\text{MoM \% Change}_t = \frac{\text{Metric}_t - \text{Metric}_{t-1}}{\text{Metric}_{t-1}} \times 100$$

### 3.11 Operational Cost Per ₹ Recovered
- **Business Meaning**: Measures total operational expenditure (workforce + dialer carrier + digital messaging + field visits) required to collect ₹1.00 of net valid recovery.
- **Numerator**: $\text{Total Operational Cost} = (\text{Agent Hours} \times ₹250) + (\text{Dialer Mins} \times ₹0.50) + (\text{WhatsApp Sent} \times ₹0.25) + (\text{SMS Sent} \times ₹0.15) + (\text{Field Visits} \times ₹350)$.
- **Denominator**: Total Valid Recovery Amount (INR) in the month.
- **Formula**:
  $$\text{Cost per ₹ Recovered} = \frac{\text{Total Operational Costs}}{\text{Valid Recovery Amount}}$$
- **Potential Bias & Denominator Manipulation**: If failed/reversed payments are included in the denominator, the cost per rupee appears artificially low.
- **Appropriateness**: Anchoring strictly to clean settled SUCCESS recovery reflects true economic collection cost.

---

### 3.12 Channel Conversion Rate
- **Business Meaning**: Efficiency of each collection channel in directly producing settled recovery payments within the standardized 7-day lookback window.
- **Numerator**: Total Net Valid Recovery Amount (or payment transaction count) attributed to Channel $C$ under the 7-day last-touch rule.
- **Denominator**: Total Gross Operational Touches / Dispatches dispatched via Channel $C$.
- **Formula**:
  $$\text{Channel Yield per Touch} = \frac{\text{Attributed Recovery via Channel } C}{\text{Total Outbound Touches in Channel } C}$$
- **Potential Bias**: Overly wide attribution windows (e.g. 30 days) claim unearned credit for organic customer self-cure payments.
- **Appropriateness**: The 7-day window balances responsiveness with realistic consumer payment friction.

---

## 4. Summary Metric Governance Matrix

| Metric Name | Numerator | Denominator | Formula | Business Meaning | Potential Bias | Why Definition is Appropriate |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Omnichannel Contact Rate** | Contacted Accounts | Attempted Accounts | $\frac{\text{Contacted}}{\text{Attempted}} \times 100$ | Broad reach across all touchpoints | Inactive accounts excluded from attempt base | Accurately evaluates campaign dialer/dispatch reach |
| **Voice Contact Rate** | Answered Voice Accounts | Dialed Accounts | $\frac{\text{Answered}}{\text{Dialed}} \times 100$ | Telephony live connection efficiency | Does not distinguish voicemail vs live person | Measures direct telephony carrier connection quality |
| **RPC Rate** | Right Party Contact Accounts | Contacted Accounts | $\frac{\text{RPC}}{\text{Contacted}} \times 100$ | Ratio of contacts that reach the actual borrower | Wrong numbers falsely counted if unharmonized | Evaluates skip-tracing and contact data accuracy |
| **PTP Rate** | Promise to Pay Accounts | RPC Accounts | $\frac{\text{PTP}}{\text{RPC}} \times 100$ | Negotiation conversion of live borrower conversations | Agent aggressiveness can create false PTPs | Direct measure of agent negotiation effectiveness |
| **PTP Kept Rate** | Kept PTP Commitments | Total PTP Commitments | $\frac{\text{Kept PTP}}{\text{Total PTP}} \times 100$ | Realization / fulfillment rate of promises | Broken PTPs hidden if not tracked longitudinally | Evaluates commitment quality and borrower intent |
| **Valid Recovery Amount** | Sum of Clean SUCCESS Payments | N/A | $\sum \text{amount}_{\text{clean success}}$ | True settled cash received in bank | Uncleaned data overstates recovery by +45.7% | Eliminates failed, pending, reversed, and duplicate rows |
| **Portfolio Recovery Rate** | Recovered Accounts | 30,000 Master Accounts | $\frac{\text{Recovered Accounts}}{30,000} \times 100$ | True macro portfolio penetration | Shrinking denominator artificially inflates rate | Prevents denominator manipulation across all months |
| **Recovery per Portfolio Account**| Valid Recovery Amount | 30,000 Master Accounts | $\frac{\text{Valid Recovery}}{30,000}$ | Average monetary recovery yield per loan | Skewed if inactive accounts are removed | Reflects macro portfolio cash generation |
| **Recovery per Recovered Account**| Valid Recovery Amount | Recovered Accounts | $\frac{\text{Valid Recovery}}{\text{Recovered Accounts}}$ | Average ticket size of paying borrowers | High-value outliers can distort average | Isolates ticket-size shifts from account volume shifts |
| **Recovery per Agent-Hour** | Valid Recovery Amount | Productive Agent Hours | $\frac{\text{Valid Recovery}}{\text{Total Agent Hours}}$ | Labor productivity of collections workforce | Overstated if non-voice digital recovery is credited | Evaluates workforce financial return per paid labor hour |
| **Daily Average Recovery** | Valid Recovery Amount | Calendar Days in Month | $\frac{\text{Valid Recovery}}{\text{Calendar Days}}$ | True operational daily run-rate | 28-day Feb vs 31-day Mar creates +10.7% illusion | Eliminates calendar-day length distortion entirely |
| **Cost per ₹ Recovered** | Total Operational Cost | Valid Recovery Amount | $\frac{\text{Total Cost}}{\text{Valid Recovery}}$ | Total collection expenditure per rupee collected | Fixed costs omitted if only variable cost is used | Provides true bottom-line unit economics |
| **Channel Conversion** | Attributed Recovery | Total Channel Touches | $\frac{\text{Attributed Recovery}}{\text{Outbound Touches}}$ | Yield per channel intervention | Last-touch credit distortion across wide windows | Guides optimal channel mix allocation |

