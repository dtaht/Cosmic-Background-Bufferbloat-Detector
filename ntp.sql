-- NOTE: THIS IS NOT EVEN CLOSE TO WORKING CODE
-- I'm still digging myself out of the morass of 
-- different data types, all different.

-- constants - speed of light - speed of light in fiber

-- watch out for this not working well in odbc

-- postgres timestamps are not very precise
-- and worse, can vary in resolution between versions 
-- that use floats and ints
-- resolution also varies over time.

-- and start in another epoch than ntp

-- timestamp [ (p) ] [ without time zone ]	
-- 8 bytes	both date and time	
-- 4713 BC	5874897 AD	1 microsecond / 14 digits

-- so we will create a conversion routine
-- between the two and keep the precise measure
-- in the database

-- and we either need an unsigned integer type
-- to promote int4 to int8 seems inelegant
-- perhaps we can do this this way, and
-- then make sure we're careful about data entry

create type uint (a int8);

create type ntp_timestamp as (seconds uint, frac uint);

-- also doing reports on intervals is no fun
-- so we will also extract that info on the
-- way in, rather the way out.

-- calc RTT statically?
-- 

create table ntp_packet (
       src inet,
       dst inet,
       src_port short,
       dst_port short,
       reference ntp_timestamp,
       originate ntp_timestamp,
       receive ntp_timestamp,
       transmit ntp_timestamp,             
       t_reference timestamp,
       t_originate timestamp,
       t_receive timestamp,
       t_transmit timestamp,

       key_identifier int,
       md 
}

create trigger on ntp_packet when reference, originate, receive, transmit are modified

-- Use postgis geography mapper

-- Distance calculation using GEOGRAPHY (122.2km)
  SELECT ST_Distance('LINESTRING(-122.33 47.606, 0.0 51.5)'::geography, 'POINT(-21.96 64.15)':: geography);
INSERT INTO global_points (name, location) VALUES ('Town', ST_GeographyFromText('SRID=4326;POINT(-110 30)') );

-- http://www.postgis.org/documentation/manual-1.5/

-- 

create table hosts(
       inet src,
       location GEOGRAPHY(POINTZ,4326),
       latlong point,
       varchar op,

);

