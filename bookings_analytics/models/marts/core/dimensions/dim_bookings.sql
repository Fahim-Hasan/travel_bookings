{{ config(tags=['core']) }}

WITH source AS (

    SELECT * 
    FROM {{ ref('booking_snapshot') }}
    WHERE dbt_valid_to IS NULL

),

formatted_data AS (

    SELECT
        {{dbt_utils.generate_surrogate_key(['booking_id'])}} AS booking_sk, -- Surrogate key for the booking to keep business key integrity
        booking_id,
        
        partner_id_offer,
        user_selected_currency,

        booked_at,
        updated_at,

        booking_date,
        updated_date,

        CAST(dbt_valid_from::DATE AS DATE) AS valid_from,
        TO_DATE('9999-12-31','YYYY-MM-DD') AS valid_to -- Hardcoded end date for current records to avoid NULLs and confusion

    FROM source

)

SELECT * FROM formatted_data