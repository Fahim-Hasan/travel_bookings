{{ config(tags=['staging']) }}

WITH raw_data AS (

    SELECT * FROM {{ source('booking_activity', 'passenger') }}

),

formatted_data AS (

    SELECT

        CAST(passengerId AS VARCHAR) AS passenger_id,
        CAST(bookingid AS VARCHAR) AS booking_id,

        UPPER(CAST(type AS VARCHAR)) AS passenger_type

    FROM raw_data
)

SELECT * FROM formatted_data