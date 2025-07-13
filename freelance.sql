-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Июл 05 2025 г., 20:22
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
(5, '2025_07_03_055418_create_personal_access_tokens_table', 2);

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
(1, 'App\\Models\\User', 1, 'app_token', 'ab35c2d4df86c9db0082d37c0dbcb6283994293a2d60ab5be1e63dfb71eb6a27', '[\"*\"]', NULL, NULL, '2025-07-05 07:12:35', '2025-07-05 07:12:35'),
(2, 'App\\Models\\User', 2, 'app_token', '12d411e682b8789a4af8a93e08e19755ce91e03a7da9dd622368b61d16250e86', '[\"*\"]', NULL, NULL, '2025-07-05 07:27:06', '2025-07-05 07:27:06'),
(3, 'App\\Models\\User', 2, 'app_token', '691e62c2019cd03a2449a02455fcaf987ccf21bca00d1b444085f0450945a3f3', '[\"*\"]', '2025-07-05 07:27:22', NULL, '2025-07-05 07:27:19', '2025-07-05 07:27:22'),
(4, 'App\\Models\\User', 3, 'app_token', '754ba330b688e5225bc8f249e85ef8f904456d696303116d3144947af8c45719', '[\"*\"]', NULL, NULL, '2025-07-05 08:53:19', '2025-07-05 08:53:19'),
(5, 'App\\Models\\User', 3, 'app_token', '75d27fb8ccf37a30f03a233c49ed66296a47d417cf2097966ac89414e31f66f6', '[\"*\"]', NULL, NULL, '2025-07-05 08:53:26', '2025-07-05 08:53:26'),
(6, 'App\\Models\\User', 3, 'app_token', '5d27a02b39c87262d764269a8228d856249d4f14e2213550fe59ca89a1065526', '[\"*\"]', NULL, NULL, '2025-07-05 08:53:38', '2025-07-05 08:53:38'),
(7, 'App\\Models\\User', 3, 'app_token', 'af09f7529c05ab6217dc19f57d1144535bf2e9b63c79de8d15b01d3c0634d1cf', '[\"*\"]', NULL, NULL, '2025-07-05 08:53:45', '2025-07-05 08:53:45'),
(8, 'App\\Models\\User', 3, 'app_token', 'a58b58b4e7d7654e7427e2dacdd2d87314d2d5fcf97c30ef54f32168c559f340', '[\"*\"]', NULL, NULL, '2025-07-05 09:13:22', '2025-07-05 09:13:22'),
(9, 'App\\Models\\User', 3, 'app_token', '9e91034cc552580b2cb0debcb74e34fec863775aac1ae055ba99f03b0101e71e', '[\"*\"]', NULL, NULL, '2025-07-05 09:13:27', '2025-07-05 09:13:27'),
(10, 'App\\Models\\User', 4, 'app_token', '9acd7ed5c28f458fe5216ea1f69e594da39831c5a08d549eb0a8d298d9d913be', '[\"*\"]', NULL, NULL, '2025-07-05 09:13:50', '2025-07-05 09:13:50'),
(11, 'App\\Models\\User', 4, 'app_token', 'a23a233948b88e940f6da6800f0483c1cfaa32b86594efc481f3087da8fd4a3c', '[\"*\"]', NULL, NULL, '2025-07-05 09:14:43', '2025-07-05 09:14:43'),
(12, 'App\\Models\\User', 4, 'app_token', '7c26c3c096c4a8b75b116589285ba04597dabca646a3e97a2ed1de828bda3adb', '[\"*\"]', NULL, NULL, '2025-07-05 09:23:55', '2025-07-05 09:23:55'),
(13, 'App\\Models\\User', 4, 'app_token', 'f0f845857fed16d7d84e3e766efdfcd75bc1117e95bbe56498b4c06279167d5a', '[\"*\"]', NULL, NULL, '2025-07-05 09:56:11', '2025-07-05 09:56:11'),
(14, 'App\\Models\\User', 4, 'app_token', '1d911ca594f457e3a675afe370b0906b839bd38dc05f643c81fbdffd9f47ba2a', '[\"*\"]', NULL, NULL, '2025-07-05 10:02:25', '2025-07-05 10:02:25'),
(15, 'App\\Models\\User', 4, 'app_token', 'b644d1f5b0525e9b366504380409d9adac687cb55ca4f9e343764f24ebf07b1a', '[\"*\"]', NULL, NULL, '2025-07-05 10:15:05', '2025-07-05 10:15:05'),
(16, 'App\\Models\\User', 4, 'app_token', 'd245b1de8ce7b3e34ec3853a20453e815fff553dffedc9edce6c73db626269b7', '[\"*\"]', NULL, NULL, '2025-07-05 10:15:19', '2025-07-05 10:15:19'),
(17, 'App\\Models\\User', 4, 'app_token', '69e8f1ae9e2dcd2003b4c707d6e634d64d98e3bded88a21591d3afc8b21dbacd', '[\"*\"]', NULL, NULL, '2025-07-05 10:26:35', '2025-07-05 10:26:35'),
(18, 'App\\Models\\User', 4, 'app_token', '4b94de6900e9a825661ab064846393bbe84f2eb68adc55e25c2d09b08b1ee340', '[\"*\"]', NULL, NULL, '2025-07-05 10:26:45', '2025-07-05 10:26:45'),
(19, 'App\\Models\\User', 4, 'app_token', 'bbf9ff1567232646890c8e6c3f90bf5c0a94c7f904cb8413123c0e88ae73285f', '[\"*\"]', NULL, NULL, '2025-07-05 10:35:47', '2025-07-05 10:35:47'),
(20, 'App\\Models\\User', 4, 'app_token', '3a09a089d5351777405cf793dd931a62b63bee6aabff2476c987a48fb9ed2c19', '[\"*\"]', NULL, NULL, '2025-07-05 11:07:19', '2025-07-05 11:07:19');

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
('8HTehPjR4MYnQI5l66e6eJnRnppErlev4auXOStj', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTUtOWklmNVl0aXJmbVZJeTlBaGQ0QzBXOWVhV1dnOWFXekZ2VUpKUiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1751715575),
('DOdq22EHczT3fciUZRszZkDEfOq93jzTyBYzNYSl', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36 Edg/138.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOENjM3NrV2VxRWNmUjBzY1NENGhkd3pvZmx6T2V2Y3FRNDlaVGhyYSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1751724478);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `surname` varchar(255) NOT NULL,
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
(1, '12312', '123123', 'qwe@qwe', NULL, '$2y$12$xFrOwipGaMq8Xt3nY.kQuOWoPGN5ZUV309GFzLKYmzg.amYMOmgda', NULL, '2025-07-05 07:12:35', '2025-07-05 07:12:35'),
(2, '123123', '1123', '1@1', NULL, '$2y$12$CID2WAhPiWQfFkz7.2.jt.Rl0J.QCOAsTziHW.F2PJ.5ECiiLpSwy', NULL, '2025-07-05 07:27:06', '2025-07-05 07:27:06'),
(3, '123123', '123123', '1qweq@1', NULL, '$2y$12$bGWjd8Tcv2wqUOKdN/GIQe8n89JjoVMZwlBh9BemuxlFFzgLNDUhG', NULL, '2025-07-05 08:53:19', '2025-07-05 08:53:19'),
(4, 'Иванов', 'Семен', '123@123', NULL, '$2y$12$fNMZd/KoVHXbe0LZlNGBOOyk8UW1bqua9cAooWvO4LCA3P8XUG5E6', NULL, '2025-07-05 09:13:50', '2025-07-05 09:13:50');

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
