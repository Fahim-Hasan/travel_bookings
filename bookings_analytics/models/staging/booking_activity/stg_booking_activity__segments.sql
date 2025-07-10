{{ config(tags=['staging']) }}

WITH raw_data AS (

    SELECT * FROM {{ source('booking_activity', 'segment') }}

),

formatted_data AS (

    SELECT

        CAST(segmentid AS VARCHAR) AS segment_id,
        CAST(bookingid AS VARCHAR) AS booking_id,

        UPPER(CAST(carriername AS VARCHAR)) AS carrier_name,
        UPPER(CAST(travelmode AS VARCHAR)) AS travel_mode,

        CAST(departuredatetime AS TIMESTAMP) AS departure_at,
        CAST(arrivaldatetime AS TIMESTAMP) AS arrival_at,
        
        CAST(departuredatetime::DATE AS DATE) AS departure_date,
        CAST(arrivaldatetime::DATE AS DATE) AS arrival_date


    FROM raw_data
)

SELECT * FROM formatted_data