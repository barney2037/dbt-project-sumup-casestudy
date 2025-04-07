# Data Quality Issues and Solutions

This file outlines the steps taken to identify and resolve various data issues found in the **Web Orders**, **Channels**, and **Leads Funnel** datasets. These issues may affect data consistency and accuracy, and therefore need to be addressed for proper analysis and decision-making.

## Web Orders Dataset

### Issues Identified

1. **Inconsistent Data Between Columns**:
    - There is a logical issue where the number of sessions should be greater than or equal to the number of signups/orders. Additionally, if the number of orders is 0, there should not be any `poslite_items_orders`. However, an inconsistency was found on **2022-03-18** where there were no orders but **10,000** `poslite_orders`, indicating erroneous data.

2. **Missing Values in Date and CampaignID**:
    - The **Date** and **CampaignID** fields should never be empty, as they are crucial for tracking the campaigns and their performance over time. Missing data in these fields can lead to inaccurate reporting and analysis.

3. **Invalid Data in `nb_signups` Column**:
    - The **`nb_signups`** column should only contain numeric values. However, on **2022-03-14** for **campaign ID 18461205812**, the dataset contains the string value `'f'`, causing inconsistency in the dataset and affecting data processing.

4. **Unexpected Values in Column `J`**:
    - The **Column J** should have no values. However, on **2022-05-13** for **campaign ID 21250282073**, there is a value of `1` in this column, which causes issues when uploading data to data warehouses. This should be handled to prevent errors during data integration.

### Solutions

- **Logically Check Column Relationships**: Implement logic to validate the relationship between columns such as sessions, signups, and orders to prevent inconsistencies.
- **Handle Missing Data**: Enforce rules to ensure that the **Date** and **CampaignID** fields are always populated, either by cleaning the data or imputing missing values.
- **Data Validation for `nb_signups`**: Ensure that the **`nb_signups`** column only contains numeric values, and implement logic to handle or clean any non-numeric values (e.g., `'f'`).
- **Validate Column `J`**: Implement validation to ensure that **Column J** is empty or correctly populated before uploading the data to the data warehouse.

---

## Channels Dataset

### Issues Identified

1. **Non-Unique Campaign IDs**:
    - **CampaignID** should be unique in the **channels** table to serve as the source of truth for mapping. However, multiple entries for the same **CampaignID** exist due to inconsistent campaign names. For example, **campaignid 21250282073** has two entries with different names, one with a leading space (`search-shopping_es_brand+gen_prospecting_self-serve` and ` search-shopping_es_brand+gen_prospecting_self-serve`), leading to duplicate campaign records.

2. **Missing Campaign Names**:
    - Some **CampaignIDs** are missing corresponding **Campaign Names**, even though the CampaignID exists elsewhere in the data. This gap needs to be addressed for accurate campaign tracking.

3. **Improvement in Naming Structure for Channels 4 and 5**:
    - The naming convention in **Channel 4** and **Channel 5** can be improved to enhance readability and consistency across the dataset:
    
    - **Channel 4**:
      - **Old Name**: `fb-prospecting`
      - **Suggested Name**: `prospecting`
      - **Reason**: As "fb" (Facebook) is already labeled in **Channel 3**, it is redundant to repeat it here. Simplifying the name to just `prospecting` would make the data cleaner and more concise.
    
    - **Channel 5**:
      - **Old Name**: `fb-prospecting-landing`
      - **Suggested Name**: `landing`
      - **Reason**: "fb" (Facebook) and "prospecting" are already accounted for in **Channels 3** and **4**, so these terms don't need to be repeated in **Channel 5**. Simplifying the name to `landing` enhances clarity.

    - **Impact**: With these naming suggestions, we will be able to compare the performance of different channels (such as **fb**, **search**, and **organic**) for various campaigns (such as **landing**, **generic**, and **channel 5**). This will enable more accurate assessments of campaign effectiveness and improve readability for data analysis.

### Solutions

- **Data Consistency**: Implement data quality checks to enforce unique **CampaignIDs** and prevent any variation in campaign names (e.g., spaces or special characters) when inputting data.
- **Remove Null Entries**: Introduce logic to remove rows with **null** campaign names and ensure every **CampaignID** is paired with its respective **Campaign Name**.
- **Naming Structure Standardization**: Update the naming structure for **Channel 4** and **Channel 5** to reflect the suggestions above. This will improve readability and allow for better comparison of campaign performance.

---

## Leads Funnel Dataset

### Issues Identified

1. **Campaign IDs with Decimal Values**:
    - Some **CampaignIDs** are recorded with decimal points (e.g., `120211150575530066` and `120211150575530066.000000`). This inconsistency can create data mismatches or errors during analysis as campaign IDs should be treated as whole numbers.

2. **Missing Campaign IDs**:
    - There are instances where **CampaignIDs** are missing, but the corresponding **Campaign Name** is available. This missing data should be controlled at the source and handled properly in the data pipeline.

3. **CampaignID Validation**:
    - **Suggestion**: The **CampaignID** column should be validated against the **CampaignIDs** listed in the **Campaign Table** to ensure consistency and accuracy. For example, **CampaignIDs** like **11348193304807181773** and **120207888497020698** are present in the **Leads Funnel Table**, but they are not registered in the **Campaign Table**. 
    - **Impact**: Since these **CampaignIDs** are not recognized in the source table, the campaigns cannot be identified or mapped correctly. This issue may have been caused by a typo during data entry, but it is not considered best practice to allow such discrepancies in the data. Implementing a validation step to cross-check **CampaignIDs** with the **Campaign Table** would improve data integrity and ensure that each campaign can be correctly mapped.

### Solutions

- **Standardize Campaign ID Data Type**: Ensure that all **CampaignIDs** are consistently stored as integers, excluding any decimal values during data processing.
- **Map Missing Campaign IDs**: Set up mapping rules to link **Campaign Names** to their respective **CampaignIDs**, ensuring no campaign is left unmapped.
- **CampaignID Validation**: Implement a validation process to ensure that **CampaignIDs** in the **Leads Funnel** dataset exist in the **Campaign Table**. Any **CampaignIDs** that do not match should be flagged and reviewed, helping to prevent data discrepancies caused by typos or incomplete mappings.


