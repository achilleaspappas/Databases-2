-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 22, 2020 at 04:31 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `travel_packets`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `find_packets` (IN `client_email` VARCHAR(40), OUT `reserved_packets` INT(10), OUT `sum_cost` FLOAT(10,2))  BEGIN
SELECT COUNT(cp.packet_num) INTO reserved_packets FROM packets AS p 
JOIN chosen_packet AS cp ON p.packet_num = cp.packet_num
JOIN customers AS c ON c.customer_num = cp.customer_num
WHERE email = client_email;
SELECT SUM(p.cost) INTO sum_cost FROM packets AS p 
JOIN chosen_packet AS cp ON p.packet_num = cp.packet_num
JOIN customers AS c ON c.customer_num = cp.customer_num
WHERE email = client_email;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `duration` () RETURNS VARCHAR(40) CHARSET utf8mb4 BEGIN
DECLARE lect_list VARCHAR(255) DEFAULT "";
DECLARE count INT DEFAULT 1;
DECLARE packages_num INT DEFAULT 0;
SET packages_num = (SELECT COUNT(*) FROM packets);
WHILE count < packages_num + 1 DO
	SET lect_list= CONCAT(lect_list, (SELECT DATEDIFF(end_date, start_date) FROM packets WHERE packet_num = count), ", ");
	SET count = count + 1;
END WHILE;
RETURN lect_list;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `category_num` int(5) NOT NULL,
  `category` varchar(15) DEFAULT NULL,
  `sum_reserved` int(5) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_num`, `category`, `sum_reserved`) VALUES
(1, 'Romantic', 1),
(2, 'Winter', 1),
(3, 'Summer', 4),
(4, 'Relaxing', 1),
(5, 'Educational', 1),
(6, 'Adventurous', 2);

-- --------------------------------------------------------

--
-- Table structure for table `chosen_packet`
--

CREATE TABLE `chosen_packet` (
  `customer_num` int(5) NOT NULL,
  `packet_num` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `chosen_packet`
--

INSERT INTO `chosen_packet` (`customer_num`, `packet_num`) VALUES
(1, 6),
(1, 7),
(2, 3),
(2, 9),
(3, 2),
(4, 1),
(5, 4),
(5, 10);

--
-- Triggers `chosen_packet`
--
DELIMITER $$
CREATE TRIGGER `delete_sum_reserved` AFTER DELETE ON `chosen_packet` FOR EACH ROW BEGIN
DECLARE num_of_categories INT(5) DEFAULT 0;
DECLARE count INT(5) DEFAULT 0;
SET num_of_categories = (SELECT COUNT(category_num) FROM packet_category_link
WHERE packet_num = OLD.packet_num
GROUP BY packet_num);
WHILE count < num_of_categories + 1 DO
	UPDATE category SET sum_reserved = sum_reserved - 1
	WHERE category_num = 
		(SELECT category_num FROM packet_category_link AS pcl
		JOIN chosen_packet AS cp ON pcl.packet_num = cp.packet_num 
		WHERE pcl.packet_num = OLD.packet_num
		LIMIT count, 1);
SET count = count + 1;
END WHILE;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_sum_reserved` AFTER INSERT ON `chosen_packet` FOR EACH ROW BEGIN
DECLARE num_of_categories INT(5) DEFAULT 0;
DECLARE count INT(5) DEFAULT 1;
SET num_of_categories = (SELECT COUNT(category_num) FROM packet_category_link
WHERE packet_num = NEW.packet_num
GROUP BY packet_num);
WHILE count < num_of_categories + 1 DO
	UPDATE category SET sum_reserved = sum_reserved + 1
	WHERE category_num = 
		(SELECT category_num FROM packet_category_link AS pcl
		JOIN chosen_packet AS cp ON pcl.packet_num = cp.packet_num 
		WHERE pcl.packet_num = NEW.packet_num
		LIMIT count,1);
