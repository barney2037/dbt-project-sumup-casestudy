# dbt-project-sumup-casestudy

**Created by:** Baris Yuksel  
**Created at:** 2025/04/07

## Objective

This project focuses on defining, calculating, and tracking key performance indicators (KPIs) across the marketing funnel using the provided datasets: `WEB_ORDERS`, `CHANNELS`, and `LEADS_FUNNEL`. These KPIs help the **Mission Lead** assess how marketing efforts are driving business outcomes, from impressions to signed deals.

---

## Data Sources

| Table         | Description |
|---------------|-------------|
| `WEB_ORDERS`  | Tracks marketing and order data. |
| `CHANNELS`    | Metadata about marketing campaigns and channels. |
| `LEADS_FUNNEL`| Tracks lead generation and progress in the sales funnel. |

---

## Funnel Overview

The analysis follows a funnel-based approach:

1. **Awareness**: Ad Impressions
2. **Engagement**: Ad Clicks, Website Sessions
3. **Interest**: Signups
4. **Consideration**: Leads → SQLs → Meetings
5. **Conversion**: Signed Leads → POS Lite Deals / Orders

---

## Core KPIs & Their Formulas

### Marketing Efficiency

| KPI            | Formula |
|----------------|---------|
| **Total Spend**         | `SUM(TOTAL_SPEND)` |
| **CPC** (Cost Per Click) | `TOTAL_SPEND / TOTAL_CLICKS` |
| **CPL** (Cost Per Lead) | `TOTAL_SPEND / TOTAL_LEADS` |
| **CTR** (Click-Through Rate) | `TOTAL_CLICKS / TOTAL_IMPRESSIONS` |

### Website Performance

| KPI                    | Formula |
|------------------------|---------|
| **Signup Rate**         | `NB_OF_SIGNUPS / NB_OF_SESSIONS` |
| **Order Conversion**    | `NB_OF_ORDERS / NB_OF_SIGNUPS` |
| **Session → Order Rate** | `NB_OF_ORDERS / NB_OF_SESSIONS` |

### Lead Funnel Efficiency

| KPI                        | Formula |
|----------------------------|---------|
| **Fake Lead Rate**         | `TOTAL_FAKE_LEADS / TOTAL_LEADS` |
| **Lead to SQL Rate**       | `TOTAL_SQLS / TOTAL_LEADS` |
| **SQL to Meeting Rate**    | `TOTAL_MEETING_DONE / TOTAL_SQLS` |
| **Meeting to Signed Rate** | `TOTAL_SIGNED_LEADS / TOTAL_MEETING_DONE` |
| **Signed to Deal Rate**    | `TOTAL_POS_LITE_DEALS / TOTAL_SIGNED_LEADS` |

### Order & Deal Tracking

| KPI                       | Formula |
|---------------------------|---------|
| **POS Items Ordered**      | `SUM(NB_OF_POSLITE_ITEMS_ORDERED)` |
| **Items Dispatched**       | `SUM(NB_POSLITE_ITEMS_DISPATCHED)` |
| **Dispatch Rate**          | `NB_POSLITE_ITEMS_DISPATCHED / NB_OF_ORDERS` |

---

## KPI Calculation Strategy

1. **Join Data**: Use `CAMPAIGN_ID` to combine `WEB_ORDERS`, `LEADS_FUNNEL`, and `CHANNELS`.
2. **Normalize Spend**: Convert all currency values to EUR if necessary.
3. **Aggregate by**: `DATE`, `COUNTRY`, `PRODUCT`, `CAMPAIGN`, and `CHANNEL`.
4. **Derive KPIs**: Use `dbt` to perform transformations and generate metrics for reporting.

---

## Example KPI Table (per Campaign/Day)

| Date       | Campaign     | Spend | Leads | SQLs | Orders | CTR  | CPL  | SQL Rate | Order Rate |
|------------|--------------|-------|-------|------|--------|------|------|----------|------------|
| 2025-04-01 | Spring_FB_01 | €950  | 110   | 45   | 30     | 3.2% | €8.6 | 41%      | 27%        |

