resource "google_bigquery_dataset_access" "shared_table_is_an_authorized_view" {
  project = var.project_id

  dataset_id = "test_protected"

  view {
    project_id = var.project_id
    dataset_id = "test_shared"
    table_id = "shared_view"
  }
}
