{{ config(tags=['core']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_booking_activity__passengers') }}

),

formatted_data AS (

    SELECT
        DISTINCT
            {{dbt_utils.generate_surrogate_key(['passenger_id'])}} AS passenger_sk, -- Surrogate key for the passenger
            passenger_id,
            passenger_type

    FROM source

)

SELECT * FROM formatted_data