# Analytical Limitations, Caveats & Risk Disclosures

**Project**: Collections Recovery Analytics Platform  
**Phase**: 6 — Final Analytics Pipeline, SQL, Notebook & Reproducibility  
**Status**: COMPLETE & VERIFIED  

---

## 1. Methodological & Data Limitations

### 1. Observational Selection Bias in Outreach Intensity
- **Limitation**: Accounts receiving >5 voice call attempts exhibit lower recovery rates (5.08% vs. 7.78%).
- **Caveat**: This reflects **negative selection bias** (unresponsive or high-delinquency borrowers are redialed more often by automated pacing engines) rather than a negative causal effect of calling. Increasing call attempts on non-responsive borrowers without channel escalation will not improve recovery.

### 2. Quasi-Experimental Nature of Campaign Targeting
- **Limitation**: Campaign allocations in historical data were assigned via deterministic business rules (DPD $\ge 30$, broken promises) rather than randomized assignment.
- **Caveat**: While controlled using observable balance, product, and risk covariates, true unconfounded causal elasticity requires the proposed **Phase 1 Pilot Randomized Controlled Trial (RCT)**.

### 3. Attribution Lookback Sensitivity
- **Limitation**: Attributed recovery scales significantly depending on lookback horizon (1-day: 3.24%, 7-day: 20.16%, 30-day: 59.78%).
- **Caveat**: Multi-touch interactions often co-occur. While 7-day lookback is the industry standard for consumer debt collections, attribution represents operational correlation rather than pure incremental credit.

### 4. August 2026 Truncation Boundary
- **Limitation**: The historical dataset terminates on August 8, 2026 (~8 days of operational data).
- **Caveat**: Unadjusted month-over-month comparisons between July and August show an artificial -74.8% drop-off. All multi-month trends must be evaluated on daily run-rates (`₹/day`) or restricted to the 7 full months (Jan to Jul 2026).

### 5. Cost & P&L Proxy Limitations
- **Limitation**: Detailed carrier minute tariffs and individual agent wage scales are not broken down in the raw telephony tables.
- **Caveat**: Cost calculations are modeled at the macro initiative level. Cash recovery is evaluated as gross cash collected rather than net P&L accounting profit.
