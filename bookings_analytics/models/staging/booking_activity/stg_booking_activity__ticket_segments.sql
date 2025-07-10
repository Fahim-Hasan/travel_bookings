{{ config(tags=['staging']) }}

WITH raw_data AS (

    SELECT * FROM {{ source('booking_activity', 'ticketSegment') }}

),

formatted_data AS (

    SELECT
        CAST(ticketId AS VARCHAR) AS ticket_id,    
        CAST(segmentid AS VARCHAR) AS segment_id


    FROM raw_data
)

SELECT * FROM formatted_data