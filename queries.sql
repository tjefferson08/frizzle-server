-- Get all stops associated with a route
SELECT DISTINCT stops.stop_id, stops.stop_name
  FROM trips
  INNER JOIN stop_times ON stop_times.trip_id = trips.trip_id
  INNER JOIN stops ON stops.stop_id = stop_times.stop_id
  WHERE route_id = 1;

-- Get all routes associated with a stop
SELECT DISTINCT r.route_short_name
    FROM stop_times st
    INNER JOIN trips t ON t.trip_id = st.trip_id
    INNER JOIN routes r ON r.route_id = t.route_id
    WHERE st.stop_id = 2613;

-- Get stops near lat/lon
SELECT
    s.stop_id,
    s.stop_name,
    ST_Distance(
        ST_GeomFromText('POINT(30.287189400000003 -97.7225488)',4326),
        s.location
    ) AS dist
FROM stops s
ORDER BY dist ASC;

-- combining nearby stops and each stop's routes
SELECT st.stop_id, array_agg(DISTINCT r.route_short_name)
    FROM stop_times st
    INNER JOIN trips t ON t.trip_id = st.trip_id
    INNER JOIN routes r ON r.route_id = t.route_id
    WHERE st.stop_id IN (
        SELECT s.stop_id
        FROM stops s
        ORDER BY ST_Distance(
            ST_GeomFromText('POINT(30.287189400000003 -97.7225488)',4326),
            s.location
        ) ASC
        LIMIT 20
    )
    GROUP BY st.stop_id
