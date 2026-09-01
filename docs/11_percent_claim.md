# Independent Validation of the "11% Recovery Improvement" Claim

**Project**: Collections Recovery Analytics Platform  
**Phase**: 2 — Recovery Performance Measurement Layer & Claim Validation  
**Claim Statement**: *"Recovery has improved by 11% month-on-month."*  
**Final Validation Classification**: **PARTIALLY SUPPORTED (CALENDAR ARTIFACT / SINGLE-MONTH ANOMALY)**  

---

## 1. Executive Summary & Verdict

An exhaustive empirical evaluation of all 240,000 monthly account observations, 17,534 valid recovery transactions (₹1.315B), and operational event streams confirms that:

1. **The Claim Matches Exactly ONE Historical Month**: In **March 2026 vs. February 2026**, valid financial recovery grew from **₹170,142,453.76 to ₹188,912,374.02**, representing an exact month-over-month increase of **+11.03%**. Similarly, recovered accounts grew by **+11.32%** (2,173 to 2,419), and portfolio recovery rate grew by **+11.33%** (7.24% to 8.06%).
2. **The Improvement Was Almost Entirely an Illusion of Calendar Length**:
   - February 2026 has **28 days**, whereas March 2026 has **31 days** (+10.71% more calendar days).
   - On a **daily run-rate basis**, collections were **₹6,076,516.21/day in February** and **₹6,093,947.55/day in March** — a true underlying operational gain of only **+0.29%**.
3. **The 11% Improvement Did NOT Sustain Across the 7-Month Horizon**:
   - In April 2026, collections immediately retreated by **-7.29%** (to ₹175.14M).
   - May 2026 rose by **+5.20%** (31-day month), June 2026 fell by **-4.72%** (30-day month), and July 2026 rose by **+6.65%** (31-day month).
   - **Cumulative 7-Month Performance (Jan 2026 to Jul 2026)**: Collections began at **₹187.23M** in January and ended at **₹187.24M** in July — an overall change of **+0.007%** (completely flat).
   - **Average Monthly Growth**: The arithmetic mean of month-over-month recovery changes across all full months is **+0.29%**, NOT +11%.

---

## 2. Multi-Metric Claim Validation Matrix

The table below tests the 11% claim across all candidate recovery metrics, comparing February 2026 against March 2026 (the peak month) as well as the full-period average.

| Metric Tested | Feb 2026 (Previous) | Mar 2026 (Current) | Absolute Change | March MoM % | Full-Period Avg MoM % | 11% Match Verdict |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Valid Net Recovery Amount** | ₹170,142,453.76 | ₹188,912,374.02 | +₹18,769,920.26 | **+11.03%** | **+0.29%** | **YES (March Only)** |
| **Gross Raw Payment Amount** | ₹239,508,700.22 | ₹269,081,795.34 | +₹29,573,095.12 | **+12.35%** | **+0.35%** | **Approximate (+12.4%)** |
| **Recovered Unique Accounts** | 2,173 accounts | 2,419 accounts | +246 accounts | **+11.32%** | **+0.42%** | **YES (March Only)** |
| **Portfolio Recovery Rate** | 7.24% | 8.06% | +0.82% pts | **+11.33%** | **+0.42%** | **YES (March Only)** |
| **Recovery / Portfolio Account**| ₹5,671.42 | ₹6,297.08 | +₹625.66 | **+11.03%** | **+0.29%** | **YES (March Only)** |
| **Recovery / Recovered Account**| ₹78,298.41 | ₹78,095.24 | -₹203.17 | **-0.26%** | **+0.30%** | **NO (Flat ticket size)**|
| **Recovery / Agent-Hour** | ₹16,116.54/hr | ₹16,972.01/hr | +₹855.47/hr | **+5.31%** | **+0.73%** | **NO (+5.3% only)** |
| **Daily Average Net Recovery** | ₹6,076,516.21/day | ₹6,093,947.55/day | +₹17,431.34/day | **+0.29%** | **+0.03%** | **NO (+0.29% true run-rate)** |
| **Omnichannel Contact Rate** | 34.43% | 35.73% | +1.30% pts | **+3.78%** | **+0.07%** | **NO (+3.8% only)** |
| **Voice Contact Rate** | 22.96% | 23.59% | +0.63% pts | **+2.74%** | **-0.49%** | **NO (+2.7% only)** |
| **RPC Rate** | 69.71% | 69.82% | +0.11% pts | **+0.16%** | **+0.32%** | **NO (Flat)** |
| **PTP Rate** | 48.95% | 49.99% | +1.04% pts | **+2.12%** | **+0.49%** | **NO (+2.1% only)** |
| **PTP Kept Rate** | 25.54% | 24.67% | -0.87% pts | **-3.41%** | **+0.34%** | **NO (-3.4% decline)** |

---

## 3. Month-by-Month Full Operational Trend (2026-01 to 2026-08)

The table below documents the full chronological timeline of monthly recovery metrics across the entire 8-month period.

