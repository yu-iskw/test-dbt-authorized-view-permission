terraform {
  # Specify a version to avoid accidentally upgrading terraform state
  required_version = "1.0.0"

  backend "local" {
    path = "./terraform.tfstate"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.50, < 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 3.50, < 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}
