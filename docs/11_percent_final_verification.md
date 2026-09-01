# 11% Month-on-Month Claim Final Verification Report

**Project**: Collections Recovery Analytics Platform  
**Phase**: 8 — Final Submission QA, Requirement Audit & Delivery Package  
**Claim Evaluated**: *"Recovery has improved by 11% month-on-month."*  
**Final Verdict**: **PARTIALLY SUPPORTED (CALENDAR ARTIFACT / SINGLE-MONTH ANOMALY)**  

---

## 1. The Core Empirical Finding

```
================================================================================
FINAL CLAIM VERIFICATION SUMMARY
================================================================================
1. Reported Business Claim:       "Recovery has improved by 11% month-on-month."
2. Validated March vs Feb Growth: +11.03% (INR 170.14M to INR 188.91M Net Recovery)
3. Underlying Mechanism:          Calendar Day Expansion (28 days in Feb vs 31 days in Mar)
4. Calendar Day Increase:         +10.71% (+3 operating days)
5. True Daily Run-Rate Growth:    +0.29% (INR 6.077M/day to INR 6.094M/day)
6. 7-Month Full Cumulative Lift:  +0.007% (INR 188.89M in Jan vs INR 188.91M in Jul)
7. Arithmetic Mean MoM Growth:    +0.29% across 7 full operating months
================================================================================
```

---

## 2. Multi-Metric Verification Table

| Metric | February 2026 | March 2026 | March MoM % Change | 7-Month Full Average MoM % | 11% Claim Verdict |
| :--- | :--- | :--- | :---: | :---: | :--- |
| **Valid Net Recovery Amount** | ₹170,142,504.60 | ₹188,912,238.41 | **+11.03%** | **+0.29%** | **YES (March Single-Month Artifact)** |
| **Gross Raw Payment Amount** | ₹239,505,096.59 | ₹269,083,722.50 | **+12.35%** | **+0.35%** | **Approximate (+12.4%)** |
| **Unique Recovered Accounts** | 2,173 Accounts | 2,419 Accounts | **+11.32%** | **+0.42%** | **YES (March Single-Month Artifact)** |
| **Portfolio Recovery Rate** | 7.24% | 8.06% | **+11.33%** | **+0.42%** | **YES (March Single-Month Artifact)** |
| **Daily Net Collections Run-Rate** | ₹6,076,518.02 / day | ₹6,093,943.17 / day | **+0.29%** | **+0.03%** | **NO (+0.29% True Run-Rate)** |
| **Recovery per Agent-Hour** | ₹2,470.85 / hr | ₹2,457.24 / hr | **-0.55%** | **-0.08%** | **NO (Agent Productivity Flat)** |

---

## 3. Methodological Takeaways

1. **Unadjusted Monthly Totals Mislead Decision-Makers**:
   - Comparing 28-day February directly against 31-day March introduces an automatic ~10.7% positive bias. Normalizing by calendar days or working hours is mandatory in collections analytics.
2. **Horizon Consistency**:
   - A single-month bounce of +11.03% following a -9.13% drop in February cannot be interpreted as a sustained structural improvement when the 7-month cumulative trend is +0.007% (flat).
