-- MySQL dump 10.13  Distrib 5.5.35, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: edxapp
-- ------------------------------------------------------
-- Server version	5.5.35-0ubuntu0.12.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (3,'instructor_diaodiyun.60240013x.2014_t4'),(5,'instructor_qinghua.10421084x.2014'),(1,'instructor_tsinghua.tsinghua101.2014_t1'),(15,'instructor_测试机构.cd_011.2014'),(17,'instructor_测试机构.yx_01.2014_t1'),(9,'instructor_清华大学.tsh_001.2014_01'),(13,'instructor_清华大学.tsh_011.2014_t4'),(11,'instructor_青花大学.tsh_002.2014_t4'),(7,'instructor_青花大学.tsh_110.2014_t3'),(4,'staff_diaodiyun.60240013x.2014_t4'),(6,'staff_qinghua.10421084x.2014'),(2,'staff_tsinghua.tsinghua101.2014_t1'),(16,'staff_测试机构.cd_011.2014'),(18,'staff_测试机构.yx_01.2014_t1'),(10,'staff_清华大学.tsh_001.2014_01'),(14,'staff_清华大学.tsh_011.2014_t4'),(12,'staff_青花大学.tsh_002.2014_t4'),(8,'staff_青花大学.tsh_110.2014_t3');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_bda51c3c` (`group_id`),
  KEY `auth_group_permissions_1e014c8f` (`permission_id`),
  CONSTRAINT `group_id_refs_id_3cea63fe` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `permission_id_refs_id_a7792de1` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_e4470c6e` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_728de91f` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can add group',2,'add_group'),(5,'Can change group',2,'change_group'),(6,'Can delete group',2,'delete_group'),(7,'Can add user',3,'add_user'),(8,'Can change user',3,'change_user'),(9,'Can delete user',3,'delete_user'),(10,'Can add content type',4,'add_contenttype'),(11,'Can change content type',4,'change_contenttype'),(12,'Can delete content type',4,'delete_contenttype'),(13,'Can add session',5,'add_session'),(14,'Can change session',5,'change_session'),(15,'Can delete session',5,'delete_session'),(16,'Can add site',6,'add_site'),(17,'Can change site',6,'change_site'),(18,'Can delete site',6,'delete_site'),(19,'Can add task state',7,'add_taskmeta'),(20,'Can change task state',7,'change_taskmeta'),(21,'Can delete task state',7,'delete_taskmeta'),(22,'Can add saved group result',8,'add_tasksetmeta'),(23,'Can change saved group result',8,'change_tasksetmeta'),(24,'Can delete saved group result',8,'delete_tasksetmeta'),(25,'Can add interval',9,'add_intervalschedule'),(26,'Can change interval',9,'change_intervalschedule'),(27,'Can delete interval',9,'delete_intervalschedule'),(28,'Can add crontab',10,'add_crontabschedule'),(29,'Can change crontab',10,'change_crontabschedule'),(30,'Can delete crontab',10,'delete_crontabschedule'),(31,'Can add periodic tasks',11,'add_periodictasks'),(32,'Can change periodic tasks',11,'change_periodictasks'),(33,'Can delete periodic tasks',11,'delete_periodictasks'),(34,'Can add periodic task',12,'add_periodictask'),(35,'Can change periodic task',12,'change_periodictask'),(36,'Can delete periodic task',12,'delete_periodictask'),(37,'Can add worker',13,'add_workerstate'),(38,'Can change worker',13,'change_workerstate'),(39,'Can delete worker',13,'delete_workerstate'),(40,'Can add task',14,'add_taskstate'),(41,'Can change task',14,'change_taskstate'),(42,'Can delete task',14,'delete_taskstate'),(43,'Can add migration history',15,'add_migrationhistory'),(44,'Can change migration history',15,'change_migrationhistory'),(45,'Can delete migration history',15,'delete_migrationhistory'),(46,'Can add server circuit',16,'add_servercircuit'),(47,'Can change server circuit',16,'change_servercircuit'),(48,'Can delete server circuit',16,'delete_servercircuit'),(49,'Can add psychometric data',17,'add_psychometricdata'),(50,'Can change psychometric data',17,'change_psychometricdata'),(51,'Can delete psychometric data',17,'delete_psychometricdata'),(52,'Can add course user group',18,'add_courseusergroup'),(53,'Can change course user group',18,'change_courseusergroup'),(54,'Can delete course user group',18,'delete_courseusergroup'),(55,'Can add nonce',19,'add_nonce'),(56,'Can change nonce',19,'change_nonce'),(57,'Can delete nonce',19,'delete_nonce'),(58,'Can add association',20,'add_association'),(59,'Can change association',20,'change_association'),(60,'Can delete association',20,'delete_association'),(61,'Can add user open id',21,'add_useropenid'),(62,'Can change user open id',21,'change_useropenid'),(63,'Can delete user open id',21,'delete_useropenid'),(64,'Can add log entry',22,'add_logentry'),(65,'Can change log entry',22,'change_logentry'),(66,'Can delete log entry',22,'delete_logentry'),(67,'Can add student module',23,'add_studentmodule'),(68,'Can change student module',23,'change_studentmodule'),(69,'Can delete student module',23,'delete_studentmodule'),(70,'Can add student module history',24,'add_studentmodulehistory'),(71,'Can change student module history',24,'change_studentmodulehistory'),(72,'Can delete student module history',24,'delete_studentmodulehistory'),(73,'Can add x module user state summary field',25,'add_xmoduleuserstatesummaryfield'),(74,'Can change x module user state summary field',25,'change_xmoduleuserstatesummaryfield'),(75,'Can delete x module user state summary field',25,'delete_xmoduleuserstatesummaryfield'),(76,'Can add x module student prefs field',26,'add_xmodulestudentprefsfield'),(77,'Can change x module student prefs field',26,'change_xmodulestudentprefsfield'),(78,'Can delete x module student prefs field',26,'delete_xmodulestudentprefsfield'),(79,'Can add x module student info field',27,'add_xmodulestudentinfofield'),(80,'Can change x module student info field',27,'change_xmodulestudentinfofield'),(81,'Can delete x module student info field',27,'delete_xmodulestudentinfofield'),(82,'Can add offline computed grade',28,'add_offlinecomputedgrade'),(83,'Can change offline computed grade',28,'change_offlinecomputedgrade'),(84,'Can delete offline computed grade',28,'delete_offlinecomputedgrade'),(85,'Can add offline computed grade log',29,'add_offlinecomputedgradelog'),(86,'Can change offline computed grade log',29,'change_offlinecomputedgradelog'),(87,'Can delete offline computed grade log',29,'delete_offlinecomputedgradelog'),(88,'Can add anonymous user id',30,'add_anonymoususerid'),(89,'Can change anonymous user id',30,'change_anonymoususerid'),(90,'Can delete anonymous user id',30,'delete_anonymoususerid'),(91,'Can add user standing',31,'add_userstanding'),(92,'Can change user standing',31,'change_userstanding'),(93,'Can delete user standing',31,'delete_userstanding'),(94,'Can add user profile',32,'add_userprofile'),(95,'Can change user profile',32,'change_userprofile'),(96,'Can delete user profile',32,'delete_userprofile'),(97,'Can add user test group',33,'add_usertestgroup'),(98,'Can change user test group',33,'change_usertestgroup'),(99,'Can delete user test group',33,'delete_usertestgroup'),(100,'Can add registration',34,'add_registration'),(101,'Can change registration',34,'change_registration'),(102,'Can delete registration',34,'delete_registration'),(103,'Can add pending name change',35,'add_pendingnamechange'),(104,'Can change pending name change',35,'change_pendingnamechange'),(105,'Can delete pending name change',35,'delete_pendingnamechange'),(106,'Can add pending email change',36,'add_pendingemailchange'),(107,'Can change pending email change',36,'change_pendingemailchange'),(108,'Can delete pending email change',36,'delete_pendingemailchange'),(109,'Can add login failures',37,'add_loginfailures'),(110,'Can change login failures',37,'change_loginfailures'),(111,'Can delete login failures',37,'delete_loginfailures'),(112,'Can add course enrollment',38,'add_courseenrollment'),(113,'Can change course enrollment',38,'change_courseenrollment'),(114,'Can delete course enrollment',38,'delete_courseenrollment'),(115,'Can add course enrollment allowed',39,'add_courseenrollmentallowed'),(116,'Can change course enrollment allowed',39,'change_courseenrollmentallowed'),(117,'Can delete course enrollment allowed',39,'delete_courseenrollmentallowed'),(118,'Can add tracking log',40,'add_trackinglog'),(119,'Can change tracking log',40,'change_trackinglog'),(120,'Can delete tracking log',40,'delete_trackinglog'),(121,'Can add certificate whitelist',41,'add_certificatewhitelist'),(122,'Can change certificate whitelist',41,'change_certificatewhitelist'),(123,'Can delete certificate whitelist',41,'delete_certificatewhitelist'),(124,'Can add generated certificate',42,'add_generatedcertificate'),(125,'Can change generated certificate',42,'change_generatedcertificate'),(126,'Can delete generated certificate',42,'delete_generatedcertificate'),(127,'Can add instructor task',43,'add_instructortask'),(128,'Can change instructor task',43,'change_instructortask'),(129,'Can delete instructor task',43,'delete_instructortask'),(130,'Can add course software',44,'add_coursesoftware'),(131,'Can change course software',44,'change_coursesoftware'),(132,'Can delete course software',44,'delete_coursesoftware'),(133,'Can add user license',45,'add_userlicense'),(134,'Can change user license',45,'change_userlicense'),(135,'Can delete user license',45,'delete_userlicense'),(136,'Can add course email',46,'add_courseemail'),(137,'Can change course email',46,'change_courseemail'),(138,'Can delete course email',46,'delete_courseemail'),(139,'Can add optout',47,'add_optout'),(140,'Can change optout',47,'change_optout'),(141,'Can delete optout',47,'delete_optout'),(142,'Can add course email template',48,'add_courseemailtemplate'),(143,'Can change course email template',48,'change_courseemailtemplate'),(144,'Can delete course email template',48,'delete_courseemailtemplate'),(145,'Can add course authorization',49,'add_courseauthorization'),(146,'Can change course authorization',49,'change_courseauthorization'),(147,'Can delete course authorization',49,'delete_courseauthorization'),(148,'Can add external auth map',50,'add_externalauthmap'),(149,'Can change external auth map',50,'change_externalauthmap'),(150,'Can delete external auth map',50,'delete_externalauthmap'),(151,'Can add article',51,'add_article'),(152,'Can change article',51,'change_article'),(153,'Can delete article',51,'delete_article'),(154,'Can edit all articles and lock/unlock/restore',51,'moderate'),(155,'Can change ownership of any article',51,'assign'),(156,'Can assign permissions to other users',51,'grant'),(157,'Can add Article for object',52,'add_articleforobject'),(158,'Can change Article for object',52,'change_articleforobject'),(159,'Can delete Article for object',52,'delete_articleforobject'),(160,'Can add article revision',53,'add_articlerevision'),(161,'Can change article revision',53,'change_articlerevision'),(162,'Can delete article revision',53,'delete_articlerevision'),(163,'Can add URL path',54,'add_urlpath'),(164,'Can change URL path',54,'change_urlpath'),(165,'Can delete URL path',54,'delete_urlpath'),(166,'Can add article plugin',55,'add_articleplugin'),(167,'Can change article plugin',55,'change_articleplugin'),(168,'Can delete article plugin',55,'delete_articleplugin'),(169,'Can add reusable plugin',56,'add_reusableplugin'),(170,'Can change reusable plugin',56,'change_reusableplugin'),(171,'Can delete reusable plugin',56,'delete_reusableplugin'),(172,'Can add simple plugin',57,'add_simpleplugin'),(173,'Can change simple plugin',57,'change_simpleplugin'),(174,'Can delete simple plugin',57,'delete_simpleplugin'),(175,'Can add revision plugin',58,'add_revisionplugin'),(176,'Can change revision plugin',58,'change_revisionplugin'),(177,'Can delete revision plugin',58,'delete_revisionplugin'),(178,'Can add revision plugin revision',59,'add_revisionpluginrevision'),(179,'Can change revision plugin revision',59,'change_revisionpluginrevision'),(180,'Can delete revision plugin revision',59,'delete_revisionpluginrevision'),(181,'Can add article subscription',60,'add_articlesubscription'),(182,'Can change article subscription',60,'change_articlesubscription'),(183,'Can delete article subscription',60,'delete_articlesubscription'),(184,'Can add type',61,'add_notificationtype'),(185,'Can change type',61,'change_notificationtype'),(186,'Can delete type',61,'delete_notificationtype'),(187,'Can add settings',62,'add_settings'),(188,'Can change settings',62,'change_settings'),(189,'Can delete settings',62,'delete_settings'),(190,'Can add subscription',63,'add_subscription'),(191,'Can change subscription',63,'change_subscription'),(192,'Can delete subscription',63,'delete_subscription'),(193,'Can add notification',64,'add_notification'),(194,'Can change notification',64,'change_notification'),(195,'Can delete notification',64,'delete_notification'),(196,'Can add score',65,'add_score'),(197,'Can change score',65,'change_score'),(198,'Can delete score',65,'delete_score'),(199,'Can add puzzle complete',66,'add_puzzlecomplete'),(200,'Can change puzzle complete',66,'change_puzzlecomplete'),(201,'Can delete puzzle complete',66,'delete_puzzlecomplete'),(202,'Can add flag',67,'add_flag'),(203,'Can change flag',67,'change_flag'),(204,'Can delete flag',67,'delete_flag'),(205,'Can add switch',68,'add_switch'),(206,'Can change switch',68,'change_switch'),(207,'Can delete switch',68,'delete_switch'),(208,'Can add sample',69,'add_sample'),(209,'Can change sample',69,'change_sample'),(210,'Can delete sample',69,'delete_sample'),(211,'Can add note',70,'add_note'),(212,'Can change note',70,'change_note'),(213,'Can delete note',70,'delete_note'),(214,'Can add user preference',71,'add_userpreference'),(215,'Can change user preference',71,'change_userpreference'),(216,'Can delete user preference',71,'delete_userpreference'),(217,'Can add order',72,'add_order'),(218,'Can change order',72,'change_order'),(219,'Can delete order',72,'delete_order'),(220,'Can add order item',73,'add_orderitem'),(221,'Can change order item',73,'change_orderitem'),(222,'Can delete order item',73,'delete_orderitem'),(223,'Can add paid course registration',74,'add_paidcourseregistration'),(224,'Can change paid course registration',74,'change_paidcourseregistration'),(225,'Can delete paid course registration',74,'delete_paidcourseregistration'),(226,'Can add paid course registration annotation',75,'add_paidcourseregistrationannotation'),(227,'Can change paid course registration annotation',75,'change_paidcourseregistrationannotation'),(228,'Can delete paid course registration annotation',75,'delete_paidcourseregistrationannotation'),(229,'Can add certificate item',76,'add_certificateitem'),(230,'Can change certificate item',76,'change_certificateitem'),(231,'Can delete certificate item',76,'delete_certificateitem'),(232,'Can add course mode',77,'add_coursemode'),(233,'Can change course mode',77,'change_coursemode'),(234,'Can delete course mode',77,'delete_coursemode'),(235,'Can add software secure photo verification',78,'add_softwaresecurephotoverification'),(236,'Can change software secure photo verification',78,'change_softwaresecurephotoverification'),(237,'Can delete software secure photo verification',78,'delete_softwaresecurephotoverification'),(238,'Can add dark lang config',79,'add_darklangconfig'),(239,'Can change dark lang config',79,'change_darklangconfig'),(240,'Can delete dark lang config',79,'delete_darklangconfig'),(241,'Can add midcourse reverification window',80,'add_midcoursereverificationwindow'),(242,'Can change midcourse reverification window',80,'change_midcoursereverificationwindow'),(243,'Can delete midcourse reverification window',80,'delete_midcoursereverificationwindow'),(244,'Can add linked in',81,'add_linkedin'),(245,'Can change linked in',81,'change_linkedin'),(246,'Can delete linked in',81,'delete_linkedin'),(247,'Can add splash config',82,'add_splashconfig'),(248,'Can change splash config',82,'change_splashconfig'),(249,'Can delete splash config',82,'delete_splashconfig'),(250,'Can add captcha store',83,'add_captchastore'),(251,'Can change captcha store',83,'change_captchastore'),(252,'Can delete captcha store',83,'delete_captchastore'),(253,'Can add embargoed course',84,'add_embargoedcourse'),(254,'Can change embargoed course',84,'change_embargoedcourse'),(255,'Can delete embargoed course',84,'delete_embargoedcourse'),(256,'Can add embargoed state',85,'add_embargoedstate'),(257,'Can change embargoed state',85,'change_embargoedstate'),(258,'Can delete embargoed state',85,'delete_embargoedstate'),(259,'Can add ip filter',86,'add_ipfilter'),(260,'Can change ip filter',86,'change_ipfilter'),(261,'Can delete ip filter',86,'delete_ipfilter'),(262,'Can add answer',87,'add_answer'),(263,'Can change answer',87,'change_answer'),(264,'Can delete answer',87,'delete_answer'),(265,'Can add course creator',88,'add_coursecreator'),(266,'Can change course creator',88,'change_coursecreator'),(267,'Can delete course creator',88,'delete_coursecreator');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_registration`
--

DROP TABLE IF EXISTS `auth_registration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_registration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `activation_key` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `activation_key` (`activation_key`),
  CONSTRAINT `user_id_refs_id_3fe8066a03e5b0b5` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_registration`
--

