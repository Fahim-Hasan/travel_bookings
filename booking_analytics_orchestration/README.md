# BOOKING_ANALYTICS_ORCHESTRATION
This is a demo project for orchestrating our dbt data pipeline with the help of Apache Airflow and Slack Notification.
The codes are generated as mock, not fit for production. The idea is to showcase the way of how we can achieve that. For production deployment, we need different setup using tools such docker, Kubernetes cluster. Considering this out of the scope, we will only focus on how the pipeline execution may look like.

# Project Overview
This project mainly consists of two modules - dags and scripts(Utilities and Slack Notification)

***-- dags --***

dags folder is the main location where we declare our pipeline. For running dbt pipelines, we have ```booking_analytics_pipeline.py```, a python script to manage Airflow dags. To visualise, how we are running our pipeline steps, here is a high level flow 

```dbt_seed >> dbt_source_freshness >> dbt_test_source >> dbt_run_staging >> dbt_snapshot >> dbt_run_core >> dbt_test_all >> dbt_generate_docs```

Here, we do not have any parallel steps as per our use case. These are the steps which are executed by our Airflow Dag.
Let's interpret the steps- 

1. dbt_seed: Seeds the database with initial data.
2. dbt_source_freshness: Checks the source freshness first to check if the upstream data is available.
3. dbt_test_source: Tests the source data to ensure it meets expectations.
4. dbt_run_staging: Runs the staging models tagged with 'staging'.
5. dbt_snapshot: Takes snapshots of the data. (Currently only for booking data)
6. dbt_run_core: Runs the core models tagged with 'core'.
7. dbt_test_all: Runs all tests to ensure data integrity across the pipeline.
8. dbt_generate_docs: Generates the updated docs everytime after pipeline run.
The reason behind this approach is to modarate each of the steps and collect meta data.

As we are using synthetic data for the demo, seed is used to load the initial data. Then validation comes into play.
Once upon the successful validation, the staging models are run to prepare the data for core models.

In a hypothetical scenario, if we do not want to load the seed data or want to get rid of any steps, we can simple do it in Airflow.
It enables us to gain speed for hot fixes in the production environment without the need to change the dbt project.

Detailed documentation can be found in the script

***-- scripts --***
In this folder, we will be adding all the helper scripts like notification, loging etc. For now only the ```slack_notify.py``` is added to showcase how Airflow will be sending notifications in Slack.

