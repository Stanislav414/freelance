<template>
  <div v-if="specializations && specializations.length > 0" class="specialization-tags-container">
    <div class="specialization-tags">
      <span 
        v-for="spec in processedSpecializations" 
        :key="spec.value" 
        class="specialization-tag"
      >
        {{ spec.label }}
      </span>
    </div>
  </div>
  <div v-else class="no-specializations">
    <span class="no-spec-text">{{ noSpecializationsText }}</span>
  </div>
</template>

<script>
export default {
  name: 'SpecializationTags',
  props: {
    specializations: {
      type: [Array, String],
      default: () => []
    },
    noSpecializationsText: {
      type: String,
      default: 'Специализации не указаны'
    }
  },
  computed: {
    processedSpecializations() {
      const specializationMap = {
        'video': 'Видео',
        'color_correction': 'Цветокоррекция',
        'motion_design': 'Моушн-дизайн',
        'video_editing': 'Монтаж видео',
        'graphic_design': 'Графический дизайн',
        'logo_design': 'Дизайн логотипов',
        'branding': 'Брендинг',
        'presentation': 'Презентации',
        'advertising': 'Рекламные макеты',
        'social_media': 'Контент для соцсетей',
        'mp_card_design': 'Дизайн карточки для МП',
        'business_card_design': 'Дизайн визитки'
      };
      
      // Если специализации не переданы
      if (!this.specializations) {
        return [];
      }
      
      let specs = this.specializations;
      
      // Если это строка, пытаемся распарсить JSON
      if (typeof specs === 'string') {
        try {
          specs = JSON.parse(specs);
        } catch (e) {
          console.warn('Ошибка парсинга специализаций:', e);
          return [];
        }
      }
      
      // Проверяем, что это массив
      if (!Array.isArray(specs)) {
        console.warn('Специализации не являются массивом:', specs);
        return [];
      }
      
      // Фильтруем пустые значения и маппим
      return specs
        .filter(spec => spec && typeof spec === 'string')
        .map(spec => ({
          value: spec,
          label: specializationMap[spec] || spec
        }));
    }
  }
}
</script>

<style scoped>
.specialization-tags-container {
  margin-top: 8px;
}

.specialization-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.specialization-tag {
  background: #2563eb;
  color: #fff;
  padding: 4px 12px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 500;
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.no-specializations {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 8px;
  color: #bfc9da;
  font-size: 12px;
  font-style: italic;
}

.no-spec-text {
  text-align: center;
}
</style> 