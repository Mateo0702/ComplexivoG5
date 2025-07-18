-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: pruebas
-- ------------------------------------------------------
-- Server version	9.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accesos`
--

DROP TABLE IF EXISTS `accesos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accesos` (
  `id_acceso` int NOT NULL AUTO_INCREMENT,
  `fecha` datetime DEFAULT NULL,
  `clave` varchar(50) DEFAULT NULL,
  `id_usuario` int DEFAULT NULL,
  PRIMARY KEY (`id_acceso`),
  KEY `accesos_ibfk_1` (`id_usuario`),
  CONSTRAINT `accesos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accesos`
--

LOCK TABLES `accesos` WRITE;
/*!40000 ALTER TABLE `accesos` DISABLE KEYS */;
INSERT INTO `accesos` VALUES (1,'2025-07-02 02:30:51','AxvrPd',NULL),(2,'2025-07-02 02:40:39','3ROPL4',NULL),(3,'2025-07-02 03:39:28','tySI4J',1),(4,'2025-07-02 03:39:59','BBLINM',1),(5,'2025-07-03 10:19:43','ZACu6F',NULL);
/*!40000 ALTER TABLE `accesos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `area`
--

DROP TABLE IF EXISTS `area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `area` (
  `id_area` int NOT NULL AUTO_INCREMENT,
  `nombre_area` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_area`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `area`
--