LOCK TABLES `auth_registration` WRITE;
/*!40000 ALTER TABLE `auth_registration` DISABLE KEYS */;
INSERT INTO `auth_registration` VALUES (1,1,'e29e1b741eca44c08f7ef3ed808b82f1'),(2,2,'01c648f186924af09bfa40fbbbb977eb'),(3,3,'5bd8e1e65cd3414ca6d1b2ed81de756f'),(4,4,'e1b0c952f6c348ddaba0ac929b0b05d4'),(5,9,'eb57fca303f04738b19d6aced14033c4'),(6,10,'3dceec71fa2647d5a12989b36306d7be'),(7,11,'059a64096b8f43d1972a482298c8e6c3'),(8,12,'f10f8e5865ae44c8a85c6615984a0445'),(9,19,'dcd5970d680b4444a9d4615b2fcbdba2'),(10,21,'32646e126ca64f9a8606d72b3f54951f'),(19,33,'26fbf4a1d31c47c7a0923ad4973099c7'),(20,35,'03e28892b809452d845769758f996f5b'),(21,36,'2431c47f9c504bc68278e6a0b9efb8af'),(22,41,'b23d964d6e6842eb9aa1c804f2144651'),(23,42,'78f366fc783345438bdb7186d8696d31'),(24,70,'918622a7757a41a7829b7bbeaf5f331f'),(25,96,'22a37048f69e45eba6e98c4bdd754a9b'),(26,97,'3eaa6a5bbdb14f1783e2446114461582'),(27,98,'c2c36dd1d57840bf914b28560cda6532'),(28,99,'b469e6e3563d4e5ab8dcfe55e1134fd3'),(29,101,'b031abf3260945f69c52ac7186006a3a'),(30,102,'468819276af64585b8d23ea0690d4021'),(31,104,'71f7f7a973764b2fb50eef4699953ac5'),(32,108,'70caed46432f4bc4a7165cc8435f27f8'),(33,110,'a1b10737bd624352975a18472ac46241'),(34,111,'a79a972b601a4603ad6603a5807663d0'),(35,112,'03f6456de86b4064ba4b7244cd28bf3e');
/*!40000 ALTER TABLE `auth_registration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `password` varchar(128) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `last_login` datetime NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'honor','','','honor@example.com','8ec6a6b8d19d2b1b48870e22c91d9144',0,1,0,'2014-09-28 02:54:10','2014-02-10 03:20:18'),(2,'audit','','','audit@example.com','8ec6a6b8d19d2b1b48870e22c91d9144',0,1,0,'2014-06-27 08:27:13','2014-02-10 03:20:20'),(3,'verified','','','verified@example.com','pbkdf2_sha256$10000$JeWxVvd9Krz8$ba/hxk85pJfp+uKU39Hc7xWW5oVoPEW/unbMZKa+UrY=',0,1,0,'2014-02-10 03:20:22','2014-02-10 03:20:22'),(4,'staff','','','staff@example.com','8ec6a6b8d19d2b1b48870e22c91d9144',1,1,0,'2014-09-28 08:13:10','2014-02-10 03:20:23'),(9,'csc','','','csc@diandiyun.com','pbkdf2_sha256$10000$ad2JtV2Keih5$Mt4DJ9L0Gi2tZ+MKq5zPxcSr/tz79Qv5zvjsMTznavM=',0,1,0,'2014-03-01 08:21:18','2014-02-26 13:20:42'),(10,'diandiyun-1','','','edx@diandiyun.com','pbkdf2_sha256$10000$lYQCVx5yBswo$sQ2lhnBkM0dNgF9ZoO69ciQ6/vw+bhO4oEOU/bBgzkE=',0,1,0,'2014-02-28 09:56:31','2014-02-27 08:59:34'),(11,'diandiyun-ddy','','','ddy@diandiyun.com','pbkdf2_sha256$10000$v7SucSs07PPl$mKjhsu9lM7nAbxjNmph1kv0Q9OZ/6WLSjkB85RUOgVU=',0,1,0,'2014-03-01 03:39:46','2014-02-27 09:01:04'),(12,'xiaodun_dev_test_5','','','xiaodun_dev_test_5@163.com','bcf36eb437d347d148585726dc4e356f',0,1,0,'2014-07-29 02:56:43','2014-06-27 06:13:30'),(13,'张老师','','','zy@diandiyun.com','78c030cbacfb8be9bfe53318a1e5800e',0,1,0,'2014-07-02 07:58:16','2014-07-02 07:58:16'),(14,'刘一鸣','','','liuyiming@126.com','4e5ee00b85dec91cf6c4f296c38274ce',0,1,0,'2014-07-02 09:04:10','2014-07-02 09:04:10'),(15,'张一凡','','','zhangyifan@126.com','d61ad6571ae78109d89b1aaa3f6ec842',0,1,0,'2014-07-02 09:57:21','2014-07-02 09:57:21'),(16,'张友名','','','zhangyouming@126.com','9421ca3581ebaa69bd57149445d982b1',0,1,0,'2014-07-02 09:58:38','2014-07-02 09:58:38'),(17,'刘大伟','','','liudawei@126.com','2f1041bca42afd2dbc75ae01ca27512a',0,1,0,'2014-07-03 06:51:29','2014-07-03 06:51:29'),(18,'null','','','test_yangfeiyu@126.com','e031c091b80da489a0c54f2a99a36127',0,1,0,'2014-07-03 07:00:39','2014-07-03 07:00:39'),(19,'bluecrazy5210','','','bluecrazy5210@163.com','3b54a66c586d8ca65407a23bfd18e4cb',0,0,0,'2014-07-07 09:14:38','2014-07-07 09:14:38'),(21,'xiaodun','','','xiaodun_dev@163.com','bcf36eb437d347d148585726dc4e356f',0,0,0,'2014-07-08 07:31:15','2014-07-08 07:31:15'),(33,'xiaodun_dev_test_2','','','xiaodun_dev_test_2@163.com','bcf36eb437d347d148585726dc4e356f',0,0,0,'2014-07-08 08:02:21','2014-07-08 08:02:21'),(35,'xiaodun_dev_test_3','','','xiaodun_dev_test_3@163.com','bcf36eb437d347d148585726dc4e356f',0,0,0,'2014-07-08 08:05:46','2014-07-08 08:05:46'),(36,'zhangwei','','','415364580@qq.com','7f3886be136f704739be561424271e62',0,0,0,'2014-07-09 03:08:18','2014-07-09 03:08:18'),(37,'中研','','','test_zhongyan@126.com','6af1a7a51842f80dbdaee8d5fde3626d',0,1,0,'2014-07-10 06:16:10','2014-07-10 06:16:10'),(41,'xiaodun_dev_pro_1','','','xiaodun_dev_pro_1@163.com','bcf36eb437d347d148585726dc4e356f',0,0,0,'2014-07-14 07:20:16','2014-07-14 07:20:16'),(42,'xiaodun_dev_pro_2','','','xiaodun_dev_pro_2@163.com','b47906f4dfb392de005518a3e37ef950',0,0,0,'2014-07-14 07:23:18','2014-07-14 07:23:18'),(43,'sdy110','','','sdy110@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 02:51:46','2014-07-15 02:51:46'),(44,'马静4','','','majing5@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 06:24:39','2014-07-15 06:24:39'),(45,'马静6','','','majing6@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 06:28:27','2014-07-15 06:28:27'),(46,'马静3','','','majing4@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 06:30:45','2014-07-15 06:30:45'),(47,'zhangtao2','','','zhangta2@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 06:34:06','2014-07-15 06:34:06'),(48,'吴迪2','','','wudi2@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 06:39:57','2014-07-15 06:39:57'),(49,'吴迪3','','','wudi3@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 06:41:53','2014-07-15 06:41:53'),(50,'长春','','','cfsss@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 06:48:44','2014-07-15 06:48:44'),(51,'长春2','','','cfsss2@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 06:50:00','2014-07-15 06:50:00'),(52,'长春3','','','cfsss3@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 06:51:15','2014-07-15 06:51:15'),(53,'zhongyee','','','zhongy@162.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 07:21:21','2014-07-15 07:21:21'),(54,'liuyiming33333','','','liuyiming3333@126.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 07:28:23','2014-07-15 07:28:23'),(55,'zhongy33333','','','zhongy333333@162.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 07:29:05','2014-07-15 07:29:05'),(56,'sdy111','','','sdy111@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-15 09:33:42','2014-07-15 09:33:42'),(57,'amd0081','','','amd0082@guoshi.com','96e79218965eb72c92a549dd5a330112',0,1,0,'2014-07-16 02:04:27','2014-07-16 02:02:51'),(58,'sdy121','','','sdy121@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-16 03:07:13','2014-07-16 03:07:13'),(59,'xiaodun_dev','','','xiaodun_dev_test_7@163.com','7a9cddabdc10b7b1fc1a41ca0fee65ff',0,1,0,'2014-07-16 03:29:20','2014-07-16 03:29:20'),(60,'xiaodun_pro','','','xiaodun_dev_test@163.com','7a9cddabdc10b7b1fc1a41ca0fee65ff',0,1,0,'2014-07-16 03:32:29','2014-07-16 03:32:29'),(62,'HUALALA_PRO','','','xiaodun_dev_test_12@163.com','7a9cddabdc10b7b1fc1a41ca0fee65ff',0,1,0,'2014-07-16 03:43:04','2014-07-16 03:43:04'),(64,'HUALALA_PROP','','','xiaodun_dev_test_11@163.com','7a9cddabdc10b7b1fc1a41ca0fee65ff',0,1,0,'2014-07-16 03:45:29','2014-07-16 03:45:29'),(66,'HUALALA_PROPK','','','xiaodun_dev_test_13@163.com','7a9cddabdc10b7b1fc1a41ca0fee65ff',0,1,0,'2014-07-16 03:46:59','2014-07-16 03:46:59'),(67,'kaixinhaole','','','xiaodun_dev_text_2@163.com','7a9cddabdc10b7b1fc1a41ca0fee65ff',0,1,0,'2014-07-16 03:58:52','2014-07-16 03:58:52'),(70,'bluecrazy52100','','','xiaodun_dev_text_3@163.com','7a9cddabdc10b7b1fc1a41ca0fee65ff',0,0,0,'2014-07-16 04:09:23','2014-07-16 04:09:23'),(71,'dhk1234567','','','dsd123456@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-16 06:24:24','2014-07-16 06:24:24'),(72,'zhanglaoshi2','','','zhangly2@diandiyun.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-16 06:24:25','2014-07-16 06:24:25'),(73,'zhanglaoshi3','','','zhangly3@diandiyun.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-16 06:31:48','2014-07-16 06:31:48'),(74,'yyyyyyy2','','','sundongyun5@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-07-16 09:05:04','2014-07-16 09:05:04'),(75,'sunyanho56','','','sundy456@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 06:20:24','2014-08-22 06:13:51'),(76,'sunyanhong','','','sundy234@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 07:44:45','2014-08-22 07:44:45'),(78,'sunyanh890','','','sundy789@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 07:45:58','2014-08-22 07:45:58'),(79,'sunyanok89','','','sundy012@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 07:47:36','2014-08-22 07:47:36'),(80,'sundyhong','','','sundy123@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 07:49:48','2014-08-22 07:49:48'),(81,'sunyanok6554','','','sundyio012@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 08:10:23','2014-08-22 08:10:23'),(83,'kjsdjad','','','sjdjfdy345@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 10:44:43','2014-08-22 10:44:43'),(84,'ksdjkska','','','sdjksddy123@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 11:03:47','2014-08-22 11:03:47'),(85,'shdyufke','','','sdyssssd@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 11:11:06','2014-08-22 11:11:06'),(86,'sundyh12','','','sundy345@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 11:13:59','2014-08-22 11:13:59'),(92,'suwei34dsf','','','dsd123457@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-22 11:24:18','2014-08-22 11:23:37'),(94,'刘立虎','','','liulihu123@126.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-23 04:53:16','2014-08-23 04:52:50'),(95,'hgdsahhds1234','','','sjfhddy876012@163.com','25d55ad283aa400af464c76d713c07ad',0,1,0,'2014-08-23 04:59:48','2014-08-23 04:58:56'),(96,'123456qq','','','liuquanrui@126.com','98641e30ace18a76f07bd7e5fbf7cd6c',0,0,0,'2014-09-04 09:07:10','2014-09-04 09:07:10'),(97,'cehisceshi','','','liuqr@diandiyun.com','98641e30ace18a76f07bd7e5fbf7cd6c',0,0,0,'2014-09-04 09:10:11','2014-09-04 09:10:11'),(98,'ssssssssdasd','','','907007852@qq.com','98641e30ace18a76f07bd7e5fbf7cd6c',0,0,0,'2014-09-04 09:11:51','2014-09-04 09:11:51'),(99,'shishishishihh','','','xiaodunxin@126.com','fa22fb87b07ae7407f5ceda208a47996',0,0,0,'2014-09-10 02:58:48','2014-09-10 02:58:48'),(101,'qwerqw','','','lqr@example.com','0b2f71af431692ef21b95cd2f504bec1',0,0,0,'2014-09-10 07:12:28','2014-09-10 07:12:28'),(102,'lishili','','','1416248520@qq.com','5bacd9f25613659b2fbd2f3a58822e5c',0,0,0,'2014-09-10 07:13:35','2014-09-10 07:13:35'),(104,'lishishi','','','445303527@qq.com','pbkdf2_sha256$10000$DS4gtK0ZxXh7$R7q22RRJa+/5NozJT34PzZEKFY0qiXiNuQA5GNritSU=',0,0,0,'2014-09-10 07:23:43','2014-09-10 07:23:43'),(108,'ceshishi','','','liuqr@example.com','pbkdf2_sha256$10000$2NdNe5Qh9KwA$6LsTt+2C6ymPunanICanVbbMJ++GuN3BvGt9sTCvSO8=',0,1,0,'2014-09-12 06:46:56','2014-09-10 08:08:14'),(110,'lishishishis','','','liuquanrui@example.com','pbkdf2_sha256$10000$CE11pCeMSqXe$qZFQia1JLCc5jHu3DvKrIimPnAzDCbD5qeEmbZicACY=',0,0,0,'2014-09-10 08:09:16','2014-09-10 08:09:16'),(111,'liuliuliulllllll','','','aaa@example.com','pbkdf2_sha256$10000$90ieubVm9lE4$BbooKKgeH5TeUOKx0TsglIJyJTtqIEu74g109S5eF9c=',0,0,0,'2014-09-15 01:49:02','2014-09-15 01:49:02'),(112,'institu','','','liuinstui@example.com','8ec6a6b8d19d2b1b48870e22c91d9144',0,1,0,'2014-09-26 01:37:40','2014-09-23 03:36:50');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_fbfc09f1` (`user_id`),
  KEY `auth_user_groups_bda51c3c` (`group_id`),
  CONSTRAINT `group_id_refs_id_f0ee9890` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `user_id_refs_id_831107f1` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (12,1,6),(19,1,13),(20,1,14),(26,1,17),(25,1,18),(13,4,7),(14,4,8),(15,4,9),(16,4,10),(17,4,11),(18,4,12),(21,4,15),(22,4,16),(23,4,17),(24,4,18),(1,9,1),(2,9,2),(3,9,3),(4,9,4),(5,11,5),(6,11,6);
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_fbfc09f1` (`user_id`),
  KEY `auth_user_user_permissions_1e014c8f` (`permission_id`),
  CONSTRAINT `permission_id_refs_id_67e79cb` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `user_id_refs_id_f2045483` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_userprofile`
--

DROP TABLE IF EXISTS `auth_userprofile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_userprofile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `language` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `meta` longtext NOT NULL,
  `courseware` varchar(255) NOT NULL,
  `gender` varchar(6),
  `mailing_address` longtext,
  `year_of_birth` int(11),
  `level_of_education` varchar(6),
  `goals` longtext,
  `allow_certificate` tinyint(1) NOT NULL,
  `country` varchar(2),
  `city` longtext,
  `profile_role` varchar(6) DEFAULT 'st',
  `institute` int(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `auth_userprofile_52094d6e` (`name`),
  KEY `auth_userprofile_8a7ac9ab` (`language`),
  KEY `auth_userprofile_b54954de` (`location`),
  KEY `auth_userprofile_fca3d292` (`gender`),
  KEY `auth_userprofile_d85587` (`year_of_birth`),
  KEY `auth_userprofile_551e365c` (`level_of_education`),
  KEY `auth_userprofile_551e465c` (`profile_role`),
  CONSTRAINT `user_id_refs_id_3daaa960628b4c11` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_userprofile`
--

LOCK TABLES `auth_userprofile` WRITE;
/*!40000 ALTER TABLE `auth_userprofile` DISABLE KEYS */;
INSERT INTO `auth_userprofile` VALUES (1,1,'honor','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'th',NULL),(2,2,'audit','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'st',NULL),(3,3,'verified','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'st',NULL),(4,4,'staff','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'th',NULL),(5,9,'csc-diandiyun','','','','course.xml','','',NULL,'','',1,'',NULL,'st',NULL),(6,10,'diandiyun-1','','','','course.xml','','',NULL,'','',1,'',NULL,'st',NULL),(7,11,'diandiyun-ddy','','','','course.xml','','',NULL,'','',1,'',NULL,'th',NULL),(8,12,'xiaodun_dev_test_5','','','','course.xml','m','',1999,'m','',1,'',NULL,'st',NULL),(9,13,'张老师','','','','course.xml','o','河北',NULL,'other',NULL,1,'',NULL,'st',NULL),(10,14,'刘一鸣','','','','course.xml','o','天津',NULL,'other',NULL,1,'',NULL,'st',NULL),(11,15,'张一凡','','','','course.xml','o','北京',NULL,'other',NULL,1,'',NULL,'st',NULL),(12,16,'张友名','','','','course.xml','o','北京',NULL,'other',NULL,1,'',NULL,'st',NULL),(13,17,'刘大伟','','','','course.xml','o','北京',NULL,'other',NULL,1,'',NULL,'th',NULL),(14,18,'null','','','','course.xml','o','北京',NULL,'other',NULL,1,'',NULL,'st',NULL),(15,19,'bluecrazy5210','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'st',NULL),(16,21,'xioadun','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'st',NULL),(25,33,'xiaodun_dev_test_2','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'st',NULL),(26,35,'xiaodun_dev_test_3','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'st',NULL),(27,36,'张维','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'st',NULL),(28,37,'中研','','','','course.xml','o','北京',NULL,'other',NULL,1,'',NULL,'th',NULL),(29,41,'xiaodun_dev_pro_1','','','','course.xml','f','库卡库卡',2002,'m','库卡库卡库卡库卡',1,'',NULL,'st',NULL),(30,42,'xiaodun_dev_pro_2','','','','course.xml','f','库卡库卡',2004,'b','库卡库卡',1,'',NULL,'st',NULL),(31,43,'sdy110','','','','course.xml','o','北京',NULL,'other',NULL,1,'',NULL,'st',NULL),(32,44,'马静4','','','','course.xml','o','',NULL,'other',NULL,1,'',NULL,'st',NULL),(33,45,'马静6','','','','course.xml','o','',NULL,'other',NULL,1,'',NULL,'st',NULL),(34,46,'马静3','','','','course.xml','o','',NULL,'other',NULL,1,'',NULL,'st',NULL),(35,47,'zhangtao2','','','','course.xml','o','',NULL,'other',NULL,1,'',NULL,'st',NULL),(36,48,'吴迪2','','','','course.xml','o','济南',NULL,'other',NULL,1,'',NULL,'st',NULL),(37,49,'吴迪3','','','','course.xml','o','济南',NULL,'other',NULL,1,'',NULL,'st',NULL),(38,50,'长春','','','','course.xml','o','',NULL,'other',NULL,1,'',NULL,'st',NULL),(39,51,'长春2','','','','course.xml','o','',NULL,'other',NULL,1,'',NULL,'st',NULL),(40,52,'长春3','','','','course.xml','o','',NULL,'other',NULL,1,'',NULL,'st',NULL),(41,53,'zhongyee','','','','course.xml','m','北京',NULL,'other',NULL,1,'',NULL,'st',NULL),(42,54,'liuyiming33333','','','','course.xml','m','天津',NULL,'other',NULL,1,'',NULL,'st',NULL),(43,55,'zhongy33333','','','','course.xml','m','北京',NULL,'other',NULL,1,'',NULL,'st',NULL),(44,56,'sdy111','','','','course.xml','o','北京',NULL,'other',NULL,1,'',NULL,'st',NULL),(45,57,'刘伟','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'st',NULL),(46,58,'sdy121','','','','course.xml','o','北京',NULL,'other',NULL,1,'',NULL,'st',NULL),(47,59,'xiaodun_dev','','','','course.xml','o','null',NULL,'jhs',NULL,1,'',NULL,'st',NULL),(48,60,'xiaodun_pro','','','','course.xml','o','null',NULL,'jhs',NULL,1,'',NULL,'st',NULL),(49,62,'HUALALA_PRO','','','','course.xml','o','null',NULL,'jhs',NULL,1,'',NULL,'st',NULL),(50,64,'HUALALA_PROP','','','','course.xml','o','null',NULL,'jhs',NULL,1,'',NULL,'st',NULL),(51,66,'HUALALA_PROPK','','','','course.xml','o','null',NULL,'jhs',NULL,1,'',NULL,'st',NULL),(52,67,'kaixinhaole','','','','course.xml','o','null',NULL,'other',NULL,1,'',NULL,'st',NULL),(53,70,'开心好了','','','','course.xml','f','阿萨德发色的',1999,'b','阿斯对付撒但',1,'',NULL,'st',NULL),(54,71,'dhk1234567','','','','course.xml','f','天津',NULL,'other',NULL,1,'',NULL,'st',NULL),(55,72,'zhanglaoshi2','','','','course.xml','m','河北',NULL,'other',NULL,1,'',NULL,'st',NULL),(56,73,'zhanglaoshi3','','','','course.xml','m','河北',NULL,'other',NULL,1,'',NULL,'st',NULL),(57,74,'yyyyyyy2','','','','course.xml','o','',NULL,'other',NULL,1,'',NULL,'st',NULL),(58,75,'sunyanho56','','','','course.xml','m','河南',NULL,'other',NULL,1,'',NULL,'st',NULL),(59,76,'sunyanhong','','','','course.xml','f','河南',NULL,'other',NULL,1,'',NULL,'st',NULL),(60,78,'sunyanh890','','','','course.xml','f','河南',NULL,'other',NULL,1,'',NULL,'st',NULL),(61,81,'sunyanok6554','','','','course.xml','m','河南',NULL,'other',NULL,1,'',NULL,'st',NULL),(62,83,'kjsdjad','','','','course.xml','f','河南',NULL,'other',NULL,1,'',NULL,'st',NULL),(63,84,'ksdjkska','','','','course.xml','m','河南',NULL,'other',NULL,1,'',NULL,'st',NULL),(64,85,'shdyufke','','','','course.xml','f','河南',NULL,'other',NULL,1,'',NULL,'st',NULL),(65,86,'sundyh12','','','','course.xml','f','河南',NULL,'other',NULL,1,'',NULL,'st',NULL),(66,92,'suwei34dsf','','','','course.xml','f','天津',NULL,'other',NULL,1,'',NULL,'th',NULL),(67,94,'刘立虎','','','','course.xml','m','',NULL,'other',NULL,1,'',NULL,'st',NULL),(68,95,'hgdsahhds1234','','','','course.xml','m','河南',NULL,'other',NULL,1,'',NULL,'th',NULL),(69,96,'ceshi','','','','course.xml','m','cehsi',2005,'b','ceshi ',1,'',NULL,'st',NULL),(76,108,'ceshishi','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'in',NULL),(77,110,'lishishishis','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'in',NULL),(78,111,'lliuquanrui','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'st',NULL),(79,112,'institu','','','','course.xml',NULL,NULL,NULL,NULL,NULL,1,'',NULL,'in',NULL);
/*!40000 ALTER TABLE `auth_userprofile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulk_email_courseauthorization`
--

DROP TABLE IF EXISTS `bulk_email_courseauthorization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bulk_email_courseauthorization` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` varchar(255) NOT NULL,
  `email_enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `bulk_email_courseauthorization_course_id_4f6cee675bf93275_uniq` (`course_id`),
  KEY `bulk_email_courseauthorization_ff48d8e5` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulk_email_courseauthorization`
--

LOCK TABLES `bulk_email_courseauthorization` WRITE;
/*!40000 ALTER TABLE `bulk_email_courseauthorization` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulk_email_courseauthorization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulk_email_courseemail`
--

DROP TABLE IF EXISTS `bulk_email_courseemail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bulk_email_courseemail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) DEFAULT NULL,
  `slug` varchar(128) NOT NULL,
  `subject` varchar(128) NOT NULL,
  `html_message` longtext,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `course_id` varchar(255) NOT NULL,
  `to_option` varchar(64) NOT NULL,
  `text_message` longtext,
  PRIMARY KEY (`id`),
  KEY `bulk_email_courseemail_901f59e9` (`sender_id`),
  KEY `bulk_email_courseemail_36af87d1` (`slug`),
  KEY `bulk_email_courseemail_ff48d8e5` (`course_id`),
  CONSTRAINT `sender_id_refs_id_5e8b8f9870ed6279` FOREIGN KEY (`sender_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulk_email_courseemail`
--

LOCK TABLES `bulk_email_courseemail` WRITE;
/*!40000 ALTER TABLE `bulk_email_courseemail` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulk_email_courseemail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulk_email_courseemailtemplate`
--

DROP TABLE IF EXISTS `bulk_email_courseemailtemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bulk_email_courseemailtemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `html_template` longtext,
  `plain_template` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulk_email_courseemailtemplate`
--

LOCK TABLES `bulk_email_courseemailtemplate` WRITE;
/*!40000 ALTER TABLE `bulk_email_courseemailtemplate` DISABLE KEYS */;
INSERT INTO `bulk_email_courseemailtemplate` VALUES (1,'<!DOCTYPE html PUBLIC \'-//W3C//DTD XHTML 1.0 Transitional//EN\' \'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\'><html xmlns:fb=\'http://www.facebook.com/2008/fbml\' xmlns:og=\'http://opengraph.org/schema/\'> <head><meta property=\'og:title\' content=\'Update from {course_title}\'/><meta property=\'fb:page_id\' content=\'43929265776\' />        <meta http-equiv=\'Content-Type\' content=\'text/html; charset=UTF-8\'>        <title>Update from {course_title}</title>                    </head>        <body leftmargin=\'0\' marginwidth=\'0\' topmargin=\'0\' marginheight=\'0\' offset=\'0\' style=\'margin: 0;padding: 0;background-color: #ffffff;\'>        <center>            <table align=\'center\' border=\'0\' cellpadding=\'0\' cellspacing=\'0\' height=\'100%\' width=\'100%\' id=\'bodyTable\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;margin: 0;padding: 0;background-color: #ffffff;height: 100% !important;width: 100% !important;\'>                <tr>                   <td align=\'center\' valign=\'top\' id=\'bodyCell\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;margin: 0;padding: 0;border-top: 0;height: 100% !important;width: 100% !important;\'>                        <!-- BEGIN TEMPLATE // -->                        <table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                            <tr>                                <td align=\'center\' valign=\'top\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                    <!-- BEGIN PREHEADER // -->                                    <table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' id=\'templatePreheader\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;background-color: #fcfcfc;border-top: 0;border-bottom: 0;\'>                                        <tr>                                        <td align=\'center\' valign=\'top\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                                <table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'600\' class=\'templateContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                                    <tr>                                                        <td valign=\'top\' class=\'preheaderContainer\' style=\'padding-top: 9px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'><table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' class=\'mcnTextBlock\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>    <tbody class=\'mcnTextBlockOuter\'>        <tr>            <td valign=\'top\' class=\'mcnTextBlockInner\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                <table align=\'left\' border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'366\' class=\'mcnTextContentContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                    <tbody><tr>                                                <td valign=\'top\' class=\'mcnTextContent\' style=\'padding-top: 9px;padding-left: 18px;padding-bottom: 9px;padding-right: 0;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;color: #606060;font-family: Helvetica;font-size: 11px;line-height: 125%;text-align: left;\'>                                                    <br>                        </td>                    </tr>                </tbody></table>                            </td>        </tr>    </tbody></table></td>                                                    </tr>                                                </table>                                            </td>                                                                                    </tr>                                    </table>                                    <!-- // END PREHEADER -->                                </td>                            </tr>                            <tr>                                <td align=\'center\' valign=\'top\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                    <!-- BEGIN HEADER // -->                                    <table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' id=\'templateHeader\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;background-color: #fcfcfc;border-top: 0;border-bottom: 0;\'>                                        <tr>                                            <td align=\'center\' valign=\'top\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                                <table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'600\' class=\'templateContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                                    <tr>                                                        <td valign=\'top\' class=\'headerContainer\' style=\'padding-top: 10px;padding-right: 18px;padding-bottom: 10px;padding-left: 18px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'><table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' class=\'mcnImageBlock\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>    <tbody class=\'mcnImageBlockOuter\'>            <tr>                <td valign=\'top\' style=\'padding: 9px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\' class=\'mcnImageBlockInner\'>                    <table align=\'left\' width=\'100%\' border=\'0\' cellpadding=\'0\' cellspacing=\'0\' class=\'mcnImageContentContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                        <tbody><tr>                            <td class=\'mcnImageContent\' valign=\'top\' style=\'padding-right: 9px;padding-left: 9px;padding-top: 0;padding-bottom: 0;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                                                    <a href=\'http://edx.org\' title=\'\' class=\'\' target=\'_self\' style=\'word-wrap: break-word !important;\'>                                        <img align=\'left\' alt=\'edX\' src=\'http://courses.edx.org/static/images/bulk_email/edXHeaderImage.jpg\' width=\'564.0000152587891\' style=\'max-width: 600px;padding-bottom: 0;display: inline !important;vertical-align: bottom;border: 0;line-height: 100%;outline: none;text-decoration: none;height: auto !important;\' class=\'mcnImage\'>                                    </a>                                                            </td>                        </tr>                    </tbody></table>                </td>            </tr>    </tbody></table><table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' class=\'mcnTextBlock\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>    <tbody class=\'mcnTextBlockOuter\'>        <tr>            <td valign=\'top\' class=\'mcnTextBlockInner\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                <table align=\'left\' border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'599\' class=\'mcnTextContentContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                    <tbody><tr>                                                <td valign=\'top\' class=\'mcnTextContent\' style=\'padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;color: #606060;font-family: Helvetica;font-size: 15px;line-height: 150%;text-align: left;\'>                                                    <div style=\'text-align: right;\'><span style=\'font-size:11px;\'><span style=\'color:#00a0e3;\'>Connect with edX:</span></span> &nbsp;<a href=\'http://facebook.com/edxonline\' target=\'_blank\' style=\'color: #6DC6DD;font-weight: normal;text-decoration: underline;word-wrap: break-word !important;\'><img align=\'none\' height=\'16\' src=\'http://courses.edx.org/static/images/bulk_email/FacebookIcon.png\' style=\'width: 16px;height: 16px;border: 0;line-height: 100%;outline: none;text-decoration: none;\' width=\'16\'></a>&nbsp;&nbsp;<a href=\'http://twitter.com/edxonline\' target=\'_blank\' style=\'color: #6DC6DD;font-weight: normal;text-decoration: underline;word-wrap: break-word !important;\'><img align=\'none\' height=\'16\' src=\'http://courses.edx.org/static/images/bulk_email/TwitterIcon.png\' style=\'width: 16px;height: 16px;border: 0;line-height: 100%;outline: none;text-decoration: none;\' width=\'16\'></a>&nbsp;&nbsp;<a href=\'https://plus.google.com/108235383044095082735\' target=\'_blank\' style=\'color: #6DC6DD;font-weight: normal;text-decoration: underline;word-wrap: break-word !important;\'><img align=\'none\' height=\'16\' src=\'http://courses.edx.org/static/images/bulk_email/GooglePlusIcon.png\' style=\'width: 16px;height: 16px;border: 0;line-height: 100%;outline: none;text-decoration: none;\' width=\'16\'></a>&nbsp;&nbsp;<a href=\'http://www.meetup.com/edX-Communities/\' target=\'_blank\' style=\'color: #6DC6DD;font-weight: normal;text-decoration: underline;word-wrap: break-word !important;\'><img align=\'none\' height=\'16\' src=\'http://courses.edx.org/static/images/bulk_email/MeetupIcon.png\' style=\'width: 16px;height: 16px;border: 0;line-height: 100%;outline: none;text-decoration: none;\' width=\'16\'></a></div>                        </td>                    </tr>                </tbody></table>                            </td>        </tr>    </tbody></table></td>                                                    </tr>                                                </table>                                            </td>                                        </tr>                                    </table>                                    <!-- // END HEADER -->                                </td>                            </tr>                            <tr>                                <td align=\'center\' valign=\'top\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                    <!-- BEGIN BODY // -->                                    <table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' id=\'templateBody\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;background-color: #fcfcfc;border-top: 0;border-bottom: 0;\'>                                        <tr>                                            <td align=\'center\' valign=\'top\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                                <table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'600\' class=\'templateContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                                    <tr>                                                        <td valign=\'top\' class=\'bodyContainer\' style=\'padding-top: 10px;padding-right: 18px;padding-bottom: 10px;padding-left: 18px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'><table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' class=\'mcnCaptionBlock\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>    <tbody class=\'mcnCaptionBlockOuter\'>        <tr>            <td class=\'mcnCaptionBlockInner\' valign=\'top\' style=\'padding: 9px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                <table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' class=\'mcnCaptionLeftContentOuter\' width=\'100%\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>    <tbody><tr>        <td valign=\'top\' class=\'mcnCaptionLeftContentInner\' style=\'padding: 0 9px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>            <table align=\'right\' border=\'0\' cellpadding=\'0\' cellspacing=\'0\' class=\'mcnCaptionLeftImageContentContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                <tbody><tr>                    <td class=\'mcnCaptionLeftImageContent\' valign=\'top\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                                                    <img alt=\'\' src=\'{course_image_url}\' width=\'176\' style=\'max-width: 180px;border: 0;line-height: 100%;outline: none;text-decoration: none;vertical-align: bottom;height: auto !important;\' class=\'mcnImage\'>                                                                </td>                </tr>            </tbody></table>            <table class=\'mcnCaptionLeftTextContentContainer\' align=\'left\' border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'352\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                <tbody><tr>                    <td valign=\'top\' class=\'mcnTextContent\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;color: #606060;font-family: Helvetica;font-size: 14px;line-height: 150%;text-align: left;\'>                        <h3 class=\'null\' style=\'display: block;font-family: Helvetica;font-size: 18px;font-style: normal;font-weight: bold;line-height: 125%;letter-spacing: -.5px;margin: 0;text-align: left;color: #606060 !important;\'><strong style=\'font-size: 22px;\'>{course_title}</strong><br></h3><br>                    </td>                </tr>            </tbody></table>        </td>    </tr></tbody></table>            </td>        </tr>    </tbody></table><table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' class=\'mcnTextBlock\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>    <tbody class=\'mcnTextBlockOuter\'>        <tr>            <td valign=\'top\' class=\'mcnTextBlockInner\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                <table align=\'left\' border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'600\' class=\'mcnTextContentContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                    <tbody><tr>                                                <td valign=\'top\' class=\'mcnTextContent\' style=\'padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;color: #606060;font-family: Helvetica;font-size: 14px;line-height: 150%;text-align: left;\'>                        {{message_body}}                        </td>                    </tr>                </tbody></table>                            </td>        </tr>    </tbody></table><table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' class=\'mcnDividerBlock\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>    <tbody class=\'mcnDividerBlockOuter\'>        <tr>            <td class=\'mcnDividerBlockInner\' style=\'padding: 18px 18px 3px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                <table class=\'mcnDividerContent\' border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' style=\'border-top-width: 1px;border-top-style: solid;border-top-color: #666666;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                    <tbody><tr>                        <td style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                            <span></span>                        </td>                    </tr>                </tbody></table>            </td>        </tr>    </tbody></table><table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' class=\'mcnTextBlock\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>    <tbody class=\'mcnTextBlockOuter\'>        <tr>            <td valign=\'top\' class=\'mcnTextBlockInner\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                <table align=\'left\' border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'600\' class=\'mcnTextContentContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                    <tbody><tr>                                                <td valign=\'top\' class=\'mcnTextContent\' style=\'padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;color: #606060;font-family: Helvetica;font-size: 14px;line-height: 150%;text-align: left;\'>                                                    <div style=\'text-align: right;\'><a href=\'http://facebook.com/edxonline\' target=\'_blank\' style=\'color: #2f73bc;font-weight: normal;text-decoration: underline;word-wrap: break-word !important;\'><img align=\'none\' height=\'16\' src=\'http://courses.edx.org/static/images/bulk_email/FacebookIcon.png\' style=\'width: 16px;height: 16px;border: 0;line-height: 100%;outline: none;text-decoration: none;\' width=\'16\'></a>&nbsp;&nbsp;<a href=\'http://twitter.com/edxonline\' target=\'_blank\' style=\'color: #2f73bc;font-weight: normal;text-decoration: underline;word-wrap: break-word !important;\'><img align=\'none\' height=\'16\' src=\'http://courses.edx.org/static/images/bulk_email/TwitterIcon.png\' style=\'width: 16px;height: 16px;border: 0;line-height: 100%;outline: none;text-decoration: none;\' width=\'16\'></a>&nbsp;&nbsp;<a href=\'https://plus.google.com/108235383044095082735\' target=\'_blank\' style=\'color: #2f73bc;font-weight: normal;text-decoration: underline;word-wrap: break-word !important;\'><img align=\'none\' height=\'16\' src=\'http://courses.edx.org/static/images/bulk_email/GooglePlusIcon.png\' style=\'width: 16px;height: 16px;border: 0;line-height: 100%;outline: none;text-decoration: none;\' width=\'16\'></a>&nbsp; &nbsp;<a href=\'http://www.meetup.com/edX-Communities/\' target=\'_blank\' style=\'color: #2f73bc;font-weight: normal;text-decoration: underline;word-wrap: break-word !important;\'><img align=\'none\' height=\'16\' src=\'http://courses.edx.org/static/images/bulk_email/MeetupIcon.png\' style=\'width: 16px;height: 16px;border: 0;line-height: 100%;outline: none;text-decoration: none;\' width=\'16\'></a></div>                        </td>                    </tr>                </tbody></table>                            </td>        </tr>    </tbody></table></td>                                                    </tr>                                                </table>                                            </td>                                        </tr>                                    </table>                                    <!-- // END BODY -->                                </td>                            </tr>                            <tr>                                <td align=\'center\' valign=\'top\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                    <!-- BEGIN FOOTER // -->                                    <table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' id=\'templateFooter\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;background-color: #9FCFE8;border-top: 0;border-bottom: 0;\'>                                        <tr>                                            <td align=\'center\' valign=\'top\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                                <table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'600\' class=\'templateContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                                    <tr>                                                        <td valign=\'top\' class=\'footerContainer\' style=\'padding-top: 10px;padding-right: 18px;padding-bottom: 10px;padding-left: 18px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'><table border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'100%\' class=\'mcnTextBlock\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>    <tbody class=\'mcnTextBlockOuter\'>        <tr>            <td valign=\'top\' class=\'mcnTextBlockInner\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                                <table align=\'left\' border=\'0\' cellpadding=\'0\' cellspacing=\'0\' width=\'600\' class=\'mcnTextContentContainer\' style=\'border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;\'>                    <tbody><tr>                                                <td valign=\'top\' class=\'mcnTextContent\' style=\'padding-top: 9px;padding-right: 18px;padding-bottom: 9px;padding-left: 18px;border-collapse: collapse;mso-table-lspace: 0pt;mso-table-rspace: 0pt;color: #f2f2f2;font-family: Helvetica;font-size: 11px;line-height: 125%;text-align: left;\'>                                                    <em>Copyright © 2013 edX, All rights reserved.</em><br><br><br>  <b>Our mailing address is:</b><br>  edX<br>  11 Cambridge Center, Suite 101<br>  Cambridge, MA, USA 02142<br><br><br>This email was automatically sent from {platform_name}. <br>You are receiving this email at address {email} because you are enrolled in <a href=\'{course_url}\'>{course_title}</a>.<br>To stop receiving email like this, update your course email settings <a href=\'{account_settings_url}\'>here</a>. <br>                        </td>                    </tr>                </tbody></table>                            </td>        </tr>    </tbody></table></td>                                                    </tr>                                                </table>                                            </td>                                        </tr>                                    </table>                                    <!-- // END FOOTER -->                                </td>                            </tr>                        </table>                        <!-- // END TEMPLATE -->                    </td>                </tr>            </table>        </center>    </body>    </body> </html>','{course_title}\n\n{{message_body}}\r\n----\r\nCopyright 2013 edX, All rights reserved.\r\n----\r\nConnect with edX:\r\nFacebook (http://facebook.com/edxonline)\r\nTwitter (http://twitter.com/edxonline)\r\nGoogle+ (https://plus.google.com/108235383044095082735)\r\nMeetup (http://www.meetup.com/edX-Communities/)\r\n----\r\nThis email was automatically sent from {platform_name}.\r\nYou are receiving this email at address {email} because you are enrolled in {course_title}\r\n(URL: {course_url} ).\r\nTo stop receiving email like this, update your account settings at {account_settings_url}.\r\n');
/*!40000 ALTER TABLE `bulk_email_courseemailtemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bulk_email_optout`
--

DROP TABLE IF EXISTS `bulk_email_optout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bulk_email_optout` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` varchar(255) NOT NULL,
  `user_id` int(11),
  PRIMARY KEY (`id`),
  UNIQUE KEY `bulk_email_optout_course_id_368f7519b2997e1a_uniq` (`course_id`,`user_id`),
  KEY `bulk_email_optout_ff48d8e5` (`course_id`),
  KEY `bulk_email_optout_fbfc09f1` (`user_id`),
  CONSTRAINT `user_id_refs_id_fc2bac99e68e67c` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bulk_email_optout`
--

LOCK TABLES `bulk_email_optout` WRITE;
/*!40000 ALTER TABLE `bulk_email_optout` DISABLE KEYS */;
/*!40000 ALTER TABLE `bulk_email_optout` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `captcha_captchastore`
--

DROP TABLE IF EXISTS `captcha_captchastore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `captcha_captchastore` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `challenge` varchar(32) NOT NULL,
  `response` varchar(32) NOT NULL,
  `hashkey` varchar(40) NOT NULL,
  `expiration` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hashkey` (`hashkey`)
) ENGINE=InnoDB AUTO_INCREMENT=497 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `captcha_captchastore`
--

LOCK TABLES `captcha_captchastore` WRITE;
/*!40000 ALTER TABLE `captcha_captchastore` DISABLE KEYS */;
INSERT INTO `captcha_captchastore` VALUES (427,'TTFD','ttfd','e92a3bda405b9e0105c51f06e63c8085468b161a','2014-09-23 05:44:06'),(428,'DFZP','dfzp','90540f8e50879480076b6de1a62de790088b7899','2014-09-23 05:44:37'),(429,'OWVU','owvu','17e244fa1aef42770bd7d82bfd399a50f96d8d62','2014-09-23 05:44:39'),(430,'AVXT','avxt','7ee484274dea0bbd2b89ea19d9883fbf9634a863','2014-09-24 02:50:11'),(431,'KLXL','klxl','e6d2782dc1b99f1bd5b5bb5dbf39f946a376205f','2014-09-24 03:35:48'),(432,'XDCL','xdcl','93cf4b2c75ceb8de5821707c037ade3b22c8f3bd','2014-09-24 06:08:17'),(433,'ISHP','ishp','6015f563ff98a9a1ed1edbf27667c24e16b3fe1e','2014-09-24 08:06:09'),(434,'ZKBZ','zkbz','dfc64e8e18b71d4d1196eed710f0a530de24b456','2014-09-24 08:06:34'),(435,'CWZO','cwzo','07d8403cac1ff09362a3bcb527548f6bf337be75','2014-09-25 01:16:22'),(436,'TNTY','tnty','b2b7eb5dc94a7f459a065199017b28ecb8443042','2014-09-25 01:25:40'),(437,'ZWYK','zwyk','d84110ed834ba09aa23e3380390f60ee98850574','2014-09-25 01:27:03'),(438,'OWOW','owow','ea55c863c23e0006c6a7f79285c533ac54ddaabe','2014-09-25 01:31:34'),(439,'IQXZ','iqxz','c7dde42a601b4b129c53d374f4e8b8468146abe1','2014-09-25 01:36:39'),(440,'YNQN','ynqn','7146dfbd9f4abe884faff34b6d73325b523ceac4','2014-09-25 01:37:33'),(441,'RYOK','ryok','3ce73cd2ee14c4a2e0fbc42e9aa8aa6d6946f2c8','2014-09-25 01:37:38'),(442,'EPQB','epqb','4343332ebb28047e3b96b2ca2110bcc5b335df0d','2014-09-25 01:39:43'),(443,'FKXA','fkxa','2a8f75983f1762fc80a6fa292d1ec659b1818506','2014-09-25 01:39:50'),(444,'IJHX','ijhx','e3f48bf9dbf30e3b1c22d3376d26c36f35d5b40c','2014-09-25 01:40:10'),(445,'WYFB','wyfb','fd343fe7120fed7ccb0691a8e22b70078d3aced1','2014-09-25 01:41:05'),(446,'MFPZ','mfpz','5f0d96b5a056bfbbbaa773890b606f229dba0238','2014-09-25 01:41:37'),(447,'QYLU','qylu','1bac433ae74b34b6850202b57ac53a4b8797efd8','2014-09-25 01:49:25'),(448,'TYZQ','tyzq','953448e8d969a95f4153c84fd4678a75e0ad43a6','2014-09-25 01:50:12'),(449,'HQTR','hqtr','217b13cf36e5c7b2e7087c17471811c26d17cc1f','2014-09-25 01:50:21'),(450,'SVWZ','svwz','27bbf8cde0c19904f5da67f4ae85aefd32d99c3c','2014-09-25 02:15:59'),(451,'BLDV','bldv','c42695b014803bf68c62e0b50e180266138ef75f','2014-09-25 02:20:59'),(452,'GGAH','ggah','9615b972ffa6a8035c6f00cec6c17bf0cb09f555','2014-09-25 02:53:54'),(453,'OUTX','outx','417ebecd7ab75278a3c609cd96a5cbcb3af9d033','2014-09-25 03:27:26'),(454,'TTOY','ttoy','1765b4b2534c0094fc6555852cd064acc3b033b9','2014-09-25 03:51:48'),(455,'UXTW','uxtw','c08100d997f115fae2599633e6471ae229a4faf1','2014-09-25 09:35:46'),(456,'HMMU','hmmu','a4df376eaf03cf813c354c5cc4e13fb11b62cfe7','2014-09-26 01:42:14'),(457,'RBBN','rbbn','345dfd41b93bd29ace0e31a38c1d1cee6505d7ab','2014-09-26 03:33:36'),(458,'KECL','kecl','a9dc63f020d85c7ab7d9da17e8e00247729786b9','2014-09-26 03:40:59'),(459,'AAZE','aaze','94188234abb3f5ff8ffe69ca24764676c8e58a1c','2014-09-26 06:07:13'),(460,'TXSJ','txsj','a9abf8e25cd33d1b6b05fd4300ea2c28e33271b0','2014-09-26 06:07:23'),(461,'GMYH','gmyh','aac16125899efd37c56df73a7dd6072333a615b2','2014-09-26 10:13:22'),(462,'BMLV','bmlv','f7a2e874cc15d130ff60bc648769038541b3fb77','2014-09-26 10:13:48'),(463,'ISLO','islo','c9bf57b9c39dd20f67bf5dbd7175567ecd89c9d3','2014-09-28 01:08:44'),(464,'CPTD','cptd','5cc04a51069d91418d3fc2235f295f0b5d654ee1','2014-09-28 01:09:15'),(465,'OKKO','okko','8ed59d2102834da1e79ffe8de414db00b1280319','2014-09-28 01:17:51'),(466,'JXGG','jxgg','965e174348994e8731c5b83fcc54c82d4720fc52','2014-09-28 01:33:53'),(467,'EGYN','egyn','32d372bff791998e55e9828ee4cd9c4ea9817230','2014-09-28 01:48:53'),(468,'RRTJ','rrtj','8f2dc948c2434ca52b955130eb492571345d4854','2014-09-28 01:50:38'),(469,'SLXO','slxo','f279bb395267b065f6a7b468f9706c1b022d8283','2014-09-28 01:50:58'),(470,'ZDRM','zdrm','3c7ac0bcc7684cff5f263b66e7dda04844803df1','2014-09-28 01:52:32'),(471,'ZFYE','zfye','9975f67dd453cdb1c33213cf606bd7159ad4714e','2014-09-28 02:01:10'),(472,'LNFB','lnfb','555ad14b365f81a092c487b0d8eb58850d3304c7','2014-09-28 02:52:27'),(473,'JETV','jetv','35e66d3e3fef6fd560cc89b3ec097d775160f22a','2014-09-28 02:58:02'),(474,'VLYZ','vlyz','968d56b0eb2743ddf48f1d617980ad01d518c4d2','2014-09-28 02:59:03'),(475,'DQBH','dqbh','587d40b111f3fd1842828d4f90bcb40b1fc23733','2014-09-28 04:24:19'),(476,'ZYZH','zyzh','47eb501f368ca0f3b20e78776b0dd400fc11f561','2014-09-28 05:23:13'),(477,'SAHO','saho','1bd0b173c95e396860b14a33c15a28dcc5a64607','2014-09-28 05:32:57'),(478,'BWND','bwnd','e7a56d4d5a90b143a701dc13034b075e570ce4b8','2014-09-28 05:41:41'),(479,'XNIH','xnih','31145e866a8e11859ec8694c9da2becbac71fe0e','2014-09-28 05:45:28'),(480,'ANEG','aneg','0409ad0668a61ca769c3c2830c5e36e617df9d82','2014-09-28 05:46:19'),(481,'DZQG','dzqg','4738cfe88470d05cef308c443f9562f64c21da5c','2014-09-28 06:01:07'),(482,'WMKO','wmko','ff773e917b27e9ef0040056ecaed5bd87cb91206','2014-09-28 06:05:08'),(483,'MNNU','mnnu','eb7372717606553c48612b7c4a33327cdc255231','2014-09-28 06:14:40'),(484,'BLNG','blng','6f23b1696363e0fc08aa69e043f88dab55ef32ce','2014-09-28 06:15:15'),(485,'JIPG','jipg','ac62a17a23efdfbffa35cf781139a905eb0c5cee','2014-09-28 06:28:08'),(486,'HLQI','hlqi','4e0c9a5a5e88d22a47d5f9f47262fccb681cf1f8','2014-09-28 06:28:16'),(487,'PZQY','pzqy','4026ea3f54e02969289f25c8d9bdc7c060a9c385','2014-09-28 06:28:21'),(488,'DLHV','dlhv','03d481283e5811214307fb296f64827a246cd348','2014-09-28 06:29:03'),(489,'VGXX','vgxx','7b59a0ecfc6f57d4f2cb0d6b7b519357474c6859','2014-09-28 06:40:05'),(490,'SFIA','sfia','520aecdf7206f848fa81b110721a041e046d7c33','2014-09-28 07:18:26'),(491,'XWIZ','xwiz','8ee8dc46e51fadd4816115fc869b661497d19e16','2014-09-28 07:34:35'),(492,'XFCD','xfcd','3f0bb71f21c5eb1dee4a6245344aeee0683065b6','2014-09-28 07:40:03'),(493,'NTEX','ntex','875bbb91e89a44fdbd41c7c3489f2687198c068c','2014-09-28 07:40:14'),(494,'IEWD','iewd','47570b35b52b4621b0d37b57aa0f6697c64c357a','2014-09-28 08:06:25'),(495,'MCVZ','mcvz','fcb76963827718984a570cd9ae99890697554621','2014-09-28 08:17:46'),(496,'EONM','eonm','fb53fe8e38a4f6b6c7b4f5e383c84b92f9128379','2014-09-28 08:18:04');
/*!40000 ALTER TABLE `captcha_captchastore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `celery_taskmeta`
--

DROP TABLE IF EXISTS `celery_taskmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `celery_taskmeta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL,
  `result` longtext,
  `date_done` datetime NOT NULL,
  `traceback` longtext,
  `hidden` tinyint(1) NOT NULL,
  `meta` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_id` (`task_id`),
  KEY `celery_taskmeta_c91f1bf` (`hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `celery_taskmeta`
--

LOCK TABLES `celery_taskmeta` WRITE;
/*!40000 ALTER TABLE `celery_taskmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `celery_taskmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `celery_tasksetmeta`
--

DROP TABLE IF EXISTS `celery_tasksetmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `celery_tasksetmeta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskset_id` varchar(255) NOT NULL,
  `result` longtext NOT NULL,
  `date_done` datetime NOT NULL,
  `hidden` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taskset_id` (`taskset_id`),
  KEY `celery_tasksetmeta_c91f1bf` (`hidden`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `celery_tasksetmeta`
--

LOCK TABLES `celery_tasksetmeta` WRITE;
/*!40000 ALTER TABLE `celery_tasksetmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `celery_tasksetmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificates_certificatewhitelist`
--

DROP TABLE IF EXISTS `certificates_certificatewhitelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certificates_certificatewhitelist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  `whitelist` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `certificates_certificatewhitelist_fbfc09f1` (`user_id`),
  CONSTRAINT `user_id_refs_id_517c1c6aa7ba9306` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificates_certificatewhitelist`
--

LOCK TABLES `certificates_certificatewhitelist` WRITE;
/*!40000 ALTER TABLE `certificates_certificatewhitelist` DISABLE KEYS */;
INSERT INTO `certificates_certificatewhitelist` VALUES (1,1,'edX/Open_DemoX/edx_demo_course',1),(2,2,'edX/Open_DemoX/edx_demo_course',1),(3,3,'edX/Open_DemoX/edx_demo_course',1);
/*!40000 ALTER TABLE `certificates_certificatewhitelist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificates_generatedcertificate`
--

DROP TABLE IF EXISTS `certificates_generatedcertificate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `certificates_generatedcertificate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `download_url` varchar(128) NOT NULL,
  `grade` varchar(5) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  `key` varchar(32) NOT NULL,
  `distinction` tinyint(1) NOT NULL,
  `status` varchar(32) NOT NULL,
  `verify_uuid` varchar(32) NOT NULL,
  `download_uuid` varchar(32) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `error_reason` varchar(512) NOT NULL,
  `mode` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `certificates_generatedcertifica_course_id_1389f6b2d72f5e78_uniq` (`course_id`,`user_id`),
  KEY `certificates_generatedcertificate_fbfc09f1` (`user_id`),
  CONSTRAINT `user_id_refs_id_6c4fb3478e23bfe2` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificates_generatedcertificate`
--

LOCK TABLES `certificates_generatedcertificate` WRITE;
/*!40000 ALTER TABLE `certificates_generatedcertificate` DISABLE KEYS */;
/*!40000 ALTER TABLE `certificates_generatedcertificate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `circuit_servercircuit`
--

DROP TABLE IF EXISTS `circuit_servercircuit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `circuit_servercircuit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `schematic` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `circuit_servercircuit`
--

LOCK TABLES `circuit_servercircuit` WRITE;
/*!40000 ALTER TABLE `circuit_servercircuit` DISABLE KEYS */;
/*!40000 ALTER TABLE `circuit_servercircuit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_groups_courseusergroup`
--

DROP TABLE IF EXISTS `course_groups_courseusergroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_groups_courseusergroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  `group_type` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`course_id`),
  KEY `course_groups_courseusergroup_ff48d8e5` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_groups_courseusergroup`
--

LOCK TABLES `course_groups_courseusergroup` WRITE;
/*!40000 ALTER TABLE `course_groups_courseusergroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_groups_courseusergroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_groups_courseusergroup_users`
--

DROP TABLE IF EXISTS `course_groups_courseusergroup_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_groups_courseusergroup_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `courseusergroup_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `courseusergroup_id` (`courseusergroup_id`,`user_id`),
  KEY `course_groups_courseusergroup_users_caee1c64` (`courseusergroup_id`),
  KEY `course_groups_courseusergroup_users_fbfc09f1` (`user_id`),
  CONSTRAINT `courseusergroup_id_refs_id_d26180aa` FOREIGN KEY (`courseusergroup_id`) REFERENCES `course_groups_courseusergroup` (`id`),
  CONSTRAINT `user_id_refs_id_bf33b47a` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_groups_courseusergroup_users`
--

LOCK TABLES `course_groups_courseusergroup_users` WRITE;
/*!40000 ALTER TABLE `course_groups_courseusergroup_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_groups_courseusergroup_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_modes_coursemode`
--

DROP TABLE IF EXISTS `course_modes_coursemode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_modes_coursemode` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` varchar(255) NOT NULL,
  `mode_slug` varchar(100) NOT NULL,
  `mode_display_name` varchar(255) NOT NULL,
  `min_price` int(11) NOT NULL,
  `suggested_prices` varchar(255) NOT NULL,
  `currency` varchar(8) NOT NULL,
  `expiration_date` date DEFAULT NULL,
  `expiration_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_modes_coursemode_course_id_69505c92fc09856_uniq` (`course_id`,`currency`,`mode_slug`),
  KEY `course_modes_coursemode_ff48d8e5` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_modes_coursemode`
--

LOCK TABLES `course_modes_coursemode` WRITE;
/*!40000 ALTER TABLE `course_modes_coursemode` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_modes_coursemode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courseware_offlinecomputedgrade`
--

DROP TABLE IF EXISTS `courseware_offlinecomputedgrade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courseware_offlinecomputedgrade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime NOT NULL,
  `gradeset` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `courseware_offlinecomputedgrade_user_id_46133bbd0926078f_uniq` (`user_id`,`course_id`),
  KEY `courseware_offlinecomputedgrade_fbfc09f1` (`user_id`),
  KEY `courseware_offlinecomputedgrade_ff48d8e5` (`course_id`),
  KEY `courseware_offlinecomputedgrade_3216ff68` (`created`),
  KEY `courseware_offlinecomputedgrade_8aac229` (`updated`),
  CONSTRAINT `user_id_refs_id_7b3221f638cf339d` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courseware_offlinecomputedgrade`
--

LOCK TABLES `courseware_offlinecomputedgrade` WRITE;
/*!40000 ALTER TABLE `courseware_offlinecomputedgrade` DISABLE KEYS */;
/*!40000 ALTER TABLE `courseware_offlinecomputedgrade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courseware_offlinecomputedgradelog`
--

DROP TABLE IF EXISTS `courseware_offlinecomputedgradelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courseware_offlinecomputedgradelog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` varchar(255) NOT NULL,
  `created` datetime DEFAULT NULL,
  `seconds` int(11) NOT NULL,
  `nstudents` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `courseware_offlinecomputedgradelog_ff48d8e5` (`course_id`),
  KEY `courseware_offlinecomputedgradelog_3216ff68` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courseware_offlinecomputedgradelog`
--

LOCK TABLES `courseware_offlinecomputedgradelog` WRITE;
/*!40000 ALTER TABLE `courseware_offlinecomputedgradelog` DISABLE KEYS */;
/*!40000 ALTER TABLE `courseware_offlinecomputedgradelog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courseware_studentmodule`
--

DROP TABLE IF EXISTS `courseware_studentmodule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courseware_studentmodule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `module_type` varchar(32) NOT NULL,
  `module_id` varchar(255) NOT NULL,
  `student_id` int(11) NOT NULL,
  `state` longtext,
  `grade` double DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `max_grade` double,
  `done` varchar(8) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `courseware_studentmodule_student_id_635d77aea1256de5_uniq` (`student_id`,`module_id`,`course_id`),
  KEY `courseware_studentmodule_42ff452e` (`student_id`),
  KEY `courseware_studentmodule_3216ff68` (`created`),
  KEY `courseware_studentmodule_6dff86b5` (`grade`),
  KEY `courseware_studentmodule_5436e97a` (`modified`),
  KEY `courseware_studentmodule_2d8768ff` (`module_type`),
  KEY `courseware_studentmodule_f53ed95e` (`module_id`),
  KEY `courseware_studentmodule_1923c03f` (`done`),
  KEY `courseware_studentmodule_ff48d8e5` (`course_id`),
  CONSTRAINT `student_id_refs_id_51af713179ba2570` FOREIGN KEY (`student_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=206 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courseware_studentmodule`
--

LOCK TABLES `courseware_studentmodule` WRITE;
/*!40000 ALTER TABLE `courseware_studentmodule` DISABLE KEYS */;
INSERT INTO `courseware_studentmodule` VALUES (1,'course','i4x://edX/Open_DemoX/course/edx_demo_course',9,'{\"position\": 2}',NULL,'2014-02-26 13:21:30','2014-02-27 02:10:17',NULL,'na','edX/Open_DemoX/edx_demo_course'),(2,'chapter','i4x://edX/Open_DemoX/chapter/d8a6192ade314473a78242dfeedfbf5b',9,'{\"position\": 1}',NULL,'2014-02-26 13:21:30','2014-02-26 13:21:30',NULL,'na','edX/Open_DemoX/edx_demo_course'),(3,'sequential','i4x://edX/Open_DemoX/sequential/edx_introduction',9,'{\"position\": 1}',NULL,'2014-02-26 13:21:30','2014-02-26 13:21:30',NULL,'na','edX/Open_DemoX/edx_demo_course'),(4,'problem','i4x://edX/Open_DemoX/problem/303034da25524878a2e66fb57c91cf85',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-303034da25524878a2e66fb57c91cf85_2_1\": {}}}',NULL,'2014-02-26 13:21:38','2014-02-26 13:21:38',NULL,'na','edX/Open_DemoX/edx_demo_course'),(5,'problem','i4x://edX/Open_DemoX/problem/932e6f2ce8274072a355a94560216d1a',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-932e6f2ce8274072a355a94560216d1a_2_1\": {}}}',NULL,'2014-02-26 13:21:38','2014-02-26 13:21:38',NULL,'na','edX/Open_DemoX/edx_demo_course'),(6,'problem','i4x://edX/Open_DemoX/problem/9cee77a606ea4c1aa5440e0ea5d0f618',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-9cee77a606ea4c1aa5440e0ea5d0f618_2_1\": {}}}',NULL,'2014-02-26 13:21:38','2014-02-26 13:21:38',NULL,'na','edX/Open_DemoX/edx_demo_course'),(7,'problem','i4x://edX/Open_DemoX/problem/0d759dee4f9d459c8956136dbde55f02',9,'{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"correct\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}, \"attempts\": 2, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": \"France\"}}',1,'2014-02-26 13:21:38','2014-02-27 08:52:40',1,'na','edX/Open_DemoX/edx_demo_course'),(8,'problem','i4x://edX/Open_DemoX/problem/75f9562c77bc4858b61f907bb810d974',9,'{\"correct_map\": {}, \"seed\": 1, \"done\": null, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": \"\", \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": \"iuiuy\", \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": \"iuyi\"}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": {}}}',NULL,'2014-02-26 13:21:38','2014-02-27 08:52:21',NULL,'na','edX/Open_DemoX/edx_demo_course'),(9,'problem','i4x://edX/Open_DemoX/problem/Sample_ChemFormula_Problem',9,'{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"msg\": \"\", \"npoints\": 0, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": \"jhjyyuiyuiyuiuyiuy\"}}',0,'2014-02-26 13:21:38','2014-02-27 08:52:14',1,'na','edX/Open_DemoX/edx_demo_course'),(10,'problem','i4x://edX/Open_DemoX/problem/Sample_Algebraic_Problem',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_Algebraic_Problem_2_1\": {}}}',NULL,'2014-02-26 13:21:38','2014-02-26 13:21:38',NULL,'na','edX/Open_DemoX/edx_demo_course'),(11,'problem','i4x://edX/Open_DemoX/problem/a0effb954cca4759994f1ac9e9434bf4',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_2_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_3_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_4_1\": {}}}',NULL,'2014-02-26 13:21:38','2014-02-26 13:21:38',NULL,'na','edX/Open_DemoX/edx_demo_course'),(12,'problem','i4x://edX/Open_DemoX/problem/d2e35c1d294b4ba0b3b1048615605d2a',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d2e35c1d294b4ba0b3b1048615605d2a_2_1\": {}}}',NULL,'2014-02-26 13:21:38','2014-02-26 13:21:38',NULL,'na','edX/Open_DemoX/edx_demo_course'),(13,'problem','i4x://edX/Open_DemoX/problem/c554538a57664fac80783b99d9d6da7c',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}}',NULL,'2014-02-26 13:21:38','2014-02-26 13:21:38',NULL,'na','edX/Open_DemoX/edx_demo_course'),(14,'problem','i4x://edX/Open_DemoX/problem/700x_proteinmake',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_proteinmake_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(15,'problem','i4x://edX/Open_DemoX/problem/logic_gate_problem',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-logic_gate_problem_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(16,'problem','i4x://edX/Open_DemoX/problem/free_form_simulation',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-free_form_simulation_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(17,'problem','i4x://edX/Open_DemoX/problem/python_grader',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-python_grader_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(18,'problem','i4x://edX/Open_DemoX/problem/700x_editmolB',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_editmolB_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(19,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/1c055f72c03641149f2801ea1416ac50',9,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-02-26 13:21:39','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(20,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/90ffcb1647ab4957ab79bec6155bb046',9,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-02-26 13:21:39','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(21,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/Humanities_SA_ML',9,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-02-26 13:21:39','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(22,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/bb10fc2c57fc48b1a6c7228ca9be47ba',9,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-02-26 13:21:39','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(23,'problem','i4x://edX/Open_DemoX/problem/ex_practice_3',9,'{\"seed\": 695, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_3_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(24,'problem','i4x://edX/Open_DemoX/problem/d1b84dcd39b0423d9e288f27f0f7f242',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d1b84dcd39b0423d9e288f27f0f7f242_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(25,'problem','i4x://edX/Open_DemoX/problem/ex_practice_limited_checks',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_limited_checks_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(26,'problem','i4x://edX/Open_DemoX/problem/651e0945b77f42e0a4c89b8c3e6f5b3b',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-651e0945b77f42e0a4c89b8c3e6f5b3b_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(27,'problem','i4x://edX/Open_DemoX/problem/45d46192272c4f6db6b63586520bbdf4',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-45d46192272c4f6db6b63586520bbdf4_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(28,'problem','i4x://edX/Open_DemoX/problem/ex_practice_2',9,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_2_2_1\": {}}}',NULL,'2014-02-26 13:21:39','2014-02-26 13:21:39',NULL,'na','edX/Open_DemoX/edx_demo_course'),(29,'chapter','i4x://edX/Open_DemoX/chapter/interactive_demonstrations',9,'{\"position\": 2}',NULL,'2014-02-27 02:10:17','2014-02-27 02:10:17',NULL,'na','edX/Open_DemoX/edx_demo_course'),(30,'sequential','i4x://edX/Open_DemoX/sequential/basic_questions',9,'{\"position\": 2}',NULL,'2014-02-27 02:10:17','2014-02-27 08:59:04',NULL,'na','edX/Open_DemoX/edx_demo_course'),(31,'course','i4x://TSINGHUA/TSINGHUA101/course/2014_T1',9,'{\"position\": 1}',NULL,'2014-02-27 02:44:21','2014-02-27 02:44:21',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(32,'chapter','i4x://TSINGHUA/TSINGHUA101/chapter/a8420027c37f4c2e877a88a714b529f9',9,'{\"position\": 1}',NULL,'2014-02-27 02:44:21','2014-02-27 02:44:21',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(33,'sequential','i4x://TSINGHUA/TSINGHUA101/sequential/2d8ee83358a7456caf33cf30e9026566',9,'{\"position\": 1}',NULL,'2014-02-27 02:44:21','2014-02-27 02:44:21',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(34,'course','i4x://TSINGHUA/TSINGHUA101/course/2014_T1',11,'{\"position\": 1}',NULL,'2014-02-27 09:03:00','2014-02-27 09:03:00',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(35,'chapter','i4x://TSINGHUA/TSINGHUA101/chapter/a8420027c37f4c2e877a88a714b529f9',11,'{\"position\": 1}',NULL,'2014-02-27 09:03:00','2014-02-27 09:03:00',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(36,'sequential','i4x://TSINGHUA/TSINGHUA101/sequential/2d8ee83358a7456caf33cf30e9026566',11,'{\"position\": 1}',NULL,'2014-02-27 09:03:00','2014-02-27 09:03:00',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(37,'course','i4x://edX/Open_DemoX/course/edx_demo_course',11,'{\"position\": 2}',NULL,'2014-02-27 09:03:19','2014-02-27 09:03:24',NULL,'na','edX/Open_DemoX/edx_demo_course'),(38,'chapter','i4x://edX/Open_DemoX/chapter/d8a6192ade314473a78242dfeedfbf5b',11,'{\"position\": 1}',NULL,'2014-02-27 09:03:19','2014-02-27 09:03:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(39,'sequential','i4x://edX/Open_DemoX/sequential/edx_introduction',11,'{\"position\": 1}',NULL,'2014-02-27 09:03:19','2014-02-27 09:03:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(40,'chapter','i4x://edX/Open_DemoX/chapter/interactive_demonstrations',11,'{\"position\": 2}',NULL,'2014-02-27 09:03:24','2014-02-27 09:03:24',NULL,'na','edX/Open_DemoX/edx_demo_course'),(41,'problem','i4x://edX/Open_DemoX/problem/c554538a57664fac80783b99d9d6da7c',11,'{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"correct\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}, \"attempts\": 4, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": \"[484,206]\"}}',1,'2014-02-27 09:03:24','2014-02-27 09:20:21',1,'na','edX/Open_DemoX/edx_demo_course'),(42,'problem','i4x://edX/Open_DemoX/problem/d2e35c1d294b4ba0b3b1048615605d2a',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d2e35c1d294b4ba0b3b1048615605d2a_2_1\": {}}}',NULL,'2014-02-27 09:03:24','2014-02-27 09:03:24',NULL,'na','edX/Open_DemoX/edx_demo_course'),(43,'problem','i4x://edX/Open_DemoX/problem/a0effb954cca4759994f1ac9e9434bf4',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_2_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_3_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_4_1\": {}}}',NULL,'2014-02-27 09:03:24','2014-02-27 09:03:24',NULL,'na','edX/Open_DemoX/edx_demo_course'),(44,'problem','i4x://edX/Open_DemoX/problem/Sample_Algebraic_Problem',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_Algebraic_Problem_2_1\": {}}}',NULL,'2014-02-27 09:03:24','2014-02-27 09:03:24',NULL,'na','edX/Open_DemoX/edx_demo_course'),(45,'problem','i4x://edX/Open_DemoX/problem/Sample_ChemFormula_Problem',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,'2014-02-27 09:03:24','2014-02-27 09:03:24',NULL,'na','edX/Open_DemoX/edx_demo_course'),(46,'problem','i4x://edX/Open_DemoX/problem/75f9562c77bc4858b61f907bb810d974',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": {}}}',NULL,'2014-02-27 09:03:24','2014-02-27 09:03:24',NULL,'na','edX/Open_DemoX/edx_demo_course'),(47,'problem','i4x://edX/Open_DemoX/problem/0d759dee4f9d459c8956136dbde55f02',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}}',NULL,'2014-02-27 09:03:25','2014-02-27 09:03:25',NULL,'na','edX/Open_DemoX/edx_demo_course'),(48,'sequential','i4x://edX/Open_DemoX/sequential/basic_questions',11,'{\"position\": 7}',NULL,'2014-02-27 09:03:25','2014-02-27 09:20:35',NULL,'na','edX/Open_DemoX/edx_demo_course'),(49,'problem','i4x://edX/Open_DemoX/problem/303034da25524878a2e66fb57c91cf85',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-303034da25524878a2e66fb57c91cf85_2_1\": {}}}',NULL,'2014-02-28 02:04:47','2014-02-28 02:04:47',NULL,'na','edX/Open_DemoX/edx_demo_course'),(50,'problem','i4x://edX/Open_DemoX/problem/932e6f2ce8274072a355a94560216d1a',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-932e6f2ce8274072a355a94560216d1a_2_1\": {}}}',NULL,'2014-02-28 02:04:48','2014-02-28 02:04:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(51,'problem','i4x://edX/Open_DemoX/problem/9cee77a606ea4c1aa5440e0ea5d0f618',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-9cee77a606ea4c1aa5440e0ea5d0f618_2_1\": {}}}',NULL,'2014-02-28 02:04:48','2014-02-28 02:04:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(52,'problem','i4x://edX/Open_DemoX/problem/700x_proteinmake',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_proteinmake_2_1\": {}}}',NULL,'2014-02-28 02:04:48','2014-02-28 02:04:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(53,'problem','i4x://edX/Open_DemoX/problem/logic_gate_problem',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-logic_gate_problem_2_1\": {}}}',NULL,'2014-02-28 02:04:48','2014-02-28 02:04:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(54,'problem','i4x://edX/Open_DemoX/problem/free_form_simulation',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-free_form_simulation_2_1\": {}}}',NULL,'2014-02-28 02:04:48','2014-02-28 02:04:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(55,'problem','i4x://edX/Open_DemoX/problem/python_grader',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-python_grader_2_1\": {}}}',NULL,'2014-02-28 02:04:48','2014-02-28 02:04:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(56,'problem','i4x://edX/Open_DemoX/problem/700x_editmolB',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_editmolB_2_1\": {}}}',NULL,'2014-02-28 02:04:48','2014-02-28 02:04:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(57,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/1c055f72c03641149f2801ea1416ac50',11,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-02-28 02:04:48','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(58,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/90ffcb1647ab4957ab79bec6155bb046',11,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-02-28 02:04:48','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(59,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/Humanities_SA_ML',11,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-02-28 02:04:48','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(60,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/bb10fc2c57fc48b1a6c7228ca9be47ba',11,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-02-28 02:04:48','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(61,'problem','i4x://edX/Open_DemoX/problem/ex_practice_3',11,'{\"seed\": 227, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_3_2_1\": {}}}',NULL,'2014-02-28 02:04:48','2014-02-28 02:04:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(62,'problem','i4x://edX/Open_DemoX/problem/d1b84dcd39b0423d9e288f27f0f7f242',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d1b84dcd39b0423d9e288f27f0f7f242_2_1\": {}}}',NULL,'2014-02-28 02:04:48','2014-02-28 02:04:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(63,'problem','i4x://edX/Open_DemoX/problem/ex_practice_limited_checks',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_limited_checks_2_1\": {}}}',NULL,'2014-02-28 02:04:48','2014-02-28 02:04:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(64,'problem','i4x://edX/Open_DemoX/problem/651e0945b77f42e0a4c89b8c3e6f5b3b',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-651e0945b77f42e0a4c89b8c3e6f5b3b_2_1\": {}}}',NULL,'2014-02-28 02:04:49','2014-02-28 02:04:49',NULL,'na','edX/Open_DemoX/edx_demo_course'),(65,'problem','i4x://edX/Open_DemoX/problem/45d46192272c4f6db6b63586520bbdf4',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-45d46192272c4f6db6b63586520bbdf4_2_1\": {}}}',NULL,'2014-02-28 02:04:49','2014-02-28 02:04:49',NULL,'na','edX/Open_DemoX/edx_demo_course'),(66,'problem','i4x://edX/Open_DemoX/problem/ex_practice_2',11,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_2_2_1\": {}}}',NULL,'2014-02-28 02:04:49','2014-02-28 02:04:49',NULL,'na','edX/Open_DemoX/edx_demo_course'),(67,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/1c055f72c03641149f2801ea1416ac50',4,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-24 02:00:19','2014-09-28 06:14:18',NULL,'na','edX/Open_DemoX/edx_demo_course'),(68,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/90ffcb1647ab4957ab79bec6155bb046',4,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-24 02:00:19','2014-09-28 06:14:18',NULL,'na','edX/Open_DemoX/edx_demo_course'),(69,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/Humanities_SA_ML',4,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-24 02:00:19','2014-09-28 06:14:18',NULL,'na','edX/Open_DemoX/edx_demo_course'),(70,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/bb10fc2c57fc48b1a6c7228ca9be47ba',4,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-24 02:00:19','2014-09-28 06:14:18',NULL,'na','edX/Open_DemoX/edx_demo_course'),(71,'course','i4x://edX/Open_DemoX/course/edx_demo_course',4,'{\"position\": 1}',NULL,'2014-06-27 07:22:28','2014-09-22 01:45:49',NULL,'na','edX/Open_DemoX/edx_demo_course'),(72,'chapter','i4x://edX/Open_DemoX/chapter/d8a6192ade314473a78242dfeedfbf5b',4,'{\"position\": 1}',NULL,'2014-06-27 07:22:28','2014-09-28 01:20:40',NULL,'na','edX/Open_DemoX/edx_demo_course'),(73,'sequential','i4x://edX/Open_DemoX/sequential/edx_introduction',4,'{\"position\": 1}',NULL,'2014-06-27 07:22:28','2014-09-22 09:57:18',NULL,'na','edX/Open_DemoX/edx_demo_course'),(74,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/1c055f72c03641149f2801ea1416ac50',2,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:18','2014-06-27 08:27:13',NULL,'na','edX/Open_DemoX/edx_demo_course'),(75,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/90ffcb1647ab4957ab79bec6155bb046',2,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:18','2014-06-27 08:27:13',NULL,'na','edX/Open_DemoX/edx_demo_course'),(76,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/Humanities_SA_ML',2,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:18','2014-06-27 08:27:13',NULL,'na','edX/Open_DemoX/edx_demo_course'),(77,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/bb10fc2c57fc48b1a6c7228ca9be47ba',2,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:18','2014-06-27 08:27:13',NULL,'na','edX/Open_DemoX/edx_demo_course'),(78,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/1c055f72c03641149f2801ea1416ac50',1,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:19','2014-09-28 03:07:06',NULL,'na','edX/Open_DemoX/edx_demo_course'),(79,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/90ffcb1647ab4957ab79bec6155bb046',1,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:19','2014-09-28 03:07:06',NULL,'na','edX/Open_DemoX/edx_demo_course'),(80,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/Humanities_SA_ML',1,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:19','2014-09-28 03:07:06',NULL,'na','edX/Open_DemoX/edx_demo_course'),(81,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/bb10fc2c57fc48b1a6c7228ca9be47ba',1,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:19','2014-09-28 03:07:06',NULL,'na','edX/Open_DemoX/edx_demo_course'),(82,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/1c055f72c03641149f2801ea1416ac50',3,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:19','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(83,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/90ffcb1647ab4957ab79bec6155bb046',3,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:19','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(84,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/Humanities_SA_ML',3,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:19','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(85,'combinedopenended','i4x://edX/Open_DemoX/combinedopenended/bb10fc2c57fc48b1a6c7228ca9be47ba',3,'{\"ready_to_reset\": false, \"state\": \"assessing\", \"task_states\": [\"{\\\"child_created\\\": false, \\\"child_attempts\\\": 0, \\\"stored_answer\\\": null, \\\"version\\\": 1, \\\"child_history\\\": [], \\\"max_score\\\": 2, \\\"child_state\\\": \\\"initial\\\"}\"], \"current_task_number\": 0, \"student_attempts\": 0}',NULL,'2014-06-27 07:23:19','2014-06-27 07:23:19',NULL,'na','edX/Open_DemoX/edx_demo_course'),(86,'problem','i4x://edX/Open_DemoX/problem/303034da25524878a2e66fb57c91cf85',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-303034da25524878a2e66fb57c91cf85_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(87,'problem','i4x://edX/Open_DemoX/problem/932e6f2ce8274072a355a94560216d1a',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-932e6f2ce8274072a355a94560216d1a_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(88,'problem','i4x://edX/Open_DemoX/problem/9cee77a606ea4c1aa5440e0ea5d0f618',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-9cee77a606ea4c1aa5440e0ea5d0f618_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(89,'problem','i4x://edX/Open_DemoX/problem/0d759dee4f9d459c8956136dbde55f02',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(90,'problem','i4x://edX/Open_DemoX/problem/75f9562c77bc4858b61f907bb810d974',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(91,'problem','i4x://edX/Open_DemoX/problem/Sample_ChemFormula_Problem',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(92,'problem','i4x://edX/Open_DemoX/problem/Sample_Algebraic_Problem',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_Algebraic_Problem_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(93,'problem','i4x://edX/Open_DemoX/problem/a0effb954cca4759994f1ac9e9434bf4',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_2_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_3_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_4_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(94,'problem','i4x://edX/Open_DemoX/problem/d2e35c1d294b4ba0b3b1048615605d2a',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d2e35c1d294b4ba0b3b1048615605d2a_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(95,'problem','i4x://edX/Open_DemoX/problem/c554538a57664fac80783b99d9d6da7c',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(96,'problem','i4x://edX/Open_DemoX/problem/700x_proteinmake',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_proteinmake_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(97,'problem','i4x://edX/Open_DemoX/problem/logic_gate_problem',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-logic_gate_problem_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(98,'problem','i4x://edX/Open_DemoX/problem/free_form_simulation',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-free_form_simulation_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(99,'problem','i4x://edX/Open_DemoX/problem/python_grader',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-python_grader_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(100,'problem','i4x://edX/Open_DemoX/problem/700x_editmolB',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_editmolB_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(101,'problem','i4x://edX/Open_DemoX/problem/ex_practice_3',4,'{\"seed\": 896, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_3_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(102,'problem','i4x://edX/Open_DemoX/problem/d1b84dcd39b0423d9e288f27f0f7f242',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d1b84dcd39b0423d9e288f27f0f7f242_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(103,'problem','i4x://edX/Open_DemoX/problem/ex_practice_limited_checks',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_limited_checks_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(104,'problem','i4x://edX/Open_DemoX/problem/651e0945b77f42e0a4c89b8c3e6f5b3b',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-651e0945b77f42e0a4c89b8c3e6f5b3b_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(105,'problem','i4x://edX/Open_DemoX/problem/45d46192272c4f6db6b63586520bbdf4',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-45d46192272c4f6db6b63586520bbdf4_2_1\": {}}}',NULL,'2014-06-27 07:27:02','2014-06-27 07:27:02',NULL,'na','edX/Open_DemoX/edx_demo_course'),(106,'problem','i4x://edX/Open_DemoX/problem/ex_practice_2',4,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_2_2_1\": {}}}',NULL,'2014-06-27 07:27:03','2014-06-27 07:27:03',NULL,'na','edX/Open_DemoX/edx_demo_course'),(107,'course','i4x://qinghua/10421084X/course/2014',4,'{\"position\": 1}',NULL,'2014-07-03 11:28:28','2014-07-03 11:28:28',NULL,'na','qinghua/10421084X/2014'),(108,'chapter','i4x://qinghua/10421084X/chapter/d477e77d1b784eccbd199ed8c2106d75',4,'{\"position\": 1}',NULL,'2014-07-03 11:28:28','2014-07-03 11:28:28',NULL,'na','qinghua/10421084X/2014'),(109,'sequential','i4x://qinghua/10421084X/sequential/7400f4af28114075ac4eca876ba309db',4,'{\"position\": 1}',NULL,'2014-07-03 11:28:28','2014-07-03 11:28:28',NULL,'na','qinghua/10421084X/2014'),(110,'problem','i4x://TSINGHUA/TSINGHUA101/problem/244f57249d9c484cb3b69eba9aefe876',12,'{\"seed\": 1, \"input_state\": {\"i4x-TSINGHUA-TSINGHUA101-problem-244f57249d9c484cb3b69eba9aefe876_3_1\": {}, \"i4x-TSINGHUA-TSINGHUA101-problem-244f57249d9c484cb3b69eba9aefe876_2_1\": {}}}',NULL,'2014-07-04 02:35:34','2014-07-04 02:35:34',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(111,'problem','i4x://TSINGHUA/TSINGHUA101/problem/b70ad18b92bb4015b081867a26974c8b',12,'{\"seed\": 1, \"input_state\": {\"i4x-TSINGHUA-TSINGHUA101-problem-b70ad18b92bb4015b081867a26974c8b_2_1\": {}}}',NULL,'2014-07-04 02:35:34','2014-07-04 02:35:34',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(112,'problem','i4x://qinghua/10421084X/problem/94ceaf9fbdae400581ffb444fc59b88b',4,'{\"seed\": 1, \"input_state\": {\"i4x-qinghua-10421084X-problem-94ceaf9fbdae400581ffb444fc59b88b_2_1\": {}}}',NULL,'2014-07-04 06:36:09','2014-07-04 06:36:09',NULL,'na','qinghua/10421084X/2014'),(113,'problem','i4x://qinghua/10421084X/problem/eb7d2cc8289f4c57b2c5fb818e248125',4,'{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 3, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,'2014-07-04 06:36:09','2014-09-02 01:59:43',3,'na','qinghua/10421084X/2014'),(114,'course','i4x://TSINGHUA/TSINGHUA101/course/2014_T1',4,'{\"position\": 1}',NULL,'2014-07-04 08:21:57','2014-07-04 08:21:57',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(115,'chapter','i4x://TSINGHUA/TSINGHUA101/chapter/a8420027c37f4c2e877a88a714b529f9',4,'{\"position\": 1}',NULL,'2014-07-04 08:21:57','2014-07-04 09:42:39',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(116,'problem','i4x://TSINGHUA/TSINGHUA101/problem/b70ad18b92bb4015b081867a26974c8b',4,'{\"seed\": 1, \"input_state\": {\"i4x-TSINGHUA-TSINGHUA101-problem-b70ad18b92bb4015b081867a26974c8b_2_1\": {}}}',NULL,'2014-07-04 08:21:57','2014-07-04 08:21:57',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(117,'problem','i4x://TSINGHUA/TSINGHUA101/problem/244f57249d9c484cb3b69eba9aefe876',4,'{\"seed\": 1, \"input_state\": {\"i4x-TSINGHUA-TSINGHUA101-problem-244f57249d9c484cb3b69eba9aefe876_3_1\": {}, \"i4x-TSINGHUA-TSINGHUA101-problem-244f57249d9c484cb3b69eba9aefe876_2_1\": {}}}',NULL,'2014-07-04 08:21:57','2014-07-04 08:21:57',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(118,'sequential','i4x://TSINGHUA/TSINGHUA101/sequential/2d8ee83358a7456caf33cf30e9026566',4,'{\"position\": 2}',NULL,'2014-07-04 08:21:58','2014-07-04 09:42:57',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(119,'sequential','i4x://TSINGHUA/TSINGHUA101/sequential/4e7cdc47ad074908a5d80d63e79e24a7',4,'{\"position\": 1}',NULL,'2014-07-04 09:20:33','2014-07-04 09:20:33',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(120,'sequential','i4x://TSINGHUA/TSINGHUA101/sequential/b600b9c06bbd44bfa96c9129beb8a6d6',4,'{\"position\": 1}',NULL,'2014-07-04 09:37:21','2014-07-04 09:37:21',NULL,'na','TSINGHUA/TSINGHUA101/2014_T1'),(121,'chapter','i4x://edX/Open_DemoX/chapter/interactive_demonstrations',4,'{\"position\": 1}',NULL,'2014-07-07 01:19:26','2014-09-18 06:04:26',NULL,'na','edX/Open_DemoX/edx_demo_course'),(122,'sequential','i4x://edX/Open_DemoX/sequential/19a30717eff543078a5d94ae9d6c18a5',4,'{\"position\": 2}',NULL,'2014-07-07 01:19:27','2014-07-10 06:21:26',NULL,'na','edX/Open_DemoX/edx_demo_course'),(123,'sequential','i4x://edX/Open_DemoX/sequential/basic_questions',4,'{\"position\": 0}',NULL,'2014-07-07 01:19:49','2014-07-08 07:27:48',NULL,'na','edX/Open_DemoX/edx_demo_course'),(124,'sequential','i4x://edX/Open_DemoX/sequential/simulations',4,'{\"position\": 0}',NULL,'2014-07-07 06:42:47','2014-07-08 07:27:49',NULL,'na','edX/Open_DemoX/edx_demo_course'),(125,'sequential','i4x://edX/Open_DemoX/sequential/graded_simulations',4,'{\"position\": 0}',NULL,'2014-07-07 06:42:47','2014-07-08 07:27:49',NULL,'na','edX/Open_DemoX/edx_demo_course'),(126,'sequential','i4x://edX/Open_DemoX/sequential/machine_grading',4,'{\"position\": 0}',NULL,'2014-07-07 06:42:47','2014-07-08 07:27:49',NULL,'na','edX/Open_DemoX/edx_demo_course'),(127,'sequential','i4x://edX/Open_DemoX/sequential/48ecb924d7fe4b66a230137626bfa93e',4,'{\"position\": 0}',NULL,'2014-07-07 06:42:47','2014-07-08 07:27:49',NULL,'na','edX/Open_DemoX/edx_demo_course'),(128,'sequential','i4x://edX/Open_DemoX/sequential/dbe8fc027bcb4fe9afb744d2e8415855',4,'{\"position\": 0}',NULL,'2014-07-07 06:42:47','2014-07-08 07:27:49',NULL,'na','edX/Open_DemoX/edx_demo_course'),(129,'sequential','i4x://edX/Open_DemoX/sequential/workflow',4,'{\"position\": 0}',NULL,'2014-07-07 06:42:47','2014-07-08 07:27:49',NULL,'na','edX/Open_DemoX/edx_demo_course'),(135,'chapter','i4x://edX/Open_DemoX/chapter/1414ffd5143b4b508f739b563ab468b7',4,'{\"position\": 1}',NULL,'2014-07-08 07:25:25','2014-07-08 07:25:25',NULL,'na','edX/Open_DemoX/edx_demo_course'),(136,'course','i4x://edX/Open_DemoX/course/edx_demo_course',1,'{\"position\": 2}',NULL,'2014-07-10 04:08:55','2014-08-27 07:57:31',NULL,'na','edX/Open_DemoX/edx_demo_course'),(137,'chapter','i4x://edX/Open_DemoX/chapter/d8a6192ade314473a78242dfeedfbf5b',1,'{\"position\": 1}',NULL,'2014-07-10 04:08:55','2014-07-10 04:08:55',NULL,'na','edX/Open_DemoX/edx_demo_course'),(138,'sequential','i4x://edX/Open_DemoX/sequential/edx_introduction',1,'{\"position\": 0}',NULL,'2014-07-10 04:08:55','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(139,'sequential','i4x://edX/Open_DemoX/sequential/19a30717eff543078a5d94ae9d6c18a5',1,'{\"position\": 0}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(140,'problem','i4x://edX/Open_DemoX/problem/9cee77a606ea4c1aa5440e0ea5d0f618',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-9cee77a606ea4c1aa5440e0ea5d0f618_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(141,'problem','i4x://edX/Open_DemoX/problem/932e6f2ce8274072a355a94560216d1a',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-932e6f2ce8274072a355a94560216d1a_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(142,'problem','i4x://edX/Open_DemoX/problem/303034da25524878a2e66fb57c91cf85',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-303034da25524878a2e66fb57c91cf85_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(143,'sequential','i4x://edX/Open_DemoX/sequential/basic_questions',1,'{\"position\": 0}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(144,'problem','i4x://edX/Open_DemoX/problem/c554538a57664fac80783b99d9d6da7c',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(145,'problem','i4x://edX/Open_DemoX/problem/d2e35c1d294b4ba0b3b1048615605d2a',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d2e35c1d294b4ba0b3b1048615605d2a_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(146,'problem','i4x://edX/Open_DemoX/problem/a0effb954cca4759994f1ac9e9434bf4',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_2_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_3_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_4_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(147,'problem','i4x://edX/Open_DemoX/problem/Sample_Algebraic_Problem',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_Algebraic_Problem_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(148,'problem','i4x://edX/Open_DemoX/problem/Sample_ChemFormula_Problem',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(149,'problem','i4x://edX/Open_DemoX/problem/75f9562c77bc4858b61f907bb810d974',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(150,'problem','i4x://edX/Open_DemoX/problem/0d759dee4f9d459c8956136dbde55f02',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(151,'sequential','i4x://edX/Open_DemoX/sequential/simulations',1,'{\"position\": 0}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(152,'sequential','i4x://edX/Open_DemoX/sequential/graded_simulations',1,'{\"position\": 0}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(153,'problem','i4x://edX/Open_DemoX/problem/700x_editmolB',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_editmolB_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(154,'problem','i4x://edX/Open_DemoX/problem/python_grader',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-python_grader_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(155,'problem','i4x://edX/Open_DemoX/problem/free_form_simulation',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-free_form_simulation_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(156,'problem','i4x://edX/Open_DemoX/problem/logic_gate_problem',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-logic_gate_problem_2_1\": {}}}',NULL,'2014-07-18 08:12:53','2014-07-18 08:12:53',NULL,'na','edX/Open_DemoX/edx_demo_course'),(157,'problem','i4x://edX/Open_DemoX/problem/700x_proteinmake',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_proteinmake_2_1\": {}}}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(158,'sequential','i4x://edX/Open_DemoX/sequential/machine_grading',1,'{\"position\": 0}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(159,'sequential','i4x://edX/Open_DemoX/sequential/48ecb924d7fe4b66a230137626bfa93e',1,'{\"position\": 0}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(160,'sequential','i4x://edX/Open_DemoX/sequential/dbe8fc027bcb4fe9afb744d2e8415855',1,'{\"position\": 0}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(161,'sequential','i4x://edX/Open_DemoX/sequential/workflow',1,'{\"position\": 0}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(162,'problem','i4x://edX/Open_DemoX/problem/ex_practice_2',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_2_2_1\": {}}}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(163,'problem','i4x://edX/Open_DemoX/problem/45d46192272c4f6db6b63586520bbdf4',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-45d46192272c4f6db6b63586520bbdf4_2_1\": {}}}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(164,'problem','i4x://edX/Open_DemoX/problem/651e0945b77f42e0a4c89b8c3e6f5b3b',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-651e0945b77f42e0a4c89b8c3e6f5b3b_2_1\": {}}}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(165,'problem','i4x://edX/Open_DemoX/problem/ex_practice_limited_checks',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_limited_checks_2_1\": {}}}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(166,'problem','i4x://edX/Open_DemoX/problem/d1b84dcd39b0423d9e288f27f0f7f242',1,'{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d1b84dcd39b0423d9e288f27f0f7f242_2_1\": {}}}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(167,'problem','i4x://edX/Open_DemoX/problem/ex_practice_3',1,'{\"seed\": 818, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_3_2_1\": {}}}',NULL,'2014-07-18 08:12:54','2014-07-18 08:12:54',NULL,'na','edX/Open_DemoX/edx_demo_course'),(168,'chapter','i4x://edX/Open_DemoX/chapter/graded_interactions',4,'{\"position\": 1}',NULL,'2014-08-26 09:30:29','2014-08-26 09:30:29',NULL,'na','edX/Open_DemoX/edx_demo_course'),(169,'chapter','i4x://edX/Open_DemoX/chapter/interactive_demonstrations',1,'{\"position\": 1}',NULL,'2014-08-27 07:57:31','2014-08-27 07:57:31',NULL,'na','edX/Open_DemoX/edx_demo_course'),(170,'video','i4x://edX/Open_DemoX/video/0b9e39477cf34507a7a48f74be381fdd',4,'{\"saved_video_position\": \"00:00:00\"}',NULL,'2014-09-18 07:20:54','2014-09-22 09:57:18',NULL,'na','edX/Open_DemoX/edx_demo_course'),(171,'sequential','i4x://edX/Open_DemoX/sequential/24694ad32fe04e3cb3764e170ca02789',4,'{\"position\": 1}',NULL,'2014-09-28 01:20:30','2014-09-28 01:20:30',NULL,'na','edX/Open_DemoX/edx_demo_course'),(172,'course','i4x://清华大学/TSH_011/course/2014_t4',4,'{\"position\": 3}',NULL,'2014-09-28 02:22:21','2014-09-28 08:29:45',NULL,'na','清华大学/TSH_011/2014_t4'),(173,'chapter','i4x://清华大学/TSH_011/chapter/1148a4303754495da79112ba34125969',4,'{\"position\": 2}',NULL,'2014-09-28 02:22:21','2014-09-28 08:03:04',NULL,'na','清华大学/TSH_011/2014_t4'),(174,'sequential','i4x://清华大学/TSH_011/sequential/5c074d70c10a43c8842b85d4ebeb000c',4,'{\"position\": 1}',NULL,'2014-09-28 02:22:21','2014-09-28 02:22:21',NULL,'na','清华大学/TSH_011/2014_t4'),(175,'chapter','i4x://清华大学/TSH_011/chapter/f24ea76378fd47168ade2b6b40a1fb80',4,'{\"position\": 1}',NULL,'2014-09-28 02:23:58','2014-09-28 02:23:58',NULL,'na','清华大学/TSH_011/2014_t4'),(176,'sequential','i4x://清华大学/TSH_011/sequential/8485a99c474e4b94974079eaad2e25dc',4,'{\"position\": 2}',NULL,'2014-09-28 02:23:58','2014-09-28 08:07:31',NULL,'na','清华大学/TSH_011/2014_t4'),(177,'course','i4x://青花大学/TSH_110/course/2014_t3',4,'{\"position\": 1}',NULL,'2014-09-28 02:25:01','2014-09-28 02:25:01',NULL,'na','青花大学/TSH_110/2014_t3'),(178,'chapter','i4x://青花大学/TSH_110/chapter/a751acc3962b4725ba82d12398858c5b',4,'{\"position\": 1}',NULL,'2014-09-28 02:25:01','2014-09-28 02:25:01',NULL,'na','青花大学/TSH_110/2014_t3'),(179,'sequential','i4x://青花大学/TSH_110/sequential/248c96a1e8e84b3288a44d6218edd32d',4,'{\"position\": 1}',NULL,'2014-09-28 02:25:01','2014-09-28 02:25:01',NULL,'na','青花大学/TSH_110/2014_t3'),(180,'chapter','i4x://清华大学/TSH_011/chapter/f554cdc9ef414efd90dc5b6ef9de6e9a',4,'{\"position\": 1}',NULL,'2014-09-28 02:42:09','2014-09-28 08:29:45',NULL,'na','清华大学/TSH_011/2014_t4'),(181,'problem','i4x://清华大学/TSH_011/problem/41d35605156f4a0bb43ad1251b68e2a4',4,'{\"seed\": 1, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-41d35605156f4a0bb43ad1251b68e2a4_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-41d35605156f4a0bb43ad1251b68e2a4_3_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-41d35605156f4a0bb43ad1251b68e2a4_4_1\": {}}}',NULL,'2014-09-28 02:42:09','2014-09-28 02:42:09',NULL,'na','清华大学/TSH_011/2014_t4'),(182,'sequential','i4x://清华大学/TSH_011/sequential/7be641e3abba4430a2134805b77eadcd',4,'{\"position\": 3}',NULL,'2014-09-28 02:42:09','2014-09-28 08:29:49',NULL,'na','清华大学/TSH_011/2014_t4'),(183,'video','i4x://清华大学/TSH_011/video/9a1178b5863e4cf088bf9c7ec06207a6',4,'{\"saved_video_position\": \"00:00:00\"}',NULL,'2014-09-28 03:01:09','2014-09-28 06:20:03',NULL,'na','清华大学/TSH_011/2014_t4'),(184,'sequential','i4x://清华大学/TSH_011/sequential/13b817e897404c41903216a0d6e7df16',4,'{\"position\": 2}',NULL,'2014-09-28 03:43:04','2014-09-28 04:09:36',NULL,'na','清华大学/TSH_011/2014_t4'),(185,'problem','i4x://清华大学/TSH_011/problem/39e46a1ea4c44facb5f9354c7cebf1a8',4,'{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-39e46a1ea4c44facb5f9354c7cebf1a8_2_1\": {}}, \"student_answers\": {}}',NULL,'2014-09-28 03:55:11','2014-09-28 04:00:13',NULL,'na','清华大学/TSH_011/2014_t4'),(186,'problem','i4x://清华大学/TSH_011/problem/d7a4c26630fb4c7586cc1e440862d64a',4,'{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,'2014-09-28 03:55:11','2014-09-28 04:00:41',NULL,'na','清华大学/TSH_011/2014_t4'),(187,'problem','i4x://清华大学/TSH_011/problem/72608447d91847a5bbd6daa40e7a46ec',4,'{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-72608447d91847a5bbd6daa40e7a46ec_2_1\": {}}, \"student_answers\": {}}',NULL,'2014-09-28 03:55:11','2014-09-28 04:00:51',NULL,'na','清华大学/TSH_011/2014_t4'),(188,'problem','i4x://清华大学/TSH_011/problem/4283c850d5974a83840f3d38d7499af9',4,'{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {}}',NULL,'2014-09-28 03:55:11','2014-09-28 04:09:48',NULL,'na','清华大学/TSH_011/2014_t4'),(189,'sequential','i4x://清华大学/TSH_011/sequential/136879fcc2cd4ddc9a7aaefe0acc77dd',4,'{\"position\": 1}',NULL,'2014-09-28 03:55:11','2014-09-28 03:55:11',NULL,'na','清华大学/TSH_011/2014_t4'),(190,'problem','i4x://清华大学/TSH_011/problem/f348f9fc7a60475f88c281b34bb7a033',4,'{\"correct_map\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {}}, \"attempts\": 3, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": \"choice_ipad\"}}',0,'2014-09-28 03:59:44','2014-09-28 08:04:22',1,'na','清华大学/TSH_011/2014_t4'),(191,'video','i4x://清华大学/TSH_011/video/8d487f3c8fe9455f92bf9cc5992487f2',4,'{\"saved_video_position\": \"00:00:02\"}',NULL,'2014-09-28 04:06:40','2014-09-28 04:06:40',NULL,'na','清华大学/TSH_011/2014_t4'),(193,'course','i4x://diaodiyun/60240013X/course/2014_T4',4,'{\"position\": 1}',NULL,'2014-09-28 05:52:50','2014-09-28 05:52:50',NULL,'na','diaodiyun/60240013X/2014_T4'),(194,'chapter','i4x://diaodiyun/60240013X/chapter/ae00abc256bb4952ae9ad4e1ba8c7c06',4,'{\"position\": 1}',NULL,'2014-09-28 05:52:50','2014-09-28 05:52:50',NULL,'na','diaodiyun/60240013X/2014_T4'),(195,'sequential','i4x://diaodiyun/60240013X/sequential/1e00844772a4424e9cf7fc2f113c148e',4,'{\"position\": 1}',NULL,'2014-09-28 05:52:50','2014-09-28 05:52:50',NULL,'na','diaodiyun/60240013X/2014_T4'),(196,'sequential','i4x://清华大学/TSH_011/sequential/9ff21e0a612d4b778be92a9f4dde1e21',4,'{\"position\": 1}',NULL,'2014-09-28 08:03:04','2014-09-28 08:03:04',NULL,'na','清华大学/TSH_011/2014_t4'),(197,'course','i4x://测试机构/YX_01/course/2014_T1',4,'{\"position\": 1}',NULL,'2014-09-28 08:24:59','2014-09-28 08:24:59',NULL,'na','测试机构/YX_01/2014_T1'),(198,'chapter','i4x://测试机构/YX_01/chapter/0e814c1def964d668c4e0f79fc38bc7c',4,'{\"position\": 1}',NULL,'2014-09-28 08:25:00','2014-09-28 08:25:00',NULL,'na','测试机构/YX_01/2014_T1'),(199,'problem','i4x://测试机构/YX_01/problem/cd435a3079d04818bd71bf20fac4156e',4,'{\"seed\": 1, \"input_state\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-cd435a3079d04818bd71bf20fac4156e_2_1\": {}}}',NULL,'2014-09-28 08:25:00','2014-09-28 08:25:00',NULL,'na','测试机构/YX_01/2014_T1'),(200,'problem','i4x://测试机构/YX_01/problem/42d0895698744e22ad61613feeabdc17',4,'{\"seed\": 1, \"input_state\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-42d0895698744e22ad61613feeabdc17_2_1\": {}}}',NULL,'2014-09-28 08:25:00','2014-09-28 08:25:00',NULL,'na','测试机构/YX_01/2014_T1'),(201,'problem','i4x://测试机构/YX_01/problem/525a121d89f349d79808ed0e47a78e0c',4,'{\"seed\": 1}',NULL,'2014-09-28 08:25:00','2014-09-28 08:25:00',NULL,'na','测试机构/YX_01/2014_T1'),(202,'problem','i4x://测试机构/YX_01/problem/42861de960b04811b79fbd0c1d59ded1',4,'{\"seed\": 1, \"input_state\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-42861de960b04811b79fbd0c1d59ded1_2_1\": {}, \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-42861de960b04811b79fbd0c1d59ded1_3_1\": {}, \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-42861de960b04811b79fbd0c1d59ded1_4_1\": {}}}',NULL,'2014-09-28 08:25:00','2014-09-28 08:25:00',NULL,'na','测试机构/YX_01/2014_T1'),(203,'problem','i4x://测试机构/YX_01/problem/890a0fb6b6ea4bbeb949b694472d69ca',4,'{\"correct_map\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": 0, \"msg\": \"\", \"queuestate\": null}, \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": 0, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_3_1\": {}, \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_3_1\": \"[{\\\"1\\\":\\\"t5_c\\\"}]\", \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_2_1\": \"[{\\\"1\\\":[58,213.546875]},{\\\"3\\\":[302,180.546875]},{\\\"4\\\":[306,173.546875]},{\\\"5\\\":[438,180.546875]},{\\\"6\\\":[199,206.546875]},{\\\"7\\\":[201,182.546875]},{\\\"9\\\":[299,208.546875]},{\\\"10\\\":[547,169.546875]},{\\\"11\\\":[301,191.546875]}]\"}}',0,'2014-09-28 08:25:00','2014-09-28 08:26:46',2,'na','测试机构/YX_01/2014_T1'),(204,'sequential','i4x://测试机构/YX_01/sequential/23cb277a6b66491fa2da516b7c01a529',4,'{\"position\": 1}',NULL,'2014-09-28 08:25:00','2014-09-28 08:25:00',NULL,'na','测试机构/YX_01/2014_T1'),(205,'video','i4x://测试机构/YX_01/video/fc00fb36a8de4691b34845fd45a74f63',4,'{\"saved_video_position\": \"00:00:01\"}',NULL,'2014-09-28 08:25:12','2014-09-28 08:27:38',NULL,'na','测试机构/YX_01/2014_T1');
/*!40000 ALTER TABLE `courseware_studentmodule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courseware_studentmodulehistory`
--

DROP TABLE IF EXISTS `courseware_studentmodulehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courseware_studentmodulehistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_module_id` int(11) NOT NULL,
  `version` varchar(255),
  `created` datetime NOT NULL,
  `state` longtext,
  `grade` double DEFAULT NULL,
  `max_grade` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `courseware_studentmodulehistory_5656f5fe` (`student_module_id`),
  KEY `courseware_studentmodulehistory_659105e4` (`version`),
  KEY `courseware_studentmodulehistory_3216ff68` (`created`),
  CONSTRAINT `student_module_id_refs_id_51904344e48636f4` FOREIGN KEY (`student_module_id`) REFERENCES `courseware_studentmodule` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=293 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courseware_studentmodulehistory`
--

LOCK TABLES `courseware_studentmodulehistory` WRITE;
/*!40000 ALTER TABLE `courseware_studentmodulehistory` DISABLE KEYS */;
INSERT INTO `courseware_studentmodulehistory` VALUES (1,4,NULL,'2014-02-26 13:21:38','{}',NULL,NULL),(2,4,NULL,'2014-02-26 13:21:38','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-303034da25524878a2e66fb57c91cf85_2_1\": {}}}',NULL,NULL),(3,5,NULL,'2014-02-26 13:21:38','{}',NULL,NULL),(4,5,NULL,'2014-02-26 13:21:38','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-932e6f2ce8274072a355a94560216d1a_2_1\": {}}}',NULL,NULL),(5,6,NULL,'2014-02-26 13:21:38','{}',NULL,NULL),(6,6,NULL,'2014-02-26 13:21:38','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-9cee77a606ea4c1aa5440e0ea5d0f618_2_1\": {}}}',NULL,NULL),(7,7,NULL,'2014-02-26 13:21:38','{}',NULL,NULL),(8,7,NULL,'2014-02-26 13:21:38','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}}',NULL,NULL),(9,8,NULL,'2014-02-26 13:21:38','{}',NULL,NULL),(10,8,NULL,'2014-02-26 13:21:38','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": {}}}',NULL,NULL),(11,9,NULL,'2014-02-26 13:21:38','{}',NULL,NULL),(12,9,NULL,'2014-02-26 13:21:38','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(13,10,NULL,'2014-02-26 13:21:38','{}',NULL,NULL),(14,10,NULL,'2014-02-26 13:21:38','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_Algebraic_Problem_2_1\": {}}}',NULL,NULL),(15,11,NULL,'2014-02-26 13:21:38','{}',NULL,NULL),(16,11,NULL,'2014-02-26 13:21:38','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_2_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_3_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_4_1\": {}}}',NULL,NULL),(17,12,NULL,'2014-02-26 13:21:38','{}',NULL,NULL),(18,12,NULL,'2014-02-26 13:21:38','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d2e35c1d294b4ba0b3b1048615605d2a_2_1\": {}}}',NULL,NULL),(19,13,NULL,'2014-02-26 13:21:38','{}',NULL,NULL),(20,13,NULL,'2014-02-26 13:21:38','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}}',NULL,NULL),(21,14,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(22,14,NULL,'2014-02-26 13:21:39','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_proteinmake_2_1\": {}}}',NULL,NULL),(23,15,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(24,15,NULL,'2014-02-26 13:21:39','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-logic_gate_problem_2_1\": {}}}',NULL,NULL),(25,16,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(26,16,NULL,'2014-02-26 13:21:39','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-free_form_simulation_2_1\": {}}}',NULL,NULL),(27,17,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(28,17,NULL,'2014-02-26 13:21:39','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-python_grader_2_1\": {}}}',NULL,NULL),(29,18,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(30,18,NULL,'2014-02-26 13:21:39','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_editmolB_2_1\": {}}}',NULL,NULL),(31,23,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(32,23,NULL,'2014-02-26 13:21:39','{\"seed\": 695, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_3_2_1\": {}}}',NULL,NULL),(33,24,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(34,24,NULL,'2014-02-26 13:21:39','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d1b84dcd39b0423d9e288f27f0f7f242_2_1\": {}}}',NULL,NULL),(35,25,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(36,25,NULL,'2014-02-26 13:21:39','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_limited_checks_2_1\": {}}}',NULL,NULL),(37,26,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(38,26,NULL,'2014-02-26 13:21:39','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-651e0945b77f42e0a4c89b8c3e6f5b3b_2_1\": {}}}',NULL,NULL),(39,27,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(40,27,NULL,'2014-02-26 13:21:39','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-45d46192272c4f6db6b63586520bbdf4_2_1\": {}}}',NULL,NULL),(41,28,NULL,'2014-02-26 13:21:39','{}',NULL,NULL),(42,28,NULL,'2014-02-26 13:21:39','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_2_2_1\": {}}}',NULL,NULL),(43,9,NULL,'2014-02-27 08:52:06','{\"correct_map\": {}, \"student_answers\": {}, \"seed\": 1, \"done\": null, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(44,9,NULL,'2014-02-27 08:52:10','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(45,9,NULL,'2014-02-27 08:52:10','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(46,9,NULL,'2014-02-27 08:52:10','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(47,9,NULL,'2014-02-27 08:52:10','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(48,9,NULL,'2014-02-27 08:52:11','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(49,9,NULL,'2014-02-27 08:52:11','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(50,9,NULL,'2014-02-27 08:52:11','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(51,9,NULL,'2014-02-27 08:52:11','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(52,9,NULL,'2014-02-27 08:52:12','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(53,9,NULL,'2014-02-27 08:52:12','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(54,9,NULL,'2014-02-27 08:52:12','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(55,9,NULL,'2014-02-27 08:52:12','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(56,9,NULL,'2014-02-27 08:52:12','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(57,9,NULL,'2014-02-27 08:52:12','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(58,9,NULL,'2014-02-27 08:52:12','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(59,9,NULL,'2014-02-27 08:52:12','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(60,9,NULL,'2014-02-27 08:52:12','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(61,9,NULL,'2014-02-27 08:52:12','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(62,9,NULL,'2014-02-27 08:52:14','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',0,1),(63,9,NULL,'2014-02-27 08:52:14','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": 0, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": \"jhjyyuiyuiyuiuyiuy\"}}',0,1),(64,9,NULL,'2014-02-27 08:52:14','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"msg\": \"\", \"npoints\": 0, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": \"jhjyyuiyuiyuiuyiuy\"}}',0,1),(65,8,NULL,'2014-02-27 08:52:21','{\"correct_map\": {}, \"seed\": 1, \"done\": null, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": \"\", \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": \"iuiuy\", \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": \"iuyi\"}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": {}}}',NULL,NULL),(66,7,NULL,'2014-02-27 08:52:30','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}}',0,1),(67,7,NULL,'2014-02-27 08:52:30','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": \"tyjyyt\"}}',0,1),(68,7,NULL,'2014-02-27 08:52:31','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": \"tyjyyt\"}}',0,1),(69,7,NULL,'2014-02-27 08:52:40','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": \"tyjyyt\"}}',1,1),(70,7,NULL,'2014-02-27 08:52:40','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"correct\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}, \"attempts\": 2, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": \"France\"}}',1,1),(71,41,NULL,'2014-02-27 09:03:24','{}',NULL,NULL),(72,41,NULL,'2014-02-27 09:03:24','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}}',NULL,NULL),(73,42,NULL,'2014-02-27 09:03:24','{}',NULL,NULL),(74,42,NULL,'2014-02-27 09:03:24','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d2e35c1d294b4ba0b3b1048615605d2a_2_1\": {}}}',NULL,NULL),(75,43,NULL,'2014-02-27 09:03:24','{}',NULL,NULL),(76,43,NULL,'2014-02-27 09:03:24','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_2_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_3_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_4_1\": {}}}',NULL,NULL),(77,44,NULL,'2014-02-27 09:03:24','{}',NULL,NULL),(78,44,NULL,'2014-02-27 09:03:24','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_Algebraic_Problem_2_1\": {}}}',NULL,NULL),(79,45,NULL,'2014-02-27 09:03:24','{}',NULL,NULL),(80,45,NULL,'2014-02-27 09:03:24','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(81,46,NULL,'2014-02-27 09:03:24','{}',NULL,NULL),(82,46,NULL,'2014-02-27 09:03:24','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": {}}}',NULL,NULL),(83,47,NULL,'2014-02-27 09:03:25','{}',NULL,NULL),(84,47,NULL,'2014-02-27 09:03:25','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}}',NULL,NULL),(85,41,NULL,'2014-02-27 09:20:11','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}}',0,1),(86,41,NULL,'2014-02-27 09:20:11','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": \"[38,345]\"}}',0,1),(87,41,NULL,'2014-02-27 09:20:13','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": \"[38,345]\"}}',0,1),(88,41,NULL,'2014-02-27 09:20:13','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}, \"attempts\": 2, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": \"[318,221]\"}}',0,1),(89,41,NULL,'2014-02-27 09:20:14','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}, \"attempts\": 2, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": \"[318,221]\"}}',0,1),(90,41,NULL,'2014-02-27 09:20:14','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}, \"attempts\": 3, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": \"[318,221]\"}}',0,1),(91,41,NULL,'2014-02-27 09:20:16','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}, \"attempts\": 3, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": \"[318,221]\"}}',0,1),(92,41,NULL,'2014-02-27 09:20:21','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}, \"attempts\": 3, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": \"[318,221]\"}}',1,1),(93,41,NULL,'2014-02-27 09:20:21','{\"correct_map\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"correct\", \"msg\": \"\", \"npoints\": null, \"queuestate\": null}}, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}, \"attempts\": 4, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": \"[484,206]\"}}',1,1),(94,49,NULL,'2014-02-28 02:04:47','{}',NULL,NULL),(95,49,NULL,'2014-02-28 02:04:47','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-303034da25524878a2e66fb57c91cf85_2_1\": {}}}',NULL,NULL),(96,50,NULL,'2014-02-28 02:04:48','{}',NULL,NULL),(97,50,NULL,'2014-02-28 02:04:48','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-932e6f2ce8274072a355a94560216d1a_2_1\": {}}}',NULL,NULL),(98,51,NULL,'2014-02-28 02:04:48','{}',NULL,NULL),(99,51,NULL,'2014-02-28 02:04:48','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-9cee77a606ea4c1aa5440e0ea5d0f618_2_1\": {}}}',NULL,NULL),(100,52,NULL,'2014-02-28 02:04:48','{}',NULL,NULL),(101,52,NULL,'2014-02-28 02:04:48','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_proteinmake_2_1\": {}}}',NULL,NULL),(102,53,NULL,'2014-02-28 02:04:48','{}',NULL,NULL),(103,53,NULL,'2014-02-28 02:04:48','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-logic_gate_problem_2_1\": {}}}',NULL,NULL),(104,54,NULL,'2014-02-28 02:04:48','{}',NULL,NULL),(105,54,NULL,'2014-02-28 02:04:48','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-free_form_simulation_2_1\": {}}}',NULL,NULL),(106,55,NULL,'2014-02-28 02:04:48','{}',NULL,NULL),(107,55,NULL,'2014-02-28 02:04:48','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-python_grader_2_1\": {}}}',NULL,NULL),(108,56,NULL,'2014-02-28 02:04:48','{}',NULL,NULL),(109,56,NULL,'2014-02-28 02:04:48','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_editmolB_2_1\": {}}}',NULL,NULL),(110,61,NULL,'2014-02-28 02:04:48','{}',NULL,NULL),(111,61,NULL,'2014-02-28 02:04:48','{\"seed\": 227, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_3_2_1\": {}}}',NULL,NULL),(112,62,NULL,'2014-02-28 02:04:48','{}',NULL,NULL),(113,62,NULL,'2014-02-28 02:04:48','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d1b84dcd39b0423d9e288f27f0f7f242_2_1\": {}}}',NULL,NULL),(114,63,NULL,'2014-02-28 02:04:48','{}',NULL,NULL),(115,63,NULL,'2014-02-28 02:04:48','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_limited_checks_2_1\": {}}}',NULL,NULL),(116,64,NULL,'2014-02-28 02:04:49','{}',NULL,NULL),(117,64,NULL,'2014-02-28 02:04:49','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-651e0945b77f42e0a4c89b8c3e6f5b3b_2_1\": {}}}',NULL,NULL),(118,65,NULL,'2014-02-28 02:04:49','{}',NULL,NULL),(119,65,NULL,'2014-02-28 02:04:49','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-45d46192272c4f6db6b63586520bbdf4_2_1\": {}}}',NULL,NULL),(120,66,NULL,'2014-02-28 02:04:49','{}',NULL,NULL),(121,66,NULL,'2014-02-28 02:04:49','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_2_2_1\": {}}}',NULL,NULL),(122,86,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(123,86,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-303034da25524878a2e66fb57c91cf85_2_1\": {}}}',NULL,NULL),(124,87,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(125,87,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-932e6f2ce8274072a355a94560216d1a_2_1\": {}}}',NULL,NULL),(126,88,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(127,88,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-9cee77a606ea4c1aa5440e0ea5d0f618_2_1\": {}}}',NULL,NULL),(128,89,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(129,89,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}}',NULL,NULL),(130,90,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(131,90,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": {}}}',NULL,NULL),(132,91,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(133,91,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(134,92,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(135,92,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_Algebraic_Problem_2_1\": {}}}',NULL,NULL),(136,93,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(137,93,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_2_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_3_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_4_1\": {}}}',NULL,NULL),(138,94,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(139,94,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d2e35c1d294b4ba0b3b1048615605d2a_2_1\": {}}}',NULL,NULL),(140,95,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(141,95,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}}',NULL,NULL),(142,96,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(143,96,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_proteinmake_2_1\": {}}}',NULL,NULL),(144,97,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(145,97,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-logic_gate_problem_2_1\": {}}}',NULL,NULL),(146,98,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(147,98,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-free_form_simulation_2_1\": {}}}',NULL,NULL),(148,99,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(149,99,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-python_grader_2_1\": {}}}',NULL,NULL),(150,100,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(151,100,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_editmolB_2_1\": {}}}',NULL,NULL),(152,101,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(153,101,NULL,'2014-06-27 07:27:02','{\"seed\": 896, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_3_2_1\": {}}}',NULL,NULL),(154,102,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(155,102,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d1b84dcd39b0423d9e288f27f0f7f242_2_1\": {}}}',NULL,NULL),(156,103,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(157,103,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_limited_checks_2_1\": {}}}',NULL,NULL),(158,104,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(159,104,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-651e0945b77f42e0a4c89b8c3e6f5b3b_2_1\": {}}}',NULL,NULL),(160,105,NULL,'2014-06-27 07:27:02','{}',NULL,NULL),(161,105,NULL,'2014-06-27 07:27:02','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-45d46192272c4f6db6b63586520bbdf4_2_1\": {}}}',NULL,NULL),(162,106,NULL,'2014-06-27 07:27:03','{}',NULL,NULL),(163,106,NULL,'2014-06-27 07:27:03','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_2_2_1\": {}}}',NULL,NULL),(164,110,NULL,'2014-07-04 02:35:34','{}',NULL,NULL),(165,110,NULL,'2014-07-04 02:35:34','{\"seed\": 1, \"input_state\": {\"i4x-TSINGHUA-TSINGHUA101-problem-244f57249d9c484cb3b69eba9aefe876_3_1\": {}, \"i4x-TSINGHUA-TSINGHUA101-problem-244f57249d9c484cb3b69eba9aefe876_2_1\": {}}}',NULL,NULL),(166,111,NULL,'2014-07-04 02:35:34','{}',NULL,NULL),(167,111,NULL,'2014-07-04 02:35:34','{\"seed\": 1, \"input_state\": {\"i4x-TSINGHUA-TSINGHUA101-problem-b70ad18b92bb4015b081867a26974c8b_2_1\": {}}}',NULL,NULL),(168,112,NULL,'2014-07-04 06:36:09','{}',NULL,NULL),(169,112,NULL,'2014-07-04 06:36:09','{\"seed\": 1, \"input_state\": {\"i4x-qinghua-10421084X-problem-94ceaf9fbdae400581ffb444fc59b88b_2_1\": {}}}',NULL,NULL),(170,113,NULL,'2014-07-04 06:36:09','{}',NULL,NULL),(171,113,NULL,'2014-07-04 06:36:09','{\"seed\": 1, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}}',NULL,NULL),(172,113,NULL,'2014-07-04 06:41:05','{\"correct_map\": {}, \"seed\": 1, \"done\": null, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(173,113,NULL,'2014-07-04 06:41:06','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(174,113,NULL,'2014-07-04 06:41:08','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(175,113,NULL,'2014-07-04 06:41:08','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(176,113,NULL,'2014-07-04 06:41:15','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(177,113,NULL,'2014-07-04 06:41:15','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(178,113,NULL,'2014-07-04 06:41:15','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(179,113,NULL,'2014-07-04 06:41:16','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(180,113,NULL,'2014-07-04 06:41:16','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(181,113,NULL,'2014-07-04 06:41:18','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(182,113,NULL,'2014-07-04 06:41:18','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(183,113,NULL,'2014-07-04 07:42:08','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',NULL,NULL),(184,113,NULL,'2014-07-04 07:44:15','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"student_answers\": {}}',0,3),(185,113,NULL,'2014-07-04 07:44:15','{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,3),(186,116,NULL,'2014-07-04 08:21:57','{}',NULL,NULL),(187,116,NULL,'2014-07-04 08:21:57','{\"seed\": 1, \"input_state\": {\"i4x-TSINGHUA-TSINGHUA101-problem-b70ad18b92bb4015b081867a26974c8b_2_1\": {}}}',NULL,NULL),(188,117,NULL,'2014-07-04 08:21:57','{}',NULL,NULL),(189,117,NULL,'2014-07-04 08:21:57','{\"seed\": 1, \"input_state\": {\"i4x-TSINGHUA-TSINGHUA101-problem-244f57249d9c484cb3b69eba9aefe876_3_1\": {}, \"i4x-TSINGHUA-TSINGHUA101-problem-244f57249d9c484cb3b69eba9aefe876_2_1\": {}}}',NULL,NULL),(190,113,NULL,'2014-07-04 08:29:08','{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,3),(191,113,NULL,'2014-07-04 08:29:19','{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,3),(192,113,NULL,'2014-07-04 08:29:19','{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 2, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,3),(193,113,NULL,'2014-07-04 08:29:20','{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 2, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,3),(194,113,NULL,'2014-07-04 08:29:33','{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 2, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,3),(195,113,NULL,'2014-07-10 05:55:07','{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 2, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,3),(196,113,NULL,'2014-07-10 05:55:07','{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 3, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,3),(197,113,NULL,'2014-07-10 05:55:08','{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 3, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,3),(198,140,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(199,140,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-9cee77a606ea4c1aa5440e0ea5d0f618_2_1\": {}}}',NULL,NULL),(200,141,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(201,141,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-932e6f2ce8274072a355a94560216d1a_2_1\": {}}}',NULL,NULL),(202,142,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(203,142,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-303034da25524878a2e66fb57c91cf85_2_1\": {}}}',NULL,NULL),(204,144,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(205,144,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-c554538a57664fac80783b99d9d6da7c_2_1\": {}}}',NULL,NULL),(206,145,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(207,145,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d2e35c1d294b4ba0b3b1048615605d2a_2_1\": {}}}',NULL,NULL),(208,146,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(209,146,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_2_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_3_1\": {}, \"i4x-edX-Open_DemoX-problem-a0effb954cca4759994f1ac9e9434bf4_4_1\": {}}}',NULL,NULL),(210,147,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(211,147,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_Algebraic_Problem_2_1\": {}}}',NULL,NULL),(212,148,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(213,148,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-Sample_ChemFormula_Problem_2_1\": {}}}',NULL,NULL),(214,149,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(215,149,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_4_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_2_1\": {}, \"i4x-edX-Open_DemoX-problem-75f9562c77bc4858b61f907bb810d974_3_1\": {}}}',NULL,NULL),(216,150,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(217,150,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-0d759dee4f9d459c8956136dbde55f02_2_1\": {}}}',NULL,NULL),(218,153,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(219,153,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_editmolB_2_1\": {}}}',NULL,NULL),(220,154,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(221,154,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-python_grader_2_1\": {}}}',NULL,NULL),(222,155,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(223,155,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-free_form_simulation_2_1\": {}}}',NULL,NULL),(224,156,NULL,'2014-07-18 08:12:53','{}',NULL,NULL),(225,156,NULL,'2014-07-18 08:12:53','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-logic_gate_problem_2_1\": {}}}',NULL,NULL),(226,157,NULL,'2014-07-18 08:12:54','{}',NULL,NULL),(227,157,NULL,'2014-07-18 08:12:54','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-700x_proteinmake_2_1\": {}}}',NULL,NULL),(228,162,NULL,'2014-07-18 08:12:54','{}',NULL,NULL),(229,162,NULL,'2014-07-18 08:12:54','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_2_2_1\": {}}}',NULL,NULL),(230,163,NULL,'2014-07-18 08:12:54','{}',NULL,NULL),(231,163,NULL,'2014-07-18 08:12:54','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-45d46192272c4f6db6b63586520bbdf4_2_1\": {}}}',NULL,NULL),(232,164,NULL,'2014-07-18 08:12:54','{}',NULL,NULL),(233,164,NULL,'2014-07-18 08:12:54','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-651e0945b77f42e0a4c89b8c3e6f5b3b_2_1\": {}}}',NULL,NULL),(234,165,NULL,'2014-07-18 08:12:54','{}',NULL,NULL),(235,165,NULL,'2014-07-18 08:12:54','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_limited_checks_2_1\": {}}}',NULL,NULL),(236,166,NULL,'2014-07-18 08:12:54','{}',NULL,NULL),(237,166,NULL,'2014-07-18 08:12:54','{\"seed\": 1, \"input_state\": {\"i4x-edX-Open_DemoX-problem-d1b84dcd39b0423d9e288f27f0f7f242_2_1\": {}}}',NULL,NULL),(238,167,NULL,'2014-07-18 08:12:54','{}',NULL,NULL),(239,167,NULL,'2014-07-18 08:12:54','{\"seed\": 818, \"input_state\": {\"i4x-edX-Open_DemoX-problem-ex_practice_3_2_1\": {}}}',NULL,NULL),(240,113,NULL,'2014-09-02 01:59:43','{\"correct_map\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": {}, \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": {}}, \"attempts\": 3, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_4_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_2_1\": \"\", \"i4x-qinghua-10421084X-problem-eb7d2cc8289f4c57b2c5fb818e248125_3_1\": \"\"}}',0,3),(241,181,NULL,'2014-09-28 02:42:09','{}',NULL,NULL),(242,181,NULL,'2014-09-28 02:42:09','{\"seed\": 1, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-41d35605156f4a0bb43ad1251b68e2a4_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-41d35605156f4a0bb43ad1251b68e2a4_3_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-41d35605156f4a0bb43ad1251b68e2a4_4_1\": {}}}',NULL,NULL),(243,185,NULL,'2014-09-28 03:55:11','{}',NULL,NULL),(244,185,NULL,'2014-09-28 03:55:11','{\"seed\": 1, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-39e46a1ea4c44facb5f9354c7cebf1a8_2_1\": {}}}',NULL,NULL),(245,186,NULL,'2014-09-28 03:55:11','{}',NULL,NULL),(246,186,NULL,'2014-09-28 03:55:11','{\"seed\": 1, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(247,187,NULL,'2014-09-28 03:55:11','{}',NULL,NULL),(248,187,NULL,'2014-09-28 03:55:11','{\"seed\": 1, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-72608447d91847a5bbd6daa40e7a46ec_2_1\": {}}}',NULL,NULL),(249,188,NULL,'2014-09-28 03:55:11','{}',NULL,NULL),(250,188,NULL,'2014-09-28 03:55:11','{\"seed\": 1}',NULL,NULL),(251,186,NULL,'2014-09-28 03:55:17','{\"correct_map\": {}, \"student_answers\": {}, \"seed\": 1, \"done\": null, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(252,185,NULL,'2014-09-28 03:55:19','{\"correct_map\": {}, \"seed\": 1, \"done\": null, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-39e46a1ea4c44facb5f9354c7cebf1a8_2_1\": {}}, \"student_answers\": {}}',NULL,NULL),(253,187,NULL,'2014-09-28 03:55:24','{\"correct_map\": {}, \"seed\": 1, \"done\": null, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-72608447d91847a5bbd6daa40e7a46ec_2_1\": {}}, \"student_answers\": {}}',NULL,NULL),(254,188,NULL,'2014-09-28 03:55:26','{\"correct_map\": {}, \"seed\": 1, \"done\": null, \"student_answers\": {}, \"input_state\": {}}',NULL,NULL),(255,190,NULL,'2014-09-28 03:59:44','{}',NULL,NULL),(256,190,NULL,'2014-09-28 03:59:44','{\"seed\": 1, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {}}}',NULL,NULL),(257,185,NULL,'2014-09-28 04:00:13','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-39e46a1ea4c44facb5f9354c7cebf1a8_2_1\": {}}, \"student_answers\": {}}',NULL,NULL),(258,186,NULL,'2014-09-28 04:00:27','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(259,186,NULL,'2014-09-28 04:00:27','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(260,186,NULL,'2014-09-28 04:00:27','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(261,186,NULL,'2014-09-28 04:00:27','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(262,186,NULL,'2014-09-28 04:00:32','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(263,186,NULL,'2014-09-28 04:00:33','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(264,186,NULL,'2014-09-28 04:00:33','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(265,186,NULL,'2014-09-28 04:00:33','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(266,186,NULL,'2014-09-28 04:00:33','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(267,186,NULL,'2014-09-28 04:00:33','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(268,186,NULL,'2014-09-28 04:00:34','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(269,186,NULL,'2014-09-28 04:00:38','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(270,186,NULL,'2014-09-28 04:00:39','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(271,186,NULL,'2014-09-28 04:00:41','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_4_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_2_1\": {}, \"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-d7a4c26630fb4c7586cc1e440862d64a_3_1\": {}}}',NULL,NULL),(272,187,NULL,'2014-09-28 04:00:51','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-72608447d91847a5bbd6daa40e7a46ec_2_1\": {}}, \"student_answers\": {}}',NULL,NULL),(273,188,NULL,'2014-09-28 04:09:48','{\"correct_map\": {}, \"seed\": 1, \"done\": false, \"student_answers\": {}, \"input_state\": {}}',NULL,NULL),(274,190,NULL,'2014-09-28 08:04:18','{\"seed\": 1, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {}}}',0,1),(275,190,NULL,'2014-09-28 08:04:18','{\"correct_map\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": \"choice_beatles\"}}',0,1),(276,190,NULL,'2014-09-28 08:04:20','{\"correct_map\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": \"choice_beatles\"}}',0,1),(277,190,NULL,'2014-09-28 08:04:20','{\"correct_map\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {}}, \"attempts\": 2, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": \"choice_ipad\"}}',0,1),(278,190,NULL,'2014-09-28 08:04:22','{\"correct_map\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {}}, \"attempts\": 2, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": \"choice_ipad\"}}',0,1),(279,190,NULL,'2014-09-28 08:04:22','{\"correct_map\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {}}, \"attempts\": 3, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": \"choice_ipad\"}}',0,1),(280,190,NULL,'2014-09-28 08:04:22','{\"correct_map\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": null, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": {}}, \"attempts\": 3, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-\\u6e05\\u534e\\u5927\\u5b66-TSH_011-problem-f348f9fc7a60475f88c281b34bb7a033_2_1\": \"choice_ipad\"}}',0,1),(281,199,NULL,'2014-09-28 08:25:00','{}',NULL,NULL),(282,199,NULL,'2014-09-28 08:25:00','{\"seed\": 1, \"input_state\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-cd435a3079d04818bd71bf20fac4156e_2_1\": {}}}',NULL,NULL),(283,200,NULL,'2014-09-28 08:25:00','{}',NULL,NULL),(284,200,NULL,'2014-09-28 08:25:00','{\"seed\": 1, \"input_state\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-42d0895698744e22ad61613feeabdc17_2_1\": {}}}',NULL,NULL),(285,201,NULL,'2014-09-28 08:25:00','{}',NULL,NULL),(286,201,NULL,'2014-09-28 08:25:00','{\"seed\": 1}',NULL,NULL),(287,202,NULL,'2014-09-28 08:25:00','{}',NULL,NULL),(288,202,NULL,'2014-09-28 08:25:00','{\"seed\": 1, \"input_state\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-42861de960b04811b79fbd0c1d59ded1_2_1\": {}, \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-42861de960b04811b79fbd0c1d59ded1_3_1\": {}, \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-42861de960b04811b79fbd0c1d59ded1_4_1\": {}}}',NULL,NULL),(289,203,NULL,'2014-09-28 08:25:00','{}',NULL,NULL),(290,203,NULL,'2014-09-28 08:25:00','{\"seed\": 1, \"input_state\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_3_1\": {}, \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_2_1\": {}}}',NULL,NULL),(291,203,NULL,'2014-09-28 08:26:46','{\"seed\": 1, \"input_state\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_3_1\": {}, \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_2_1\": {}}}',0,2),(292,203,NULL,'2014-09-28 08:26:46','{\"correct_map\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_3_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": 0, \"msg\": \"\", \"queuestate\": null}, \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_2_1\": {\"hint\": \"\", \"hintmode\": null, \"correctness\": \"incorrect\", \"npoints\": 0, \"msg\": \"\", \"queuestate\": null}}, \"input_state\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_3_1\": {}, \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_2_1\": {}}, \"attempts\": 1, \"seed\": 1, \"done\": true, \"student_answers\": {\"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_3_1\": \"[{\\\"1\\\":\\\"t5_c\\\"}]\", \"i4x-\\u6d4b\\u8bd5\\u673a\\u6784-YX_01-problem-890a0fb6b6ea4bbeb949b694472d69ca_2_1\": \"[{\\\"1\\\":[58,213.546875]},{\\\"3\\\":[302,180.546875]},{\\\"4\\\":[306,173.546875]},{\\\"5\\\":[438,180.546875]},{\\\"6\\\":[199,206.546875]},{\\\"7\\\":[201,182.546875]},{\\\"9\\\":[299,208.546875]},{\\\"10\\\":[547,169.546875]},{\\\"11\\\":[301,191.546875]}]\"}}',0,2);
/*!40000 ALTER TABLE `courseware_studentmodulehistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courseware_xmodulestudentinfofield`
--

DROP TABLE IF EXISTS `courseware_xmodulestudentinfofield`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courseware_xmodulestudentinfofield` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `field_name` varchar(64) NOT NULL,
  `value` longtext NOT NULL,
  `student_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `courseware_xmodulestudentinfof_student_id_33f2f772c49db067_uniq` (`student_id`,`field_name`),
  KEY `courseware_xmodulestudentinfofield_7e1499` (`field_name`),
  KEY `courseware_xmodulestudentinfofield_42ff452e` (`student_id`),
  KEY `courseware_xmodulestudentinfofield_3216ff68` (`created`),
  KEY `courseware_xmodulestudentinfofield_5436e97a` (`modified`),
  CONSTRAINT `student_id_refs_id_66e06928bfcfbe68` FOREIGN KEY (`student_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courseware_xmodulestudentinfofield`
--

LOCK TABLES `courseware_xmodulestudentinfofield` WRITE;
/*!40000 ALTER TABLE `courseware_xmodulestudentinfofield` DISABLE KEYS */;
/*!40000 ALTER TABLE `courseware_xmodulestudentinfofield` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courseware_xmodulestudentprefsfield`
--

DROP TABLE IF EXISTS `courseware_xmodulestudentprefsfield`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courseware_xmodulestudentprefsfield` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `field_name` varchar(64) NOT NULL,
  `module_type` varchar(64) NOT NULL,
  `value` longtext NOT NULL,
  `student_id` int(11) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `courseware_xmodulestudentprefs_student_id_2a5d275498b7a407_uniq` (`student_id`,`module_type`,`field_name`),
  KEY `courseware_xmodulestudentprefsfield_7e1499` (`field_name`),
  KEY `courseware_xmodulestudentprefsfield_2d8768ff` (`module_type`),
  KEY `courseware_xmodulestudentprefsfield_42ff452e` (`student_id`),
  KEY `courseware_xmodulestudentprefsfield_3216ff68` (`created`),
  KEY `courseware_xmodulestudentprefsfield_5436e97a` (`modified`),
  CONSTRAINT `student_id_refs_id_32bbaa45d7b9940b` FOREIGN KEY (`student_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courseware_xmodulestudentprefsfield`
--

LOCK TABLES `courseware_xmodulestudentprefsfield` WRITE;
/*!40000 ALTER TABLE `courseware_xmodulestudentprefsfield` DISABLE KEYS */;
/*!40000 ALTER TABLE `courseware_xmodulestudentprefsfield` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courseware_xmoduleuserstatesummaryfield`
--

DROP TABLE IF EXISTS `courseware_xmoduleuserstatesummaryfield`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courseware_xmoduleuserstatesummaryfield` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `field_name` varchar(64) NOT NULL,
  `usage_id` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `courseware_xmodulecontentfi_definition_id_50fa4fd570cf2f4a_uniq` (`usage_id`,`field_name`),
  KEY `courseware_xmodulecontentfield_7e1499` (`field_name`),
  KEY `courseware_xmodulecontentfield_1d304ded` (`usage_id`),
  KEY `courseware_xmodulecontentfield_3216ff68` (`created`),
  KEY `courseware_xmodulecontentfield_5436e97a` (`modified`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courseware_xmoduleuserstatesummaryfield`
--

LOCK TABLES `courseware_xmoduleuserstatesummaryfield` WRITE;
/*!40000 ALTER TABLE `courseware_xmoduleuserstatesummaryfield` DISABLE KEYS */;
/*!40000 ALTER TABLE `courseware_xmoduleuserstatesummaryfield` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dark_lang_darklangconfig`
--

DROP TABLE IF EXISTS `dark_lang_darklangconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dark_lang_darklangconfig` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `change_date` datetime NOT NULL,
  `changed_by_id` int(11) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `released_languages` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dark_lang_darklangconfig_16905482` (`changed_by_id`),
  CONSTRAINT `changed_by_id_refs_id_3fb19c355c5fe834` FOREIGN KEY (`changed_by_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dark_lang_darklangconfig`
--

LOCK TABLES `dark_lang_darklangconfig` WRITE;
/*!40000 ALTER TABLE `dark_lang_darklangconfig` DISABLE KEYS */;
INSERT INTO `dark_lang_darklangconfig` VALUES (1,'2014-02-10 02:48:10',NULL,1,'');
/*!40000 ALTER TABLE `dark_lang_darklangconfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_fbfc09f1` (`user_id`),
  KEY `django_admin_log_e4470c6e` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_288599e6` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `user_id_refs_id_c8665aa` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_comment_client_permission`
--

DROP TABLE IF EXISTS `django_comment_client_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_comment_client_permission` (
  `name` varchar(30) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_comment_client_permission`
--

LOCK TABLES `django_comment_client_permission` WRITE;
/*!40000 ALTER TABLE `django_comment_client_permission` DISABLE KEYS */;
INSERT INTO `django_comment_client_permission` VALUES ('create_comment'),('create_sub_comment'),('create_thread'),('delete_comment'),('delete_thread'),('edit_content'),('endorse_comment'),('follow_commentable'),('follow_thread'),('manage_moderator'),('openclose_thread'),('see_all_cohorts'),('unfollow_commentable'),('unfollow_thread'),('unvote'),('update_comment'),('update_thread'),('vote');
/*!40000 ALTER TABLE `django_comment_client_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_comment_client_permission_roles`
--

DROP TABLE IF EXISTS `django_comment_client_permission_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_comment_client_permission_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `permission_id` varchar(30) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_comment_client_permi_permission_id_7a766da089425952_uniq` (`permission_id`,`role_id`),
  KEY `django_comment_client_permission_roles_1e014c8f` (`permission_id`),
  KEY `django_comment_client_permission_roles_bf07f040` (`role_id`),
  CONSTRAINT `permission_id_refs_name_63b5ab82b6302d27` FOREIGN KEY (`permission_id`) REFERENCES `django_comment_client_permission` (`name`),
  CONSTRAINT `role_id_refs_id_6ccffe4ec1b5c854` FOREIGN KEY (`role_id`) REFERENCES `django_comment_client_role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=631 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_comment_client_permission_roles`
--

LOCK TABLES `django_comment_client_permission_roles` WRITE;
/*!40000 ALTER TABLE `django_comment_client_permission_roles` DISABLE KEYS */;
INSERT INTO `django_comment_client_permission_roles` VALUES (47,'create_comment',1),(29,'create_comment',2),(30,'create_comment',3),(11,'create_comment',4),(110,'create_comment',5),(92,'create_comment',6),(93,'create_comment',7),(74,'create_comment',8),(173,'create_comment',9),(155,'create_comment',10),(156,'create_comment',11),(137,'create_comment',12),(236,'create_comment',13),(218,'create_comment',14),(219,'create_comment',15),(200,'create_comment',16),(299,'create_comment',17),(281,'create_comment',18),(282,'create_comment',19),(263,'create_comment',20),(362,'create_comment',21),(344,'create_comment',22),(345,'create_comment',23),(326,'create_comment',24),(425,'create_comment',25),(407,'create_comment',26),(408,'create_comment',27),(389,'create_comment',28),(488,'create_comment',29),(470,'create_comment',30),(471,'create_comment',31),(452,'create_comment',32),(551,'create_comment',33),(533,'create_comment',34),(534,'create_comment',35),(515,'create_comment',36),(614,'create_comment',37),(586,'create_comment',38),(597,'create_comment',39),(578,'create_comment',40),(48,'create_sub_comment',1),(24,'create_sub_comment',2),(31,'create_sub_comment',3),(6,'create_sub_comment',4),(111,'create_sub_comment',5),(87,'create_sub_comment',6),(94,'create_sub_comment',7),(69,'create_sub_comment',8),(174,'create_sub_comment',9),(150,'create_sub_comment',10),(157,'create_sub_comment',11),(132,'create_sub_comment',12),(237,'create_sub_comment',13),(213,'create_sub_comment',14),(220,'create_sub_comment',15),(195,'create_sub_comment',16),(300,'create_sub_comment',17),(276,'create_sub_comment',18),(283,'create_sub_comment',19),(258,'create_sub_comment',20),(363,'create_sub_comment',21),(339,'create_sub_comment',22),(346,'create_sub_comment',23),(321,'create_sub_comment',24),(426,'create_sub_comment',25),(402,'create_sub_comment',26),(409,'create_sub_comment',27),(384,'create_sub_comment',28),(489,'create_sub_comment',29),(465,'create_sub_comment',30),(472,'create_sub_comment',31),(447,'create_sub_comment',32),(552,'create_sub_comment',33),(528,'create_sub_comment',34),(535,'create_sub_comment',35),(510,'create_sub_comment',36),(615,'create_sub_comment',37),(587,'create_sub_comment',38),(598,'create_sub_comment',39),(573,'create_sub_comment',40),(49,'create_thread',1),(26,'create_thread',2),(32,'create_thread',3),(8,'create_thread',4),(112,'create_thread',5),(89,'create_thread',6),(95,'create_thread',7),(71,'create_thread',8),(175,'create_thread',9),(152,'create_thread',10),(158,'create_thread',11),(134,'create_thread',12),(238,'create_thread',13),(215,'create_thread',14),(221,'create_thread',15),(197,'create_thread',16),(301,'create_thread',17),(278,'create_thread',18),(284,'create_thread',19),(260,'create_thread',20),(364,'create_thread',21),(341,'create_thread',22),(347,'create_thread',23),(323,'create_thread',24),(427,'create_thread',25),(404,'create_thread',26),(410,'create_thread',27),(386,'create_thread',28),(490,'create_thread',29),(467,'create_thread',30),(473,'create_thread',31),(449,'create_thread',32),(553,'create_thread',33),(530,'create_thread',34),(536,'create_thread',35),(512,'create_thread',36),(616,'create_thread',37),(588,'create_thread',38),(599,'create_thread',39),(575,'create_thread',40),(50,'delete_comment',1),(16,'delete_comment',2),(33,'delete_comment',3),(113,'delete_comment',5),(79,'delete_comment',6),(96,'delete_comment',7),(176,'delete_comment',9),(142,'delete_comment',10),(159,'delete_comment',11),(239,'delete_comment',13),(205,'delete_comment',14),(222,'delete_comment',15),(302,'delete_comment',17),(268,'delete_comment',18),(285,'delete_comment',19),(365,'delete_comment',21),(331,'delete_comment',22),(348,'delete_comment',23),(428,'delete_comment',25),(394,'delete_comment',26),(411,'delete_comment',27),(491,'delete_comment',29),(457,'delete_comment',30),(474,'delete_comment',31),(554,'delete_comment',33),(520,'delete_comment',34),(537,'delete_comment',35),(617,'delete_comment',37),(583,'delete_comment',38),(600,'delete_comment',39),(51,'delete_thread',1),(13,'delete_thread',2),(34,'delete_thread',3),(114,'delete_thread',5),(76,'delete_thread',6),(97,'delete_thread',7),(177,'delete_thread',9),(139,'delete_thread',10),(160,'delete_thread',11),(240,'delete_thread',13),(202,'delete_thread',14),(223,'delete_thread',15),(303,'delete_thread',17),(265,'delete_thread',18),(286,'delete_thread',19),(366,'delete_thread',21),(328,'delete_thread',22),(349,'delete_thread',23),(429,'delete_thread',25),(391,'delete_thread',26),(412,'delete_thread',27),(492,'delete_thread',29),(454,'delete_thread',30),(475,'delete_thread',31),(555,'delete_thread',33),(517,'delete_thread',34),(538,'delete_thread',35),(618,'delete_thread',37),(580,'delete_thread',38),(601,'delete_thread',39),(52,'edit_content',1),(12,'edit_content',2),(35,'edit_content',3),(115,'edit_content',5),(75,'edit_content',6),(98,'edit_content',7),(178,'edit_content',9),(138,'edit_content',10),(161,'edit_content',11),(241,'edit_content',13),(201,'edit_content',14),(224,'edit_content',15),(304,'edit_content',17),(264,'edit_content',18),(287,'edit_content',19),(367,'edit_content',21),(327,'edit_content',22),(350,'edit_content',23),(430,'edit_content',25),(390,'edit_content',26),(413,'edit_content',27),(493,'edit_content',29),(453,'edit_content',30),(476,'edit_content',31),(556,'edit_content',33),(516,'edit_content',34),(539,'edit_content',35),(619,'edit_content',37),(579,'edit_content',38),(602,'edit_content',39),(53,'endorse_comment',1),(15,'endorse_comment',2),(36,'endorse_comment',3),(116,'endorse_comment',5),(78,'endorse_comment',6),(99,'endorse_comment',7),(179,'endorse_comment',9),(141,'endorse_comment',10),(162,'endorse_comment',11),(242,'endorse_comment',13),(204,'endorse_comment',14),(225,'endorse_comment',15),(305,'endorse_comment',17),(267,'endorse_comment',18),(288,'endorse_comment',19),(368,'endorse_comment',21),(330,'endorse_comment',22),(351,'endorse_comment',23),(431,'endorse_comment',25),(393,'endorse_comment',26),(414,'endorse_comment',27),(494,'endorse_comment',29),(456,'endorse_comment',30),(477,'endorse_comment',31),(557,'endorse_comment',33),(519,'endorse_comment',34),(540,'endorse_comment',35),(620,'endorse_comment',37),(582,'endorse_comment',38),(603,'endorse_comment',39),(54,'follow_commentable',1),(27,'follow_commentable',2),(37,'follow_commentable',3),(9,'follow_commentable',4),(117,'follow_commentable',5),(90,'follow_commentable',6),(100,'follow_commentable',7),(72,'follow_commentable',8),(180,'follow_commentable',9),(153,'follow_commentable',10),(163,'follow_commentable',11),(135,'follow_commentable',12),(243,'follow_commentable',13),(216,'follow_commentable',14),(226,'follow_commentable',15),(198,'follow_commentable',16),(306,'follow_commentable',17),(279,'follow_commentable',18),(289,'follow_commentable',19),(261,'follow_commentable',20),(369,'follow_commentable',21),(342,'follow_commentable',22),(352,'follow_commentable',23),(324,'follow_commentable',24),(432,'follow_commentable',25),(405,'follow_commentable',26),(415,'follow_commentable',27),(387,'follow_commentable',28),(495,'follow_commentable',29),(468,'follow_commentable',30),(478,'follow_commentable',31),(450,'follow_commentable',32),(558,'follow_commentable',33),(531,'follow_commentable',34),(541,'follow_commentable',35),(513,'follow_commentable',36),(621,'follow_commentable',37),(589,'follow_commentable',38),(604,'follow_commentable',39),(576,'follow_commentable',40),(55,'follow_thread',1),(21,'follow_thread',2),(38,'follow_thread',3),(3,'follow_thread',4),(118,'follow_thread',5),(84,'follow_thread',6),(101,'follow_thread',7),(66,'follow_thread',8),(181,'follow_thread',9),(147,'follow_thread',10),(164,'follow_thread',11),(129,'follow_thread',12),(244,'follow_thread',13),(210,'follow_thread',14),(227,'follow_thread',15),(192,'follow_thread',16),(307,'follow_thread',17),(273,'follow_thread',18),(290,'follow_thread',19),(255,'follow_thread',20),(370,'follow_thread',21),(336,'follow_thread',22),(353,'follow_thread',23),(318,'follow_thread',24),(433,'follow_thread',25),(399,'follow_thread',26),(416,'follow_thread',27),(381,'follow_thread',28),(496,'follow_thread',29),(462,'follow_thread',30),(479,'follow_thread',31),(444,'follow_thread',32),(559,'follow_thread',33),(525,'follow_thread',34),(542,'follow_thread',35),(507,'follow_thread',36),(622,'follow_thread',37),(590,'follow_thread',38),(605,'follow_thread',39),(570,'follow_thread',40),(18,'manage_moderator',1),(81,'manage_moderator',5),(144,'manage_moderator',9),(207,'manage_moderator',13),(270,'manage_moderator',17),(333,'manage_moderator',21),(396,'manage_moderator',25),(459,'manage_moderator',29),(522,'manage_moderator',33),(585,'manage_moderator',37),(56,'openclose_thread',1),(14,'openclose_thread',2),(39,'openclose_thread',3),(119,'openclose_thread',5),(77,'openclose_thread',6),(102,'openclose_thread',7),(182,'openclose_thread',9),(140,'openclose_thread',10),(165,'openclose_thread',11),(245,'openclose_thread',13),(203,'openclose_thread',14),(228,'openclose_thread',15),(308,'openclose_thread',17),(266,'openclose_thread',18),(291,'openclose_thread',19),(371,'openclose_thread',21),(329,'openclose_thread',22),(354,'openclose_thread',23),(434,'openclose_thread',25),(392,'openclose_thread',26),(417,'openclose_thread',27),(497,'openclose_thread',29),(455,'openclose_thread',30),(480,'openclose_thread',31),(560,'openclose_thread',33),(518,'openclose_thread',34),(543,'openclose_thread',35),(623,'openclose_thread',37),(581,'openclose_thread',38),(606,'openclose_thread',39),(57,'see_all_cohorts',1),(17,'see_all_cohorts',2),(40,'see_all_cohorts',3),(120,'see_all_cohorts',5),(80,'see_all_cohorts',6),(103,'see_all_cohorts',7),(183,'see_all_cohorts',9),(143,'see_all_cohorts',10),(166,'see_all_cohorts',11),(246,'see_all_cohorts',13),(206,'see_all_cohorts',14),(229,'see_all_cohorts',15),(309,'see_all_cohorts',17),(269,'see_all_cohorts',18),(292,'see_all_cohorts',19),(372,'see_all_cohorts',21),(332,'see_all_cohorts',22),(355,'see_all_cohorts',23),(435,'see_all_cohorts',25),(395,'see_all_cohorts',26),(418,'see_all_cohorts',27),(498,'see_all_cohorts',29),(458,'see_all_cohorts',30),(481,'see_all_cohorts',31),(561,'see_all_cohorts',33),(521,'see_all_cohorts',34),(544,'see_all_cohorts',35),(624,'see_all_cohorts',37),(584,'see_all_cohorts',38),(607,'see_all_cohorts',39),(58,'unfollow_commentable',1),(28,'unfollow_commentable',2),(41,'unfollow_commentable',3),(10,'unfollow_commentable',4),(121,'unfollow_commentable',5),(91,'unfollow_commentable',6),(104,'unfollow_commentable',7),(73,'unfollow_commentable',8),(184,'unfollow_commentable',9),(154,'unfollow_commentable',10),(167,'unfollow_commentable',11),(136,'unfollow_commentable',12),(247,'unfollow_commentable',13),(217,'unfollow_commentable',14),(230,'unfollow_commentable',15),(199,'unfollow_commentable',16),(310,'unfollow_commentable',17),(280,'unfollow_commentable',18),(293,'unfollow_commentable',19),(262,'unfollow_commentable',20),(373,'unfollow_commentable',21),(343,'unfollow_commentable',22),(356,'unfollow_commentable',23),(325,'unfollow_commentable',24),(436,'unfollow_commentable',25),(406,'unfollow_commentable',26),(419,'unfollow_commentable',27),(388,'unfollow_commentable',28),(499,'unfollow_commentable',29),(469,'unfollow_commentable',30),(482,'unfollow_commentable',31),(451,'unfollow_commentable',32),(562,'unfollow_commentable',33),(532,'unfollow_commentable',34),(545,'unfollow_commentable',35),(514,'unfollow_commentable',36),(625,'unfollow_commentable',37),(591,'unfollow_commentable',38),(608,'unfollow_commentable',39),(577,'unfollow_commentable',40),(59,'unfollow_thread',1),(22,'unfollow_thread',2),(42,'unfollow_thread',3),(4,'unfollow_thread',4),(122,'unfollow_thread',5),(85,'unfollow_thread',6),(105,'unfollow_thread',7),(67,'unfollow_thread',8),(185,'unfollow_thread',9),(148,'unfollow_thread',10),(168,'unfollow_thread',11),(130,'unfollow_thread',12),(248,'unfollow_thread',13),(211,'unfollow_thread',14),(231,'unfollow_thread',15),(193,'unfollow_thread',16),(311,'unfollow_thread',17),(274,'unfollow_thread',18),(294,'unfollow_thread',19),(256,'unfollow_thread',20),(374,'unfollow_thread',21),(337,'unfollow_thread',22),(357,'unfollow_thread',23),(319,'unfollow_thread',24),(437,'unfollow_thread',25),(400,'unfollow_thread',26),(420,'unfollow_thread',27),(382,'unfollow_thread',28),(500,'unfollow_thread',29),(463,'unfollow_thread',30),(483,'unfollow_thread',31),(445,'unfollow_thread',32),(563,'unfollow_thread',33),(526,'unfollow_thread',34),(546,'unfollow_thread',35),(508,'unfollow_thread',36),(626,'unfollow_thread',37),(592,'unfollow_thread',38),(609,'unfollow_thread',39),(571,'unfollow_thread',40),(60,'unvote',1),(25,'unvote',2),(43,'unvote',3),(7,'unvote',4),(123,'unvote',5),(88,'unvote',6),(106,'unvote',7),(70,'unvote',8),(186,'unvote',9),(151,'unvote',10),(169,'unvote',11),(133,'unvote',12),(249,'unvote',13),(214,'unvote',14),(232,'unvote',15),(196,'unvote',16),(312,'unvote',17),(277,'unvote',18),(295,'unvote',19),(259,'unvote',20),(375,'unvote',21),(340,'unvote',22),(358,'unvote',23),(322,'unvote',24),(438,'unvote',25),(403,'unvote',26),(421,'unvote',27),(385,'unvote',28),(501,'unvote',29),(466,'unvote',30),(484,'unvote',31),(448,'unvote',32),(564,'unvote',33),(529,'unvote',34),(547,'unvote',35),(511,'unvote',36),(627,'unvote',37),(593,'unvote',38),(610,'unvote',39),(574,'unvote',40),(61,'update_comment',1),(23,'update_comment',2),(44,'update_comment',3),(5,'update_comment',4),(124,'update_comment',5),(86,'update_comment',6),(107,'update_comment',7),(68,'update_comment',8),(187,'update_comment',9),(149,'update_comment',10),(170,'update_comment',11),(131,'update_comment',12),(250,'update_comment',13),(212,'update_comment',14),(233,'update_comment',15),(194,'update_comment',16),(313,'update_comment',17),(275,'update_comment',18),(296,'update_comment',19),(257,'update_comment',20),(376,'update_comment',21),(338,'update_comment',22),(359,'update_comment',23),(320,'update_comment',24),(439,'update_comment',25),(401,'update_comment',26),(422,'update_comment',27),(383,'update_comment',28),(502,'update_comment',29),(464,'update_comment',30),(485,'update_comment',31),(446,'update_comment',32),(565,'update_comment',33),(527,'update_comment',34),(548,'update_comment',35),(509,'update_comment',36),(628,'update_comment',37),(594,'update_comment',38),(611,'update_comment',39),(572,'update_comment',40),(62,'update_thread',1),(20,'update_thread',2),(45,'update_thread',3),(2,'update_thread',4),(125,'update_thread',5),(83,'update_thread',6),(108,'update_thread',7),(65,'update_thread',8),(188,'update_thread',9),(146,'update_thread',10),(171,'update_thread',11),(128,'update_thread',12),(251,'update_thread',13),(209,'update_thread',14),(234,'update_thread',15),(191,'update_thread',16),(314,'update_thread',17),(272,'update_thread',18),(297,'update_thread',19),(254,'update_thread',20),(377,'update_thread',21),(335,'update_thread',22),(360,'update_thread',23),(317,'update_thread',24),(440,'update_thread',25),(398,'update_thread',26),(423,'update_thread',27),(380,'update_thread',28),(503,'update_thread',29),(461,'update_thread',30),(486,'update_thread',31),(443,'update_thread',32),(566,'update_thread',33),(524,'update_thread',34),(549,'update_thread',35),(506,'update_thread',36),(629,'update_thread',37),(595,'update_thread',38),(612,'update_thread',39),(569,'update_thread',40),(63,'vote',1),(19,'vote',2),(46,'vote',3),(1,'vote',4),(126,'vote',5),(82,'vote',6),(109,'vote',7),(64,'vote',8),(189,'vote',9),(145,'vote',10),(172,'vote',11),(127,'vote',12),(252,'vote',13),(208,'vote',14),(235,'vote',15),(190,'vote',16),(315,'vote',17),(271,'vote',18),(298,'vote',19),(253,'vote',20),(378,'vote',21),(334,'vote',22),(361,'vote',23),(316,'vote',24),(441,'vote',25),(397,'vote',26),(424,'vote',27),(379,'vote',28),(504,'vote',29),(460,'vote',30),(487,'vote',31),(442,'vote',32),(567,'vote',33),(523,'vote',34),(550,'vote',35),(505,'vote',36),(630,'vote',37),(596,'vote',38),(613,'vote',39),(568,'vote',40);
/*!40000 ALTER TABLE `django_comment_client_permission_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_comment_client_role`
--

DROP TABLE IF EXISTS `django_comment_client_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_comment_client_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_comment_client_role_ff48d8e5` (`course_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_comment_client_role`
--

LOCK TABLES `django_comment_client_role` WRITE;
/*!40000 ALTER TABLE `django_comment_client_role` DISABLE KEYS */;
INSERT INTO `django_comment_client_role` VALUES (1,'Administrator','edX/Open_DemoX/edx_demo_course'),(2,'Moderator','edX/Open_DemoX/edx_demo_course'),(3,'Community TA','edX/Open_DemoX/edx_demo_course'),(4,'Student','edX/Open_DemoX/edx_demo_course'),(5,'Administrator','TSINGHUA/TSINGHUA101/2014_T1'),(6,'Moderator','TSINGHUA/TSINGHUA101/2014_T1'),(7,'Community TA','TSINGHUA/TSINGHUA101/2014_T1'),(8,'Student','TSINGHUA/TSINGHUA101/2014_T1'),(9,'Administrator','diaodiyun/60240013X/2014_T4'),(10,'Moderator','diaodiyun/60240013X/2014_T4'),(11,'Community TA','diaodiyun/60240013X/2014_T4'),(12,'Student','diaodiyun/60240013X/2014_T4'),(13,'Administrator','qinghua/10421084X/2014'),(14,'Moderator','qinghua/10421084X/2014'),(15,'Community TA','qinghua/10421084X/2014'),(16,'Student','qinghua/10421084X/2014'),(17,'Administrator','青花大学/TSH_110/2014_t3'),(18,'Moderator','青花大学/TSH_110/2014_t3'),(19,'Community TA','青花大学/TSH_110/2014_t3'),(20,'Student','青花大学/TSH_110/2014_t3'),(21,'Administrator','清华大学/TSH_001/2014_01'),(22,'Moderator','清华大学/TSH_001/2014_01'),(23,'Community TA','清华大学/TSH_001/2014_01'),(24,'Student','清华大学/TSH_001/2014_01'),(25,'Administrator','青花大学/TSH_002/2014_t4'),(26,'Moderator','青花大学/TSH_002/2014_t4'),(27,'Community TA','青花大学/TSH_002/2014_t4'),(28,'Student','青花大学/TSH_002/2014_t4'),(29,'Administrator','清华大学/TSH_011/2014_t4'),(30,'Moderator','清华大学/TSH_011/2014_t4'),(31,'Community TA','清华大学/TSH_011/2014_t4'),(32,'Student','清华大学/TSH_011/2014_t4'),(33,'Administrator','测试机构/cd_011/2014'),(34,'Moderator','测试机构/cd_011/2014'),(35,'Community TA','测试机构/cd_011/2014'),(36,'Student','测试机构/cd_011/2014'),(37,'Administrator','测试机构/YX_01/2014_T1'),(38,'Moderator','测试机构/YX_01/2014_T1'),(39,'Community TA','测试机构/YX_01/2014_T1'),(40,'Student','测试机构/YX_01/2014_T1');
/*!40000 ALTER TABLE `django_comment_client_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_comment_client_role_users`
--

DROP TABLE IF EXISTS `django_comment_client_role_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_comment_client_role_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_comment_client_role_users_role_id_78e483f531943614_uniq` (`role_id`,`user_id`),
  KEY `django_comment_client_role_users_bf07f040` (`role_id`),
  KEY `django_comment_client_role_users_fbfc09f1` (`user_id`),
  CONSTRAINT `role_id_refs_id_282d08d1ab82c838` FOREIGN KEY (`role_id`) REFERENCES `django_comment_client_role` (`id`),
  CONSTRAINT `user_id_refs_id_60d02531441b79e7` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_comment_client_role_users`
--

LOCK TABLES `django_comment_client_role_users` WRITE;
/*!40000 ALTER TABLE `django_comment_client_role_users` DISABLE KEYS */;
INSERT INTO `django_comment_client_role_users` VALUES (1,4,1),(2,4,2),(3,4,3),(4,4,4),(5,4,9),(9,4,11),(19,8,1),(18,8,4),(6,8,9),(8,8,11),(17,8,12),(20,12,1),(13,12,4),(7,12,9),(12,12,10),(16,12,12),(15,16,1),(14,16,4),(11,16,10),(10,16,11),(21,20,4),(24,24,1),(22,24,4),(26,24,12),(23,28,4),(25,32,1),(28,32,4),(27,36,4),(30,40,1),(29,40,4);
/*!40000 ALTER TABLE `django_comment_client_role_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'permission','auth','permission'),(2,'group','auth','group'),(3,'user','auth','user'),(4,'content type','contenttypes','contenttype'),(5,'session','sessions','session'),(6,'site','sites','site'),(7,'task state','djcelery','taskmeta'),(8,'saved group result','djcelery','tasksetmeta'),(9,'interval','djcelery','intervalschedule'),(10,'crontab','djcelery','crontabschedule'),(11,'periodic tasks','djcelery','periodictasks'),(12,'periodic task','djcelery','periodictask'),(13,'worker','djcelery','workerstate'),(14,'task','djcelery','taskstate'),(15,'migration history','south','migrationhistory'),(16,'server circuit','circuit','servercircuit'),(17,'psychometric data','psychometrics','psychometricdata'),(18,'course user group','course_groups','courseusergroup'),(19,'nonce','django_openid_auth','nonce'),(20,'association','django_openid_auth','association'),(21,'user open id','django_openid_auth','useropenid'),(22,'log entry','admin','logentry'),(23,'student module','courseware','studentmodule'),(24,'student module history','courseware','studentmodulehistory'),(25,'x module user state summary field','courseware','xmoduleuserstatesummaryfield'),(26,'x module student prefs field','courseware','xmodulestudentprefsfield'),(27,'x module student info field','courseware','xmodulestudentinfofield'),(28,'offline computed grade','courseware','offlinecomputedgrade'),(29,'offline computed grade log','courseware','offlinecomputedgradelog'),(30,'anonymous user id','student','anonymoususerid'),(31,'user standing','student','userstanding'),(32,'user profile','student','userprofile'),(33,'user test group','student','usertestgroup'),(34,'registration','student','registration'),(35,'pending name change','student','pendingnamechange'),(36,'pending email change','student','pendingemailchange'),(37,'login failures','student','loginfailures'),(38,'course enrollment','student','courseenrollment'),(39,'course enrollment allowed','student','courseenrollmentallowed'),(40,'tracking log','track','trackinglog'),(41,'certificate whitelist','certificates','certificatewhitelist'),(42,'generated certificate','certificates','generatedcertificate'),(43,'instructor task','instructor_task','instructortask'),(44,'course software','licenses','coursesoftware'),(45,'user license','licenses','userlicense'),(46,'course email','bulk_email','courseemail'),(47,'optout','bulk_email','optout'),(48,'course email template','bulk_email','courseemailtemplate'),(49,'course authorization','bulk_email','courseauthorization'),(50,'external auth map','external_auth','externalauthmap'),(51,'article','wiki','article'),(52,'Article for object','wiki','articleforobject'),(53,'article revision','wiki','articlerevision'),(54,'URL path','wiki','urlpath'),(55,'article plugin','wiki','articleplugin'),(56,'reusable plugin','wiki','reusableplugin'),(57,'simple plugin','wiki','simpleplugin'),(58,'revision plugin','wiki','revisionplugin'),(59,'revision plugin revision','wiki','revisionpluginrevision'),(60,'article subscription','wiki','articlesubscription'),(61,'type','django_notify','notificationtype'),(62,'settings','django_notify','settings'),(63,'subscription','django_notify','subscription'),(64,'notification','django_notify','notification'),(65,'score','foldit','score'),(66,'puzzle complete','foldit','puzzlecomplete'),(67,'flag','waffle','flag'),(68,'switch','waffle','switch'),(69,'sample','waffle','sample'),(70,'note','notes','note'),(71,'user preference','user_api','userpreference'),(72,'order','shoppingcart','order'),(73,'order item','shoppingcart','orderitem'),(74,'paid course registration','shoppingcart','paidcourseregistration'),(75,'paid course registration annotation','shoppingcart','paidcourseregistrationannotation'),(76,'certificate item','shoppingcart','certificateitem'),(77,'course mode','course_modes','coursemode'),(78,'software secure photo verification','verify_student','softwaresecurephotoverification'),(79,'dark lang config','dark_lang','darklangconfig'),(80,'midcourse reverification window','reverification','midcoursereverificationwindow'),(81,'linked in','linkedin','linkedin'),(82,'splash config','splash','splashconfig'),(83,'captcha store','captcha','captchastore'),(84,'embargoed course','embargo','embargoedcourse'),(85,'embargoed state','embargo','embargoedstate'),(86,'ip filter','embargo','ipfilter'),(87,'answer','mentoring','answer'),(88,'course creator','course_creators','coursecreator');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_openid_auth_association`
--

DROP TABLE IF EXISTS `django_openid_auth_association`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_openid_auth_association` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_url` longtext NOT NULL,
  `handle` varchar(255) NOT NULL,
  `secret` longtext NOT NULL,
  `issued` int(11) NOT NULL,
  `lifetime` int(11) NOT NULL,
  `assoc_type` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_openid_auth_association`
--

LOCK TABLES `django_openid_auth_association` WRITE;
/*!40000 ALTER TABLE `django_openid_auth_association` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_openid_auth_association` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_openid_auth_nonce`
--

DROP TABLE IF EXISTS `django_openid_auth_nonce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_openid_auth_nonce` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server_url` varchar(2047) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `salt` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_openid_auth_nonce`
--

LOCK TABLES `django_openid_auth_nonce` WRITE;
/*!40000 ALTER TABLE `django_openid_auth_nonce` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_openid_auth_nonce` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_openid_auth_useropenid`
--

DROP TABLE IF EXISTS `django_openid_auth_useropenid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_openid_auth_useropenid` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `claimed_id` longtext NOT NULL,
  `display_id` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_openid_auth_useropenid_fbfc09f1` (`user_id`),
  CONSTRAINT `user_id_refs_id_be7162f0` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_openid_auth_useropenid`
--

LOCK TABLES `django_openid_auth_useropenid` WRITE;
/*!40000 ALTER TABLE `django_openid_auth_useropenid` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_openid_auth_useropenid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_c25c2c28` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_site`
--

DROP TABLE IF EXISTS `django_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_site`
--

LOCK TABLES `django_site` WRITE;
/*!40000 ALTER TABLE `django_site` DISABLE KEYS */;
INSERT INTO `django_site` VALUES (1,'example.com','example.com');
/*!40000 ALTER TABLE `django_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_crontabschedule`
--

DROP TABLE IF EXISTS `djcelery_crontabschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_crontabschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `minute` varchar(64) NOT NULL,
  `hour` varchar(64) NOT NULL,
  `day_of_week` varchar(64) NOT NULL,
  `day_of_month` varchar(64) NOT NULL,
  `month_of_year` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_crontabschedule`
--

LOCK TABLES `djcelery_crontabschedule` WRITE;
/*!40000 ALTER TABLE `djcelery_crontabschedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_crontabschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_intervalschedule`
--

DROP TABLE IF EXISTS `djcelery_intervalschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_intervalschedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `every` int(11) NOT NULL,
  `period` varchar(24) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_intervalschedule`
--

LOCK TABLES `djcelery_intervalschedule` WRITE;
/*!40000 ALTER TABLE `djcelery_intervalschedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_intervalschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_periodictask`
--

DROP TABLE IF EXISTS `djcelery_periodictask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_periodictask` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `task` varchar(200) NOT NULL,
  `interval_id` int(11) DEFAULT NULL,
  `crontab_id` int(11) DEFAULT NULL,
  `args` longtext NOT NULL,
  `kwargs` longtext NOT NULL,
  `queue` varchar(200) DEFAULT NULL,
  `exchange` varchar(200) DEFAULT NULL,
  `routing_key` varchar(200) DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `last_run_at` datetime DEFAULT NULL,
  `total_run_count` int(10) unsigned NOT NULL,
  `date_changed` datetime NOT NULL,
  `description` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `djcelery_periodictask_17d2d99d` (`interval_id`),
  KEY `djcelery_periodictask_7aa5fda` (`crontab_id`),
  CONSTRAINT `crontab_id_refs_id_ebff5e74` FOREIGN KEY (`crontab_id`) REFERENCES `djcelery_crontabschedule` (`id`),
  CONSTRAINT `interval_id_refs_id_f2054349` FOREIGN KEY (`interval_id`) REFERENCES `djcelery_intervalschedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_periodictask`
--

LOCK TABLES `djcelery_periodictask` WRITE;
/*!40000 ALTER TABLE `djcelery_periodictask` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_periodictask` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_periodictasks`
--

DROP TABLE IF EXISTS `djcelery_periodictasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_periodictasks` (
  `ident` smallint(6) NOT NULL,
  `last_update` datetime NOT NULL,
  PRIMARY KEY (`ident`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_periodictasks`
--

LOCK TABLES `djcelery_periodictasks` WRITE;
/*!40000 ALTER TABLE `djcelery_periodictasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_periodictasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_taskstate`
--

DROP TABLE IF EXISTS `djcelery_taskstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_taskstate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(64) NOT NULL,
  `task_id` varchar(36) NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `tstamp` datetime NOT NULL,
  `args` longtext,
  `kwargs` longtext,
  `eta` datetime DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  `result` longtext,
  `traceback` longtext,
  `runtime` double DEFAULT NULL,
  `retries` int(11) NOT NULL,
  `worker_id` int(11) DEFAULT NULL,
  `hidden` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `task_id` (`task_id`),
  KEY `djcelery_taskstate_355bfc27` (`state`),
  KEY `djcelery_taskstate_52094d6e` (`name`),
  KEY `djcelery_taskstate_f0ba6500` (`tstamp`),
  KEY `djcelery_taskstate_20fc5b84` (`worker_id`),
  KEY `djcelery_taskstate_c91f1bf` (`hidden`),
  CONSTRAINT `worker_id_refs_id_4e3453a` FOREIGN KEY (`worker_id`) REFERENCES `djcelery_workerstate` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_taskstate`
--

LOCK TABLES `djcelery_taskstate` WRITE;
/*!40000 ALTER TABLE `djcelery_taskstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_taskstate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `djcelery_workerstate`
--

DROP TABLE IF EXISTS `djcelery_workerstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `djcelery_workerstate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostname` varchar(255) NOT NULL,
  `last_heartbeat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hostname` (`hostname`),
  KEY `djcelery_workerstate_eb8ac7e4` (`last_heartbeat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `djcelery_workerstate`
--

LOCK TABLES `djcelery_workerstate` WRITE;
/*!40000 ALTER TABLE `djcelery_workerstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `djcelery_workerstate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `embargo_embargoedcourse`
--

DROP TABLE IF EXISTS `embargo_embargoedcourse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `embargo_embargoedcourse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` varchar(255) NOT NULL,
  `embargoed` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `embargo_embargoedcourse`
--

LOCK TABLES `embargo_embargoedcourse` WRITE;
/*!40000 ALTER TABLE `embargo_embargoedcourse` DISABLE KEYS */;
/*!40000 ALTER TABLE `embargo_embargoedcourse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `embargo_embargoedstate`
--

DROP TABLE IF EXISTS `embargo_embargoedstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `embargo_embargoedstate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `change_date` datetime NOT NULL,
  `changed_by_id` int(11) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `embargoed_countries` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `embargo_embargoedstate_16905482` (`changed_by_id`),
  CONSTRAINT `changed_by_id_refs_id_3c8b83add0205d39` FOREIGN KEY (`changed_by_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `embargo_embargoedstate`
--

LOCK TABLES `embargo_embargoedstate` WRITE;
/*!40000 ALTER TABLE `embargo_embargoedstate` DISABLE KEYS */;
/*!40000 ALTER TABLE `embargo_embargoedstate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `embargo_ipfilter`
--

DROP TABLE IF EXISTS `embargo_ipfilter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `embargo_ipfilter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `change_date` datetime NOT NULL,
  `changed_by_id` int(11) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `whitelist` longtext NOT NULL,
  `blacklist` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `embargo_ipfilter_16905482` (`changed_by_id`),
  CONSTRAINT `changed_by_id_refs_id_3babbf0a22c1f5d3` FOREIGN KEY (`changed_by_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `embargo_ipfilter`
--

LOCK TABLES `embargo_ipfilter` WRITE;
/*!40000 ALTER TABLE `embargo_ipfilter` DISABLE KEYS */;
/*!40000 ALTER TABLE `embargo_ipfilter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `external_auth_externalauthmap`
--

DROP TABLE IF EXISTS `external_auth_externalauthmap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `external_auth_externalauthmap` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `external_id` varchar(255) NOT NULL,
  `external_domain` varchar(255) NOT NULL,
  `external_credentials` longtext NOT NULL,
  `external_email` varchar(255) NOT NULL,
  `external_name` varchar(255) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `internal_password` varchar(31) NOT NULL,
  `dtcreated` datetime NOT NULL,
  `dtsignup` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `external_auth_externalauthmap_external_id_7f035ef8bc4d313e_uniq` (`external_id`,`external_domain`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `external_auth_externalauthmap_d5e787` (`external_id`),
  KEY `external_auth_externalauthmap_a570024c` (`external_domain`),
  KEY `external_auth_externalauthmap_a142061d` (`external_email`),
  KEY `external_auth_externalauthmap_c1a016f` (`external_name`),
  CONSTRAINT `user_id_refs_id_39c4e675f8635f67` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `external_auth_externalauthmap`
--

LOCK TABLES `external_auth_externalauthmap` WRITE;
/*!40000 ALTER TABLE `external_auth_externalauthmap` DISABLE KEYS */;
/*!40000 ALTER TABLE `external_auth_externalauthmap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foldit_puzzlecomplete`
--

DROP TABLE IF EXISTS `foldit_puzzlecomplete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `foldit_puzzlecomplete` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `unique_user_id` varchar(50) NOT NULL,
  `puzzle_id` int(11) NOT NULL,
  `puzzle_set` int(11) NOT NULL,
  `puzzle_subset` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `foldit_puzzlecomplete_user_id_4c63656af6674331_uniq` (`user_id`,`puzzle_id`,`puzzle_set`,`puzzle_subset`),
  KEY `foldit_puzzlecomplete_fbfc09f1` (`user_id`),
  KEY `foldit_puzzlecomplete_8027477e` (`unique_user_id`),
  KEY `foldit_puzzlecomplete_4798a2b8` (`puzzle_set`),
  KEY `foldit_puzzlecomplete_59f06bcd` (`puzzle_subset`),
  CONSTRAINT `user_id_refs_id_23bb09ab37e9437b` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foldit_puzzlecomplete`
--

LOCK TABLES `foldit_puzzlecomplete` WRITE;
/*!40000 ALTER TABLE `foldit_puzzlecomplete` DISABLE KEYS */;
/*!40000 ALTER TABLE `foldit_puzzlecomplete` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `foldit_score`
--

DROP TABLE IF EXISTS `foldit_score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `foldit_score` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `unique_user_id` varchar(50) NOT NULL,
  `puzzle_id` int(11) NOT NULL,
  `best_score` double NOT NULL,
  `current_score` double NOT NULL,
  `score_version` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `foldit_score_fbfc09f1` (`user_id`),
  KEY `foldit_score_8027477e` (`unique_user_id`),
  KEY `foldit_score_3624c060` (`best_score`),
  KEY `foldit_score_b4627792` (`current_score`),
  CONSTRAINT `user_id_refs_id_44efb56f4c07957f` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `foldit_score`
--

LOCK TABLES `foldit_score` WRITE;
/*!40000 ALTER TABLE `foldit_score` DISABLE KEYS */;
/*!40000 ALTER TABLE `foldit_score` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `instructor_task_instructortask`
--

DROP TABLE IF EXISTS `instructor_task_instructortask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instructor_task_instructortask` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_type` varchar(50) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  `task_key` varchar(255) NOT NULL,
  `task_input` varchar(255) NOT NULL,
  `task_id` varchar(255) NOT NULL,
  `task_state` varchar(50) DEFAULT NULL,
  `task_output` varchar(1024) DEFAULT NULL,
  `requester_id` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime NOT NULL,
  `subtasks` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `instructor_task_instructortask_8ae638b4` (`task_type`),
  KEY `instructor_task_instructortask_ff48d8e5` (`course_id`),
  KEY `instructor_task_instructortask_cfc55170` (`task_key`),
  KEY `instructor_task_instructortask_c00fe455` (`task_id`),
  KEY `instructor_task_instructortask_731e67a4` (`task_state`),
  KEY `instructor_task_instructortask_b8ca8b9f` (`requester_id`),
  CONSTRAINT `requester_id_refs_id_4d6b69c6a97278e6` FOREIGN KEY (`requester_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instructor_task_instructortask`
--

LOCK TABLES `instructor_task_instructortask` WRITE;
/*!40000 ALTER TABLE `instructor_task_instructortask` DISABLE KEYS */;
/*!40000 ALTER TABLE `instructor_task_instructortask` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `licenses_coursesoftware`
--

DROP TABLE IF EXISTS `licenses_coursesoftware`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `licenses_coursesoftware` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `licenses_coursesoftware`
--

LOCK TABLES `licenses_coursesoftware` WRITE;
/*!40000 ALTER TABLE `licenses_coursesoftware` DISABLE KEYS */;
/*!40000 ALTER TABLE `licenses_coursesoftware` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `licenses_userlicense`
--

DROP TABLE IF EXISTS `licenses_userlicense`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `licenses_userlicense` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `software_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `serial` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `licenses_userlicense_4c6ed3c1` (`software_id`),
  KEY `licenses_userlicense_fbfc09f1` (`user_id`),
  CONSTRAINT `software_id_refs_id_78738fcdf9e27be8` FOREIGN KEY (`software_id`) REFERENCES `licenses_coursesoftware` (`id`),
  CONSTRAINT `user_id_refs_id_26345de02f3a1cb3` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `licenses_userlicense`
--

LOCK TABLES `licenses_userlicense` WRITE;
/*!40000 ALTER TABLE `licenses_userlicense` DISABLE KEYS */;
/*!40000 ALTER TABLE `licenses_userlicense` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `linkedin_linkedin`
--

DROP TABLE IF EXISTS `linkedin_linkedin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `linkedin_linkedin` (
  `user_id` int(11) NOT NULL,
  `has_linkedin_account` tinyint(1) DEFAULT NULL,
  `emailed_courses` longtext NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `user_id_refs_id_7b29e97d72e31bb2` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `linkedin_linkedin`
--

LOCK TABLES `linkedin_linkedin` WRITE;
/*!40000 ALTER TABLE `linkedin_linkedin` DISABLE KEYS */;
/*!40000 ALTER TABLE `linkedin_linkedin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mentoring_answer`
--

DROP TABLE IF EXISTS `mentoring_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mentoring_answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `student_id` varchar(32) NOT NULL,
  `student_input` longtext NOT NULL,
  `created_on` datetime NOT NULL,
  `modified_on` datetime NOT NULL,
  `course_id` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mentoring_answer_course_id_7f581fd43d0d1f77_uniq` (`course_id`,`student_id`,`name`),
  KEY `mentoring_answer_52094d6e` (`name`),
  KEY `mentoring_answer_42ff452e` (`student_id`),
  KEY `mentoring_answer_ff48d8e5` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mentoring_answer`
--

LOCK TABLES `mentoring_answer` WRITE;
/*!40000 ALTER TABLE `mentoring_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `mentoring_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notes_note`
--

DROP TABLE IF EXISTS `notes_note`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notes_note` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  `uri` varchar(255) NOT NULL,
  `text` longtext NOT NULL,
  `quote` longtext NOT NULL,
  `range_start` varchar(2048) NOT NULL,
  `range_start_offset` int(11) NOT NULL,
  `range_end` varchar(2048) NOT NULL,
  `range_end_offset` int(11) NOT NULL,
  `tags` longtext NOT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime NOT NULL,
  `media` varchar(20) DEFAULT 'text',
  PRIMARY KEY (`id`),
  KEY `notes_note_fbfc09f1` (`user_id`),
  KEY `notes_note_ff48d8e5` (`course_id`),
  KEY `notes_note_a9794fa` (`uri`),
  KEY `notes_note_3216ff68` (`created`),
  KEY `notes_note_8aac229` (`updated`),
  CONSTRAINT `user_id_refs_id_380a4734360715cc` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notes_note`
--

LOCK TABLES `notes_note` WRITE;
/*!40000 ALTER TABLE `notes_note` DISABLE KEYS */;
INSERT INTO `notes_note` VALUES (5,4,'edX/Open_DemoX/edx_demo_course','http://localhost:8000/courses/edX/Open_DemoX/edx_demo_course/courseware/interactive_demonstrations/19a30717eff543078a5d94ae9d6c18a5/','你回来了拉手网啦啦啦库卡卡卡','re seen\n      a rabbit with either a waistc','/div[1]/div[8]/div[1]/div[1]/div[2]/div[1]/p[3]',546,'/div[1]/div[8]/div[1]/div[1]/div[2]/div[1]/p[3]',589,'','2014-07-09 07:05:13','2014-07-30 06:53:10','text'),(8,4,'qinghua/10421084X/2014','http://localhost:8000/courses/qinghua/10421084X/2014/courseware/d477e77d1b784eccbd199ed8c2106d75/7400f4af28114075ac4eca876ba309db/','测试media怎样过后菊花啦啦啦','呈现的选项。\n\n\n答案选项和正确答案的标识以optioni','/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/div[2]/div[1]/p[1]',56,'/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/div[2]/div[1]/p[2]/b[1]',7,'','2014-07-10 03:35:06','2014-07-10 08:37:44','text'),(9,4,'qinghua/10421084X/2014','http://localhost:8000/courses/qinghua/10421084X/2014/courseware/d477e77d1b784eccbd199ed8c2106d75/7400f4af28114075ac4eca876ba309db/','阿萨德发馊豆腐','问题接受学生的文字','/div[1]/div[2]/div[1]/div[1]/div[4]/div[1]/div[1]/div[2]/div[1]/p[1]',7,'/div[1]/div[2]/div[1]/div[1]/div[4]/div[1]/div[1]/div[2]/div[1]/p[1]',16,'','2014-07-10 03:43:15','2014-07-10 03:43:15','text'),(10,4,'qinghua/10421084X/2014','http://localhost:8000/courses/qinghua/10421084X/2014/courseware/d477e77d1b784eccbd199ed8c2106d75/7400f4af28114075ac4eca876ba309db/','出来出来出来','根据其数值评估输入的正确性。','/div[1]/div[2]/div[1]/div[1]/div[4]/div[1]/div[1]/div[2]/div[1]/p[1]',20,'/div[1]/div[2]/div[1]/div[1]/div[4]/div[1]/div[1]/div[2]/div[1]/p[1]',34,'','2014-07-10 03:50:37','2014-07-10 03:50:37','text'),(11,4,'qinghua/10421084X/2014','http://localhost:8000/courses/qinghua/10421084X/2014/courseware/d477e77d1b784eccbd199ed8c2106d75/7400f4af28114075ac4eca876ba309db/','阿萨德发馊豆腐','们寻找一个明确的答案','/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/div[2]/div[1]/p[1]',40,'/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/div[2]/div[1]/p[1]',50,'','2014-07-10 03:53:06','2014-07-10 05:58:23','text'),(12,4,'qinghua/10421084X/2014','http://localhost:8000/courses/qinghua/10421084X/2014/courseware/d477e77d1b784eccbd199ed8c2106d75/7400f4af28114075ac4eca876ba309db/','么啊飞速打法对付','转换是非常简单的：','/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/div[2]/div[1]/p[3]',18,'/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/div[2]/div[1]/p[3]',27,'','2014-07-10 04:05:06','2014-07-10 04:05:06','text'),(13,4,'qinghua/10421084X/2014','http://localhost:8000/courses/qinghua/10421084X/2014/courseware/d477e77d1b784eccbd199ed8c2106d75/7400f4af28114075ac4eca876ba309db/','，， 没','种形式呈现这些','/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/div[2]/div[1]/p[1]',27,'/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/div[2]/div[1]/p[1]',34,'','2014-07-10 04:07:39','2014-07-10 04:07:39','text'),(14,1,'edX/Open_DemoX/edx_demo_course','http://localhost:8000/courses/edX/Open_DemoX/edx_demo_course/courseware/d8a6192ade314473a78242dfeedfbf5b/edx_introduction/','中么没有文字哦','You can watch the introduction video (below) or scroll though the course studies and assignments using the toolbar (above).  Just for fun, we\'ll keep track of your work in this','/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/p[2]',0,'/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/p[2]',176,'','2014-07-10 04:09:10','2014-07-10 04:11:18','text'),(15,1,'edX/Open_DemoX/edx_demo_course','http://localhost:8000/courses/edX/Open_DemoX/edx_demo_course/courseware/d8a6192ade314473a78242dfeedfbf5b/edx_introduction/','测试瞧一桥','Watch the overview video (below), then click on \"Example','/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/p[3]',0,'/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/p[3]',57,'','2014-07-10 04:12:02','2014-07-10 04:12:30','text'),(16,4,'qinghua/10421084X/2014','http://192.168.1.15:8000/courses/qinghua/10421084X/2014/courseware/d477e77d1b784eccbd199ed8c2106d75/7400f4af28114075ac4eca876ba309db/','查看笔记，测试笔记','给出了一组有限的选项让学生回复，并且以某种形式呈现这些选项，帮助他们寻找一个明确的答案，而不是即刻呈现的选项。','/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/div[2]/div[1]/p[1]',7,'/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/div[2]/div[1]/p[1]',62,'','2014-07-11 01:37:08','2014-07-11 01:37:08','text'),(17,4,'qinghua/10421084X/2014','http://192.168.1.15:8000/courses/qinghua/10421084X/2014/courseware/d477e77d1b784eccbd199ed8c2106d75/7400f4af28114075ac4eca876ba309db/','下雨了，下吧下吧，我要开花！','题接受学生的文字输入，并根据其数值评估输入的正确性。\n\n\n\n如果答案是在预期的答案的指定数值的公差','/div[1]/div[2]/div[1]/div[1]/div[4]/div[1]/div[1]/div[2]/div[1]/p[1]',8,'/div[1]/div[2]/div[1]/div[1]/div[4]/div[1]/div[1]/div[2]/div[1]/p[2]',20,'','2014-07-11 01:54:37','2014-07-11 01:54:37','text'),(18,4,'edX/Open_DemoX/edx_demo_course','http://localhost:8000/courses/edX/Open_DemoX/edx_demo_course/courseware/d8a6192ade314473a78242dfeedfbf5b/edx_introduction/','瞧一桥，眼界高于头顶','on video (below) or scroll though the co','/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/p[2]',28,'/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/p[2]',68,'','2014-07-18 08:27:40','2014-07-30 06:53:36','text'),(20,4,'edX/Open_DemoX/edx_demo_course','http://localhost:8000/courses/edX/Open_DemoX/edx_demo_course/courseware/d8a6192ade314473a78242dfeedfbf5b/edx_introduction/','测试用户不是打通的','k on \"Example Week One\" in the left hand navig','/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/p[3]',43,'/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/p[3]',89,'','2014-07-18 09:18:41','2014-07-18 09:18:41','text'),(21,4,'edX/Open_DemoX/edx_demo_course','http://localhost:8000/courses/edX/Open_DemoX/edx_demo_course/courseware/d8a6192ade314473a78242dfeedfbf5b/edx_introduction/','asdfdasfasdfdf','ntro\" video that shows you how it all wor','/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/p[1]',141,'/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/p[1]',182,'','2014-07-18 10:03:44','2014-07-18 10:03:44','text');
/*!40000 ALTER TABLE `notes_note` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications_articlesubscription`
--

DROP TABLE IF EXISTS `notifications_articlesubscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications_articlesubscription` (
  `subscription_ptr_id` int(11) NOT NULL,
  `articleplugin_ptr_id` int(11) NOT NULL,
  PRIMARY KEY (`articleplugin_ptr_id`),
  UNIQUE KEY `subscription_ptr_id` (`subscription_ptr_id`),
  CONSTRAINT `articleplugin_ptr_id_refs_id_1bd08ac071ed584a` FOREIGN KEY (`articleplugin_ptr_id`) REFERENCES `wiki_articleplugin` (`id`),
  CONSTRAINT `subscription_ptr_id_refs_id_18f7bae575c0b518` FOREIGN KEY (`subscription_ptr_id`) REFERENCES `notify_subscription` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications_articlesubscription`
--

LOCK TABLES `notifications_articlesubscription` WRITE;
/*!40000 ALTER TABLE `notifications_articlesubscription` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications_articlesubscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_notification`
--

DROP TABLE IF EXISTS `notify_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_id` int(11) DEFAULT NULL,
  `message` longtext NOT NULL,
  `url` varchar(200) DEFAULT NULL,
  `is_viewed` tinyint(1) NOT NULL,
  `is_emailed` tinyint(1) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notify_notification_104f5ac1` (`subscription_id`),
  CONSTRAINT `subscription_id_refs_id_7a99ebc5baf93d4f` FOREIGN KEY (`subscription_id`) REFERENCES `notify_subscription` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_notification`
--

LOCK TABLES `notify_notification` WRITE;
/*!40000 ALTER TABLE `notify_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `notify_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_notificationtype`
--

DROP TABLE IF EXISTS `notify_notificationtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_notificationtype` (
  `key` varchar(128) NOT NULL,
  `label` varchar(128) DEFAULT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`key`),
  KEY `notify_notificationtype_e4470c6e` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_4919de6f2478378` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_notificationtype`
--

LOCK TABLES `notify_notificationtype` WRITE;
/*!40000 ALTER TABLE `notify_notificationtype` DISABLE KEYS */;
INSERT INTO `notify_notificationtype` VALUES ('article_edit',NULL,51);
/*!40000 ALTER TABLE `notify_notificationtype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_settings`
--

DROP TABLE IF EXISTS `notify_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `interval` smallint(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notify_settings_fbfc09f1` (`user_id`),
  CONSTRAINT `user_id_refs_id_2e6a6a1d9a2911e6` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_settings`
--

LOCK TABLES `notify_settings` WRITE;
/*!40000 ALTER TABLE `notify_settings` DISABLE KEYS */;
INSERT INTO `notify_settings` VALUES (1,4,0);
/*!40000 ALTER TABLE `notify_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_subscription`
--

DROP TABLE IF EXISTS `notify_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_subscription` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `settings_id` int(11) NOT NULL,
  `notification_type_id` varchar(128) NOT NULL,
  `object_id` varchar(64) DEFAULT NULL,
  `send_emails` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `notify_subscription_83326d99` (`settings_id`),
  KEY `notify_subscription_9955f091` (`notification_type_id`),
  CONSTRAINT `notification_type_id_refs_key_25426c9bbaa41a19` FOREIGN KEY (`notification_type_id`) REFERENCES `notify_notificationtype` (`key`),
  CONSTRAINT `settings_id_refs_id_2b8d6d653b7225d5` FOREIGN KEY (`settings_id`) REFERENCES `notify_settings` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_subscription`
--

LOCK TABLES `notify_subscription` WRITE;
/*!40000 ALTER TABLE `notify_subscription` DISABLE KEYS */;
/*!40000 ALTER TABLE `notify_subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `psychometrics_psychometricdata`
--

DROP TABLE IF EXISTS `psychometrics_psychometricdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `psychometrics_psychometricdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `studentmodule_id` int(11) NOT NULL,
  `done` tinyint(1) NOT NULL,
  `attempts` int(11) NOT NULL,
  `checktimes` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `studentmodule_id` (`studentmodule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `psychometrics_psychometricdata`
--

LOCK TABLES `psychometrics_psychometricdata` WRITE;
/*!40000 ALTER TABLE `psychometrics_psychometricdata` DISABLE KEYS */;
/*!40000 ALTER TABLE `psychometrics_psychometricdata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reverification_midcoursereverificationwindow`
--

DROP TABLE IF EXISTS `reverification_midcoursereverificationwindow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reverification_midcoursereverificationwindow` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` varchar(255) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reverification_midcoursereverificationwindow_ff48d8e5` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reverification_midcoursereverificationwindow`
--

LOCK TABLES `reverification_midcoursereverificationwindow` WRITE;
/*!40000 ALTER TABLE `reverification_midcoursereverificationwindow` DISABLE KEYS */;
/*!40000 ALTER TABLE `reverification_midcoursereverificationwindow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shoppingcart_certificateitem`
--

DROP TABLE IF EXISTS `shoppingcart_certificateitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shoppingcart_certificateitem` (
  `orderitem_ptr_id` int(11) NOT NULL,
  `course_id` varchar(128) NOT NULL,
  `course_enrollment_id` int(11) NOT NULL,
  `mode` varchar(50) NOT NULL,
  PRIMARY KEY (`orderitem_ptr_id`),
  KEY `shoppingcart_certificateitem_ff48d8e5` (`course_id`),
  KEY `shoppingcart_certificateitem_9e513f0b` (`course_enrollment_id`),
  KEY `shoppingcart_certificateitem_4160619e` (`mode`),
  CONSTRAINT `course_enrollment_id_refs_id_259181e58048c435` FOREIGN KEY (`course_enrollment_id`) REFERENCES `student_courseenrollment` (`id`),
  CONSTRAINT `orderitem_ptr_id_refs_id_4d598262d3ebc4d0` FOREIGN KEY (`orderitem_ptr_id`) REFERENCES `shoppingcart_orderitem` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shoppingcart_certificateitem`
--

LOCK TABLES `shoppingcart_certificateitem` WRITE;
/*!40000 ALTER TABLE `shoppingcart_certificateitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `shoppingcart_certificateitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shoppingcart_order`
--

DROP TABLE IF EXISTS `shoppingcart_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shoppingcart_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `currency` varchar(8) NOT NULL,
  `status` varchar(32) NOT NULL,
  `purchase_time` datetime DEFAULT NULL,
  `bill_to_first` varchar(64) NOT NULL,
  `bill_to_last` varchar(64) NOT NULL,
  `bill_to_street1` varchar(128) NOT NULL,
  `bill_to_street2` varchar(128) NOT NULL,
  `bill_to_city` varchar(64) NOT NULL,
  `bill_to_state` varchar(8) NOT NULL,
  `bill_to_postalcode` varchar(16) NOT NULL,
  `bill_to_country` varchar(64) NOT NULL,
  `bill_to_ccnum` varchar(8) NOT NULL,
  `bill_to_cardtype` varchar(32) NOT NULL,
  `processor_reply_dump` longtext NOT NULL,
  `refunded_time` datetime,
  PRIMARY KEY (`id`),
  KEY `shoppingcart_order_fbfc09f1` (`user_id`),
  CONSTRAINT `user_id_refs_id_a4b0342e1195673` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shoppingcart_order`
--

LOCK TABLES `shoppingcart_order` WRITE;
/*!40000 ALTER TABLE `shoppingcart_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `shoppingcart_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shoppingcart_orderitem`
--

DROP TABLE IF EXISTS `shoppingcart_orderitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shoppingcart_orderitem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `status` varchar(32) NOT NULL,
  `qty` int(11) NOT NULL,
  `unit_cost` decimal(30,2) NOT NULL,
  `line_desc` varchar(1024) NOT NULL,
  `currency` varchar(8) NOT NULL,
  `fulfilled_time` datetime,
  `report_comments` longtext NOT NULL,
  `refund_requested_time` datetime,
  `service_fee` decimal(30,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `shoppingcart_orderitem_8337030b` (`order_id`),
  KEY `shoppingcart_orderitem_fbfc09f1` (`user_id`),
  KEY `shoppingcart_orderitem_c9ad71dd` (`status`),
  KEY `shoppingcart_orderitem_8457f26a` (`fulfilled_time`),
  KEY `shoppingcart_orderitem_416112c1` (`refund_requested_time`),
  CONSTRAINT `order_id_refs_id_4fad6e867c77b3f0` FOREIGN KEY (`order_id`) REFERENCES `shoppingcart_order` (`id`),
  CONSTRAINT `user_id_refs_id_608b9042d92ae410` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shoppingcart_orderitem`
--

LOCK TABLES `shoppingcart_orderitem` WRITE;
/*!40000 ALTER TABLE `shoppingcart_orderitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `shoppingcart_orderitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shoppingcart_paidcourseregistration`
--

DROP TABLE IF EXISTS `shoppingcart_paidcourseregistration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shoppingcart_paidcourseregistration` (
  `orderitem_ptr_id` int(11) NOT NULL,
  `course_id` varchar(128) NOT NULL,
  `mode` varchar(50) NOT NULL,
  PRIMARY KEY (`orderitem_ptr_id`),
  KEY `shoppingcart_paidcourseregistration_ff48d8e5` (`course_id`),
  KEY `shoppingcart_paidcourseregistration_4160619e` (`mode`),
  CONSTRAINT `orderitem_ptr_id_refs_id_c5c6141d8709d99` FOREIGN KEY (`orderitem_ptr_id`) REFERENCES `shoppingcart_orderitem` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shoppingcart_paidcourseregistration`
--

LOCK TABLES `shoppingcart_paidcourseregistration` WRITE;
/*!40000 ALTER TABLE `shoppingcart_paidcourseregistration` DISABLE KEYS */;
/*!40000 ALTER TABLE `shoppingcart_paidcourseregistration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shoppingcart_paidcourseregistrationannotation`
--

DROP TABLE IF EXISTS `shoppingcart_paidcourseregistrationannotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shoppingcart_paidcourseregistrationannotation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` varchar(128) NOT NULL,
  `annotation` longtext,
  PRIMARY KEY (`id`),
  UNIQUE KEY `course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shoppingcart_paidcourseregistrationannotation`
--

LOCK TABLES `shoppingcart_paidcourseregistrationannotation` WRITE;
/*!40000 ALTER TABLE `shoppingcart_paidcourseregistrationannotation` DISABLE KEYS */;
/*!40000 ALTER TABLE `shoppingcart_paidcourseregistrationannotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `south_migrationhistory`
--

DROP TABLE IF EXISTS `south_migrationhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `south_migrationhistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(255) NOT NULL,
  `migration` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `south_migrationhistory`
--

LOCK TABLES `south_migrationhistory` WRITE;
/*!40000 ALTER TABLE `south_migrationhistory` DISABLE KEYS */;
INSERT INTO `south_migrationhistory` VALUES (1,'courseware','0001_initial','2014-02-10 02:47:56'),(2,'courseware','0002_add_indexes','2014-02-10 02:47:56'),(3,'courseware','0003_done_grade_cache','2014-02-10 02:47:56'),(4,'courseware','0004_add_field_studentmodule_course_id','2014-02-10 02:47:56'),(5,'courseware','0005_auto__add_offlinecomputedgrade__add_unique_offlinecomputedgrade_user_c','2014-02-10 02:47:57'),(6,'courseware','0006_create_student_module_history','2014-02-10 02:47:57'),(7,'courseware','0007_allow_null_version_in_history','2014-02-10 02:47:57'),(8,'courseware','0008_add_xmodule_storage','2014-02-10 02:47:57'),(9,'courseware','0009_add_field_default','2014-02-10 02:47:57'),(10,'courseware','0010_rename_xblock_field_content_to_user_state_summary','2014-02-10 02:47:57'),(11,'student','0001_initial','2014-02-10 02:47:58'),(12,'student','0002_text_to_varchar_and_indexes','2014-02-10 02:47:58'),(13,'student','0003_auto__add_usertestgroup','2014-02-10 02:47:58'),(14,'student','0004_add_email_index','2014-02-10 02:47:58'),(15,'student','0005_name_change','2014-02-10 02:47:58'),(16,'student','0006_expand_meta_field','2014-02-10 02:47:58'),(17,'student','0007_convert_to_utf8','2014-02-10 02:47:58'),(18,'student','0008__auto__add_courseregistration','2014-02-10 02:47:58'),(19,'student','0009_auto__del_courseregistration__add_courseenrollment','2014-02-10 02:47:58'),(20,'student','0010_auto__chg_field_courseenrollment_course_id','2014-02-10 02:47:58'),(21,'student','0011_auto__chg_field_courseenrollment_user__del_unique_courseenrollment_use','2014-02-10 02:47:58'),(22,'student','0012_auto__add_field_userprofile_gender__add_field_userprofile_date_of_birt','2014-02-10 02:47:59'),(23,'student','0013_auto__chg_field_userprofile_meta','2014-02-10 02:47:59'),(24,'student','0014_auto__del_courseenrollment','2014-02-10 02:47:59'),(25,'student','0015_auto__add_courseenrollment__add_unique_courseenrollment_user_course_id','2014-02-10 02:47:59'),(26,'student','0016_auto__add_field_courseenrollment_date__chg_field_userprofile_country','2014-02-10 02:47:59'),(27,'student','0017_rename_date_to_created','2014-02-10 02:47:59'),(28,'student','0018_auto','2014-02-10 02:47:59'),(29,'student','0019_create_approved_demographic_fields_fall_2012','2014-02-10 02:47:59'),(30,'student','0020_add_test_center_user','2014-02-10 02:47:59'),(31,'student','0021_remove_askbot','2014-02-10 02:48:00'),(32,'student','0022_auto__add_courseenrollmentallowed__add_unique_courseenrollmentallowed_','2014-02-10 02:48:00'),(33,'student','0023_add_test_center_registration','2014-02-10 02:48:00'),(34,'student','0024_add_allow_certificate','2014-02-10 02:48:00'),(35,'student','0025_auto__add_field_courseenrollmentallowed_auto_enroll','2014-02-10 02:48:00'),(36,'student','0026_auto__remove_index_student_testcenterregistration_accommodation_request','2014-02-10 02:48:00'),(37,'student','0027_add_active_flag_and_mode_to_courseware_enrollment','2014-02-10 02:48:00'),(38,'student','0028_auto__add_userstanding','2014-02-10 02:48:01'),(39,'student','0029_add_lookup_table_between_user_and_anonymous_student_id','2014-02-10 02:48:01'),(40,'student','0029_remove_pearson','2014-02-10 02:48:01'),(41,'student','0030_auto__chg_field_anonymoususerid_anonymous_user_id','2014-02-10 02:48:01'),(42,'student','0031_drop_student_anonymoususerid_temp_archive','2014-02-10 02:48:01'),(43,'student','0032_add_field_UserProfile_country_add_field_UserProfile_city','2014-02-10 02:48:01'),(44,'student','0032_auto__add_loginfailures','2014-02-10 02:48:01'),(45,'track','0001_initial','2014-02-10 02:48:01'),(46,'track','0002_auto__add_field_trackinglog_host__chg_field_trackinglog_event_type__ch','2014-02-10 02:48:01'),(47,'certificates','0001_added_generatedcertificates','2014-02-10 02:48:01'),(48,'certificates','0002_auto__add_field_generatedcertificate_download_url','2014-02-10 02:48:01'),(49,'certificates','0003_auto__add_field_generatedcertificate_enabled','2014-02-10 02:48:01'),(50,'certificates','0004_auto__add_field_generatedcertificate_graded_certificate_id__add_field_','2014-02-10 02:48:02'),(51,'certificates','0005_auto__add_field_generatedcertificate_name','2014-02-10 02:48:02'),(52,'certificates','0006_auto__chg_field_generatedcertificate_certificate_id','2014-02-10 02:48:02'),(53,'certificates','0007_auto__add_revokedcertificate','2014-02-10 02:48:02'),(54,'certificates','0008_auto__del_revokedcertificate__del_field_generatedcertificate_name__add','2014-02-10 02:48:02'),(55,'certificates','0009_auto__del_field_generatedcertificate_graded_download_url__del_field_ge','2014-02-10 02:48:02'),(56,'certificates','0010_auto__del_field_generatedcertificate_enabled__add_field_generatedcerti','2014-02-10 02:48:02'),(57,'certificates','0011_auto__del_field_generatedcertificate_certificate_id__add_field_generat','2014-02-10 02:48:02'),(58,'certificates','0012_auto__add_field_generatedcertificate_name__add_field_generatedcertific','2014-02-10 02:48:02'),(59,'certificates','0013_auto__add_field_generatedcertificate_error_reason','2014-02-10 02:48:02'),(60,'certificates','0014_adding_whitelist','2014-02-10 02:48:02'),(61,'certificates','0015_adding_mode_for_verified_certs','2014-02-10 02:48:02'),(62,'instructor_task','0001_initial','2014-02-10 02:48:03'),(63,'instructor_task','0002_add_subtask_field','2014-02-10 02:48:03'),(64,'licenses','0001_initial','2014-02-10 02:48:03'),(65,'bulk_email','0001_initial','2014-02-10 02:48:03'),(66,'bulk_email','0002_change_field_names','2014-02-10 02:48:04'),(67,'bulk_email','0003_add_optout_user','2014-02-10 02:48:04'),(68,'bulk_email','0004_migrate_optout_user','2014-02-10 02:48:04'),(69,'bulk_email','0005_remove_optout_email','2014-02-10 02:48:04'),(70,'bulk_email','0006_add_course_email_template','2014-02-10 02:48:04'),(71,'bulk_email','0007_load_course_email_template','2014-02-10 02:48:04'),(72,'bulk_email','0008_add_course_authorizations','2014-02-10 02:48:04'),(73,'bulk_email','0009_force_unique_course_ids','2014-02-10 02:48:04'),(74,'external_auth','0001_initial','2014-02-10 02:48:04'),(75,'wiki','0001_initial','2014-02-10 02:48:05'),(76,'wiki','0002_auto__add_field_articleplugin_created','2014-02-10 02:48:05'),(77,'wiki','0003_auto__add_field_urlpath_article','2014-02-10 02:48:05'),(78,'wiki','0004_populate_urlpath__article','2014-02-10 02:48:05'),(79,'wiki','0005_auto__chg_field_urlpath_article','2014-02-10 02:48:05'),(80,'wiki','0006_auto__add_attachmentrevision__add_image__add_attachment','2014-02-10 02:48:05'),(81,'wiki','0007_auto__add_articlesubscription','2014-02-10 02:48:05'),(82,'wiki','0008_auto__add_simpleplugin__add_revisionpluginrevision__add_imagerevision_','2014-02-10 02:48:05'),(83,'wiki','0009_auto__add_field_imagerevision_width__add_field_imagerevision_height','2014-02-10 02:48:05'),(84,'wiki','0010_auto__chg_field_imagerevision_image','2014-02-10 02:48:05'),(85,'wiki','0011_auto__chg_field_imagerevision_width__chg_field_imagerevision_height','2014-02-10 02:48:06'),(86,'django_notify','0001_initial','2014-02-10 02:48:06'),(87,'notifications','0001_initial','2014-02-10 02:48:06'),(88,'foldit','0001_initial','2014-02-10 02:48:06'),(89,'waffle','0001_initial','2014-02-10 02:48:07'),(90,'waffle','0002_auto__add_sample','2014-02-10 02:48:07'),(91,'waffle','0003_auto__add_field_flag_note__add_field_switch_note__add_field_sample_not','2014-02-10 02:48:07'),(92,'waffle','0004_auto__add_field_flag_testing','2014-02-10 02:48:07'),(93,'waffle','0005_auto__add_field_flag_created__add_field_flag_modified','2014-02-10 02:48:07'),(94,'waffle','0006_auto__add_field_switch_created__add_field_switch_modified__add_field_s','2014-02-10 02:48:07'),(95,'waffle','0007_auto__chg_field_flag_created__chg_field_flag_modified__chg_field_switc','2014-02-10 02:48:07'),(96,'waffle','0008_auto__add_field_flag_languages','2014-02-10 02:48:07'),(97,'django_comment_client','0001_initial','2014-02-10 02:48:07'),(98,'django_comment_common','0001_initial','2014-02-10 02:48:08'),(99,'notes','0001_initial','2014-02-10 02:48:08'),(100,'user_api','0001_initial','2014-02-10 02:48:08'),(101,'shoppingcart','0001_initial','2014-02-10 02:48:08'),(102,'shoppingcart','0002_auto__add_field_paidcourseregistration_mode','2014-02-10 02:48:09'),(103,'shoppingcart','0003_auto__del_field_orderitem_line_cost','2014-02-10 02:48:09'),(104,'shoppingcart','0004_auto__add_field_orderitem_fulfilled_time','2014-02-10 02:48:09'),(105,'shoppingcart','0005_auto__add_paidcourseregistrationannotation__add_field_orderitem_report','2014-02-10 02:48:09'),(106,'shoppingcart','0006_auto__add_field_order_refunded_time__add_field_orderitem_refund_reques','2014-02-10 02:48:09'),(107,'shoppingcart','0007_auto__add_field_orderitem_service_fee','2014-02-10 02:48:09'),(108,'course_modes','0001_initial','2014-02-10 02:48:09'),(109,'course_modes','0002_auto__add_field_coursemode_currency','2014-02-10 02:48:09'),(110,'course_modes','0003_auto__add_unique_coursemode_course_id_currency_mode_slug','2014-02-10 02:48:09'),(111,'course_modes','0004_auto__add_field_coursemode_expiration_date','2014-02-10 02:48:09'),(112,'course_modes','0005_auto__add_field_coursemode_expiration_datetime','2014-02-10 02:48:09'),(113,'course_modes','0006_expiration_date_to_datetime','2014-02-10 02:48:09'),(114,'verify_student','0001_initial','2014-02-10 02:48:09'),(115,'verify_student','0002_auto__add_field_softwaresecurephotoverification_window','2014-02-10 02:48:09'),(116,'verify_student','0003_auto__add_field_softwaresecurephotoverification_display','2014-02-10 02:48:09'),(117,'dark_lang','0001_initial','2014-02-10 02:48:10'),(118,'dark_lang','0002_enable_on_install','2014-02-10 02:48:10'),(119,'reverification','0001_initial','2014-02-10 02:48:10'),(120,'linkedin','0001_initial','2014-02-10 02:48:10'),(121,'splash','0001_initial','2014-02-26 12:12:29'),(122,'splash','0002_auto__add_field_splashconfig_unaffected_url_paths','2014-02-26 12:12:29'),(123,'captcha','0001_initial','2014-06-23 07:22:27'),(124,'user_api','0002_auto__add_usercoursetags__add_unique_usercoursetags_user_course_id_key','2014-06-23 07:22:29'),(125,'user_api','0003_rename_usercoursetags','2014-06-23 07:22:29'),(126,'embargo','0001_initial','2014-06-23 07:22:30'),(127,'mentoring','0001_initial','2014-06-23 07:22:30'),(128,'mentoring','0002_auto__add_field_answer_course_id__chg_field_answer_student_id','2014-06-23 07:22:30'),(129,'mentoring','0003_auto__del_unique_answer_student_id_name__add_unique_answer_course_id_s','2014-06-23 07:22:30'),(130,'course_creators','0001_initial','2014-09-24 07:49:42');
/*!40000 ALTER TABLE `south_migrationhistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `splash_splashconfig`
--

DROP TABLE IF EXISTS `splash_splashconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `splash_splashconfig` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `change_date` datetime NOT NULL,
  `changed_by_id` int(11) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `cookie_name` longtext NOT NULL,
  `cookie_allowed_values` longtext NOT NULL,
  `unaffected_usernames` longtext NOT NULL,
  `redirect_url` varchar(200) NOT NULL,
  `unaffected_url_paths` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `splash_splashconfig_16905482` (`changed_by_id`),
  CONSTRAINT `changed_by_id_refs_id_6024c0b79125b21c` FOREIGN KEY (`changed_by_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `splash_splashconfig`
--

LOCK TABLES `splash_splashconfig` WRITE;
/*!40000 ALTER TABLE `splash_splashconfig` DISABLE KEYS */;
/*!40000 ALTER TABLE `splash_splashconfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_anonymoususerid`
--

DROP TABLE IF EXISTS `student_anonymoususerid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_anonymoususerid` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `anonymous_user_id` varchar(32) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `anonymous_user_id` (`anonymous_user_id`),
  KEY `student_anonymoususerid_fbfc09f1` (`user_id`),
  KEY `student_anonymoususerid_ff48d8e5` (`course_id`),
  CONSTRAINT `user_id_refs_id_23effb36c38f7a2a` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_anonymoususerid`
--

LOCK TABLES `student_anonymoususerid` WRITE;
/*!40000 ALTER TABLE `student_anonymoususerid` DISABLE KEYS */;
INSERT INTO `student_anonymoususerid` VALUES (1,9,'45c48cce2e2d7fbdea1afc51c7c6ad26',''),(2,10,'d3d9446802a44259755d38e6d163e820',''),(3,11,'6512bd43d9caa6e02c990b0a82652dca',''),(4,4,'a87ff679a2f3e71d9181a67b7542122c',''),(5,2,'c81e728d9d4c2f636f067f89cc14862c',''),(6,1,'c4ca4238a0b923820dcc509a6f75849b',''),(7,3,'eccbc87e4b5ce2fe28308fd9f2a7baf3',''),(8,12,'c20ad4d76fe97759aa27a0c99bff6710',''),(9,57,'72b32a1f754ba1c09b3695e0cb6cde7f',''),(10,108,'a3c65c2974270fd093ee8a9bf8ae7d0b',''),(11,112,'7f6ffaa6bb0b408017b62254211691b5','');
/*!40000 ALTER TABLE `student_anonymoususerid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_courseenrollment`
--

DROP TABLE IF EXISTS `student_courseenrollment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_courseenrollment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  `created` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL,
  `mode` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_courseenrollment_user_id_2d2a572f07dd8e37_uniq` (`user_id`,`course_id`),
  KEY `student_courseenrollment_fbfc09f1` (`user_id`),
  KEY `student_courseenrollment_ff48d8e5` (`course_id`),
  KEY `student_courseenrollment_3216ff68` (`created`),
  CONSTRAINT `user_id_refs_id_45948fcded37bc9d` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_courseenrollment`
--

LOCK TABLES `student_courseenrollment` WRITE;
/*!40000 ALTER TABLE `student_courseenrollment` DISABLE KEYS */;
INSERT INTO `student_courseenrollment` VALUES (1,1,'edX/Open_DemoX/edx_demo_course','2014-02-10 03:20:19',1,'honor'),(2,2,'edX/Open_DemoX/edx_demo_course','2014-02-10 03:20:20',1,'audit'),(3,3,'edX/Open_DemoX/edx_demo_course','2014-02-10 03:20:22',1,'verified'),(4,4,'edX/Open_DemoX/edx_demo_course','2014-02-10 03:20:23',0,'honor'),(5,9,'edX/Open_DemoX/edx_demo_course','2014-02-26 13:21:20',1,'honor'),(6,9,'TSINGHUA/TSINGHUA101/2014_T1','2014-02-27 02:20:46',1,'honor'),(7,9,'diaodiyun/60240013X/2014_T4','2014-02-27 03:04:27',1,'honor'),(8,11,'TSINGHUA/TSINGHUA101/2014_T1','2014-02-27 09:02:53',1,'honor'),(9,11,'edX/Open_DemoX/edx_demo_course','2014-02-27 09:03:13',1,'honor'),(10,11,'qinghua/10421084X/2014','2014-02-28 02:57:20',1,'honor'),(11,10,'qinghua/10421084X/2014','2014-02-28 10:05:02',1,'honor'),(12,10,'diaodiyun/60240013X/2014_T4','2014-02-28 10:18:29',1,'honor'),(13,4,'diaodiyun/60240013X/2014_T4','2014-06-24 02:04:33',1,'honor'),(14,4,'qinghua/10421084X/2014','2014-06-26 08:48:23',1,'honor'),(15,1,'qinghua/10421084X/2014','2014-06-27 07:38:27',1,'honor'),(16,12,'diaodiyun/60240013X/2014_T4','2014-07-04 02:33:41',1,'honor'),(17,12,'TSINGHUA/TSINGHUA101/2014_T1','2014-07-04 02:35:29',1,'honor'),(18,4,'TSINGHUA/TSINGHUA101/2014_T1','2014-07-04 08:21:53',0,'honor'),(19,1,'TSINGHUA/TSINGHUA101/2014_T1','2014-07-08 05:37:54',1,'honor'),(20,1,'diaodiyun/60240013X/2014_T4','2014-07-18 05:39:24',0,'honor'),(21,4,'青花大学/TSH_110/2014_t3','2014-07-23 02:43:51',0,'honor'),(22,4,'清华大学/TSH_001/2014_01','2014-07-23 02:52:06',0,'honor'),(23,4,'青花大学/TSH_002/2014_t4','2014-07-23 03:14:40',1,'honor'),(24,1,'清华大学/TSH_001/2014_01','2014-07-25 08:43:48',0,'honor'),(25,1,'清华大学/TSH_011/2014_t4','2014-07-25 08:49:54',1,'honor'),(26,12,'清华大学/TSH_001/2014_01','2014-07-29 02:59:28',1,'honor'),(27,4,'测试机构/cd_011/2014','2014-09-03 08:36:01',1,'honor'),(28,4,'清华大学/TSH_011/2014_t4','2014-09-28 02:22:11',1,'honor'),(29,4,'测试机构/YX_01/2014_T1','2014-09-28 07:36:01',1,'honor'),(30,1,'测试机构/YX_01/2014_T1','2014-09-28 07:41:27',1,'honor');
/*!40000 ALTER TABLE `student_courseenrollment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_courseenrollmentallowed`
--

DROP TABLE IF EXISTS `student_courseenrollmentallowed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_courseenrollmentallowed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  `created` datetime DEFAULT NULL,
  `auto_enroll` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_courseenrollmentallowed_email_6f3eafd4a6c58591_uniq` (`email`,`course_id`),
  KEY `student_courseenrollmentallowed_3904588a` (`email`),
  KEY `student_courseenrollmentallowed_ff48d8e5` (`course_id`),
  KEY `student_courseenrollmentallowed_3216ff68` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_courseenrollmentallowed`
--

LOCK TABLES `student_courseenrollmentallowed` WRITE;
/*!40000 ALTER TABLE `student_courseenrollmentallowed` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_courseenrollmentallowed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_loginfailures`
--

DROP TABLE IF EXISTS `student_loginfailures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_loginfailures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `failure_count` int(11) NOT NULL,
  `lockout_until` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_loginfailures_fbfc09f1` (`user_id`),
  CONSTRAINT `user_id_refs_id_50dcb1c1e6a71045` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_loginfailures`
--

LOCK TABLES `student_loginfailures` WRITE;
/*!40000 ALTER TABLE `student_loginfailures` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_loginfailures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_pendingemailchange`
--

DROP TABLE IF EXISTS `student_pendingemailchange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_pendingemailchange` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `new_email` varchar(255) NOT NULL,
  `activation_key` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  UNIQUE KEY `activation_key` (`activation_key`),
  KEY `student_pendingemailchange_856c86d7` (`new_email`),
  CONSTRAINT `user_id_refs_id_24fa3bcda525fa67` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_pendingemailchange`
--

LOCK TABLES `student_pendingemailchange` WRITE;
/*!40000 ALTER TABLE `student_pendingemailchange` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_pendingemailchange` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_pendingnamechange`
--

DROP TABLE IF EXISTS `student_pendingnamechange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_pendingnamechange` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `new_name` varchar(255) NOT NULL,
  `rationale` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `user_id_refs_id_24e959cdd9359b27` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_pendingnamechange`
--

LOCK TABLES `student_pendingnamechange` WRITE;
/*!40000 ALTER TABLE `student_pendingnamechange` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_pendingnamechange` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_uploadfileform`
--

DROP TABLE IF EXISTS `student_uploadfileform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_uploadfileform` (
  `file` char(255) DEFAULT NULL,
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_uploadfileform`
--

LOCK TABLES `student_uploadfileform` WRITE;
/*!40000 ALTER TABLE `student_uploadfileform` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_uploadfileform` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_userstanding`
--

DROP TABLE IF EXISTS `student_userstanding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_userstanding` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `account_status` varchar(31) NOT NULL,
  `changed_by_id` int(11) NOT NULL,
  `standing_last_changed_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `student_userstanding_16905482` (`changed_by_id`),
  CONSTRAINT `changed_by_id_refs_id_5ec33b2b0450a33b` FOREIGN KEY (`changed_by_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `user_id_refs_id_5ec33b2b0450a33b` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_userstanding`
--

LOCK TABLES `student_userstanding` WRITE;
/*!40000 ALTER TABLE `student_userstanding` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_userstanding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_usertestgroup`
--

DROP TABLE IF EXISTS `student_usertestgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_usertestgroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `description` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `student_usertestgroup_52094d6e` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_usertestgroup`
--

LOCK TABLES `student_usertestgroup` WRITE;
/*!40000 ALTER TABLE `student_usertestgroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_usertestgroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_usertestgroup_users`
--

DROP TABLE IF EXISTS `student_usertestgroup_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_usertestgroup_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usertestgroup_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `student_usertestgroup_us_usertestgroup_id_63c588e0372991b0_uniq` (`usertestgroup_id`,`user_id`),
  KEY `student_usertestgroup_users_44f27cdf` (`usertestgroup_id`),
  KEY `student_usertestgroup_users_fbfc09f1` (`user_id`),
  CONSTRAINT `usertestgroup_id_refs_id_78e186d36d724f9e` FOREIGN KEY (`usertestgroup_id`) REFERENCES `student_usertestgroup` (`id`),
  CONSTRAINT `user_id_refs_id_412b14bf8947584c` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_usertestgroup_users`
--

LOCK TABLES `student_usertestgroup_users` WRITE;
/*!40000 ALTER TABLE `student_usertestgroup_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_usertestgroup_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `track_trackinglog`
--

DROP TABLE IF EXISTS `track_trackinglog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `track_trackinglog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtcreated` datetime NOT NULL,
  `username` varchar(32) NOT NULL,
  `ip` varchar(32) NOT NULL,
  `event_source` varchar(32) NOT NULL,
  `event_type` varchar(512) NOT NULL,
  `event` longtext NOT NULL,
  `agent` varchar(256) NOT NULL,
  `page` varchar(512),
  `time` datetime NOT NULL,
  `host` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track_trackinglog`
--

LOCK TABLES `track_trackinglog` WRITE;
/*!40000 ALTER TABLE `track_trackinglog` DISABLE KEYS */;
/*!40000 ALTER TABLE `track_trackinglog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_api_usercoursetag`
--

DROP TABLE IF EXISTS `user_api_usercoursetag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_api_usercoursetag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `course_id` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_api_usercoursetags_user_id_a734720a0483b08_uniq` (`user_id`,`course_id`,`key`),
  KEY `user_api_usercoursetags_fbfc09f1` (`user_id`),
  KEY `user_api_usercoursetags_45544485` (`key`),
  KEY `user_api_usercoursetags_ff48d8e5` (`course_id`),
  CONSTRAINT `user_id_refs_id_1d26ef6c47a9a367` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_api_usercoursetag`
--

LOCK TABLES `user_api_usercoursetag` WRITE;
/*!40000 ALTER TABLE `user_api_usercoursetag` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_api_usercoursetag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_api_userpreference`
--

DROP TABLE IF EXISTS `user_api_userpreference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_api_userpreference` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_api_userpreference_user_id_4e4942d73f760072_uniq` (`user_id`,`key`),
  KEY `user_api_userpreference_fbfc09f1` (`user_id`),
  KEY `user_api_userpreference_45544485` (`key`),
  CONSTRAINT `user_id_refs_id_2839c1f4f3473b9e` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_api_userpreference`
--

LOCK TABLES `user_api_userpreference` WRITE;
/*!40000 ALTER TABLE `user_api_userpreference` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_api_userpreference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verify_student_softwaresecurephotoverification`
--

DROP TABLE IF EXISTS `verify_student_softwaresecurephotoverification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `verify_student_softwaresecurephotoverification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(100) NOT NULL,
  `status_changed` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `face_image_url` varchar(255) NOT NULL,
  `photo_id_image_url` varchar(255) NOT NULL,
  `receipt_id` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `reviewing_user_id` int(11) DEFAULT NULL,
  `reviewing_service` varchar(255) NOT NULL,
  `error_msg` longtext NOT NULL,
  `error_code` varchar(50) NOT NULL,
  `photo_id_key` longtext NOT NULL,
  `window_id` int(11),
  `display` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `verify_student_softwaresecurephotoverification_fbfc09f1` (`user_id`),
  KEY `verify_student_softwaresecurephotoverification_8713c555` (`receipt_id`),
  KEY `verify_student_softwaresecurephotoverification_3b1c9c31` (`created_at`),
  KEY `verify_student_softwaresecurephotoverification_f84f7de6` (`updated_at`),
  KEY `verify_student_softwaresecurephotoverification_4452d192` (`submitted_at`),
  KEY `verify_student_softwaresecurephotoverification_b2c165b4` (`reviewing_user_id`),
  KEY `verify_student_softwaresecurephotoverification_7343ffda` (`window_id`),
  KEY `verify_student_softwaresecurephotoverification_35eebcb6` (`display`),
  CONSTRAINT `reviewing_user_id_refs_id_5b90d52ad6ea4207` FOREIGN KEY (`reviewing_user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `user_id_refs_id_5b90d52ad6ea4207` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `window_id_refs_id_30f70c30fce8f38a` FOREIGN KEY (`window_id`) REFERENCES `reverification_midcoursereverificationwindow` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verify_student_softwaresecurephotoverification`
--

LOCK TABLES `verify_student_softwaresecurephotoverification` WRITE;
/*!40000 ALTER TABLE `verify_student_softwaresecurephotoverification` DISABLE KEYS */;
/*!40000 ALTER TABLE `verify_student_softwaresecurephotoverification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waffle_flag`
--

DROP TABLE IF EXISTS `waffle_flag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waffle_flag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `everyone` tinyint(1) DEFAULT NULL,
  `percent` decimal(3,1) DEFAULT NULL,
  `superusers` tinyint(1) NOT NULL,
  `staff` tinyint(1) NOT NULL,
  `authenticated` tinyint(1) NOT NULL,
  `rollout` tinyint(1) NOT NULL,
  `note` longtext NOT NULL,
  `testing` tinyint(1) NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `languages` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `waffle_flag_3216ff68` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waffle_flag`
--

LOCK TABLES `waffle_flag` WRITE;
/*!40000 ALTER TABLE `waffle_flag` DISABLE KEYS */;
/*!40000 ALTER TABLE `waffle_flag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waffle_flag_groups`
--

DROP TABLE IF EXISTS `waffle_flag_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waffle_flag_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `flag_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `waffle_flag_groups_flag_id_582896076571ab8b_uniq` (`flag_id`,`group_id`),
  KEY `waffle_flag_groups_9bca17e2` (`flag_id`),
  KEY `waffle_flag_groups_bda51c3c` (`group_id`),
  CONSTRAINT `flag_id_refs_id_6f1b152a8e6a807d` FOREIGN KEY (`flag_id`) REFERENCES `waffle_flag` (`id`),
  CONSTRAINT `group_id_refs_id_66545bd34ea49f34` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waffle_flag_groups`
--

LOCK TABLES `waffle_flag_groups` WRITE;
/*!40000 ALTER TABLE `waffle_flag_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `waffle_flag_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waffle_flag_users`
--

DROP TABLE IF EXISTS `waffle_flag_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waffle_flag_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `flag_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `waffle_flag_users_flag_id_3bb77386107938a3_uniq` (`flag_id`,`user_id`),
  KEY `waffle_flag_users_9bca17e2` (`flag_id`),
  KEY `waffle_flag_users_fbfc09f1` (`user_id`),
  CONSTRAINT `flag_id_refs_id_5034023d8fef0c12` FOREIGN KEY (`flag_id`) REFERENCES `waffle_flag` (`id`),
  CONSTRAINT `user_id_refs_id_1fe1cfb8bae2dfc2` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waffle_flag_users`
--

LOCK TABLES `waffle_flag_users` WRITE;
/*!40000 ALTER TABLE `waffle_flag_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `waffle_flag_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waffle_sample`
--

DROP TABLE IF EXISTS `waffle_sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waffle_sample` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `percent` decimal(4,1) NOT NULL,
  `note` longtext NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `waffle_sample_3216ff68` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waffle_sample`
--

LOCK TABLES `waffle_sample` WRITE;
/*!40000 ALTER TABLE `waffle_sample` DISABLE KEYS */;
/*!40000 ALTER TABLE `waffle_sample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waffle_switch`
--

DROP TABLE IF EXISTS `waffle_switch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waffle_switch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `note` longtext NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `waffle_switch_3216ff68` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waffle_switch`
--

LOCK TABLES `waffle_switch` WRITE;
/*!40000 ALTER TABLE `waffle_switch` DISABLE KEYS */;
/*!40000 ALTER TABLE `waffle_switch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_article`
--

DROP TABLE IF EXISTS `wiki_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `current_revision_id` int(11) DEFAULT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `group_read` tinyint(1) NOT NULL,
  `group_write` tinyint(1) NOT NULL,
  `other_read` tinyint(1) NOT NULL,
  `other_write` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `current_revision_id` (`current_revision_id`),
  KEY `wiki_article_5d52dd10` (`owner_id`),
  KEY `wiki_article_bda51c3c` (`group_id`),
  CONSTRAINT `current_revision_id_refs_id_1d8d320ebafac304` FOREIGN KEY (`current_revision_id`) REFERENCES `wiki_articlerevision` (`id`),
  CONSTRAINT `group_id_refs_id_10e2d3dd108bfee4` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `owner_id_refs_id_18073b359e14b583` FOREIGN KEY (`owner_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_article`
--

LOCK TABLES `wiki_article` WRITE;
/*!40000 ALTER TABLE `wiki_article` DISABLE KEYS */;
INSERT INTO `wiki_article` VALUES (1,1,'2014-02-26 13:21:34','2014-02-26 13:21:34',NULL,NULL,1,0,1,0),(2,2,'2014-02-26 13:21:34','2014-02-26 13:21:34',NULL,NULL,1,1,1,1),(3,6,'2014-06-26 08:49:59','2014-09-28 03:38:07',NULL,NULL,1,1,1,1),(4,9,'2014-07-31 07:03:05','2014-09-28 06:16:57',NULL,NULL,1,1,1,1);
/*!40000 ALTER TABLE `wiki_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_articleforobject`
--

DROP TABLE IF EXISTS `wiki_articleforobject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_articleforobject` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `is_mptt` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wiki_articleforobject_content_type_id_27c4cce189b3bcab_uniq` (`content_type_id`,`object_id`),
  KEY `wiki_articleforobject_30525a19` (`article_id`),
  KEY `wiki_articleforobject_e4470c6e` (`content_type_id`),
  CONSTRAINT `article_id_refs_id_1698e37305099436` FOREIGN KEY (`article_id`) REFERENCES `wiki_article` (`id`),
  CONSTRAINT `content_type_id_refs_id_6b30567037828764` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_articleforobject`
--

LOCK TABLES `wiki_articleforobject` WRITE;
/*!40000 ALTER TABLE `wiki_articleforobject` DISABLE KEYS */;
INSERT INTO `wiki_articleforobject` VALUES (1,1,54,1,1),(2,2,54,2,1),(3,3,54,3,1),(4,4,54,4,1);
/*!40000 ALTER TABLE `wiki_articleforobject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_articleplugin`
--

DROP TABLE IF EXISTS `wiki_articleplugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_articleplugin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `deleted` tinyint(1) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_articleplugin_30525a19` (`article_id`),
  CONSTRAINT `article_id_refs_id_64fa106f92c648ca` FOREIGN KEY (`article_id`) REFERENCES `wiki_article` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_articleplugin`
--

LOCK TABLES `wiki_articleplugin` WRITE;
/*!40000 ALTER TABLE `wiki_articleplugin` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_articleplugin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_articlerevision`
--

DROP TABLE IF EXISTS `wiki_articlerevision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_articlerevision` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `revision_number` int(11) NOT NULL,
  `user_message` longtext NOT NULL,
  `automatic_log` longtext NOT NULL,
  `ip_address` char(15) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  `previous_revision_id` int(11) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL,
  `locked` tinyint(1) NOT NULL,
  `article_id` int(11) NOT NULL,
  `content` longtext NOT NULL,
  `title` varchar(512) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wiki_articlerevision_article_id_4b4e7910c8e7b2d0_uniq` (`article_id`,`revision_number`),
  KEY `wiki_articlerevision_fbfc09f1` (`user_id`),
  KEY `wiki_articlerevision_49bc38cc` (`previous_revision_id`),
  KEY `wiki_articlerevision_30525a19` (`article_id`),
  CONSTRAINT `article_id_refs_id_5a3b45ce5c88570a` FOREIGN KEY (`article_id`) REFERENCES `wiki_article` (`id`),
  CONSTRAINT `previous_revision_id_refs_id_7c6fe338a951e36b` FOREIGN KEY (`previous_revision_id`) REFERENCES `wiki_articlerevision` (`id`),
  CONSTRAINT `user_id_refs_id_672c6e4dfbb26714` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_articlerevision`
--

LOCK TABLES `wiki_articlerevision` WRITE;
/*!40000 ALTER TABLE `wiki_articlerevision` DISABLE KEYS */;
INSERT INTO `wiki_articlerevision` VALUES (1,1,'','',NULL,NULL,'2014-02-26 13:21:34','2014-02-26 13:21:34',NULL,0,0,1,'Welcome to the edX Wiki\n===\nVisit a course wiki to add an article.','Wiki'),(2,1,'Course page automatically created.','',NULL,NULL,'2014-02-26 13:21:34','2014-02-26 13:21:34',NULL,0,0,2,'This is the wiki for **edX**\'s _edX Demonstration Course_.','Open_DemoX'),(3,1,'课程网页已经自动创建','',NULL,NULL,'2014-06-26 08:49:59','2014-06-26 08:49:59',NULL,0,0,3,'This is the wiki for **qinghua**\'s _微积分B_.','10421084X'),(4,1,'课程网页已经自动创建','',NULL,NULL,'2014-07-31 07:03:05','2014-07-31 07:03:05',NULL,0,0,4,'This is the wiki for **diaodiyun**\'s _组合数学 _.','60240013X'),(5,2,'','',NULL,4,'2014-09-28 03:37:53','2014-09-28 03:37:53',3,0,0,3,'This is the wiki for **qinghua**\'s _微积分B_.\r\n本书分上、下册. 上册内容包括函数、极限与连续、导数与微分、微分中值定理与导数应用、不定积分和定积分及其应用.下册内容包括向量与空间解析几何、多元函数微分学、二重积分、无穷级数、常微分方程和差分方程.\r\n与本书(上、下册) 配套的有习题课教材、电子教案. 该套教材汲取了现行教学改革中一些成功的举措, 总结了作者在教学科研方面的研究成果,注重数学在经济管理领域中的应用, 选用大量有关的例题与习题；具有结构严谨、逻辑清楚、循序渐进、结合实际等特点.可作为高等学校经济、管理、金融及相关专业的教材或教学参考书.','10421084X'),(6,3,'','',NULL,4,'2014-09-28 03:38:07','2014-09-28 03:38:07',5,0,0,3,'微积分B_.\r\n本书分上、下册. 上册内容包括函数、极限与连续、导数与微分、微分中值定理与导数应用、不定积分和定积分及其应用.下册内容包括向量与空间解析几何、多元函数微分学、二重积分、无穷级数、常微分方程和差分方程.\r\n与本书(上、下册) 配套的有习题课教材、电子教案. 该套教材汲取了现行教学改革中一些成功的举措, 总结了作者在教学科研方面的研究成果,注重数学在经济管理领域中的应用, 选用大量有关的例题与习题；具有结构严谨、逻辑清楚、循序渐进、结合实际等特点.可作为高等学校经济、管理、金融及相关专业的教材或教学参考书.','10421084X'),(7,2,'','',NULL,4,'2014-09-28 06:15:56','2014-09-28 06:15:56',4,0,0,4,'本书是根据国家教育部非数学专业数学基础课教学指导分委员会制定的工科类本科数学基础课程教学基本要求编写的·内容包括： 函数与极限，一元函数微积分，向量代数与空间解析几何，多元函数微积分，级数，常微分方程等，书末附有几种常用平面曲线及其方程、积分表、场论初步等三个附录以及习题参考答案·本书对基本概念的叙述清晰准确，对基本理论的论述简明易懂，例题习题的选配典型多样，强调基本运算能力的培养及理论的实际应用·本书可用作高等学校工科类本科生和电大、职大的高等数学课程的教材，也可供教师作为教学参考书及自学高等数学课程者使用·','60240013X'),(8,3,'','',NULL,4,'2014-09-28 06:16:35','2014-09-28 06:16:35',7,0,0,4,'  本书是根据国家教育部非数学专业数学基础课教学指导分委员会制定的工科类本科数学基础课程教学基本要求编写的·内容包括： 函数与极限，一元函数微积分，向量代数与空间解析几何，多元函数微积分，级数，常微分方程等，书末附有几种常用平面曲线及其方程、积分表、场论初步等三个附录以及习题参考答案·本书对基本概念的叙述清晰准确，对基本理论的论述简明易懂，例题习题的选配典型多样，强调基本运算能力的培养及理论的实际应用·本书可用作高等学校工科类本科生和电大、职大的高等数学课程的教材，也可供教师作为教学参考书及自学高等数学课程者使用·\r\n  \r\n  数学是研究现实世界数量关系和空间形式的学科.随着现代科学技术和数学科学的发展，“数量关系”和“空间形式”有了越来越丰富的内涵和更加广泛的外延.数学不仅是一种工具，而且是一种思维模式； 不仅是一种知识，而且是一种素养； 不仅是一门科学，而且是一种文化.数学教育在培养高素质科技人才中具有其独特的、不可替代的作用.对于高等学校工科类专业的本科生而言，高等数学课程是一门非常重要的基础课，它内容丰富，理论严谨，应用广泛，影响深远.不仅为学习后继课程和进一步扩大数学知识面奠定必要的基础，而且在培养学生抽象思维、逻辑推理能力，综合利用所学知识分析问题解决问题的能力，较强的自主学习的能力，创新意识和创新能力上都具有非常重要的作用.\r\n　　本教材面对高等教育大众化的现实，以教育部非数学专业数学基础课教学指导分委员会制定的新的“工科类本科数学基础课程教学基本要求”为依据，以“必须够用”为原则确定内容和深度.知识点的覆盖面与“基本要求”相一致，要求度上略高于“基本要求”.本教材对基本概念的叙述清晰准确； 对定理的证明简明易懂，但对难度较大的理论问题则不过分强调论证的严密性，有的仅给出结论而不加证明； 对例题的选配力求典型多样，难度上层次分明，注意解题方法的总结； 强调基本运算能力的培养和理论的实际应用； 注重对学生的思维能力、自学能力和创新意识的培养.\r\n　　为便于学生自学和自我检查，本书每章之后附有小结.小结包括内容纲要、教学基本要求、本章重点难点、部分重点难点内容浅析等几个部分.基本要求的高低用不同词汇加以区分，对概念理论从高到低用“理解”、“了解”（或“知道”）二级区分； 对运算、方法从高到低用“掌握”、“能”（或“会”）二级区分.本书配有较丰富的习题，每节后的习题多为基本题，用于加深对基本概念、基本理论的理解和基本运算、方法的训练.每章后的复习题用于对该章所学知识的巩固和提高，难度有所增加，少量难度较大的题在答案中给出必要的提示，以启发学生思维，提高解题能力.\r\n　　考虑到不同学校、不同专业对高等数学课程内容广度和深度的不同要求，本书作了适当的处理，以适应不同层次、不同专业的需要； 在内容的选取上，对加*号的内容可依不同需要加以取舍，并不会影响后继内容的学习； 在教学的深度上由于配有较丰富的例题和习题，从而使教师和学生都有较大的选择余地，以满足不同层次的教学对象的要求.\r\n　　本书内容包括： 函数与极限、一元函数微积分学、空间解析几何、多元微积分学、级数、微分方程.书末附有几种常用的曲线及其方程、积分表、场论初步三个附录及习题参考答案.\r\n　　本书一元微积分部分由薛志纯、袁洁英编写，多元微积分及场论初步由薛志纯编写，空间解析几何、级数、微分方程由余慎之编写，薛志纯负责全书的统稿及多次的修改定稿.参加审稿的有东南大学王文蔚教授、南京理工大学许品芳副教授、南京邮电大学杨应弼教授及王健明、黄俊良副教授等.郦志新、周华、戴建新、张颖等参加了最近一次的修改工作.在此对所有关心支持本书的编写、修改工作的教师表示衷心的感谢.\r\n　　本书中存在的问题，欢迎专家、同行及读者批评指正.[1] \r\n','60240013X'),(9,4,'','',NULL,4,'2014-09-28 06:16:57','2014-09-28 06:16:57',8,0,0,4,'  本书是根据国家教育部非数学专业数学基础课教学指导分委员会制定的工科类本科数学基础课程教学基本要求编写的·内容包括： 函数与极限，一元函数微积分，向量代数与空间解析几何，多元函数微积分，级数，常微分方程等，书末附有几种常用平面曲线及其方程、积分表、场论初步等三个附录以及习题参考答案·本书对基本概念的叙述清晰准确，对基本理论的论述简明易懂，例题习题的选配典型多样，强调基本运算能力的培养及理论的实际应用·本书可用作高等学校工科类本科生和电大、职大的高等数学课程的教材，也可供教师作为教学参考书及自学高等数学课程者使用·\r\n  \r\n  数学是研究现实世界数量关系和空间形式的学科.随着现代科学技术和数学科学的发展，“数量关系”和“空间形式”有了越来越丰富的内涵和更加广泛的外延.数学不仅是一种工具，而且是一种思维模式； 不仅是一种知识，而且是一种素养； 不仅是一门科学，而且是一种文化.数学教育在培养高素质科技人才中具有其独特的、不可替代的作用.对于高等学校工科类专业的本科生而言，高等数学课程是一门非常重要的基础课，它内容丰富，理论严谨，应用广泛，影响深远.不仅为学习后继课程和进一步扩大数学知识面奠定必要的基础，而且在培养学生抽象思维、逻辑推理能力，综合利用所学知识分析问题解决问题的能力，较强的自主学习的能力，创新意识和创新能力上都具有非常重要的作用.\r\n  \r\n　　本教材面对高等教育大众化的现实，以教育部非数学专业数学基础课教学指导分委员会制定的新的“工科类本科数学基础课程教学基本要求”为依据，以“必须够用”为原则确定内容和深度.知识点的覆盖面与“基本要求”相一致，要求度上略高于“基本要求”.本教材对基本概念的叙述清晰准确； 对定理的证明简明易懂，但对难度较大的理论问题则不过分强调论证的严密性，有的仅给出结论而不加证明； 对例题的选配力求典型多样，难度上层次分明，注意解题方法的总结； 强调基本运算能力的培养和理论的实际应用； 注重对学生的思维能力、自学能力和创新意识的培养.\r\n  \r\n　　为便于学生自学和自我检查，本书每章之后附有小结.小结包括内容纲要、教学基本要求、本章重点难点、部分重点难点内容浅析等几个部分.基本要求的高低用不同词汇加以区分，对概念理论从高到低用“理解”、“了解”（或“知道”）二级区分； 对运算、方法从高到低用“掌握”、“能”（或“会”）二级区分.本书配有较丰富的习题，每节后的习题多为基本题，用于加深对基本概念、基本理论的理解和基本运算、方法的训练.每章后的复习题用于对该章所学知识的巩固和提高，难度有所增加，少量难度较大的题在答案中给出必要的提示，以启发学生思维，提高解题能力.\r\n  \r\n　　考虑到不同学校、不同专业对高等数学课程内容广度和深度的不同要求，本书作了适当的处理，以适应不同层次、不同专业的需要； 在内容的选取上，对加*号的内容可依不同需要加以取舍，并不会影响后继内容的学习； 在教学的深度上由于配有较丰富的例题和习题，从而使教师和学生都有较大的选择余地，以满足不同层次的教学对象的要求.\r\n  \r\n　　本书内容包括： 函数与极限、一元函数微积分学、空间解析几何、多元微积分学、级数、微分方程.书末附有几种常用的曲线及其方程、积分表、场论初步三个附录及习题参考答案.\r\n  \r\n　　本书一元微积分部分由薛志纯、袁洁英编写，多元微积分及场论初步由薛志纯编写，空间解析几何、级数、微分方程由余慎之编写，薛志纯负责全书的统稿及多次的修改定稿.参加审稿的有东南大学王文蔚教授、南京理工大学许品芳副教授、南京邮电大学杨应弼教授及王健明、黄俊良副教授等.郦志新、周华、戴建新、张颖等参加了最近一次的修改工作.在此对所有关心支持本书的编写、修改工作的教师表示衷心的感谢.\r\n  \r\n　　本书中存在的问题，欢迎专家、同行及读者批评指正.[1] \r\n','60240013X');
/*!40000 ALTER TABLE `wiki_articlerevision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_articlesubscription`
--

DROP TABLE IF EXISTS `wiki_articlesubscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_articlesubscription` (
  `subscription_ptr_id` int(11) NOT NULL,
  `articleplugin_ptr_id` int(11) NOT NULL,
  PRIMARY KEY (`articleplugin_ptr_id`),
  UNIQUE KEY `subscription_ptr_id` (`subscription_ptr_id`),
  CONSTRAINT `articleplugin_ptr_id_refs_id_7b2f9df4cbce00e3` FOREIGN KEY (`articleplugin_ptr_id`) REFERENCES `wiki_articleplugin` (`id`),
  CONSTRAINT `subscription_ptr_id_refs_id_4ec3f6dbae89f475` FOREIGN KEY (`subscription_ptr_id`) REFERENCES `notify_subscription` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_articlesubscription`
--

LOCK TABLES `wiki_articlesubscription` WRITE;
/*!40000 ALTER TABLE `wiki_articlesubscription` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_articlesubscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_attachment`
--

DROP TABLE IF EXISTS `wiki_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_attachment` (
  `reusableplugin_ptr_id` int(11) NOT NULL,
  `current_revision_id` int(11) DEFAULT NULL,
  `original_filename` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`reusableplugin_ptr_id`),
  UNIQUE KEY `current_revision_id` (`current_revision_id`),
  CONSTRAINT `current_revision_id_refs_id_66561e6e2198feb4` FOREIGN KEY (`current_revision_id`) REFERENCES `wiki_attachmentrevision` (`id`),
  CONSTRAINT `reusableplugin_ptr_id_refs_articleplugin_ptr_id_79d179a16644e87a` FOREIGN KEY (`reusableplugin_ptr_id`) REFERENCES `wiki_reusableplugin` (`articleplugin_ptr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_attachment`
--

LOCK TABLES `wiki_attachment` WRITE;
/*!40000 ALTER TABLE `wiki_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_attachmentrevision`
--

DROP TABLE IF EXISTS `wiki_attachmentrevision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_attachmentrevision` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `revision_number` int(11) NOT NULL,
  `user_message` longtext NOT NULL,
  `automatic_log` longtext NOT NULL,
  `ip_address` char(15) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  `previous_revision_id` int(11) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL,
  `locked` tinyint(1) NOT NULL,
  `attachment_id` int(11) NOT NULL,
  `file` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_attachmentrevision_fbfc09f1` (`user_id`),
  KEY `wiki_attachmentrevision_49bc38cc` (`previous_revision_id`),
  KEY `wiki_attachmentrevision_edee6011` (`attachment_id`),
  CONSTRAINT `attachment_id_refs_reusableplugin_ptr_id_33d8cf1f640583da` FOREIGN KEY (`attachment_id`) REFERENCES `wiki_attachment` (`reusableplugin_ptr_id`),
  CONSTRAINT `previous_revision_id_refs_id_5521ecec0041bbf5` FOREIGN KEY (`previous_revision_id`) REFERENCES `wiki_attachmentrevision` (`id`),
  CONSTRAINT `user_id_refs_id_2822eb682eaca84c` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_attachmentrevision`
--

LOCK TABLES `wiki_attachmentrevision` WRITE;
/*!40000 ALTER TABLE `wiki_attachmentrevision` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_attachmentrevision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_image`
--

DROP TABLE IF EXISTS `wiki_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_image` (
  `revisionplugin_ptr_id` int(11) NOT NULL,
  PRIMARY KEY (`revisionplugin_ptr_id`),
  CONSTRAINT `revisionplugin_ptr_id_refs_articleplugin_ptr_id_1a20f885fc42a0b1` FOREIGN KEY (`revisionplugin_ptr_id`) REFERENCES `wiki_revisionplugin` (`articleplugin_ptr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_image`
--

LOCK TABLES `wiki_image` WRITE;
/*!40000 ALTER TABLE `wiki_image` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_imagerevision`
--

DROP TABLE IF EXISTS `wiki_imagerevision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_imagerevision` (
  `revisionpluginrevision_ptr_id` int(11) NOT NULL,
  `image` varchar(2000),
  `width` smallint(6),
  `height` smallint(6),
  PRIMARY KEY (`revisionpluginrevision_ptr_id`),
  CONSTRAINT `revisionpluginrevision_ptr_id_refs_id_5da3ee545b9fc791` FOREIGN KEY (`revisionpluginrevision_ptr_id`) REFERENCES `wiki_revisionpluginrevision` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_imagerevision`
--

LOCK TABLES `wiki_imagerevision` WRITE;
/*!40000 ALTER TABLE `wiki_imagerevision` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_imagerevision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_reusableplugin`
--

DROP TABLE IF EXISTS `wiki_reusableplugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_reusableplugin` (
  `articleplugin_ptr_id` int(11) NOT NULL,
  PRIMARY KEY (`articleplugin_ptr_id`),
  CONSTRAINT `articleplugin_ptr_id_refs_id_2a5c48de4ca661fd` FOREIGN KEY (`articleplugin_ptr_id`) REFERENCES `wiki_articleplugin` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_reusableplugin`
--

LOCK TABLES `wiki_reusableplugin` WRITE;
/*!40000 ALTER TABLE `wiki_reusableplugin` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_reusableplugin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_reusableplugin_articles`
--

DROP TABLE IF EXISTS `wiki_reusableplugin_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_reusableplugin_articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reusableplugin_id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `wiki_reusableplugin_art_reusableplugin_id_6e34ac94afa8f9f2_uniq` (`reusableplugin_id`,`article_id`),
  KEY `wiki_reusableplugin_articles_28b0b358` (`reusableplugin_id`),
  KEY `wiki_reusableplugin_articles_30525a19` (`article_id`),
  CONSTRAINT `article_id_refs_id_854477c2f51faad` FOREIGN KEY (`article_id`) REFERENCES `wiki_article` (`id`),
  CONSTRAINT `reusableplugin_id_refs_articleplugin_ptr_id_496cabe744b45e30` FOREIGN KEY (`reusableplugin_id`) REFERENCES `wiki_reusableplugin` (`articleplugin_ptr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_reusableplugin_articles`
--

LOCK TABLES `wiki_reusableplugin_articles` WRITE;
/*!40000 ALTER TABLE `wiki_reusableplugin_articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_reusableplugin_articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_revisionplugin`
--

DROP TABLE IF EXISTS `wiki_revisionplugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_revisionplugin` (
  `articleplugin_ptr_id` int(11) NOT NULL,
  `current_revision_id` int(11),
  PRIMARY KEY (`articleplugin_ptr_id`),
  UNIQUE KEY `current_revision_id` (`current_revision_id`),
  CONSTRAINT `articleplugin_ptr_id_refs_id_2b8f815fcac31401` FOREIGN KEY (`articleplugin_ptr_id`) REFERENCES `wiki_articleplugin` (`id`),
  CONSTRAINT `current_revision_id_refs_id_2732d4b244938e26` FOREIGN KEY (`current_revision_id`) REFERENCES `wiki_revisionpluginrevision` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_revisionplugin`
--

LOCK TABLES `wiki_revisionplugin` WRITE;
/*!40000 ALTER TABLE `wiki_revisionplugin` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_revisionplugin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_revisionpluginrevision`
--

DROP TABLE IF EXISTS `wiki_revisionpluginrevision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_revisionpluginrevision` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `revision_number` int(11) NOT NULL,
  `user_message` longtext NOT NULL,
  `automatic_log` longtext NOT NULL,
  `ip_address` char(15) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `modified` datetime NOT NULL,
  `created` datetime NOT NULL,
  `previous_revision_id` int(11) DEFAULT NULL,
  `deleted` tinyint(1) NOT NULL,
  `locked` tinyint(1) NOT NULL,
  `plugin_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `wiki_revisionpluginrevision_fbfc09f1` (`user_id`),
  KEY `wiki_revisionpluginrevision_49bc38cc` (`previous_revision_id`),
  KEY `wiki_revisionpluginrevision_2857ccbf` (`plugin_id`),
  CONSTRAINT `plugin_id_refs_articleplugin_ptr_id_3e044eb541bbc69c` FOREIGN KEY (`plugin_id`) REFERENCES `wiki_revisionplugin` (`articleplugin_ptr_id`),
  CONSTRAINT `previous_revision_id_refs_id_3348918678fffe43` FOREIGN KEY (`previous_revision_id`) REFERENCES `wiki_revisionpluginrevision` (`id`),
  CONSTRAINT `user_id_refs_id_21540d2c32d8f395` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_revisionpluginrevision`
--

LOCK TABLES `wiki_revisionpluginrevision` WRITE;
/*!40000 ALTER TABLE `wiki_revisionpluginrevision` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_revisionpluginrevision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_simpleplugin`
--

DROP TABLE IF EXISTS `wiki_simpleplugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_simpleplugin` (
  `articleplugin_ptr_id` int(11) NOT NULL,
  `article_revision_id` int(11) NOT NULL,
  PRIMARY KEY (`articleplugin_ptr_id`),
  KEY `wiki_simpleplugin_b3dc49fe` (`article_revision_id`),
  CONSTRAINT `articleplugin_ptr_id_refs_id_6704e8c7a25cbfd2` FOREIGN KEY (`articleplugin_ptr_id`) REFERENCES `wiki_articleplugin` (`id`),
  CONSTRAINT `article_revision_id_refs_id_2252033b6df37b12` FOREIGN KEY (`article_revision_id`) REFERENCES `wiki_articlerevision` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_simpleplugin`
--

LOCK TABLES `wiki_simpleplugin` WRITE;
/*!40000 ALTER TABLE `wiki_simpleplugin` DISABLE KEYS */;
/*!40000 ALTER TABLE `wiki_simpleplugin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wiki_urlpath`
--

DROP TABLE IF EXISTS `wiki_urlpath`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wiki_urlpath` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(50) DEFAULT NULL,
  `site_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `lft` int(10) unsigned NOT NULL,
  `rght` int(10) unsigned NOT NULL,
  `tree_id` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL,
  `article_id` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `wiki_urlpath_site_id_124f6aa7b2cc9b82_uniq` (`site_id`,`parent_id`,`slug`),
  KEY `wiki_urlpath_a951d5d6` (`slug`),
  KEY `wiki_urlpath_6223029` (`site_id`),
  KEY `wiki_urlpath_63f17a16` (`parent_id`),
  KEY `wiki_urlpath_42b06ff6` (`lft`),
  KEY `wiki_urlpath_91543e5a` (`rght`),
  KEY `wiki_urlpath_efd07f28` (`tree_id`),
  KEY `wiki_urlpath_2a8f42e8` (`level`),
  KEY `wiki_urlpath_30525a19` (`article_id`),
  CONSTRAINT `article_id_refs_id_23bd80e7971759c9` FOREIGN KEY (`article_id`) REFERENCES `wiki_article` (`id`),
  CONSTRAINT `parent_id_refs_id_62afe7c752d1e703` FOREIGN KEY (`parent_id`) REFERENCES `wiki_urlpath` (`id`),
  CONSTRAINT `site_id_refs_id_462d2bc7f4bbaaa2` FOREIGN KEY (`site_id`) REFERENCES `django_site` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wiki_urlpath`
--

LOCK TABLES `wiki_urlpath` WRITE;
/*!40000 ALTER TABLE `wiki_urlpath` DISABLE KEYS */;
INSERT INTO `wiki_urlpath` VALUES (1,NULL,1,NULL,1,8,1,0,1),(2,'Open_DemoX',1,1,2,3,1,1,2),(3,'10421084X',1,1,4,5,1,1,3),(4,'60240013X',1,1,6,7,1,1,4);
/*!40000 ALTER TABLE `wiki_urlpath` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-09-28  8:58:16
