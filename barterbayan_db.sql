-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 20, 2026 at 04:36 PM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterbayan_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE `conversations` (
  `convo_id` int(11) NOT NULL,
  `user_a` int(11) NOT NULL,
  `user_b` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `conversations`
--

INSERT INTO `conversations` (`convo_id`, `user_a`, `user_b`, `created_at`) VALUES
(1, 2, 48, '2026-05-20 14:41:04'),
(2, 3, 106, '2026-05-20 14:44:45'),
(3, 1, 106, '2026-05-20 14:45:50'),
(4, 106, 107, '2026-05-20 21:14:37');

-- --------------------------------------------------------

--
-- Table structure for table `direct_messages`
--

CREATE TABLE `direct_messages` (
  `dm_id` int(11) NOT NULL,
  `convo_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `sent_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `direct_messages`
--

INSERT INTO `direct_messages` (`dm_id`, `convo_id`, `sender_id`, `content`, `is_read`, `sent_at`) VALUES
(1, 2, 106, 'pautang', 0, '2026-05-20 14:44:51'),
(2, 3, 106, 'hellow', 1, '2026-05-20 19:00:26'),
(3, 4, 107, 'Hi', 1, '2026-05-20 21:14:37'),
(4, 4, 106, 'Hello', 1, '2026-05-20 21:14:57');

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `fav_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `category` enum('electronics','vehicles','furniture','clothing','other') COLLATE utf8mb4_unicode_ci DEFAULT 'other',
  `condition_status` enum('new','like_new','good','fair','poor') COLLATE utf8mb4_unicode_ci DEFAULT 'good',
  `delivery_type` enum('pickup','cod','both') COLLATE utf8mb4_unicode_ci DEFAULT 'pickup',
  `swap_for` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images`)),
  `status` enum('available','traded','removed') COLLATE utf8mb4_unicode_ci DEFAULT 'available',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`item_id`, `user_id`, `title`, `description`, `category`, `condition_status`, `delivery_type`, `swap_for`, `images`, `status`, `created_at`) VALUES
