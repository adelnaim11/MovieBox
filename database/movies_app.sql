-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 04, 2026 at 02:48 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `movies_app`
--

-- --------------------------------------------------------

--
-- Table structure for table `movies`
--

CREATE TABLE `movies` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `rating` decimal(3,1) NOT NULL,
  `category` varchar(50) NOT NULL,
  `cover` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `movies`
--

INSERT INTO `movies` (`id`, `title`, `description`, `rating`, `category`, `cover`) VALUES
(1, 'John Wick', 'An ex-hitman seeks vengeance.', 8.7, 'Action', 'https://picsum.photos/300/450?1'),
(2, 'Mad Max: Fury Road', 'Post-apocalyptic chaos on wheels.', 8.5, 'Action', 'https://picsum.photos/300/450?2'),
(3, 'The Dark Knight', 'Batman faces the Joker.', 9.0, 'Action', 'https://picsum.photos/300/450?3'),
(4, 'Avengers: Endgame', 'Heroes unite for the final battle.', 8.4, 'Action', 'https://picsum.photos/300/450?4'),
(5, 'Gladiator', 'A Roman general seeks revenge.', 8.5, 'Action', 'https://picsum.photos/300/450?5'),
(6, 'The Hangover', 'A wild bachelor party gone wrong.', 7.7, 'Comedy', 'https://picsum.photos/300/450?6'),
(7, 'Superbad', 'Teens chase one legendary night.', 7.6, 'Comedy', 'https://picsum.photos/300/450?7'),
(8, 'Step Brothers', 'Two grown men act like kids.', 6.9, 'Comedy', 'https://picsum.photos/300/450?8'),
(9, 'Dumb and Dumber', 'Two idiots on a road trip.', 7.3, 'Comedy', 'https://picsum.photos/300/450?9'),
(10, 'Deadpool', 'A mercenary with a dark sense of humor.', 8.0, 'Comedy', 'https://picsum.photos/300/450?10'),
(11, 'Inception', 'Dreams within dreams.', 8.8, 'Top', 'https://picsum.photos/300/450?11'),
(12, 'Interstellar', 'A journey beyond space and time.', 8.6, 'Top', 'https://picsum.photos/300/450?12'),
(13, 'Fight Club', 'An underground fight movement.', 8.8, 'Top', 'https://picsum.photos/300/450?13'),
(14, 'The Matrix', 'Reality is a lie.', 8.7, 'Top', 'https://picsum.photos/300/450?14'),
(15, 'Forrest Gump', 'Life is like a box of chocolates.', 8.8, 'Top', 'https://picsum.photos/300/450?15'),
(16, 'Joker', 'The rise of Gotham’s villain.', 8.4, 'Drama', 'https://picsum.photos/300/450?16'),
(17, 'The Godfather', 'A mafia family legacy.', 9.2, 'Drama', 'https://picsum.photos/300/450?17'),
(18, 'Scarface', 'The rise and fall of a drug lord.', 8.3, 'Drama', 'https://picsum.photos/300/450?18'),
(19, 'Titanic', 'A tragic love story.', 7.9, 'Drama', 'https://picsum.photos/300/450?19'),
(20, 'Whiplash', 'The cost of greatness.', 8.5, 'Drama', 'https://picsum.photos/300/450?20'),
(21, 'Parasite', 'Class warfare turns deadly.', 8.6, 'Drama', 'https://picsum.photos/300/450?21');

-- --------------------------------------------------------

--
-- Table structure for table `movie_images`
--

CREATE TABLE `movie_images` (
  `id` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `image_url` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `movie_images`
--

INSERT INTO `movie_images` (`id`, `movie_id`, `image_url`) VALUES
(1, 1, 'https://picsum.photos/800/450?101'),
(2, 1, 'https://picsum.photos/800/450?102'),
(3, 2, 'https://picsum.photos/800/450?103'),
(4, 2, 'https://picsum.photos/800/450?104'),
(5, 3, 'https://picsum.photos/800/450?105'),
(6, 3, 'https://picsum.photos/800/450?106'),
(7, 4, 'https://picsum.photos/800/450?107'),
(8, 5, 'https://picsum.photos/800/450?108'),
(9, 6, 'https://picsum.photos/800/450?109'),
(10, 7, 'https://picsum.photos/800/450?110'),
(11, 8, 'https://picsum.photos/800/450?111'),
(12, 9, 'https://picsum.photos/800/450?112'),
(13, 10, 'https://picsum.photos/800/450?113'),
(14, 11, 'https://picsum.photos/800/450?114'),
(15, 11, 'https://picsum.photos/800/450?115'),
(16, 12, 'https://picsum.photos/800/450?116'),
(17, 13, 'https://picsum.photos/800/450?117'),
(18, 14, 'https://picsum.photos/800/450?118'),
(19, 15, 'https://picsum.photos/800/450?119'),
(20, 16, 'https://picsum.photos/800/450?120'),
(21, 17, 'https://picsum.photos/800/450?121'),
(22, 18, 'https://picsum.photos/800/450?122'),
(23, 19, 'https://picsum.photos/800/450?123'),
(24, 20, 'https://picsum.photos/800/450?124'),
(25, 21, 'https://picsum.photos/800/450?125');

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `rating` decimal(2,1) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ratings`
--

INSERT INTO `ratings` (`id`, `user_id`, `movie_id`, `rating`, `created_at`) VALUES
(1, 2, 12, 5.0, '2026-01-04 13:06:24');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, 'testmiloud', '$2y$10$vka8R3J8nGAcSx3Az9/EAOMhaNigWDo/nMmyqQsQKKd/7pptUR5T2', 'admin'),
(2, 'testmiloud2', '$2y$10$8iUzBWAabhM1Es40mZZV5.CboYWtIJY5aOBN3xCr1iNCkq.B/3Zn2', 'user');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `movie_images`
--
ALTER TABLE `movie_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `movie_id` (`movie_id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_movie` (`user_id`,`movie_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `movie_id` (`movie_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `movies`
--
ALTER TABLE `movies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `movie_images`
--
ALTER TABLE `movie_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `movie_images`
--
ALTER TABLE `movie_images`
  ADD CONSTRAINT `movie_images_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `ratings_ibfk_2` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
