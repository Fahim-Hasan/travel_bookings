{{ config(tags=['core']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_booking_activity__ticket_passengers') }}

),

formatted_data AS (

    SELECT
        DISTINCT
            {{ dbt_utils.generate_surrogate_key(['ticket_id']) }}AS ticket_sk,  -- Surrogate key for the ticket
            ticket_id,
            passenger_id,
           {{ dbt_utils.generate_surrogate_key(['passenger_id']) }} AS passenger_sk -- Surrogate key for the passenger

    FROM source
)

SELECT * FROM formatted_data