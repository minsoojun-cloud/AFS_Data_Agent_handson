variable "project_id" {
  type        = string
  default = "aeon-workshop-demo"
  description = "The Google Cloud Project ID"
}

variable "region" {
  type        = string
  default     = "US"
  description = "The region for the BigQuery dataset"
}

