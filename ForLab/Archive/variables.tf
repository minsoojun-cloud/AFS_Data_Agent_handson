variable "gcp_project_id" {
  type        = string
  description = "The Google Cloud Project ID automatically passed by Qwiklabs"
}

variable "gcp_region" {
  type        = string
  default     = "us-central1"
  description = "The region for GCP resources automatically passed by Qwiklabs"
}

variable "gcp_zone" {
  type        = string
  default     = ""
  description = "The zone for GCP resources automatically passed by Qwiklabs"
}
