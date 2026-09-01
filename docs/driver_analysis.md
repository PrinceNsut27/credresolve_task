# Recovery Driver Analysis, Mix Effects & Structural Investigation

**Project**: Collections Recovery Analytics Platform  
**Phase**: 3 — Driver Analysis, Mix Effects & Statistical Investigation  
**Status**: COMPLETE & VERIFIED  

---

## 1. Executive Summary: Why Collections Performance Shifted

Phase 2 established that collections recovery remained essentially flat across the 7-month full operating period (**+0.007% cumulative growth from Jan to Jul 2026**, averaging **₹181.3M/month** and **~₹6.0M/day**), with the reported "+11% MoM improvement" isolated strictly to the **March vs. February calendar-day jump (+10.71% days effect)**.

Phase 3 investigates the underlying operational, structural, and behavioral drivers across **15 distinct analytical dimensions**.

### Core Findings Matrix

| Driver Category | Primary Finding | Effect on 7-Month Trend | Evidence Level |
| :--- | :--- | :--- | :--- |
| **Calendar Horizon** | March (31d) vs Feb (28d) created an artificial +11.03% jump; daily run-rate was flat (+0.29%) | **DOMINANT EXPLANATION (100% of March spike)** | **FACT** |
| **Portfolio Mix (DPD/Product/Risk)** | Portfolio composition remained virtually identical across all 8 months; mix shift explained 0.0% of growth | **ZERO MIX SHIFT (0.0% contribution)** | **FACT** |
| **Attempt Frequency** | Moderate outreach (2–3 touches) yields peak recovery (7.78%); >5 touches suffers severe diminishing returns (5.08%) | **STRONG BEHAVIORAL PATTERN (Selection bias flagged)** | **STRONG EVIDENCE** |
| **Channel Mix** | WhatsApp and SMS generate high digital engagement at negligible cost; Voice accounts for 54% of attributed recovery | **OPERATIONAL EFFICIENCY DIFFERENTIAL** | **STRONG EVIDENCE** |
| **Agent Tenure & Capacity** | Agent productivity is identical across tenure tiers (~₹111k recovery/agent); no tenure learning curve detected | **NO TENURE MIX EFFECT** | **STRONG EVIDENCE** |
| **Telephony Vendor Integration** | All 15 carrier vendors exhibit identical connection rates (~19.7%–20.5%) and RPC rates (~68%–70%) | **NO VENDOR ADVANTAGE** | **FACT** |
| **Calling Time Distribution** | Dialing volume is spread uniformly 24/7; connection rates stay invariant at ~20% across all hours and days | **NO TIME-OF-DAY ADVANTAGE** | **FACT** |

---

## 2. Shift-Share / Kitagawa Mix Effect Decomposition

To determine whether performance changes were driven by **Portfolio Mix Shifts** (changes in the proportion of higher-yielding accounts) or **Within-Group Rate Changes** (improvements within fixed segments), we executed a formal Kitagawa Shift-Share Decomposition:

$$\Delta R = \sum \left( r_{i, \text{target}} - r_{i, \text{base}} \right) w_{i, \text{base}} + \sum r_{i, \text{base}} \left( w_{i, \text{target}} - w_{i, \text{base}} \right) + \sum \Delta r_i \Delta w_i$$

### 2.1 Decomposition of the March Spike (2026-03 vs. 2026-02)

| Dimension Decomposed | Base Rate (Feb) | Target Rate (Mar) | Total Delta | Within-Group Effect | Portfolio Mix Effect | % Driven by Within | % Driven by Mix |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **DPD Bucket** | 7.24% | 8.06% | **+0.82% pts** | **+0.82% pts** | **0.00% pts** | **100.0%** | **0.0%** |
| **Loan Type / Product** | 7.24% | 8.06% | **+0.82% pts** | **+0.82% pts** | **0.00% pts** | **100.0%** | **0.0%** |
| **Risk Segment Tier** | 7.24% | 8.06% | **+0.82% pts** | **+0.82% pts** | **0.00% pts** | **100.0%** | **0.0%** |

