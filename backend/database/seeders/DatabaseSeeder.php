<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Проверяем, есть ли уже данные в базе
        $existingWorkTypes = DB::table('work_types')->count();
        if ($existingWorkTypes > 0) {
            $this->command->info('Данные уже существуют в базе. Пропускаем создание типов работ и атрибутов.');
            return;
        }

        // Отключаем проверки внешних ключей
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');
        DB::table('order_attributes')->delete();
        DB::table('order_attribute_values')->delete();
        DB::table('order_attribute_types')->delete();
        DB::table('work_type_attribute_type')->delete();
        DB::table('work_types')->delete();
        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        // Новый тип заказа "Дизайн карточки для МП"
        $mpCardDesignTypeId = DB::table('work_types')->insertGetId([
            'name' => 'Дизайн карточки для МП',
            'description' => 'Создание привлекательных и продающих карточек для маркетплейсов',
            'average_price' => 800,
            'average_time' => '2 дня',
            'is_custom' => false,
            'image' => '',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // Создаем атрибуты для дизайна карточки
        $mpCardDesignAttrs = [
            'marketplace' => 'Платформа (маркетплейс)',
            'product_name' => 'Название товара',
            'product_photo' => 'Ссылка на фото товара',
            'card_text' => 'Текст для карточки',
            'slides_count' => 'Количество слайдов',
            'design_style' => 'Стиль дизайна',
        ];

        foreach ($mpCardDesignAttrs as $name => $label) {
            $attrId = DB::table('order_attribute_types')->insertGetId([
                'name' => $name,
                'label' => $label,
                'sort_order' => 0,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            // Добавляем значения только для выпадающих списков
            if ($name === 'marketplace') {
                $marketplaceValues = ['Ozon', 'Wildberries', 'Яндекс.Маркет'];
                foreach ($marketplaceValues as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            // Связываем атрибут с типом заказа
            DB::table('work_type_attribute_type')->insert([
                'work_type_id' => $mpCardDesignTypeId,
                'attribute_type_id' => $attrId,
                'required' => true,
                'sort_order' => array_search($name, array_keys($mpCardDesignAttrs)),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // Новый тип заказа "Дизайн визитки"
        $businessCardTypeId = DB::table('work_types')->insertGetId([
            'name' => 'Дизайн визитки',
            'description' => 'Создание профессиональных визиток для бизнеса',
            'average_price' => 1500,
            'average_time' => '3 дня',
            'is_custom' => false,
            'image' => '',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // Создаем атрибуты для дизайна визитки
        $businessCardAttrs = [
            'card_purpose' => 'Какова основная цель визитки?',
            'card_recipients' => 'Кто будет получать визитку?',
            'recipient_lifestyle' => 'Какой образ жизни у получателя визитки?',
            'card_text' => 'Какой текст нужно разместить на визитке?',
            'contact_info' => 'Какие контактные данные включить?',
            'brandbook' => 'Прикрепите брендбук (если есть)',
            'company_name' => 'Название компании',
            'company_colors' => 'Цвета компании',
            'company_fonts' => 'Шрифты компании',
            'company_logo' => 'Загрузите логотип компании',
            'brand_elements' => 'Загрузите фирменные элементы',
            'qr_code_link' => 'Ссылка для QR-кода',
            'qr_code_description' => 'Описание QR-кода',
            'card_size' => 'Размер визитки',
            'design_direction' => 'Общее направление дизайна',
            'background_color' => 'Цвет фона визитки',
            'card_sides' => 'Сколько сторон у визитки?',
        ];

        foreach ($businessCardAttrs as $name => $label) {
            $attrId = DB::table('order_attribute_types')->insertGetId([
                'name' => $name,
                'label' => $label,
                'sort_order' => 0,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            // Добавляем значения только для выпадающих списков
            if ($name === 'card_purpose') {
                $cardPurposeValues = ['Бизнес', 'Личная', 'Событие', 'Промо'];
                foreach ($cardPurposeValues as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            if ($name === 'card_recipients') {
                $cardRecipientsValues = ['Клиенты', 'Партнеры', 'Коллеги', 'Друзья', 'Семья'];
                foreach ($cardRecipientsValues as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            if ($name === 'recipient_lifestyle') {
                $lifestyleValues = ['Деловой', 'Творческий', 'Спортивный', 'Классический', 'Современный'];
                foreach ($lifestyleValues as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            if ($name === 'card_size') {
                $cardSizeValues = ['Стандарт (90x50 мм)', 'Евро (85x55 мм)', 'Американский (88.9x50.8 мм)', 'Квадрат (50x50 мм)'];
                foreach ($cardSizeValues as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            if ($name === 'design_direction') {
                $designDirectionValues = ['Минимализм', 'Классика', 'Современный', 'Креативный', 'Элегантный'];
                foreach ($designDirectionValues as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            if ($name === 'card_sides') {
                $cardSidesValues = ['Односторонняя', 'Двусторонняя'];
                foreach ($cardSidesValues as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            // Связываем атрибут с типом заказа
            DB::table('work_type_attribute_type')->insert([
                'work_type_id' => $businessCardTypeId,
                'attribute_type_id' => $attrId,
                'required' => true,
                'sort_order' => array_search($name, array_keys($businessCardAttrs)),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        
        // Новый тип заказа "Видео"
        $videoTypeId = DB::table('work_types')->insertGetId([
            'name' => 'Видео',
            'description' => 'Создание и монтаж видеороликов под разные задачи',
            'average_price' => 3000,
            'average_time' => '3 дня',
            'is_custom' => false,
            'image' => '',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // Атрибуты для типа "Видео"
        $videoAttrs = [
            'duration' => 'Какое количество секунд должно быть в итоговом видео?',
            'format' => 'Какого формата должно быть видео?',
            'direction' => 'Какой направленности должно быть видео?',
            'add_subtitles' => 'Добавить субтитры?'
        ];

        foreach ($videoAttrs as $name => $label) {
            $attrId = DB::table('order_attribute_types')->insertGetId([
                'name' => 'video_' . $name,
                'label' => $label,
                'sort_order' => 0,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            // Значения для выпадающих списков
            if ($name === 'duration') {
                $values = ['до 15 секунд', '16-30 секунд', '31-60 секунд', '61-100 секунд', '101-150 секунд'];
                foreach ($values as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            if ($name === 'format') {
                $values = ['9:16 (tik tok)', '1:1', '16:9 (Youtube)', '4:3 (горизонтальный)', '3:4 (вертикальный)', '5.8"', '2:1', '2.35:1', '1.85:1', 'Свой вариант'];
                foreach ($values as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            if ($name === 'direction') {
                $values = [
                    'Анимационное видео (2D, 3D, моушн-графика)',
                    'Видео визитка',
                    'Видео с ASRM звуками',
                    'Видеоподкаст',
                    'Влог, видео из путешествия',
                    'Видео инструкция',
                    'Информационное видео',
                    'Клип',
                    'Видео-нарезка',
                    'Мультфильм',
                    'Обзорное видео недвижимости / пространства, услуги, спортивных соревнований',
                    'Отзыв',
                    'Отчетное видео',
                    'Приветственное видео',
                    'Развлекательного характера',
                    'Рекламное видео',
                    'Репортаж',
                    'Рецепты',
                    'Распаковка товара',
                    'Самопрезентация',
                    'Свадебное видео',
                    'Тизер / Трейлер',
                    'Художественное видео (короткометражка), свой вариант'
                ];
                foreach ($values as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            if ($name === 'add_subtitles') {
                $values = ['да', 'нет'];
                foreach ($values as $i => $val) {
                    DB::table('order_attribute_values')->insert([
                        'attribute_type_id' => $attrId,
                        'value' => strtolower($val),
                        'label' => $val,
                        'sort_order' => $i,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            // Связываем атрибут с типом заказа "Видео"
            DB::table('work_type_attribute_type')->insert([
                'work_type_id' => $videoTypeId,
                'attribute_type_id' => $attrId,
                'required' => true,
                'sort_order' => array_search($name, array_keys($videoAttrs)),
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
        
        // Запускаем сидер для тарифов
        $this->call(TariffSeeder::class);
        
        // Запускаем сидер для заказов
        $this->call(OrderSeeder::class);
        
        // Запускаем сидер для чатов
        $this->call(ChatSeeder::class);
    }
}
