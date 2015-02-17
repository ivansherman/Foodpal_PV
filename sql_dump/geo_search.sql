DELIMITER ;;

DROP FUNCTION IF EXISTS `geo_distance`;;
CREATE FUNCTION `geo_distance`(in_lat decimal(10,7), in_lon decimal(10,7), latitude decimal(10,7), longitude decimal(10,7)) RETURNS decimal(10,3)
    DETERMINISTIC
return ((ACOS(SIN(in_lat * PI() / 180) * SIN(latitude * PI() / 180) + COS(in_lat * PI() / 180) * COS(latitude * PI() / 180) * COS((in_lon - longitude) * PI() / 180)) * 180 / PI()) * 60 * 1.1515);;

DELIMITER ;