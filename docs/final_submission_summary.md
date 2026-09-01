# Final Project Submission Summary

**Project**: Collections Recovery Performance Analytics & ₹10 Cr Investment Strategy  
**Assignment**: Data Analyst Assignment (Phases 0 through 8 Complete)  
**Submission Status**: **SUBMISSION READY**  

---

## 1. Core Business Conclusions

1. **Portfolio Recovery Health**:
   - Total clean, verified collections across the 30,000-account master portfolio is **₹1,315,583,964.64** across 17,534 valid payments.
   - Monthly net collections average **₹181.21M / month** across the 7 full operating months (Jan–Jul 2026), yielding an annual baseline of **₹217.45 Cr**.
2. **11% Claim Verdict**: **PARTIALLY SUPPORTED (CALENDAR ARTIFACT / SINGLE-MONTH ANOMALY)**.
   - March 2026 grew by **+11.03%** over February 2026 (₹170.14M to ₹188.91M).
   - This was driven almost entirely by the calendar-day effect (+10.71% more days: 31 in Mar vs. 28 in Feb).
   - On a **daily run-rate basis**, recovery was flat (**₹6.08M/day in Feb vs. ₹6.09M/day in Mar, a +0.29% change**). Across all 7 full operating months, cumulative growth was **+0.007% (flat)**.
3. **Top 3 Validated Drivers**:
   - **0.0% Portfolio Mix Shift Effect `[FACT]`**: 100% of monthly variance is within-group and calendar-driven.
   - **Diminishing Returns in Outreach Frequency `[FACT]`**: Outreach recovery peaks at **2–3 attempts (7.78%)** and falls to **5.08% beyond 5 attempts** due to negative selection bias.
   - **Broken PTP Conversion Gap `[FACT]`**: **75% of PTP commitments break** (₹675M at risk), presenting the single largest immediate recovery opportunity via automated digital reminders.
4. **Targeting Counterfactual & Incremental Lift**:
   - Targeted accounts yielded **7.63% recovery (₹5,976.80/acct)** vs. non-targeted organic controls of **6.89% (₹5,380.44/acct)** (+0.74% pts / +11.08% yield spread).
   - **Estimated Incremental Lift (Base Case)**: **+₹11.13M (+7.04% lift)**.
5. **₹10.00 Crore Investment Recommendation**:
   - **Decision**: **PILOT FIRST / INVEST WITH CONDITIONS (Phase-Gated Deployment)**.
   - **Phase 1 Pilot (Months 1–3: ₹2.50 Cr)**: Fund a 90-day 1:1 Randomized Controlled Trial (RCT) across 30,000 accounts.
   - **Phase 2 Scale (Months 4–12: ₹7.50 Cr)**: Released upon proving $\ge 3.50\%$ incremental recovery uplift.
   - **Base-Case Financials (+3.50% Lift)**: **+₹7.61 Cr/year incremental recovery**, **15.8-month payback**, and **+₹5.22 Cr net benefit over 2 years** (ROI: +52.2%).

---

## 2. Complete Deliverable Catalog

```
cred/
├── README.md                                 # Master project overview & reproducibility guide
├── task.md                                   # Phase-wise execution checklist (Phases 0–8 COMPLETE)
├── goal.md                                   # Assignment North Star & requirements
│
├── data/                                     # Raw Data Layer (18 CSVs, strictly untouched)
├── data/clean/                               # 17 Cleaned & harmonized CSV tables
├── data/golden/                              # 6 Golden analytical CSV tables (240k rows spine)
├── analytics/                                # 3 Performance & driver datasets
│
├── sql/                                      # 7 Production SQL pipeline scripts
│   ├── 01_staging.sql                        # Staging layer DDL & data contracts
│   ├── 02_cleaning.sql                       # Cleansing, deduplication & standardization
│   ├── 03_golden.sql                         # Cartesian Spine & Golden layer SQL
│   ├── 04_metrics.sql                        # Monthly metrics & MoM calculations
│   ├── 05_analysis.sql                       # Multidimensional driver analysis
│   ├── 06_counterfactual.sql                 # Targeting counterfactual simulation
│   └── 07_investment_model.sql               # Financial model & ₹10 Cr allocation
│
├── notebooks/                                # Jupyter Analysis Layer
│   └── analysis.ipynb                        # Executed master notebook (215 KB, rendered plots)
│
├── dashboard/                                # Executive Decision-Support Layer
│   ├── app.py                                # Interactive Streamlit dashboard (6 tabs)
│   └── README.md                             # Dashboard launch guide & feature overview
│
└── docs/                                     # 20 Comprehensive Technical & Executive Reports
    ├── data_inventory.md                     # Phase 0 Data Discovery
    ├── data_quality_report.md                # Phase 1 Data Quality Scorecard & Forensics
    ├── golden_dataset.md                     # Phase 1 Golden Dataset Architecture
    ├── metrics_definitions.md                # Phase 2 Metrics Framework
    ├── 11_percent_claim.md                   # Phase 2 Independent 11% Claim Audit
    ├── driver_analysis.md                    # Phase 3 Multidimensional Driver Analysis
    ├── statistical_analysis.md               # Phase 3 Econometric Logit Models
    ├── targeting_counterfactual.md           # Phase 4 Targeting Counterfactual & RCT Design
    ├── investment_options.md                 # Phase 5 Lever Prioritization
    ├── investment_recommendation.md          # Phase 5 Executive Investment Memorandum
    ├── financial_model.md                    # Phase 5 Financial Scenario & ROI Model
    ├── data_lineage.md                       # Phase 6 End-to-End Pipeline Lineage
    ├── final_data_validation.md              # Phase 6 QA & Invariant Matrix
    ├── assumptions.md                        # Phase 6 Analytical Assumption Register
    ├── limitations.md                        # Phase 6 Methodological Limitations
    ├── requirement_traceability.md           # Phase 6 Assignment Requirement Traceability
    ├── final_file_inventory.md               # Phase 6 Deliverable File Catalog
    ├── executive_memo.md                     # Phase 7 Senior Executive Decision Memo
    ├── production_architecture.md            # Phase 7 Production Lakehouse Architecture
    ├── final_requirement_audit.md            # Phase 8 Requirement-by-Requirement Audit
    ├── 11_percent_final_verification.md      # Phase 8 11% Claim Verification Report
    ├── final_scorecard.md                    # Phase 8 Quality Scorecard (49.5 / 50.0)
    ├── final_blockers.md                     # Phase 8 Blocker Resolution Log
    └── final_submission_summary.md           # Phase 8 Final Submission Summary
```
