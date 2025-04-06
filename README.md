# dbt-project-sumup-casestudy

**Created by:** Baris Yuksel
**Created at:** 2025/04/06

**Question 1**: What are the main KPIs the Mission Lead should track to answer their business question? 
How will you build these metrics? What are the different steps we should track?  

# 📊 KPI Strategy for Marketing Funnel Performance

This repository documents the approach to defining, calculating, and tracking core marketing and sales KPIs based on the provided datasets: `WEB_ORDERS`, `CHANNELS`, and `LEADS_FUNNEL`.

---

## ✅ Objective

To help the **Mission Lead** monitor how marketing efforts translate into business outcomes by tracking key performance indicators (KPIs) across the full funnel—from impressions to signed deals.

---

## 📁 Data Sources

| Table         | Description |
|---------------|-------------|
| `WEB_ORDERS`  | Captures website marketing and order metrics. |
| `CHANNELS`    | Metadata about campaigns and their marketing channels. |
| `LEADS_FUNNEL`| Tracks lead generation and progression through the sales funnel. |

---

## 🧭 Funnel Overview

The data models support a funnel-based analysis:

1. **Awareness**: Ad Impressions
2. **Engagement**: Ad Clicks, Website Sessions
3. **Interest**: Signups
4. **Consideration**: Leads → SQLs → Meetings
5. **Conversion**: Signed Leads → POS Lite Deals / Orders

---

## 📊 Core KPIs & How They're Built

### 🧾 Marketing Efficiency

| KPI            | Formula |
|----------------|---------|
| **Total Spend**         | `SUM(TOTAL_SPEND)` or `SUM(TOTAL_SPEND_EUR)` |
| **CPC (Cost Per Click)**| `TOTAL_SPEND / TOTAL_CLICKS` |
| **CPL (Cost Per Lead)** | `TOTAL_SPEND / TOTAL_LEADS` |
| **CTR (Click-Through Rate)** | `TOTAL_CLICKS / TOTAL_IMPRESSIONS` |

---

### 🌐 Website Performance

| KPI                    | Formula |
|------------------------|---------|
| **Signup Rate**        | `NB_OF_SIGNUPS / NB_OF_SESSIONS` |
| **Order Conversion**   | `NB_OF_ORDERS / NB_OF_SIGNUPS` |
| **Session → Order Rate** | `NB_OF_ORDERS / NB_OF_SESSIONS` |

---

### 🔁 Lead Funnel Efficiency

| KPI                        | Formula |
|----------------------------|---------|
| **Fake Lead Rate**         | `TOTAL_FAKE_LEADS / TOTAL_LEADS` |
| **Lead to SQL Rate**       | `TOTAL_SQLS / TOTAL_LEADS` |
| **SQL to Meeting Rate**    | `TOTAL_MEETING_DONE / TOTAL_SQLS` |
| **Meeting to Signed Rate** | `TOTAL_SIGNED_LEADS / TOTAL_MEETING_DONE` |
| **Signed to Deal Rate**    | `TOTAL_POS_LITE_DEALS / TOTAL_SIGNED_LEADS` |

---

### 📦 Order & Deal Tracking

| KPI                       | Formula |
|---------------------------|---------|
| **POS Items Ordered**     | `SUM(NB_OF_POSLITE_ITEMS_ORDERED)` |
| **Items Dispatched**      | `SUM(NB_POSLITE_ITEMS_DISPATCHED)` |
| **Dispatch Rate**         | `NB_POSLITE_ITEMS_DISPATCHED / NB_OF_ORDERS` |

---

## 🧱 KPI Calculation Strategy

- **Join Data:** Use `CAMPAIGN_ID` to join `WEB_ORDERS`, `LEADS_FUNNEL`, and `CHANNELS`.
- **Normalize Spend:** Consider converting all currencies to EUR if needed.
- **Aggregate by:** `DATE`, `COUNTRY`, `CAMPAIGN`, and `CHANNEL` levels.
- **Derive KPIs:** Use `dbt` to build transformations and expose metrics to dashboards.

---

## 🧮 Example KPI Table (per Campaign/Day)

| Date       | Campaign     | Spend | Leads | SQLs | Orders | CTR  | CPL  | SQL Rate | Order Rate |
|------------|--------------|-------|-------|------|--------|------|------|----------|------------|
| 2025-04-01 | Spring_FB_01 | €950  | 110   | 45   | 30     | 3.2% | €8.6 | 41%      | 27%        |