(1, 1, 'iPhone 17 Pro Max 1TB', 'Gamit na gamit, may basag screen pero smooth parin. w/free case', 'electronics', 'fair', 'pickup', 'Gaming PC w/RTX 5090 + Konting Cash', NULL, 'available', '2026-05-20 14:39:10'),
(2, 2, 'iPhone 17 Pro Max 1TB', 'Gamit na gamit, may basag screen pero smooth parin. w/free case', 'electronics', 'fair', 'pickup', 'Gaming PC w/RTX 5090 + Konting Cash', NULL, 'available', '2026-05-20 14:39:10'),
(3, 3, 'iPhone 17 Pro Max 1TB', 'Gamit na gamit, may basag screen pero smooth parin. w/free case', 'electronics', 'fair', 'pickup', 'Gaming PC w/RTX 5090 + Konting Cash', NULL, 'available', '2026-05-20 14:39:10'),
(4, 4, 'MacBook Pro M3 14-inch 2024', '3 months old. Space Gray. Complete box. Perfect condition.', 'electronics', 'like_new', 'cod', 'iPhone 15 Pro or cash', NULL, 'available', '2026-05-20 14:39:10'),
(5, 5, 'MacBook Pro M3 14-inch 2024', '3 months old. Space Gray. Complete box. Perfect condition.', 'electronics', 'like_new', 'cod', 'iPhone 15 Pro or cash', NULL, 'available', '2026-05-20 14:39:10'),
(6, 6, 'MacBook Pro M3 14-inch 2024', '3 months old. Space Gray. Complete box. Perfect condition.', 'electronics', 'like_new', 'cod', 'iPhone 15 Pro or cash', NULL, 'available', '2026-05-20 14:39:10'),
(7, 7, 'Samsung Galaxy S24 Ultra', '6 months old. Titanium Black. With original charger and case.', 'electronics', 'like_new', 'cod', 'iPhone 15 or iPad Pro', NULL, 'available', '2026-05-20 14:39:10'),
(8, 8, 'Samsung Galaxy S24 Ultra', '6 months old. Titanium Black. With original charger and case.', 'electronics', 'like_new', 'cod', 'iPhone 15 or iPad Pro', NULL, 'available', '2026-05-20 14:39:10'),
(9, 10, 'Sony A7 IV Camera', 'Still sealed in box. Gift ko sana. With kit lens 28-70mm.', 'electronics', 'new', 'cod', 'Gaming setup or high-end laptop', NULL, 'available', '2026-05-20 14:39:10'),
(10, 11, 'Sony A7 IV Camera', 'Still sealed in box. Gift ko sana. With kit lens 28-70mm.', 'electronics', 'new', 'cod', 'Gaming setup or high-end laptop', NULL, 'available', '2026-05-20 14:39:10'),
(11, 12, 'Sony A7 IV Camera', 'Still sealed in box. Gift ko sana. With kit lens 28-70mm.', 'electronics', 'new', 'cod', 'Gaming setup or high-end laptop', NULL, 'available', '2026-05-20 14:39:10'),
(12, 13, 'iPad Air M2 256GB WiFi', '3 months old. With Apple Pencil and keyboard case.', 'electronics', 'like_new', 'both', 'iPhone 15 or gaming laptop', NULL, 'available', '2026-05-20 14:39:10'),
(13, 14, 'iPad Air M2 256GB WiFi', '3 months old. With Apple Pencil and keyboard case.', 'electronics', 'like_new', 'both', 'iPhone 15 or gaming laptop', NULL, 'available', '2026-05-20 14:39:10'),
(14, 15, 'iPad Air M2 256GB WiFi', '3 months old. With Apple Pencil and keyboard case.', 'electronics', 'like_new', 'both', 'iPhone 15 or gaming laptop', NULL, 'available', '2026-05-20 14:39:10'),
(15, 16, 'Dell XPS 15 Laptop', '1 year old. Core i7, 16GB RAM, 512GB SSD. Good condition.', 'electronics', 'good', 'cod', 'Mechanical keyboard or monitor', NULL, 'available', '2026-05-20 14:39:10'),
(16, 17, 'Dell XPS 15 Laptop', '1 year old. Core i7, 16GB RAM, 512GB SSD. Good condition.', 'electronics', 'good', 'cod', 'Mechanical keyboard or monitor', NULL, 'available', '2026-05-20 14:39:10'),
(17, 18, 'Dell XPS 15 Laptop', '1 year old. Core i7, 16GB RAM, 512GB SSD. Good condition.', 'electronics', 'good', 'cod', 'Mechanical keyboard or monitor', NULL, 'available', '2026-05-20 14:39:10'),
(18, 19, 'Xiaomi Mi 11 Ultra', '6 months old. Black. Complete accessories. Minor scratch.', 'electronics', 'good', 'both', 'iPhone or Samsung flagship', NULL, 'available', '2026-05-20 14:39:10'),
(19, 20, 'Xiaomi Mi 11 Ultra', '6 months old. Black. Complete accessories. Minor scratch.', 'electronics', 'good', 'both', 'iPhone or Samsung flagship', NULL, 'available', '2026-05-20 14:39:10'),
(20, 21, 'Xiaomi Mi 11 Ultra', '6 months old. Black. Complete accessories. Minor scratch.', 'electronics', 'good', 'both', 'iPhone or Samsung flagship', NULL, 'available', '2026-05-20 14:39:10'),
(21, 22, 'JBL Bluetooth Speaker', 'Bago pa lang. JBL Flip 6. Waterproof. 12 hours battery.', 'electronics', 'like_new', 'cod', 'Earphones or headphones', NULL, 'available', '2026-05-20 14:39:10'),
(22, 23, 'JBL Bluetooth Speaker', 'Bago pa lang. JBL Flip 6. Waterproof. 12 hours battery.', 'electronics', 'like_new', 'cod', 'Earphones or headphones', NULL, 'available', '2026-05-20 14:39:10'),
(23, 25, 'PS5 Console Digital Edition', '1 year old. With 3 controllers. Good condition.', 'electronics', 'good', 'pickup', 'Gaming PC or Xbox Series X', NULL, 'available', '2026-05-20 14:39:10'),
(24, 26, 'PS5 Console Digital Edition', '1 year old. With 3 controllers. Good condition.', 'electronics', 'good', 'pickup', 'Gaming PC or Xbox Series X', NULL, 'available', '2026-05-20 14:39:10'),
(25, 27, 'PS5 Console Digital Edition', '1 year old. With 3 controllers. Good condition.', 'electronics', 'good', 'pickup', 'Gaming PC or Xbox Series X', NULL, 'available', '2026-05-20 14:39:10'),
(26, 28, 'GoPro Hero 12', 'Brand new. Sealed box. Complete accessories.', 'electronics', 'new', 'cod', 'Drone or action camera', NULL, 'available', '2026-05-20 14:39:10'),
(27, 29, 'GoPro Hero 12', 'Brand new. Sealed box. Complete accessories.', 'electronics', 'new', 'cod', 'Drone or action camera', NULL, 'available', '2026-05-20 14:39:10'),
(28, 31, 'Smart TV 55 inch 4K', '2 years old. Samsung. Good picture quality. Remote included.', 'electronics', 'good', 'pickup', 'Refrigerator or washing machine', NULL, 'available', '2026-05-20 14:39:10'),
(29, 32, 'Smart TV 55 inch 4K', '2 years old. Samsung. Good picture quality. Remote included.', 'electronics', 'good', 'pickup', 'Refrigerator or washing machine', NULL, 'available', '2026-05-20 14:39:10'),
(30, 34, 'DJI Mini 3 Pro Drone', '6 months old. With extra batteries and case.', 'electronics', 'like_new', 'both', 'Camera or laptop', NULL, 'available', '2026-05-20 14:39:10'),
(31, 35, 'DJI Mini 3 Pro Drone', '6 months old. With extra batteries and case.', 'electronics', 'like_new', 'both', 'Camera or laptop', NULL, 'available', '2026-05-20 14:39:10'),
(32, 37, 'Logitech MX Master 3 Mouse', '6 months old. Excellent condition. Wireless.', 'electronics', 'like_new', 'cod', 'Keyboard or webcam', NULL, 'available', '2026-05-20 14:39:10'),
(33, 38, 'Logitech MX Master 3 Mouse', '6 months old. Excellent condition. Wireless.', 'electronics', 'like_new', 'cod', 'Keyboard or webcam', NULL, 'available', '2026-05-20 14:39:10'),
(34, 39, 'Logitech MX Master 3 Mouse', '6 months old. Excellent condition. Wireless.', 'electronics', 'like_new', 'cod', 'Keyboard or webcam', NULL, 'available', '2026-05-20 14:39:10'),
(35, 40, 'DSLR Canon EOS 800D', '2 years old. With kit lens. Good condition.', 'electronics', 'good', 'both', 'Mirrorless camera', NULL, 'available', '2026-05-20 14:39:10'),
(36, 41, 'DSLR Canon EOS 800D', '2 years old. With kit lens. Good condition.', 'electronics', 'good', 'both', 'Mirrorless camera', NULL, 'available', '2026-05-20 14:39:10'),
(37, 42, 'DSLR Canon EOS 800D', '2 years old. With kit lens. Good condition.', 'electronics', 'good', 'both', 'Mirrorless camera', NULL, 'available', '2026-05-20 14:39:10'),
(38, 43, 'Aircon 1HP Inverter', '1 year old. Daikin brand. Efficient at malamig pa.', 'electronics', 'good', 'pickup', 'TV or laptop', NULL, 'available', '2026-05-20 14:39:10'),
(39, 44, 'Aircon 1HP Inverter', '1 year old. Daikin brand. Efficient at malamig pa.', 'electronics', 'good', 'pickup', 'TV or laptop', NULL, 'available', '2026-05-20 14:39:10'),
(40, 46, 'Honda XRM 125 2020', 'Good running condition. Fresh PO. Registered 2026.', 'vehicles', 'good', 'pickup', 'Laptop or cash equivalent', NULL, 'available', '2026-05-20 14:39:10'),
(41, 47, 'Honda XRM 125 2020', 'Good running condition. Fresh PO. Registered 2026.', 'vehicles', 'good', 'pickup', 'Laptop or cash equivalent', NULL, 'available', '2026-05-20 14:39:10'),
(42, 48, 'Honda XRM 125 2020', 'Good running condition. Fresh PO. Registered 2026.', 'vehicles', 'good', 'pickup', 'Laptop or cash equivalent', NULL, 'available', '2026-05-20 14:39:10'),
(43, 49, 'Toyota Vios 2019 Manual', 'Well maintained. All original paint. Fresh PMS.', 'vehicles', 'good', 'pickup', 'Multicab or cash difference', NULL, 'available', '2026-05-20 14:39:10'),
(44, 50, 'Toyota Vios 2019 Manual', 'Well maintained. All original paint. Fresh PMS.', 'vehicles', 'good', 'pickup', 'Multicab or cash difference', NULL, 'available', '2026-05-20 14:39:10'),
(45, 52, 'Kawasaki Barako II 175', '2018 model. Bagong gulong at battery. Registered.', 'vehicles', 'fair', 'pickup', 'Laptop or tablet', NULL, 'available', '2026-05-20 14:39:10'),
(46, 53, 'Kawasaki Barako II 175', '2018 model. Bagong gulong at battery. Registered.', 'vehicles', 'fair', 'pickup', 'Laptop or tablet', NULL, 'available', '2026-05-20 14:39:10'),
(47, 54, 'Kawasaki Barako II 175', '2018 model. Bagong gulong at battery. Registered.', 'vehicles', 'fair', 'pickup', 'Laptop or tablet', NULL, 'available', '2026-05-20 14:39:10'),
(48, 55, 'Electric Scooter Ninebot Max', '1 year old. 400km mileage. Fast charger included.', 'vehicles', 'good', 'both', 'Folding bike or cash', NULL, 'available', '2026-05-20 14:39:10'),
(49, 56, 'Electric Scooter Ninebot Max', '1 year old. 400km mileage. Fast charger included.', 'vehicles', 'good', 'both', 'Folding bike or cash', NULL, 'available', '2026-05-20 14:39:10'),
(50, 58, 'Mountain Bike Trek Marlin 7', 'Well maintained. 29er wheels. Front suspension.', 'vehicles', 'good', 'both', 'Road bike or cash', NULL, 'available', '2026-05-20 14:39:10'),
(51, 59, 'Mountain Bike Trek Marlin 7', 'Well maintained. 29er wheels. Front suspension.', 'vehicles', 'good', 'both', 'Road bike or cash', NULL, 'available', '2026-05-20 14:39:10'),
(52, 60, 'Mountain Bike Trek Marlin 7', 'Well maintained. 29er wheels. Front suspension.', 'vehicles', 'good', 'both', 'Road bike or cash', NULL, 'available', '2026-05-20 14:39:10'),
(53, 61, 'Suzuki Multicab 2015', 'Good running condition. Fresh paint. Registered.', 'vehicles', 'fair', 'pickup', 'Smaller vehicle or cash', NULL, 'available', '2026-05-20 14:39:10'),
(54, 62, 'Suzuki Multicab 2015', 'Good running condition. Fresh paint. Registered.', 'vehicles', 'fair', 'pickup', 'Smaller vehicle or cash', NULL, 'available', '2026-05-20 14:39:10'),
(55, 63, 'Suzuki Multicab 2015', 'Good running condition. Fresh paint. Registered.', 'vehicles', 'fair', 'pickup', 'Smaller vehicle or cash', NULL, 'available', '2026-05-20 14:39:10'),
(56, 64, 'BMX Bike Stolen Thunder', 'Bago pa lang. Adult size. Chrome finish.', 'vehicles', 'like_new', 'both', 'Mountain bike or cash', NULL, 'available', '2026-05-20 14:39:10'),
(57, 65, 'BMX Bike Stolen Thunder', 'Bago pa lang. Adult size. Chrome finish.', 'vehicles', 'like_new', 'both', 'Mountain bike or cash', NULL, 'available', '2026-05-20 14:39:10'),
(58, 66, 'BMX Bike Stolen Thunder', 'Bago pa lang. Adult size. Chrome finish.', 'vehicles', 'like_new', 'both', 'Mountain bike or cash', NULL, 'available', '2026-05-20 14:39:10'),
(59, 67, 'Folding Bike Dahon', '1 year old. 20 inch wheels. Compact and lightweight.', 'vehicles', 'good', 'cod', 'Electric scooter or cash', NULL, 'available', '2026-05-20 14:39:10'),
(60, 68, 'Folding Bike Dahon', '1 year old. 20 inch wheels. Compact and lightweight.', 'vehicles', 'good', 'cod', 'Electric scooter or cash', NULL, 'available', '2026-05-20 14:39:10'),
(61, 69, 'Folding Bike Dahon', '1 year old. 20 inch wheels. Compact and lightweight.', 'vehicles', 'good', 'cod', 'Electric scooter or cash', NULL, 'available', '2026-05-20 14:39:10'),
(62, 70, 'Bangka with Outboard Motor', 'Good condition. 16 ft. With 5HP Yamaha outboard.', 'vehicles', 'fair', 'pickup', 'Generator or livestock', NULL, 'available', '2026-05-20 14:39:10'),
(63, 71, 'Bangka with Outboard Motor', 'Good condition. 16 ft. With 5HP Yamaha outboard.', 'vehicles', 'fair', 'pickup', 'Generator or livestock', NULL, 'available', '2026-05-20 14:39:10'),
(64, 72, 'Bangka with Outboard Motor', 'Good condition. 16 ft. With 5HP Yamaha outboard.', 'vehicles', 'fair', 'pickup', 'Generator or livestock', NULL, 'available', '2026-05-20 14:39:10'),
(65, 73, 'Tricycle Sidecar Complete', '2017 model. Good engine. Registered. Ready to use.', 'vehicles', 'good', 'pickup', 'Multicab or pickup truck', NULL, 'available', '2026-05-20 14:39:10'),
(66, 74, 'Tricycle Sidecar Complete', '2017 model. Good engine. Registered. Ready to use.', 'vehicles', 'good', 'pickup', 'Multicab or pickup truck', NULL, 'available', '2026-05-20 14:39:10'),
(67, 76, 'Wooden Dining Table Set', 'Narra wood, solid. 6 seater. Minor scratches lang.', 'furniture', 'good', 'pickup', 'Refrigerator or washing machine', NULL, 'available', '2026-05-20 14:39:10'),
(68, 77, 'Wooden Dining Table Set', 'Narra wood, solid. 6 seater. Minor scratches lang.', 'furniture', 'good', 'pickup', 'Refrigerator or washing machine', NULL, 'available', '2026-05-20 14:39:10'),
(69, 79, 'Narra Sala Set 3-seater', 'Full narra wood. Custom made. Maganda pa rin.', 'furniture', 'good', 'pickup', 'Refrigerator or TV 50inch', NULL, 'available', '2026-05-20 14:39:10'),
(70, 80, 'Narra Sala Set 3-seater', 'Full narra wood. Custom made. Maganda pa rin.', 'furniture', 'good', 'pickup', 'Refrigerator or TV 50inch', NULL, 'available', '2026-05-20 14:39:10'),
(71, 81, 'Narra Sala Set 3-seater', 'Full narra wood. Custom made. Maganda pa rin.', 'furniture', 'good', 'pickup', 'Refrigerator or TV 50inch', NULL, 'available', '2026-05-20 14:39:10'),
(72, 82, 'IKEA Office Chair Markus', '3 years old. Lumbar support intact. No tears.', 'furniture', 'good', 'cod', 'Standing desk or keyboard', NULL, 'available', '2026-05-20 14:39:10'),
(73, 83, 'IKEA Office Chair Markus', '3 years old. Lumbar support intact. No tears.', 'furniture', 'good', 'cod', 'Standing desk or keyboard', NULL, 'available', '2026-05-20 14:39:10'),
(74, 85, 'Sofa Bed L-shape', '2 years old. Gray fabric. Converts to bed. Good condition.', 'furniture', 'good', 'pickup', 'Dining set or aparador', NULL, 'available', '2026-05-20 14:39:10'),
(75, 86, 'Sofa Bed L-shape', '2 years old. Gray fabric. Converts to bed. Good condition.', 'furniture', 'good', 'pickup', 'Dining set or aparador', NULL, 'available', '2026-05-20 14:39:10'),
(76, 87, 'Sofa Bed L-shape', '2 years old. Gray fabric. Converts to bed. Good condition.', 'furniture', 'good', 'pickup', 'Dining set or aparador', NULL, 'available', '2026-05-20 14:39:10'),
(77, 88, 'Aparador Wooden', '4 door wooden cabinet. Solid and heavy. Good condition.', 'furniture', 'good', 'pickup', 'Sala set or bed frame', NULL, 'available', '2026-05-20 14:39:10'),
(78, 89, 'Aparador Wooden', '4 door wooden cabinet. Solid and heavy. Good condition.', 'furniture', 'good', 'pickup', 'Sala set or bed frame', NULL, 'available', '2026-05-20 14:39:10'),
(79, 91, 'Bunk Bed with Mattress', '3 years old. Double deck. With mattresses. Good condition.', 'furniture', 'good', 'pickup', 'Single bed or sala set', NULL, 'available', '2026-05-20 14:39:10'),
(80, 92, 'Bunk Bed with Mattress', '3 years old. Double deck. With mattresses. Good condition.', 'furniture', 'good', 'pickup', 'Single bed or sala set', NULL, 'available', '2026-05-20 14:39:10'),
(81, 94, 'Computer Desk Gaming', '1 year old. Black. With LED lights. Good condition.', 'furniture', 'like_new', 'cod', 'Office chair or bookshelf', NULL, 'available', '2026-05-20 14:39:10'),
(82, 95, 'Computer Desk Gaming', '1 year old. Black. With LED lights. Good condition.', 'furniture', 'like_new', 'cod', 'Office chair or bookshelf', NULL, 'available', '2026-05-20 14:39:10'),
(83, 96, 'Computer Desk Gaming', '1 year old. Black. With LED lights. Good condition.', 'furniture', 'like_new', 'cod', 'Office chair or bookshelf', NULL, 'available', '2026-05-20 14:39:10'),
(84, 97, 'Refrigerator 2-door', '3 years old. LG brand. Good cooling. No issues.', 'furniture', 'good', 'pickup', 'Washing machine or aircon', NULL, 'available', '2026-05-20 14:39:10'),
(85, 98, 'Refrigerator 2-door', '3 years old. LG brand. Good cooling. No issues.', 'furniture', 'good', 'pickup', 'Washing machine or aircon', NULL, 'available', '2026-05-20 14:39:10'),
(86, 99, 'Refrigerator 2-door', '3 years old. LG brand. Good cooling. No issues.', 'furniture', 'good', 'pickup', 'Washing machine or aircon', NULL, 'available', '2026-05-20 14:39:10'),
(87, 100, 'Washing Machine Fully Auto', '2 years old. Samsung 8kg. Good condition.', 'furniture', 'good', 'pickup', 'Refrigerator or dryer', NULL, 'available', '2026-05-20 14:39:10'),
(88, 101, 'Washing Machine Fully Auto', '2 years old. Samsung 8kg. Good condition.', 'furniture', 'good', 'pickup', 'Refrigerator or dryer', NULL, 'available', '2026-05-20 14:39:10'),
(89, 102, 'Washing Machine Fully Auto', '2 years old. Samsung 8kg. Good condition.', 'furniture', 'good', 'pickup', 'Refrigerator or dryer', NULL, 'available', '2026-05-20 14:39:10'),
(90, 103, 'Vintage Levi Denim Jacket', 'Large size. 80s vintage. Good condition.', 'clothing', 'good', 'cod', 'Other vintage items', NULL, 'available', '2026-05-20 14:39:10'),
(91, 104, 'Vintage Levi Denim Jacket', 'Large size. 80s vintage. Good condition.', 'clothing', 'good', 'cod', 'Other vintage items', NULL, 'available', '2026-05-20 14:39:10'),
(92, 1, 'Nike Air Jordan 1 High', 'Size 10. Chicago colorway. Good condition. OG box.', 'clothing', 'good', 'cod', 'Other sneakers or cash', NULL, 'available', '2026-05-20 14:39:10'),
(93, 2, 'Nike Air Jordan 1 High', 'Size 10. Chicago colorway. Good condition. OG box.', 'clothing', 'good', 'cod', 'Other sneakers or cash', NULL, 'available', '2026-05-20 14:39:10'),
(94, 4, 'Barong Tagalog Premium', 'XL size. Jusi fabric. Worn once. Good condition.', 'clothing', 'good', 'cod', 'Other formal wear', NULL, 'available', '2026-05-20 14:39:10'),
(95, 5, 'Barong Tagalog Premium', 'XL size. Jusi fabric. Worn once. Good condition.', 'clothing', 'good', 'cod', 'Other formal wear', NULL, 'available', '2026-05-20 14:39:10'),
(96, 7, 'Bundled Ukay Clothes 10pcs', 'Random bundle. Mixed sizes. Good condition.', 'clothing', 'fair', 'cod', 'Other clothes or accessories', NULL, 'available', '2026-05-20 14:39:10'),
(97, 8, 'Bundled Ukay Clothes 10pcs', 'Random bundle. Mixed sizes. Good condition.', 'clothing', 'fair', 'cod', 'Other clothes or accessories', NULL, 'available', '2026-05-20 14:39:10'),
(98, 10, 'Adidas Track Suit', 'Large size. Black with white stripes. Like new.', 'clothing', 'like_new', 'cod', 'Shoes or bag', NULL, 'available', '2026-05-20 14:39:10'),
(99, 11, 'Adidas Track Suit', 'Large size. Black with white stripes. Like new.', 'clothing', 'like_new', 'cod', 'Shoes or bag', NULL, 'available', '2026-05-20 14:39:10'),
(100, 12, 'Adidas Track Suit', 'Large size. Black with white stripes. Like new.', 'clothing', 'like_new', 'cod', 'Shoes or bag', NULL, 'available', '2026-05-20 14:39:10'),
(101, 13, '50kg NFA Rice', 'Freshly milled. Malinis at walang bato.', 'other', 'new', 'both', 'Canned goods or household items', NULL, 'available', '2026-05-20 14:39:10'),
(102, 14, '50kg NFA Rice', 'Freshly milled. Malinis at walang bato.', 'other', 'new', 'both', 'Canned goods or household items', NULL, 'available', '2026-05-20 14:39:10'),
(103, 15, '50kg NFA Rice', 'Freshly milled. Malinis at walang bato.', 'other', 'new', 'both', 'Canned goods or household items', NULL, 'available', '2026-05-20 14:39:10'),
(104, 16, 'Carabao Working', 'Malusog. Sanay sa pagsasaka. 4 years old. With harness.', 'other', 'good', 'pickup', 'Pig or goat equivalent', NULL, 'available', '2026-05-20 14:39:10'),
(105, 17, 'Carabao Working', 'Malusog. Sanay sa pagsasaka. 4 years old. With harness.', 'other', 'good', 'pickup', 'Pig or goat equivalent', NULL, 'available', '2026-05-20 14:39:10'),
(106, 19, 'Dewalt Cordless Drill Set', '18V brushless. 2 batteries, charger, bits. Light use.', 'other', 'like_new', 'both', 'Power saw or angle grinder', NULL, 'available', '2026-05-20 14:39:10'),
(107, 20, 'Dewalt Cordless Drill Set', '18V brushless. 2 batteries, charger, bits. Light use.', 'other', 'like_new', 'both', 'Power saw or angle grinder', NULL, 'available', '2026-05-20 14:39:10'),
(108, 22, 'Hamilton Beach Stand Mixer', '2 years old. Works perfectly. Complete attachments.', 'other', 'good', 'cod', 'Air fryer or blender', NULL, 'available', '2026-05-20 14:39:10'),
(109, 23, 'Hamilton Beach Stand Mixer', '2 years old. Works perfectly. Complete attachments.', 'other', 'good', 'cod', 'Air fryer or blender', NULL, 'available', '2026-05-20 14:39:10'),
(110, 25, 'Durian Fresh Box 5kg', 'Straight from farm. Mixed varieties. Ship in styro box.', 'other', 'new', 'cod', 'Mangosteen or tropical fruits', NULL, 'available', '2026-05-20 14:39:10'),
(111, 26, 'Durian Fresh Box 5kg', 'Straight from farm. Mixed varieties. Ship in styro box.', 'other', 'new', 'cod', 'Mangosteen or tropical fruits', NULL, 'available', '2026-05-20 14:39:10'),
(112, 28, 'Benguet Coffee Beans 2kg', 'Medium roast Arabica. Freshly roasted last week.', 'other', 'new', 'cod', 'Pastillas or local delicacies', NULL, 'available', '2026-05-20 14:39:10'),
(113, 29, 'Benguet Coffee Beans 2kg', 'Medium roast Arabica. Freshly roasted last week.', 'other', 'new', 'cod', 'Pastillas or local delicacies', NULL, 'available', '2026-05-20 14:39:10'),
(114, 30, 'Benguet Coffee Beans 2kg', 'Medium roast Arabica. Freshly roasted last week.', 'other', 'new', 'cod', 'Pastillas or local delicacies', NULL, 'available', '2026-05-20 14:39:10'),
(115, 31, 'Fishing Net 50m', 'Brand new. Nylon. 3 inch mesh. Good for fresh water.', 'other', 'new', 'pickup', 'Fishing rods or hooks', NULL, 'available', '2026-05-20 14:39:10'),
(116, 32, 'Fishing Net 50m', 'Brand new. Nylon. 3 inch mesh. Good for fresh water.', 'other', 'new', 'pickup', 'Fishing rods or hooks', NULL, 'available', '2026-05-20 14:39:10'),
(117, 33, 'Fishing Net 50m', 'Brand new. Nylon. 3 inch mesh. Good for fresh water.', 'other', 'new', 'pickup', 'Fishing rods or hooks', NULL, 'available', '2026-05-20 14:39:10'),
(118, 34, 'Sack of Sweet Potatoes 20kg', 'Fresh from farm. Organic. No pesticides.', 'other', 'new', 'pickup', 'Other root crops or vegetables', NULL, 'available', '2026-05-20 14:39:10'),
(119, 35, 'Sack of Sweet Potatoes 20kg', 'Fresh from farm. Organic. No pesticides.', 'other', 'new', 'pickup', 'Other root crops or vegetables', NULL, 'available', '2026-05-20 14:39:10'),
(120, 36, 'Sack of Sweet Potatoes 20kg', 'Fresh from farm. Organic. No pesticides.', 'other', 'new', 'pickup', 'Other root crops or vegetables', NULL, 'available', '2026-05-20 14:39:10'),
(121, 37, 'Antique Jar Collection 5pcs', 'Pre-colonial period. Authenticated. Collectors only.', 'other', 'good', 'pickup', 'Cash or equivalent artwork', NULL, 'available', '2026-05-20 14:39:10'),
(122, 38, 'Antique Jar Collection 5pcs', 'Pre-colonial period. Authenticated. Collectors only.', 'other', 'good', 'pickup', 'Cash or equivalent artwork', NULL, 'available', '2026-05-20 14:39:10'),
(123, 39, 'Antique Jar Collection 5pcs', 'Pre-colonial period. Authenticated. Collectors only.', 'other', 'good', 'pickup', 'Cash or equivalent artwork', NULL, 'available', '2026-05-20 14:39:10'),
(124, 40, 'Outboard Motor 6HP Parsun', 'Bago pa lang. Four-stroke. Dalawang beses lang nagamit.', 'other', 'like_new', 'pickup', 'Generator or water pump', NULL, 'available', '2026-05-20 14:39:10'),
(125, 41, 'Outboard Motor 6HP Parsun', 'Bago pa lang. Four-stroke. Dalawang beses lang nagamit.', 'other', 'like_new', 'pickup', 'Generator or water pump', NULL, 'available', '2026-05-20 14:39:10'),
(126, 43, 'Generator 2kW Honda', '1 year old. Good condition. Starts easily.', 'other', 'good', 'pickup', 'Water pump or tools', NULL, 'available', '2026-05-20 14:39:10'),
(127, 44, 'Generator 2kW Honda', '1 year old. Good condition. Starts easily.', 'other', 'good', 'pickup', 'Water pump or tools', NULL, 'available', '2026-05-20 14:39:10'),
(128, 45, 'Generator 2kW Honda', '1 year old. Good condition. Starts easily.', 'other', 'good', 'pickup', 'Water pump or tools', NULL, 'available', '2026-05-20 14:39:10'),
(129, 46, 'Water Pump Submersible', '6 months old. 1HP. Good for deep well.', 'other', 'like_new', 'pickup', 'Generator or irrigation tools', NULL, 'available', '2026-05-20 14:39:10'),
(130, 47, 'Water Pump Submersible', '6 months old. 1HP. Good for deep well.', 'other', 'like_new', 'pickup', 'Generator or irrigation tools', NULL, 'available', '2026-05-20 14:39:10'),
(131, 49, 'Sewing Machine Singer Electric', '2 years old. Good condition. Complete accessories.', 'other', 'good', 'cod', 'Washing machine or iron', NULL, 'available', '2026-05-20 14:39:10'),
(132, 50, 'Sewing Machine Singer Electric', '2 years old. Good condition. Complete accessories.', 'other', 'good', 'cod', 'Washing machine or iron', NULL, 'available', '2026-05-20 14:39:10'),
(133, 51, 'Sewing Machine Singer Electric', '2 years old. Good condition. Complete accessories.', 'other', 'good', 'cod', 'Washing machine or iron', NULL, 'available', '2026-05-20 14:39:10'),
(134, 52, 'Airfryer Philips 4L', '6 months old. Perfect condition. Complete accessories.', 'other', 'like_new', 'cod', 'Blender or rice cooker', NULL, 'available', '2026-05-20 14:39:10'),
(135, 53, 'Airfryer Philips 4L', '6 months old. Perfect condition. Complete accessories.', 'other', 'like_new', 'cod', 'Blender or rice cooker', NULL, 'available', '2026-05-20 14:39:10'),
(136, 54, 'Airfryer Philips 4L', '6 months old. Perfect condition. Complete accessories.', 'other', 'like_new', 'cod', 'Blender or rice cooker', NULL, 'available', '2026-05-20 14:39:10'),
(137, 55, 'Rice Cooker Cuckoo 10cup', '1 year old. Multi-function. Good condition.', 'other', 'good', 'cod', 'Airfryer or electric fan', NULL, 'available', '2026-05-20 14:39:10'),
(138, 56, 'Rice Cooker Cuckoo 10cup', '1 year old. Multi-function. Good condition.', 'other', 'good', 'cod', 'Airfryer or electric fan', NULL, 'available', '2026-05-20 14:39:10'),
(139, 57, 'Rice Cooker Cuckoo 10cup', '1 year old. Multi-function. Good condition.', 'other', 'good', 'cod', 'Airfryer or electric fan', NULL, 'available', '2026-05-20 14:39:10'),
(140, 58, 'Electric Fan Stand Hanabishi', 'Brand new. 16 inch. 5 speed settings.', 'other', 'new', 'cod', 'Other appliances', NULL, 'available', '2026-05-20 14:39:10'),
(141, 59, 'Electric Fan Stand Hanabishi', 'Brand new. 16 inch. 5 speed settings.', 'other', 'new', 'cod', 'Other appliances', NULL, 'available', '2026-05-20 14:39:10'),
(142, 61, 'Lawn Mower Gas Powered', '2 years old. Good condition. Self-propelled.', 'other', 'good', 'pickup', 'Garden tools or fertilizer', NULL, 'available', '2026-05-20 14:39:10'),
(143, 62, 'Lawn Mower Gas Powered', '2 years old. Good condition. Self-propelled.', 'other', 'good', 'pickup', 'Garden tools or fertilizer', NULL, 'available', '2026-05-20 14:39:10'),
(144, 63, 'Lawn Mower Gas Powered', '2 years old. Good condition. Self-propelled.', 'other', 'good', 'pickup', 'Garden tools or fertilizer', NULL, 'available', '2026-05-20 14:39:10'),
(145, 64, 'Chainsaw Stihl MS170', '1 year old. Good condition. Sharp chain.', 'other', 'good', 'pickup', 'Power tools or generator', NULL, 'available', '2026-05-20 14:39:10'),
(146, 65, 'Chainsaw Stihl MS170', '1 year old. Good condition. Sharp chain.', 'other', 'good', 'pickup', 'Power tools or generator', NULL, 'available', '2026-05-20 14:39:10'),
(147, 1, 'Nipa Hut Materials Bundle', 'Complete bundle: bamboo, nipa leaves, rattan. Fresh cut.', 'other', 'new', 'pickup', 'Construction materials or livestock', NULL, 'available', '2026-05-20 14:39:10'),
(148, 2, 'Organic Vegetables Weekly Box', 'Assorted veggies from our garden. Kamote, kangkong, ampalaya.', 'other', 'new', 'both', 'Other organic produce', NULL, 'available', '2026-05-20 14:39:10'),
(149, 3, 'Bangka Paddle Set 2pcs', 'Handmade locally. Good quality wood. Light and strong.', 'other', 'good', 'pickup', 'Fishing gear', NULL, 'available', '2026-05-20 14:39:10'),
(150, 4, 'Hammock Canvas Double', 'Brand new. Fits 2 persons. With mosquito net. Good for camping.', 'other', 'new', 'cod', 'Camping gear or tools', NULL, 'available', '2026-05-20 14:39:10'),
(151, 5, 'Fresh Coconut 50pcs', 'Buko or niyog. Fresh from our farm. Pick up only.', 'other', 'new', 'pickup', 'Tropical fruits or vegetables', NULL, 'available', '2026-05-20 14:39:10'),
(152, 1, 'Rattan Furniture Set', '3-piece sala set. Locally made. Good condition.', 'furniture', 'good', 'pickup', 'Wooden furniture or appliances', NULL, 'available', '2026-05-20 14:39:10'),
(153, 3, 'Motorcycle Sidecar Attachment', 'Custom made. Fits Honda XRM or XL. Good condition.', 'vehicles', 'good', 'pickup', 'Bicycle or tools', NULL, 'available', '2026-05-20 14:39:10'),
(154, 2, 'Duck Eggs Tray 30pcs', 'Fresh itlog ng pato. Organic. Perfect for salted egg.', 'other', 'new', 'pickup', 'Chicken eggs or other produce', NULL, 'available', '2026-05-20 14:39:10'),
(155, 4, 'Handwoven Blanket Mindoro', 'Traditional design. Handmade by local artisans.', 'other', 'good', 'cod', 'Other handicrafts', NULL, 'available', '2026-05-20 14:39:10'),
(156, 5, 'Fishing Rod Complete Set', 'Medium action. With reel, line, and tackle box.', 'other', 'good', 'pickup', 'Fishing net or bangka', NULL, 'available', '2026-05-20 14:39:10'),
(157, 106, 'Picture', 'PICTURE', 'other', 'good', 'both', 'PICTURE', '[\"http:\\/\\/localhost\\/barterbayan\\/api\\/uploads\\/bb_6a0d587e791931.78267774.png\"]', 'available', '2026-05-20 14:45:32'),
(158, 106, 'wall', 'PICTURE', 'other', 'good', 'pickup', 'PICTURE', '[\"http:\\/\\/localhost\\/barterbayan\\/api\\/uploads\\/bb_6a0d69ac38d943.80882895.png\"]', 'available', '2026-05-20 15:58:48'),
(159, 107, 'wallpaper', 'Picture', 'other', 'good', 'cod', 'Picture', '[\"http:\\/\\/localhost\\/barterbayan\\/api\\/uploads\\/bb_6a0db397448184.98885630.png\"]', 'available', '2026-05-20 21:14:20');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `offer_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `sent_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notif_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('trade_offer','offer_accepted','offer_declined','new_message') COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notif_id`, `user_id`, `type`, `reference_id`, `message`, `is_read`, `created_at`) VALUES
(1, 2, 'trade_offer', 4, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(2, 3, 'new_message', 6, 'You have a new message from a trader.', 0, '2026-05-20 14:39:45'),
(3, 4, 'trade_offer', 7, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(4, 5, 'trade_offer', 7, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(5, 6, 'offer_declined', 4, 'Your trade offer was declined.', 0, '2026-05-20 14:39:45'),
(6, 7, 'new_message', 2, 'You have a new message from a trader.', 0, '2026-05-20 14:39:45'),
(7, 8, 'offer_declined', 4, 'Your trade offer was declined.', 0, '2026-05-20 14:39:45'),
(8, 9, 'trade_offer', 6, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(9, 10, 'trade_offer', 6, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(10, 11, 'offer_accepted', 3, 'Your trade offer was accepted! Arrange the meetup or delivery.', 0, '2026-05-20 14:39:45'),
(11, 12, 'trade_offer', 5, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(12, 13, 'new_message', 3, 'You have a new message from a trader.', 0, '2026-05-20 14:39:45'),
(13, 14, 'new_message', 8, 'You have a new message from a trader.', 0, '2026-05-20 14:39:45'),
(14, 15, 'trade_offer', 2, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(15, 16, 'trade_offer', 5, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(16, 17, 'offer_accepted', 3, 'Your trade offer was accepted! Arrange the meetup or delivery.', 0, '2026-05-20 14:39:45'),
(17, 18, 'new_message', 2, 'You have a new message from a trader.', 0, '2026-05-20 14:39:45'),
(18, 19, 'offer_declined', 4, 'Your trade offer was declined.', 0, '2026-05-20 14:39:45'),
(19, 20, 'offer_declined', 2, 'Your trade offer was declined.', 0, '2026-05-20 14:39:45'),
(20, 1, 'trade_offer', 4, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(21, 2, 'new_message', 10, 'You have a new message from a trader.', 0, '2026-05-20 14:39:45'),
(22, 3, 'new_message', 2, 'You have a new message from a trader.', 0, '2026-05-20 14:39:45'),
(23, 4, 'trade_offer', 8, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(24, 5, 'trade_offer', 9, 'You received a new trade offer!', 0, '2026-05-20 14:39:45'),
(25, 6, 'offer_accepted', 3, 'Your trade offer was accepted! Arrange the meetup or delivery.', 0, '2026-05-20 14:39:45'),
(26, 1, 'trade_offer', 31, 'You received a new trade offer!', 0, '2026-05-20 14:46:02'),
(27, 1, 'trade_offer', 32, 'You received a new trade offer!', 0, '2026-05-20 15:59:04'),
(28, 106, 'trade_offer', 33, 'You received a new trade offer!', 0, '2026-05-20 21:16:36');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `reviewer_id` int(11) NOT NULL,
  `reviewee_id` int(11) NOT NULL,
  `offer_id` int(11) DEFAULT NULL,
  `rating` tinyint(4) NOT NULL CHECK (`rating` between 1 and 5),
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`review_id`, `reviewer_id`, `reviewee_id`, `offer_id`, `rating`, `comment`, `created_at`) VALUES
(1, 15, 29, NULL, 5, 'Fast response. Friendly and professional. 5 stars!', '2026-05-20 14:39:24'),
(2, 4, 44, NULL, 4, 'Fast response. Friendly and professional. 5 stars!', '2026-05-20 14:39:24'),
(3, 2, 26, NULL, 4, 'Item as described. Will trade again!', '2026-05-20 14:39:24'),
(4, 28, 30, NULL, 3, 'Very slow to respond. Had to follow up many times.', '2026-05-20 14:39:24'),
(5, 21, 41, NULL, 5, 'Smooth transaction! Fast replies. Legit seller!', '2026-05-20 14:39:24'),
(6, 2, 22, NULL, 4, 'Very honest and accommodating. Highly recommend!', '2026-05-20 14:39:24'),
(7, 26, 37, NULL, 4, 'Good communication throughout. Smooth pickup. Thanks!', '2026-05-20 14:39:24'),
(8, 7, 38, NULL, 4, 'Great experience. No issues at all. Salamat!', '2026-05-20 14:39:24'),
(9, 11, 50, NULL, 3, 'Could communicate better. Item was okay though.', '2026-05-20 14:39:24'),
(10, 1, 18, NULL, 5, 'Very honest and accommodating. Highly recommend!', '2026-05-20 14:39:24'),
(11, 5, 35, NULL, 4, 'Very honest and accommodating. Highly recommend!', '2026-05-20 14:39:24'),
(12, 4, 43, NULL, 5, 'Very honest and accommodating. Highly recommend!', '2026-05-20 14:39:24'),
(13, 1, 23, NULL, 5, 'Great experience. No issues at all. Salamat!', '2026-05-20 14:39:24'),
(14, 19, 21, NULL, 1, 'Item condition was different from description.', '2026-05-20 14:39:24'),
(15, 2, 9, NULL, 5, 'Good communication throughout. Smooth pickup. Thanks!', '2026-05-20 14:39:24'),
(16, 4, 48, NULL, 2, 'Medyo matagal bago sumagot. Pero natuloy naman.', '2026-05-20 14:39:24'),
(17, 25, 24, NULL, 5, 'Item as described. Will trade again!', '2026-05-20 14:39:24'),
(18, 15, 33, NULL, 4, 'Certified legit trader! Will do business again.', '2026-05-20 14:39:24'),
(19, 2, 47, NULL, 5, 'Good communication throughout. Smooth pickup. Thanks!', '2026-05-20 14:39:24'),
(20, 10, 30, NULL, 5, 'Smooth transaction! Fast replies. Legit seller!', '2026-05-20 14:39:24'),
(21, 2, 31, NULL, 5, 'Legit talaga! Super satisfied with the trade.', '2026-05-20 14:39:24'),
(22, 22, 7, NULL, 5, 'Item was exactly as posted. No hidden defects. Great!', '2026-05-20 14:39:24'),
(23, 3, 6, NULL, 4, 'Very honest and accommodating. Highly recommend!', '2026-05-20 14:39:24'),
(24, 3, 9, NULL, 4, 'Certified legit trader! Will do business again.', '2026-05-20 14:39:24'),
(25, 18, 46, NULL, 4, 'Certified legit trader! Will do business again.', '2026-05-20 14:39:24'),
(26, 17, 19, NULL, 4, 'Certified legit trader! Will do business again.', '2026-05-20 14:39:24'),
(27, 14, 7, NULL, 5, 'Item as described. Will trade again!', '2026-05-20 14:39:24'),
(28, 28, 42, NULL, 5, 'Good communication throughout. Smooth pickup. Thanks!', '2026-05-20 14:39:24'),
(29, 24, 14, NULL, 4, 'Great experience. No issues at all. Salamat!', '2026-05-20 14:39:24'),
(30, 14, 22, NULL, 5, 'Legit talaga! Super satisfied with the trade.', '2026-05-20 14:39:24'),
(31, 14, 47, NULL, 3, 'Medyo matagal bago sumagot. Pero natuloy naman.', '2026-05-20 14:39:24'),
(32, 11, 43, NULL, 4, 'Very honest and accommodating. Highly recommend!', '2026-05-20 14:39:24'),
(33, 22, 31, NULL, 2, 'Item had hidden damage not mentioned in the post.', '2026-05-20 14:39:24'),
(34, 3, 28, NULL, 3, 'Item condition was different from description.', '2026-05-20 14:39:24'),
(35, 26, 9, NULL, 5, 'Certified legit trader! Will do business again.', '2026-05-20 14:39:24'),
(36, 18, 36, NULL, 4, 'Item as described. Will trade again!', '2026-05-20 14:39:24'),
(37, 14, 23, NULL, 5, 'Legit talaga! Super satisfied with the trade.', '2026-05-20 14:39:24'),
(38, 28, 47, NULL, 2, 'Item condition was different from description.', '2026-05-20 14:39:24'),
(39, 12, 7, NULL, 5, 'Great experience. No issues at all. Salamat!', '2026-05-20 14:39:24'),
(40, 5, 43, NULL, 5, 'Item as described. Will trade again!', '2026-05-20 14:39:24'),
(41, 12, 36, NULL, 4, 'Trustworthy trader. Item in perfect condition.', '2026-05-20 14:39:24'),
(42, 19, 15, NULL, 5, 'Good communication throughout. Smooth pickup. Thanks!', '2026-05-20 14:39:24'),
(43, 25, 40, NULL, 5, 'Good communication throughout. Smooth pickup. Thanks!', '2026-05-20 14:39:24'),
(44, 1, 39, NULL, 5, 'Trustworthy trader. Item in perfect condition.', '2026-05-20 14:39:24'),
(45, 1, 12, NULL, 4, 'Trustworthy trader. Item in perfect condition.', '2026-05-20 14:39:24'),
(46, 30, 22, NULL, 4, 'Very honest and accommodating. Highly recommend!', '2026-05-20 14:39:24'),
(47, 28, 10, NULL, 5, 'Legit talaga! Super satisfied with the trade.', '2026-05-20 14:39:24'),
(48, 3, 10, NULL, 5, 'Smooth transaction! Fast replies. Legit seller!', '2026-05-20 14:39:24'),
(49, 3, 48, NULL, 5, 'Legit talaga! Super satisfied with the trade.', '2026-05-20 14:39:24'),
(50, 14, 30, NULL, 4, 'Fast response. Friendly and professional. 5 stars!', '2026-05-20 14:39:24'),
(51, 10, 47, NULL, 4, 'Certified legit trader! Will do business again.', '2026-05-20 14:39:24'),
(52, 20, 6, NULL, 5, 'Very honest and accommodating. Highly recommend!', '2026-05-20 14:39:24'),
(53, 6, 49, NULL, 5, 'Item as described. Will trade again!', '2026-05-20 14:39:24'),
(54, 9, 29, NULL, 5, 'Item was exactly as posted. No hidden defects. Great!', '2026-05-20 14:39:24'),
(55, 20, 29, NULL, 4, 'Great experience. No issues at all. Salamat!', '2026-05-20 14:39:24'),
(56, 25, 33, NULL, 3, 'Medyo matagal bago sumagot. Pero natuloy naman.', '2026-05-20 14:39:24'),
(57, 4, 19, NULL, 5, 'Certified legit trader! Will do business again.', '2026-05-20 14:39:24'),
(58, 16, 34, NULL, 5, 'Smooth transaction! Fast replies. Legit seller!', '2026-05-20 14:39:24'),
(59, 8, 26, NULL, 5, 'Smooth transaction! Fast replies. Legit seller!', '2026-05-20 14:39:24'),
(60, 1, 14, NULL, 4, 'Great experience. No issues at all. Salamat!', '2026-05-20 14:39:24'),
(61, 25, 9, NULL, 5, 'Trustworthy trader. Item in perfect condition.', '2026-05-20 14:39:24'),
(62, 11, 8, NULL, 1, 'Medyo matagal bago sumagot. Pero natuloy naman.', '2026-05-20 14:39:24'),
(63, 6, 9, NULL, 4, 'Great experience. No issues at all. Salamat!', '2026-05-20 14:39:24'),
(64, 17, 36, NULL, 5, 'Fast response. Friendly and professional. 5 stars!', '2026-05-20 14:39:24'),
(65, 3, 26, NULL, 5, 'Smooth transaction! Fast replies. Legit seller!', '2026-05-20 14:39:24'),
(66, 14, 2, NULL, 4, 'Item as described. Will trade again!', '2026-05-20 14:39:24'),
(67, 28, 21, NULL, 5, 'Certified legit trader! Will do business again.', '2026-05-20 14:39:24'),
(68, 13, 46, NULL, 5, 'Trustworthy trader. Item in perfect condition.', '2026-05-20 14:39:24'),
(69, 4, 26, NULL, 1, 'Item condition was different from description.', '2026-05-20 14:39:24'),
(70, 6, 40, NULL, 4, 'Fast response. Friendly and professional. 5 stars!', '2026-05-20 14:39:24'),
(71, 28, 7, NULL, 4, 'Certified legit trader! Will do business again.', '2026-05-20 14:39:24'),
(72, 13, 34, NULL, 2, 'Item condition was different from description.', '2026-05-20 14:39:24'),
(73, 24, 22, NULL, 4, 'Very honest and accommodating. Highly recommend!', '2026-05-20 14:39:24'),
(74, 3, 33, NULL, 5, 'Good communication throughout. Smooth pickup. Thanks!', '2026-05-20 14:39:24'),
(75, 17, 13, NULL, 5, 'Fast response. Friendly and professional. 5 stars!', '2026-05-20 14:39:24'),
(76, 12, 47, NULL, 5, 'Very honest and accommodating. Highly recommend!', '2026-05-20 14:39:24'),
(77, 8, 7, NULL, 3, 'Very slow to respond. Had to follow up many times.', '2026-05-20 14:39:24'),
(78, 6, 39, NULL, 3, 'Item had hidden damage not mentioned in the post.', '2026-05-20 14:39:24'),
(79, 6, 50, NULL, 5, 'Item was exactly as posted. No hidden defects. Great!', '2026-05-20 14:39:24'),
(80, 25, 37, NULL, 5, 'Item was exactly as posted. No hidden defects. Great!', '2026-05-20 14:39:24');

-- --------------------------------------------------------

--
-- Table structure for table `trade_comments`
--

CREATE TABLE `trade_comments` (
  `comment_id` int(11) NOT NULL,
  `offer_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `trade_offers`
