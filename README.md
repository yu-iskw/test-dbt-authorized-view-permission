# Check if an BigQuery authorized view permission is kept with dbt and terraform
The repository is used to make sure if permission of an authorized view can be kept even after recreating a dbt model for an authorized view.

The reason I grant authorized view permission with terraform is to centralize permissions in a single place as terraform.
I totally understand that it is a little annoying to manage dbt models and their authorized view permissions separately.
But, I want to use terraform to control ACL including Google Cloud IAM.

On the contrary, if it is ok with you to grant authorized view permission with dbt, the official feature would be useful.
[BigQuery configurations \| dbt Docs](https://docs.getdbt.com/reference/resource-configs/bigquery-configs#authorized-views)

## TL;DR
Even if I grant authorized view permissions to BigQuery tables created by dbt with terraform, authorized views can keep the permission even after recreating dbt models.

## How to setup
The test environment uses:
- Python: 3.8
- dbt 0.19.1

```bash
make setup
```
## How to run

### 1. Create dbt models
The command below enables us to create the two BigQuery tables.
At the moment, the view is not an authorized view yet.
The later table will be an authorized view with terraform later.

- ${YOUR_GCP_PROJECT_ID}.test_protected.protected_table
- ${YOUR_GCP_PROJECT_ID}.test_shared.shared_view

```bash
make run-dbt PROJECT_ID="$(YOUR_GCP_PROJECT_ID)"
```

### 2. Show the dataset information
We make sure if the view is not an authorized view by showing the dataset information.
```bash
make show-bigquery-info PROJECT_ID="${YOUR_GCP_PROJECT_ID}"

{
  "access": [
    {
      "role": "WRITER",
      "specialGroup": "projectWriters"
    },
    {
      "role": "OWNER",
      "specialGroup": "projectOwners"
    },
    {
      "role": "OWNER",
      "userByEmail": "you@gmail.com"
    },
    {
      "role": "READER",
      "specialGroup": "projectReaders"
    }
  ],
  "creationTime": "1624103472910",
  "datasetReference": {
    "datasetId": "test_protected",
    "projectId": "{{ YOUR_GCP_PROJECT_ID }}"
  },
  "etag": "GX0GkUgggjCQ2cWz7lyOdQ==",
  "id": "{{ YOUR_GCP_PROJECT_ID }}:test_protected",
  "kind": "bigquery#dataset",
  "lastModifiedTime": "1624103472910",
  "location": "asia-northeast1",
  "selfLink": "https://bigquery.googleapis.com/bigquery/v2/projects/{{ YOUR_GCP_PROJECT_ID }}/datasets/test_protected",
  "type": "DEFAULT"
}
```

### 3. Grant authorized view permission 
Alright, let's make the view an authorized view with terraform.
```bash
make run-terraform PROJECT_ID="$(YOUR_GCP_PROJECT_ID)"
```

### 4. Show the dataset information
The view has been an authorized view.
Let's make sure of that.
```bash
make show-bigquery-info PROJECT_ID="${YOUR_GCP_PROJECT_ID}"

{
  "access": [
    {
      "view": {
        "datasetId": "test_shared",
        "projectId": "{{ YOUR_GCP_PROJECT_ID }}",
        "tableId": "shared_view"
      }
    }
...
```

### 5. Recreate dbt models
We recreate the dbt models so that the view keeps the authorized view permission.
```bash
make run-dbt PROJECT_ID="$(YOUR_GCP_PROJECT_ID)"
```

### 6. Show the dataset information
The view must keep the authorized view permission.
```bash
make show-bigquery-info PROJECT_ID="${YOUR_GCP_PROJECT_ID}"

{
  "access": [
    {
      "view": {
        "datasetId": "test_shared",
        "projectId": "{{ YOUR_GCP_PROJECT_ID }}",
        "tableId": "shared_view"
      }
    }
...
```

### 7. Clean up
Finally, please don't forget clean up the testing resources.
```bash
make clean PROJECT_ID="${YOUR_GCP_PROJECT_ID})"
```
