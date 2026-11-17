# Data source contract for InvestigAIte

This document defines the expected data inputs for the application in a non-sensitive, implementation-focused format. It is meant to describe the type of data the app relies on, not the specific production records or PII-bearing artifacts.

## Source categories

### 1. Transactional data

Purpose: support pattern analysis, trend review, and query execution for investigator inquiries.

Expected source types:

- CSV exports from analytical data stores
- Athena or query result exports in tabular form
- flat files with rows representing transactions or shipment events
- structured records with fields such as:
  - date or timestamp
  - region or geography
  - product or substance identifier
  - buyer / seller / registrant identifier
  - quantity, weight, or dosage unit
  - transaction type or classification

Example field pattern:

```text
transaction_date,region,drug_code,quantity,unit_of_measure,buyer_id,seller_id,transaction_type
2024-01-15,us-east-2,ABC123,1200,kg,acct-001,acct-002,shipment
```

Operational notes:

- This source is used for SQL generation and answer synthesis.
- Query outputs may be stored in S3 and referred to by the app workflow.
- The app should be able to handle tabular results and summarize them in plain English.

### 2. Investigative report / case text data

Purpose: support historical case context, prior findings, and narrative review.

Expected source types:

- structured text exports
- case summaries in plain text or delimited records
- document exports with identifiers and date metadata
- lookup-style records keyed by registrant, provider, or entity

Example field pattern:

```text
case_id,entity_name,entity_type,report_date,summary,investigator_notes,status
case-001,Sample Clinic,clinic,2024-03-20,Inspection summary...,internal note,closed
```

Operational notes:

- This source supports retrieval and narrative summarization.
- The app should not assume a specific schema beyond stable identifiers and text fields.
- Records may be source-controlled only in sanitized or de-identified form.

### 3. Regulatory or reference documents

Purpose: support statutory and procedural guidance.

Expected source types:

- PDFs
- manually curated text extracts
- reference documents stored in immutable buckets or libraries

Example contents:

- CFR section references
- policy summaries
- internal procedures and guidance material

Operational notes:

- These documents are used as reference context rather than transactional source data.
- Their content should be treated as controlled documentation, not investigator data.

## Expected app behavior

The application should be able to work with the following data patterns:

1. a user asks a natural-language question
2. the app routes the question to the relevant source category
3. the app retrieves the relevant records or document context
4. the app summarizes the answer in plain English and prepares a report

## Data handling expectations

- keep raw source data outside the repo unless it is sanitized and explicitly approved
- prefer bucket or object references over embedding sensitive records in code
- keep schema documentation separate from live production data
- treat all source data as environment-specific and subject to least-privilege access

## Example production bucket mapping

A production deployment may use bucket patterns like:

- `analytics-raw-transactions`
- `analytics-query-results`
- `knowledgebase-investigative-reports`
- `reference-regulatory-documents`

These names are illustrative and should be aligned to the real AWS environment during deployment.

## Repository guidance

The repo should not include raw production or public-regulated data. When adding test fixtures, use:

- synthetic sample data
- de-identified record sets
- minimal examples that preserve schema shape without exposing real identifiers
