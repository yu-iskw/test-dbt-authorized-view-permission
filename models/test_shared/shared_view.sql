{% set project_id = env_var("PROJECT_ID") %}

{{
  config(
    enabled=true,
    full_refresh=false,
    materialized="view",
    database=project_id,
    schema="test_shared",
    alias="shared_view",
    persist_docs={"relation": true, "columns": true},
    labels={
      "status": "test",
      "owner": "yu",
      "modeled": "dbt",
    },
    tags=[],
  )
}}

SELECT
    id AS id
FROM {{ ref("protected_table") }}
