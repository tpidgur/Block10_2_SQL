-- phpMyAdmin SQL Dump
-- version 3.5.2.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 03, 2012 at 01:13 PM
-- Server version: 5.5.27
-- PHP Version: 5.4.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `task_site`
--

-- --------------------------------------------------------

--
-- Table structure for table `banners`
--

CREATE TABLE IF NOT EXISTS `banners` (
  `b_id` int(11) NOT NULL AUTO_INCREMENT,
  `b_url` varchar(255) NOT NULL,
  `b_show` int(11) NOT NULL DEFAULT '0',
  `b_click` int(11) NOT NULL DEFAULT '0',
  `b_text` varchar(255) DEFAULT NULL,
  `b_pic` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`b_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `m2m_banners_pages`
--

CREATE TABLE IF NOT EXISTS `m2m_banners_pages` (
  `b_id` int(11) NOT NULL,
  `p_id` int(11) NOT NULL,
  PRIMARY KEY (`b_id`,`p_id`),
  KEY `p_id` (`p_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `news`
--

CREATE TABLE IF NOT EXISTS `news` (
  `n_id` int(11) NOT NULL AUTO_INCREMENT,
  `n_category` int(11) NOT NULL,
  `n_header` varchar(255) NOT NULL,
  `n_text` text NOT NULL,
  `n_dt` datetime NOT NULL,
  PRIMARY KEY (`n_id`),
  KEY `n_category` (`n_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `news_categories`
--

CREATE TABLE IF NOT EXISTS `news_categories` (
  `nc_id` int(11) NOT NULL AUTO_INCREMENT,
  `nc_name` varchar(255) NOT NULL,
  PRIMARY KEY (`nc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE IF NOT EXISTS `pages` (
  `p_id` int(11) NOT NULL AUTO_INCREMENT,
  `p_parent` int(11) DEFAULT NULL,
  `p_name` varchar(255) NOT NULL,
  PRIMARY KEY (`p_id`),
  KEY `p_parent` (`p_parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE IF NOT EXISTS `reviews` (
  `r_id` int(11) NOT NULL AUTO_INCREMENT,
  `r_category` int(11) NOT NULL,
  `r_header` varchar(255) NOT NULL,
  `r_text` text NOT NULL,
  `r_dt` datetime NOT NULL,
  PRIMARY KEY (`r_id`),
  KEY `r_category` (`r_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `reviews_categories`
--

CREATE TABLE IF NOT EXISTS `reviews_categories` (
  `rc_id` int(11) NOT NULL AUTO_INCREMENT,
  `rc_name` varchar(255) NOT NULL,
  PRIMARY KEY (`rc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `m2m_banners_pages`
--
ALTER TABLE `m2m_banners_pages`
  ADD CONSTRAINT `m2m_banners_pages_ibfk_2` FOREIGN KEY (`p_id`) REFERENCES `pages` (`p_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `m2m_banners_pages_ibfk_1` FOREIGN KEY (`b_id`) REFERENCES `banners` (`b_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `news`
--
ALTER TABLE `news`
  ADD CONSTRAINT `news_ibfk_1` FOREIGN KEY (`n_category`) REFERENCES `news_categories` (`nc_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pages`
--
ALTER TABLE `pages`
  ADD CONSTRAINT `pages_ibfk_1` FOREIGN KEY (`p_parent`) REFERENCES `pages` (`p_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`r_category`) REFERENCES `reviews_categories` (`rc_id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

insert into pages (p_id, p_parent, p_name)
values
(1, NULL, 'Юридическим лицам'),
(2, NULL, 'Физическим лицам'),
(3, 1, 'Образцы договоров'),
(4, 1, 'Банковские реквизиты'),
(5, 2, 'Схема проезда к офису'),
(6, 2, 'Почта и телефон'),
(7, 3, 'Договоры оптовых закупок');

insert into news_categories (nc_id, nc_name)
values
(1, 'Финансы'),
(2, 'Законодательство'),
(3, 'Логистика'),
(4, 'Строительство');

insert into reviews_categories (rc_id, rc_name)
values
(1, 'Технологии'),
(2, 'Товары и услуги');

insert into news (n_id, n_category, n_header, n_text, n_dt)
values
(1, 1, 'Состояние валютного рынка', '<to be added>', '2012-12-03 04:15:27'),
(2, 3, 'Контрабанда железобетонных плит', '<to be added>', '2011-09-14 06:19:08'),
(3, 3, 'Почта России: вчера, сегодня и снова вчера', '', '2011-08-17 09:06:30'),
(4, 3, 'Самолётом или поездом?', '<to be added>', '2012-12-20 06:11:42'),
(5, 3, 'Куда всё катится?', '<to be added>', '2012-12-11 04:36:17');

insert into reviews (r_id, r_category, r_header, r_text, r_dt)
values
(1, 1, 'Роботы на страже строек', '<empty>', '2011-10-03 05:17:37'),
(2, 1, 'Когда всё это кончится?!', 'Никогда!', '2012-12-12 06:31:13');

insert into banners (b_id, b_url, b_show, b_click, b_text, b_pic)
values
(1, 'http://tut.by', 200, 20, 'TUT.BY', NULL),
(2, 'http://tut.by', 200, 300, NULL, 'tutby.png'),
(3, 'http://onliner.by', 50, 45, 'ONLINER.BY', NULL),
(4, 'http://onliner.by', 50, 1, NULL, 'onlinerby.jpg'),
(5, 'http://google.by', 10, 10, 'GOOGLE.BY', 'googleby.png'),
(6, 'http://google.com', 1, 1, NULL, 'googlecom.png'),
(7, 'http://habrahabr.ru', 999, 997, NULL, 'habrahabrru.png'),
(8, 'http://habrahabr.ru', 50, 49, 'HABRAHABR.RU', NULL),
(9, 'http://gismeteo.by', 0, 0, 'Погода', NULL),
(10, 'http://gismeteo.ru', 0, 0, 'Погода', NULL);

insert into m2m_banners_pages (b_id, p_id)
values
(1, 1),
(2, 1),
(7, 1),
(1, 2),
(4, 3),
(1, 4),
(2, 4),
(1, 5),
(2, 5),
(3, 5);