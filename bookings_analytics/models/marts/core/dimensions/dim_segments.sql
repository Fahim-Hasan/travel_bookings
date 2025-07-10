{{ config(tags=['core']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_booking_activity__segments') }}

),

formatted_data AS (

    SELECT
        DISTINCT
            {{dbt_utils.generate_surrogate_key(['segment_id'])}} AS segment_sk, -- Surrogate key for the segment
            segment_id,
            carrier_name,
            travel_mode,
            departure_at,
            arrival_at,
            departure_date,
            arrival_date

    FROM source

)

SELECT * FROM formatted_data