---

## Suggested Enhancements & Additional KPIs

1. **Product Price Table (for Revenue Estimation)**

   Create a table with product prices to estimate revenue and calculate KPIs like:
   - **Estimated Revenue** = `NB_OF_POSLITE_ITEMS_ORDERED * price_eur`
   - **ROAS** = `Estimated Revenue / Total Spend`
   - **CAC** = `Total Spend / Total Signed Leads`

2. **Attribution Beyond Last Click**

   - Implement multi-touch attribution to track user sessions over time and capture campaign touchpoints.

3. **Currency Normalization**

   - Use an `exchange_rates` table to standardize currency values (e.g., USD, GBP) to EUR.

4. **Customer Category in Leads Funnel**

   Add a `customer_category` column to track high, medium, and low-volume customers and optimize lead conversion strategies.

---

## Data Issues

Below are the issues identified in the datasets and suggested solutions:

### Web Orders:
1. **Sessions to Orders Logic**:
   - There should be a logical relationship between `Sessions` and `Orders`. For example, if `Orders = 0`, there shouldn't be any `POSLite_items_orders`. For instance, on 2022-03-18, `campaign_id = 2022-03-18` has `0 orders` but `10000 poslite_orders`, indicating an inconsistency.

2. **Empty Date and CampaignID**:
   - Both `Date` and `CampaignID` should not be empty. Any missing values need to be addressed.

3. **String in Numeric Fields**:
   - There should not be any strings in the `nb_signups` column. On 2022-03-14, `campaign_id = 18461205812` has a string value `'f'`, which causes inconsistency in the data.

4. **Unexpected Value in Column J**:
   - On 2022-05-13, `campaign_id = 21250282073` has a value of `1` in column `J`, even though this column is expected to be empty. This needs to be cleaned to avoid issues during data upload to data warehouses.

---

### Channels:
1. **CampaignID Duplication**:
   - `CampaignID` should be unique. However, multiple entries exist for the same `campaign_id`, leading to inconsistencies. For example, `campaign_id = 21250282073` has two different campaign names due to an extra space in one of them. Consistent naming conventions should be enforced.

2. **Missing Campaign Names**:
   - Some campaign entries are missing their campaign names, leading to difficulties in mapping data. Missing values should be cleaned and handled.

3. **Channel Naming Improvements**:
   - The naming structure for `channel_4` and `channel_5` can be improved for better readability and consistency:
     - Channel 4: `fb-prospecting` → Suggestion: `prospecting`, as `fb` is already captured in `channel_3`.
     - Channel 5: `fb-prospecting-landing` → Suggestion: `landing`, as `fb` and `prospecting` are already labeled in `channel_3` and `channel_4`.

---

### Leads Funnel:
1. **CampaignID Type Inconsistency**:
   - Some `campaign_id` values have decimals (e.g., `120211150575530066` and `120211150575530066.000000`). Ensure that campaign IDs are consistently stored as integers, excluding any decimal points.

2. **Missing CampaignIDs**:
   - Some entries are missing `campaign_id` values, while the campaign name is available. This can be controlled at the source level, ensuring that missing campaign IDs are handled and mapped correctly.

3. **Improving Data Consistency**:
   - The `CampaignID` column in the `Leads Funnel` table should be validated against the list of valid campaign IDs in the campaign table to ensure that all entries can be accurately mapped.

---

## Next Steps

- [ ] Build staging models to clean and normalize raw tables.
- [ ] Create marts with aggregated KPIs.
- [ ] Design dashboards to visualize KPIs.
- [ ] Implement data tests to ensure consistency.

---

## Folder Structure

- `models/staging/` — Clean data models.
- `models/marts/` — KPI-ready models for dashboarding.

---

📂 For more details, explore the folders above.
