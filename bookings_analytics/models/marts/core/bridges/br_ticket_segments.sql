{{ config(tags=['core']) }}

WITH source AS (

    SELECT * FROM {{ ref('stg_booking_activity__ticket_segments') }}

),

formatted_data AS (

    SELECT
        DISTINCT
            ticket_id,
            {{dbt_utils.generate_surrogate_key(['ticket_id'])}} AS ticket_sk, -- Surrogate key for the ticket
            segment_id,
            {{dbt_utils.generate_surrogate_key(['segment_id'])}} AS segment_sk -- Surrogate key for the segment

    FROM source
)

SELECT * FROM formatted_data