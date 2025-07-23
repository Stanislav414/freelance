-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Июл 16 2025 г., 20:24
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
(17, '2025_07_16_171242_add_image_to_work_types_table', 7);

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `executor_id` bigint(20) UNSIGNED DEFAULT NULL,
  `work_type_id` bigint(20) UNSIGNED DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `budget` decimal(10,2) DEFAULT NULL,
  `deadline` date DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `executor_id`, `work_type_id`, `title`, `description`, `budget`, `deadline`, `status`, `created_at`, `updated_at`) VALUES
(26, 1, 2, 22, 'Видео до 30 секунд', 'Короткий видеоролик до 30 секунд', 1113.00, '2025-08-08', 'in_progress', '2025-07-16 10:42:14', '2025-07-16 10:43:54'),
(27, 1, 2, 23, 'Цветокоррекция фото', 'Обработка и цветокоррекция фотографий', 1000.00, '2025-07-23', 'in_progress', '2025-07-16 10:42:44', '2025-07-16 10:46:26'),
(28, 1, NULL, 24, 'Оформление сторис', 'Дизайн и оформление сторис для соцсетей', 2000.00, '2025-07-29', 'open', '2025-07-16 10:43:11', '2025-07-16 10:43:11'),
(29, 1, NULL, 25, 'Инфографика для МП', 'Понятная и продающая инфографика для карточек товаров', 1000.00, '2025-07-25', 'open', '2025-07-16 10:43:43', '2025-07-16 10:43:43'),
(30, 2, NULL, 23, 'Цветокоррекция фото', 'Обработка фотографий', 500.00, '2025-08-10', 'open', '2025-07-16 10:49:56', '2025-07-16 10:49:56');

-- --------------------------------------------------------

--
-- Структура таблицы `order_attributes`
--

CREATE TABLE `order_attributes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `attribute_type_id` bigint(20) UNSIGNED NOT NULL,
  `value_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `order_attributes`
--

