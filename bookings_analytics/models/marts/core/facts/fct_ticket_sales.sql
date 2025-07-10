{{ config(
    materialized='incremental',
    unique_key='ticket_sk',
    on_schema_change='sync_all_columns',
    tags=['core']
) }}

WITH source_tickets AS (
    SELECT * FROM {{ ref('stg_booking_activity__tickets') }}
),

source_ticket_counts AS (
    SELECT * FROM {{ ref('int_ticket_counts') }}
),

source_booking AS (
    SELECT
        DISTINCT
        booking_id,
        booked_at
    FROM {{ ref('booking_snapshot') }}
),

joined_ticket_info AS (
    SELECT
        t.ticket_id,
        t.booking_id,
        t.booking_price,
        t.booking_currency,
        t.vendor_code,
        COALESCE(tc.passenger_count, 0) AS passenger_count,
        COALESCE(tc.segment_count, 0) AS segment_count
    FROM source_tickets t
    LEFT JOIN source_ticket_counts tc 
    ON t.ticket_id = tc.ticket_id
),

joined_ticket_booking_date AS (
    SELECT
        t.ticket_id,
        t.booking_id,
        t.booking_price,
        t.booking_currency,
        t.vendor_code,
        t.passenger_count,
        t.segment_count,
        b.booked_at::DATE as ticket_purchased_date,
        b.booked_at as ticket_purchased_at
    -- Join ticket information with booking date
    FROM joined_ticket_info t
    LEFT JOIN source_booking b
    ON t.booking_id = b.booking_id

),

formatted_data AS (
    SELECT
        ticket_id,
        {{dbt_utils.generate_surrogate_key(['ticket_id'])}}as ticket_sk, -- Surrogate key for the ticket to keep business key integrity
        {{dbt_utils.generate_surrogate_key(['booking_id'])}} as booking_sk, -- Surrogate key for the booking to keep business key integrity
        booking_price,
        booking_currency,
        vendor_code,
        passenger_count,
        segment_count,
        ticket_purchased_at,
        ticket_purchased_date
    FROM joined_ticket_booking_date

 
)

SELECT * FROM formatted_data
