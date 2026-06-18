output "dataset_id" {
  value       = google_bigquery_dataset.ga_dataset.dataset_id
  description = "The ID of the created BigQuery dataset"
}

output "view_id" {
  value       = "projects/${var.gcp_project_id}/datasets/${google_bigquery_dataset.ga_dataset.dataset_id}/tables/ga_sessions_20170801"
  description = "The fully qualified ID of the BigQuery table"
}

output "query_example" {
  value       = "SELECT * FROM `${var.gcp_project_id}.${google_bigquery_dataset.ga_dataset.dataset_id}.ga_sessions_20170801` LIMIT 10"
  description = "Example SQL query to test the table in BigQuery"
}








