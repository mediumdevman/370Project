# Functional dependencies & BCNF argument

For each table in `db/schema.sql`, list its functional dependencies (FDs)
and confirm every determinant is a candidate key — that's the definition
of BCNF (Boyce-Codd Normal Form).

A functional dependency `X -> Y` means: given a value of `X`, there is
only ever one possible value of `Y` in that table. A table is in BCNF if,
for every non-trivial FD `X -> Y`, `X` is a candidate key (i.e. `X` could
serve as the table's primary key on its own).

Things to watch for when writing this up:
- **Transitive dependency** — `A -> B -> C` stored all in one table means
  `C` depends on `A` only indirectly, through `B`. This is a normalization
  violation; `C` belongs in the table keyed by `B`, not duplicated here.
- **Partial dependency** — with a composite key `(A, B)`, if some column
  depends on `A` alone (not the full `A, B` pair), that's a violation.
- **Junction tables** — if a table exists purely to represent a
  many-to-many relationship with no extra attributes, it has no non-key
  columns, so BCNF holds vacuously (there's nothing to check).

## Template — copy this per table

```
## TABLE_NAME

FD: `key_column -> other_column_1, other_column_2, ...`

[Explanation of why the determinant is a candidate key, or — if it's
not — what decomposition was needed to fix the violation.]
```

## Summary

Once every table is written up above, state the overall conclusion here:
is the full schema in BCNF? Did any table need to be split into two to
get there?
