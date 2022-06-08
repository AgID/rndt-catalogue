CREATE DATABASE  IF NOT EXISTS `geoportal` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `geoportal`;

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
-- Table structure for table `gpt_collection`
--

DROP TABLE IF EXISTS `gpt_collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_collection` (
  `COLUUID` varchar(38) NOT NULL,
  `SHORTNAME` varchar(128) NOT NULL,
  PRIMARY KEY (`COLUUID`),
  UNIQUE KEY `SHORTNAME` (`SHORTNAME`),
  KEY `GPT_COLLECTION_IDX1` (`SHORTNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_collection_member`
--

DROP TABLE IF EXISTS `gpt_collection_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_collection_member` (
  `DOCUUID` varchar(38) NOT NULL,
  `COLUUID` varchar(38) NOT NULL,
  KEY `GPT_COLL_MEMBER_IDX1` (`DOCUUID`),
  KEY `GPT_COLL_MEMBER_IDX2` (`COLUUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_harvesting_history`
--

DROP TABLE IF EXISTS `gpt_harvesting_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_harvesting_history` (
  `UUID` varchar(38) NOT NULL,
  `HARVEST_ID` varchar(38) NOT NULL,
  `HARVEST_DATE` datetime DEFAULT NULL,
  `HARVESTED_COUNT` int DEFAULT '0',
  `VALIDATED_COUNT` int DEFAULT '0',
  `PUBLISHED_COUNT` int DEFAULT '0',
  `HARVEST_REPORT` longtext,
  PRIMARY KEY (`UUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_harvesting_jobs_completed`
--

DROP TABLE IF EXISTS `gpt_harvesting_jobs_completed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_harvesting_jobs_completed` (
  `UUID` varchar(38) NOT NULL,
  `HARVEST_ID` varchar(38) NOT NULL,
  `INPUT_DATE` datetime DEFAULT NULL,
  `HARVEST_DATE` datetime DEFAULT NULL,
  `JOB_TYPE` varchar(10) DEFAULT NULL,
  `SERVICE_ID` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`UUID`),
  KEY `GPT_HJOBSCMPLTD_IDX1` (`HARVEST_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_harvesting_jobs_pending`
--

DROP TABLE IF EXISTS `gpt_harvesting_jobs_pending`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_harvesting_jobs_pending` (
  `UUID` varchar(38) NOT NULL,
  `HARVEST_ID` varchar(38) NOT NULL,
  `INPUT_DATE` datetime DEFAULT NULL,
  `HARVEST_DATE` datetime DEFAULT NULL,
  `JOB_STATUS` varchar(10) DEFAULT NULL,
  `JOB_TYPE` varchar(10) DEFAULT NULL,
  `CRITERIA` varchar(1024) DEFAULT NULL,
  `SERVICE_ID` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`HARVEST_ID`),
  KEY `GPT_HJOBSPNDG_IDX1` (`UUID`),
  KEY `GPT_HJOBSPNDG_IDX2` (`HARVEST_DATE`),
  KEY `GPT_HJOBSPNDG_IDX3` (`INPUT_DATE`),
  KEY `GPT_HJOBSPNDG_IDX4` (`JOB_STATUS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_pa`
--

DROP TABLE IF EXISTS `gpt_pa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_pa` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `cod_ipa` varchar(45) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `ultimoID1` int DEFAULT NULL,
  `ultimoID2` int DEFAULT NULL,
  `tipoPA` varchar(255) DEFAULT NULL,
  `codiceTipoPA` varchar(45) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID_UNIQUE` (`ID`),
  UNIQUE KEY `cod_ipa_UNIQUE` (`cod_ipa`),
  UNIQUE KEY `nome_UNIQUE` (`nome`)
) ENGINE=InnoDB AUTO_INCREMENT=2115 DEFAULT CHARSET=utf8 COMMENT='Elenco delle pubbliche amministrazioni legate all''utente';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_resource`
--

DROP TABLE IF EXISTS `gpt_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_resource` (
  `DOCUUID` varchar(38) NOT NULL,
  `TITLE` varchar(4000) DEFAULT NULL,
  `OWNER` int NOT NULL,
  `INPUTDATE` datetime DEFAULT NULL,
  `UPDATEDATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ID` int NOT NULL AUTO_INCREMENT,
  `APPROVALSTATUS` varchar(64) DEFAULT NULL,
  `PUBMETHOD` varchar(64) DEFAULT NULL,
  `SITEUUID` varchar(38) DEFAULT NULL,
  `SOURCEURI` varchar(4000) DEFAULT NULL,
  `FILEIDENTIFIER` varchar(4000) DEFAULT NULL,
  `ACL` varchar(4000) DEFAULT NULL,
  `HOST_URL` varchar(255) DEFAULT NULL,
  `PROTOCOL_TYPE` varchar(20) DEFAULT NULL,
  `PROTOCOL` varchar(2000) DEFAULT NULL,
  `FREQUENCY` varchar(10) DEFAULT NULL,
  `SEND_NOTIFICATION` varchar(10) DEFAULT NULL,
  `FINDABLE` varchar(6) DEFAULT NULL,
  `SEARCHABLE` varchar(6) DEFAULT NULL,
  `SYNCHRONIZABLE` varchar(6) DEFAULT NULL,
  `LASTSYNCDATE` datetime DEFAULT NULL,
  `FILTRO_CSW` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DOCUUID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `GPT_RESOURCE_IDX1` (`SITEUUID`),
  KEY `GPT_RESOURCE_IDX2` (`FILEIDENTIFIER`(255)),
  KEY `GPT_RESOURCE_IDX3` (`SOURCEURI`(255)),
  KEY `GPT_RESOURCE_IDX4` (`UPDATEDATE`),
  KEY `GPT_RESOURCE_IDX5` (`TITLE`(255)),
  KEY `GPT_RESOURCE_IDX6` (`OWNER`),
  KEY `GPT_RESOURCE_IDX8` (`APPROVALSTATUS`),
  KEY `GPT_RESOURCE_IDX9` (`PUBMETHOD`),
  KEY `GPT_RESOURCE_IDX11` (`ACL`(255)),
  KEY `GPT_RESOURCE_IDX12` (`PROTOCOL_TYPE`),
  KEY `GPT_RESOURCE_IDX13` (`LASTSYNCDATE`)
) ENGINE=InnoDB AUTO_INCREMENT=126798 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_resource_data`
--

DROP TABLE IF EXISTS `gpt_resource_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_resource_data` (
  `DOCUUID` varchar(38) NOT NULL,
  `ID` int NOT NULL,
  `XML` longtext,
  `THUMBNAIL` longblob,
  PRIMARY KEY (`DOCUUID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `GPT_RESOURCE_DATA_IDX1` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_resource_data_backup`
--

DROP TABLE IF EXISTS `gpt_resource_data_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_resource_data_backup` (
  `DOCUUID` varchar(38) NOT NULL,
  `ID` int NOT NULL,
  `XML` longtext,
  `THUMBNAIL` longblob,
  PRIMARY KEY (`DOCUUID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `GPT_RESOURCE_DATA_IDX1` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_resource_stat`
--

DROP TABLE IF EXISTS `gpt_resource_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_resource_stat` (
  `DOCUUID` varchar(38) NOT NULL,
  `ID` int NOT NULL,
  `HIERARCHY` varchar(255) DEFAULT NULL,
  `RESPONSIBLE` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_resource_stat_inspire_service`
--

DROP TABLE IF EXISTS `gpt_resource_stat_inspire_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_resource_stat_inspire_service` (
  `DOCUUID` varchar(38) NOT NULL,
  `ID` int NOT NULL,
  `INSPIRE_SERVICE` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_resource_stat_inspire_theme`
--

DROP TABLE IF EXISTS `gpt_resource_stat_inspire_theme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_resource_stat_inspire_theme` (
  `DOCUUID` varchar(38) NOT NULL,
  `ID` int NOT NULL,
  `INSPIRE_THEME` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_resource_stat_opendata`
--

DROP TABLE IF EXISTS `gpt_resource_stat_opendata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_resource_stat_opendata` (
  `DOCUUID` varchar(38) NOT NULL,
  `ID` int NOT NULL,
  `OPENDATA` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_DOC` (`DOCUUID`),
  KEY `IDX_OPEN` (`OPENDATA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabella per la gestione dei dati statistici Opendata';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_resource_stat_priority_dataset`
--

DROP TABLE IF EXISTS `gpt_resource_stat_priority_dataset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_resource_stat_priority_dataset` (
  `DOCUUID` varchar(38) NOT NULL,
  `ID` int NOT NULL,
  `PRIORITYDATASET` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDX_DOC` (`DOCUUID`),
  KEY `IDX_PRIORITY` (`PRIORITYDATASET`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabella per la gestione dei dati statistici Priority Dataset';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_resource_stat_service_type`
--

DROP TABLE IF EXISTS `gpt_resource_stat_service_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_resource_stat_service_type` (
  `DOCUUID` varchar(38) NOT NULL,
  `ID` int NOT NULL,
  `SERVICE_TYPE` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_resource_stat_topic`
--

DROP TABLE IF EXISTS `gpt_resource_stat_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_resource_stat_topic` (
  `DOCUUID` varchar(38) NOT NULL,
  `ID` int NOT NULL,
  `TOPIC` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_search`
--

DROP TABLE IF EXISTS `gpt_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_search` (
  `UUID` varchar(38) NOT NULL,
  `NAME` varchar(255) DEFAULT NULL,
  `USERID` int DEFAULT NULL,
  `CRITERIA` longtext,
  PRIMARY KEY (`UUID`),
  KEY `GPT_SEARCH_IDX1` (`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_tipoente`
--

DROP TABLE IF EXISTS `gpt_tipoente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_tipoente` (
  `codiceTipo` varchar(45) NOT NULL,
  `nomeTipo` varchar(255) NOT NULL,
  PRIMARY KEY (`codiceTipo`),
  UNIQUE KEY `nomeTipo_UNIQUE` (`nomeTipo`),
  UNIQUE KEY `codiceTipo_UNIQUE` (`codiceTipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_user`
--

DROP TABLE IF EXISTS `gpt_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_user` (
  `USERID` int NOT NULL AUTO_INCREMENT,
  `DN` varchar(900) DEFAULT NULL,
  `USERNAME` varchar(64) DEFAULT NULL,
  `FK_IDPA` int DEFAULT NULL,
  PRIMARY KEY (`USERID`),
  UNIQUE KEY `DN_UNIQUE` (`DN`),
  UNIQUE KEY `USERNAME_UNIQUE` (`USERNAME`),
  KEY `GPT_USER_IDX1` (`DN`(255)),
  KEY `GPT_USER_IDX2` (`USERNAME`)
) ENGINE=InnoDB AUTO_INCREMENT=1149 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gpt_user_login`
--

DROP TABLE IF EXISTS `gpt_user_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gpt_user_login` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `USERID` int DEFAULT NULL,
  `DATA_IN` datetime DEFAULT NULL,
  `DATA_OUT` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `GPT_USER_IDX2` (`USERID`)
) ENGINE=InnoDB AUTO_INCREMENT=5965 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

