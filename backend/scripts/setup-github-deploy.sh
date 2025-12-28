#!/bin/bash
set -e

# Configuration - update these
PROJECT_ID="baby-tracker-88ca3"
REGION="us-central1"
REPOSITORY="baby-tracker"
SERVICE_ACCOUNT_NAME="github-actions-deployer"
GITHUB_ORG="justintout"  # your GitHub username or org
GITHUB_REPO="baby-tracker"

echo "=== Setting up GitHub Actions deploy to Cloud Run ==="
echo "Project: $PROJECT_ID"
echo "Region: $REGION"
echo ""

# Enable required APIs
echo "1. Enabling required APIs..."
gcloud services enable \
  artifactregistry.googleapis.com \
  run.googleapis.com \
  iamcredentials.googleapis.com \
  cloudresourcemanager.googleapis.com \
  --project=$PROJECT_ID

# Create Artifact Registry repository
echo ""
echo "2. Creating Artifact Registry repository..."
gcloud artifacts repositories create $REPOSITORY \
  --repository-format=docker \
  --location=$REGION \
  --project=$PROJECT_ID \
  --description="Docker images for Baby Tracker" \
  2>/dev/null || echo "   Repository already exists"

# Create service account
echo ""
echo "3. Creating service account..."
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --display-name="GitHub Actions Deployer" \
  --project=$PROJECT_ID \
  2>/dev/null || echo "   Service account already exists"

SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

# Grant permissions to service account
echo ""
echo "4. Granting permissions to service account..."

# Cloud Run Admin
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/run.admin" \
  --quiet

# Artifact Registry Writer
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/artifactregistry.writer" \
  --quiet

# Service Account User (to deploy as the Cloud Run service account)
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
  --role="roles/iam.serviceAccountUser" \
  --quiet

# Create Workload Identity Pool
echo ""
echo "5. Creating Workload Identity Pool..."
gcloud iam workload-identity-pools create "github-pool" \
  --location="global" \
  --display-name="GitHub Actions Pool" \
  --project=$PROJECT_ID \
  2>/dev/null || echo "   Pool already exists"

# Create Workload Identity Provider
echo ""
echo "6. Creating Workload Identity Provider..."
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --location="global" \
  --workload-identity-pool="github-pool" \
  --display-name="GitHub Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
  --attribute-condition="assertion.repository_owner == '${GITHUB_ORG}'" \
  --issuer-uri="https://token.actions.githubusercontent.com" \
  --project=$PROJECT_ID \
  2>/dev/null || echo "   Provider already exists"

# Get the Workload Identity Provider resource name
WIF_PROVIDER=$(gcloud iam workload-identity-pools providers describe github-provider \
  --location="global" \
  --workload-identity-pool="github-pool" \
  --project=$PROJECT_ID \
  --format="value(name)")

# Allow GitHub Actions to impersonate the service account
echo ""
echo "7. Allowing GitHub to impersonate service account..."
gcloud iam service-accounts add-iam-policy-binding $SERVICE_ACCOUNT_EMAIL \
  --member="principalSet://iam.googleapis.com/${WIF_PROVIDER}/attribute.repository/${GITHUB_ORG}/${GITHUB_REPO}" \
  --role="roles/iam.workloadIdentityUser" \
  --project=$PROJECT_ID \
  --quiet

echo ""
echo "=== Setup complete! ==="
echo ""
echo "Add these secrets to your GitHub repository:"
echo "  Settings > Secrets and variables > Actions > New repository secret"
echo ""
echo "WIF_PROVIDER:"
echo "  $WIF_PROVIDER"
echo ""
echo "WIF_SERVICE_ACCOUNT:"
echo "  $SERVICE_ACCOUNT_EMAIL"
echo ""