**Conclusion**: The March recovery jump was **100% within-group** across all segments simultaneously. Because the portfolio mix did not change at all, the uniform lift was caused entirely by the external 3-day calendar extension (+10.71% days).

### 2.2 Decomposition of Full Horizon (2026-07 vs. 2026-01)

| Dimension Decomposed | Base Rate (Jan) | Target Rate (Jul) | Total Delta | Within-Group Effect | Portfolio Mix Effect | % Driven by Within | % Driven by Mix |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **DPD Bucket** | 7.91% | 7.78% | **-0.13% pts** | **-0.13% pts** | **0.00% pts** | **100.0%** | **0.0%** |
| **Loan Type / Product** | 7.91% | 7.78% | **-0.13% pts** | **-0.13% pts** | **0.00% pts** | **100.0%** | **0.0%** |

---

## 3. Dimensional Deep-Dives

### 3.1 DPD Bucket Performance

| DPD Bucket | Master Accounts | Recovered Accounts | Portfolio Recovery Rate | Net Valid Recovery (₹) | Recovery / Portfolio Acct (₹) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1–30 DPD** | 59,960 | 4,677 | **7.80%** | ₹350,772,999.07 | ₹5,850.12 |
| **31–60 DPD** | 60,000 | 4,635 | **7.73%** | ₹347,750,767.14 | ₹5,795.85 |
| **61–90 DPD** | 59,984 | 4,611 | **7.69%** | ₹345,950,560.10 | ₹5,767.38 |
| **91–180 DPD** | 60,056 | 4,647 | **7.74%** | ₹351,109,638.33 | ₹5,846.37 |

- **Observation**: Recovery rates across DPD buckets are uniformly distributed between **7.69% and 7.80%**, demonstrating that collections recovery was maintained evenly across early-stage and late-stage delinquency portfolios.

---

### 3.2 Product / Credit Facility Performance

| Loan Product Type | Master Accounts | Recovered Accounts | Recovery Rate | Net Valid Recovery (₹) | Recovery / Account (₹) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **CREDIT_CARD** | 48,448 | 3,747 | **7.73%** | ₹281,424,547.46 | ₹5,808.80 |
| **PERSONAL** | 47,848 | 3,722 | **7.78%** | ₹279,307,816.92 | ₹5,837.40 |
| **AUTO** | 47,824 | 3,707 | **7.75%** | ₹277,975,417.85 | ₹5,812.55 |
| **CONSUMER** | 48,152 | 3,714 | **7.71%** | ₹278,981,878.89 | ₹5,793.77 |
| **BNPL** | 47,728 | 3,680 | **7.71%** | ₹277,894,303.52 | ₹5,822.46 |

- **Observation**: Recovery performance is virtually identical across all 5 credit products (~7.71%–7.78% recovery rate, ~₹5.8k/account yield).

---

### 3.3 Risk Segment Tier Performance

| Risk Segment Tier | Master Accounts | Recovered Accounts | Recovery Rate | Net Valid Recovery (₹) | Recovery / Account (₹) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **LOW** | 60,040 | 4,669 | **7.78%** | ₹350,078,574.65 | ₹5,830.76 |
| **MEDIUM** | 59,968 | 4,642 | **7.74%** | ₹348,310,215.18 | ₹5,808.27 |
| **HIGH** | 59,976 | 4,639 | **7.73%** | ₹348,178,397.68 | ₹5,805.30 |
| **NPA** | 60,016 | 4,620 | **7.70%** | ₹349,016,777.13 | ₹5,815.40 |

---

### 3.4 Attempt Frequency & Diminishing Returns (Selection Bias)

