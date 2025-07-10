### BOOKING_ANALYTICS
This is our transformation project. This is a dbt-core project tagged with postgres adapter. Once you installed and run the steps declared [here](/README.md), you will be able to run this project.

### How to run
Here, the following steps will help you to run and materialize the entire pipeline in your local postgres database. 
- step 1- In your terminal, enter the project folder. In your terminal Run ```cd booking_analytics```
- step 2- Once you are inside, run ```dbt debug```, if you see error, please allign your profile and database connection accordingly.
- step 3- After checking the connection, install dependancies- run ```dbt deps```
- step 4- Now you are ready to run your pipeline. In the seed folder, we have syntheric csv files as described in the description of raw data. To load the source- run ```dbt seed```
- step 5- To run the staging models- run ```dbt run --select tag:staging``` This is crucial as it is our first step of our pipeline.
- step 6- Now, we need to also run ```dbt snapshot``` as we have a snapshot model.
- step 6- To run the rest of the models- run ```dbt run --select tag:core``` This will materialize the models and you can find the respective models according to ```dbt_project.yml```

Now you have all your models materialized in your database. There are some other operations which are important for our project,

for testing source, run ```dbt test --select source:booking_activity```

for testing rest of the pipeline, run ```dbt test```

for generating docs, run ```dbt docs generate && dbt docs serve```

These are some important commands to run this project. The detailed documentation about this project and answers of the question is provided under the [docs](docs/) folder, so that all of the documentations are placed in one folder. The model and column level documentations are provided in ```__models.yml``` files.

To understand the project and thought process, Please check [project_overview.md](/bookings_analytics/docs/project_overview.md)

To understand, data modeling technique and strategy, Please check [data_modeling_overview.md](/bookings_analytics/docs/data_modeling_overview.md)

To check data quality coverage and framework, Please check [data_quality_overview.md](/bookings_analytics/docs/data_quality_overview.md)

To get answers for provided questions, Please check [deliverables.md](/bookings_analytics/docs/project_overview.md)

#### Please follow the docs for detailed understanding of the project and find the answers of the provided questions.
