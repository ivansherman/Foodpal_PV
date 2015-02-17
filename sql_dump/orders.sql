/*
Navicat MySQL Data Transfer

Source Server         : home
Source Server Version : 50528
Source Host           : localhost:3306
Source Database       : foodpal_development

Target Server Type    : MYSQL
Target Server Version : 50528
File Encoding         : 65001

Date: 2014-02-06 23:24:01
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `totalprice` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delivery_type` tinyint(1) DEFAULT NULL,
  `payment_method` tinyint(1) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `instructions` text COLLATE utf8_unicode_ci,
  `napkins` tinyint(1) DEFAULT NULL,
  `condiments` tinyint(1) DEFAULT NULL,
  `delivery_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delivery_time` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `transaction_id` int(11) DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `status_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_orders_on_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES ('1', '1', null, '1', '1', '2014-01-21 09:50:34', '2014-01-21 09:50:34', '555 5555', '', '0', '1', 'As Soon As Possible', '12:00:00', null, null, null, null);
INSERT INTO `orders` VALUES ('2', '1', null, '1', '1', '2014-01-21 10:18:36', '2014-01-21 10:18:36', '555 5555', '', '0', '0', 'As Soon As Possible', '12:00:00', null, null, null, null);
INSERT INTO `orders` VALUES ('3', '1', null, '1', '1', '2014-01-21 10:20:34', '2014-01-21 10:20:34', '555 5555', '', '0', '0', 'As Soon As Possible', '12:00:00', null, null, null, null);
INSERT INTO `orders` VALUES ('4', '3', null, '1', '1', '2014-01-21 10:41:55', '2014-01-21 10:41:55', '555 5555', '', '0', '0', 'As Soon As Possible', '12:00:00', null, null, null, '3');
INSERT INTO `orders` VALUES ('5', '1', null, '1', '1', '2014-01-28 11:22:07', '2014-01-28 11:22:07', '555 5555', '', '1', '1', 'As Soon As Possible', '12:00:00', null, null, null, null);
INSERT INTO `orders` VALUES ('6', '3', null, '1', '1', '2014-01-28 16:52:20', '2014-01-28 16:52:20', '', '', '0', '0', 'As Soon As Possible', '12:00:00', null, null, null, '2');
INSERT INTO `orders` VALUES ('7', '3', null, '1', '1', '2014-01-29 12:23:30', '2014-01-29 12:23:30', '555 5555', '', '0', '1', 'As Soon As Possible', '12:00:00', null, null, null, '1');
INSERT INTO `orders` VALUES ('8', '1', null, '1', '1', '2014-01-29 12:24:53', '2014-01-29 12:24:53', '555 5555', '', '0', '0', 'As Soon As Possible', '12:00:00', null, null, null, null);
INSERT INTO `orders` VALUES ('9', '3', '300.0', '1', '1', '2014-02-06 12:14:03', '2014-02-06 12:14:03', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('10', '3', '125.0', '1', '1', '2014-02-06 13:09:04', '2014-02-06 13:09:04', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('11', '3', '0', '1', '1', '2014-02-06 13:09:31', '2014-02-06 13:09:31', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('12', '3', '0', '1', '1', '2014-02-06 13:16:34', '2014-02-06 13:16:34', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('13', '3', '100.0', '1', '1', '2014-02-06 14:36:16', '2014-02-06 14:36:16', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('14', '3', '106.0', '1', '1', '2014-02-06 15:11:01', '2014-02-06 15:11:01', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('15', '3', '106.0', '1', '1', '2014-02-06 15:12:07', '2014-02-06 15:12:07', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('16', '3', '0', '1', '1', '2014-02-06 15:12:12', '2014-02-06 15:12:12', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('17', '3', '0', '1', '1', '2014-02-06 15:13:05', '2014-02-06 15:13:05', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('18', '3', '0', '1', '1', '2014-02-06 15:18:18', '2014-02-06 15:18:18', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('19', '3', '0', '1', '1', '2014-02-06 15:20:27', '2014-02-06 15:20:27', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
INSERT INTO `orders` VALUES ('20', '3', '233.0', '1', '1', '2014-02-06 15:21:14', '2014-02-06 15:30:48', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '3');
INSERT INTO `orders` VALUES ('21', '3', '250.0', '1', '1', '2014-02-06 21:19:56', '2014-02-06 21:19:56', '123423 903242134 ', '', '0', '0', 'As Soon As Possible', '12:00:00', null, 'Kentucky, 0 Aberdeen, Tuchoho12/33', '693', '1');