--

CREATE TABLE `trade_offers` (
  `offer_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `offered_item_id` int(11) NOT NULL,
  `requested_item_id` int(11) NOT NULL,
  `cash_topup` decimal(10,2) DEFAULT 0.00,
  `status` enum('pending','accepted','declined','cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trade_offers`
--

INSERT INTO `trade_offers` (`offer_id`, `sender_id`, `receiver_id`, `offered_item_id`, `requested_item_id`, `cash_topup`, `status`, `created_at`) VALUES
(1, 19, 20, 21, 41, '200.00', 'pending', '2026-05-20 14:39:34'),
(2, 15, 3, 31, 29, '100.00', 'pending', '2026-05-20 14:39:34'),
(3, 19, 2, 23, 33, '0.00', 'pending', '2026-05-20 14:39:34'),
(4, 15, 16, 3, 4, '200.00', 'pending', '2026-05-20 14:39:34'),
(5, 3, 4, 40, 39, '500.00', 'accepted', '2026-05-20 14:39:34'),
(6, 19, 18, 48, 3, '1000.00', 'declined', '2026-05-20 14:39:34'),
(7, 7, 11, 39, 31, '0.00', 'pending', '2026-05-20 14:39:34'),
(8, 15, 4, 22, 46, '0.00', 'declined', '2026-05-20 14:39:34'),
(9, 6, 2, 16, 46, '1000.00', 'accepted', '2026-05-20 14:39:34'),
(10, 17, 18, 40, 11, '200.00', 'pending', '2026-05-20 14:39:34'),
(11, 10, 13, 27, 50, '200.00', 'declined', '2026-05-20 14:39:34'),
(12, 2, 11, 5, 22, '0.00', 'declined', '2026-05-20 14:39:34'),
(13, 13, 10, 17, 47, '0.00', 'pending', '2026-05-20 14:39:34'),
(14, 3, 19, 43, 10, '200.00', 'pending', '2026-05-20 14:39:34'),
(15, 13, 5, 39, 46, '0.00', 'pending', '2026-05-20 14:39:34'),
(16, 18, 13, 42, 22, '0.00', 'declined', '2026-05-20 14:39:34'),
(17, 3, 14, 33, 24, '0.00', 'pending', '2026-05-20 14:39:34'),
(18, 10, 6, 14, 22, '1000.00', 'pending', '2026-05-20 14:39:34'),
(19, 8, 5, 10, 5, '100.00', 'pending', '2026-05-20 14:39:34'),
(20, 17, 18, 48, 34, '0.00', 'pending', '2026-05-20 14:39:34'),
(21, 20, 5, 39, 25, '0.00', 'pending', '2026-05-20 14:39:34'),
(22, 6, 20, 11, 47, '1000.00', 'pending', '2026-05-20 14:39:34'),
(23, 14, 12, 44, 47, '50.00', 'accepted', '2026-05-20 14:39:34'),
(24, 20, 10, 49, 48, '1000.00', 'pending', '2026-05-20 14:39:34'),
(25, 18, 8, 20, 31, '50.00', 'pending', '2026-05-20 14:39:34'),
(26, 19, 15, 30, 50, '100.00', 'accepted', '2026-05-20 14:39:34'),
(27, 17, 18, 27, 11, '50.00', 'declined', '2026-05-20 14:39:34'),
(28, 5, 9, 4, 42, '1000.00', 'pending', '2026-05-20 14:39:34'),
(29, 18, 4, 46, 34, '0.00', 'pending', '2026-05-20 14:39:34'),
(30, 3, 6, 18, 29, '0.00', 'accepted', '2026-05-20 14:39:34'),
(31, 106, 1, 157, 1, '1.00', 'pending', '2026-05-20 14:46:02'),
(32, 106, 1, 158, 1, '4.00', 'pending', '2026-05-20 15:59:04'),
(33, 107, 106, 159, 157, '5.00', 'pending', '2026-05-20 21:16:36');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `barangay` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `profile_pic` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `neg_review_count` int(11) DEFAULT 0,
  `is_warned` tinyint(1) DEFAULT 0,
  `is_banned` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `phone`, `password_hash`, `location`, `city`, `barangay`, `latitude`, `longitude`, `profile_pic`, `is_verified`, `neg_review_count`, `is_warned`, `is_banned`, `created_at`) VALUES