---


## ✨ Suggested Enhancements & Additional KPIs

#### 🛍️ 1. **Product Price Table (for Revenue Estimation)**

Introduce a new table for product prices:

| **product**   | **price_eur** | **currency** |
|---------------|---------------|--------------|
| POS Lite      | 29.99         | EUR          |
| SumUp Solo    | 59.99         | EUR          |

This allows for the calculation of revenue-based KPIs like:

- **Estimated Revenue** = `nb_of_poslite_items_ordered * price_eur`
- **ROAS** = `estimated_revenue / total_spend`
- **CAC (Customer Acquisition Cost)** = `total_spend / total_signed_leads`

#### 🧭 2. **Attribution Beyond Last Click**

To improve understanding of user acquisition:

- Move beyond last-click attribution
- Consider building multi-touch attribution by tracking:
  - Sessions over time
  - Campaign touchpoints per user (e.g., session IDs, cookies, UTM parameters)


#### 💱 3. **Currency Normalization**

As `leads_funnel` may use different currencies, normalize all monetary values (spend, revenue) to **EUR** using:

- A daily `exchange_rates` table
- Or adding a standardized `price_eur` field in `product_prices`

### 💱 4. **New Column: `customer_category` in Leads Funnel Table**

To improve the granularity of lead data, I suggest adding a **customer category** column to the **Leads Funnel** table. This will allow the marketing team to better segment and analyze lead progression through the funnel based on customer categories. It will enable tracking of leads according to their spending behavior and frequency, which will help in improving lead conversion strategies.

#### **Leads Funnel Table (`leads_funnel`) with `customer_category`**

| **lead_id** | **date** | **country_code** | **campaign_id** | **campaign_name** | **currency** | **product** | **channel_3** | **channel_4** | **channel_5** | **total_impressions** | **total_clicks** | **total_spend** | **total_leads** | **total_fake_leads** | **total_sqls** | **total_meeting_done** | **total_signed_leads** | **total_pos_lite_deals** | **customer_category** |
|-------------|----------|------------------|-----------------|------------------|--------------|-------------|---------------|---------------|---------------|-----------------------|------------------|-----------------|-----------------|----------------------|----------------|-----------------------|------------------------|------------------------|----------------------|
| 1           | 2023-04-01 | US               | 101             | Spring Promo     | USD          | POS Lite    | Facebook      | Prospecting   | Video Ad      | 5000                  | 1500             | 500             | 100             | 10                   | 50             | 20                    | 10                     | 5                      | High-Volume           |
| 2           | 2023-04-02 | UK               | 102             | Summer Blast     | GBP          | POS Lite    | Google        | Remarketing   | Display Ad    | 4000                  | 1300             | 400             | 80              | 8                    | 40             | 15                    | 8                      | 4                      | Medium-Volume         |
| 3           | 2023-04-03 | DE               | 103             | New Year Sale    | EUR          | POS Lite    | Bing          | Acquisition   | Carousel Ad   | 3000                  | 1200             | 300             | 60              | 6                    | 30             | 10                    | 5                      | 2                      | Low-Volume            |

---

### **Why Add `customer_category` to the Leads Funnel Table?**

By adding this **customer category** field, the **Leads Funnel** data becomes more granular, allowing you to:

1. **Track Lead Behavior Across Segments**: Understand how **High-Volume**, **Medium-Volume**, and **Low-Volume** customers behave through the funnel.
   
2. **Refine Marketing Strategies**: Tailor marketing efforts to each customer category, optimizing campaigns and content for more effective conversions.

3. **Enhance Lead Scoring**: Apply different lead scoring models based on customer category, which helps prioritize high-potential leads.

4. **Improve Forecasting**: Predict future conversions and sales by understanding the typical behavior of each customer segment.


## 📌 Next Steps

- [ ] Build `staging` models to clean and normalize raw tables
- [ ] Create `marts` with aggregated KPIs
- [ ] Design dashboards using these KPIs
- [ ] Implement tests to ensure metric consistency

---

📂 For more details, check the folders:
- `models/staging/` — clean data models
- `models/marts/` — KPI-ready models for dashboarding
