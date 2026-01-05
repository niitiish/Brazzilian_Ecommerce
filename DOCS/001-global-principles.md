# Modeling Decisions

## Table of Contents
- [Global Principles](#global-principles)

---

## Global Principles

### RAW data immutability
- Decision: RAW tables are treated as immutable representations of source CSVs
- Reason: RAW exists to preserve source truth, including upstream issues
- Note: No deduplication, normalization, or business logic is applied in RAW

---

### Layered modeling approach
- Layers used: RAW → TMP → STAGING → DIMENSIONS → FACTS
- Decision: Each layer has a single, well-defined responsibility
- Reason: Prevents mixing of data safety, semantics, and metrics
- Note: Logic is only allowed in the layer where it semantically belongs

---

### Idempotent rebuild strategy
- Decision: STAGING tables must be fully rebuildable from RAW/TMP
- Reason: Ensures reruns produce identical results and avoids stateful pipelines
- Note: Auto-generated surrogate keys are avoided before DIM layer

---

