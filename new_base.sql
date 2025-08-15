-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Авг 15 2025 г., 19:47
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `freelance`
--

-- --------------------------------------------------------

--
-- Структура таблицы `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `chats`
--

CREATE TABLE `chats` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `category` enum('active','archive','support') NOT NULL DEFAULT 'active',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `chats`
--

INSERT INTO `chats` (`id`, `order_id`, `title`, `category`, `is_active`, `created_at`, `updated_at`) VALUES
(74, 178, 'Заказ #178', 'archive', 1, '2025-08-14 03:22:36', '2025-08-14 03:47:51'),
(77, 180, 'Заказ #180', 'active', 1, '2025-08-14 04:21:35', '2025-08-14 04:21:35'),
(78, 181, 'Заказ #181', 'archive', 1, '2025-08-14 04:25:00', '2025-08-14 04:25:39'),
(80, 183, 'Заказ #183', 'archive', 1, '2025-08-14 05:23:40', '2025-08-14 05:24:50'),
(81, 188, 'Заказ #188', 'active', 1, '2025-08-14 21:16:54', '2025-08-14 21:16:54'),
(82, 189, 'Заказ #189', 'active', 1, '2025-08-14 21:21:15', '2025-08-14 21:21:15'),
(83, 184, 'Заказ #184', 'active', 1, '2025-08-14 21:34:15', '2025-08-14 21:47:24'),
(84, 185, 'Заказ #185', 'active', 1, '2025-08-15 02:07:27', '2025-08-15 02:09:17'),
(85, 186, 'Заказ #186', 'active', 1, '2025-08-15 05:11:35', '2025-08-15 05:17:40');

-- --------------------------------------------------------

--
-- Структура таблицы `chat_participants`
--

CREATE TABLE `chat_participants` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `chat_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `role` enum('customer','executor') NOT NULL,
  `last_read_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `chat_participants`
--

INSERT INTO `chat_participants` (`id`, `chat_id`, `user_id`, `role`, `last_read_at`, `is_active`, `created_at`, `updated_at`) VALUES
(141, 74, 1, 'customer', NULL, 1, '2025-08-14 03:22:36', '2025-08-14 03:22:36'),
(142, 74, 2, 'executor', NULL, 1, '2025-08-14 03:22:36', '2025-08-14 03:22:36'),
(147, 77, 1, 'customer', NULL, 1, '2025-08-14 04:21:35', '2025-08-14 04:21:35'),
(148, 77, 2, 'executor', NULL, 1, '2025-08-14 04:21:35', '2025-08-14 04:21:35'),
(149, 78, 1, 'customer', NULL, 1, '2025-08-14 04:25:00', '2025-08-14 04:25:00'),
(150, 78, 2, 'executor', NULL, 1, '2025-08-14 04:25:00', '2025-08-14 04:25:00'),
(153, 80, 1, 'customer', NULL, 1, '2025-08-14 05:23:40', '2025-08-14 05:23:40'),
(154, 80, 2, 'executor', '2025-08-14 05:24:43', 1, '2025-08-14 05:23:40', '2025-08-14 05:24:43'),
(155, 81, 1, 'customer', NULL, 1, '2025-08-14 21:16:54', '2025-08-14 21:16:54'),
(156, 81, 2, 'executor', NULL, 1, '2025-08-14 21:16:54', '2025-08-14 21:16:54'),
(157, 82, 2, 'customer', NULL, 1, '2025-08-14 21:21:15', '2025-08-14 21:21:15'),
(158, 82, 1, 'executor', NULL, 1, '2025-08-14 21:21:15', '2025-08-14 21:21:15'),
(159, 83, 1, 'customer', '2025-08-14 21:49:06', 1, '2025-08-14 21:34:15', '2025-08-14 21:49:06'),
(160, 83, 6, 'executor', '2025-08-14 21:37:18', 1, '2025-08-14 21:34:15', '2025-08-14 21:37:18'),
(161, 84, 2, 'customer', NULL, 1, '2025-08-15 02:07:27', '2025-08-15 02:07:27'),
(162, 84, 12, 'executor', '2025-08-15 02:09:17', 1, '2025-08-15 02:07:27', '2025-08-15 02:09:17'),
(163, 85, 1, 'customer', NULL, 1, '2025-08-15 05:11:35', '2025-08-15 05:11:35'),
(164, 85, 13, 'executor', '2025-08-15 05:17:48', 1, '2025-08-15 05:11:35', '2025-08-15 05:17:48');

-- --------------------------------------------------------

--
-- Структура таблицы `failed_jobs`
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
-- Структура таблицы `jobs`
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
-- Структура таблицы `job_batches`
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
-- Структура таблицы `messages`
--

CREATE TABLE `messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `chat_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `content` text NOT NULL,
  `type` enum('text','system') NOT NULL DEFAULT 'text',
  `status` enum('sent','delivered','read') NOT NULL DEFAULT 'sent',
  `read_at` timestamp NULL DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `messages`
--

INSERT INTO `messages` (`id`, `chat_id`, `user_id`, `content`, `type`, `status`, `read_at`, `is_deleted`, `created_at`, `updated_at`) VALUES
(252, 74, NULL, 'Создан новый заказ \"Дизайн визитки\" для исполнителя тестовый тест. Заказ находится на согласовании.', 'system', 'sent', NULL, 0, '2025-08-14 03:22:36', '2025-08-14 03:22:36'),
(253, 74, NULL, 'Заказ взят в работу. Статус заказа: В работе', 'system', 'sent', NULL, 0, '2025-08-14 03:36:04', '2025-08-14 03:36:04'),
(254, 74, NULL, 'Заказ взят в работу. Статус заказа: В работе', 'system', 'sent', NULL, 0, '2025-08-14 03:36:04', '2025-08-14 03:36:04'),
(263, 74, NULL, 'Заказ завершен заказчиком. Статус заказа: Завершен', 'system', 'sent', NULL, 0, '2025-08-14 03:47:51', '2025-08-14 03:47:51'),
(264, 77, NULL, 'Создан новый заказ \"Дизайн карточки для МП\" для исполнителя тестовый тест. Заказ находится на согласовании.', 'system', 'sent', NULL, 0, '2025-08-14 04:21:35', '2025-08-14 04:21:35'),
(265, 77, NULL, 'Заказ отменен. Статус заказа: Отменен', 'system', 'sent', NULL, 0, '2025-08-14 04:21:41', '2025-08-14 04:21:41'),
(266, 78, NULL, 'Создан новый заказ \"Дизайн карточки для МП\" для исполнителя тестовый тест. Заказ находится на согласовании.', 'system', 'sent', NULL, 0, '2025-08-14 04:25:00', '2025-08-14 04:25:00'),
(267, 78, NULL, 'Заказ взят в работу. Статус заказа: В работе', 'system', 'sent', NULL, 0, '2025-08-14 04:25:13', '2025-08-14 04:25:13'),
(268, 78, NULL, 'Заказ отменен заказчиком. Статус заказа: Отменен', 'system', 'sent', NULL, 0, '2025-08-14 04:25:39', '2025-08-14 04:25:39'),
(270, 80, NULL, 'Создан новый заказ \"Дизайн карточки для МП\" для исполнителя тестовый тест. Заказ находится на согласовании.', 'system', 'sent', NULL, 0, '2025-08-14 05:23:40', '2025-08-14 05:23:40'),
(271, 80, NULL, 'Заказ находится на согласовании. Статус заказа: На согласовании', 'system', 'sent', NULL, 0, '2025-08-14 05:23:40', '2025-08-14 05:23:40'),
(272, 80, NULL, 'Заказ взят в работу. Статус заказа: В работе', 'system', 'sent', NULL, 0, '2025-08-14 05:24:08', '2025-08-14 05:24:08'),
(273, 80, NULL, 'Исполнитель завершил работу. Статус заказа: На проверке. Ожидается проверка заказчиком. Ссылка на работу: https://ozon.ru/t/ytJNy41', 'system', 'sent', NULL, 0, '2025-08-14 05:24:40', '2025-08-14 05:24:40'),
(274, 80, 2, 'Ссылка на готовую работу: https://ozon.ru/t/ytJNy41', 'text', 'sent', NULL, 0, '2025-08-14 05:24:43', '2025-08-14 05:24:43'),
(275, 80, NULL, 'Заказ завершен заказчиком. Статус заказа: Завершен', 'system', 'sent', NULL, 0, '2025-08-14 05:24:50', '2025-08-14 05:24:50'),
(276, 81, NULL, 'Создан новый заказ \"Дизайн карточки для МП\" для исполнителя тестовый тест. Заказ находится на согласовании.', 'system', 'sent', NULL, 0, '2025-08-14 21:16:54', '2025-08-14 21:16:54'),
(277, 82, NULL, 'Создан новый заказ \"Дизайн карточки для МП\" для исполнителя Станислав Пузынин. Заказ находится на согласовании.', 'system', 'sent', NULL, 0, '2025-08-14 21:21:15', '2025-08-14 21:21:15'),
(278, 82, NULL, 'Заказ взят в работу. Статус заказа: В работе', 'system', 'sent', NULL, 0, '2025-08-14 21:23:39', '2025-08-14 21:23:39'),
(279, 81, NULL, 'Заказ взят в работу. Статус заказа: В работе', 'system', 'sent', NULL, 0, '2025-08-14 21:28:18', '2025-08-14 21:28:18'),
(280, 83, 1, 'привет', 'text', 'sent', NULL, 0, '2025-08-14 21:47:24', '2025-08-14 21:47:24'),
(281, 84, NULL, 'Создан новый заказ \"Дизайн визитки\" для исполнителя Софья Горбачева. Заказ находится на согласовании.', 'system', 'sent', NULL, 0, '2025-08-15 02:07:27', '2025-08-15 02:07:27'),
(282, 84, NULL, 'Заказ находится на согласовании. Статус заказа: На согласовании', 'system', 'sent', NULL, 0, '2025-08-15 02:07:27', '2025-08-15 02:07:27'),
(283, 84, 12, 'Здравствуйте!Жду подробное техническое задание!', 'text', 'sent', NULL, 0, '2025-08-15 02:09:17', '2025-08-15 02:09:17'),
(284, 85, NULL, 'Создан новый заказ \"Видео\" для исполнителя Арина Кондраткова. Заказ находится на согласовании.', 'system', 'sent', NULL, 0, '2025-08-15 05:11:35', '2025-08-15 05:11:35'),
(285, 85, NULL, 'Заказ находится на согласовании. Статус заказа: На согласовании', 'system', 'sent', NULL, 0, '2025-08-15 05:11:35', '2025-08-15 05:11:35'),
(286, 85, 13, 'Здравствуйте! Могу увидеть материал который нужно смонтировать?', 'text', 'sent', NULL, 0, '2025-08-15 05:17:40', '2025-08-15 05:17:40');

-- --------------------------------------------------------

--
-- Структура таблицы `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_07_11_182044_create_work_types_table', 1),
(5, '2025_07_11_182051_create_order_attribute_types_table', 1),
(6, '2025_07_11_182109_create_order_attribute_values_table', 1),
(7, '2025_07_11_182155_create_orders_table', 1),
(8, '2025_07_11_182208_create_order_attributes_table', 1),
(9, '2025_07_11_182216_create_order_materials_table', 1),
(10, '2025_07_12_194831_add_order_fields_to_orders_table', 1),
(11, '2025_07_16_031917_add_order_fields_to_orders_table', 1),
(12, '2025_07_16_043948_remove_flexible_fields_from_orders_table', 2),
(13, '2025_07_12_064858_create_personal_access_tokens_table', 3),
(14, '2025_07_12_064521_add_surname_to_users_table', 4),
(15, '2025_07_16_170000_add_executor_id_to_orders_table', 5),
(16, '2025_07_16_170923_add_image_to_work_types_table', 6),
(17, '2025_07_16_171242_add_image_to_work_types_table', 7),
(18, '2025_01_16_000000_add_portfolio_fields_to_users_table', 8),
(19, '2025_07_29_175904_add_specializations_to_users_table', 9),
(20, '2025_07_30_050647_add_value_to_order_attributes_table', 10),
(21, '2025_07_30_050955_make_value_id_nullable_in_order_attributes', 11),
(22, '2025_07_30_061512_add_pending_approval_status_to_orders_table', 12),
(23, '2025_07_30_061637_add_pending_approval_status_to_orders_table', 12),
(28, '2025_07_30_163240_add_was_created_without_executor_to_orders_table', 13),
(29, '2025_08_04_122842_create_tariffs_table', 13),
(30, '2025_08_04_122848_create_services_table', 13),
(31, '2025_08_04_122900_create_service_prices_table', 13),
(32, '2025_08_04_124435_add_missing_tariff_fields_to_orders_table', 14),
(33, '2025_08_04_124454_add_foreign_key_to_selected_tariff_id', 14),
(34, '2025_08_04_162942_add_slides_quantity_to_orders_table', 15),
(35, '2025_08_07_040845_create_chats_table', 16),
(36, '2025_08_07_040850_create_chat_participants_table', 16),
(37, '2025_08_07_040855_create_messages_table', 16),
(38, '2025_08_07_052511_add_category_to_chats_table', 17),
(39, '2025_08_07_132915_make_user_id_nullable_in_messages_table', 18),
(40, '2025_08_07_162031_update_existing_chats_to_archive', 18),
(41, '2025_08_07_170152_add_pending_review_status_to_orders_table', 18),
(42, '2025_08_11_000000_add_revision_count_to_orders_table', 19),
(43, '2025_08_11_155450_create_reviews_table', 20),
(44, '2025_08_11_174456_add_description_fields_to_users_table', 21),
(45, '2025_08_11_181125_remove_general_description_from_users_table', 22),
(46, '2025_08_13_172130_create_portfolio_works_table', 23),
(47, '2025_08_14_180000_add_work_link_to_orders_table', 24),
(48, '2025_08_11_181126_add_chat_indexes', 25);

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `executor_id` bigint(20) UNSIGNED DEFAULT NULL,
  `executor_offers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`executor_offers`)),
  `work_type_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `budget` decimal(10,2) DEFAULT NULL,
  `deadline` date DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'open',
  `work_link` varchar(2048) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `selected_tariff_id` bigint(20) UNSIGNED DEFAULT NULL,
  `was_created_without_executor` tinyint(1) NOT NULL DEFAULT 0,
  `selected_services` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`selected_services`)),
  `selected_options` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`selected_options`)),
  `calculated_price` decimal(10,2) DEFAULT NULL,
  `slides_quantity` int(11) DEFAULT NULL,
  `revision_count` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `executor_id`, `executor_offers`, `work_type_id`, `title`, `description`, `budget`, `deadline`, `status`, `work_link`, `created_at`, `updated_at`, `selected_tariff_id`, `was_created_without_executor`, `selected_services`, `selected_options`, `calculated_price`, `slides_quantity`, `revision_count`) VALUES
