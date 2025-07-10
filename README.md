# TRAVEL_BOOKINGS
This is a project to define booking_analytics data model and pipeline orchestration. Every day, the Booking Team delivers an export of booking activity. The file is nested and complex, like a semi-structured JSON, but we need
to turn it into well-modeled, tested, and trustworthy data marts. So this project is divided into two segments, one orchestration and another is transformation. This Readme contains a very high level documentation of the solution. The detailed solutions are inside of the each folders.

# Project Overview
As mentioned before, we have two segments, orchestration and transformation. The core idea is to seperate these two concern from the very begining so that it ease the development process and concerns. The root directory has two folders

***-- booking_analytics_orchestration --***
This segment or project is mostly dedicated to orchestrating our data pipelines. Here we are focused to construct dags and some custom scripts for the alert system. This is a hypothetical or implementation of **Apache Airflow** orchestrator tool including **Slack** alerts. The core purpose of these model is not to build production grade code rather that showcasing how this connects to our transformation workload and how it will react in real-life scenario. 

Inside the **booking_analytics_orchestration**, we have currently two folders, one for dags and scripts for custom scripts like slack_notify. We are using python for scripting and writing dags.

***-- booking_analytics --***
This segment is our main transformation project. We have defined whole transformation workload in this project using dbt-core. The folders inside booking_analytics follows dbt best practices defined inside of the project. To navigate through the project, you will find README.md file inside fo the project. The rest is discussed there.

***-- requirements.txt --***
This file contains all the dependancies of setting up this project.

***-- .gitignore --***
This file contains the extra files that we do not want to commit in our remote repository.

# Tools
As we have two seperate concern for this project, industry standard tools are used to create, manage and test the data pipelines. 

***-- Orchestration --***

For orchestration, **Python** and **Apache Airflow** is being used. Because of rich ecosystem and compatibility with our dbt tranformation project

***-- Transformation --***

For tranformation, **dbt-core** is used with **dbt postgres adapter**. To develop locally with sythetic data, postgres is chosen for ease and flexibility purpose. The local postgres and dbt-core setup is easily replicable in local environment and scalable.

# Installation & Setup

To install this project, we have to run the following steps

- Step 1- Clone the project, [here](https://github.com/Fahim-Hasan/travel_bookings.git)
- Step 2- After cloning the project, we need make python environment ```python3 -m venv venv```
- Step 3- Now, activate the environment ```source venv/bin/activate```
- Step 4- After the activation, we need to install requirements.txt file, in your terminal run - ```pip install -r requirements.txt```. This will install all the dependancies in your virtual envinroment.
- Step 5- Now, we need to setup POSTGRE SQL server locally. To download and and installation follow the steps from [here](https://www.postgresql.org/download/) 
- Step 6- Once the installation is complete, create your ```profile.yml``` in ```.dbt``` file according to your local postgres setup. Follow this page to create [profiles.yml](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)
- Step 7- Please create database assets locally with ```psql``` or [pgadmin](https://www.pgadmin.org/) similar to ```profile.yml```
- Step 8- Now, to run the pipelines locally we can find the documentation in README.md file inside ```bookings_analytics```

#### PS- For detailed documentation on each project, please follow each project folder's README.md files

- For [booking_analytics_orchestration](booking_analytics_orchestration/README.md)

- For [booking_analytics](bookings_analytics/README.md)

