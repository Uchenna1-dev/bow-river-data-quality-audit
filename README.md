# Bow River Data Quality Audit

A SQL data quality audit of public water quality monitoring data from the Bow River in Calgary, Alberta, with a Power BI dashboard to follow. The project takes an unvalidated public extract, checks it against the standard data quality dimensions, logs every issue it finds, and turns the clean result into a dashboard.

**Status:** in progress. The database, raw load and cleaned staging layer are complete; the reference tables and audit checks are being built now.

**Tools:** PostgreSQL, DBeaver, Power BI (planned), Python (initial profiling)

## The data

| | |
| --- | --- |
| Source | Government of Alberta surface water quality data, Bow River stations in Calgary |
| Downloaded | 23 October 2026 |
| Size | 594 measurements, 30 columns |
| Stations | 6 on the Bow River, upstream and downstream of the Bonnybrook sewage treatment plant |
| Period | May 1981 to August 1998 |
| Determinands | 8: ammonia, phosphorus, water temperature, turbidity, pH (field and lab), dissolved oxygen (field meter and Winkler) |

## How it works

The database is built in layers, so every number can be traced back to the original file:

| Layer | Holds |
| --- | --- |
| `raw` | The CSV exactly as downloaded, every column stored as text so a malformed value can never break the load |
| `staging` | A cleaned copy: spaces trimmed, blanks turned into NULL, numbers and dates converted into proper types |
| `ref` | Lookup tables: determinands, physically plausible ranges, station positions along the river |
| `audit` | One issue log that every data quality check writes to |
| `mart` | Views for the Power BI dashboard |

## Findings so far

**1. The date format trap.** Every date in the file is `MM/DD/YYYY`. 385 rows prove it (the second number is above 12), no row suggests day first, and 209 rows are ambiguous, such as `07/06/1989`. A UK style day first parser would reject 385 rows and silently misdate 194 more, making the data appear to end in 1995. The pipeline parses every date with an explicit month first pattern instead of relying on locale settings.

**2. Hidden blanks.** 31 values in `MeasurementFlag` look empty but contain a single space, so a search for missing values would not find them. They were found by measuring each value's length, not by eye.

**3. Completeness.** Three qualifier columns are 100% empty, `QCSampleFlag` holds the same value on every row, and `MethodDetectionLimit` is blank on 378 rows (64%), all of them field measurements.

**4. Uneven coverage.** The extract holds 246 of the 447 water samples the agency lists for these stations (55%). One station has 2 rows; another has 176. There are no samples from 1985 to 1988 or 1990 to 1993.

**5. Nutrients below the outfall, with a caveat.** Below the Bonnybrook outfall, median ammonia is 1.55 mg/L against 0.01 mg/L upstream, and median phosphorus is 1.0 mg/L against 0.019 mg/L. However, the downstream station was sampled in 1981 to 1984 and the upstream stations in 1994 to 1998, so location and time cannot be separated. The result is consistent with an outfall effect but does not prove one.

**Checks passed:** no duplicate rows, no negative or non numeric values, one unit per determinand, and station coordinates that match the agency's station records exactly.

**Staging layer sign off:** 594 rows, 0 dates that failed to convert, 0 values that failed to convert.

## Progress

* [x] Database, schemas and raw table
* [x] Load and reconcile the CSV (594 rows, 6 stations)
* [x] Staging table: cleaning, type conversion, month first date parsing, primary key
* [ ] Reference tables
* [ ] Issue log and data quality checks (completeness, uniqueness, validity, consistency, accuracy, timeliness)
* [ ] Scorecard and coverage analysis
* [ ] Compliance against Alberta surface water quality guidelines
* [ ] Power BI dashboard
* [ ] Final write up

## Repository structure

```
sql/
  01_schema.sql      creates the database layers and the raw table
  02_load.sql        loads the CSV and stamps each row with its source file
  03_staging.sql     builds the cleaned, typed staging table
```

More scripts will be added as each step is completed.

## How to run

1. Install PostgreSQL 16 or later and create a database called `water_quality`.
2. Run the scripts in the `sql` folder in number order.
3. The load script uses psql's `\copy`; update the file path to where the CSV is saved.
