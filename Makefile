setup:
	pip install -r requirements.txt

run: run-dbt run-terraform

run-dbt: check-project-id
	export PROJECT_ID=$(PROJECT_ID)
	dbt run --profiles-dir profiles/

run-terraform: check-project-id
	cd terraform \
		&& terraform init \
		&& terraform apply -auto-approve -var "project_id=$(PROJECT_ID)"

clean: clean-terraform clean-bigquery

clean-bigquery: check-project-id
	bq rm -f -r $(PROJECT_ID):test_protected
	bq rm -f -r $(PROJECT_ID):test_shared

clean-terraform: check-project-id
	cd terraform \
		&& terraform destroy -auto-approve -v "project_id=$(PROJECT_ID)"

show-bigquery-info:
	bq show --format=prettyjson $(PROJECT_ID):test_protected

check-project-id:
ifndef PROJECT_ID
	$(error PROJECT_ID is undefined)
endif
