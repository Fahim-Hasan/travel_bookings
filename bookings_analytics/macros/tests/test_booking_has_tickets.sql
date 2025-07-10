{% test booking_has_tickets(model, booking_id_column) %}

SELECT {{ booking_id_column }}
FROM {{ model }}
WHERE {{ booking_id_column }} NOT IN (
    SELECT
        DISTINCT
            dm.booking_id
    FROM {{ ref('dim_bookings')}} dm LEFT JOIN {{ ref('fct_ticket_sales')}} fts
    ON dm.booking_sk = fts.booking_sk
    WHERE fts.ticket_id IS NULL
)

{% endtest %}

