{{ config(tags=['core']) }}

WITH source_ticket_passengers AS (
    SELECT * FROM {{ ref('stg_booking_activity__ticket_passengers') }}
),
source_ticket_segments AS (
    SELECT * FROM {{ ref('stg_booking_activity__ticket_segments') }}
),

count_ticket_passengers AS (
    SELECT
        ticket_id,
        COUNT(passenger_id) AS passenger_count
    FROM source_ticket_passengers
    GROUP BY ticket_id
),

count_ticket_segments AS (
    SELECT
        ticket_id,
        COUNT(segment_id) AS segment_count
    FROM source_ticket_segments
    GROUP BY ticket_id
),

joined_data AS (
    SELECT
        tp.ticket_id,
        COALESCE(tp.passenger_count, 0) AS passenger_count,
        COALESCE(ts.segment_count, 0) AS segment_count
    FROM count_ticket_passengers tp
    LEFT JOIN count_ticket_segments ts 
    ON tp.ticket_id = ts.ticket_id
),

formatted_data AS (
    SELECT
        ticket_id,
        passenger_count,
        segment_count
    FROM joined_data
)

SELECT * FROM formatted_data
