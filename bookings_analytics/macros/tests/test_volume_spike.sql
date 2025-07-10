{% test volume_spike(model, date_column, window_days, threshold_multiplier) %}
-- Flags if today's count > threshold_multiplier * previous rolling average over window_days

{% set max_date_query %}
    SELECT MAX({{ date_column }}) FROM {{ model }}
{% endset %}

{% if execute %}
    {% set results = run_query(max_date_query) %}
    {% set max_date = results.columns[0].values()[0] %}
{% else %}
    {% set max_date = '2020-01-01' %}  -- fallback during parse
{% endif %}

WITH date_counts AS (
    SELECT
        {{ date_column }}::date AS date,
        COUNT(*) AS record_count
    FROM {{ model }}
    GROUP BY 1
),

current_day_count AS (
    SELECT record_count
    FROM date_counts
    WHERE date = '{{ max_date }}'
),

previous_avg AS (
    SELECT AVG(record_count) AS avg_count
    FROM date_counts
    WHERE date BETWEEN (DATE('{{ max_date }}') - INTERVAL '{{ window_days }} days')
                  AND (DATE('{{ max_date }}'))
)

SELECT
    cd.record_count,
    pa.avg_count,
    {{ threshold_multiplier }} * pa.avg_count AS threshold
FROM current_day_count cd, previous_avg pa
WHERE cd.record_count > {{ threshold_multiplier }} * pa.avg_count

{% endtest %}
