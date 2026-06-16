terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
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
    "geminidataanalytics.googleapis.com",
    "cloudaicompanion.googleapis.com"
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
# resource "google_bigquery_dataset" "ga_dataset" {
#   dataset_id                  = "google_analytics_sample"
#   friendly_name               = "Google Analytics Sample (Linked)"
#   description                 = "Dataset containing views linked to the bigquery-public-data Google Analytics sample tables"
#   location                    = "US"
#   project                     = var.gcp_project_id
# 
#   depends_on = [google_project_service.enabled_apis]
# }
# 
# # Create the view linking to the public dataset table
# resource "google_bigquery_table" "ga_sessions_20170801" {
#   dataset_id          = google_bigquery_dataset.ga_dataset.dataset_id
#   table_id            = "ga_sessions_20170801"
#   project             = var.gcp_project_id
#   deletion_protection = false
# 
#   view {
#     query          = "SELECT * FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`"
#     use_legacy_sql = false
#   }
# 
#   depends_on = [google_bigquery_dataset.ga_dataset]
# }
