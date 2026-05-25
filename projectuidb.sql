-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 25, 2026 at 08:42 PM
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
-- Database: `projectuidb`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllUserScanHistory` ()   BEGIN
    SELECT 
        user_id,
        disease_type,
        created_at,
        confidence,
        prediction_data,
        recommendations
    FROM scan_histories
    ORDER BY created_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserSessions` ()   BEGIN
    SELECT 
        u.id,
        u.last_name,
        u.first_name,
        u.last_activity,
        s.id AS session_id,
        s.last_activity AS session_last_activity,
        FROM_UNIXTIME(s.last_activity) AS session_last_activity_datetime
    FROM users u
    LEFT JOIN sessions s ON u.id = s.user_id
    ORDER BY u.id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) UNSIGNED NOT NULL,
  `table_name` varchar(100) NOT NULL,
  `action` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `record_id` int(20) NOT NULL,
  `user_id` int(20) UNSIGNED DEFAULT NULL,
  `old_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `new_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `daily_scan_trends`
-- (See below for the actual view)
--
CREATE TABLE `daily_scan_trends` (
`scan_date` date
,`total_scans` bigint(21)
,`unique_users` bigint(21)
,`unique_diseases` bigint(21)
,`avg_confidence` decimal(6,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `disease_summary`
-- (See below for the actual view)
--
CREATE TABLE `disease_summary` (
`disease_type` varchar(255)
,`detection_count` bigint(21)
,`avg_confidence` decimal(6,2)
,`min_confidence` decimal(5,2)
,`max_confidence` decimal(5,2)
,`unique_users_affected` bigint(21)
,`detection_date` date
);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_12_10_162215_add_profile_fields_to_users_table', 1),
(5, '2025_12_12_004537_create_scan_histories_table', 1),
(6, '2025_12_12_004626_add_is_admin_to_users_table', 1),
(7, '2025_12_12_123548_add_prediction_data_to_scan_histories_table', 1),
(8, '2026_05_25_174848_add_database_optimizations', 2),
(9, '2026_05_25_224958_split_name_into_first_and_last_name', 3);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `scan_histories`
--

CREATE TABLE `scan_histories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `disease_type` varchar(255) NOT NULL,
  `confidence` decimal(5,2) NOT NULL,
  `prediction_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`prediction_data`)),
  `recommendations` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `scan_histories`
--

INSERT INTO `scan_histories` (`id`, `user_id`, `image_path`, `disease_type`, `confidence`, `prediction_data`, `recommendations`, `created_at`, `updated_at`) VALUES
(1, 1, '6a145a7868267_1.jpg', 'Panama', 81.89, '\"{\\\"summary\\\":{\\\"top_prediction\\\":{\\\"class\\\":\\\"Panama\\\",\\\"confidence\\\":81.89},\\\"all_predictions\\\":[{\\\"class\\\":\\\"Panama\\\",\\\"confidence\\\":81.89},{\\\"class\\\":\\\"Healthy\\\",\\\"confidence\\\":68.78},{\\\"class\\\":\\\"Panama\\\",\\\"confidence\\\":63.37}],\\\"total_predictions\\\":3,\\\"timestamp\\\":\\\"2026-05-25 22:19:36\\\"},\\\"disease_type\\\":\\\"Panama\\\",\\\"confidence\\\":81.89,\\\"full_prediction_stored\\\":false}\"', 'Consult with a local agricultural expert for proper treatment recommendations.', '2026-05-25 14:19:36', '2026-05-25 14:19:36');

