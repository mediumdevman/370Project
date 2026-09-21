# Generative AI usage disclosure

Per course policy, this document tracks where and how generative AI was
used on this project, and how we ensured it did not substitute for our
own development of course competencies.

## Sprint 1

- Tool used: Claude (Anthropic)
- Scope: brainstorming the initial ERD structure (entities, relationships,
  cardinalities) for the song logging/rating idea, and drafting an initial
  pass at the SQL DDL from that ERD.
- What we did ourselves: reviewed and revised the entity list against our
  own requirements, worked through the functional dependency / BCNF
  reasoning by hand for each table (see `docs/normalization.md`), and
  verified the DDL runs correctly and matches our intended design before
  including it.
- Why this doesn't undermine our learning: the AI-drafted ERD and DDL were
  treated as a first draft to critique and correct, not a final answer —
  the normalization argument and schema validation were done by the team.