| Month | Days | Attempted Accounts | Contacted Accounts | Contact Rate | RPC Rate | PTP Rate | Kept Rate | Recovered Accounts | Valid Recovery (₹) | MoM Change (%) | Daily Avg Recovery (₹/day) | Daily MoM (%) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **2026-01** | 31 | 18,172 | 6,502 | 35.78% | 67.96% | 51.80% | 24.07% | 2,374 | ₹187,229,127.59 | Baseline | ₹6,039,649.28 | Baseline |
| **2026-02** | 28 | 16,913 | 5,824 | 34.43% | 69.71% | 48.95% | 25.54% | 2,173 | ₹170,142,453.76 | **-9.13%** | ₹6,076,516.21 | **+0.61%** |
| **2026-03** | 31 | 18,241 | 6,518 | 35.73% | 69.82% | 49.99% | 24.67% | 2,419 | ₹188,912,374.02 | **+11.03%** | ₹6,093,947.55 | **+0.29%** |
| **2026-04** | 30 | 17,736 | 6,266 | 35.33% | 69.33% | 51.38% | 25.24% | 2,304 | ₹175,138,043.41 | **-7.29%** | ₹5,837,934.78 | **-4.20%** |
| **2026-05** | 31 | 18,043 | 6,506 | 36.06% | 69.49% | 49.62% | 25.29% | 2,344 | ₹184,250,278.50 | **+5.20%** | ₹5,943,557.37 | **+1.81%** |
| **2026-06** | 30 | 17,557 | 6,259 | 35.65% | 67.78% | 51.95% | 24.68% | 2,286 | ₹175,559,726.97 | **-4.72%** | ₹5,851,990.90 | **-1.54%** |
| **2026-07** | 31 | 18,229 | 6,467 | 35.48% | 69.19% | 52.55% | 24.56% | 2,335 | ₹187,242,265.08 | **+6.65%** | ₹6,040,073.07 | **+3.21%** |
| **2026-08\***| 8 | 5,612 | 1,513 | 26.96% | 67.74% | 53.64% | 27.15% | 608 | ₹47,109,695.31 | -74.84% | ₹5,888,711.91 | -2.51% |

*\*Note: August 2026 reflects partial-month operational data through August 8, 2026 (8 days).*

---

## 4. Forensic Breakdown: Why Was the 11% Claim Reported?

### 4.1 Root Cause 1 — The Calendar-Day Mirage
- The collections operation operates 7 days a week. Monthly totals naturally scale with the number of calendar days in each month.
- February has 28 days; March has 31 days. Simply by existing for 3 additional days, March captures **+10.71% more time** than February.
- Because daily operational collections remained virtually unchanged (~₹6.08M/day in Feb vs ~₹6.09M/day in Mar), the monthly sum jumped by **+11.03%**, creating an artificial illusion of massive operational improvement.

### 4.2 Root Cause 2 — Selective Horizon Reporting ("Cherry-Picking")
- If management evaluated performance exclusively between February and March, the monthly report would accurately reflect "+11% MoM".
- However, reporting this single-month step as an ongoing monthly improvement trend is deeply misleading.
- When followed into April (30 days), collections immediately dropped by **-7.29%**, proving that the March jump was not a sustainable operational breakthrough.

### 4.3 Root Cause 3 — Data Quality & Uncleaned Payment Inflation
- In uncleaned raw data, gross payments jumped by **+12.35%** in March (from ₹239.5M to ₹269.1M), further exaggerating perceived growth due to uncollected failed/pending payments and duplicate ingestion records.

---

## 5. Denominator & Attribution Sensitivity Analysis

### 5.1 Denominator Diagnostic: Fixed Master vs. Open Portfolio

| Analysis Month | Fixed Master Portfolio (30k Accounts) | Open Active Delinquent Accounts | Recovery Rate (Fixed Denom) | Recovery Rate (Open Denom) |
| :--- | :--- | :--- | :--- | :--- |
| **2026-01** | 30,000 accounts | 9,894 accounts | 7.91% | 23.99% |
| **2026-02** | 30,000 accounts | 11,512 accounts | 7.24% | 18.88% |
| **2026-03** | 30,000 accounts | 12,989 accounts | 8.06% | 18.62% |
| **2026-04** | 30,000 accounts | 13,924 accounts | 7.68% | 16.55% |
| **2026-05** | 30,000 accounts | 14,710 accounts | 7.81% | 15.94% |
| **2026-06** | 30,000 accounts | 15,334 accounts | 7.62% | 14.87% |
| **2026-07** | 30,000 accounts | 15,775 accounts | 7.78% | 14.80% |

- **Observation**: As more accounts transitioned into delinquency over time (expanding the open delinquent denominator from 9.9k to 15.8k), the recovery rate on open accounts steadily declined from 23.99% to 14.80%, while recovery rate on the fixed 30k master portfolio remained stable around ~7.6%–8.0%.

---

## 6. Formal Conclusion & Audit Statement

```
================================================================================
AUDIT STATEMENT ON THE 11% RECOVERY IMPROVEMENT CLAIM
================================================================================

1. IS THE 11% CLAIM SUPPORTED ACROSS THE 12-MONTH HORIZON?
   -> NO. The 11% claim is NOT supported as an ongoing or average trend.
   -> Across the 7 full operating months, cumulative recovery growth was +0.007%
      (completely flat), and the arithmetic mean MoM change was +0.29%.

2. DID ANY METRIC ACTUALLY INCREASE BY 11%?
   -> YES. In March 2026 vs. February 2026, Valid Recovery Amount increased by
      exactly +11.03%, and Recovered Accounts increased by +11.32%.

3. WHY DID IT INCREASE BY 11% IN MARCH?
   -> The increase was driven by the calendar-day effect (+10.71% more days in
      March: 31 days vs. 28 days in February).
   -> True daily collections grew by only +0.29% (from INR 6.077M/day to
      INR 6.094M/day).

4. CLASSIFICATION:
   -> PARTIALLY SUPPORTED (CALENDAR ARTIFACT / SINGLE-MONTH ANOMALY).
================================================================================
```
