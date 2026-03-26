# SA-Health-Exploration - BigQuery Exploratory Analysis

## Project Overview
This project ingests the **WHO South Africa Health dataset** from CSV into Google BigQuery and performs structured exploratory analysis to surface trends across key health indicators. 

---

## Dataset
| Property | Detail |
| --- | --- |
| **Source**   | World Health Organisation |
| **Geography** | South Africa |
| **Format** | CSV -> BigQuery |
| **Domain** | Public health indicators (HIV, TB) |

---

## Tech Stack

- **Google BigQuery** - cloud data warehouse & query engine
- **SQL** - CTEs, window functions, joins, aggregations.

---

## Pipeline

```

 WHO CSV dataset
        🔻
Google Cloud Storage
        🔻
 BigQuery Table
        🔻
Exploratory SQL Analysis 
        🔻
  Insights & Trends

```
---

## Repository Structure

```
SA-Health-Exploration
|--- sql
      |--- Composite health.sql
      |--- Flag years deviating from 5 year rolling average.sql
      |--- HIV-TB coinfection.sql
      |--- TB Incidents Trend.sql
      |--- Treatment success rate by category.sql
      |--- Treatment success rates: all categories per year.sql
|--- README.md

```
---

## Getting Started

### Prerequisites 
- Google Cloud account with BigQuery enabled
- Access to the WHO South African dataset(CSV)

### Steps

1. **Clone this repo**
   ```bash
   git clone https://github.com/zs0325/SA-Health-Exploration.git
   cd SA-Health-Exploration
   ```

2. **Upload CSV to BigQuery**

3. **Run the queries**

---