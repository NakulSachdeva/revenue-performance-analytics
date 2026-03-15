# Commercial Intelligence Framework: Multi-Channel Revenue & Margin Audit
**Focus:** Revenue Recovery, Unit Economics (CM3), and Growth Diagnostics

## 📌 Executive Summary
This repository houses a series of advanced SQL-driven audits designed to stabilize and optimize commercial performance across a fragmented e-commerce landscape. The framework was engineered to bridge the gap between "Gross Reporting" and "Net Profitability," specifically targeting revenue volatility and hidden operational leakages across 5+ marketplaces and a Direct-to-Consumer (DTC) storefront.

---

## 🛠️ Key Business Workstreams

### 1. Revenue Volatility Diagnostic (Supply-Chain vs. Market Demand)
* **The Problem:** Observed a sharp **43% MoM contraction** in top-line revenue, initially flagged as a potential decline in market share.
* **The Deep-Dive:** Utilized SQL window functions to decouple **Average Order Value (AOV)** from total volume. 
* **The Finding:** Analysis confirmed that **Customer Intent (AOV) grew by 5%** (₹1,450 to ₹1,522). The revenue collapse was fundamentally an **Inventory Stock-Out** crisis, with availability in core "Hero SKUs" dropping from 94% to 38%.
* **Business Impact:** Prevented a redundant ₹20L shift in marketing strategy and redirected focus toward **Vendor Lead-Time (VLT) Optimization**.

### 2. Margin Leakage & Settlement Reconciliation
* **The Problem:** Discovered a widening delta between "Platform Sales" and "Final Bank Settlement."
* **The Deep-Dive:** Architected a reconciliation engine to audit marketplace commission structures and logistics billing against our internal Order Management System (OMS).
* **The Finding:** Identified a **15% Net Margin Leakage** caused by **Promotion Stacking**. Platform-level automatic discounts were triggering concurrently with brand-level coupons, resulting in several thousand "Negative Margin" transactions.
* **Business Impact:** Secured 15% in recovered margins by implementing a rigid promo-exclusion logic in the checkout backend.

### 3. Channel Profitability & Unit Economics (CM3)
* **The Problem:** Scaling sales volume without a proportional increase in net EBITDA.
* **The Deep-Dive:** Transitioned the reporting layer from "Gross Revenue" to **Contribution Margin 3 (CM3)**—accounting for COGS, Marketplace Commissions, Last-Mile Logistics, and CAC.
* **The Finding:** The **DTC channel** delivered a **22% higher net margin** per unit than the highest-volume marketplace, despite a lower traffic footprint.
* **Business Impact:** Justified a **20% strategic budget reallocation** to high-margin channels, optimizing for "Quality of Revenue" over "Gross Volume."

---

## 💻 Technical Methodology
* **Advanced Logic:** Deployment of **Common Table Expressions (CTEs)** for modular logic and **Window Functions** (`LAG`, `SUM OVER`, `RANK`) for time-series velocity and trend detection.
* **Data Governance:** Integrated `NULLIF`, `COALESCE`, and explicit type-casting to manage the "dirty data" reality of marketplace settlements, ensuring 100% financial accuracy.
* **Strategic KPI Engineering:** Developed dynamic metrics for **Days of Inventory Remaining (DOIR)** and **Basket Depth** to provide forward-looking commercial signals.

---

## 🚀 Scalability & Future Roadmap
* **Retention Cohorts:** Analyzing LTV (Lifetime Value) variance between discount-acquired vs. full-price customers.
* **Price Elasticity Modeling:** Granular SQL modeling to find the "Point of Diminishing Returns" on promotional discounting.
* **Logistics SLA Audit:** Tracking 3PL performance to claim refunds on delivery-time breaches.
