{% test booking_has_passengers(model, booking_id_column) %}

SELECT {{ booking_id_column }}
FROM {{ model }}
WHERE {{ booking_id_column }} NOT IN (
    SELECT
        DISTINCT
            fts.booking_sk
    FROM {{ ref('fct_ticket_sales')}} fts
    WHERE fts.passenger_count = 0
)

{% endtest %}