(1, 'JohnMarkN', 'johnmark@gmail.com', '09351907843', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mamburao, Occidental Mindoro', 'Mamburao', 'Poblacion', '13.22510396', '120.60797103', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(2, 'GeradM', 'gerad@gmail.com', '09496628573', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mamburao, Occidental Mindoro', 'Mamburao', 'Caguray', '13.21208045', '120.60371865', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(3, 'KimC', 'kimpo@gmail.com', '09326915725', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mamburao, Occidental Mindoro', 'Mamburao', 'Talabaan', '13.23744034', '120.61013914', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(4, 'AchillesB', 'achilles@gmail.com', '09489011595', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mamburao, Occidental Mindoro', 'Mamburao', 'Fatima', '13.22291443', '120.59555779', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(5, 'AngeloJamesC', 'angelo@gmail.com', '09567689618', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mamburao, Occidental Mindoro', 'Mamburao', 'Rizal', '13.21809648', '120.60137135', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(6, 'JoseSab32', 'josesabado@gmail.com', '09353341057', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Paranaque, Metro Manila', 'Paranaque', 'Mines View', '14.49855342', '121.02342932', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(7, 'JoseRam28', 'joseramos@gmail.com', '09359478454', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Paluan, Occidental Mindoro', 'Paluan', 'Molo', '13.39260701', '120.47869076', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(8, 'VictorinoDri36', 'victorinodrilon@gmail.com', '09173678638', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Angeles, Pampanga', 'Angeles', 'Lahug', '15.12722971', '120.56592510', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(9, 'RobertoDia13', 'robertodiaz@gmail.com', '09516770619', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Dipolog, Zamboanga del Norte', 'Dipolog', 'Caguray', '8.55567604', '123.33845399', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(10, 'ConsueloCay38', 'consuelocayetano@gmail.com', '09564226067', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Pasig, Metro Manila', 'Pasig', 'San Antonio', '14.58930107', '121.10694547', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(11, 'EduardoDia36', 'eduardodiaz@gmail.com', '09777120868', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Talisay, Cebu', 'Talisay', 'Banilad', '10.23312166', '123.86181401', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(12, 'JohnAqu22', 'johnaquino@gmail.com', '09955107245', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Talisay, Cebu', 'Talisay', 'Talomo', '10.23505644', '123.88736187', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(13, 'JeromeMan99', 'jeromemanalo@gmail.com', '09204842788', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Abra de Ilog, Occidental Mindoro', 'Abra de Ilog', 'Caguray', '13.41853624', '120.69811927', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(14, 'MaritesHil64', 'mariteshilbay@gmail.com', '09638698256', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mandaue, Cebu', 'Mandaue', 'Bagumbayan', '10.32147043', '123.95179912', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(15, 'KatrinaLun47', 'katrinaluna@gmail.com', '09353320821', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Cotabato City, Maguindanao', 'Cotabato City', 'Calinan', '7.19087275', '124.20986931', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(16, 'EmilioPer55', 'emilioperalta@gmail.com', '09992065818', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tuguegarao, Cagayan', 'Tuguegarao', 'Talamban', '17.62087107', '121.72444399', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(17, 'JeromeMor88', 'jeromemorales@gmail.com', '09955476583', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lipa, Batangas', 'Lipa', 'Aguinaldo', '13.92458001', '121.13575262', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(18, 'KarenLim65', 'karenlim@gmail.com', '09236007072', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Coron, Palawan', 'Coron', 'Lapuz', '11.97421289', '120.19461311', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(19, 'JohnMan63', 'johnmanalo@gmail.com', '09182876828', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tayabas, Quezon', 'Tayabas', 'Ligang', '14.05014198', '121.57305618', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(20, 'RobertoBue9', 'robertobuenaventura@gmail.com', '09953109911', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Muntinlupa, Metro Manila', 'Muntinlupa', 'Pacdal', '14.40612259', '121.04548429', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(21, 'MaritesArr97', 'maritesarroyo@gmail.com', '09326229731', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Vigan, Ilocos Sur', 'Vigan', 'Pacdal', '17.58669024', '120.38194801', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(22, 'LeonardoChu9', 'leonardochua@gmail.com', '09491352896', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'La Trinidad, Benguet', 'La Trinidad', 'Arevalo', '16.43491739', '120.55347945', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(23, 'AntonioOca43', 'antonioocampo@gmail.com', '09219626108', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Cagayan de Oro, Misamis Oriental', 'Cagayan de Oro', 'Batasan Hills', '8.49571822', '124.62433894', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(24, 'JenniferVic53', 'jennifervictorino@gmail.com', '09322582524', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Las Pinas, Metro Manila', 'Las Pinas', 'Pacdal', '14.44448409', '120.97718629', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(25, 'JeromeHil83', 'jeromehilbay@gmail.com', '09232016911', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Vigan, Ilocos Sur', 'Vigan', 'Consolacion', '17.56184421', '120.41583380', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(26, 'MarkTol18', 'marktolentino@gmail.com', '09674078418', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Koronadal, South Cotabato', 'Koronadal', 'Talomo', '6.48278452', '124.88056125', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(27, 'CarlosHil70', 'carloshilbay@gmail.com', '09172564689', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Cagayan de Oro, Misamis Oriental', 'Cagayan de Oro', 'Del Pilar', '8.47471312', '124.64570867', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(28, 'RicardoDia1', 'ricardodiaz@gmail.com', '09615449368', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Cainta, Rizal', 'Cainta', 'Commonwealth', '14.56994060', '121.15938541', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(29, 'EsperanzaCo38', 'esperanzaco@gmail.com', '09331981186', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Makati, Metro Manila', 'Makati', 'Indahag', '14.53978838', '120.98841139', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(30, 'CarlosIlu11', 'carlosilustre@gmail.com', '09302149597', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Pasig, Metro Manila', 'Pasig', 'Mines View', '14.60534554', '121.07740204', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(31, 'BryanPim6', 'bryanpimentel@gmail.com', '09228033426', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Marawi, Lanao del Sur', 'Marawi', 'Matandang Balara', '8.03477650', '124.25964074', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(32, 'ErnestoPad17', 'ernestopadilla@gmail.com', '09478670955', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'San Jose, Nueva Ecija', 'San Jose', 'Barangay 1', '15.82905874', '121.06854524', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(33, 'AntonioEst28', 'antonioestrada@gmail.com', '09895449324', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Muntinlupa, Metro Manila', 'Muntinlupa', 'Apas', '14.43856913', '121.07184162', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(34, 'VictorinoArr91', 'victorinoarroyo@gmail.com', '09479874152', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'San Jose, Occidental Mindoro', 'San Jose', 'Pacdal', '12.37536833', '121.05065030', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(35, 'ErnestoMor14', 'ernestomorales@gmail.com', '09963607983', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'General Santos, South Cotabato', 'General Santos', 'Commonwealth', '6.12478639', '125.18900897', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(36, 'KarenBue33', 'karenbuenaventura@gmail.com', '09202548511', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Angeles, Pampanga', 'Angeles', 'Ligang', '15.12713442', '120.54898366', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(37, 'NatividadSic71', 'natividadsicat@gmail.com', '09671162230', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mandaluyong, Metro Manila', 'Mandaluyong', 'Magsaysay', '14.61500408', '121.05118157', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(38, 'ArnelSot71', 'arnelsotto@gmail.com', '09288210624', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Muntinlupa, Metro Manila', 'Muntinlupa', 'San Antonio', '14.39276067', '121.07341852', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(39, 'RonaldoGo88', 'ronaldogo@gmail.com', '09362724590', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lucena, Quezon', 'Lucena', 'Fatima', '13.93669068', '121.64727702', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(40, 'LeonardoNav23', 'leonardonavarro@gmail.com', '09661415846', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Davao City, Davao del Sur', 'Davao City', 'Indahag', '7.09835898', '125.63049092', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(41, 'AlfredoNav90', 'alfredonavarro@gmail.com', '09237417985', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Abra de Ilog, Occidental Mindoro', 'Abra de Ilog', 'Danlog', '13.43095520', '120.69266583', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(42, 'FlorenciaTiu29', 'florenciatiu@gmail.com', '09184240180', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Vigan, Ilocos Sur', 'Vigan', 'Lahug', '17.55698824', '120.35245366', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(43, 'VanessaIlu52', 'vanessailustre@gmail.com', '09956555772', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Paluan, Occidental Mindoro', 'Paluan', 'Aguinaldo', '13.44686307', '120.44759722', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(44, 'RosaCas77', 'rosacastillo@gmail.com', '09676799667', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'San Jose, Nueva Ecija', 'San Jose', 'Agdao', '15.80269671', '121.10871384', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(45, 'ErnestoGar91', 'ernestogarcia@gmail.com', '09671028374', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Marawi, Lanao del Sur', 'Marawi', 'Caguray', '8.00307616', '124.30085440', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(46, 'ArnelBat9', 'arnelbatungbakal@gmail.com', '09496266630', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Marikina, Metro Manila', 'Marikina', 'Consolacion', '14.68270375', '121.10346980', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(47, 'RowenaSal71', 'rowenasalazar@gmail.com', '09274218542', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'San Fernando, Pampanga', 'San Fernando', 'Pacdal', '15.06382909', '120.70408544', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(48, 'RowenaCay1', 'rowenacayetano@gmail.com', '09475813613', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Iloilo City, Iloilo', 'Iloilo City', 'Agdao', '10.74306071', '122.57063293', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(49, 'JasmineLeo28', 'jasmineleonardo@gmail.com', '09898938746', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Consolacion, Cebu', 'Consolacion', 'Pacdal', '10.34148364', '123.96263616', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(50, 'ConsueloYap87', 'consueloyap@gmail.com', '09474768844', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Panabo, Davao del Norte', 'Panabo', 'Mabini', '7.27055403', '125.66318740', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(51, 'NoelIgn81', 'noelignacio@gmail.com', '09974262081', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tuguegarao, Cagayan', 'Tuguegarao', 'Calinan', '17.60517223', '121.69880571', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(52, 'FelicianoEnr29', 'felicianoenriquez@gmail.com', '09309689889', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Binan, Laguna', 'Binan', 'Santo Nino', '14.34629246', '121.11589760', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(53, 'HernanCon86', 'hernanconcepcion@gmail.com', '09946323376', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Meycauayan, Bulacan', 'Meycauayan', 'Burnham', '14.75850052', '120.98136162', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(54, 'NatividadVic58', 'natividadvictorino@gmail.com', '09395147994', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Koronadal, South Cotabato', 'Koronadal', 'Fatima', '6.52501399', '124.84546776', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(55, 'LuzDom31', 'luzdomingo@gmail.com', '09426634586', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'San Jose, Nueva Ecija', 'San Jose', 'Mandurriao', '15.76064621', '121.07986645', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(56, 'AlvinSy9', 'alvinsy@gmail.com', '09667838382', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Iba, Zambales', 'Iba', 'Mandurriao', '15.32697394', '119.94388126', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(57, 'KatrinaCru98', 'katrinacruz@gmail.com', '09977381734', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tacloban, Leyte', 'Tacloban', 'Poblacion', '11.27961933', '124.98828901', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(58, 'LovelyArr78', 'lovelyarroyo@gmail.com', '09359191131', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Baguio, Benguet', 'Baguio', 'Batasan Hills', '16.39716688', '120.55832199', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(59, 'NatividadCon17', 'natividadconcepcion@gmail.com', '09951452421', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Ilagan, Isabela', 'Ilagan', 'Arevalo', '17.15375136', '121.85186816', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(60, 'NoelTan7', 'noeltan@gmail.com', '09397360307', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Olongapo, Zambales', 'Olongapo', 'Santa Cruz', '14.82557595', '120.26980004', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(61, 'MelanieAng11', 'melanieang@gmail.com', '09781325197', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Manila, Metro Manila', 'Manila', 'Apas', '14.57743777', '120.94968947', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(62, 'NestorBau32', 'nestorbautista@gmail.com', '09321341919', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lapu-Lapu, Cebu', 'Lapu-Lapu', 'San Isidro', '10.28039768', '123.96295671', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(63, 'NoelAng99', 'noelang@gmail.com', '09563815034', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mandaluyong, Metro Manila', 'Mandaluyong', 'Fatima', '14.60494409', '121.07307766', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(64, 'RenatoTri87', 'renatotrillanes@gmail.com', '09617654757', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Panabo, Davao del Norte', 'Panabo', 'Magsaysay', '7.31596783', '125.71004573', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(65, 'TrishaPim16', 'trishapimentel@gmail.com', '09971689025', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Batangas City, Batangas', 'Batangas City', 'Mandurriao', '13.75077024', '121.04794567', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(66, 'MariaIgn63', 'mariaignacio@gmail.com', '09238273315', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tayabas, Quezon', 'Tayabas', 'Session Road Area', '14.05692600', '121.59067915', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(67, 'DanteRec84', 'danterecto@gmail.com', '09429111742', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Binan, Laguna', 'Binan', 'Agdao', '14.36775877', '121.08989797', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(68, 'RobertoSab58', 'robertosabado@gmail.com', '09368796514', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Naga, Camarines Sur', 'Naga', 'Lahug', '13.58409600', '123.22287623', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(69, 'RonaldoMag44', 'ronaldomagpayo@gmail.com', '09425635017', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'San Jose, Occidental Mindoro', 'San Jose', 'Jaro', '12.38584501', '121.03354904', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(70, 'PrincessYap89', 'princessyap@gmail.com', '09789234615', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Antipolo, Rizal', 'Antipolo', 'Talabaan', '14.54777946', '121.15953885', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(71, 'RenatoCar75', 'renatocarpio@gmail.com', '09568939993', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Iligan, Lanao del Norte', 'Iligan', 'Apas', '8.22204031', '124.26487483', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(72, 'LourdesCor33', 'lourdescorpuz@gmail.com', '09353024269', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tagum, Davao del Norte', 'Tagum', 'Matandang Balara', '7.41736438', '125.81056912', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(73, 'RodrigoSy95', 'rodrigosy@gmail.com', '09785638893', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Iligan, Lanao del Norte', 'Iligan', 'Lapuz', '8.21063990', '124.21324209', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(74, 'ArnelLim39', 'arnellim@gmail.com', '09179961299', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Muntinlupa, Metro Manila', 'Muntinlupa', 'Batasan Hills', '14.37174126', '121.00586208', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(75, 'JasonBue14', 'jasonbuenaventura@gmail.com', '09175770422', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Santa Rosa, Laguna', 'Santa Rosa', 'Toril', '14.30743750', '121.08614909', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(76, 'CristinaFlo52', 'cristinaflores@gmail.com', '09792242892', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Manila, Metro Manila', 'Manila', 'Mabini', '14.57143581', '120.98922717', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(77, 'FernandoVil98', 'fernandovillar@gmail.com', '09664786401', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Marawi, Lanao del Sur', 'Marawi', 'Talamban', '7.99604116', '124.27871768', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(78, 'FlorenciaLac80', 'florencialacson@gmail.com', '09202664863', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Iloilo City, Iloilo', 'Iloilo City', 'Session Road Area', '10.69708202', '122.57493425', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(79, 'RyanAqu21', 'ryanaquino@gmail.com', '09177853787', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Antipolo, Rizal', 'Antipolo', 'Macasandig', '14.59390490', '121.15930074', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(80, 'RosarioAqu88', 'rosarioaquino@gmail.com', '09355438490', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Panabo, Davao del Norte', 'Panabo', 'Agdao', '7.27778210', '125.66158476', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(81, 'EsperanzaAqu8', 'esperanzaaquino@gmail.com', '09296160869', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Bacolod, Negros Occidental', 'Bacolod', 'Buhangin', '10.64124829', '122.96619424', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(82, 'KarenArr64', 'karenarroyo@gmail.com', '09732349590', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Quezon City, Metro Manila', 'Quezon City', 'Agdao', '14.69476271', '121.05199709', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(83, 'JeromeTri76', 'jerometrillanes@gmail.com', '09185521644', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Quezon City, Metro Manila', 'Quezon City', 'Barangay 1', '14.69650151', '121.04134007', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(84, 'FeSot56', 'fesotto@gmail.com', '09792530793', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Santa Rosa, Laguna', 'Santa Rosa', 'Apas', '14.30486785', '121.09708466', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(85, 'DaniloSan89', 'danilosantiago@gmail.com', '09795835492', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Vigan, Ilocos Sur', 'Vigan', 'Bataan', '17.59553998', '120.34983577', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(86, 'CeciliaMor99', 'ceciliamorales@gmail.com', '09639633492', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Mamburao, Occidental Mindoro', 'Mamburao', 'Pacdal', '13.25444940', '120.59575811', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(87, 'NicolePan81', 'nicolepanganiban@gmail.com', '09731865901', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Iloilo City, Iloilo', 'Iloilo City', 'Batasan Hills', '10.72413757', '122.59631382', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(88, 'CristinaBau81', 'cristinabautista@gmail.com', '09995014745', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Talisay, Cebu', 'Talisay', 'Holy Spirit', '10.24876712', '123.85238011', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(89, 'NoelGon83', 'noelgonzales@gmail.com', '09289361353', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Silay, Negros Occidental', 'Silay', 'Mintal', '10.81613293', '122.96713923', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(90, 'JenniferGue71', 'jenniferguevarra@gmail.com', '09287435505', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Tagum, Davao del Norte', 'Tagum', 'Lapuz', '7.44845927', '125.83804610', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(91, 'MelanieEsg65', 'melanieesguerra@gmail.com', '09421043037', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Bacolod, Negros Occidental', 'Bacolod', 'Consolacion', '10.65518447', '122.95805502', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(92, 'EsperanzaTol69', 'esperanzatolentino@gmail.com', '09786790218', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Iba, Zambales', 'Iba', 'Molo', '15.35072981', '119.96907680', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(93, 'GilbertYap74', 'gilbertyap@gmail.com', '09614918527', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Laoag, Ilocos Norte', 'Laoag', 'San Antonio', '18.18315411', '120.59143810', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(94, 'VivianCar84', 'viviancarpio@gmail.com', '09289310235', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Abra de Ilog, Occidental Mindoro', 'Abra de Ilog', 'Quezon', '13.43348329', '120.72391443', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(95, 'RemediosMac59', 'remediosmacapagal@gmail.com', '09173418526', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Laoag, Ilocos Norte', 'Laoag', 'Camp 7', '18.23529654', '120.55958626', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(96, 'NormaAba89', 'normaabad@gmail.com', '09632347467', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Iba, Zambales', 'Iba', 'Danlog', '15.34364860', '119.98158978', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(97, 'LovelyOca80', 'lovelyocampo@gmail.com', '09214938791', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Bacolod, Negros Occidental', 'Bacolod', 'San Miguel', '10.69104131', '122.94581772', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(98, 'VictorinoAgu89', 'victorinoaguilar@gmail.com', '09471485654', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Quezon City, Metro Manila', 'Quezon City', 'Matandang Balara', '14.69969148', '121.02716942', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(99, 'LeonardoMac53', 'leonardomacapagal@gmail.com', '09974020853', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Consolacion, Cebu', 'Consolacion', 'San Jose', '10.34101747', '123.99106717', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(100, 'RommelSot19', 'rommelsotto@gmail.com', '09358736811', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Zamboanga City, Zamboanga del Sur', 'Zamboanga City', 'Talomo', '6.90182614', '122.03975179', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(101, 'TrishaArr21', 'trishaarroyo@gmail.com', '09218410995', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Batangas City, Batangas', 'Batangas City', 'Arevalo', '13.74043234', '121.09526233', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(102, 'FlorenciaUy50', 'florenciauy@gmail.com', '09782789344', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Cagayan de Oro, Misamis Oriental', 'Cagayan de Oro', 'Talamban', '8.48795382', '124.65318495', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(103, 'AnaCar51', 'anacarpio@gmail.com', '09421135861', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Manila, Metro Manila', 'Manila', 'Lapuz', '14.61911377', '121.01082711', NULL, 1, 0, 0, 0, '2026-05-20 14:38:56'),
(104, 'JohnVer29', 'johnverzosa@gmail.com', '09325204819', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Cebu City, Cebu', 'Cebu City', 'Session Road Area', '10.28347311', '123.89559665', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(105, 'RosaSot47', 'rosasotto@gmail.com', '09272512187', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Silay, Negros Occidental', 'Silay', 'Matandang Balara', '10.81949847', '122.94795121', NULL, 0, 0, 0, 0, '2026-05-20 14:38:56'),
(106, 'Loaf', 'angeloconcepcionmarc@gmail.com', '0955925900', '$2y$10$/Saza1TXKGHSsQXRS6yI1O2EjLML6nXBfI/Bt27ZU4Hms/uGlDHY6', 'Bakery', 'Las Pinas', 'My house', NULL, NULL, 'http://localhost/barterbayan/api/uploads/bb_6a0d58e2917fe3.29318267.png', 0, 0, 0, 0, '2026-05-20 14:41:50'),
(107, 'Manuel', 'manual@gmail.com', '0989898965', '$2y$10$AS4iITXi66N5kRtDnNvKGu51vx2F2ZMzWRwMG0zfmdCe6tvIE0h6C', NULL, 'Taguig', 'House', NULL, NULL, NULL, 0, 0, 0, 0, '2026-05-20 21:11:07');

-- --------------------------------------------------------

--
-- Stand-in structure for view `user_ratings`
-- (See below for the actual view)
--
CREATE TABLE `user_ratings` (
`user_id` int(11)
,`avg_rating` decimal(5,1)
,`total_reviews` bigint(21)
);

-- --------------------------------------------------------

--
-- Structure for view `user_ratings`
--
DROP TABLE IF EXISTS `user_ratings`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `user_ratings`  AS SELECT `reviews`.`reviewee_id` AS `user_id`, round(avg(`reviews`.`rating`),1) AS `avg_rating`, count(0) AS `total_reviews` FROM `reviews` GROUP BY `reviews`.`reviewee_id``reviewee_id`  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`convo_id`),
  ADD UNIQUE KEY `unique_pair` (`user_a`,`user_b`),
  ADD KEY `user_b` (`user_b`);

--
-- Indexes for table `direct_messages`
--
ALTER TABLE `direct_messages`
  ADD PRIMARY KEY (`dm_id`),
  ADD KEY `convo_id` (`convo_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`fav_id`),
  ADD UNIQUE KEY `unique_fav` (`user_id`,`item_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `offer_id` (`offer_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notif_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `reviewer_id` (`reviewer_id`),
  ADD KEY `reviewee_id` (`reviewee_id`),
  ADD KEY `offer_id` (`offer_id`);

--
-- Indexes for table `trade_comments`
--
ALTER TABLE `trade_comments`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `offer_id` (`offer_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `trade_offers`
--
ALTER TABLE `trade_offers`
  ADD PRIMARY KEY (`offer_id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`),
  ADD KEY `offered_item_id` (`offered_item_id`),
  ADD KEY `requested_item_id` (`requested_item_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `conversations`
--
ALTER TABLE `conversations`
  MODIFY `convo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `direct_messages`
--
ALTER TABLE `direct_messages`
  MODIFY `dm_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `fav_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=160;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notif_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `trade_comments`
--
ALTER TABLE `trade_comments`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trade_offers`
--
ALTER TABLE `trade_offers`
  MODIFY `offer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `conversations_ibfk_1` FOREIGN KEY (`user_a`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `conversations_ibfk_2` FOREIGN KEY (`user_b`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `direct_messages`
--
ALTER TABLE `direct_messages`
  ADD CONSTRAINT `direct_messages_ibfk_1` FOREIGN KEY (`convo_id`) REFERENCES `conversations` (`convo_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `direct_messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favorites_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE;

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`offer_id`) REFERENCES `trade_offers` (`offer_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`reviewee_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`offer_id`) REFERENCES `trade_offers` (`offer_id`) ON DELETE SET NULL;

--
-- Constraints for table `trade_comments`
--
ALTER TABLE `trade_comments`
  ADD CONSTRAINT `trade_comments_ibfk_1` FOREIGN KEY (`offer_id`) REFERENCES `trade_offers` (`offer_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `trade_comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `trade_offers`
--
ALTER TABLE `trade_offers`
  ADD CONSTRAINT `trade_offers_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `trade_offers_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `trade_offers_ibfk_3` FOREIGN KEY (`offered_item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `trade_offers_ibfk_4` FOREIGN KEY (`requested_item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
