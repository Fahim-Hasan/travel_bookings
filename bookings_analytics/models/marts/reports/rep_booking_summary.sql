WITH source AS (
    SELECT
        ticket_purchased_date,
        booking_price,
        ticket_sk,
        booking_sk,
        passenger_count,
        segment_count
    FROM {{ ref('fct_ticket_sales') }} f

),

aggregation AS (

    SELECT
        ticket_purchased_date AS date,
        COUNT(DISTINCT ticket_sk) AS total_tickets_sold,
        COUNT(DISTINCT booking_sk) AS total_unique_bookings,
        SUM(passenger_count) AS total_passengers,
        SUM(segment_count) AS total_segments,
        SUM(booking_price) AS total_revenue,
        round(AVG(booking_price),2) AS average_ticket_price

    FROM source
    GROUP BY 1

),

final AS (
    SELECT
        date,
        total_tickets_sold,
        total_unique_bookings,
        total_passengers,
        total_segments,
        total_revenue,
        average_ticket_price
    FROM aggregation
)

SELECT * FROM final
