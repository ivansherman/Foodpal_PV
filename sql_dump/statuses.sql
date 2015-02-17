/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50527
Source Host           : 127.0.0.1:3306
Source Database       : foodpal_development

Target Server Type    : MYSQL
Target Server Version : 50527
File Encoding         : 65001

Date: 2014-02-07 14:42:40
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for statuses
-- ----------------------------
DROP TABLE IF EXISTS `statuses`;
CREATE TABLE `statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `color` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of statuses
-- ----------------------------
INSERT INTO `statuses` VALUES ('1', 'New', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '#428bca');
INSERT INTO `statuses` VALUES ('2', 'In Progress', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '#5bc0de');
INSERT INTO `statuses` VALUES ('3', 'Wrong', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '#FF8182');
INSERT INTO `statuses` VALUES ('4', 'Delivering', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '#FFCC66');
INSERT INTO `statuses` VALUES ('5', 'Delivered', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '#94ca74');
INSERT INTO `statuses` VALUES ('6', 'Canceled', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '#FF8182');
