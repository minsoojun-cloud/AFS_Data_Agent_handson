terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = var.gcp_region
}


# Define all necessary APIs to enable
locals {
  apis = [
    "bigquery.googleapis.com",
    "dialogflow.googleapis.com",
    "discoveryengine.googleapis.com",
    "aiplatform.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "connectors.googleapis.com",
    "dataplex.googleapis.com"
  ]
}






# Enable APIs in a loop
resource "google_project_service" "enabled_apis" {
  for_each           = toset(local.apis)
  project            = var.gcp_project_id
  service            = each.key
  disable_on_destroy = false
}

# Create the BigQuery Dataset
resource "google_bigquery_dataset" "ga_dataset" {
  dataset_id                  = "google_analytics_sample"
  friendly_name               = "Google Analytics Sample (Linked)"
  description                 = "Dataset containing views linked to the bigquery-public-data Google Analytics sample tables"
  location                    = "US"
  project                     = var.gcp_project_id

  depends_on = [google_project_service.enabled_apis]
}

# Create the view linking to the public dataset table
resource "google_bigquery_table" "ga_sessions_20170801" {
  dataset_id          = google_bigquery_dataset.ga_dataset.dataset_id
  table_id            = "ga_sessions_20170801"
  project             = var.gcp_project_id
  deletion_protection = false

  view {
    query          = "SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`"
    use_legacy_sql = false
  }

  depends_on = [google_bigquery_dataset.ga_dataset]
}

# Force creation of Dialogflow Service Identity
resource "google_project_service_identity" "dialogflow_sa" {
  provider = google-beta
  project  = var.gcp_project_id
  service  = "dialogflow.googleapis.com"

  depends_on = [google_project_service.enabled_apis]
}

# Force creation of Discovery Engine Service Identity
resource "google_project_service_identity" "discoveryengine_sa" {
  provider = google-beta
  project  = var.gcp_project_id
  service  = "discoveryengine.googleapis.com"

  depends_on = [google_project_service.enabled_apis]
}

# Force creation of Dataplex Service Identity
resource "google_project_service_identity" "dataplex_sa" {
  provider = google-beta
  project  = var.gcp_project_id
  service  = "dataplex.googleapis.com"

  depends_on = [google_project_service.enabled_apis]
}

# Grant BigQuery Admin permission to Dialogflow Service Agent (required for Agent tool query execution)
resource "google_project_iam_member" "dialogflow_bq_admin" {
  project = var.gcp_project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_project_service_identity.dialogflow_sa.email}"

  depends_on = [google_project_service.enabled_apis]
}

# Grant BigQuery Admin permission to Discovery Engine Service Agent (required for Agent tool query execution)
resource "google_project_iam_member" "discoveryengine_bq_admin" {
  project = var.gcp_project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_project_service_identity.discoveryengine_sa.email}"

  depends_on = [google_project_service.enabled_apis]
}

# Grant BigQuery Admin permission to Dataplex Service Agent (required for metadata indexing and search)
resource "google_project_iam_member" "dataplex_bq_admin" {
  project = var.gcp_project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_project_service_identity.dataplex_sa.email}"

  depends_on = [google_project_service.enabled_apis]
}





