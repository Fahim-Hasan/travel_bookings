{{ config(tags=['staging']) }}

WITH raw_data AS (

    SELECT * FROM {{ source('booking_activity', 'booking') }}

),

formatted_data AS (

    SELECT

        CAST(bookingid AS VARCHAR) AS booking_id,
        CAST(partnerIdOffer AS VARCHAR) AS partner_id_offer,

        UPPER(CAST(userSelectedCurrency AS VARCHAR)) AS user_selected_currency,        

        CAST(createdAt AS TIMESTAMP) AS booked_at,
        CAST(updatedAt AS TIMESTAMP) AS updated_at,

        CAST(createdAt::DATE AS DATE) AS booking_date,
        CAST(updatedAt::DATE AS DATE) AS updated_date

    FROM raw_data
)

SELECT * FROM formatted_data
