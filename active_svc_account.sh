#!/bin/bash
gcloud beta services identity create --service="dialogflow.googleapis.com" --project=$(gcloud config get-value project)
gcloud beta services identity create --service="discoveryengine.googleapis.com" --project=$(gcloud config get-value project)
gcloud beta services identity create --service="dataplex.googleapis.com" --project=$(gcloud config get-value project)

#get Project number
PROJECT_NUMBER=$(gcloud projects describe $(gcloud config get-value project) --format="value(projectNumber)")

# 3. Dialogflow svc
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member="serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-dialogflow.iam.gserviceaccount.com" \
  --role="roles/bigquery.admin"

gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member="serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-dialogflow.iam.gserviceaccount.com" \
  --role="roles/datacatalog.viewer"

# 4. Discovery Engine svc
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member="serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-discoveryengine.iam.gserviceaccount.com" \
  --role="roles/bigquery.admin"

# 5. Dataplex svc
gcloud projects add-iam-policy-binding $(gcloud config get-value project) \
  --member="serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-dataplex.iam.gserviceaccount.com" \
  --role="roles/bigquery.admin"

echo "Done"