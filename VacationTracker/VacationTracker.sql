-- MySQL dump 10.13  Distrib 5.7.12, for Win32 (AMD64)
--
-- Host: localhost    Database: vacationtracker
-- ------------------------------------------------------
-- Server version	5.1.50-community

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
-- Table structure for table `tbl_associate`
--

DROP TABLE IF EXISTS `tbl_associate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_associate` (
  `Pkey` int(11) NOT NULL AUTO_INCREMENT,
  `ID` varchar(255) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Email_ID` varchar(255) NOT NULL,
  `team_ID` int(11) DEFAULT NULL,
  `is_manager` int(11) NOT NULL,
  `Password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Pkey`),
  UNIQUE KEY `ID_UNIQUE` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_associate`
--

LOCK TABLES `tbl_associate` WRITE;
/*!40000 ALTER TABLE `tbl_associate` DISABLE KEYS */;
INSERT INTO `tbl_associate` VALUES (1,'RD042260','Agarwala,Ashish','krishna.kishore@cerner.com',1,0,'RD042260'),(2,'RD042261','BP,Karthik','krishna.kishore@cerner.com',4,0,'RD042261'),(3,'RD042262','D,Sandeep','krishna.kishore@cerner.com',1,0,'RD042262'),(4,'RD042263','Dhongade,Rakesh','krishna.kishore@cerner.com',1,1,'RD042263'),(5,'RD042264','Dubey,Vineet','krishna.kishore@cerner.com',1,0,'RD042264'),(6,'RD042265','E,Vishwanath','krishna.kishore@cerner.com',4,0,'RD042265'),(7,'RD042266','G,Ramdev','krishna.kishore@cerner.com',4,0,'RD042266'),(8,'RD042267','Guttappa,Rajesh','krishnakishore536@gmail.com',4,1,'RD042267'),(9,'RD042268','HN,Manjunatha','krishna.kishore@cerner.com',4,0,'RD042268'),(10,'RD042269','K N,Thara','krishna.kishore@cerner.com',4,0,'RD042269'),(11,'RD042270','Kamath,Vijayalakshmi','krishna.kishore@cerner.com',12,1,'RD042270'),(12,'KK047583','Kishore,Krishna','krishna.kishore@cerner.com',5,1,'KK047583'),(13,'RD042272','Kumar,Vikas','krishna.kishore@cerner.com',12,0,'RD042272'),(14,'RD042273','Leo,Anoop','krishna.kishore@cerner.com',2,1,'RD042273'),(15,'RD042274','Maity,Krishnendu','krishna.kishore@cerner.com',5,0,'RD042274'),(16,'RD042275','Mavinagidad,Amar','krishna.kishore@cerner.com',5,0,'RD042275'),(17,'RD042276','Nair,Priya','krishna.kishore@cerner.com',2,0,'RD042276'),(18,'RD042277','Nayak,Ganesh','krishna.kishore@cerner.com',6,1,'RD042277'),(19,'RD042278','Nayak,Priya','krishna.kishore@cerner.com',2,0,'RD042278'),(20,'RD042279','P,Naresh','krishna.kishore@cerner.com',3,1,'RD042279'),(21,'RD042280','Pothuganti,Ramya','krishna.kishore@cerner.com',2,0,'RD042280'),(22,'RD042281','Ramdass,Prabhu','krishna.kishore@cerner.com',2,0,'RD042281'),(23,'RD042282','Roy,Deepika','krishna.kishore@cerner.com',6,0,'RD042282'),(24,'RD042283','S,Deepak','krishna.kishore@cerner.com',6,0,'RD042283'),(25,'RD042284','Sathineedi,Madhava','krishna.kishore@cerner.com',6,0,'RD042284'),(26,'RD042285','Shetty,Akarsh','krishna.kishore@cerner.com',6,0,'RD042285'),(27,'RD042286','Singh,Amit Kumar','krishna.kishore@cerner.com',3,0,'RD042286'),(28,'RD042287','Singh,Mahipal','krishna.kishore@cerner.com',3,0,'RD042287'),(29,'RD042288','Tikku,Adhiraj','krishna.kishore@cerner.com',3,0,'RD042288'),(30,'RD042289','Tiwari,Kaushal','krishna.kishore@cerner.com',1,0,'RD042289'),(31,'RD042290','Vaish,Achal','krishna.kishore@cerner.com',1,0,'RD042290'),(32,'RD042291','Vasanth,Rahul','krishna.kishore@cerner.com',1,0,'RD042291'),(33,'RD042292','Venugopala,Nagashree','krishna.kishore@cerner.com',4,0,'RD042292'),(34,'RD042293','Vyas,Keshav','krishna.kishore@cerner.com',1,0,'RD042293'),(35,'RD042294','Suman, Kumar','krishna.kishore@cerner.com',3,0,'C12244'),(36,'RD042295','Ankit,Mishra','krishna.kishore@cerner.com',12,0,'C12245'),(37,'RD042296','RG,Rahul Goyal','krishna.kishore@cerner.com',12,0,'C12246'),(38,'RD042297',' G,Bhavya','krishna.kishore@cerner.com',12,0,'C12247');
/*!40000 ALTER TABLE `tbl_associate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_holidays`
--

DROP TABLE IF EXISTS `tbl_holidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_holidays` (
  `pkey` int(11) NOT NULL AUTO_INCREMENT,
  `Date` varchar(255) NOT NULL,
  `vacation` varchar(255) NOT NULL,
  `updated_time` datetime DEFAULT NULL,
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_holidays`
--

LOCK TABLES `tbl_holidays` WRITE;
/*!40000 ALTER TABLE `tbl_holidays` DISABLE KEYS */;
INSERT INTO `tbl_holidays` VALUES (1,'2016-01-01','New Year','2016-10-03 04:10:55'),(2,'2016-01-26','Republic Day','2016-10-03 04:10:39'),(3,'2016-03-25','Good Friday','2016-10-03 04:10:29'),(4,'2016-04-08','Ugadi','2016-10-03 04:10:29'),(5,'2016-05-01','May day','2016-10-03 04:10:29'),(6,'2016-08-15','Independence Day','2016-10-03 04:10:19'),(7,'2016-09-05','Ganesha Chaturthi','2016-10-03 04:10:19'),(8,'2016-09-12','Bakrid','2016-10-03 04:10:04'),(9,'2016-10-02','Gandhi Jayanti','2016-10-03 04:10:04'),(11,'2016-10-31','Balipadyami','2016-10-03 04:10:46'),(12,'2016-11-01','Rajyothsava Day','2016-10-03 04:10:46'),(13,'2016-11-25','Christmas ','2016-10-03 04:10:46'),(20,'2016-10-11','Vijayadashami','2016-10-03 04:10:55'),(27,'2016-10-28','band','2016-10-20 17:10:02');
/*!40000 ALTER TABLE `tbl_holidays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_roles`
--

DROP TABLE IF EXISTS `tbl_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_roles` (
  `pkey` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`pkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_roles`
--

LOCK TABLES `tbl_roles` WRITE;
/*!40000 ALTER TABLE `tbl_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_teams`
--

DROP TABLE IF EXISTS `tbl_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_teams` (
  `Pkey` int(11) NOT NULL AUTO_INCREMENT,
  `Team_Name` varchar(255) NOT NULL,
  `Max_Allowed_Vaction` int(11) NOT NULL,
  `Splil_Out_Vacation` int(11) DEFAULT NULL,
  PRIMARY KEY (`Pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_teams`
--

LOCK TABLES `tbl_teams` WRITE;
/*!40000 ALTER TABLE `tbl_teams` DISABLE KEYS */;
INSERT INTO `tbl_teams` VALUES (1,'InPatient',26,24),(2,'OutPatient',22,0),(3,'SupplyChain',22,0),(4,'Nursing',22,4),(5,'Orders',22,0),(6,'Revenue Cycle',22,0),(7,'Surginet',22,0),(12,'test team',20,10);
/*!40000 ALTER TABLE `tbl_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_vacations`
--

DROP TABLE IF EXISTS `tbl_vacations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_vacations` (
  `Pkey` int(11) NOT NULL AUTO_INCREMENT,
  `Associate_key` int(11) NOT NULL,
  `from_date` varchar(255) NOT NULL,
  `to_date` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `updated_time` datetime DEFAULT NULL,
  `show_notifications` int(11) DEFAULT NULL,
  `Comments` text,
  `Org_from_date` varchar(255) DEFAULT NULL,
  `Org_to_date` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_vacations`
--

LOCK TABLES `tbl_vacations` WRITE;
/*!40000 ALTER TABLE `tbl_vacations` DISABLE KEYS */;
INSERT INTO `tbl_vacations` VALUES (1,1,'2016-01-05','2016-01-06',0,'2 days leave','2 days leave','2016-10-20 13:10:27',NULL,NULL,'2016-01-05','2016-01-07'),(2,1,'2016-01-06','2016-01-07',0,'2 days leave','2 days leave','2016-10-20 13:10:27',NULL,NULL,'2016-01-05','2016-01-07'),(3,1,'2016-04-12','2016-04-13',1,'one day leave','one day leave','2016-10-20 13:10:15',NULL,NULL,'2016-04-12','2016-04-13'),(4,2,'2016-01-05','2016-01-06',0,'2 days leave','2 days leave','2016-10-20 13:10:27',NULL,NULL,'2016-01-05','2016-01-07'),(5,2,'2016-01-06','2016-01-07',0,'2 days leave','2 days leave','2016-10-20 13:10:27',NULL,NULL,'2016-01-05','2016-01-07'),(6,2,'2016-04-12','2016-04-13',1,'one day leave','one day leave','2016-10-20 13:10:15',NULL,NULL,'2016-04-12','2016-04-13'),(7,3,'2016-02-09','2016-02-10',0,'1 day','1 day','2016-10-20 13:10:36',NULL,NULL,'2016-02-09','2016-02-10'),(8,3,'2016-07-12','2016-07-13',0,'3 days leaves','3 days leaves','2016-10-20 13:10:37',NULL,NULL,'2016-07-12','2016-07-15'),(9,3,'2016-07-13','2016-07-14',0,'3 days leaves','3 days leaves','2016-10-20 13:10:37',NULL,NULL,'2016-07-12','2016-07-15'),(10,3,'2016-07-14','2016-07-15',0,'3 days leaves','3 days leaves','2016-10-20 13:10:37',NULL,NULL,'2016-07-12','2016-07-15'),(12,3,'2016-12-21','2016-12-22',0,'one day','one day','2016-10-20 13:10:37',NULL,NULL,'2016-12-21','2016-12-22'),(13,3,'2016-12-09','2016-12-10',2,'2 days','2 days','2016-10-20 13:10:38',1,'','2016-12-09','2016-12-13'),(14,3,'2016-12-10','2016-12-11',1,'2 days','2 days','2016-10-20 13:10:38',1,'','2016-12-09','2016-12-13'),(15,3,'2016-12-11','2016-12-12',1,'2 days','2 days','2016-10-20 13:10:38',1,'','2016-12-09','2016-12-13'),(16,3,'2016-12-12','2016-12-13',1,'2 days','2 days','2016-10-20 13:10:38',1,'','2016-12-09','2016-12-13'),(17,5,'2016-01-13','2016-01-14',0,'2 days','2 days','2016-10-20 13:10:38',NULL,NULL,'2016-01-13','2016-01-15'),(18,5,'2016-01-14','2016-01-15',0,'2 days','2 days','2016-10-20 13:10:38',NULL,NULL,'2016-01-13','2016-01-15'),(19,5,'2016-03-24','2016-03-25',0,'1 day','1 day','2016-10-20 13:10:33',NULL,NULL,'2016-03-24','2016-03-25'),(20,5,'2016-07-20','2016-07-21',0,'1 day','1 day','2016-10-20 13:10:33',NULL,NULL,'2016-07-20','2016-07-21'),(22,5,'2016-10-20','2016-10-21',0,'2 days','2 days','2016-10-20 13:10:34',NULL,NULL,'2016-10-20','2016-10-22'),(23,5,'2016-10-21','2016-10-22',0,'2 days','2 days','2016-10-20 13:10:34',NULL,NULL,'2016-10-20','2016-10-22'),(24,30,'2016-02-23','2016-02-24',1,'3 days','3 days','2016-10-20 14:10:41',NULL,NULL,'2016-02-23','2016-02-26'),(25,30,'2016-02-24','2016-02-25',2,'3 days','3 days','2016-10-20 14:10:41',NULL,NULL,'2016-02-23','2016-02-26'),(26,30,'2016-02-25','2016-02-26',1,'3 days','3 days','2016-10-20 14:10:41',NULL,NULL,'2016-02-23','2016-02-26'),(27,30,'2016-06-14','2016-06-15',0,'3 days','3 days','2016-10-20 14:10:41',NULL,NULL,'2016-06-14','2016-06-17'),(28,30,'2016-06-15','2016-06-16',0,'3 days','3 days','2016-10-20 14:10:41',NULL,NULL,'2016-06-14','2016-06-17'),(29,30,'2016-06-16','2016-06-17',0,'3 days','3 days','2016-10-20 14:10:41',NULL,NULL,'2016-06-14','2016-06-17'),(33,30,'2016-11-22','2016-11-23',2,'1 day','1 day','2016-10-20 14:10:41',0,'','2016-11-22','2016-11-23'),(34,31,'2016-05-10','2016-05-11',0,'1 day','1 day','2016-10-20 14:10:55',NULL,NULL,'2016-05-10','2016-05-11'),(35,31,'2016-10-17','2016-10-18',1,'1 day','1 day','2016-10-20 14:10:55',1,'','2016-10-17','2016-10-18'),(36,31,'2016-12-27','2016-12-28',0,'1 day','1 day','2016-10-20 14:10:55',NULL,NULL,'2016-12-27','2016-12-28'),(37,32,'2016-10-26','2016-10-27',2,'1 day','1 day','2016-10-20 14:10:07',1,'project deadline','2016-10-26','2016-10-27'),(38,30,'2016-09-13','2016-09-14',0,'3 days','3 days','2016-10-20 14:10:19',NULL,NULL,'2016-09-13','2016-09-16'),(39,30,'2016-09-14','2016-09-15',0,'3 days','3 days','2016-10-20 14:10:19',NULL,NULL,'2016-09-13','2016-09-16'),(40,30,'2016-09-15','2016-09-16',0,'3 days','3 days','2016-10-20 14:10:19',NULL,NULL,'2016-09-13','2016-09-16'),(41,30,'2016-10-04','2016-10-05',1,'3 days','3 days','2016-10-20 14:10:00',NULL,NULL,'2016-10-04','2016-10-07'),(42,30,'2016-10-05','2016-10-06',2,'3 days','3 days','2016-10-20 14:10:00',NULL,NULL,'2016-10-04','2016-10-07'),(43,30,'2016-10-06','2016-10-07',1,'3 days','3 days','2016-10-20 14:10:00',NULL,NULL,'2016-10-04','2016-10-07'),(57,1,'2016-10-14','2016-10-15',2,'1 day',' 1 day','2016-10-20 17:10:32',0,'project deadline','2016-10-14','2016-10-15'),(58,1,'2016-10-18','2016-10-19',2,'2 day','2 days.....','2016-10-20 17:10:32',0,'','2016-10-18','2016-10-20'),(59,1,'2016-10-19','2016-10-20',1,'2 day','2 days.....','2016-10-20 17:10:32',0,'','2016-10-18','2016-10-20'),(60,1,'2017-01-18','2017-01-19',0,'dsfdss','v;lksmvlvml','2016-10-20 07:10:40',NULL,NULL,'2017-01-18','2017-01-19');
/*!40000 ALTER TABLE `tbl_vacations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_vacations_copy`
--

DROP TABLE IF EXISTS `tbl_vacations_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_vacations_copy` (
  `Pkey` int(11) NOT NULL AUTO_INCREMENT,
  `Associate_key` int(11) NOT NULL,
  `from_date` varchar(255) NOT NULL,
  `to_date` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `updated_time` datetime DEFAULT NULL,
  `show_notifications` int(11) DEFAULT NULL,
  `Comments` text,
  `Org_from_date` varchar(255) DEFAULT NULL,
  `Org_to_date` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Pkey`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_vacations_copy`
--

LOCK TABLES `tbl_vacations_copy` WRITE;
/*!40000 ALTER TABLE `tbl_vacations_copy` DISABLE KEYS */;
INSERT INTO `tbl_vacations_copy` VALUES (1,1,'2016-10-06','2016-10-07',1,'sick leave','not feeling well','2016-10-03 18:10:08',0,NULL,'2016-10-06','2016-10-07'),(2,1,'2016-10-27','2016-10-28',3,'casual leave','personal reason','2016-10-03 18:10:08',0,NULL,'2016-10-27','2016-10-28'),(3,2,'2016-10-28','2016-11-03',1,'casual leave','casual Leave','2016-10-03 18:10:09',0,NULL,'2016-10-28','2016-11-03'),(4,5,'2016-11-02','2016-11-03',1,'casual leave','casual leave','2016-10-03 18:10:52',0,NULL,'2016-11-02','2016-11-03'),(5,5,'2016-10-10','2016-10-11',1,'sick leave','sick leave','2016-10-03 18:10:52',1,'','2016-10-10','2016-10-11'),(6,3,'2016-10-13','2016-10-15',2,'Request for Leave','need 2 days vacation','2016-10-03 18:10:28',0,NULL,'2016-10-13','2016-10-15'),(7,6,'2016-09-26','2016-10-01',3,'need leaves','sdf','2016-10-03 18:10:24',0,NULL,'2016-09-26','2016-10-01'),(8,7,'2016-10-25','2016-10-26',1,'leaves','leave','2016-10-03 18:10:15',0,NULL,'2016-10-25','2016-10-26'),(9,7,'2016-10-27','2016-10-28',0,'leave','leave','2016-10-03 18:10:15',0,NULL,'2016-10-27','2016-10-28'),(10,9,'2016-10-18','2016-10-21',0,'3 leaves','leaves','2016-10-03 18:10:31',0,NULL,'2016-10-18','2016-10-21'),(11,10,'2016-10-05','2016-10-06',1,'need leaves','need leaves ','2016-10-03 18:10:10',0,NULL,'2016-10-05','2016-10-06'),(12,10,'2016-10-07','2016-10-08',2,'need leaves','dsfs','2016-10-03 18:10:25',0,NULL,'2016-10-07','2016-10-08'),(13,1,'2016-10-05','2016-10-06',3,'sdv','sd','2016-10-12 23:10:09',0,'Too iregular','2016-10-05','2016-10-06'),(14,1,'2016-10-03','2016-10-04',1,'Test','Test Approved','2016-10-15 02:10:41',0,'','2016-10-03','2016-10-04'),(15,1,'2016-10-04','2016-10-05',3,'TEst Reject Freq','Test Reject Freq','2016-10-15 02:10:41',0,'You are taking too frequently.','2016-10-04','2016-10-05'),(16,1,'2016-10-07','2016-10-08',2,'Test Reject PTO','PTO','2016-10-15 02:10:41',0,'You have very less PTO Balance','2016-10-07','2016-10-08'),(17,1,'2016-10-20','2016-10-21',3,'sdf','dsf','2016-10-15 02:10:26',0,'csdc','2016-10-20','2016-10-21'),(18,1,'2016-10-19','2016-10-20',2,'sdf','df','2016-10-15 02:10:22',0,'dfr3','2016-10-19','2016-10-20'),(19,1,'2016-10-18','2016-10-19',3,'TEst Noti','Noti','2016-10-15 02:10:16',0,'wdfe','2016-10-18','2016-10-19'),(20,1,'2016-10-12','2016-10-13',2,'Noti','Notific','2016-10-15 02:10:49',0,'Less PTO','2016-10-12','2016-10-13'),(21,1,'2016-09-28','2016-09-29',2,'Past','Past','2016-10-15 02:10:40',0,'sdvsd','2016-09-28','2016-09-29'),(22,1,'2016-09-27','2016-09-28',2,'dfs','ds','2016-10-15 02:10:17',0,'sdsdv','2016-09-27','2016-09-28'),(23,1,'2016-10-21','2016-10-22',2,'Test Vaca Count','Vaca Cnt','2016-10-15 10:10:58',0,'dsf','2016-10-21','2016-10-22'),(24,1,'2016-09-29','2016-09-30',2,'Test Comments','Comments','2016-10-15 16:10:37',0,'Rejected','2016-09-29','2016-09-30'),(25,1,'2016-10-24','2016-10-25',2,'Test Rejected','Rejected','2016-10-15 18:10:19',0,'Rejected becuase you are not proper','2016-10-24','2016-10-25'),(26,1,'2016-10-25','2016-10-26',3,'Test Less PTO','Less PTO','2016-10-15 18:10:19',0,'','2016-10-25','2016-10-26'),(27,1,'2016-10-26','2016-10-27',4,'Test Too Freq','Too Freq','2016-10-15 18:10:19',0,'','2016-10-26','2016-10-27'),(28,1,'2016-11-03','2016-11-04',1,'TEst Approved','Approved','2016-10-15 18:10:19',0,'','2016-11-03','2016-11-04'),(29,1,'2016-09-26','2016-09-27',2,'TEst Not','Not','2016-10-15 18:10:12',0,'svsv','2016-09-26','2016-09-27'),(30,1,'2016-11-08','2016-11-09',2,'Test Rejected','Rejected','2016-10-15 18:10:02',0,'Rejected with Comments','2016-11-08','2016-11-09'),(31,1,'2016-11-09','2016-11-10',1,'Test Approved','Approved','2016-10-15 18:10:02',0,'','2016-11-09','2016-11-10'),(32,1,'2016-11-10','2016-11-11',3,'Test Less PTo','Less PTo','2016-10-15 18:10:02',0,'','2016-11-10','2016-11-11'),(33,1,'2016-11-11','2016-11-12',4,'Test Too Freq','Freq','2016-10-15 18:10:02',0,'','2016-11-11','2016-11-12'),(34,1,'2016-11-15','2016-11-19',2,'Test Multiple','Multiple','2016-10-15 18:10:02',0,'Rejected Multiple Leaves','2016-11-15','2016-11-19'),(35,1,'2016-11-22','2016-11-23',2,'Test Multi Rej','Rej','2016-10-15 18:10:55',0,'sdcsf','2016-11-22','2016-11-23'),(36,1,'2016-11-23','2016-11-24',1,'TEst Approv Multi','Mutli','2016-10-15 18:10:55',0,'','2016-11-23','2016-11-24'),(37,1,'2016-11-24','2016-11-25',1,'Test MAil','Mail','2016-10-15 18:10:16',0,'','2016-11-24','2016-11-25'),(38,1,'2016-12-01','2016-12-02',0,'TEst Email','Email','2016-10-15 18:10:44',NULL,NULL,'2016-12-01','2016-12-02'),(39,1,'2016-11-29','2016-11-30',0,'jhgf','hbgvfcx','2016-10-15 19:10:48',NULL,NULL,'2016-11-29','2016-11-30'),(40,1,'2017-01-10','2017-01-11',0,'nhbvc','nhbgvfc','2016-10-15 19:10:06',NULL,NULL,'2017-01-10','2017-01-11'),(42,1,'2016-12-15','2016-12-23',1,'Multiple Leaves','fsd','2016-10-16 09:10:59',0,'','2016-12-15','2016-12-23'),(44,1,'2016-12-07','2016-12-08',2,'Test Single','Single','2016-10-16 09:10:43',0,'Bcz less pto','2016-12-07','2016-12-08'),(45,1,'2016-12-26','2016-12-29',0,'Multiple','Multiple','2016-10-16 09:10:33',NULL,NULL,'2016-12-26','2016-12-29'),(46,1,'2016-12-14','2016-12-15',0,'gf','sdf','2016-10-16 09:10:37',NULL,NULL,'2016-12-14','2016-12-15'),(50,1,'2016-12-30','2017-01-04',0,'fgs','sdf','2016-10-16 09:10:02',NULL,NULL,'2016-12-30','2017-01-04'),(53,1,'2016-12-23','2016-12-24',0,'dfv','fsvd','2016-10-16 09:10:51',NULL,NULL,'2016-12-23','2016-12-24'),(55,1,'2016-12-08','2016-12-13',0,'sdf','sdfdfb','2016-10-16 09:10:33',NULL,NULL,'2016-12-08','2016-12-13');
/*!40000 ALTER TABLE `tbl_vacations_copy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_xl_tbl_associate`
--

DROP TABLE IF EXISTS `v_xl_tbl_associate`;
/*!50001 DROP VIEW IF EXISTS `v_xl_tbl_associate`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_xl_tbl_associate` AS SELECT 
 1 AS `Pkey`,
 1 AS `ID`,
 1 AS `Name`,
 1 AS `Email_ID`,
 1 AS `Team_Name`,
 1 AS `IS_MANAGER`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_xl_tbl_vacation`
--

DROP TABLE IF EXISTS `v_xl_tbl_vacation`;
/*!50001 DROP VIEW IF EXISTS `v_xl_tbl_vacation`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_xl_tbl_vacation` AS SELECT 
 1 AS `Pkey`,
 1 AS `ID`,
 1 AS `Name`,
 1 AS `From_Date`,
 1 AS `To_Date`,
 1 AS `Approved_status`,
 1 AS `Title`,
 1 AS `Description`,
 1 AS `EMAIL_ID`,
 1 AS `SHOW_NOTIFICATIONS`,
 1 AS `Comments`,
 1 AS `Org_from_date`,
 1 AS `Org_to_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_xl_tbl_associate`
--

/*!50001 DROP VIEW IF EXISTS `v_xl_tbl_associate`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_xl_tbl_associate` AS select `a`.`Pkey` AS `Pkey`,`a`.`ID` AS `ID`,`a`.`Name` AS `Name`,`a`.`Email_ID` AS `Email_ID`,ifnull(`b`.`Team_Name`,'') AS `Team_Name`,(case when (`a`.`is_manager` = '0') then 'N' else 'Y' end) AS `IS_MANAGER` from (`tbl_associate` `a` left join `tbl_teams` `b` on((`a`.`team_ID` = `b`.`Pkey`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_xl_tbl_vacation`
--

/*!50001 DROP VIEW IF EXISTS `v_xl_tbl_vacation`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_xl_tbl_vacation` AS select `a`.`Pkey` AS `Pkey`,`b`.`ID` AS `ID`,`b`.`Name` AS `Name`,`a`.`from_date` AS `From_Date`,`a`.`to_date` AS `To_Date`,(case when (`a`.`status` = '0') then 'N' when (`a`.`status` = '2') then 'R' when (`a`.`status` = '3') then 'P' when (`a`.`status` = '4') then 'F' else 'Y' end) AS `Approved_status`,`a`.`title` AS `Title`,`a`.`description` AS `Description`,`b`.`Email_ID` AS `EMAIL_ID`,(case when (`a`.`show_notifications` = '0') then 'N' when (`a`.`show_notifications` = '1') then 'Y' end) AS `SHOW_NOTIFICATIONS`,`a`.`Comments` AS `Comments`,`a`.`Org_from_date` AS `Org_from_date`,`a`.`Org_to_date` AS `Org_to_date` from (`tbl_vacations` `a` left join `tbl_associate` `b` on((`a`.`Associate_key` = `b`.`Pkey`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-21  0:32:59
