# Data Quality Overview
This doc describes the measures that has been taken in this project to ensure data quality and observibility which will be reflected in production environment.

# Enforcement
To enforce quality check, this project is highly dependant on dbt. dbt packages and custom macros has been used to ensure data quality. But behind the scene, Great Expectation frameworks has been established including some custom pointers at the core. 

# Strategy
To ensure the highest data quality, we focused on some core pointers like-
- Data exists
- Data is correct
- Data is consistent
- Data is fresh
- Data is complete

Here, we check all these factors at the very source so that we do not put any garbeg data into our system. So anything is entering, it is clean from the begining. Now the rest of the transformations has tests for each of the new column. DRY principle is followed so that we do not repeat tests unnessesarily. 

To wrap these pointer, Great Expectation is used not as a tool but as a framework. For testing tool, dbt_utils and dbt_expectations are used.

How GE concept is relevant? 

- This project has defined contracts at source (Expectations)
- Validation process is implemented via dbt utils and expectation tests. (Validation)
- Documentation is written in YML files. (Data Docs)

Checkpoint and profiling is not covered here. Though this is a very high level of alignment with GE framework but it gives us a structure on how we can ensure our data quality.

# Trust the numbers
To ensure trust among the stakeholders, sharing numbers is the key. To get test coverage report, we can use tools such [Elementary](https://www.elementary-data.com/). Though it is not hooked in this project but we can consider this in future.

# Monitoring and Alerts
After all the precautions, our data pipeline still can fail. To address this as quickly as possible, there is notification alert established with [orchestration](/booking_analytics_orchestration/scripts/slack_notify.py).

For monitoring, we can also use Elementary kind of tools.


