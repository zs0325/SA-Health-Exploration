# SA Health Exploration — dbt + BigQuery

Exploratory analysis of **WHO South Africa TB and HIV health indicators** using dbt on Google BigQuery. Raw WHO CSV data is ingested into BigQuery, transformed through a staging and marts layer, and visualised in Tableau.

---

## Dataset

| Property | Detail |
|----------|--------|
| Source | World Health Organisation (WHO) |
| Geography | South Africa |
| Domain | Public health — TB & HIV indicators |
| Format | CSV → Google Cloud Storage → BigQuery |

---

## Tech Stack

- **Google BigQuery** — cloud data warehouse
- **dbt (data build tool)** — transformation layer, testing, and documentation
- **SQL** — CTEs, window functions, pivots, aggregations
- **Tableau** — dashboards and visualisations
- **GCP / OAuth** — authentication

---

## Pipeline

```
WHO CSV Dataset
      ↓
Google Cloud Storage
      ↓
BigQuery Raw Table (who_health.TB_Indicator)
      ↓
dbt Staging Layer  (stg_tb_indicator — cleans column names)
      ↓
dbt Marts Layer    (6 analytical models)
      ↓
Tableau Dashboards
```

---

## Project Structure

```
sa_health_dbt/
├── docs/
│   ├── lineage.png
├── models/
│   ├── staging/
│   │   ├── stg_tb_indicator.sql          # Cleans raw column names once
│   │   └── schema.yml                    # Source definition + staging tests
│   └── marts/
│       ├── tb_incidence_trend.sql
│       ├── treatment_success_rates.sql
│       ├── treatment_success_by_category.sql
│       ├── hiv_tb_coinfection.sql
│       ├── rolling_average_anomalies.sql
│       ├── composite_health_score.sql
│       └── schema.yml                    # Mart model docs + data tests
├── dbt_project.yml
├── profiles.yml                          # Copy to ~/.dbt/profiles.yml
├── README.md
└── test_results.txt
```

---

## Model Lineage

```
who_health.TB_Indicator  (raw BigQuery source)
            ↓
    stg_tb_indicator     (staging view)
            ↓
┌──────────────────────────────────────────┐
│  tb_incidence_trend                      │
│  treatment_success_rates                 │
│  treatment_success_by_category           │
│  hiv_tb_coinfection                      │
│  rolling_average_anomalies               │
│  composite_health_score                  │
└──────────────────────────────────────────┘
```

All mart models depend solely on `stg_tb_indicator`, meaning the raw source table is only referenced once. Any upstream schema changes only need to be fixed in one place.

---

## Marts

| Model | Description |
|-------|-------------|
| `tb_incidence_trend` | Year-over-year TB incidence per 100k with absolute and % change |
| `treatment_success_rates` | Pivoted treatment success rates across all TB categories per year |
| `treatment_success_by_category` | Success rates by category with rank within each year |
| `hiv_tb_coinfection` | HIV-TB case counts, % of total TB, and HIV-TB treatment success rate |
| `rolling_average_anomalies` | Flags years where TB incidence deviates > 1 stddev from 5-year rolling avg |
| `composite_health_score` | Weighted score: 40% new TSR + 40% treatment coverage + 20% HIV test rate |

---

## BigQuery Output Datasets

| dbt Layer | BigQuery Dataset | Materialisation |
|-----------|-----------------|-----------------|
| Staging | `dbt_dev_staging` | View |
| Marts | `dbt_dev_marts` | Table |

---

## Setup

### Prerequisites
- Google Cloud account with BigQuery enabled
- Python 3.8+
- `gcloud` CLI installed

### Steps

1. **Clone the repo**
   ```bash
   git clone https://github.com/zs0325/SA-Health-Exploration.git
   cd SA-Health-Exploration
   ```

2. **Install dbt**
   ```bash
   pip install dbt-bigquery
   ```

3. **Configure your profile** — copy `profiles.yml` to the dbt home directory:
   ```bash
   cp profiles.yml ~/.dbt/profiles.yml
   ```

4. **Authenticate with GCP**
   ```bash
   gcloud auth application-default login
   ```
   > On WSL2, copy the URL printed in the terminal into your Windows browser if it doesn't open automatically.

5. **Verify the connection**
   ```bash
   dbt debug
   ```

---

## Usage

```bash
# Build all models
dbt run

# Run all data tests
dbt test

# Build and test in one command (recommended)
dbt build

# Generate and serve documentation locally
dbt docs generate
dbt docs serve
```
