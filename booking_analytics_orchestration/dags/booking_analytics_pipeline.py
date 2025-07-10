""" This is a demo DAG for a modular dbt booking_analytics pipeline using Airflow.
Though this reflects actual airflow code but is not a real DAG and not production ready.
This DAG is written to demonstrate how the pipeline run can be structured in Airflow.
"""
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago
from airflow.utils.trigger_rule import TriggerRule
from datetime import timedelta
from scripts.slack_notify import notify_slack

default_args = {
    'owner': 'data_team', # Usually owner of the data pipelines
    'depends_on_past': False, 
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
    'on_failure_callback': notify_slack # Here, we are telling our dag to raise flag in case of pipeline failure.
}
# Here is the DAG definition which runs everyday at UTC 2 AM
with DAG(
    dag_id='dbt_travel_pipeline',
    description='Modular dbt pipeline execution,
    default_args=default_args,
    schedule_interval='0 2 * * *',  # Daily at 2 AM UTC
    start_date=days_ago(1),
    catchup=False,
    tags=['dbt', 'travel', 'pipeline']
) as dag:

""" 
Populating Seed files as we are working with synthetic data. 
In real world, we may already have loaded raw data in our data warehouse by another project or pipeline
"""
    dbt_seed = BashOperator(
        task_id='dbt_seed',
        bash_command='cd /path/to/dbt/project && dbt seed --profiles-dir .',
    )
""" 
In this step, we are making sure, if we have fresh data, if not we do not run the following step
"""
    dbt_source_freshness = BashOperator(
        task_id='dbt_source_freshness',
        bash_command='cd /path/to/dbt/project && dbt source freshness --profiles-dir .',
    )
""" 
After getting the fresh data, we want to test the raw data and check our data contracts. 
On failure, it will trigger slack notification and stop executing the rest of the pipeline.
"""
    dbt_test_source = BashOperator(
        task_id='dbt_test_source',
        bash_command='cd /path/to/dbt/project && dbt test --select source:booking_activity --profiles-dir .',
    )
""" 
As we are modularising our pipeline based on tags, to run the staging layer, we will be running the following step.
"""
    dbt_run_staging = BashOperator(
        task_id='dbt_run_staging',
        bash_command='cd /path/to/dbt/project && dbt run --select tag:staging --profiles-dir .',
    )
""" 
This step ensures, we materialize our snapshot models. As we have snapshot model now, we are using this step.
Initially, the snapshot model was under the core tag, but considering best practices, seperate step is considered.
"""    
    dbt_snapshot = BashOperator(
        task_id='dbt_snapshot',
        bash_command='cd /path/to/dbt/project && dbt snapshot --profiles-dir .',
    )
""" 
This step populates the core data models, will be used to create BI reporting
"""
    dbt_run_core = BashOperator(
        task_id='dbt_run_core',
        bash_command='cd /path/to/dbt/project && dbt run --select tag:core --profiles-dir .',
    )
""" 
As we are testing our sources before, we are populating our warehouse with clean data. 
This step is mostly to test our own written transformation logics.
We are not using dbt build because considering the fact that, the data will be available at the very first place for daily use cases but we will know if we have bugs.
It will help us to align stakeholders before hand rather than stoping from consuming other processess.
"""
    dbt_test_all = BashOperator(
        task_id='dbt_test_all',
        bash_command='cd /path/to/dbt/project && dbt test --profiles-dir .',
    )
""" 
Once, everything is passes, we will generate fresh docs everytime, so that the stakeholders can get up to date documentation.
The documentation serve is not indluded here but it can be a potential step to add in future
"""

    dbt_generate_docs = BashOperator(
        task_id='dbt_generate_docs',
        bash_command='cd /path/to/dbt/project && dbt docs generate --profiles-dir .',
    )
    # Dependencies
    dbt_seed >> dbt_source_freshness >> dbt_test_source >> dbt_run_staging >> dbt_snapshot >> dbt_run_core >> dbt_test_all >> dbt_generate_docs