| Monthly Outreach Attempts | Account Observations | Recovered Accounts | Recovery Rate | Net Recovery (₹) | Recovery / Account (₹) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **0 Attempts (Organic)** | 137,889 | 9,216 | **6.68%** | ₹717,907,989.70 | ₹5,206.41 |
| **1 Attempt** | 71,221 | 5,231 | **7.34%** | ₹407,207,877.84 | ₹5,717.50 |
| **2–3 Attempts** | 29,253 | 2,277 | **7.78%** | ₹181,695,921.32 | ₹6,211.19 |
| **4–5 Attempts** | 1,578 | 116 | **7.35%** | ₹8,642,369.57 | ₹5,476.79 |
| **6–10 Attempts** | 59 | 3 | **5.08%** | ₹132,926.18 | ₹2,252.99 |

- **Critical Operational Finding**: Recovery rate peaks at **2–3 attempts (7.78%)** and sharply deteriorates beyond 5 attempts (**5.08%**).
- **Selection Bias Note**: Chronic non-responders receive repeated dialer attempts, artificially lowering the conversion of high-frequency buckets. Increasing attempts on stubborn accounts does NOT yield higher recovery.

---

### 3.5 Agent Tenure & Workforce Dynamics

| Agent Tenure Bucket | Canonical Agents | Total Calls Handled | RPC Calls | Kept PTPs | Attributed Net Recovery (₹) | Recovery / Agent (₹) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **0–3m (New)** | 124 | 11,289 | 2,752 | 567 | ₹13,812,084.15 | **₹111,387.78** |
| **3–6m** | 129 | 11,811 | 2,878 | 592 | ₹14,295,438.22 | **₹110,817.35** |
| **6–12m** | 246 | 22,250 | 5,429 | 1,120 | ₹27,684,210.90 | **₹112,537.44** |
| **12–24m** | 402 | 36,194 | 8,831 | 1,821 | ₹44,984,120.30 | **₹111,900.80** |
| **24m+ (Veteran)** | 99 | 8,956 | 2,186 | 450 | ₹11,061,846.43 | **₹111,735.82** |

- **Workforce Finding**: Agent performance is completely uniform across tenure buckets (~₹111k/agent recovery, ~24.4% RPC rate, ~25.2% PTP kept rate). There is no observed tenure premium or onboarding learning curve in the historical telephony data.

---

### 3.6 Telephony Vendors & Calling Schedules

- **Telephony Carriers**: All 15 carrier vendors exhibit identical connection rates (**19.45% to 20.48%**) and RPC rates (**67.8% to 70.1%**). Vendor selection was not a differentiator in recovery performance.
- **Calling Schedule**: Connection rates remain constant at **~19.6%–20.9%** across all 24 hours of the day and across all 7 days of the week, reflecting automated dialer pacing without time-of-day concentration.

---

## 4. Synthesis: Why Recovery Changed

```
================================================================================
FINAL DRIVER SYNTHESIS: SUMMARY OF EVIDENCE
================================================================================

1. WHAT IS DEFINITELY TRUE (FACTS):
   - The reported 11% MoM improvement occurred ONLY in March 2026 vs February 2026.
   - March had 31 days (+10.71% more days than 28-day February).
   - Daily recovery run-rate was completely flat (+0.29% change).
   - Overall cumulative growth across all 7 full months was +0.007% (flat).
   - Telephony connection rates (~20%) and vendor performance are invariant.

2. WHAT IS STRONGLY SUPPORTED (STRONG EVIDENCE):
   - Outreach frequency beyond 3 touches suffers severe diminishing returns.
   - Organic recovery represents ~54%–80% of collections depending on lookback window.
   - Shift-share decomposition confirms 0.0% mix effect; all variance was within-group.
   - Agent productivity is invariant across tenure tiers (~INR 111k/agent).

3. WHAT IS CORRELATED (CORRELATION, NOT CAUSATION):
   - Accounts receiving 6-10 calls have lower recovery rates (5.08% vs 7.78%) due to
     selection bias (harder accounts targeted more frequently).

4. WHAT REMAINS A HYPOTHESIS:
   - Dynamic channel switching (escalating digital non-responders to field visits)
     could unlock higher recovery than brute-force voice retries.
================================================================================
```
