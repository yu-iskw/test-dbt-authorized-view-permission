{% set project_id = env_var("PROJECT_ID") %}

{{
  config(
    enabled=true,
    full_refresh=false,
    materialized="table",
    database=project_id,
    schema="test_protected",
    alias="protected_table",
    persist_docs={"relation": true, "columns": true},
    labels={
      "status": "test",
      "modeled": "dbt",
    },
    tags=[],
  )
}}

SELECT
    1 AS id
    , "Tommy" AS name
