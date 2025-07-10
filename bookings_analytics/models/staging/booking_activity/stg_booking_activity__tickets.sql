{{ config(tags=['staging']) }}

WITH raw_data AS (

    SELECT * FROM {{ source('booking_activity', 'ticket') }}

),

formatted_data AS (

    SELECT

        CAST(ticketid AS VARCHAR) AS ticket_id,
        CAST(bookingid AS VARCHAR) AS booking_id,

        ROUND(CAST(bookingPrice AS NUMERIC),2) AS booking_price,
        UPPER(CAST(bookingCurrency AS VARCHAR)) AS booking_currency,
        CAST(vendorCode AS VARCHAR) AS vendor_code

    FROM raw_data
)

SELECT * FROM formatted_data