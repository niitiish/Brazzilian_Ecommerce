# Modeling decisions

## Customers

### Customer grain (STAGING)
- Table: stg_customers
- Grain: one row per customer_id
- Reason: customer_id is the transactional identifier referenced by orders
- Note: customer_unique_id represents a person and may map to multiple customer_id values

---

### Customer deduplication
- Issue: raw_customers may contain duplicate customer_id rows
- Constraint: no ingestion timestamp or update timestamp available
- Decision: select exactly one deterministic row per customer_id
- Tie-breaker: customer_unique_id (stable secondary identifier)
- Goal: ensure idempotent and reproducible STAGING loads

---

### Customer ZIP code data type
- Column: customer_zip_code_prefix
- Decision: model as VARCHAR(5), not numeric
- Reason: ZIP codes are identifiers and may contain leading zeros
- Layer: enforced starting from TMP and preserved in STAGING

---

### Nullable customer location attributes
- Columns: customer_city, customer_state, customer_zip_code_prefix
- Decision: allow NULL values in STAGING
- Reason: location attributes are descriptive, not identity-defining
- Impact: customers are preserved even if location data is missing

---

### No surrogate keys in STAGING
- Decision: do not introduce auto-increment or surrogate keys in STAGING
- Reason: STAGING must remain deterministic and rebuildable
- Note: surrogate keys will be introduced in DIM tables if required