SET count = count + 1;
END WHILE;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_sum_reserved` AFTER UPDATE ON `chosen_packet` FOR EACH ROW BEGIN
DECLARE num_of_categories INT(5) DEFAULT 0;
DECLARE count_add INT(5) DEFAULT 1;
DECLARE count_del INT(5) DEFAULT 0;

SET num_of_categories = (SELECT COUNT(category_num) FROM packet_category_link
WHERE packet_num = NEW.packet_num
GROUP BY packet_num);
WHILE count_add < num_of_categories + 1 DO
	UPDATE category SET sum_reserved = sum_reserved + 1
	WHERE category_num = 
		(SELECT category_num FROM packet_category_link AS pcl
		JOIN chosen_packet AS cp ON pcl.packet_num = cp.packet_num 
		WHERE pcl.packet_num = NEW.packet_num
		LIMIT count_add,1);
SET count_add = count_add + 1;
END WHILE;

SET num_of_categories = (SELECT COUNT(category_num) FROM packet_category_link
WHERE packet_num = OLD.packet_num
GROUP BY packet_num);
WHILE count_del < num_of_categories + 1 DO
	UPDATE category SET sum_reserved = sum_reserved - 1
	WHERE category_num = 
		(SELECT category_num FROM packet_category_link AS pcl
		JOIN chosen_packet AS cp ON pcl.packet_num = cp.packet_num 
		WHERE pcl.packet_num = OLD.packet_num
		LIMIT count_del, 1);
SET count_del = count_del + 1;
END WHILE;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_num` int(5) NOT NULL,
  `first_name` varchar(20) DEFAULT NULL,
  `last_name` varchar(20) DEFAULT NULL,
  `address` varchar(30) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_num`, `first_name`, `last_name`, `address`, `phone`, `email`) VALUES
(1, 'Elene', 'Brigestone', 'Water-lily Avenue 78', '6931408722', 'EleneBrigest@mail.com'),
(2, 'Adam', 'Smith', 'Square Street 206', '6931402414', 'Adamsmth@mail.com'),
(3, 'Maria', 'Papadimou', 'Kings Street 32', '6942944884', 'Papadimaria@mail.com'),
(4, 'Leonidas', 'Dimitriou', 'Pine Avenue 5', '6927502857', 'LeoDimitri@mail.com'),
(5, 'Mike', 'Aliston', 'Swamp Street 183', '6917374832', 'AliMike@mail.com');

-- --------------------------------------------------------

--
-- Table structure for table `packets`
--

CREATE TABLE `packets` (
  `packet_num` int(6) NOT NULL,
  `destination` varchar(20) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `transport` varchar(20) DEFAULT NULL,
  `cost` int(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `packets`
--

INSERT INTO `packets` (`packet_num`, `destination`, `start_date`, `end_date`, `transport`, `cost`) VALUES
(1, 'Paris', '2020-12-16', '2020-12-30', 'Plane', 2800),
(2, 'London', '2021-04-20', '2021-04-27', 'Plane', 1200),
(3, 'Hawaii', '2020-07-15', '2020-07-29', 'Boat', 14000),
(4, 'Hungary', '2022-07-01', '2022-07-22', 'Bus', 3000),
(5, 'New York', '2022-10-25', '2022-11-04', 'Plane', 5200),
(6, 'Marrakech', '2023-06-30', '2023-07-14', 'Plane', 6800),
(7, 'Moscow', '2021-01-02', '2021-01-18', 'Plane', 12000),
(8, 'Rodos', '2021-08-01', '2021-08-30', 'Boat', 2800),
(9, 'Volos', '2021-03-08', '2021-03-25', 'Bus', 600),
(10, 'Crete', '2021-04-12', '2021-04-23', 'Boat', 1800);

-- --------------------------------------------------------

--
-- Table structure for table `packet_category_link`
--

CREATE TABLE `packet_category_link` (
  `category_num` int(5) NOT NULL,
  `packet_num` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `packet_category_link`
--

INSERT INTO `packet_category_link` (`category_num`, `packet_num`) VALUES
(1, 1),
(2, 1),
(2, 7),
(3, 3),
(3, 4),
(3, 6),
(3, 8),
(3, 9),
(4, 3),
(4, 8),
(5, 2),
(5, 5),
(6, 6),
(6, 10);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_num`);

--
-- Indexes for table `chosen_packet`
--
ALTER TABLE `chosen_packet`
  ADD PRIMARY KEY (`customer_num`,`packet_num`),
  ADD KEY `packet_num` (`packet_num`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_num`);

--
-- Indexes for table `packets`
--
ALTER TABLE `packets`
  ADD PRIMARY KEY (`packet_num`);

--
-- Indexes for table `packet_category_link`
--
ALTER TABLE `packet_category_link`
  ADD PRIMARY KEY (`category_num`,`packet_num`),
  ADD KEY `packet_num` (`packet_num`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_num` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_num` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `packets`
--
ALTER TABLE `packets`
  MODIFY `packet_num` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `chosen_packet`
--
ALTER TABLE `chosen_packet`
  ADD CONSTRAINT `chosen_packet_ibfk_1` FOREIGN KEY (`customer_num`) REFERENCES `customers` (`customer_num`),
  ADD CONSTRAINT `chosen_packet_ibfk_2` FOREIGN KEY (`packet_num`) REFERENCES `packets` (`packet_num`);

--
-- Constraints for table `packet_category_link`
--
ALTER TABLE `packet_category_link`
  ADD CONSTRAINT `packet_category_link_ibfk_1` FOREIGN KEY (`category_num`) REFERENCES `category` (`category_num`),
  ADD CONSTRAINT `packet_category_link_ibfk_2` FOREIGN KEY (`packet_num`) REFERENCES `packets` (`packet_num`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
