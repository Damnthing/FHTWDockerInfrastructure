CREATE FUNCTION get_version()
RETURNS INTEGER
AS $$
    SELECT 1;
$$ LANGUAGE SQL
 