(178, 1, 2, '[2]', 7, 'Дизайн визитки', 'Создание профессиональных визиток для бизнеса', 3000.00, '2025-08-23', 'completed', NULL, '2025-08-14 03:22:36', '2025-08-14 03:47:51', NULL, 0, '{\"11\":{\"enabled\":true,\"tariffId\":9},\"12\":{\"enabled\":false,\"tariffId\":null}}', NULL, 3000.00, NULL, 0),
(180, 1, 2, '[2]', 6, 'Дизайн карточки для МП', 'Создание привлекательных и продающих карточек для маркетплейсов', 600.00, '2025-08-21', 'cancelled', NULL, '2025-08-14 04:21:34', '2025-08-14 04:21:41', NULL, 0, '{\"9\":{\"enabled\":true,\"tariffId\":7},\"10\":{\"enabled\":false,\"tariffId\":null}}', NULL, 600.00, 1, 0),
(181, 1, 2, '[2]', 6, 'Дизайн карточки для МП', 'Создание привлекательных и продающих карточек для маркетплейсов', 2000.00, '2025-08-21', 'cancelled', NULL, '2025-08-14 04:25:00', '2025-08-14 04:25:39', NULL, 0, '{\"9\":{\"enabled\":true,\"tariffId\":9},\"10\":{\"enabled\":false,\"tariffId\":null}}', NULL, 2000.00, 1, 0),
(183, 1, 2, NULL, 6, 'Дизайн карточки для МП', 'Создание привлекательных и продающих карточек для маркетплейсов', 600.00, '2025-08-21', 'completed', 'https://ozon.ru/t/ytJNy41', '2025-08-14 05:12:40', '2025-08-14 05:24:50', NULL, 1, '{\"9\":{\"enabled\":true,\"tariffId\":7},\"10\":{\"enabled\":false,\"tariffId\":null}}', NULL, 600.00, 1, 0),
(184, 1, NULL, NULL, 6, 'Дизайн карточки для МП', 'Создание привлекательных и продающих карточек для маркетплейсов', 1400.00, '2025-09-06', 'open', NULL, '2025-08-14 06:24:11', '2025-08-14 06:24:11', NULL, 1, '{\"9\":{\"enabled\":true,\"tariffId\":7},\"10\":{\"enabled\":true,\"tariffId\":7}}', NULL, 1400.00, 2, 0),
(185, 2, 12, NULL, 7, 'Дизайн визитки', 'Создание профессиональных визиток для бизнеса', 3000.00, '2025-09-18', 'pending_approval', NULL, '2025-08-14 06:26:22', '2025-08-15 02:07:27', NULL, 1, '{\"11\":{\"enabled\":true,\"tariffId\":9},\"12\":{\"enabled\":false,\"tariffId\":null}}', NULL, 3000.00, NULL, 0),
(186, 1, 13, NULL, 8, 'Видео', 'Создание и монтаж видеороликов под разные задачи', 6000.00, '2025-10-03', 'pending_approval', NULL, '2025-08-14 06:27:00', '2025-08-15 05:11:35', NULL, 1, '{\"14\":{\"enabled\":true,\"tariffId\":9}}', NULL, 6000.00, NULL, 0),
(188, 1, 2, '[2]', 6, 'Дизайн карточки для МП', 'Создание привлекательных и продающих карточек для маркетплейсов', 600.00, '2025-08-22', 'in_progress', NULL, '2025-08-14 21:16:54', '2025-08-14 21:28:18', NULL, 0, '{\"9\":{\"enabled\":true,\"tariffId\":7},\"10\":{\"enabled\":false,\"tariffId\":null}}', NULL, 600.00, 1, 0),
(189, 2, 1, '[1]', 6, 'Дизайн карточки для МП', 'Создание привлекательных и продающих карточек для маркетплейсов', 600.00, '2025-08-28', 'in_progress', NULL, '2025-08-14 21:21:15', '2025-08-14 21:23:39', NULL, 0, '{\"9\":{\"enabled\":true,\"tariffId\":7},\"10\":{\"enabled\":false,\"tariffId\":null}}', NULL, 600.00, 1, 0),
(190, 5, NULL, NULL, 6, 'Дизайн карточки для МП', 'Нужен дизайн карточки', 1400.00, '2025-09-07', 'open', NULL, '2025-08-14 21:31:28', '2025-08-14 21:31:28', NULL, 1, '{\"9\":{\"enabled\":true,\"tariffId\":7},\"10\":{\"enabled\":true,\"tariffId\":7}}', NULL, 1400.00, 2, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `order_attributes`
--

CREATE TABLE `order_attributes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `attribute_type_id` bigint(20) UNSIGNED NOT NULL,
  `value_id` bigint(20) UNSIGNED DEFAULT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `order_attributes`
--

INSERT INTO `order_attributes` (`id`, `order_id`, `attribute_type_id`, `value_id`, `value`, `created_at`, `updated_at`) VALUES
(91, 184, 51, 97, NULL, '2025-08-14 06:24:11', '2025-08-14 06:24:11'),
(92, 184, 52, NULL, 'Чайник', '2025-08-14 06:24:11', '2025-08-14 06:24:11'),
(93, 184, 53, NULL, 'ссылка на фото', '2025-08-14 06:24:11', '2025-08-14 06:24:11'),
(94, 184, 54, NULL, 'Отличный чайник', '2025-08-14 06:24:11', '2025-08-14 06:24:11'),
(95, 184, 56, NULL, 'Светлый минимализм', '2025-08-14 06:24:11', '2025-08-14 06:24:11'),
(96, 185, 57, 100, NULL, '2025-08-14 06:26:22', '2025-08-14 06:26:22'),
(97, 185, 58, 106, NULL, '2025-08-14 06:26:22', '2025-08-14 06:26:22'),
(98, 185, 59, 109, NULL, '2025-08-14 06:26:22', '2025-08-14 06:26:22'),
(99, 185, 60, NULL, 'ФИО', '2025-08-14 06:26:22', '2025-08-14 06:26:22'),
(100, 185, 61, NULL, 'Номер телефона', '2025-08-14 06:26:22', '2025-08-14 06:26:22'),
(101, 185, 62, NULL, 'нет', '2025-08-14 06:26:22', '2025-08-14 06:26:22'),
(102, 186, 74, 128, NULL, '2025-08-14 06:27:00', '2025-08-14 06:27:00'),
(103, 186, 75, 135, NULL, '2025-08-14 06:27:00', '2025-08-14 06:27:00'),
(104, 186, 76, 156, NULL, '2025-08-14 06:27:00', '2025-08-14 06:27:00'),
(105, 186, 77, 164, NULL, '2025-08-14 06:27:00', '2025-08-14 06:27:00'),
(106, 190, 51, 97, NULL, '2025-08-14 21:31:28', '2025-08-14 21:31:28'),
(107, 190, 52, NULL, 'Снежколеп', '2025-08-14 21:31:28', '2025-08-14 21:31:28'),
(108, 190, 53, NULL, 'ссылка позже будет', '2025-08-14 21:31:28', '2025-08-14 21:31:28'),
(109, 190, 54, NULL, 'Текст для карточки', '2025-08-14 21:31:28', '2025-08-14 21:31:28'),
(110, 190, 56, NULL, 'Стил простой и красивый', '2025-08-14 21:31:28', '2025-08-14 21:31:28');

-- --------------------------------------------------------

--
-- Структура таблицы `order_attribute_types`
--

CREATE TABLE `order_attribute_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `order_attribute_types`
--

INSERT INTO `order_attribute_types` (`id`, `name`, `label`, `sort_order`, `created_at`, `updated_at`) VALUES
(51, 'marketplace', 'Платформа (маркетплейс)', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(52, 'product_name', 'Название товара', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(53, 'product_photo', 'Ссылка на фото товара', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(54, 'card_text', 'Текст для карточки', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(55, 'slides_count', 'Количество слайдов', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(56, 'design_style', 'Стиль дизайна', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(57, 'card_purpose', 'Какова основная цель визитки?', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(58, 'card_recipients', 'Кто будет получать визитку?', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(59, 'recipient_lifestyle', 'Какой образ жизни у получателя визитки?', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(60, 'card_text', 'Какой текст нужно разместить на визитке?', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(61, 'contact_info', 'Какие контактные данные включить?', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(62, 'brandbook', 'Прикрепите брендбук (если есть)', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(63, 'company_name', 'Название компании', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(64, 'company_colors', 'Цвета компании', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(65, 'company_fonts', 'Шрифты компании', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(66, 'company_logo', 'Загрузите логотип компании', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(67, 'brand_elements', 'Загрузите фирменные элементы', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(68, 'qr_code_link', 'Ссылка для QR-кода', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(69, 'qr_code_description', 'Описание QR-кода', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(70, 'card_size', 'Размер визитки', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(71, 'design_direction', 'Общее направление дизайна', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(72, 'background_color', 'Цвет фона визитки', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(73, 'card_sides', 'Сколько сторон у визитки?', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(74, 'video_duration', 'Какое количество секунд должно быть в итоговом видео?', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(75, 'video_format', 'Какого формата должно быть видео?', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(76, 'video_direction', 'Какой направленности должно быть видео?', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(77, 'video_add_subtitles', 'Добавить субтитры?', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09');

-- --------------------------------------------------------

--
-- Структура таблицы `order_attribute_values`
--

CREATE TABLE `order_attribute_values` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `attribute_type_id` bigint(20) UNSIGNED NOT NULL,
  `value` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `order_attribute_values`
--

INSERT INTO `order_attribute_values` (`id`, `attribute_type_id`, `value`, `label`, `sort_order`, `created_at`, `updated_at`) VALUES
(97, 51, 'ozon', 'Ozon', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(98, 51, 'wildberries', 'Wildberries', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(99, 51, 'Яндекс.Маркет', 'Яндекс.Маркет', 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(100, 57, 'Бизнес', 'Бизнес', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(101, 57, 'Личная', 'Личная', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(102, 57, 'Событие', 'Событие', 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(103, 57, 'Промо', 'Промо', 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(104, 58, 'Клиенты', 'Клиенты', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(105, 58, 'Партнеры', 'Партнеры', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(106, 58, 'Коллеги', 'Коллеги', 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(107, 58, 'Друзья', 'Друзья', 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(108, 58, 'Семья', 'Семья', 4, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(109, 59, 'Деловой', 'Деловой', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(110, 59, 'Творческий', 'Творческий', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(111, 59, 'Спортивный', 'Спортивный', 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(112, 59, 'Классический', 'Классический', 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(113, 59, 'Современный', 'Современный', 4, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(114, 70, 'Стандарт (90x50 мм)', 'Стандарт (90x50 мм)', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(115, 70, 'Евро (85x55 мм)', 'Евро (85x55 мм)', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(116, 70, 'Американский (88.9x50.8 мм)', 'Американский (88.9x50.8 мм)', 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(117, 70, 'Квадрат (50x50 мм)', 'Квадрат (50x50 мм)', 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(118, 71, 'Минимализм', 'Минимализм', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(119, 71, 'Классика', 'Классика', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(120, 71, 'Современный', 'Современный', 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(121, 71, 'Креативный', 'Креативный', 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(122, 71, 'Элегантный', 'Элегантный', 4, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(123, 73, 'Односторонняя', 'Односторонняя', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(124, 73, 'Двусторонняя', 'Двусторонняя', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(125, 74, 'до 15 секунд', 'до 15 секунд', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(126, 74, '16-30 секунд', '16-30 секунд', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(127, 74, '31-60 секунд', '31-60 секунд', 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(128, 74, '61-100 секунд', '61-100 секунд', 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(129, 74, '101-150 секунд', '101-150 секунд', 4, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(130, 75, '9:16 (tik tok)', '9:16 (tik tok)', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(131, 75, '1:1', '1:1', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(132, 75, '16:9 (youtube)', '16:9 (Youtube)', 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(133, 75, '4:3 (горизонтальный)', '4:3 (горизонтальный)', 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(134, 75, '3:4 (вертикальный)', '3:4 (вертикальный)', 4, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(135, 75, '5.8\"', '5.8\"', 5, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(136, 75, '2:1', '2:1', 6, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(137, 75, '2.35:1', '2.35:1', 7, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(138, 75, '1.85:1', '1.85:1', 8, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(139, 75, 'Свой вариант', 'Свой вариант', 9, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(140, 76, 'Анимационное видео (2d, 3d, моушн-графика)', 'Анимационное видео (2D, 3D, моушн-графика)', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(141, 76, 'Видео визитка', 'Видео визитка', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(142, 76, 'Видео с asrm звуками', 'Видео с ASRM звуками', 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(143, 76, 'Видеоподкаст', 'Видеоподкаст', 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(144, 76, 'Влог, видео из путешествия', 'Влог, видео из путешествия', 4, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(145, 76, 'Видео инструкция', 'Видео инструкция', 5, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(146, 76, 'Информационное видео', 'Информационное видео', 6, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(147, 76, 'Клип', 'Клип', 7, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(148, 76, 'Видео-нарезка', 'Видео-нарезка', 8, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(149, 76, 'Мультфильм', 'Мультфильм', 9, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(150, 76, 'Обзорное видео недвижимости / пространства, услуги, спортивных соревнований', 'Обзорное видео недвижимости / пространства, услуги, спортивных соревнований', 10, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(151, 76, 'Отзыв', 'Отзыв', 11, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(152, 76, 'Отчетное видео', 'Отчетное видео', 12, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(153, 76, 'Приветственное видео', 'Приветственное видео', 13, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(154, 76, 'Развлекательного характера', 'Развлекательного характера', 14, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(155, 76, 'Рекламное видео', 'Рекламное видео', 15, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(156, 76, 'Репортаж', 'Репортаж', 16, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(157, 76, 'Рецепты', 'Рецепты', 17, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(158, 76, 'Распаковка товара', 'Распаковка товара', 18, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(159, 76, 'Самопрезентация', 'Самопрезентация', 19, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(160, 76, 'Свадебное видео', 'Свадебное видео', 20, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(161, 76, 'Тизер / Трейлер', 'Тизер / Трейлер', 21, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(162, 76, 'Художественное видео (короткометражка), свой вариант', 'Художественное видео (короткометражка), свой вариант', 22, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(163, 77, 'да', 'да', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(164, 77, 'нет', 'нет', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09');

-- --------------------------------------------------------

--
-- Структура таблицы `order_materials`
--

CREATE TABLE `order_materials` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `file_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `order_materials`
--

INSERT INTO `order_materials` (`id`, `order_id`, `type`, `description`, `file_url`, `created_at`, `updated_at`) VALUES
(15, 177, 'https://docs.google.com/document/d/1ap2K2BdVRHwwHEN1BGypqszp0g_lEOddIGs63S4RuAU/edit?tab=t.0', 'https://docs.google.com/document/d/1ap2K2BdVRHwwHEN1BGypqszp0g_lEOddIGs63S4RuAU/edit?tab=t.0', 'https://docs.google.com/document/d/1ap2K2BdVRHwwHEN1BGypqszp0g_lEOddIGs63S4RuAU/edit?tab=t.0', '2025-08-14 01:52:31', '2025-08-14 01:52:31'),
(16, 185, 'нет', NULL, NULL, '2025-08-14 06:26:22', '2025-08-14 06:26:22'),
(17, 186, 'нет', NULL, NULL, '2025-08-14 06:27:00', '2025-08-14 06:27:00');

-- --------------------------------------------------------

--
-- Структура таблицы `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'app_token', '9fbf494e0f31d2647249daea8d91838d1bfdd257fcad0448575a301a148331f8', '[\"*\"]', '2025-07-15 23:01:49', NULL, '2025-07-15 22:05:50', '2025-07-15 23:01:49'),
(2, 'App\\Models\\User', 1, 'app_token', '9772872c6c9cd902598322f2312085ec705504722e1046926f1370c81b591012', '[\"*\"]', '2025-07-15 23:22:39', NULL, '2025-07-15 23:05:21', '2025-07-15 23:22:39'),
(3, 'App\\Models\\User', 1, 'app_token', '873c5c8de1a4e482714d1468df107e1b096ae9885a91f89f1fbe3986d81a293d', '[\"*\"]', '2025-07-16 07:22:01', NULL, '2025-07-16 07:21:59', '2025-07-16 07:22:01'),
(4, 'App\\Models\\User', 1, 'app_token', '86219d55665d04e0ca835716f6fcd33a07bae2f29571a6bf15d5671e00b4f77c', '[\"*\"]', '2025-07-16 09:08:58', NULL, '2025-07-16 07:22:13', '2025-07-16 09:08:58'),
(5, 'App\\Models\\User', 2, 'app_token', 'e7be4abe7a26e21b3703661270f9f49f31ca87d00129bad3cd4720492c6f5c4c', '[\"*\"]', '2025-07-16 09:14:07', NULL, '2025-07-16 09:09:22', '2025-07-16 09:14:07'),
(6, 'App\\Models\\User', 1, 'app_token', '533ec7bca4df9c343422609a20cab3af3c2e8e14d47f0944b3afafa12d8af8ce', '[\"*\"]', '2025-07-16 09:19:40', NULL, '2025-07-16 09:14:18', '2025-07-16 09:19:40'),
(7, 'App\\Models\\User', 2, 'app_token', 'f01a3eb0670b11b97e73debd28a04e7fa7d558914a10c99dbb004dac119829e0', '[\"*\"]', '2025-07-16 09:19:55', NULL, '2025-07-16 09:19:51', '2025-07-16 09:19:55'),
(8, 'App\\Models\\User', 3, 'app_token', 'eed3cb3b2c8899ba22b657f8deda83512cd67091bfbaa39eabb102f44e516a35', '[\"*\"]', '2025-07-16 09:21:10', NULL, '2025-07-16 09:21:10', '2025-07-16 09:21:10'),
(9, 'App\\Models\\User', 1, 'app_token', 'a0253bcdc1c573e4df0c5ac0cb22603c67614ace6c02562464b7771dc4effce1', '[\"*\"]', '2025-07-16 09:47:03', NULL, '2025-07-16 09:23:03', '2025-07-16 09:47:03'),
(10, 'App\\Models\\User', 2, 'app_token', 'e164b5e8cab536496ee1221c2e1480c065251ff33774425c2a1602850ab0e722', '[\"*\"]', '2025-07-16 09:52:07', NULL, '2025-07-16 09:47:12', '2025-07-16 09:52:07'),
(11, 'App\\Models\\User', 1, 'app_token', 'e9c30d46621cf12fe2915e17c1cd0211df07827cd0034173da059a119f5ebb80', '[\"*\"]', '2025-07-16 10:43:44', NULL, '2025-07-16 09:52:35', '2025-07-16 10:43:44'),
(12, 'App\\Models\\User', 2, 'app_token', 'ad6d3e0157ea839e58bd6542e25361801ac81def722c2e3b5c9317739fce7723', '[\"*\"]', '2025-07-16 10:53:02', NULL, '2025-07-16 10:43:50', '2025-07-16 10:53:02'),
(13, 'App\\Models\\User', 1, 'app_token', '3b3cb2145ee97293d78009dddf2fca00ad9132070d759d8bfeab2ff1b7e7a03c', '[\"*\"]', '2025-07-23 03:32:21', NULL, '2025-07-16 10:54:51', '2025-07-23 03:32:21'),
(14, 'App\\Models\\User', 1, 'app_token', 'f529abf8485ae3618f9046b17b95de8a0d66dedae4461c37438b065c778821e5', '[\"*\"]', '2025-07-23 03:58:49', NULL, '2025-07-23 03:32:31', '2025-07-23 03:58:49'),
(15, 'App\\Models\\User', 1, 'app_token', 'cbf0f4b9939943f78d02faae8a3cd18c21c11e4a2dca4801beaf53da7e9f0568', '[\"*\"]', '2025-07-23 03:59:03', NULL, '2025-07-23 03:58:55', '2025-07-23 03:59:03'),
(16, 'App\\Models\\User', 1, 'app_token', '8ed76a43d7ce9b3b58ba131b25d539a764b5a304543dd955de4ba9415f33ca35', '[\"*\"]', '2025-07-23 04:02:19', NULL, '2025-07-23 04:00:27', '2025-07-23 04:02:19'),
(17, 'App\\Models\\User', 1, 'app_token', '482ee40a38919d7be44820cb7bbc52b0fd88c31632ea317bd37751539bb9e375', '[\"*\"]', '2025-07-29 09:37:58', NULL, '2025-07-23 04:02:26', '2025-07-29 09:37:58'),
(18, 'App\\Models\\User', 2, 'app_token', '961aa286dde7dafc4bd3e72881a1f907e159ca044c3ed16163823c6e465c31c5', '[\"*\"]', '2025-07-29 11:12:17', NULL, '2025-07-29 09:38:05', '2025-07-29 11:12:17'),
(19, 'App\\Models\\User', 1, 'app_token', 'cb58cb4adecc6a71931158187820e564db1883d502f46bafbfc79eee9eba6c9f', '[\"*\"]', '2025-07-30 08:22:48', NULL, '2025-07-29 11:12:24', '2025-07-30 08:22:48'),
(20, 'App\\Models\\User', 1, 'app_token', '2e82bbddcb0a22fc623cca1aed7a585733cc1ee5a66516747216269a58b9da1b', '[\"*\"]', '2025-07-29 23:10:16', NULL, '2025-07-29 20:25:14', '2025-07-29 23:10:16'),
(21, 'App\\Models\\User', 2, 'app_token', 'f22ea225466418cb7f6e0a85bf550be28f977e0e1962f58cabbc710976a54f5d', '[\"*\"]', '2025-07-29 23:21:32', NULL, '2025-07-29 23:11:13', '2025-07-29 23:21:32'),
(22, 'App\\Models\\User', 1, 'app_token', '8026d106162119241be78ef73daa06484de5339cefc40177fd974272b2a75122', '[\"*\"]', '2025-07-29 23:21:43', NULL, '2025-07-29 23:21:36', '2025-07-29 23:21:43'),
(23, 'App\\Models\\User', 2, 'app_token', 'dc371cf4fa2a0dffd617dc8b59256f66cce39a15812f95ee7bc046fdacd37f56', '[\"*\"]', '2025-07-30 08:24:21', NULL, '2025-07-30 08:23:07', '2025-07-30 08:24:21'),
(24, 'App\\Models\\User', 1, 'app_token', '35d5c98e08fee6b34897db69fc7bf5d5c2421374a431ff8152847fae05f6cad2', '[\"*\"]', '2025-07-30 08:24:42', NULL, '2025-07-30 08:24:34', '2025-07-30 08:24:42'),
(25, 'App\\Models\\User', 2, 'app_token', '59d6dadfad6cf4c8b7400db402da93f59ff146e5e1844aa70f1c2b16aae6d2dc', '[\"*\"]', '2025-07-30 08:35:06', NULL, '2025-07-30 08:24:46', '2025-07-30 08:35:06'),
(26, 'App\\Models\\User', 1, 'app_token', 'e79f7d138b549460b0fd4c4d833b11fccdf40a20468517144c3b4eb9a6dcc616', '[\"*\"]', '2025-07-30 08:36:36', NULL, '2025-07-30 08:35:10', '2025-07-30 08:36:36'),
(27, 'App\\Models\\User', 2, 'app_token', '3dc9e16731ed91fbf5ee343814f563124290c070a00accf914cfac9416324080', '[\"*\"]', '2025-07-30 08:40:42', NULL, '2025-07-30 08:36:40', '2025-07-30 08:40:42'),
(28, 'App\\Models\\User', 1, 'app_token', '57c0c019e2c51a90a29e283450dd84ba5c233a351ddcef9590f6657650a3982b', '[\"*\"]', '2025-07-30 08:40:59', NULL, '2025-07-30 08:40:58', '2025-07-30 08:40:59'),
(29, 'App\\Models\\User', 2, 'app_token', '9dc24eb838af651f67163b866d63d4552ce71756870cbc9dc56911e29115ed2c', '[\"*\"]', '2025-07-30 08:42:40', NULL, '2025-07-30 08:41:11', '2025-07-30 08:42:40'),
(30, 'App\\Models\\User', 1, 'app_token', 'ff4c141c19e34cf1a244c0194ff836f7b9c909d876ef8e5781b5ee52a72a81b0', '[\"*\"]', '2025-07-30 08:43:40', NULL, '2025-07-30 08:42:54', '2025-07-30 08:43:40'),
(31, 'App\\Models\\User', 2, 'app_token', '4ebedffc757dc2af452b8d14f27080e468b3857cbea1f796448b0db369e9cf4c', '[\"*\"]', '2025-07-30 08:43:51', NULL, '2025-07-30 08:43:50', '2025-07-30 08:43:51'),
(32, 'App\\Models\\User', 3, 'app_token', '3c60233aabfb25d2921a3e5e1940d83e4d2a0c22041586845257e1e57b8b1f03', '[\"*\"]', '2025-07-30 08:46:37', NULL, '2025-07-30 08:45:40', '2025-07-30 08:46:37'),
(33, 'App\\Models\\User', 2, 'app_token', '9c678a1c10cdde0a108c01986acc2a5088204de8ed6147cfeca682f3b6f5a841', '[\"*\"]', '2025-07-30 08:56:09', NULL, '2025-07-30 08:46:40', '2025-07-30 08:56:09'),
(34, 'App\\Models\\User', 1, 'app_token', '73169f226017a100de11f99f95d6072c1775e962bb7e50335f91a54a812112e4', '[\"*\"]', '2025-07-30 09:03:06', NULL, '2025-07-30 08:56:14', '2025-07-30 09:03:06'),
(35, 'App\\Models\\User', 2, 'app_token', '46551f554d41109bf7bc6afbd38f032fe34f0bb2f548d76e755189d67d54141e', '[\"*\"]', '2025-07-30 09:04:52', NULL, '2025-07-30 09:03:11', '2025-07-30 09:04:52'),
(36, 'App\\Models\\User', 3, 'app_token', 'c3f27979128369e8362a13848eb1d9e1730dc77b2b3b65214d483eb7cca44666', '[\"*\"]', '2025-07-30 09:08:01', NULL, '2025-07-30 09:04:54', '2025-07-30 09:08:01'),
(37, 'App\\Models\\User', 2, 'app_token', '1d20733d2d5f576242af980c2bb02ee716d4e7100ca66abf3ac530ebc4f58f91', '[\"*\"]', '2025-07-30 09:20:25', NULL, '2025-07-30 09:08:05', '2025-07-30 09:20:25'),
(38, 'App\\Models\\User', 3, 'app_token', 'de8e7c721ff478526400e6741081509726aba89c777d99c86cbebf9bcda97513', '[\"*\"]', '2025-07-30 09:20:37', NULL, '2025-07-30 09:20:29', '2025-07-30 09:20:37'),
(39, 'App\\Models\\User', 2, 'app_token', '8f2d48433c67dc4a2ef05b8b6f98b405e60e5c930ba8d4eeb138b323bf321261', '[\"*\"]', '2025-07-30 09:20:52', NULL, '2025-07-30 09:20:44', '2025-07-30 09:20:52'),
(40, 'App\\Models\\User', 1, 'app_token', 'e96e7649270d9a32c951aa55e71f8ac1301eba54191abfc48183693d5d0090dc', '[\"*\"]', '2025-07-30 09:27:56', NULL, '2025-07-30 09:20:58', '2025-07-30 09:27:56'),
(41, 'App\\Models\\User', 3, 'app_token', '83d3aed60cbc1b7ab078c4db3e41057b7ab7e85c5efb294f9174b8c129d06fc8', '[\"*\"]', '2025-07-30 09:28:26', NULL, '2025-07-30 09:28:06', '2025-07-30 09:28:26'),
(42, 'App\\Models\\User', 2, 'app_token', '6c61f9a5e2745268e22b61848f4f27e8a7dc905d9e8262d6f0f145a424854c65', '[\"*\"]', '2025-07-30 09:33:54', NULL, '2025-07-30 09:28:37', '2025-07-30 09:33:54'),
(43, 'App\\Models\\User', 1, 'app_token', '18cbbeac25b4a1998870f70174658dda3dfa03dc0d5ab600a521eccb09f344d9', '[\"*\"]', '2025-07-30 09:35:55', NULL, '2025-07-30 09:35:29', '2025-07-30 09:35:55'),
(44, 'App\\Models\\User', 3, 'app_token', '4f3118c51fcd23889caf417b4a85770ac31fa86107bfa60fa2cd60e2073bf26f', '[\"*\"]', '2025-07-30 09:40:07', NULL, '2025-07-30 09:36:08', '2025-07-30 09:40:07'),
(45, 'App\\Models\\User', 2, 'app_token', 'd6bf4e72a94064ae5d377a6397a6931170eefb01224974096ed2727cd142b90d', '[\"*\"]', '2025-07-30 09:40:16', NULL, '2025-07-30 09:40:13', '2025-07-30 09:40:16'),
(46, 'App\\Models\\User', 1, 'app_token', '0586d3983be3470ad1bd110214baeb97da63879f05b6a545097dfb23cf20a406', '[\"*\"]', '2025-07-30 09:41:28', NULL, '2025-07-30 09:40:22', '2025-07-30 09:41:28'),
(47, 'App\\Models\\User', 2, 'app_token', 'e2caca731f24a1a13ee994929a8c7991c2b048203ffb43d8154a6a3138c504b2', '[\"*\"]', '2025-07-30 09:44:05', NULL, '2025-07-30 09:43:55', '2025-07-30 09:44:05'),
(48, 'App\\Models\\User', 3, 'app_token', '1bd13a8c6106cb5a95e2524032f1945b919e78ccb4f65a0f410ae9386821a208', '[\"*\"]', '2025-07-30 09:46:59', NULL, '2025-07-30 09:44:09', '2025-07-30 09:46:59'),
(49, 'App\\Models\\User', 1, 'app_token', '52df49e93102349eedcd037e8fe34f31617acf747417c5ecf5c2af5f58737f8d', '[\"*\"]', '2025-07-30 10:46:46', NULL, '2025-07-30 09:47:06', '2025-07-30 10:46:46'),
(50, 'App\\Models\\User', 1, 'app_token', 'f9ceaae427cf9f66dc2583b7b61ab3e9f7dd65a63b1c1c44528a84be072c37f7', '[\"*\"]', '2025-07-30 20:35:23', NULL, '2025-07-30 20:35:20', '2025-07-30 20:35:23'),
(51, 'App\\Models\\User', 1, 'app_token', '8f1ac9899ad52f632baa5f68514e89dc1a3f3881e5696320e2f70be10f58febc', '[\"*\"]', NULL, NULL, '2025-07-30 20:35:22', '2025-07-30 20:35:22'),
(52, 'App\\Models\\User', 1, 'app_token', '6a8dbe07b9a94bf5f2c2c1c3f35e57b26f0888118be8db5cc0cfb2b95d66dee8', '[\"*\"]', '2025-07-30 20:46:43', NULL, '2025-07-30 20:35:22', '2025-07-30 20:46:43'),
(53, 'App\\Models\\User', 2, 'app_token', '8e1b60c678084fbe7a5a3b9e24f7646e2cb18310880820b1b1b3727873c43bef', '[\"*\"]', '2025-07-30 21:03:16', NULL, '2025-07-30 21:03:01', '2025-07-30 21:03:16'),
(54, 'App\\Models\\User', 1, 'app_token', '046f23b809b102cdac5abcf83655668dbd3948c5c02a717561e4adfc0066607a', '[\"*\"]', NULL, NULL, '2025-07-30 21:03:21', '2025-07-30 21:03:21'),
(55, 'App\\Models\\User', 1, 'app_token', '17b7cb280cc3bcaa433240f86d438879b476a5d1cc481eb13ede52126ad75f69', '[\"*\"]', '2025-07-30 21:31:27', NULL, '2025-07-30 21:03:23', '2025-07-30 21:31:27'),
(56, 'App\\Models\\User', 2, 'app_token', 'c3dc3f0ac44ad53b100ced840d1a164b3b71930a2881ec6ada9ff96a92cbf8fd', '[\"*\"]', '2025-07-30 21:35:03', NULL, '2025-07-30 21:31:36', '2025-07-30 21:35:03'),
(57, 'App\\Models\\User', 1, 'app_token', '03a703b6a77ce2898d057182f44762d08d6099f6941a0678937fe428147b845e', '[\"*\"]', '2025-07-30 21:36:32', NULL, '2025-07-30 21:35:10', '2025-07-30 21:36:32'),
(58, 'App\\Models\\User', 2, 'app_token', 'a0c483bc68c3cce3a8147520a77e0db497cd10a1b3ed71368a468164e46fd4ed', '[\"*\"]', '2025-07-30 21:36:52', NULL, '2025-07-30 21:36:39', '2025-07-30 21:36:52'),
(59, 'App\\Models\\User', 1, 'app_token', '577f8bd5b20eddbeb46de8c7de8036d88c91fb58705c44fa8892dc16de905574', '[\"*\"]', '2025-07-30 21:55:55', NULL, '2025-07-30 21:36:56', '2025-07-30 21:55:55'),
(60, 'App\\Models\\User', 2, 'app_token', '1a9960e33eb919e4c6e99fcc06bbb6fc9833329dc7c1af01fa697f64640965d9', '[\"*\"]', '2025-07-30 21:57:11', NULL, '2025-07-30 21:56:04', '2025-07-30 21:57:11'),
(61, 'App\\Models\\User', 2, 'app_token', '3e741525f3a75b1f9ae2287163f74f2d2b1ec162e735ea004e1f88d33a951ebd', '[\"*\"]', '2025-07-30 21:57:42', NULL, '2025-07-30 21:57:41', '2025-07-30 21:57:42'),
(62, 'App\\Models\\User', 1, 'app_token', '71d29c04d85261c47b9a29214d092b36d370da86851e17154398eca935dc3b9b', '[\"*\"]', '2025-07-30 22:00:48', NULL, '2025-07-30 21:57:46', '2025-07-30 22:00:48'),
(63, 'App\\Models\\User', 1, 'app_token', '7fcfced1644dcb290b823a881e1b64230eca7925146beea42f2c1205e1625ec8', '[\"*\"]', '2025-07-30 22:01:10', NULL, '2025-07-30 22:00:52', '2025-07-30 22:01:10'),
(64, 'App\\Models\\User', 2, 'app_token', '759221192bd4e1e69d9cec79686745162276aecebb2ba22c05c12de598fa423e', '[\"*\"]', '2025-07-30 22:04:58', NULL, '2025-07-30 22:01:15', '2025-07-30 22:04:58'),
(65, 'App\\Models\\User', 1, 'app_token', '7e8b0dc0869441b95f2f5148eb8dc9287f86712162b6f923208dac58ad8e1ea3', '[\"*\"]', '2025-07-30 22:05:34', NULL, '2025-07-30 22:05:02', '2025-07-30 22:05:34'),
(66, 'App\\Models\\User', 2, 'app_token', '04e141c8950f6b44ca9fe39c2f276818e476824f7219294317be69c4f4185106', '[\"*\"]', '2025-07-30 22:08:51', NULL, '2025-07-30 22:05:41', '2025-07-30 22:08:51'),
(67, 'App\\Models\\User', 1, 'app_token', 'f6468b286fdf8bc14e93ed45899ac274d585225aa8633bc2dc712142338858a1', '[\"*\"]', '2025-07-30 22:09:10', NULL, '2025-07-30 22:08:59', '2025-07-30 22:09:10'),
(68, 'App\\Models\\User', 2, 'app_token', '175288bc471f755c3c4d3c6d77f067915310df01737fbb2d93677366cb0d2b88', '[\"*\"]', '2025-07-30 22:11:08', NULL, '2025-07-30 22:09:14', '2025-07-30 22:11:08'),
(69, 'App\\Models\\User', 1, 'app_token', '54228b6cd92cfa5d0ffb113774f176ab4a824468e19c52e057643faac8bb68ab', '[\"*\"]', '2025-07-30 22:11:29', NULL, '2025-07-30 22:11:12', '2025-07-30 22:11:29'),
(70, 'App\\Models\\User', 2, 'app_token', '450d82bc8f55a2150ffca08dfe5effab640004254b863be1fc4f207abe35a0cb', '[\"*\"]', '2025-07-30 22:12:26', NULL, '2025-07-30 22:11:36', '2025-07-30 22:12:26'),
(71, 'App\\Models\\User', 1, 'app_token', 'f7b4fd0df4dbd66199634112de97020d3d91f0b07bc596810dbb353e30b3ee64', '[\"*\"]', '2025-07-30 22:13:15', NULL, '2025-07-30 22:12:59', '2025-07-30 22:13:15'),
(72, 'App\\Models\\User', 2, 'app_token', 'a5a292e99a6b025f9d9568551825e727e3c2c52a0a06b253846bf76fcd4e65ce', '[\"*\"]', '2025-07-30 22:17:49', NULL, '2025-07-30 22:13:21', '2025-07-30 22:17:49'),
(73, 'App\\Models\\User', 1, 'app_token', '65d1d927e8fa9e70d87010377f55151d00287de69bc0a1a0cddca498adc5255a', '[\"*\"]', '2025-07-30 22:18:37', NULL, '2025-07-30 22:18:36', '2025-07-30 22:18:37'),
(74, 'App\\Models\\User', 1, 'app_token', '92b2c28c0a468db424796d7ae17b94dc6a5fb477e18b57a8e494c016aae3438f', '[\"*\"]', '2025-07-30 22:18:59', NULL, '2025-07-30 22:18:36', '2025-07-30 22:18:59'),
(75, 'App\\Models\\User', 2, 'app_token', 'fafd57b1fd971a26575d17b1eb983fa87858ffa33daa946c7ed54affd5aa2586', '[\"*\"]', '2025-07-30 22:19:21', NULL, '2025-07-30 22:19:17', '2025-07-30 22:19:21'),
(76, 'App\\Models\\User', 1, 'app_token', '8b7ac6b60262e75e8269231aec0f6f623cec5cb22214d83863b9bf41445cd456', '[\"*\"]', '2025-07-30 22:20:39', NULL, '2025-07-30 22:20:36', '2025-07-30 22:20:39'),
(77, 'App\\Models\\User', 2, 'app_token', '544d11663e4a70b90aab1dfecc1e422eef83c01d650e491703f7dc44e44bee39', '[\"*\"]', '2025-07-30 22:20:58', NULL, '2025-07-30 22:20:50', '2025-07-30 22:20:58'),
(78, 'App\\Models\\User', 1, 'app_token', '71b0f2debe3ec5e43082f90ef7302866b9da8baf8f183200208f1b3fc51c40f9', '[\"*\"]', '2025-07-30 22:21:03', NULL, '2025-07-30 22:21:02', '2025-07-30 22:21:03'),
(79, 'App\\Models\\User', 1, 'app_token', '04f9f5d48b39a89bde76fb8bcc9452da4d4c2e90b4e7ee825406b5cc9b34a6be', '[\"*\"]', '2025-07-30 22:22:59', NULL, '2025-07-30 22:21:03', '2025-07-30 22:22:59'),
(80, 'App\\Models\\User', 2, 'app_token', '9287094d19bb44f763ba1874c98f7042cd196e592da899db5965b397fb5bc5f6', '[\"*\"]', '2025-07-30 22:23:10', NULL, '2025-07-30 22:23:03', '2025-07-30 22:23:10'),
(81, 'App\\Models\\User', 1, 'app_token', '8847c87ef7ab70b68304ac65b404fcd01acccf48ebcb91e5a603b9660149cbe2', '[\"*\"]', '2025-07-30 22:28:10', NULL, '2025-07-30 22:23:13', '2025-07-30 22:28:10'),
(82, 'App\\Models\\User', 2, 'app_token', '156c0141cb748fcb3ea469d621c5471fed6a769a1ddf4c6fd6feef070ba05bf5', '[\"*\"]', '2025-07-30 22:28:22', NULL, '2025-07-30 22:28:15', '2025-07-30 22:28:22'),
(83, 'App\\Models\\User', 1, 'app_token', '302acc15ed8a3ead3ab090ffeb47931d3d1993c580245e9513563727152e97fe', '[\"*\"]', '2025-07-30 22:28:38', NULL, '2025-07-30 22:28:25', '2025-07-30 22:28:38'),
(84, 'App\\Models\\User', 2, 'app_token', '8a0f39fae20aac434fbd7768acfac7dcaf169d92bc9425a2c6b8f2d0f7da681c', '[\"*\"]', '2025-07-30 22:28:54', NULL, '2025-07-30 22:28:44', '2025-07-30 22:28:54'),
(85, 'App\\Models\\User', 1, 'app_token', '67c27ab3b5f32affb24544eba29286da664074fee8ff0c6697bf40e3371d6800', '[\"*\"]', '2025-07-30 22:29:32', NULL, '2025-07-30 22:28:58', '2025-07-30 22:29:32'),
(86, 'App\\Models\\User', 2, 'app_token', 'c13f3ba1c9a1f9563a6dae046e9a076ec9fd15473ee8e0e4be5af7b364366091', '[\"*\"]', '2025-07-30 22:36:12', NULL, '2025-07-30 22:29:39', '2025-07-30 22:36:12'),
(87, 'App\\Models\\User', 1, 'app_token', '12acf16b136c1c63570693107969e5727104dc56d9615b4fb90f8be415109e81', '[\"*\"]', '2025-07-30 22:36:27', NULL, '2025-07-30 22:36:15', '2025-07-30 22:36:27'),
(88, 'App\\Models\\User', 2, 'app_token', '63abdef548710e261fa73dcd034c5cfbc71ffb12a0d151a328d69fdca7e14fac', '[\"*\"]', '2025-07-30 22:39:54', NULL, '2025-07-30 22:36:32', '2025-07-30 22:39:54'),
(89, 'App\\Models\\User', 1, 'app_token', '1b0e3f1aaa396e42c3113cb6d3ef2184239f348432a319e07ffe124747311b4e', '[\"*\"]', '2025-07-30 22:40:10', NULL, '2025-07-30 22:39:57', '2025-07-30 22:40:10'),
(90, 'App\\Models\\User', 2, 'app_token', '65ce5bc12f1f554b2c87e3c30dbdfee07add5c825ccf9e2818cb1f0dcc4d11c7', '[\"*\"]', '2025-07-30 22:43:39', NULL, '2025-07-30 22:40:14', '2025-07-30 22:43:39'),
(91, 'App\\Models\\User', 1, 'app_token', '3ce6764376d95b5fc0acbaae5597f2e2bed8040338314e740479a320c46dbe7e', '[\"*\"]', '2025-07-30 22:45:31', NULL, '2025-07-30 22:43:59', '2025-07-30 22:45:31'),
(92, 'App\\Models\\User', 2, 'app_token', '472c08559b15f38ab4ff09b52fa86feb83e9cc612c7fab97e394d4a0000707c1', '[\"*\"]', '2025-08-06 19:43:12', NULL, '2025-07-30 22:45:36', '2025-08-06 19:43:12'),
(93, 'App\\Models\\User', 1, 'app_token', '3d2875fa59a4cdaacfc3c2f6ec80b1d574f23c4deae05482c7ab3fbe81c0585e', '[\"*\"]', NULL, NULL, '2025-07-31 00:23:49', '2025-07-31 00:23:49'),
(94, 'App\\Models\\User', 1, 'app_token', '51535c08d79f4374032fddbc1649d92ab5c8cb0337d2878c4f6dae52931e5842', '[\"*\"]', '2025-07-31 01:43:31', NULL, '2025-07-31 00:23:50', '2025-07-31 01:43:31'),
(95, 'App\\Models\\User', 3, 'app_token', '5a6c94f790d85f6e6058285c7c55583c156c6edf9d9213f0eb86f189f1dbd472', '[\"*\"]', '2025-07-31 01:44:24', NULL, '2025-07-31 01:43:37', '2025-07-31 01:44:24'),
(96, 'App\\Models\\User', 1, 'app_token', '083ebcfdbb90f8deb64d0b42a11ef13f0eb656b494b0f7f98632429bb4aaf833', '[\"*\"]', '2025-08-04 05:00:45', NULL, '2025-07-31 01:44:29', '2025-08-04 05:00:45'),
(97, 'App\\Models\\User', 1, 'app_token', '3f1a468fb3b5008e31a66a0e2bfbca5efb4ddf52dfc815d1f329690bce6792a6', '[\"*\"]', NULL, NULL, '2025-08-04 05:00:48', '2025-08-04 05:00:48'),
(98, 'App\\Models\\User', 1, 'app_token', '735eb308d0fb7a77cebd60df5c0022999434e6d2db2466282a481f7a7bfede99', '[\"*\"]', NULL, NULL, '2025-08-04 05:00:49', '2025-08-04 05:00:49'),
(99, 'App\\Models\\User', 1, 'app_token', '2d7c8dde599fcdcc1029d1f77f75bfb78f67be315a8ad1728109c92d0416df4d', '[\"*\"]', NULL, NULL, '2025-08-04 05:00:50', '2025-08-04 05:00:50'),
(100, 'App\\Models\\User', 1, 'app_token', '7772a9388bc039f45cd939143f9b584c0409e80d593ae13bea703f56a145d330', '[\"*\"]', '2025-08-04 11:30:17', NULL, '2025-08-04 05:00:50', '2025-08-04 11:30:17'),
(101, 'App\\Models\\User', 1, 'app_token', '63de80a7ff17ba7561a7add34f98016318341669093daf83207e86ff7c727919', '[\"*\"]', '2025-08-06 19:47:22', NULL, '2025-08-06 19:43:16', '2025-08-06 19:47:22'),
(102, 'App\\Models\\User', 2, 'app_token', '0f054c6dca7db47dde65bb5fe2db926635be38289ac3a9ca688d49e183f07121', '[\"*\"]', '2025-08-06 19:57:25', NULL, '2025-08-06 19:57:23', '2025-08-06 19:57:25'),
(103, 'App\\Models\\User', 2, 'app_token', 'a88a73187403bdf08ff7d1b40a3551b4f90eeccaecd32e575b74a40df61b31bc', '[\"*\"]', '2025-08-06 20:38:27', NULL, '2025-08-06 19:57:24', '2025-08-06 20:38:27'),
(104, 'App\\Models\\User', 1, 'app_token', '149177a94b94e92086aae813b1f0eb116e1eb52e8b2b72366e528120bbf11292', '[\"*\"]', '2025-08-06 21:24:25', NULL, '2025-08-06 20:38:30', '2025-08-06 21:24:25'),
(105, 'App\\Models\\User', 2, 'app_token', 'd5efbd9bd1b0a75beaaf0f29b443c69c642cdf69ca066429f38122431ff8274e', '[\"*\"]', '2025-08-06 21:25:05', NULL, '2025-08-06 21:24:33', '2025-08-06 21:25:05'),
(106, 'App\\Models\\User', 1, 'app_token', '684a72187139e36907c8c0601102c5e04024efda2808e4149449f7edc69976f5', '[\"*\"]', '2025-08-06 21:35:47', NULL, '2025-08-06 21:25:10', '2025-08-06 21:35:47'),
(107, 'App\\Models\\User', 2, 'app_token', '981d349b90bb69e05daaaf2afde406973890dbb24d5c7503c45f27e6726365eb', '[\"*\"]', '2025-08-06 21:40:04', NULL, '2025-08-06 21:35:51', '2025-08-06 21:40:04'),
(108, 'App\\Models\\User', 1, 'app_token', '6c7ca60d4eec63fca4512a756d055d0a0daa720fd8a10cafbbbada8001665031', '[\"*\"]', '2025-08-06 21:40:52', NULL, '2025-08-06 21:40:07', '2025-08-06 21:40:52'),
(109, 'App\\Models\\User', 2, 'app_token', '904e17202422d0e6a1a71242f6a17241916611e2b9acd66378bcf3bc92877202', '[\"*\"]', '2025-08-06 21:46:00', NULL, '2025-08-06 21:40:57', '2025-08-06 21:46:00'),
(110, 'App\\Models\\User', 1, 'app_token', '50c9017b83ac21daff157ff57905817b2801e72419a35fc81b7865d2673f1782', '[\"*\"]', '2025-08-06 21:47:56', NULL, '2025-08-06 21:46:03', '2025-08-06 21:47:56'),
(111, 'App\\Models\\User', 2, 'app_token', 'c32f1823ac7f820eb51297cbffa8c97010f98d876bf4e594d5f6b8946d795d36', '[\"*\"]', '2025-08-06 21:48:25', NULL, '2025-08-06 21:48:08', '2025-08-06 21:48:25'),
(112, 'App\\Models\\User', 1, 'app_token', 'b53843e5af773b34bb7096e1ff3962276fdafd0dc4608b0e75ce951985810f82', '[\"*\"]', '2025-08-06 21:53:25', NULL, '2025-08-06 21:48:33', '2025-08-06 21:53:25'),
(113, 'App\\Models\\User', 2, 'app_token', 'f373adb6272609ea05f57636f42fe8bad57e3fac957e44fcbba6333fbe926da0', '[\"*\"]', '2025-08-06 22:00:19', NULL, '2025-08-06 21:51:46', '2025-08-06 22:00:19'),
(114, 'App\\Models\\User', 1, 'app_token', 'ba3cde9408a41121b654fb00b25d6cd39fe0552c0fc75e3748c7f4bb49c37803', '[\"*\"]', '2025-08-07 19:16:18', NULL, '2025-08-06 22:00:31', '2025-08-07 19:16:18'),
(115, 'App\\Models\\User', 2, 'app_token', '88c87f5e0285a31d43ab719429461392b389b8999f55697dc8239dcd46acd89c', '[\"*\"]', '2025-08-11 20:05:02', NULL, '2025-08-06 22:00:44', '2025-08-11 20:05:02'),
(116, 'App\\Models\\User', 1, 'app_token', '2fd4540182824bf0b57da1d1ed20030b5e2ac3112c1d00f2709b976dd674333c', '[\"*\"]', '2025-08-07 11:56:54', NULL, '2025-08-07 11:27:48', '2025-08-07 11:56:54'),
(117, 'App\\Models\\User', 2, 'app_token', 'aec885650d304400bb6efab4c5861e9601ab28ce3e95519560d997b2a20ee438', '[\"*\"]', '2025-08-07 11:57:09', NULL, '2025-08-07 11:54:19', '2025-08-07 11:57:09'),
(118, 'App\\Models\\User', 2, 'app_token', 'e41786daef0bb73593e72ee7b8b262fc51ebb903331e84af9ea2fc9d89f67672', '[\"*\"]', '2025-08-07 19:16:30', NULL, '2025-08-07 19:16:24', '2025-08-07 19:16:30'),
(119, 'App\\Models\\User', 1, 'app_token', '0135651afb0d49cf9fc43ba27d3e560eb358040530be09a5f61dd8c17375bd2a', '[\"*\"]', '2025-08-07 21:14:01', NULL, '2025-08-07 19:16:34', '2025-08-07 21:14:01'),
(120, 'App\\Models\\User', 2, 'app_token', 'f909ce54e8a25ed9053c74e2e19039907b155aede411cb996ea2f4958f6e156a', '[\"*\"]', '2025-08-07 21:25:12', NULL, '2025-08-07 21:14:08', '2025-08-07 21:25:12'),
(121, 'App\\Models\\User', 1, 'app_token', '89f39c2454c3cd7a181a5c54de09b65d2a6969eb04679fbade19350ad2b875fa', '[\"*\"]', '2025-08-07 21:28:26', NULL, '2025-08-07 21:25:21', '2025-08-07 21:28:26'),
(122, 'App\\Models\\User', 2, 'app_token', '48d032c893aa72c4029bf298ab9c3d3787ebd46a8cb2fb183f9072e8f87afb47', '[\"*\"]', '2025-08-07 21:44:28', NULL, '2025-08-07 21:28:31', '2025-08-07 21:44:28'),
(123, 'App\\Models\\User', 1, 'app_token', '7d1d2fbac6f1bd2e91bfe3105572d72172e56e6d383a616b09a02ee70b851cac', '[\"*\"]', '2025-08-07 21:44:34', NULL, '2025-08-07 21:44:33', '2025-08-07 21:44:34'),
(124, 'App\\Models\\User', 1, 'app_token', '2341f93c9bbd8d6ac2f9679913e0fb6c7a38d89c18227917afeaed36837acc5c', '[\"*\"]', '2025-08-08 00:26:22', NULL, '2025-08-07 21:44:34', '2025-08-08 00:26:22'),
(125, 'App\\Models\\User', 1, 'app_token', '23595b3443e60cabdde4c33868a445f2162579be21fb4f53f1b5c92e45eb56b4', '[\"*\"]', '2025-08-10 23:06:26', NULL, '2025-08-10 20:25:11', '2025-08-10 23:06:26'),
(126, 'App\\Models\\User', 1, 'app_token', 'd147586179ee1024eafb1303aed84ffa11637c6aa82f2b08320e95bb73f5f05c', '[\"*\"]', '2025-08-10 23:16:38', NULL, '2025-08-10 23:06:36', '2025-08-10 23:16:38'),
(127, 'App\\Models\\User', 1, 'app_token', '75b93ced24d032c532fd862c82b02617a7685e5caa358276262f7375256d008c', '[\"*\"]', '2025-08-11 06:56:02', NULL, '2025-08-11 05:57:39', '2025-08-11 06:56:02'),
(128, 'App\\Models\\User', 2, 'app_token', 'e3ef34412095b6cff332d4f93ce18aa6d60c191a59fc84339074b8831c7f4412', '[\"*\"]', '2025-08-11 08:19:46', NULL, '2025-08-11 06:01:17', '2025-08-11 08:19:46'),
(129, 'App\\Models\\User', 1, 'app_token', '468f07a451ee948c2f50dc31c84a46c3e1dceac6416e232861444fede346ab34', '[\"*\"]', '2025-08-11 06:59:56', NULL, '2025-08-11 06:58:23', '2025-08-11 06:59:56'),
(130, 'App\\Models\\User', 1, 'app_token', 'a6e199fbd7f2a3e6d4a8524797b73a04099d47c8572bd131416b63b7ae35dfd8', '[\"*\"]', '2025-08-11 07:01:35', NULL, '2025-08-11 07:00:02', '2025-08-11 07:01:35'),
(131, 'App\\Models\\User', 1, 'app_token', 'f631674f46da9947119e2dca6ed5cea9402daeb53776e19af12ba25db8bb474d', '[\"*\"]', '2025-08-11 07:01:55', NULL, '2025-08-11 07:01:46', '2025-08-11 07:01:55'),
(132, 'App\\Models\\User', 1, 'app_token', '063289db36c4e25f1b86ea0be286899b398489ebf16017c7ae8ff8e8989011e7', '[\"*\"]', '2025-08-11 07:02:18', NULL, '2025-08-11 07:02:01', '2025-08-11 07:02:18'),
(133, 'App\\Models\\User', 1, 'app_token', '0d8e04926e189f192fe09740f4a942a54bff649b098556103b8dfa988b1a28b5', '[\"*\"]', '2025-08-11 07:04:01', NULL, '2025-08-11 07:02:19', '2025-08-11 07:04:01'),
(134, 'App\\Models\\User', 1, 'app_token', '0fd4b9358208d82e93e2f918e1d7ef7198116997ff127b692e219e0dd713ef83', '[\"*\"]', '2025-08-11 07:15:29', NULL, '2025-08-11 07:04:03', '2025-08-11 07:15:29'),
(135, 'App\\Models\\User', 3, 'app_token', 'e0b70648632d141a504285e84abefe31b1f90bd6849fa7bfee07fc4da5c2f22e', '[\"*\"]', '2025-08-11 07:43:33', NULL, '2025-08-11 07:15:41', '2025-08-11 07:43:33'),
(136, 'App\\Models\\User', 1, 'app_token', '9de164984805f903a9c82193672459ec8ee68e95f08944972e6a4d3ce56b5943', '[\"*\"]', '2025-08-11 08:19:51', NULL, '2025-08-11 07:44:16', '2025-08-11 08:19:51'),
(137, 'App\\Models\\User', 2, 'app_token', '169c3810d39b41f1c2451d623b6fd7a4d13842c45be6323defefcaa1c9657e62', '[\"*\"]', '2025-08-14 06:13:10', NULL, '2025-08-11 08:19:50', '2025-08-14 06:13:10'),
(138, 'App\\Models\\User', 3, 'app_token', '5240d43cac5f7670563d50232ff5646056397392626a35e00963d563930079b9', '[\"*\"]', '2025-08-11 08:22:53', NULL, '2025-08-11 08:20:14', '2025-08-11 08:22:53'),
(139, 'App\\Models\\User', 1, 'app_token', '2a36ef5cebf85ae9237772d6526f1f8cbbd0528faeaf912846237e69b7999818', '[\"*\"]', '2025-08-11 09:23:23', NULL, '2025-08-11 08:23:08', '2025-08-11 09:23:23'),
(140, 'App\\Models\\User', 3, 'app_token', '2c6c22ea7d9624e20a1c7ba35ef8cab88ff5e9e90adde9bba25b0cde17d18930', '[\"*\"]', '2025-08-11 09:23:41', NULL, '2025-08-11 09:23:30', '2025-08-11 09:23:41'),
(141, 'App\\Models\\User', 1, 'app_token', 'ce5b009d10c7475457f82378b7601a42f5317f02f5dabf0ec4ba359034bc6bae', '[\"*\"]', '2025-08-11 09:28:35', NULL, '2025-08-11 09:23:45', '2025-08-11 09:28:35'),
(142, 'App\\Models\\User', 3, 'app_token', '6d717e1b00cce98b562ae4fb7e3f47159a13c106578424e468a790f85c7716e8', '[\"*\"]', '2025-08-11 09:28:57', NULL, '2025-08-11 09:28:41', '2025-08-11 09:28:57'),
(143, 'App\\Models\\User', 1, 'app_token', '186caf462d6eed375962ea3ea50aadeb7df063143e8e478693866c8f9304c71a', '[\"*\"]', '2025-08-11 09:45:45', NULL, '2025-08-11 09:29:01', '2025-08-11 09:45:45'),
(144, 'App\\Models\\User', 1, 'app_token', '96abfd453729186f97f36d22163af76bdf2b7033f0dede8456ea7d71a8cfd1de', '[\"*\"]', '2025-08-11 11:31:11', NULL, '2025-08-11 09:45:52', '2025-08-11 11:31:11'),
(145, 'App\\Models\\User', 1, 'app_token', '55caa2c18ec797707c8d5b60af79868ff22d57424f65fcaab9f6841e4d260cf9', '[\"*\"]', '2025-08-11 11:44:36', NULL, '2025-08-11 11:31:13', '2025-08-11 11:44:36'),
(146, 'App\\Models\\User', 1, 'app_token', 'ffd145ada29ecee6ad1a2f53f9427ec27e3e511202fb0aaacc7297844a047e1b', '[\"*\"]', '2025-08-11 19:34:46', NULL, '2025-08-11 19:13:58', '2025-08-11 19:34:46'),
(147, 'App\\Models\\User', 1, 'app_token', 'cc65847d02570fc0b96e3d15bfa9852ccf433e3c494c262d5ec20747a54a4f2b', '[\"*\"]', '2025-08-11 20:40:56', NULL, '2025-08-11 19:34:47', '2025-08-11 20:40:56'),
(148, 'App\\Models\\User', 2, 'app_token', '6f06fe1d4c90ca29f3754a5e39db35feabce17c6f746c5a3bee5db356969a8f3', '[\"*\"]', '2025-08-11 23:24:03', NULL, '2025-08-11 20:05:07', '2025-08-11 23:24:03'),
(149, 'App\\Models\\User', 1, 'app_token', '34d63f39aeeafd93bd46235638550f183b88d9c8fdd608dd3495f9c24686c77b', '[\"*\"]', '2025-08-11 22:46:17', NULL, '2025-08-11 20:40:58', '2025-08-11 22:46:17'),
(150, 'App\\Models\\User', 1, 'app_token', 'e55932501bb3d99bae02459e7be2921e5e687e4f23cc4a8465844f6262f8494d', '[\"*\"]', '2025-08-11 22:49:00', NULL, '2025-08-11 22:49:00', '2025-08-11 22:49:00'),
(151, 'App\\Models\\User', 1, 'app_token', '6337264eadffd9f29887144b9eae79f25704ab51caa7b09374493b97600d2b9c', '[\"*\"]', '2025-08-11 22:57:23', NULL, '2025-08-11 22:50:34', '2025-08-11 22:57:23'),
(152, 'App\\Models\\User', 2, 'app_token', '40be8b78a1ed5408cffa662c13fc8cd0413066ec919edb8bbf9dc58473668990', '[\"*\"]', '2025-08-11 23:25:33', NULL, '2025-08-11 23:24:04', '2025-08-11 23:25:33'),
(153, 'App\\Models\\User', 1, 'app_token', '7007d720a6d1cf4923e3f0bc14cefa658b82a288b3ae763df30aa4a0fd92605f', '[\"*\"]', '2025-08-11 23:26:53', NULL, '2025-08-11 23:25:36', '2025-08-11 23:26:53'),
(154, 'App\\Models\\User', 2, 'app_token', '2fe6ec7fefb6356a01e2be4166fbf4bd3406f52bc150dbfc6feb9f872106e54a', '[\"*\"]', '2025-08-11 23:27:15', NULL, '2025-08-11 23:26:58', '2025-08-11 23:27:15'),
(155, 'App\\Models\\User', 1, 'app_token', '6d2d2daf0275270d88f259d7cf69a1ba38cf51871d4dd18cbaf265ae9690845a', '[\"*\"]', '2025-08-13 07:54:24', NULL, '2025-08-11 23:56:39', '2025-08-13 07:54:24'),
(156, 'App\\Models\\User', 1, 'app_token', '561b25051d906880d363caccda539a39636dadb28ef134c2e804b1cccf24bd29', '[\"*\"]', '2025-08-13 07:54:26', NULL, '2025-08-13 07:54:22', '2025-08-13 07:54:26'),
(157, 'App\\Models\\User', 1, 'app_token', '82fb852b8e548fcef786cdb7c98a39d14807dc587a34db13438ea93863cf8be9', '[\"*\"]', '2025-08-13 09:06:05', NULL, '2025-08-13 07:54:23', '2025-08-13 09:06:05'),
(158, 'App\\Models\\User', 2, 'app_token', 'e53e2e8a661c76af5a33b9247cd2138b2336fbca85e46a7a7523563f5be249c6', '[\"*\"]', '2025-08-13 09:15:53', NULL, '2025-08-13 09:06:22', '2025-08-13 09:15:53'),
(159, 'App\\Models\\User', 1, 'app_token', 'ce62e5bacf1767660ab3ef826cd71c6f8d3d68d79840b108332c815f32886143', '[\"*\"]', '2025-08-13 10:50:32', NULL, '2025-08-13 09:15:58', '2025-08-13 10:50:32'),
(160, 'App\\Models\\User', 2, 'app_token', 'fa8b9624b1082b6cc1b352f3202ce8a62bc37d4d1cabee4ee9dd41fcc686d9ef', '[\"*\"]', '2025-08-14 00:23:15', NULL, '2025-08-13 10:50:35', '2025-08-14 00:23:15'),
(161, 'App\\Models\\User', 1, 'app_token', 'fe0b27061d8f765726a0a09e498faa3e52e9141ba5e06983be450f5c79f86a1e', '[\"*\"]', '2025-08-14 04:09:43', NULL, '2025-08-14 00:23:17', '2025-08-14 04:09:43'),
(162, 'App\\Models\\User', 1, 'app_token', '443407a17bdf09b24b0090acb1637b77a5728e67ff72b263b70b7729c84dd0b3', '[\"*\"]', '2025-08-14 04:10:21', NULL, '2025-08-14 04:10:14', '2025-08-14 04:10:21'),
(163, 'App\\Models\\User', 1, 'app_token', '9e4c86ceb0034ceff393fcd25ec4e68525e59de0e65be21008a0a3c93ad0bbb2', '[\"*\"]', '2025-08-14 04:12:42', NULL, '2025-08-14 04:12:12', '2025-08-14 04:12:42'),
(164, 'App\\Models\\User', 1, 'app_token', '85c9d6a7ad6b8ddec1edfe7ddbdd26cb4b792dfa777fd32b98837039cd3b4502', '[\"*\"]', '2025-08-14 04:13:14', NULL, '2025-08-14 04:13:07', '2025-08-14 04:13:14'),
(165, 'App\\Models\\User', 1, 'app_token', 'fd49e9afbacd72e67ebc2a3cb5c8a8faeaa41ff503d21a3f1102c4b9675647d4', '[\"*\"]', '2025-08-14 04:13:27', NULL, '2025-08-14 04:13:20', '2025-08-14 04:13:27'),
(166, 'App\\Models\\User', 1, 'app_token', '4d4792061cc8928bc186a781528c7e14d7d94e04b5760295a2380f711d03dcb1', '[\"*\"]', '2025-08-14 04:15:22', NULL, '2025-08-14 04:15:15', '2025-08-14 04:15:22'),
(167, 'App\\Models\\User', 1, 'app_token', 'bc7bbb641c98479258888324bc995cfa925828cef7c9ccf5a2d39d3d0d8fa3e2', '[\"*\"]', '2025-08-14 05:30:31', NULL, '2025-08-14 04:20:41', '2025-08-14 05:30:31'),
(168, 'App\\Models\\User', 1, 'app_token', 'd48b24e5aebd11de58f41222b7a23a3255e609c7e0e606ec17cac207dc7967e0', '[\"*\"]', '2025-08-14 05:24:53', NULL, '2025-08-14 05:11:20', '2025-08-14 05:24:53'),
(169, 'App\\Models\\User', 2, 'app_token', '661ed55c2a6f9927ff86c1ea451563eb44b67f5fed478057980154853b7a84af', '[\"*\"]', '2025-08-14 08:04:10', NULL, '2025-08-14 05:15:38', '2025-08-14 08:04:10'),
(170, 'App\\Models\\User', 1, 'app_token', 'a62d53eaf98dddb46017ec9286b831218b944597b9d724d0721af2138c862fe3', '[\"*\"]', '2025-08-14 05:34:00', NULL, '2025-08-14 05:26:35', '2025-08-14 05:34:00'),
(171, 'App\\Models\\User', 1, 'app_token', '49fe9ecdb89c660ff3168dfdef97db40b188eb2f607abd5d6800296645142625', '[\"*\"]', '2025-08-14 05:35:41', NULL, '2025-08-14 05:34:28', '2025-08-14 05:35:41'),
(172, 'App\\Models\\User', 4, 'app_token', '2a16d5ce19e677733b46abf22461f0b71e1149cea75afbbff24eaf8057a657b0', '[\"*\"]', '2025-08-14 05:36:33', NULL, '2025-08-14 05:36:04', '2025-08-14 05:36:33'),
(173, 'App\\Models\\User', 1, 'app_token', 'e0e0836518f1fc6802c02468b38680956c29e92b72acd2fc311ed434066ae2be', '[\"*\"]', '2025-08-14 07:36:31', NULL, '2025-08-14 05:36:45', '2025-08-14 07:36:31'),
(174, 'App\\Models\\User', 2, 'app_token', '93187b5ec82a683986cdf0a8d1214cb5cbf0fd2a82d03e4363f8dca37df44f3d', '[\"*\"]', '2025-08-14 05:38:17', NULL, '2025-08-14 05:38:10', '2025-08-14 05:38:17'),
(175, 'App\\Models\\User', 2, 'app_token', '6cc284f74b476217314bb56ed6734cdffe55b46071f22356548fafb809ba806d', '[\"*\"]', '2025-08-14 05:55:58', NULL, '2025-08-14 05:55:50', '2025-08-14 05:55:58'),
(176, 'App\\Models\\User', 1, 'app_token', '1c6dc67da3b1fb4201ad8365d766abc623d6a99e8480eb79932720ecb8cd7cbf', '[\"*\"]', '2025-08-14 07:36:23', NULL, '2025-08-14 06:14:23', '2025-08-14 07:36:23'),
(177, 'App\\Models\\User', 2, 'app_token', 'c33ad45fe22b27ece3fe6c0e91f3e68bb56e17d949d85ee78aef76920866f4c1', '[\"*\"]', '2025-08-14 08:36:33', NULL, '2025-08-14 06:15:09', '2025-08-14 08:36:33'),
(178, 'App\\Models\\User', 1, 'app_token', '1a6a1e7503f66cf2df55c7c75b9bf1f9940e25763595f1422dca2fafee873f87', '[\"*\"]', '2025-08-14 07:44:04', NULL, '2025-08-14 07:36:49', '2025-08-14 07:44:04'),
(179, 'App\\Models\\User', 1, 'app_token', '2c66c6a2cf1408cb6d96ca23ce3be59649699a30e99c8b5a3e56dd4a8e570f9f', '[\"*\"]', '2025-08-14 07:40:15', NULL, '2025-08-14 07:40:12', '2025-08-14 07:40:15'),
(180, 'App\\Models\\User', 2, 'app_token', '90ac70bce37bb6dd8ccd5ee10900484137529319926ea6f6b0f1fa51cbb0508f', '[\"*\"]', NULL, NULL, '2025-08-14 08:03:44', '2025-08-14 08:03:44'),
(181, 'App\\Models\\User', 2, 'app_token', '03a16e4ce967d8909e206ab30647926d9ee7d8c31fc0ff38178c0d5d6854166e', '[\"*\"]', NULL, NULL, '2025-08-14 08:04:05', '2025-08-14 08:04:05'),
(182, 'App\\Models\\User', 2, 'app_token', '539b1343c33d00f94882c4c953f11ebcc368ace22d54d09e34a0f67a8ddc080c', '[\"*\"]', NULL, NULL, '2025-08-14 08:04:07', '2025-08-14 08:04:07'),
(183, 'App\\Models\\User', 2, 'app_token', 'e605a33b64dd06e293395ef72869b3d3a706324bdd5d51fcaf2a8ed1d7a40071', '[\"*\"]', NULL, NULL, '2025-08-14 08:04:09', '2025-08-14 08:04:09'),
(184, 'App\\Models\\User', 1, 'app_token', 'afdc0831b5f4ef96105511026cb33325a04d3f88e2bd8b4ab55b221d395bbdd0', '[\"*\"]', NULL, NULL, '2025-08-14 08:12:25', '2025-08-14 08:12:25'),
(185, 'App\\Models\\User', 1, 'app_token', 'd6d072d401d2b455fff68e957141016ef065f0fcc9ee7f6f3867303b8111f536', '[\"*\"]', '2025-08-14 08:15:13', NULL, '2025-08-14 08:12:25', '2025-08-14 08:15:13'),
(186, 'App\\Models\\User', 1, 'app_token', '3259f3b769dc270bc74c706093cf8bf3fa8f654783797066fe507dd21820614c', '[\"*\"]', '2025-08-14 08:25:22', NULL, '2025-08-14 08:15:12', '2025-08-14 08:25:22'),
(187, 'App\\Models\\User', 1, 'app_token', '0ec3277b896ef48b1cf6f3254ea3e83e720aaa86abc068c29d4990c3dc248a27', '[\"*\"]', '2025-08-14 21:16:57', NULL, '2025-08-14 21:10:59', '2025-08-14 21:16:57'),
(188, 'App\\Models\\User', 2, 'app_token', '841f04fe46bf37c5b92fd635c199a7858eab2b20fdd1785cfdabe003103b8126', '[\"*\"]', '2025-08-14 21:15:56', NULL, '2025-08-14 21:15:42', '2025-08-14 21:15:56'),
(189, 'App\\Models\\User', 2, 'app_token', 'be35917ee68ffa5959e45270d791ba6487a4e2148070072bf6f0fb303f0bc769', '[\"*\"]', '2025-08-14 21:29:18', NULL, '2025-08-14 21:20:18', '2025-08-14 21:29:18'),
(190, 'App\\Models\\User', 1, 'app_token', 'b9de124470911677e6e169ccad1c587667935935e87bb26b285fa8cd906e5d68', '[\"*\"]', '2025-08-14 21:23:32', NULL, '2025-08-14 21:23:08', '2025-08-14 21:23:32'),
(191, 'App\\Models\\User', 1, 'app_token', '16f367039f18e2c482e13e81d3a25c33b848a1d58895c7a7e816c4c6b97f15f7', '[\"*\"]', '2025-08-14 21:24:25', NULL, '2025-08-14 21:23:10', '2025-08-14 21:24:25'),
(192, 'App\\Models\\User', 1, 'app_token', '0aa8be852e8d5fd9a2ca9aeee745d302ebed8ae113fc641d544f70d8999e5334', '[\"*\"]', '2025-08-14 21:23:57', NULL, '2025-08-14 21:23:17', '2025-08-14 21:23:57'),
(193, 'App\\Models\\User', 5, 'app_token', '6224f7013e1048400f79548496533a20a18ffc17a294ebd5087e74ee904d0785', '[\"*\"]', '2025-08-14 21:39:14', NULL, '2025-08-14 21:29:32', '2025-08-14 21:39:14'),
(194, 'App\\Models\\User', 6, 'app_token', '865d1b677050d47c71d1aebff9a7ec8d469bca4d24dbb74b61957ffc9600d85f', '[\"*\"]', '2025-08-14 21:46:01', NULL, '2025-08-14 21:33:33', '2025-08-14 21:46:01'),
(195, 'App\\Models\\User', 3, 'app_token', 'b98b898ffd810f936476d67ec25037b0ab02d2da7351aa9d8c6835e1a7cb46c1', '[\"*\"]', '2025-08-14 21:38:38', NULL, '2025-08-14 21:36:54', '2025-08-14 21:38:38'),
(196, 'App\\Models\\User', 1, 'app_token', '01d77246b116040e83ecdd7e06e3a519dfbed14e0b8b5a6e506706f27ac393ad', '[\"*\"]', '2025-08-14 22:10:30', NULL, '2025-08-14 21:39:16', '2025-08-14 22:10:30'),
(197, 'App\\Models\\User', 7, 'app_token', 'ed9e3eb8bfb4cd171fcad9ccca07a53253f9ea38a19f729370c208ecb96f5602', '[\"*\"]', '2025-08-14 21:55:18', NULL, '2025-08-14 21:55:06', '2025-08-14 21:55:18'),
(198, 'App\\Models\\User', 8, 'app_token', '7123498fa431131b95395bda10482c694206d0685db917d4db80e9faf60fba54', '[\"*\"]', '2025-08-14 21:55:53', NULL, '2025-08-14 21:55:46', '2025-08-14 21:55:53'),
(199, 'App\\Models\\User', 1, 'app_token', '945a94ffe8d12d55b3decdfec097ec1b2f15b441bdfa18efb12b099ab46f425c', '[\"*\"]', '2025-08-14 23:14:32', NULL, '2025-08-14 22:11:07', '2025-08-14 23:14:32'),
(200, 'App\\Models\\User', 2, 'app_token', '1474f2de24b229749457ae6402c8a9389667faba55b4feeb65e4594f5b6ef1a2', '[\"*\"]', '2025-08-14 22:14:24', NULL, '2025-08-14 22:14:00', '2025-08-14 22:14:24'),
(201, 'App\\Models\\User', 2, 'app_token', 'd1200a2cc27da1c39cca5bdc306f3ff0ff02a0b98ac01297127d16c0e579bcc0', '[\"*\"]', '2025-08-14 22:17:22', NULL, '2025-08-14 22:17:14', '2025-08-14 22:17:22'),
(202, 'App\\Models\\User', 9, 'app_token', 'dfe1bc49a59d72f60a12005310456d70d99cf32890fd11389a5b77a8d3d4eec9', '[\"*\"]', '2025-08-14 22:17:59', NULL, '2025-08-14 22:17:50', '2025-08-14 22:17:59'),
(203, 'App\\Models\\User', 2, 'app_token', 'ae76db9b3ec63acba67499e31d6e651eeefbdb46102013bdc86ff5b975b1748b', '[\"*\"]', '2025-08-14 22:25:37', NULL, '2025-08-14 22:24:44', '2025-08-14 22:25:37'),
(204, 'App\\Models\\User', 5, 'app_token', '55a2a1a2166d42a94e760a117874e97ffa7ce9d65f86cac538d3d93d17d3ffb2', '[\"*\"]', '2025-08-14 22:26:00', NULL, '2025-08-14 22:25:48', '2025-08-14 22:26:00'),
(205, 'App\\Models\\User', 5, 'app_token', 'dde1a2a990eb073eae163d981a1bdea6f5769721695532bcbf16c98d49488a45', '[\"*\"]', '2025-08-14 23:08:17', NULL, '2025-08-14 22:28:37', '2025-08-14 23:08:17'),
(206, 'App\\Models\\User', 1, 'app_token', 'e01d38b4e8acc01424b30b9d6d5fb4eac3b6c4db21be192cc543c36ee134f5fd', '[\"*\"]', '2025-08-14 23:22:15', NULL, '2025-08-14 23:18:57', '2025-08-14 23:22:15'),
(207, 'App\\Models\\User', 10, 'app_token', '755b287be41edd9a6640a619a394b875fe542de1a9de4c66ab96280984d91ae3', '[\"*\"]', '2025-08-14 23:31:11', NULL, '2025-08-14 23:25:44', '2025-08-14 23:31:11'),
(208, 'App\\Models\\User', 2, 'app_token', 'de66976e9f619394f1771806557511d0c9ef4ba8c2d93a0ccb1a99e14f6610eb', '[\"*\"]', '2025-08-15 00:26:11', NULL, '2025-08-15 00:03:41', '2025-08-15 00:26:11'),
(209, 'App\\Models\\User', 1, 'app_token', '17ec81387cc2e529bf28ead01b096ab293e4c6abcadc61789a37e3e4a26d73c5', '[\"*\"]', '2025-08-15 01:35:13', NULL, '2025-08-15 00:26:12', '2025-08-15 01:35:13'),
(210, 'App\\Models\\User', 11, 'app_token', '62920878c8f9773e09ca41e1ea9d941fb9ab312c4e13f3c496d16baa1efe8b8c', '[\"*\"]', '2025-08-15 00:48:28', NULL, '2025-08-15 00:32:21', '2025-08-15 00:48:28'),
(211, 'App\\Models\\User', 12, 'app_token', '305084d06d3377b4b3376be175d6c74563d5b684e8a1323ca94bc63840acea40', '[\"*\"]', '2025-08-15 02:10:06', NULL, '2025-08-15 02:07:05', '2025-08-15 02:10:06'),
(212, 'App\\Models\\User', 1, 'app_token', '8e5e18cbc123036b0ec92ab1bbe04cbab34b1a2c22882efc31da98fa173e6c53', '[\"*\"]', '2025-08-15 03:03:19', NULL, '2025-08-15 03:03:10', '2025-08-15 03:03:19'),
(213, 'App\\Models\\User', 1, 'app_token', 'cf9cc50fc0ffb8c9c664d59a96b9d6b78947014cfc3a5c9486c90ecb4bf167f0', '[\"*\"]', '2025-08-15 03:35:07', NULL, '2025-08-15 03:30:10', '2025-08-15 03:35:07'),
(214, 'App\\Models\\User', 1, 'app_token', '38cbec3ea4c88fe184fcac803bd5e6cbc6d6e29f632340023d1b6858e5bd457c', '[\"*\"]', '2025-08-15 04:59:33', NULL, '2025-08-15 04:59:24', '2025-08-15 04:59:33'),
(215, 'App\\Models\\User', 1, 'app_token', '3324d5693b2ba141df0c1e7ca92866f95deb07f6f84993954cf953e971d21726', '[\"*\"]', NULL, NULL, '2025-08-15 04:59:26', '2025-08-15 04:59:26'),
(216, 'App\\Models\\User', 13, 'app_token', '51e6e1911f3f3ef596cbb24242733aa4610f4eb56d21f1f583986161c7d8b077', '[\"*\"]', '2025-08-15 05:18:36', NULL, '2025-08-15 05:07:22', '2025-08-15 05:18:36'),
(217, 'App\\Models\\User', 1, 'app_token', '91509a914cf466de5e47070abf65617670b40d2c6461126c9739533f4452afa8', '[\"*\"]', '2025-08-15 06:25:35', NULL, '2025-08-15 06:25:27', '2025-08-15 06:25:35');

-- --------------------------------------------------------

--
-- Структура таблицы `portfolio_works`
--

CREATE TABLE `portfolio_works` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `specialization` varchar(255) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `is_featured` tinyint(1) NOT NULL DEFAULT 0,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `portfolio_works`
--

INSERT INTO `portfolio_works` (`id`, `user_id`, `title`, `description`, `specialization`, `url`, `image`, `is_featured`, `sort_order`, `created_at`, `updated_at`) VALUES
(4, 1, 'qqqqqqq', 'необязательно', 'business_card_design', 'https://www.fl.ru/users/radyjnuy/portfolio/', NULL, 0, 4, '2025-08-13 10:34:49', '2025-08-13 10:34:49'),
(5, 1, 'название', 'описание', 'graphic_design', 'https://www.fl.ru/users/radyjnuy/portfolio/', NULL, 0, 5, '2025-08-13 10:47:15', '2025-08-13 10:47:15'),
(6, 2, 'История для соц сетей', 'Динамичная история для соц сетей', 'video', NULL, NULL, 0, 1, '2025-08-14 05:39:57', '2025-08-14 05:39:57'),
(7, 2, 'Дизайн карточки', 'Карточка для Озона', 'mp_card_design', NULL, NULL, 0, 2, '2025-08-14 05:41:46', '2025-08-14 05:41:46');

-- --------------------------------------------------------

--
-- Структура таблицы `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `reviewer_id` bigint(20) UNSIGNED NOT NULL,
  `reviewed_id` bigint(20) UNSIGNED NOT NULL,
  `rating` int(11) NOT NULL COMMENT 'Оценка от 1 до 5',
  `text` text NOT NULL COMMENT 'Текст отзыва',
  `is_public` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Публичный ли отзыв',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `reviews`
--

INSERT INTO `reviews` (`id`, `order_id`, `reviewer_id`, `reviewed_id`, `rating`, `text`, `is_public`, `created_at`, `updated_at`) VALUES
(23, 178, 2, 1, 5, 'Супер, рекомендую', 1, '2025-08-14 05:27:19', '2025-08-14 05:27:19'),
(24, 178, 1, 2, 5, 'Хороший исполнитель, буду обращаться', 1, '2025-08-14 05:28:50', '2025-08-14 05:28:50'),
(25, 183, 2, 1, 5, 'Рекомендую, быстро', 1, '2025-08-14 06:25:35', '2025-08-14 06:25:35');

-- --------------------------------------------------------

--
-- Структура таблицы `services`
--

CREATE TABLE `services` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `work_type_id` bigint(20) UNSIGNED NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `services`
--

INSERT INTO `services` (`id`, `name`, `description`, `work_type_id`, `is_active`, `created_at`, `updated_at`) VALUES
(9, 'Обложка для МП', 'Создание обложки', 6, 1, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(10, '1 слайд в карточке', 'Один слайд презентации', 6, 1, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(11, 'Односторонняя визитка', 'Дизайн односторонней визитки', 7, 1, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(12, 'Двухсторонняя визитка', 'Дизайн двухсторонней визитки', 7, 1, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(14, 'Видео с анимацией', 'Создание видео с анимацией', 8, 1, '2025-08-14 01:51:10', '2025-08-14 01:51:10');

-- --------------------------------------------------------

--
-- Структура таблицы `service_prices`
--

CREATE TABLE `service_prices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `service_id` bigint(20) UNSIGNED NOT NULL,
  `tariff_id` bigint(20) UNSIGNED NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `service_prices`
--

INSERT INTO `service_prices` (`id`, `service_id`, `tariff_id`, `price`, `created_at`, `updated_at`) VALUES
(37, 9, 7, 600.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(38, 9, 8, 1300.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(39, 9, 9, 2000.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(40, 10, 7, 400.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(41, 10, 8, 1100.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(42, 10, 9, 1750.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(43, 11, 7, 800.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(44, 11, 8, 1250.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(45, 11, 9, 3000.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(46, 12, 7, 1300.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(47, 12, 8, 1750.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(48, 12, 9, 4500.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(49, 13, 7, 1500.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(50, 13, 8, 3000.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(51, 13, 9, 4500.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(52, 14, 7, 2000.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(53, 14, 8, 4000.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(54, 14, 9, 6000.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(55, 15, 7, 3000.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(56, 15, 8, 5000.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(57, 15, 9, 8000.00, '2025-08-14 01:51:10', '2025-08-14 01:51:10');

-- --------------------------------------------------------

--
-- Структура таблицы `sessions`
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
-- Дамп данных таблицы `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('1XgnhxfkoF41uK93FhMoTUJsFTKFC7h2TVvl8fnh', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 YaBrowser/25.6.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVGs4clV4S2ZrNkc3M1p4ZDdCN1dsVW1TUVNUbzJvZWZhTkdLTUd2dSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly9tZWFuLXNuYWtlcy1kb3VibGUubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755270397),
('7B0twMscfZjyqD6UmbmMAcRUSs4qSYWZ9dY4szU6', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36 Edg/139.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMUZkWEcwWkExVlo1bFh0eHlZQjNGT1dzU3gxYjhsV0FRTDhOeWRWNiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly90aW55LWNsb3ducy1yZXRpcmUubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755252177),
('aPIeSkmV0dOYeMKQorI09G6SFss1UZNxqiKMXDOd', NULL, '127.0.0.1', 'TelegramBot (like TwitterBot)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSGhFeTUwZnN0Rnpid3JCRjVIYmdSYkFNNWVKUUxKVWhtQWFNMjl0TCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly90aW55LWNsb3ducy1yZXRpcmUubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755252236),
('g6QmPrZRvrQaJP0zdPkHU9MLU9JqJj37VPEvdvYQ', NULL, '127.0.0.1', 'Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQmg4VzdmRThXZDVycXJhOHVyZm53QVpSYzgxbW1LSUlZU0ZZV0hNeCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly9tZWFuLXNuYWtlcy1kb3VibGUubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755270410),
('GW3TNsQfkCy8fOZZvvIwjgdY9P5pH5X7iDpLacD8', NULL, '127.0.0.1', 'TelegramBot (like TwitterBot)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR242SUUwQ2M4cXhYektIQTRYTUU1NVpEeDlBdmtaV3puZmVOdDNORSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly9tZWFuLXNuYWtlcy1kb3VibGUubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755270435),
('IxXzCDTsYu5Vvou50NBMUziLKu08dARHVLyQzLMT', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36 Edg/139.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYUM2NjVDMVV6NGZVT1d6U25Fa3lwbmhZU3RWNTN6OHBHbnlUbDV5MCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHA6Ly9jcmF6eS1nYXJsaWNzLXNoYXZlLmxvY2EubHQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1755264491),
('Jxcvjlim59YxuPl3sYAjbqRxVrkGKXdeP7doWieX', NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWGRSYXlRQUtnaUI3ckJZMW9QZjh0OEJiV1hVVUtKV1JXVTlqVWw1NiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9kaXJ0eS1iYXRzLWxvc2UubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755243092),
('lcNlrCjOXQ5VYkVp9LCkyxEEPUzMHwStkuiHVQVx', NULL, '127.0.0.1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieWN2MmlLS05sWVB3aHNtZm5wRU42RTdLVlM5cEc0ZjFjSWJwSk5JayI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9raW5kLWhlYWRzLWdyaW4ubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755259153),
('lf9yKlqoRBkZHGeU7P0yzhZyh6BO6cGMFIr1oAk7', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36 Edg/139.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib3dUQjdnNlN1OTlKWU1ibk9aUWRzc0dpT3FNVDYyQzYySXlDaEcxSyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9kaXJ0eS1iYXRzLWxvc2UubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755241408),
('lLJacKKsIqS51rqqj28lHak7MhXob8X1HSFXbroh', NULL, '127.0.0.1', 'Mozilla/5.0 (Linux; Android 16; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.179 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib1laZE9jU3RVUDFUT1hwRU80QzI0Nk9kbHNpTmtyWmx5WTI2S29VTyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly9tZWFuLXNuYWtlcy1kb3VibGUubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755276063),
('mQxl9XzituJETUQoPz3JbOJ7VNo2i0WGoZ76Huks', NULL, '127.0.0.1', 'TelegramBot (like TwitterBot)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRmhpOXRtRXFHTjhvOTdoVGw2NEF1S3l0UVpQT01yQzBPOU9kS0c3QyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDA6Imh0dHA6Ly9kaXJ0eS1iYXRzLWxvc2UubG9jYS5sdC9kYXNoYm9hcmQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1755241699),
('PJCGCFlB1JWimrozswZpOAU9JMv5968FCFnq0wDA', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 YaBrowser/25.6.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib3VEZGU3WUZiUVZFS0JPN2pKVUd3bkNPQUkzcmkyZXBVcnZLR3pXTSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHA6Ly9jcmF6eS1nYXJsaWNzLXNoYXZlLmxvY2EubHQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1755264302),
('rdC6BGi6roq7ysjvRhN95B5Vo0ElWKk0Ls14e4QK', NULL, '127.0.0.1', 'Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN2UyMGJWVDVOMjEwQmxpenNzMDFHY0E1Q2k4QlE4WVN0RDh4VU5LbyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzQ6Imh0dHA6Ly9jcmF6eS1nYXJsaWNzLXNoYXZlLmxvY2EubHQiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1755264281),
('RO27EPNbXuEzlzicAFvz0a90KdHB07UyvDQ1wj0S', NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWXF1OUtteEZQUzhxUk4zOGMxUE5ISEpRcVA1aUVGdzhOVGJ0M1B3TyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NTc6Imh0dHA6Ly9tZXRhbC1tb29ucy1zdGFyZS5sb2NhLmx0L3NyYy9hc3NldHMvcGVyZm9ybWVyLnBuZyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755239470),
('SCmpxenV5XC3et8Ht4x9Kk7Zjh7WYZ7dv8CCYrdd', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 YaBrowser/25.6.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQzBQVDFZR3ZDamJrUG5Yb0FDZnJKWWxVeEJDN1BEUG1teWFyRUhVUSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9kaXJ0eS1iYXRzLWxvc2UubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755248593),
('SzqqJU58xOSJ3wKD9IwT6av5Rs5PbbTgPXD8qVo3', NULL, '127.0.0.1', 'TelegramBot (like TwitterBot)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidGxwNFl4UEFEM1Ayb2xmczRzWUFvNFl3dTVhRnlaMkFpbzNCNXVDcSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9kaXJ0eS1iYXRzLWxvc2UubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755243017),
('wS3LWkBLu5EWM9zjoLsq1LqvmwbtosYFaB6zrXbX', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 YaBrowser/25.6.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQnhLUDhBVVBrcnMybWNGYktKNUJZMkkyMzlEOVRNSkhDdUV3WXpnYyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHA6Ly90aW55LWNsb3ducy1yZXRpcmUubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755252128),
('xBnZsU8GJG63HpZMLhYbseyG1zVXw0ZaoB8dW5Gi', NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQzVXeHF5bllwTmFwMm5xVURoUW9LZzNZcExObVA3ZHJ0WjdoNk1IQiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9raW5kLWhlYWRzLWdyaW4ubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755259545),
('Xob4iWlH0hVhsXRH3jxhK7jysFwLOfbf88DKIG7C', NULL, '127.0.0.1', 'TelegramBot (like TwitterBot)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYTlNRVpmSEFUcEd4SmNhWURJVVp1cUpQcGJVMGVZUTk2RFNtQWlnbiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9raW5kLWhlYWRzLWdyaW4ubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755259484),
('zXHn5sGCcEjUesxFUekClSR8QQYgAnkdr3Gv22jH', NULL, '127.0.0.1', 'Mozilla/5.0 (Linux; Android 16; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.179 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYWR2V0NhaWZ4dWlOcXA4ZlpGZVY2YkpHMVpWWEVISUFPM1BXQ2p3OCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly9raW5kLWhlYWRzLWdyaW4ubG9jYS5sdCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755259245);

-- --------------------------------------------------------

--
-- Структура таблицы `tariffs`
--

CREATE TABLE `tariffs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `base_price` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `tariffs`
--

INSERT INTO `tariffs` (`id`, `name`, `base_price`, `description`, `is_active`, `created_at`, `updated_at`) VALUES
(7, 'Базовый тариф', 600.00, 'Базовый набор услуг', 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(8, 'Комфорт тариф', 1300.00, 'Расширенный набор услуг', 1, '2025-08-14 01:51:10', '2025-08-14 01:51:10'),
(9, 'Рич тариф', 2000.00, 'Премиум набор услуг', 1, '2025-08-14 01:51:10', '2025-08-14 01:51:10');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `specialization` varchar(255) DEFAULT NULL,
  `specializations` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`specializations`)),
  `executor_description` text DEFAULT NULL,
  `customer_description` text DEFAULT NULL,
  `rating` decimal(3,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `surname`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`, `avatar`, `specialization`, `specializations`, `executor_description`, `customer_description`, `rating`) VALUES
(1, 'Станислав', 'Пузынин', '123@123', NULL, '$2y$12$cNM8YiPntx3jpw2JBEAuy.ZEgHwy.xgq2TJfO/4DGNtoetmJYRfDS', NULL, '2025-07-15 22:05:50', '2025-08-14 06:25:35', NULL, NULL, '[\"mp_card_design\",\"business_card_design\",\"video\"]', 'Выполняю дизайн и видео', 'Заказываю все подряд', 5.00),
(2, 'тестовый', 'тест', '12@12', NULL, '$2y$12$p5nRp6K5MxYUjIzfZY/F7e1QSK6WP1.XcSyQXlyQV6G6kwr4w1Yde', NULL, '2025-07-16 09:09:22', '2025-08-14 05:28:50', NULL, 'video_editing', '[\"video\",\"mp_card_design\",\"business_card_design\"]', 'исполнитель крутой', 'тестовый заказчик', 5.00),
(3, 'Второй', 'Тестовый', 'stas.puzy@gmail.com', NULL, '$2y$12$YdNIRfjUEdnyKrwNovVWsOk1YcZ8iDpn0XtjaSbqMfmUu9Q1nhS8i', NULL, '2025-07-16 09:21:10', '2025-08-11 09:28:18', NULL, NULL, '[\"mp_card_design\"]', NULL, NULL, 5.00),
(4, 'Иван', 'Иванов', '1234@1234', NULL, '$2y$12$W5GDZkqa24ODXIvyMv/q4.qAZxiDgJejv7J.BVnUJcMko2fJvkv3u', NULL, '2025-08-14 05:36:04', '2025-08-14 05:36:04', NULL, NULL, NULL, NULL, NULL, 0.00),
(5, 'Станислав', 'Иванов', '444@444', NULL, '$2y$12$d8QFOBUEZc9zV3JWXcvr7OL2Ktc4ny0cD5V4P4j894ChCX7W/yxhW', NULL, '2025-08-14 21:29:32', '2025-08-14 21:29:32', NULL, NULL, NULL, NULL, NULL, 0.00),
(6, 'Елизавета', 'Попова', 'elizaveta.ps@mail.ru', NULL, '$2y$12$9XnOpiboGRSY9AvdQmWju.k2xk.u5xSnwtIvVPTSJsBGJiO3FjJDC', NULL, '2025-08-14 21:33:33', '2025-08-14 21:33:33', NULL, NULL, NULL, NULL, NULL, 0.00),
(7, 'Иван', 'Иванов', 'ivanov@gmail.com', NULL, '$2y$12$Df9W4W9.AvTO2A9O58208.EqCK4vQTpJPl5hQFH.REXyRpVP0Yp.C', NULL, '2025-08-14 21:55:06', '2025-08-14 21:55:06', NULL, NULL, NULL, NULL, NULL, 0.00),
(8, 'Александр', 'Пузынин', 'puzynin7@gmail.com', NULL, '$2y$12$1vW5gfa4x1HdhHKj0xymNuG4aGO4oQ4gLH13QvEHQZPFzIl0vL2Zu', NULL, '2025-08-14 21:55:46', '2025-08-14 21:55:46', NULL, NULL, NULL, NULL, NULL, 0.00),
(9, 'test', 'test', '321@321', NULL, '$2y$12$NCE8Wc8Kb6do.h5uTypByefIVJDJ9iX6EXjnN5Q/G0u77F.NdCzOa', NULL, '2025-08-14 22:17:50', '2025-08-14 22:17:50', NULL, NULL, NULL, NULL, NULL, 0.00),
(10, 'Иван', 'Иванов', 'ivanovivan@mail.ru', NULL, '$2y$12$2bbtoOMzR.9pGmhZW6c4UOUPQkoiyWQIEWA4E4WyuWhX7XZnlN8t2', NULL, '2025-08-14 23:25:44', '2025-08-14 23:25:44', NULL, NULL, NULL, NULL, NULL, 0.00),
(11, 'Анна', 'Беспоясова', 'anna.bespoyasova@mail.ru', NULL, '$2y$12$nUacKYggb4oL.YjXFvhuaOOZNVp8SUSi3pv7GPzLYc5rKvCV9DgIK', NULL, '2025-08-15 00:32:21', '2025-08-15 00:32:21', NULL, NULL, NULL, NULL, NULL, 0.00),
(12, 'Софья', 'Горбачева', 'koshkinasg02@gmail.com', NULL, '$2y$12$/uhREXaSa4p2FmU0lFRkUuakld20FJW7A32O9aei.5A2WIDlcDE5e', NULL, '2025-08-15 02:07:05', '2025-08-15 02:08:14', NULL, NULL, '[\"mp_card_design\"]', 'Графический дизайнер, работаю с векторной графикой', NULL, 0.00),
(13, 'Арина', 'Кондраткова', 'Kondratkova.Arina@yandex.ru', NULL, '$2y$12$5NScVGy4CBhc7ZopRcQ2u.5cLXT2eGvZlxAUWl9s4d7x7KSvlLADO', NULL, '2025-08-15 05:07:22', '2025-08-15 05:07:22', NULL, NULL, NULL, NULL, NULL, 0.00);

-- --------------------------------------------------------

--
-- Структура таблицы `work_types`
--

CREATE TABLE `work_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `average_price` decimal(10,2) DEFAULT NULL,
  `average_time` varchar(255) DEFAULT NULL,
  `is_custom` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `work_types`
--

INSERT INTO `work_types` (`id`, `name`, `description`, `average_price`, `average_time`, `is_custom`, `created_at`, `updated_at`, `image`) VALUES
(6, 'Дизайн карточки для МП', 'Создание привлекательных и продающих карточек для маркетплейсов', 800.00, '2 дня', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09', ''),
(7, 'Дизайн визитки', 'Создание профессиональных визиток для бизнеса', 1500.00, '3 дня', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09', ''),
(8, 'Видео', 'Создание и монтаж видеороликов под разные задачи', 3000.00, '3 дня', 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09', '');

-- --------------------------------------------------------

--
-- Структура таблицы `work_type_attribute_type`
--

CREATE TABLE `work_type_attribute_type` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `work_type_id` bigint(20) UNSIGNED NOT NULL,
  `attribute_type_id` bigint(20) UNSIGNED NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT 1,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `work_type_attribute_type`
--

INSERT INTO `work_type_attribute_type` (`id`, `work_type_id`, `attribute_type_id`, `required`, `sort_order`, `created_at`, `updated_at`) VALUES
(51, 6, 51, 1, 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(52, 6, 52, 1, 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(53, 6, 53, 1, 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(54, 6, 54, 1, 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(55, 6, 55, 1, 4, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(56, 6, 56, 1, 5, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(57, 7, 57, 1, 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(58, 7, 58, 1, 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(59, 7, 59, 1, 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(60, 7, 60, 1, 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(61, 7, 61, 1, 4, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(62, 7, 62, 1, 5, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(63, 7, 63, 1, 6, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(64, 7, 64, 1, 7, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(65, 7, 65, 1, 8, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(66, 7, 66, 1, 9, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(67, 7, 67, 1, 10, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(68, 7, 68, 1, 11, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(69, 7, 69, 1, 12, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(70, 7, 70, 1, 13, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(71, 7, 71, 1, 14, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(72, 7, 72, 1, 15, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(73, 7, 73, 1, 16, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(74, 8, 74, 1, 0, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(75, 8, 75, 1, 1, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(76, 8, 76, 1, 2, '2025-08-14 01:51:09', '2025-08-14 01:51:09'),
(77, 8, 77, 1, 3, '2025-08-14 01:51:09', '2025-08-14 01:51:09');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Индексы таблицы `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Индексы таблицы `chats`
--
ALTER TABLE `chats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chats_order_id_foreign` (`order_id`),
  ADD KEY `chats_order_idx` (`order_id`),
  ADD KEY `chats_category_idx` (`category`),
  ADD KEY `chats_updated_idx` (`updated_at`);

--
-- Индексы таблицы `chat_participants`
--
ALTER TABLE `chat_participants`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `chat_participants_chat_id_user_id_unique` (`chat_id`,`user_id`),
  ADD KEY `chat_participants_user_id_foreign` (`user_id`),
  ADD KEY `chat_participants_chat_idx` (`chat_id`),
  ADD KEY `chat_participants_user_idx` (`user_id`),
  ADD KEY `chat_participants_read_idx` (`chat_id`,`last_read_at`);

--
-- Индексы таблицы `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Индексы таблицы `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Индексы таблицы `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `messages_chat_id_foreign` (`chat_id`),
  ADD KEY `messages_user_id_foreign` (`user_id`),
  ADD KEY `messages_chat_created_idx` (`chat_id`,`created_at`),
  ADD KEY `messages_chat_user_idx` (`chat_id`,`user_id`),
  ADD KEY `messages_chat_read_idx` (`chat_id`,`read_at`);

--
-- Индексы таблицы `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_user_id_foreign` (`user_id`),
  ADD KEY `orders_work_type_id_foreign` (`work_type_id`),
  ADD KEY `orders_executor_id_foreign` (`executor_id`),
  ADD KEY `orders_selected_tariff_id_foreign` (`selected_tariff_id`);

--
-- Индексы таблицы `order_attributes`
--
ALTER TABLE `order_attributes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_attributes_order_id_foreign` (`order_id`),
  ADD KEY `order_attributes_attribute_type_id_foreign` (`attribute_type_id`),
  ADD KEY `order_attributes_value_id_foreign` (`value_id`);

--
-- Индексы таблицы `order_attribute_types`
--
ALTER TABLE `order_attribute_types`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `order_attribute_values`
--
ALTER TABLE `order_attribute_values`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_attribute_values_attribute_type_id_foreign` (`attribute_type_id`);

--
-- Индексы таблицы `order_materials`
--
ALTER TABLE `order_materials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_materials_order_id_foreign` (`order_id`);

--
-- Индексы таблицы `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Индексы таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Индексы таблицы `portfolio_works`
--
ALTER TABLE `portfolio_works`
  ADD PRIMARY KEY (`id`),
  ADD KEY `portfolio_works_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reviews_order_id_reviewer_id_unique` (`order_id`,`reviewer_id`),
  ADD KEY `reviews_reviewer_id_foreign` (`reviewer_id`),
  ADD KEY `reviews_reviewed_id_is_public_index` (`reviewed_id`,`is_public`),
  ADD KEY `reviews_order_id_index` (`order_id`);

--
-- Индексы таблицы `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `services_work_type_id_foreign` (`work_type_id`);

--
-- Индексы таблицы `service_prices`
--
ALTER TABLE `service_prices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `service_prices_service_id_tariff_id_unique` (`service_id`,`tariff_id`),
  ADD KEY `service_prices_tariff_id_foreign` (`tariff_id`);

--
-- Индексы таблицы `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Индексы таблицы `tariffs`
--
ALTER TABLE `tariffs`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Индексы таблицы `work_types`
--
ALTER TABLE `work_types`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `work_type_attribute_type`
--
ALTER TABLE `work_type_attribute_type`
  ADD PRIMARY KEY (`id`),
  ADD KEY `work_type_attribute_type_work_type_id_foreign` (`work_type_id`),
  ADD KEY `work_type_attribute_type_attribute_type_id_foreign` (`attribute_type_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `chats`
--
ALTER TABLE `chats`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT для таблицы `chat_participants`
--
ALTER TABLE `chat_participants`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- AUTO_INCREMENT для таблицы `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `messages`
--
ALTER TABLE `messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=287;

--
-- AUTO_INCREMENT для таблицы `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=191;

--
-- AUTO_INCREMENT для таблицы `order_attributes`
--
ALTER TABLE `order_attributes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT для таблицы `order_attribute_types`
--
ALTER TABLE `order_attribute_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT для таблицы `order_attribute_values`
--
ALTER TABLE `order_attribute_values`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- AUTO_INCREMENT для таблицы `order_materials`
--
ALTER TABLE `order_materials`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT для таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=218;

--
-- AUTO_INCREMENT для таблицы `portfolio_works`
--
ALTER TABLE `portfolio_works`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT для таблицы `services`
--
ALTER TABLE `services`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT для таблицы `service_prices`
--
ALTER TABLE `service_prices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT для таблицы `tariffs`
--
ALTER TABLE `tariffs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `work_types`
--
ALTER TABLE `work_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `work_type_attribute_type`
--
ALTER TABLE `work_type_attribute_type`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `chats`
--
ALTER TABLE `chats`
  ADD CONSTRAINT `chats_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `chat_participants`
--
ALTER TABLE `chat_participants`
  ADD CONSTRAINT `chat_participants_chat_id_foreign` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chat_participants_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_chat_id_foreign` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `order_attributes`
--
ALTER TABLE `order_attributes`
  ADD CONSTRAINT `order_attributes_attribute_type_id_foreign` FOREIGN KEY (`attribute_type_id`) REFERENCES `order_attribute_types` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_attributes_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_attributes_value_id_foreign` FOREIGN KEY (`value_id`) REFERENCES `order_attribute_values` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `portfolio_works`
--
ALTER TABLE `portfolio_works`
  ADD CONSTRAINT `portfolio_works_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_reviewed_id_foreign` FOREIGN KEY (`reviewed_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_reviewer_id_foreign` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
