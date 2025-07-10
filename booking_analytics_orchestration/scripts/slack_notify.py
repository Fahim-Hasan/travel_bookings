""" This demo script is used to send notifications to a Slack channel when an Airflow task fails.
The core point to add this script is to show how it the Airflow will trigger a notification on task failure.
The directory structure also gives us an idea of how to organize the scripts in a modular way.
"""
from airflow.hooks.base import BaseHook
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

def notify_slack(context):
    slack_conn_id = 'slack_conn' 
    slack_token = BaseHook.get_connection(slack_conn_id).password 
    client = WebClient(token=slack_token) # Declared connection token in Airflow

    dag_id = context.get('dag').dag_id
    task_id = context.get('task_instance').task_id
    execution_date = context.get('execution_date')
    log_url = context.get('task_instance').log_url

    message = f"""
                :rotating_light: *Airflow Alert*
                *DAG*: {dag_id}
                *Task*: {task_id}
                *Execution Time*: {execution_date}
                *Log URL*: {log_url}"""

    try:
        # Trying to send the message
        client.chat_postMessage(channel='#airflow-alerts', text=message)
    except SlackApiError as e:
        # On failure, printing error message. Airflow or Python logs could be used here instead of printing.
        print(f"Slack API error: {e.response['error']}")
