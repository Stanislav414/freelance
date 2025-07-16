-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Июл 16 2025 г., 08:22
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
(14, '2025_07_12_064521_add_surname_to_users_table', 4);

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
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

INSERT INTO `orders` (`id`, `user_id`, `work_type_id`, `title`, `description`, `budget`, `deadline`, `status`, `created_at`, `updated_at`) VALUES
(9, 1, 6, 'Цветокоррекция фото', 'Обработка и цветокоррекция фотографий', 12.00, '2025-07-17', 'open', '2025-07-15 22:28:08', '2025-07-15 22:28:08'),
(10, 1, 9, 'Оформление сторис', 'Дизайн и оформление сторис для соцсетей', 12.00, '2025-07-10', 'open', '2025-07-15 22:32:29', '2025-07-15 22:32:29'),
(11, 1, 8, 'Цветокоррекция фото', 'Обработка и цветокоррекция фотографий', 123.00, '2025-07-24', 'open', '2025-07-15 22:39:33', '2025-07-15 22:39:33'),
(12, 1, 8, 'Цветокоррекция фото', 'Обработка и цветокоррекция фотографий', 12.00, '2025-07-15', 'open', '2025-07-15 22:47:35', '2025-07-15 22:47:35'),
(13, 1, 8, 'Цветокоррекция фото', 'Обработка и цветокоррекция фотографий', 123.00, '2025-07-23', 'open', '2025-07-15 23:00:48', '2025-07-15 23:00:48'),
(14, 1, 7, 'Видео до 30 секунд', 'Короткий видеоролик до 30 секунд', 3333.00, '2025-07-17', 'open', '2025-07-15 23:19:16', '2025-07-15 23:19:16');

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
(20, 10, 24, 91, '2025-07-15 22:32:29', '2025-07-15 22:32:29'),
(21, 10, 25, 98, '2025-07-15 22:32:29', '2025-07-15 22:32:29'),
(22, 10, 27, 104, '2025-07-15 22:32:29', '2025-07-15 22:32:29'),
(23, 10, 28, 109, '2025-07-15 22:32:29', '2025-07-15 22:32:29'),
(24, 10, 29, 111, '2025-07-15 22:32:29', '2025-07-15 22:32:29'),
(25, 11, 28, 110, '2025-07-15 22:39:33', '2025-07-15 22:39:33'),
(26, 12, 28, 108, '2025-07-15 22:47:35', '2025-07-15 22:47:35'),
(27, 13, 28, 108, '2025-07-15 23:00:48', '2025-07-15 23:00:48'),
(28, 14, 22, 81, '2025-07-15 23:19:16', '2025-07-15 23:19:16'),
(29, 14, 23, 87, '2025-07-15 23:19:16', '2025-07-15 23:19:16'),
(30, 14, 24, 92, '2025-07-15 23:19:16', '2025-07-15 23:19:16'),
(31, 14, 25, 98, '2025-07-15 23:19:16', '2025-07-15 23:19:16'),
(32, 14, 26, 106, '2025-07-15 23:19:16', '2025-07-15 23:19:16'),
(33, 14, 27, 104, '2025-07-15 23:19:16', '2025-07-15 23:19:16');

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
(22, 'type', 'Тип ролика', 0, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(23, 'goal', 'Цель', 0, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(24, 'platform', 'Платформа', 0, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(25, 'format', 'Формат', 0, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(26, 'sound', 'Звук', 0, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(27, 'orientation', 'Ориентация', 0, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(28, 'color_profile', 'Цветовой профиль', 0, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(29, 'animation', 'Анимация', 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06');

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
(81, 22, 'Рекламный', 'Рекламный', 0, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(82, 22, 'Блог', 'Блог', 1, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(83, 22, 'Презентация', 'Презентация', 2, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(84, 22, 'Обзор', 'Обзор', 3, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(85, 22, 'Другое', 'Другое', 4, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(86, 23, 'Презентация товара', 'Презентация товара', 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(87, 23, 'Продвижение', 'Продвижение', 1, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(88, 23, 'Обучение', 'Обучение', 2, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(89, 23, 'Развлечение', 'Развлечение', 3, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(90, 23, 'Другое', 'Другое', 4, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(91, 24, 'instagram', 'Instagram', 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(92, 24, 'tiktok', 'TikTok', 1, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(93, 24, 'youtube', 'YouTube', 2, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(94, 24, 'vk', 'VK', 3, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(95, 24, 'Другое', 'Другое', 4, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(96, 25, '1080p (full hd)', '1080p (Full HD)', 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(97, 25, '4k', '4K', 1, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(98, 25, '720p', '720p', 2, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(99, 25, 'jpeg', 'JPEG', 3, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(100, 25, 'png', 'PNG', 4, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(101, 25, 'webp', 'WEBP', 5, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(102, 27, 'Горизонтальная', 'Горизонтальная', 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(103, 27, 'Вертикальная', 'Вертикальная', 1, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(104, 27, 'Квадратная', 'Квадратная', 2, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(105, 26, 'Фоновая музыка', 'Фоновая музыка', 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(106, 26, 'Без звука', 'Без звука', 1, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(107, 26, 'Оригинальный звук', 'Оригинальный звук', 2, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(108, 28, 'srgb', 'sRGB', 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(109, 28, 'adobergb', 'AdobeRGB', 1, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(110, 28, 'prophotorgb', 'ProPhotoRGB', 2, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(111, 29, 'Нет', 'Нет', 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(112, 29, 'Простая', 'Простая', 1, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(113, 29, 'Сложная', 'Сложная', 2, '2025-07-15 22:32:06', '2025-07-15 22:32:06');

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
(2, 'App\\Models\\User', 1, 'app_token', '9772872c6c9cd902598322f2312085ec705504722e1046926f1370c81b591012', '[\"*\"]', '2025-07-15 23:22:39', NULL, '2025-07-15 23:05:21', '2025-07-15 23:22:39');

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
('IGHI9HnMNGi4c46hcD3OyAaWquMLkqqd0xhU0e7E', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 YaBrowser/25.6.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTlB6SFRjTU1UTWZvR2RFdzFydWJsVFF1RWdidmVFWHNOZUhpS2M4diI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1752641531);

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
(1, 'Станислав', 'Пузынин', '123@123', NULL, '$2y$12$cNM8YiPntx3jpw2JBEAuy.ZEgHwy.xgq2TJfO/4DGNtoetmJYRfDS', NULL, '2025-07-15 22:05:50', '2025-07-15 22:05:50');

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
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `work_types`
--

INSERT INTO `work_types` (`id`, `name`, `description`, `average_price`, `average_time`, `is_custom`, `created_at`, `updated_at`) VALUES
(7, 'Видео до 30 секунд', 'Короткий видеоролик до 30 секунд', 2000.00, '2 дня', 0, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(8, 'Цветокоррекция фото', 'Обработка и цветокоррекция фотографий', 500.00, '1 день', 0, '2025-07-15 22:32:05', '2025-07-15 22:32:05'),
(9, 'Оформление сторис', 'Дизайн и оформление сторис для соцсетей', 1000.00, '1 день', 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06');

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
(22, 7, 22, 1, 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(23, 7, 23, 1, 1, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(24, 7, 24, 1, 2, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(25, 7, 25, 1, 3, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(26, 7, 26, 1, 4, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(27, 7, 27, 1, 5, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(28, 8, 28, 1, 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(29, 9, 24, 1, 0, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(30, 9, 25, 1, 1, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(31, 9, 27, 1, 2, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(32, 9, 28, 1, 3, '2025-07-15 22:32:06', '2025-07-15 22:32:06'),
(33, 9, 29, 1, 4, '2025-07-15 22:32:06', '2025-07-15 22:32:06');

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
  ADD KEY `orders_work_type_id_foreign` (`work_type_id`);

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT для таблицы `order_attributes`
--
ALTER TABLE `order_attributes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT для таблицы `order_attribute_types`
--
ALTER TABLE `order_attribute_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT для таблицы `order_attribute_values`
--
ALTER TABLE `order_attribute_values`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- AUTO_INCREMENT для таблицы `order_materials`
--
ALTER TABLE `order_materials`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `work_types`
--
ALTER TABLE `work_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `work_type_attribute_type`
--
ALTER TABLE `work_type_attribute_type`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_work_type_id_foreign` FOREIGN KEY (`work_type_id`) REFERENCES `work_types` (`id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `order_attributes`
--
ALTER TABLE `order_attributes`
  ADD CONSTRAINT `order_attributes_attribute_type_id_foreign` FOREIGN KEY (`attribute_type_id`) REFERENCES `order_attribute_types` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_attributes_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_attributes_value_id_foreign` FOREIGN KEY (`value_id`) REFERENCES `order_attribute_values` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `order_attribute_values`
--
ALTER TABLE `order_attribute_values`
  ADD CONSTRAINT `order_attribute_values_attribute_type_id_foreign` FOREIGN KEY (`attribute_type_id`) REFERENCES `order_attribute_types` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `order_materials`
--
ALTER TABLE `order_materials`
  ADD CONSTRAINT `order_materials_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `work_type_attribute_type`
--
ALTER TABLE `work_type_attribute_type`
  ADD CONSTRAINT `work_type_attribute_type_attribute_type_id_foreign` FOREIGN KEY (`attribute_type_id`) REFERENCES `order_attribute_types` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `work_type_attribute_type_work_type_id_foreign` FOREIGN KEY (`work_type_id`) REFERENCES `work_types` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