LOCK TABLES `area` WRITE;
/*!40000 ALTER TABLE `area` DISABLE KEYS */;
INSERT INTO `area` VALUES (1,'Piso Dinámico'),(2,'Trampolín '),(3,'Balón sensorial');
/*!40000 ALTER TABLE `area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `atracciones_baldosa_color`
--

DROP TABLE IF EXISTS `atracciones_baldosa_color`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `atracciones_baldosa_color` (
  `id_atraccion` int NOT NULL AUTO_INCREMENT,
  `color` varchar(50) NOT NULL,
  `interpretacion` text NOT NULL,
  PRIMARY KEY (`id_atraccion`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `atracciones_baldosa_color`
--

LOCK TABLES `atracciones_baldosa_color` WRITE;
/*!40000 ALTER TABLE `atracciones_baldosa_color` DISABLE KEYS */;
INSERT INTO `atracciones_baldosa_color` VALUES (1,'verde','El niño se siente atraído por las áreas verdes, asociadas a tranquilidad y confianza.'),(2,'amarillo','Muestra interés en zonas amarillas, posiblemente por su brillo y estimulación visual.'),(3,'celeste','Prefiere áreas celestes, relacionadas con estímulos suaves y relajantes.'),(4,'verde oscuro','Frecuenta zonas verde oscuro, lo que puede indicar búsqueda de contención o seguridad.');
/*!40000 ALTER TABLE `atracciones_baldosa_color` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `baldosas_info`
--

DROP TABLE IF EXISTS `baldosas_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `baldosas_info` (
  `baldosa` int NOT NULL,
  `color` varchar(50) DEFAULT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`baldosa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `baldosas_info`
--

LOCK TABLES `baldosas_info` WRITE;
/*!40000 ALTER TABLE `baldosas_info` DISABLE KEYS */;
INSERT INTO `baldosas_info` VALUES (1,'verde','zona esquina superior izquierda'),(2,'amarillo','zona superior central'),(3,'verde','zona esquina superior derecha'),(4,'celeste','zona lateral izquierda'),(5,'verde oscuro','zona centro'),(6,'celeste','zona lateral derecha'),(7,'verde','zona esquina inferior izquierda'),(8,'amarillo','zona inferior central'),(9,'verde','zona esquina inferior derecha');
/*!40000 ALTER TABLE `baldosas_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_pisadas_baldosa`
--

DROP TABLE IF EXISTS `detalle_pisadas_baldosa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_pisadas_baldosa` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `id_sesion` int NOT NULL,
  `baldosa` int NOT NULL,
  `total_pisadas` int NOT NULL,
  `observacion_baldosa` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `id_sesion` (`id_sesion`),
  CONSTRAINT `detalle_pisadas_baldosa_ibfk_1` FOREIGN KEY (`id_sesion`) REFERENCES `sesiones_activas_pasivas` (`id_sesion`)
) ENGINE=InnoDB AUTO_INCREMENT=244 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pisadas_baldosa`
--

LOCK TABLES `detalle_pisadas_baldosa` WRITE;
/*!40000 ALTER TABLE `detalle_pisadas_baldosa` DISABLE KEYS */;
INSERT INTO `detalle_pisadas_baldosa` VALUES (1,2,1,0,'Poco interés en esta zona'),(2,2,2,0,'Poco interés en esta zona'),(3,2,3,0,'Poco interés en esta zona'),(4,2,4,0,'Poco interés en esta zona'),(5,2,5,0,'Poco interés en esta zona'),(6,2,6,0,'Poco interés en esta zona'),(7,2,7,0,'Poco interés en esta zona'),(8,2,8,0,'Poco interés en esta zona'),(9,2,9,0,'Poco interés en esta zona'),(10,3,1,0,'Poco interés en esta zona'),(11,3,2,0,'Poco interés en esta zona'),(12,3,3,0,'Poco interés en esta zona'),(13,3,4,0,'Poco interés en esta zona'),(14,3,5,0,'Poco interés en esta zona'),(15,3,6,0,'Poco interés en esta zona'),(16,3,7,0,'Poco interés en esta zona'),(17,3,8,0,'Poco interés en esta zona'),(18,3,9,0,'Poco interés en esta zona'),(19,4,1,0,'Poco interés en esta zona'),(20,4,2,0,'Poco interés en esta zona'),(21,4,3,0,'Poco interés en esta zona'),(22,4,4,0,'Poco interés en esta zona'),(23,4,5,0,'Poco interés en esta zona'),(24,4,6,0,'Poco interés en esta zona'),(25,4,7,0,'Poco interés en esta zona'),(26,4,8,0,'Poco interés en esta zona'),(27,4,9,0,'Poco interés en esta zona'),(28,5,1,0,'Poco interés en esta zona'),(29,5,2,0,'Poco interés en esta zona'),(30,5,3,0,'Poco interés en esta zona'),(31,5,4,0,'Poco interés en esta zona'),(32,5,5,0,'Poco interés en esta zona'),(33,5,6,0,'Poco interés en esta zona'),(34,5,7,0,'Poco interés en esta zona'),(35,5,8,0,'Poco interés en esta zona'),(36,5,9,0,'Poco interés en esta zona'),(37,6,1,0,'Poco interés en esta zona'),(38,6,2,0,'Poco interés en esta zona'),(39,6,3,0,'Poco interés en esta zona'),(40,6,4,0,'Poco interés en esta zona'),(41,6,5,0,'Poco interés en esta zona'),(42,6,6,0,'Poco interés en esta zona'),(43,6,7,0,'Poco interés en esta zona'),(44,6,8,0,'Poco interés en esta zona'),(45,6,9,0,'Poco interés en esta zona'),(46,7,1,3,'Interacción adecuada'),(47,7,2,5,'Interacción adecuada'),(48,7,3,1,'Poco interés en esta zona'),(49,7,4,2,'Poco interés en esta zona'),(50,7,5,10,'Alta atracción hacia esta baldosa'),(51,7,6,3,'Interacción adecuada'),(52,7,7,0,'Poco interés en esta zona'),(53,7,8,1,'Poco interés en esta zona'),(54,7,9,0,'Poco interés en esta zona'),(55,8,1,1,'Poco interés en esta zona'),(56,8,2,0,'Poco interés en esta zona'),(57,8,3,0,'Poco interés en esta zona'),(58,8,4,0,'Poco interés en esta zona'),(59,8,5,0,'Poco interés en esta zona'),(60,8,6,0,'Poco interés en esta zona'),(61,8,7,0,'Poco interés en esta zona'),(62,8,8,0,'Poco interés en esta zona'),(63,8,9,0,'Poco interés en esta zona'),(64,9,1,6,'Interacción adecuada'),(65,9,2,3,'Interacción adecuada'),(66,9,3,0,'Poco interés en esta zona'),(67,9,4,2,'Poco interés en esta zona'),(68,9,5,1,'Poco interés en esta zona'),(69,9,6,0,'Poco interés en esta zona'),(70,9,7,0,'Poco interés en esta zona'),(71,9,8,0,'Poco interés en esta zona'),(72,9,9,0,'Poco interés en esta zona'),(73,10,1,5,'Interacción adecuada'),(74,10,2,20,'Alta atracción hacia esta baldosa'),(75,10,3,4,'Interacción adecuada'),(76,10,4,4,'Interacción adecuada'),(77,10,5,21,'Alta atracción hacia esta baldosa'),(78,10,6,16,'Alta atracción hacia esta baldosa'),(79,10,7,1,'Poco interés en esta zona'),(80,10,8,3,'Interacción adecuada'),(81,10,9,3,'Interacción adecuada'),(82,11,1,4,'Interacción adecuada'),(83,11,2,9,'Alta atracción hacia esta baldosa'),(84,11,3,3,'Interacción adecuada'),(85,11,4,13,'Alta atracción hacia esta baldosa'),(86,11,5,4,'Interacción adecuada'),(87,11,6,4,'Interacción adecuada'),(88,11,7,10,'Alta atracción hacia esta baldosa'),(89,11,8,5,'Interacción adecuada'),(90,11,9,4,'Interacción adecuada'),(91,12,1,0,'Poco interés en esta zona'),(92,12,2,0,'Poco interés en esta zona'),(93,12,3,0,'Poco interés en esta zona'),(94,12,4,0,'Poco interés en esta zona'),(95,12,5,0,'Poco interés en esta zona'),(96,12,6,0,'Poco interés en esta zona'),(97,12,7,0,'Poco interés en esta zona'),(98,12,8,0,'Poco interés en esta zona'),(99,12,9,0,'Poco interés en esta zona'),(100,13,1,14,'Alta atracción hacia esta baldosa'),(101,13,2,24,'Alta atracción hacia esta baldosa'),(102,13,3,0,'Poco interés en esta zona'),(103,13,4,11,'Alta atracción hacia esta baldosa'),(104,13,5,47,'Alta atracción hacia esta baldosa'),(105,13,6,18,'Alta atracción hacia esta baldosa'),(106,13,7,10,'Alta atracción hacia esta baldosa'),(107,13,8,14,'Alta atracción hacia esta baldosa'),(108,13,9,23,'Alta atracción hacia esta baldosa'),(109,14,1,17,'Alta atracción hacia esta baldosa'),(110,14,2,24,'Alta atracción hacia esta baldosa'),(111,14,3,0,'Poco interés en esta zona'),(112,14,4,12,'Alta atracción hacia esta baldosa'),(113,14,5,47,'Alta atracción hacia esta baldosa'),(114,14,6,18,'Alta atracción hacia esta baldosa'),(115,14,7,10,'Alta atracción hacia esta baldosa'),(116,14,8,14,'Alta atracción hacia esta baldosa'),(117,14,9,23,'Alta atracción hacia esta baldosa'),(118,15,1,31,'Alta atracción hacia esta baldosa'),(119,15,2,39,'Alta atracción hacia esta baldosa'),(120,15,3,0,'Poco interés en esta zona'),(121,15,4,13,'Alta atracción hacia esta baldosa'),(122,15,5,55,'Alta atracción hacia esta baldosa'),(123,15,6,25,'Alta atracción hacia esta baldosa'),(124,15,7,11,'Alta atracción hacia esta baldosa'),(125,15,8,17,'Alta atracción hacia esta baldosa'),(126,15,9,25,'Alta atracción hacia esta baldosa'),(127,16,1,31,'Alta atracción hacia esta baldosa'),(128,16,2,39,'Alta atracción hacia esta baldosa'),(129,16,3,0,'Poco interés en esta zona'),(130,16,4,13,'Alta atracción hacia esta baldosa'),(131,16,5,55,'Alta atracción hacia esta baldosa'),(132,16,6,25,'Alta atracción hacia esta baldosa'),(133,16,7,11,'Alta atracción hacia esta baldosa'),(134,16,8,17,'Alta atracción hacia esta baldosa'),(135,16,9,25,'Alta atracción hacia esta baldosa'),(136,17,1,31,'Alta atracción hacia esta baldosa'),(137,17,2,39,'Alta atracción hacia esta baldosa'),(138,17,3,0,'Poco interés en esta zona'),(139,17,4,13,'Alta atracción hacia esta baldosa'),(140,17,5,55,'Alta atracción hacia esta baldosa'),(141,17,6,25,'Alta atracción hacia esta baldosa'),(142,17,7,11,'Alta atracción hacia esta baldosa'),(143,17,8,17,'Alta atracción hacia esta baldosa'),(144,17,9,25,'Alta atracción hacia esta baldosa'),(145,18,1,31,'Alta atracción hacia esta baldosa'),(146,18,2,39,'Alta atracción hacia esta baldosa'),(147,18,3,0,'Poco interés en esta zona'),(148,18,4,13,'Alta atracción hacia esta baldosa'),(149,18,5,55,'Alta atracción hacia esta baldosa'),(150,18,6,25,'Alta atracción hacia esta baldosa'),(151,18,7,11,'Alta atracción hacia esta baldosa'),(152,18,8,17,'Alta atracción hacia esta baldosa'),(153,18,9,25,'Alta atracción hacia esta baldosa'),(154,19,1,31,'Alta atracción hacia esta baldosa'),(155,19,2,39,'Alta atracción hacia esta baldosa'),(156,19,3,0,'Poco interés en esta zona'),(157,19,4,13,'Alta atracción hacia esta baldosa'),(158,19,5,55,'Alta atracción hacia esta baldosa'),(159,19,6,25,'Alta atracción hacia esta baldosa'),(160,19,7,11,'Alta atracción hacia esta baldosa'),(161,19,8,17,'Alta atracción hacia esta baldosa'),(162,19,9,25,'Alta atracción hacia esta baldosa'),(163,20,1,31,'Alta atracción hacia esta baldosa'),(164,20,2,39,'Alta atracción hacia esta baldosa'),(165,20,3,0,'Poco interés en esta zona'),(166,20,4,13,'Alta atracción hacia esta baldosa'),(167,20,5,55,'Alta atracción hacia esta baldosa'),(168,20,6,25,'Alta atracción hacia esta baldosa'),(169,20,7,11,'Alta atracción hacia esta baldosa'),(170,20,8,17,'Alta atracción hacia esta baldosa'),(171,20,9,25,'Alta atracción hacia esta baldosa'),(172,21,1,31,'Alta atracción hacia esta baldosa'),(173,21,2,39,'Alta atracción hacia esta baldosa'),(174,21,3,0,'Poco interés en esta zona'),(175,21,4,13,'Alta atracción hacia esta baldosa'),(176,21,5,55,'Alta atracción hacia esta baldosa'),(177,21,6,25,'Alta atracción hacia esta baldosa'),(178,21,7,11,'Alta atracción hacia esta baldosa'),(179,21,8,17,'Alta atracción hacia esta baldosa'),(180,21,9,25,'Alta atracción hacia esta baldosa'),(181,22,1,31,'Alta atracción hacia esta baldosa'),(182,22,2,39,'Alta atracción hacia esta baldosa'),(183,22,3,0,'Poco interés en esta zona'),(184,22,4,13,'Alta atracción hacia esta baldosa'),(185,22,5,55,'Alta atracción hacia esta baldosa'),(186,22,6,25,'Alta atracción hacia esta baldosa'),(187,22,7,11,'Alta atracción hacia esta baldosa'),(188,22,8,17,'Alta atracción hacia esta baldosa'),(189,22,9,25,'Alta atracción hacia esta baldosa'),(190,23,1,17,'Alta atracción hacia esta baldosa'),(191,23,2,24,'Alta atracción hacia esta baldosa'),(192,23,3,0,'Poco interés en esta zona'),(193,23,4,12,'Alta atracción hacia esta baldosa'),(194,23,5,47,'Alta atracción hacia esta baldosa'),(195,23,6,18,'Alta atracción hacia esta baldosa'),(196,23,7,10,'Alta atracción hacia esta baldosa'),(197,23,8,14,'Alta atracción hacia esta baldosa'),(198,23,9,23,'Alta atracción hacia esta baldosa'),(199,24,1,17,'Alta atracción hacia esta baldosa'),(200,24,2,24,'Alta atracción hacia esta baldosa'),(201,24,3,0,'Poco interés en esta zona'),(202,24,4,12,'Alta atracción hacia esta baldosa'),(203,24,5,47,'Alta atracción hacia esta baldosa'),(204,24,6,18,'Alta atracción hacia esta baldosa'),(205,24,7,10,'Alta atracción hacia esta baldosa'),(206,24,8,14,'Alta atracción hacia esta baldosa'),(207,24,9,23,'Alta atracción hacia esta baldosa'),(208,25,1,0,'Poco interés en esta zona'),(209,25,2,0,'Poco interés en esta zona'),(210,25,3,0,'Poco interés en esta zona'),(211,25,4,0,'Poco interés en esta zona'),(212,25,5,0,'Poco interés en esta zona'),(213,25,6,0,'Poco interés en esta zona'),(214,25,7,0,'Poco interés en esta zona'),(215,25,8,0,'Poco interés en esta zona'),(216,25,9,0,'Poco interés en esta zona'),(217,26,1,0,'Poco interés en esta zona'),(218,26,2,0,'Poco interés en esta zona'),(219,26,3,0,'Poco interés en esta zona'),(220,26,4,0,'Poco interés en esta zona'),(221,26,5,0,'Poco interés en esta zona'),(222,26,6,0,'Poco interés en esta zona'),(223,26,7,0,'Poco interés en esta zona'),(224,26,8,0,'Poco interés en esta zona'),(225,26,9,0,'Poco interés en esta zona'),(226,27,1,11,'Alta atracción hacia esta baldosa'),(227,27,2,5,'Interacción adecuada'),(228,27,3,0,'Poco interés en esta zona'),(229,27,4,5,'Interacción adecuada'),(230,27,5,6,'Interacción adecuada'),(231,27,6,6,'Interacción adecuada'),(232,27,7,1,'Poco interés en esta zona'),(233,27,8,3,'Interacción adecuada'),(234,27,9,1,'Poco interés en esta zona'),(235,28,1,4,'Interacción adecuada'),(236,28,2,0,'Poco interés en esta zona'),(237,28,3,0,'Poco interés en esta zona'),(238,28,4,9,'Alta atracción hacia esta baldosa'),(239,28,5,0,'Poco interés en esta zona'),(240,28,6,0,'Poco interés en esta zona'),(241,28,7,3,'Interacción adecuada'),(242,28,8,0,'Poco interés en esta zona'),(243,28,9,0,'Poco interés en esta zona');
/*!40000 ALTER TABLE `detalle_pisadas_baldosa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intentos_sesion`
--

DROP TABLE IF EXISTS `intentos_sesion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `intentos_sesion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_sesion` varchar(50) DEFAULT NULL,
  `baldosa` int DEFAULT NULL,
  `resultado` enum('acierto','error') DEFAULT NULL,
  `modo` varchar(20) DEFAULT NULL,
  `tiempo` float DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_sesion` (`id_sesion`),
  CONSTRAINT `intentos_sesion_ibfk_1` FOREIGN KEY (`id_sesion`) REFERENCES `sesiones_activas` (`id_sesion`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intentos_sesion`
--

LOCK TABLES `intentos_sesion` WRITE;
/*!40000 ALTER TABLE `intentos_sesion` DISABLE KEYS */;
INSERT INTO `intentos_sesion` VALUES (1,'juego1607251145',3,'acierto','normal',3.801,'2025-07-16 11:45:27'),(2,'juego1607251145',2,'acierto','normal',6.097,'2025-07-16 11:45:28'),(3,'juego1607251145',5,'acierto','normal',7.596,'2025-07-16 11:45:30'),(4,'juego1607251145',4,'acierto','normal',9.193,'2025-07-16 11:45:31'),(5,'juego1607251145',7,'acierto','normal',0.957,'2025-07-16 11:45:33'),(6,'juego1607251145',9,'acierto','normal',2.006,'2025-07-16 11:45:34'),(7,'juego1607251145',3,'error','normal',6.83,'2025-07-16 11:45:39'),(8,'juego1607251145',2,'acierto','normal',7.654,'2025-07-16 11:45:40'),(9,'juego1607251145',2,'acierto','normal',0.829,'2025-07-16 11:45:43'),(10,'juego1607251145',8,'acierto','normal',2.326,'2025-07-16 11:45:45'),(11,'juego1607251145',7,'acierto','normal',3.99,'2025-07-16 11:45:46'),(12,'juego1607251145',8,'acierto','inverso',2.03,'2025-07-16 11:45:56'),(13,'juego1607251145',6,'acierto','inverso',3.543,'2025-07-16 11:45:58'),(14,'juego1607251145',4,'acierto','inverso',4.968,'2025-07-16 11:45:59'),(15,'juego1607251145',1,'acierto','inverso',6.434,'2025-07-16 11:46:01'),(16,'juego1607251145',7,'acierto','inverso',7.527,'2025-07-16 11:46:02'),(17,'juego1607251145',7,'error','inverso',0.069,'2025-07-16 11:46:04'),(18,'juego1607251145',8,'acierto','inverso',1.982,'2025-07-16 11:46:06'),(19,'juego1607251145',9,'acierto','inverso',4.207,'2025-07-16 11:46:08'),(20,'juego1607251145',6,'acierto','inverso',6.531,'2025-07-16 11:46:11'),(21,'juego1607251145',2,'acierto','inverso',8.036,'2025-07-16 11:46:12'),(22,'juego1607251145',1,'acierto','inverso',9.261,'2025-07-16 11:46:14'),(23,'juego1607251145',7,'acierto','inverso',0.49,'2025-07-16 11:46:15'),(24,'juego1607251145',8,'error','inverso',3.364,'2025-07-16 11:46:18'),(25,'juego1607251145',6,'error','inverso',5.277,'2025-07-16 11:46:20'),(26,'juego1607251145',3,'error','inverso',6.775,'2025-07-16 11:46:21'),(27,'juego1607251145',5,'acierto','inverso',8.299,'2025-07-16 11:46:23'),(28,'juego1607251231',1,'error','normal',2.29,'2025-07-16 12:33:02'),(29,'juego1607251231',4,'error','normal',6.014,'2025-07-16 12:33:05'),(30,'juego1607251231',2,'acierto','normal',9.288,'2025-07-16 12:33:08'),(31,'juego1607251231',5,'acierto','normal',0.557,'2025-07-16 12:33:10'),(32,'juego1607251231',4,'error','normal',2.204,'2025-07-16 12:33:11'),(33,'juego1607251231',1,'acierto','normal',3.578,'2025-07-16 12:33:13'),(34,'juego1607251231',2,'error','normal',5.102,'2025-07-16 12:33:14'),(35,'juego1607251231',7,'error','normal',7.894,'2025-07-16 12:33:17'),(36,'juego1607251231',1,'acierto','normal',1.19,'2025-07-16 12:33:20'),(37,'juego1607251231',2,'acierto','normal',3.215,'2025-07-16 12:33:22'),(38,'juego1607251231',3,'acierto','normal',4.462,'2025-07-16 12:33:23'),(39,'juego1607251231',5,'error','normal',5.909,'2025-07-16 12:33:27'),(40,'juego1607251231',7,'error','normal',9.656,'2025-07-16 12:33:29'),(41,'juego1607251231',1,'acierto','inverso',1.49,'2025-07-16 12:33:32'),(42,'juego1607251231',2,'acierto','inverso',2.815,'2025-07-16 12:33:34'),(43,'juego1607251231',4,'error','inverso',4.062,'2025-07-16 12:33:35'),(44,'juego1607251231',5,'error','inverso',6.136,'2025-07-16 12:33:37'),(45,'juego1607251231',7,'error','inverso',9.133,'2025-07-16 12:33:40'),(46,'juego1607251231',4,'error','inverso',0.846,'2025-07-16 12:33:42'),(47,'juego1607251231',1,'acierto','inverso',2.021,'2025-07-16 12:33:43'),(48,'juego1607251231',2,'acierto','inverso',3.395,'2025-07-16 12:33:44'),(49,'juego1607251231',5,'acierto','inverso',4.992,'2025-07-16 12:33:46'),(50,'juego1607251231',3,'error','inverso',8.939,'2025-07-16 12:33:50'),(51,'juego1607251231',1,'error','inverso',3.168,'2025-07-16 12:33:54'),(52,'juego1607251231',4,'acierto','inverso',4.516,'2025-07-16 12:33:55'),(53,'juego1607251231',2,'error','inverso',6.441,'2025-07-16 12:33:57'),(54,'juego1607251231',5,'acierto','inverso',8.088,'2025-07-16 12:33:59'),(55,'juego1607251231',3,'acierto','inverso',9.385,'2025-07-16 12:34:00');
/*!40000 ALTER TABLE `intentos_sesion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `juegos`
--

DROP TABLE IF EXISTS `juegos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `juegos` (
  `id_juego` int NOT NULL AUTO_INCREMENT,
  `id_nino` int NOT NULL,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP,
  `aciertos` int DEFAULT '0',
  `errores` int DEFAULT '0',
  PRIMARY KEY (`id_juego`),
  KEY `id_nino` (`id_nino`),
  CONSTRAINT `juegos_ibfk_1` FOREIGN KEY (`id_nino`) REFERENCES `ninos` (`id_nino`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `juegos`
--

LOCK TABLES `juegos` WRITE;
/*!40000 ALTER TABLE `juegos` DISABLE KEYS */;
/*!40000 ALTER TABLE `juegos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ninos`
--

DROP TABLE IF EXISTS `ninos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ninos` (
  `id_nino` int NOT NULL AUTO_INCREMENT,
  `nombre_nino` varchar(100) NOT NULL,
  `edad` int DEFAULT NULL,
  `id_terapeuta` int NOT NULL,
  `apellido_nino` varchar(100) DEFAULT NULL,
  `genero` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_nino`),
  KEY `id_terapeuta` (`id_terapeuta`),
  CONSTRAINT `ninos_ibfk_1` FOREIGN KEY (`id_terapeuta`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ninos`
--

LOCK TABLES `ninos` WRITE;
/*!40000 ALTER TABLE `ninos` DISABLE KEYS */;
INSERT INTO `ninos` VALUES (1,'Juan',5,14,'Perez','Masculino'),(2,'Ana',6,1,'Gomez','Femenino'),(3,'Hernesto',9,14,'Villalta','Masculino'),(4,'Esteban',4,16,'Mora','Masculino'),(5,'francisco',12,14,'cardenas','Masculino'),(6,'Teodoro',15,14,'Coronel','Masculino');
/*!40000 ALTER TABLE `ninos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `id_rol` int NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (1,'admin'),(2,'user'),(3,'terapeuta');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sesiones_activas`
--

DROP TABLE IF EXISTS `sesiones_activas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sesiones_activas` (
  `id_sesion` varchar(50) NOT NULL,
  `id_nino` int DEFAULT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `total_aciertos` int DEFAULT NULL,
  `total_errores` int DEFAULT NULL,
  `tiempo_total` float DEFAULT NULL,
  `tiempo_promedio` float DEFAULT NULL,
  `observacion_global` text,
  PRIMARY KEY (`id_sesion`),
  KEY `id_nino` (`id_nino`),
  CONSTRAINT `sesiones_activas_ibfk_1` FOREIGN KEY (`id_nino`) REFERENCES `ninos` (`id_nino`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sesiones_activas`
--

LOCK TABLES `sesiones_activas` WRITE;
/*!40000 ALTER TABLE `sesiones_activas` DISABLE KEYS */;
INSERT INTO `sesiones_activas` VALUES ('juego1607251118',3,'2025-07-16 16:18:19','2025-07-16 16:20:48',0,0,0,0,'Bajo nivel de respuesta física'),('juego1607251145',3,'2025-07-16 16:45:09','2025-07-16 16:46:59',0,0,0,0,'Bajo nivel de respuesta física'),('juego1607251231',3,'2025-07-16 17:31:40','2025-07-16 17:34:16',14,14,58.99,4.21,'Participación dentro de lo esperado'),('juego1607251639',5,'2025-07-16 21:39:31','2025-07-16 22:18:49',0,0,0,0,'Requiere apoyo en la actividad'),('juego1707251915',6,'2025-07-18 00:15:41','2025-07-18 00:15:46',0,0,0,0,'Requiere apoyo en la actividad');
/*!40000 ALTER TABLE `sesiones_activas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sesiones_activas_pasivas`
--

DROP TABLE IF EXISTS `sesiones_activas_pasivas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sesiones_activas_pasivas` (
  `id_sesion` int NOT NULL AUTO_INCREMENT,
  `id_nino` int NOT NULL,
  `nombre_nino` varchar(100) DEFAULT NULL,
  `edad` int DEFAULT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `total_pisadas` int DEFAULT '0',
  `observacion_global` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id_sesion`),
  KEY `id_nino` (`id_nino`),
  CONSTRAINT `sesiones_activas_pasivas_ibfk_1` FOREIGN KEY (`id_nino`) REFERENCES `ninos` (`id_nino`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sesiones_activas_pasivas`
--

LOCK TABLES `sesiones_activas_pasivas` WRITE;
/*!40000 ALTER TABLE `sesiones_activas_pasivas` DISABLE KEYS */;
INSERT INTO `sesiones_activas_pasivas` VALUES (1,3,'Hernesto Villalta',9,'2025-07-10 03:56:57','2025-07-10 03:57:00',0,'Bajo nivel de respuesta física'),(2,3,'Hernesto Villalta',9,'2025-07-10 04:01:07','2025-07-10 04:01:13',0,'Bajo nivel de respuesta física'),(3,1,'Juan Perez',5,'2025-07-11 02:33:56','2025-07-11 02:34:51',0,'Bajo nivel de respuesta física'),(4,4,'Esteban Mora',4,'2025-07-11 02:45:42','2025-07-11 03:25:59',0,'Bajo nivel de respuesta física'),(5,4,'Esteban Mora',4,'2025-07-11 03:38:44','2025-07-11 14:02:37',0,'Bajo nivel de respuesta física'),(6,3,'Hernesto Villalta',9,'2025-07-11 14:08:46','2025-07-11 14:10:08',0,'Bajo nivel de respuesta física'),(7,3,'Hernesto Villalta',9,'2025-07-11 15:03:19','2025-07-11 15:04:39',25,'Bajo nivel de respuesta física'),(8,3,'Hernesto Villalta',9,'2025-07-11 15:26:26','2025-07-11 15:27:04',1,'Bajo nivel de respuesta física'),(9,3,'Hernesto Villalta',9,'2025-07-11 15:27:28','2025-07-11 15:29:08',12,'Bajo nivel de respuesta física'),(10,1,'Juan Perez',5,'2025-07-11 15:49:35','2025-07-11 15:57:55',77,'Participación dentro de lo esperado'),(11,5,'francisco cardenas',12,'2025-07-16 21:17:46','2025-07-16 21:18:51',56,'Alta actividad física (vigilar hiperactividad)'),(12,5,'francisco cardenas',12,'2025-07-17 05:01:51','2025-07-17 05:01:53',0,'Bajo nivel de respuesta física'),(13,6,'Teodoro Coronel',15,'2025-07-17 23:38:30','2025-07-17 23:39:32',161,'Alta actividad física (vigilar hiperactividad)'),(14,6,'Teodoro Coronel',15,'2025-07-17 23:44:47','2025-07-17 23:45:50',165,'Alta actividad física (vigilar hiperactividad)'),(15,6,'Teodoro Coronel',15,'2025-07-18 00:00:13','2025-07-18 00:00:46',216,'Alta actividad física (vigilar hiperactividad)'),(16,6,'Teodoro Coronel',15,'2025-07-18 00:00:13','2025-07-18 00:00:46',216,'Alta actividad física (vigilar hiperactividad)'),(17,6,'Teodoro Coronel',15,'2025-07-18 00:00:13','2025-07-18 00:00:46',216,'Alta actividad física (vigilar hiperactividad)'),(18,6,'Teodoro Coronel',15,'2025-07-18 00:00:13','2025-07-18 00:00:46',216,'Alta actividad física (vigilar hiperactividad)'),(19,6,'Teodoro Coronel',15,'2025-07-18 00:00:13','2025-07-18 00:00:46',216,'Alta actividad física (vigilar hiperactividad)'),(20,6,'Teodoro Coronel',15,'2025-07-18 00:00:13','2025-07-18 00:00:46',216,'Alta actividad física (vigilar hiperactividad)'),(21,6,'Teodoro Coronel',15,'2025-07-18 00:00:13','2025-07-18 00:00:46',216,'Alta actividad física (vigilar hiperactividad)'),(22,6,'Teodoro Coronel',15,'2025-07-18 00:00:13','2025-07-18 00:00:46',216,'Alta actividad física (vigilar hiperactividad)'),(23,6,'Teodoro Coronel',15,'2025-07-17 23:44:47','2025-07-17 23:45:50',165,'Alta actividad física (vigilar hiperactividad)'),(24,6,'Teodoro Coronel',15,'2025-07-17 23:44:47','2025-07-17 23:45:50',165,'Alta actividad física (vigilar hiperactividad)'),(25,3,'Hernesto Villalta',9,'2025-07-17 22:29:03','2025-07-17 22:29:40',0,'Bajo nivel de respuesta física'),(26,4,'Esteban Mora',4,'2025-07-17 22:32:26','2025-07-17 22:32:30',0,'Bajo nivel de respuesta física'),(27,2,'Ana Gomez',6,'2025-07-17 22:43:21','2025-07-17 22:43:54',38,'Alta actividad física (vigilar hiperactividad)'),(28,4,'Esteban Mora',4,'2025-07-17 23:22:18','2025-07-17 23:22:45',16,'Participación dentro de lo esperado');
/*!40000 ALTER TABLE `sesiones_activas_pasivas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `umbrales_baldosa`
--

DROP TABLE IF EXISTS `umbrales_baldosa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `umbrales_baldosa` (
  `id_criterio` int NOT NULL AUTO_INCREMENT,
  `minimo` int NOT NULL,
  `maximo` int DEFAULT NULL,
  `observacion` varchar(150) NOT NULL,
  PRIMARY KEY (`id_criterio`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `umbrales_baldosa`
--

LOCK TABLES `umbrales_baldosa` WRITE;
/*!40000 ALTER TABLE `umbrales_baldosa` DISABLE KEYS */;
INSERT INTO `umbrales_baldosa` VALUES (1,0,2,'Poco interés en esta zona'),(2,3,6,'Interacción adecuada'),(3,7,NULL,'Alta atracción hacia esta baldosa');
/*!40000 ALTER TABLE `umbrales_baldosa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `umbrales_juego`
--

DROP TABLE IF EXISTS `umbrales_juego`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `umbrales_juego` (
  `id` int NOT NULL AUTO_INCREMENT,
  `min_aciertos` int DEFAULT '0',
  `max_aciertos` int DEFAULT NULL,
  `min_errores` int DEFAULT '0',
  `max_errores` int DEFAULT NULL,
  `min_porcentaje_acierto` float DEFAULT '0',
  `max_porcentaje_acierto` float DEFAULT NULL,
  `min_tiempo_promedio` float DEFAULT '0',
  `max_tiempo_promedio` float DEFAULT NULL,
  `observacion` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `umbrales_juego`
--

LOCK TABLES `umbrales_juego` WRITE;
/*!40000 ALTER TABLE `umbrales_juego` DISABLE KEYS */;
INSERT INTO `umbrales_juego` VALUES (1,15,NULL,0,5,80,NULL,0,6,'Excelente desempeño'),(2,10,NULL,0,10,60,NULL,0,7,'Buen intento, sigue practicando'),(3,0,NULL,0,NULL,0,NULL,0,NULL,'Requiere apoyo en la actividad');
/*!40000 ALTER TABLE `umbrales_juego` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `umbrales_sesion`
--

DROP TABLE IF EXISTS `umbrales_sesion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `umbrales_sesion` (
  `id_criterio` int NOT NULL AUTO_INCREMENT,
  `minimo` int NOT NULL,
  `maximo` int DEFAULT NULL,
  `observacion` varchar(150) NOT NULL,
  PRIMARY KEY (`id_criterio`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `umbrales_sesion`
--

LOCK TABLES `umbrales_sesion` WRITE;
/*!40000 ALTER TABLE `umbrales_sesion` DISABLE KEYS */;
INSERT INTO `umbrales_sesion` VALUES (1,0,10,'Bajo nivel de respuesta física'),(2,11,30,'Participación dentro de lo esperado'),(3,31,NULL,'Alta actividad física (vigilar hiperactividad)');
/*!40000 ALTER TABLE `umbrales_sesion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `cedula` varchar(20) DEFAULT NULL,
  `nombre_usuario` varchar(50) DEFAULT NULL,
  `apellido_usuario` varchar(50) DEFAULT NULL,
  `password` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_area` int DEFAULT NULL,
  `id_rol` int DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  KEY `id_area` (`id_area`),
  KEY `id_rol` (`id_rol`),
  CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_area`) REFERENCES `area` (`id_area`),
  CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'0123456789','Admin','Admin','scrypt:32768:8:1$JuyLhyzU3tLXCCri$be8e30662ea0e008079232867de5049f4f5f6dadfd9afe767a27a676b3e91ffcf763fc6bf55518de56994683a30cf56ec8cf2d01cb4eaeaaeaee367ea4e91e05',NULL,1),(14,'0107949158','Mateo','Samaniego','scrypt:32768:8:1$u3OtyMmUAmYmSg8b$3a002284b7f7ab879eaca1dae07cd98d745cadd09a5007a02d19beeb241dd957b7a4587cfe46068bda70ba4d28ef9f368336cf0e02facfd99fab950edd0d27f1',2,3),(16,'1234568792','Danny','Flores','scrypt:32768:8:1$tsVtUpLiTxXEv2CE$148b7bf8d346e6341a3c1437361ecbee540f14d991a073e110bc4521aa6f8e705d79ad14c65635ee01c69da8eba6011dbf57d8a62bb1191235dbca471958fe8c',1,3);
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-18  1:01:53
