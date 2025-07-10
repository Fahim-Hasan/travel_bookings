{{ config(tags=['staging']) }}

WITH raw_data AS (

    SELECT * FROM {{ source('booking_activity', 'ticketPassenger') }}

),

formatted_data AS (

    SELECT
    
        CAST(ticketId AS VARCHAR) AS ticket_id,
        CAST(passengerId AS VARCHAR) AS passenger_id

    FROM raw_data
)

SELECT * FROM formatted_data