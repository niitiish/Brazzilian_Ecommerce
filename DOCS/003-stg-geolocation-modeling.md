# Decisions Log

## Geolocation Modeling & Encoding Handling

### Context
The Olist `raw_geolocation` dataset contains multiple records per `geolocation_zip_code_prefix`, with slight variations in latitude/longitude and city labels. Some city values contain encoding corruption due to mojibake characters.

The objective was to design a stable, analyzable **staging geolocation table** suitable for downstream joins with customers and sellers.

---

### Decision 1: Encoding Issue Detection and Handling

**Decision**  
A conservative encoding safeguard is implemented in the temporary layer.

- Rows are flagged if `geolocation_city` contains invalid symbols indicating encoding corruption (`£ ¢ ¥ € ± × ÷ ¹ ² ³`).
- Deterministic corrections are applied only for known cases using ZIP-level targeting.
- Unknown or future encoding issues are preserved and not replaced with NULL or empty values.

**Rationale**
- Accented UTF-8 characters (e.g. `ã`, `é`, `ç`) are valid and should not be treated as errors.
- Encoding corruption is repairable; data loss is not.
- ZIP-level targeting avoids incorrect mass replacements.

**Impact**
- No row loss
- No silent data mutation
- Encoding logic remains auditable and extendable

---

### Decision 2: Geolocation Grain Selection

**Decision**  
`geolocation_zip_code_prefix` is chosen as the grain for the staging geolocation table.

**Rationale**
- Raw geolocation data contains multiple rows per ZIP prefix.
- ZIP prefix is the most stable join key across customers and sellers.
- ZIP-level grain avoids row explosion during fact joins.

**Impact**
- One row per ZIP prefix in staging
- ZIP prefix enforced as `PRIMARY KEY NOT NULL`

---

### Decision 3: Coordinate Aggregation Strategy

**Decision**  
Latitude and longitude are aggregated using the average (centroid) per ZIP prefix.

**Rationale**
- Raw coordinates represent multiple measurements within the same ZIP area.
- Averaging produces a stable and geographically meaningful centroid.
- Selecting an arbitrary row would be deterministic but not spatially representative.

**Impact**
- Coordinates represent approximate ZIP-level location
- Suitable for mapping, distance, and regional analysis

---

### Decision 4: City and State Selection Strategy

**Decision**  
City and state labels are selected using the most frequent value (mode) per ZIP prefix.

**Rationale**
- Multiple city labels may exist per ZIP due to noise or spelling variants.
- Mode reflects the dominant label in the data.
- More meaningful than arbitrary selection (`min`, `max`, or row-based selection).

**Tie Handling**
- In the event of ties, PostgreSQL resolves deterministically based on ordering.
- This behavior is accepted and documented.

**Impact**
- City and state are descriptive attributes, not authoritative mappings.
- Columns remain nullable to avoid enforcing semantic assumptions.

---

### Decision 5: Staging Table Constraints

**Decision**
- `geolocation_zip_code_prefix`: `PRIMARY KEY NOT NULL`
- `geolocation_lat`, `geolocation_lng`, `geolocation_city`, `geolocation_state`: nullable

**Rationale**
- ZIP prefix defines row identity.
- Descriptive attributes may be missing in future data and should not block ingestion.
- Constraints encode invariants, not expectations.

---

### Summary

The staging geolocation table represents:

> A ZIP-level geographic centroid with dominant descriptive labels, derived conservatively from raw data.

This design prioritizes:
- Semantic honesty
- Join stability
- Auditability
- Future extensibility
