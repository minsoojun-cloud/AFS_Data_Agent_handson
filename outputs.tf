output "dataset_id" {
  value       = google_bigquery_dataset.ga_dataset.dataset_id
  description = "The ID of the created BigQuery dataset"
}

output "view_id" {
  value       = google_bigquery_table.ga_sessions_20170801.id
  description = "The fully qualified ID of the BigQuery view"
}

output "query_example" {
  value       = "SELECT * FROM `${var.gcp_project_id}.${google_bigquery_dataset.ga_dataset.dataset_id}.${google_bigquery_table.ga_sessions_20170801.table_id}` LIMIT 10"
  description = "Example SQL query to test the view in BigQuery"
}








