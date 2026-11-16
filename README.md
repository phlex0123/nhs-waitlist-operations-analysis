# 🏥 NHS Operations & Capacity Analysis: 5-Year Waitlist Dashboard

![NHS Dashboard](3_dashboard_presentation/nhs_dashboard.png)

## 📌 Executive Summary
This project analyzes the National Health Service (NHS) elective care waitlist, which recently surpassed 7.1 million patients. Using PostgreSQL for backend data engineering and Microsoft Excel for the front-end presentation layer, I built an interactive Executive Dashboard designed to answer critical capacity and resource allocation questions for healthcare leadership.

## ⚠️ Data Quality Audit & Engineering Fix
During the initial data exploration phase in PostgreSQL, I discovered a critical data integrity issue in the raw government export. High-performing hospital trusts were returning `NULL` values instead of `0` for patients waiting over 52 weeks. 

If loaded directly into a visualization tool, these `NULL` values would mathematically drop hundreds of hospitals from the dataset, corrupting the national average. I engineered a structural fix using `COALESCE()` in the SQL Views to convert these nulls to zeros, ensuring 100% data accuracy for executive decision-making.

## 📊 Strategic Business Questions Answered
The final dashboard moves beyond standard reporting to act as an operational command center, answering five key business questions:

1. **Are we meeting our statutory mandates?** 
   * *Finding:* The volume-weighted 18-week treatment compliance rate has fallen to **~58.8%**, critically below the 92% legal mandate.
2. **Is the waitlist growing due to a demand spike or a capacity failure?** 
   * *Finding:* The 5-year waitlist growth sits at **31.62%**. The dual-line capacity chart proves a chronic structural deficit; the system consistently treats fewer patients than it admits weekly.
3. **Where is the patient inflow originating?** 
   * *Finding:* The referral funnel visualization isolates General Practitioners (GPs) as the overwhelming source of system inflow, highlighting a need for upstream community diagnostic funding.
4. **Where should emergency funding be deployed today?** 
   * *Finding:* The watchlist filters isolate the top 10 most overwhelmed facilities (led by Manchester University and Mid And South Essex) to target financial intervention.
5. **Which medical specialists must HR prioritize for recruitment?** 
   * *Finding:* Trauma/Orthopaedics and Ophthalmology alone account for over 1.3 million backlogged patients, dictating a highly targeted clinical hiring strategy.

## 🧠 Analytical Methodology & Strategic Recommendations

### The Data Quality Trap (Methodology)
A standard aggregation of the NHS dataset yields a mathematically inaccurate 18-week compliance rate. Because the raw data captures a weekly snapshot, grouping the data temporally (e.g., by quarter) artificially inflates the backlog volume if summed. 
*   **The Fix:** I engineered the Excel data model to calculate the true volume-weighted compliance rate dynamically, rather than relying on unweighted Pivot Table averages that grant equal mathematical weight to a 10-patient rural clinic and a 150,000-patient urban hospital. 
*   **The SQL Audit:** I utilized `COALESCE()` in the PostgreSQL views to convert `NULL` values (which represented zero waitlist patients in high-performing hospitals) into `0.0`. Failing to do this would have mathematically dropped 309 hospitals from the denominator, skewing the national average.

### Core Analytical Insights
1. **The Capacity Deficit is Structural, Not Seasonal:** The dual-line Inflow vs. Outflow chart demonstrates that the NHS is not suffering from seasonal demand spikes (like winter flu surges). Instead, `total_inflow_added` consistently outpaces `total_outflow_treated` week over week for 5 years, indicating a chronic shortage of physical beds or clinical staff.
2. **The 52+ Week Crisis:** While the total waitlist grew by 31.62% over five years, the Stacked Area chart reveals that the growth is disproportionately concentrated in the extreme wait bands (52 to 104+ weeks). The system is failing the most complex, long-term cases.
3. **The Funnel Bottleneck:** General Practitioners (GPs) account for over 38 million system entries. The inflow is highly concentrated at the primary care level.

### Strategic Business Recommendations
Based on the data modeling, I recommend the following operational shifts for NHS leadership:
*   **Targeted CapEx Deployment:** Freeze blanket national funding. Divert emergency capital expenditure specifically to **Manchester University** and **Mid And South Essex** trusts, which are carrying the highest raw patient volume.
*   **Clinical Recruitment Pivot:** The data proves the backlog is heavily localized in **Trauma/Orthopaedics** and **Ophthalmology**. HR must shift recruitment budgets away from general medicine to target these specific surgical specialists.
*   **Upstream GP Interception:** Because GPs are the primary demand driver, funding must be allocated to community diagnostic centers (CDCs) to intercept and treat minor cases before they hit the acute hospital waitlist.

## 🛠️ Technical Stack
* **Database:** PostgreSQL (pgAdmin 4)
* **Data Processing & Cleaning:** SQL (Views, Aggregations, COALESCE, CTEs)
* **Visualization:** Microsoft Excel (Advanced Pivot Tables, Dynamic KPI Engine, Interactive Timeline Slicers)

## 📁 Repository Contents
* **`1_sql_engineering/`**: Contains the SQL queries used to audit the raw data and build the 5 production views.
* **`2_data_exports/`**: Contains the clean CSV datasets powering the dashboard. *(Raw data omitted for size; sourced from NHS England).*
* **`3_dashboard_presentation/`**: Contains high-resolution images, PDF exports, and the fully interactive Excel dashboard file.
