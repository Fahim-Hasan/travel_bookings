# Project Overview
This project is written in dbt-core and mainly focused on transformation pipeline. Naming conventions of this project is followed from dbt best practices. The how tos are defined in the README.md file in the project root folder. Please follow through to run. Here, we will discuss the overall structure of this transformation project. How the folders are structured and where to find what.

# Project Structure
Here, the project is structured following basic structure of a dbt project. The overall project looks something like this-
```
bookings_analytics/
│
├── analyses/                           # This folder is used for auditing purpose
├── docs/                               # Contains all the documentations and question-answers
├── macros/                             # The macro or functions that dbt uses. Here only custom test macros are added
│   └── tests/                          # Custom test macros to check business logic validity in the core data marts
│       ├── test_booking_has_passengers.sql
│       ├── test_booking_has_segments.sql
│       ├── test_booking_has_tickets.sql
│       └── test_volume_spike.sql
│
├── models/                             # Here we have all the data models to build our star schema
│   ├── intermediate/                   # Mid layer of the transformation pipeline
│   │   └── core/
│   │       ├── _int_core__models.yml
│   │       └── int_ticket_counts.sql
│   │
│   ├── marts/                          # Final layer of the transformation pipeline
│   │   ├── core/
│   │   │   ├── bridges/
│   │   │   │   ├── _br_core__models.yml
│   │   │   │   ├── br_ticket_passengers.sql
│   │   │   │   └── br_ticket_segments.sql
│   │   │   │
│   │   │   ├── dimensions/
│   │   │   │   ├── _dim_core__models.yml
│   │   │   │   ├── dim_bookings.sql
│   │   │   │   ├── dim_passengers.sql
│   │   │   │   └── dim_segments.sql
│   │   │   │
│   │   │   ├── facts/
│   │   │   │   ├── _fct_core__models.yml
│   │   │   │   └── fct_ticket_sales.sql
│   │   │
│   │   └── reports/
│   │       └── rep_booking_summary.sql
│   │
│   └── staging/                            # first layer of the transformation pipeline
│       └── booking_activity/
│           ├── _stg_booking_activity__sources.yml
│           ├── _stg_booking_activity__models.yml
│           ├── stg_booking_activity__bookings.sql
│           ├── stg_booking_activity__passengers.sql
│           ├── stg_booking_activity__segments.sql
│           ├── stg_booking_activity__tickets.sql
│           ├── stg_booking_activity__ticket_passengers.sql
│           └── stg_booking_activity__ticket_segments.sql
│
├── seeds/                                  # Sythetic source data, generated for demonstration
│   └── booking_analytics/
│       ├── booking.csv
│       ├── passenger.csv
│       ├── segment.csv
│       ├── ticket.csv
│       ├── ticketPassenger.csv
│       └── ticketSegment.csv
│
├── snapshots/                              # All the snapshot models are defined to track SCD2 type data models
│   ├── booking_snapshot.sql
│   └── booking_snapshot.yml
│
├── tests/                                  # dbt tests folder. In our case empty,all the tests are defined in _models.yml 
├── .gitignore
├── dbt_project.yml                         # Project level configuration. Check the schema naming and materialization here
├── packages.yml
└── package-lock.yml

```

The models are layered following dbt best practices. 

 ```staging``` All the sources are defined here. Each model represts one to one mapping of the sources. We perform simple transformation like renaming columns, data_type change etc in these models. The tests for these models are defined in ```_stg_booking_activity__models.yml``` file. The sources are defined here ```_stg_booking_activity__sources```. Data contracts and source level data checks are declared here, so that we enter expected data in our system. This helps us to detect errors at the begining. 

```intermediate``` This folder comes into the middle in our transformation pipeline. This layer has models which handles heavy business logic transformations, joins etc. In our case, we kept our intermediate model under the ```core``` folder because it will be used to build core data model in marts layer. The tests are written in ```_int_core__models.yml``` file, only for the transformed columns as the other columns are already tested at source.

```marts```  Here, we have our final model or star schema. It has dimensions, facts and bridges folder containing respective models of our star schema. The yml files are written for tests and descriptions of the columns.

There are some other folders that is needed to be mentioned. 

```snapshots``` Used to build out SCD type 2 model, ```dim_bookings```. To track historical implementations as well, we will be using these models.

```macros``` In this folder, we are defining some macros but for our case it only limited to custom business logic tests. These macros are called in marts yml files respect to the final models.

#### This is the overall project structure. To see the configuration of the project, please check ```dbt_project.yml``` file. 