INSERT INTO `order_attributes` (`id`, `order_id`, `attribute_type_id`, `value_id`, `created_at`, `updated_at`) VALUES
(69, 26, 57, 229, '2025-07-16 10:42:14', '2025-07-16 10:42:14'),
(70, 26, 58, 234, '2025-07-16 10:42:14', '2025-07-16 10:42:14'),
(71, 26, 59, 238, '2025-07-16 10:42:14', '2025-07-16 10:42:14'),
(72, 26, 60, 244, '2025-07-16 10:42:14', '2025-07-16 10:42:14'),
(73, 26, 61, 253, '2025-07-16 10:42:14', '2025-07-16 10:42:14'),
(74, 26, 62, 249, '2025-07-16 10:42:14', '2025-07-16 10:42:14'),
(75, 27, 63, 257, '2025-07-16 10:42:44', '2025-07-16 10:42:44'),
(76, 28, 59, 239, '2025-07-16 10:43:11', '2025-07-16 10:43:11'),
(77, 28, 60, 244, '2025-07-16 10:43:11', '2025-07-16 10:43:11'),
(78, 28, 62, 250, '2025-07-16 10:43:11', '2025-07-16 10:43:11'),
(79, 28, 63, 256, '2025-07-16 10:43:11', '2025-07-16 10:43:11'),
(80, 28, 64, 259, '2025-07-16 10:43:11', '2025-07-16 10:43:11'),
(81, 29, 65, 264, '2025-07-16 10:43:43', '2025-07-16 10:43:43'),
(82, 29, 60, 246, '2025-07-16 10:43:43', '2025-07-16 10:43:43'),
(83, 29, 62, 250, '2025-07-16 10:43:43', '2025-07-16 10:43:43'),
(84, 29, 63, 256, '2025-07-16 10:43:43', '2025-07-16 10:43:43'),
(85, 29, 64, 258, '2025-07-16 10:43:43', '2025-07-16 10:43:43'),
(86, 30, 63, 257, '2025-07-16 10:49:56', '2025-07-16 10:49:56');

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
(57, 'type', 'Тип ролика', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(58, 'goal', 'Цель', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(59, 'platform', 'Платформа', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(60, 'format', 'Формат', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(61, 'sound', 'Звук', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(62, 'orientation', 'Ориентация', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(63, 'color_profile', 'Цветовой профиль', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(64, 'animation', 'Анимация', 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(65, 'marketplace', 'Платформа (маркетплейс)', 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17');

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
(228, 57, 'Рекламный', 'Рекламный', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(229, 57, 'Блог', 'Блог', 1, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(230, 57, 'Презентация', 'Презентация', 2, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(231, 57, 'Обзор', 'Обзор', 3, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(232, 57, 'Другое', 'Другое', 4, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(233, 58, 'Презентация товара', 'Презентация товара', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(234, 58, 'Продвижение', 'Продвижение', 1, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(235, 58, 'Обучение', 'Обучение', 2, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(236, 58, 'Развлечение', 'Развлечение', 3, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(237, 58, 'Другое', 'Другое', 4, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(238, 59, 'instagram', 'Instagram', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(239, 59, 'tiktok', 'TikTok', 1, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(240, 59, 'youtube', 'YouTube', 2, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(241, 59, 'vk', 'VK', 3, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(242, 59, 'Другое', 'Другое', 4, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(243, 60, '1080p (full hd)', '1080p (Full HD)', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(244, 60, '4k', '4K', 1, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(245, 60, '720p', '720p', 2, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(246, 60, 'jpeg', 'JPEG', 3, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(247, 60, 'png', 'PNG', 4, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(248, 60, 'webp', 'WEBP', 5, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(249, 62, 'Горизонтальная', 'Горизонтальная', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16'),
(250, 62, 'Вертикальная', 'Вертикальная', 1, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(251, 62, 'Квадратная', 'Квадратная', 2, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(252, 61, 'Фоновая музыка', 'Фоновая музыка', 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(253, 61, 'Без звука', 'Без звука', 1, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(254, 61, 'Оригинальный звук', 'Оригинальный звук', 2, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(255, 63, 'srgb', 'sRGB', 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(256, 63, 'adobergb', 'AdobeRGB', 1, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(257, 63, 'prophotorgb', 'ProPhotoRGB', 2, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(258, 64, 'Нет', 'Нет', 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(259, 64, 'Простая', 'Простая', 1, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(260, 64, 'Сложная', 'Сложная', 2, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(261, 65, 'ozon', 'Ozon', 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(262, 65, 'wildberries', 'Wildberries', 1, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(263, 65, 'Яндекс.Маркет', 'Яндекс.Маркет', 2, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(264, 65, 'aliexpress', 'AliExpress', 3, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(265, 65, 'Другое', 'Другое', 4, '2025-07-16 10:38:17', '2025-07-16 10:38:17');

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
(1, 16, 'йййй', 'ццццц', 'уууу', '2025-07-16 08:19:06', '2025-07-16 08:19:06'),
(2, 17, 'wish', '3d', NULL, '2025-07-16 08:25:20', '2025-07-16 08:25:20'),
(3, 17, 'wish', 'vfx', NULL, '2025-07-16 08:25:20', '2025-07-16 08:25:20'),
(4, 17, 'wish', 'animation', NULL, '2025-07-16 08:25:20', '2025-07-16 08:25:20'),
(5, 17, 'wish', 'sound_fx', NULL, '2025-07-16 08:25:20', '2025-07-16 08:25:20'),
(6, 17, 'wish', 'subtitles', NULL, '2025-07-16 08:25:20', '2025-07-16 08:25:20');

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
(13, 'App\\Models\\User', 1, 'app_token', '3b3cb2145ee97293d78009dddf2fca00ad9132070d759d8bfeab2ff1b7e7a03c', '[\"*\"]', '2025-07-16 11:03:18', NULL, '2025-07-16 10:54:51', '2025-07-16 11:03:18');

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
('IGHI9HnMNGi4c46hcD3OyAaWquMLkqqd0xhU0e7E', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 YaBrowser/25.6.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTlB6SFRjTU1UTWZvR2RFdzFydWJsVFF1RWdidmVFWHNOZUhpS2M4diI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1752641531),
('RCPnygF9V3cS4niJRK1jTeBzjmcyq3l0d0o98hEe', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicktMc0hmRUphMUVCNVZRb1VYcUpVWWt3ZDJKamJQeFp6T3h0cU9qdiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1752675239);

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
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `surname`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Станислав', 'Пузынин', '123@123', NULL, '$2y$12$cNM8YiPntx3jpw2JBEAuy.ZEgHwy.xgq2TJfO/4DGNtoetmJYRfDS', NULL, '2025-07-15 22:05:50', '2025-07-15 22:05:50'),
(2, 'тестовый', 'тест', '12@12', NULL, '$2y$12$p5nRp6K5MxYUjIzfZY/F7e1QSK6WP1.XcSyQXlyQV6G6kwr4w1Yde', NULL, '2025-07-16 09:09:22', '2025-07-16 09:09:22'),
(3, 'йцу', 'уцй', 'stas.puzy@gmail.com', NULL, '$2y$12$YdNIRfjUEdnyKrwNovVWsOk1YcZ8iDpn0XtjaSbqMfmUu9Q1nhS8i', NULL, '2025-07-16 09:21:10', '2025-07-16 09:21:10');

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
(22, 'Видео до 30 секунд', 'Короткий видеоролик до 30 секунд', 2000.00, '2 дня', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16', 'video.png'),
(23, 'Цветокоррекция фото', 'Обработка и цветокоррекция фотографий', 500.00, '1 день', 0, '2025-07-16 10:38:16', '2025-07-16 10:38:16', 'цветокор.png'),
(24, 'Оформление сторис', 'Дизайн и оформление сторис для соцсетей', 1000.00, '1 день', 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17', 'story.png'),
(25, 'Инфографика для МП', 'Понятная и продающая инфографика для карточек товаров', 400.00, '3 часа', 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17', 'infographic.png');

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
(85, 22, 57, 1, 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(86, 22, 58, 1, 1, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(87, 22, 59, 1, 2, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(88, 22, 60, 1, 3, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(89, 22, 61, 1, 4, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(90, 22, 62, 1, 5, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(91, 23, 63, 1, 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(92, 24, 59, 1, 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(93, 24, 60, 1, 1, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(94, 24, 62, 1, 2, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(95, 24, 63, 1, 3, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(96, 24, 64, 1, 4, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(97, 25, 65, 1, 0, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(98, 25, 60, 1, 1, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(99, 25, 62, 1, 2, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(100, 25, 63, 1, 3, '2025-07-16 10:38:17', '2025-07-16 10:38:17'),
(101, 25, 64, 1, 4, '2025-07-16 10:38:17', '2025-07-16 10:38:17');

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
  ADD KEY `orders_executor_id_foreign` (`executor_id`);

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
-- Индексы таблицы `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

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
-- AUTO_INCREMENT для таблицы `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT для таблицы `order_attributes`
--
ALTER TABLE `order_attributes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT для таблицы `order_attribute_types`
--
ALTER TABLE `order_attribute_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT для таблицы `order_attribute_values`
--
ALTER TABLE `order_attribute_values`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=266;

--
-- AUTO_INCREMENT для таблицы `order_materials`
--
ALTER TABLE `order_materials`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `work_types`
--
ALTER TABLE `work_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT для таблицы `work_type_attribute_type`
--
ALTER TABLE `work_type_attribute_type`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_executor_id_foreign` FOREIGN KEY (`executor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `order_attributes`
--
ALTER TABLE `order_attributes`
  ADD CONSTRAINT `order_attributes_attribute_type_id_foreign` FOREIGN KEY (`attribute_type_id`) REFERENCES `order_attribute_types` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_attributes_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_attributes_value_id_foreign` FOREIGN KEY (`value_id`) REFERENCES `order_attribute_values` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
