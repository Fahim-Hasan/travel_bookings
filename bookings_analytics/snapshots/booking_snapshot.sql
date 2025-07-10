WITH source AS (

    SELECT * FROM {{ ref('stg_booking_activity__bookings') }}

),
 
final AS (

    SELECT

        booking_id,
        partner_id_offer,
        user_selected_currency,

        booked_at,
        updated_at,

        booking_date,
        updated_date

    FROM source

)

SELECT * FROM final