--
-- Triggers `scan_histories`
--
DELIMITER $$
CREATE TRIGGER `before_scan_insert` BEFORE INSERT ON `scan_histories` FOR EACH ROW BEGIN
                IF NEW.recommendations IS NULL THEN
                    SET NEW.recommendations = CASE NEW.disease_type
                        WHEN 'Healthy' THEN 'Your plant appears healthy. Continue regular care and monitoring.'
                        WHEN 'Early Blight' THEN 'Remove affected leaves, apply fungicide, and ensure proper air circulation.'
                        WHEN 'Late Blight' THEN 'Immediately remove infected plants, avoid overhead watering, apply copper-based fungicide.'
                        WHEN 'Leaf Curl' THEN 'Control whitefly population, remove infected leaves, apply neem oil.'
                        WHEN 'Powdery Mildew' THEN 'Increase air circulation, apply sulfur-based fungicide, avoid nitrogen-rich fertilizers.'
                        WHEN 'Rust' THEN 'Remove infected leaves, apply fungicide, ensure good air circulation.'
                        WHEN 'Septoria Leaf Spot' THEN 'Remove infected leaves, avoid overhead watering, apply fungicide.'
                        ELSE 'Consult with a local agricultural expert for proper treatment recommendations.'
                    END;
                END IF;
            END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prevent_duplicate_scan` BEFORE INSERT ON `scan_histories` FOR EACH ROW BEGIN
    DECLARE duplicate_count INT;
    
    SELECT COUNT(*) INTO duplicate_count
    FROM scan_histories
    WHERE user_id = NEW.user_id 
        AND disease_type = NEW.disease_type
        AND created_at > DATE_SUB(NOW(), INTERVAL 5 MINUTE);
    
    IF duplicate_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Duplicate scan detected within 5 minutes';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_scan_histories_timestamp` BEFORE UPDATE ON `scan_histories` FOR EACH ROW BEGIN
                SET NEW.updated_at = CURRENT_TIMESTAMP;
            END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_user_last_activity` AFTER INSERT ON `scan_histories` FOR EACH ROW BEGIN
                UPDATE users 
                SET last_activity = CURRENT_TIMESTAMP
                WHERE id = NEW.user_id;
            END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('ZNnMIcEwflXYi172z391ryBArQH0Pa1KFh3PRVnB', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiM2xvZUQ4ME9MSkNaaEdZSmFIRTJyWE1QOG1uWGc4c2g0ZDVaaFBzZyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJuZXciO2E6MDp7fXM6Mzoib2xkIjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjY6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9ob21lIjtzOjU6InJvdXRlIjtzOjQ6ImhvbWUiO31zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aToxO30=', 1779730884);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `is_admin` int(1) NOT NULL DEFAULT 0,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `last_activity` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `profile_picture`, `phone`, `location`, `bio`, `is_admin`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `last_activity`) VALUES
(1, 'Adrian', 'Plaza', 'plazaadrianp@gmail.com', NULL, NULL, NULL, NULL, 1, '2026-05-25 14:17:52', '$2y$12$.PzV6s2dIogYl0rokcJgOOQTLXbVeoHopiQMqgimYhXaxAeHLe6mK', 'QtLRDQIXLtqx04ltTshtDcBbTQCyMJl8DbHimiyMh0P5QD76PPddfUnLyFs9', '2026-05-25 09:08:16', '2026-05-25 09:08:16', '2026-05-25 14:19:36'),
(2, 'John Dane', 'Galvez', 'daboy123@gmail.com', NULL, NULL, NULL, NULL, 0, '2026-05-25 12:28:57', '$2y$12$MODIBS3rQx1P3R2mLElca.5M.MyI9Dx8AuswFSf9rFKWPyUG8XHMS', NULL, '2026-05-25 12:26:53', '2026-05-25 12:28:57', NULL),
(3, 'Elljay', 'Ballo', 'ejballo@gmail.com', NULL, NULL, NULL, NULL, 0, '2026-05-25 13:06:12', '$2y$12$6xFzCZGktyVTJnOWUwoMouSGWugtar8Pt01dLPZK/rj0m9xRZKd7S', NULL, '2026-05-25 13:04:19', '2026-05-25 13:06:12', NULL),
(4, 'Axcel', 'Tabada', 'axcel@gmail.com', NULL, NULL, NULL, NULL, 0, '2026-05-25 14:04:44', '$2y$12$DkNlA82HHhbo93DUNBWut.rKbt2KZwIXqa8qQiZm4cm20tMJzq4Eu', NULL, '2026-05-25 14:03:47', '2026-05-25 14:04:44', NULL),
(6, 'Andre', 'Plaza', 'andreplaza4@gmail.com', NULL, NULL, NULL, NULL, 0, NULL, '$2y$12$vqdfA0p5meOYuWT1SxTmUuHOxWj1ZHauZreGnToD7BBma1F205/AG', NULL, '2026-05-25 17:17:55', '2026-05-25 17:17:55', NULL);

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `audit_users_delete` BEFORE DELETE ON `users` FOR EACH ROW BEGIN
    INSERT INTO audit_logs (
        table_name,
        action,
        record_id,
        user_id,
        old_data,
        new_data,
        created_at
    )
    VALUES (
        'users',
        'DELETE',
        OLD.id,
        NULL,  -- User might be deleted, so set to NULL
        JSON_OBJECT(
            'id', OLD.id,
            'first_name', OLD.first_name,
            'last_name', OLD.last_name,
            'email', OLD.email,
            'profile_picture', OLD.profile_picture,
            'phone', OLD.phone,
            'location', OLD.location,
            'bio', OLD.bio,
            'is_admin', OLD.is_admin,
            'email_verified_at', OLD.email_verified_at,
            'created_at', OLD.created_at,
            'updated_at', OLD.updated_at,
            'last_activity', OLD.last_activity
        ),
        NULL,  -- No new data for delete
        CURRENT_TIMESTAMP
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_users_insert` AFTER INSERT ON `users` FOR EACH ROW BEGIN
    INSERT INTO audit_logs (
        table_name,
        action,
        record_id,
        user_id,
        old_data,
        new_data,
        created_at
    )
    VALUES (
        'users',
        'INSERT',
        NEW.id,
        NEW.id,  -- Assuming the user performing the action is the one being created
        NULL,    -- No old data for insert
        JSON_OBJECT(
            'id', NEW.id,
            'first_name', NEW.first_name,
            'last_name', NEW.last_name,
            'email', NEW.email,
            'profile_picture', NEW.profile_picture,
            'phone', NEW.phone,
            'location', NEW.location,
            'bio', NEW.bio,
            'is_admin', NEW.is_admin,
            'email_verified_at', NEW.email_verified_at,
            'created_at', NEW.created_at,
            'updated_at', NEW.updated_at,
            'last_activity', NEW.last_activity
        ),
        CURRENT_TIMESTAMP
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audit_users_update` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
    INSERT INTO audit_logs (
        table_name,
        action,
        record_id,
        user_id,
        old_data,
        new_data,
        created_at
    )
    VALUES (
        'users',
        'UPDATE',
        NEW.id,
        NEW.id,  -- The user making the change
        JSON_OBJECT(
            'id', OLD.id,
            'first_name', OLD.first_name,
            'last_name', OLD.last_name,
            'email', OLD.email,
            'profile_picture', OLD.profile_picture,
            'phone', OLD.phone,
            'location', OLD.location,
            'bio', OLD.bio,
            'is_admin', OLD.is_admin,
            'email_verified_at', OLD.email_verified_at,
            'created_at', OLD.created_at,
            'updated_at', OLD.updated_at,
            'last_activity', OLD.last_activity
        ),
        JSON_OBJECT(
            'id', NEW.id,
            'first_name', NEW.first_name,
            'last_name', NEW.last_name,
            'email', NEW.email,
            'profile_picture', NEW.profile_picture,
            'phone', NEW.phone,
            'location', NEW.location,
            'bio', NEW.bio,
            'is_admin', NEW.is_admin,
            'email_verified_at', NEW.email_verified_at,
            'created_at', NEW.created_at,
            'updated_at', NEW.updated_at,
            'last_activity', NEW.last_activity
        ),
        CURRENT_TIMESTAMP
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `auto_verify_admin_email` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    IF NEW.is_admin = 1 THEN
        SET NEW.email_verified_at = CURRENT_TIMESTAMP;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `auto_verify_admin_email_on_update` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN
    IF NEW.is_admin = 1 AND OLD.is_admin = 0 THEN
        SET NEW.email_verified_at = CURRENT_TIMESTAMP;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `user_session_view`
-- (See below for the actual view)
--
CREATE TABLE `user_session_view` (
`user_id` bigint(20) unsigned
,`last_name` varchar(255)
,`first_name` varchar(255)
,`session_id` varchar(255)
,`session_last_activity` int(11)
,`user_created_at` timestamp
,`user_last_activity` timestamp
);

-- --------------------------------------------------------

--
-- Structure for view `daily_scan_trends`
--
DROP TABLE IF EXISTS `daily_scan_trends`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `daily_scan_trends`  AS SELECT cast(`scan_histories`.`created_at` as date) AS `scan_date`, count(0) AS `total_scans`, count(distinct `scan_histories`.`user_id`) AS `unique_users`, count(distinct `scan_histories`.`disease_type`) AS `unique_diseases`, round(avg(`scan_histories`.`confidence`),2) AS `avg_confidence` FROM `scan_histories` WHERE `scan_histories`.`created_at` >= current_timestamp() - interval 30 day GROUP BY cast(`scan_histories`.`created_at` as date) ORDER BY cast(`scan_histories`.`created_at` as date) DESC ;

-- --------------------------------------------------------

--
-- Structure for view `disease_summary`
--
DROP TABLE IF EXISTS `disease_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `disease_summary`  AS SELECT `scan_histories`.`disease_type` AS `disease_type`, count(0) AS `detection_count`, round(avg(`scan_histories`.`confidence`),2) AS `avg_confidence`, round(min(`scan_histories`.`confidence`),2) AS `min_confidence`, round(max(`scan_histories`.`confidence`),2) AS `max_confidence`, count(distinct `scan_histories`.`user_id`) AS `unique_users_affected`, cast(`scan_histories`.`created_at` as date) AS `detection_date` FROM `scan_histories` GROUP BY `scan_histories`.`disease_type`, cast(`scan_histories`.`created_at` as date) ORDER BY cast(`scan_histories`.`created_at` as date) DESC, count(0) DESC ;

-- --------------------------------------------------------

--
-- Structure for view `user_session_view`
--
DROP TABLE IF EXISTS `user_session_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `user_session_view`  AS SELECT `u`.`id` AS `user_id`, `u`.`last_name` AS `last_name`, `u`.`first_name` AS `first_name`, `s`.`id` AS `session_id`, `s`.`last_activity` AS `session_last_activity`, `u`.`created_at` AS `user_created_at`, `u`.`last_activity` AS `user_last_activity` FROM (`users` `u` left join `sessions` `s` on(`u`.`id` = `s`.`user_id`)) ORDER BY `u`.`id` ASC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`),
  ADD KEY `idx_jobs_reserved_available` (`reserved_at`,`available_at`),
  ADD KEY `idx_jobs_queue_attempts` (`queue`,`attempts`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `scan_histories`
--
ALTER TABLE `scan_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_scan_histories_user_created` (`user_id`,`created_at`),
  ADD KEY `idx_scan_histories_disease_confidence` (`disease_type`,`confidence`),
  ADD KEY `idx_scan_user_created` (`user_id`,`created_at`),
  ADD KEY `idx_scan_disease_confidence` (`disease_type`,`confidence`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`),
  ADD KEY `idx_sessions_last_activity` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_unique_email` (`email`),
  ADD KEY `idx_users_names` (`last_name`,`first_name`) USING BTREE;

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `scan_histories`
--
ALTER TABLE `scan_histories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `scan_histories`
--
ALTER TABLE `scan_histories`
  ADD CONSTRAINT `scan_histories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sessions`
--
ALTER TABLE `sessions`
  ADD CONSTRAINT `sessions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
