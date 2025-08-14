<template>
  <div class="tariff-table-container">
    <div class="tariff-table-header mb-6">
      <h3 class="text-xl font-bold text-white mb-2">Выберите услуги и тариф</h3>
      <p class="text-gray-400 text-sm">Отметьте нужные услуги для расчета стоимости</p>
    </div>

    <!-- Индикатор загрузки -->
    <div v-if="loading" class="loading-indicator bg-[#16243a] rounded-2xl p-6 mb-6">
      <div class="flex items-center justify-center">
        <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
        <span class="ml-3 text-white">Загрузка тарифов...</span>
      </div>
    </div>

    <!-- Сообщение об ошибке -->
    <div v-else-if="tariffs.length === 0 && !loading" class="error-message bg-red-900 rounded-2xl p-6 mb-6">
      <div class="text-red-200">
        <h4 class="font-semibold mb-2">Ошибка загрузки тарифов</h4>
        <p class="text-sm">Не удалось загрузить данные о тарифах. Попробуйте обновить страницу.</p>
      </div>
    </div>

    <!-- Тарифная таблица -->
    <div v-if="!loading && tariffs.length > 0" class="tariff-table-wrapper bg-[#16243a] rounded-2xl p-6 mb-6">
      <div class="tariff-table">
        <!-- Заголовки тарифов -->
        <div class="tariff-header-row">
          <div class="tariff-cell service-header">
            <span class="text-gray-400 text-sm">Услуги</span>
          </div>
          <div 
            v-for="tariff in tariffs" 
            :key="tariff.id" 
            class="tariff-cell tariff-header"
            :class="{ 'selected': selectedTariff === tariff.id, 'active': currentTooltip === tariff.id }"
            @click="toggleTooltip(tariff.id)"
          >
            <div class="tariff-name">{{ tariff.name }}</div>
            <div class="tariff-price">{{ tariff.basePrice }}₽</div>
            <button 
              @click.stop="selectTariff(tariff.id)"
              class="tariff-select-btn"
              :class="{ 'selected': selectedTariff === tariff.id }"
            >
              {{ selectedTariff === tariff.id ? 'Выбрано' : 'Выбрать' }}
            </button>
            
            <!-- Иконка подсказки -->
            <div 
              v-if="shouldShowTooltip(tariff.id)" 
              class="tooltip-icon"
              title="Подробнее о тарифе"
            >ℹ️</div>
          </div>
        </div>

        <!-- Строки услуг -->
        <div 
          v-for="service in services" 
          :key="service.id" 
          class="tariff-row"
        >
          <div class="tariff-cell service-cell">
            <div class="service-info">
              <div class="service-name">{{ service.name }}</div>
              <div class="service-description">{{ service.description }}</div>
            </div>
          </div>
          <div 
            v-for="tariff in tariffs" 
            :key="tariff.id" 
            class="tariff-cell price-cell"
            :class="{ 'selected': selectedTariff === tariff.id }"
          >
            <div class="price-amount">{{ getServicePrice(service.id, tariff.id) }}₽</div>
            <input 
              type="checkbox" 
              :id="`service-${service.id}-tariff-${tariff.id}`"
              :checked="isServiceSelected(service.id, tariff.id)"
              @change="toggleService(service.id, tariff.id)"
              class="service-checkbox"
              :disabled="selectedTariff !== tariff.id"
            />
            <label 
              :for="`service-${service.id}-tariff-${tariff.id}`"
              class="service-checkbox-label"
              :class="{ 'disabled': selectedTariff !== tariff.id }"
            ></label>
          </div>
        </div>
      </div>
    </div>

    <!-- Подсказка для тарифов -->
    <div v-if="currentTooltip && getTooltipData(currentTooltip)" class="tariff-tooltip bg-[#0D1F31] rounded-2xl p-6 mb-6 border-2 border-blue-500">
      <div class="tooltip-content">
        <div class="tooltip-header">
          <h4 class="tooltip-title text-lg font-bold text-white mb-4">{{ getTooltipData(currentTooltip).name }}</h4>
        </div>
        
        <div class="tooltip-section mb-4">
          <h5 class="tooltip-subtitle text-md font-semibold text-blue-400 mb-2">Что входит в тариф:</h5>
          <ul class="tooltip-list">
            <li v-for="item in getTooltipData(currentTooltip).includes" :key="item" class="tooltip-list-item">
              <span class="tooltip-checkmark">✓</span>
              <span class="tooltip-text">{{ item }}</span>
            </li>
          </ul>
        </div>
        
        <div class="tooltip-section">
          <h5 class="tooltip-subtitle text-md font-semibold text-blue-400 mb-2">{{ getTooltipData(currentTooltip).example.title }}</h5>
          <p class="tooltip-example text-gray-300">{{ getTooltipData(currentTooltip).example.description }}</p>
        </div>
      </div>
    </div>

    <!-- Выбранные услуги -->
    <div v-if="!loading && getSelectedServicesForDisplay().length > 0" class="selected-services bg-[#064e3b] rounded-2xl p-6 mb-6">
      <h4 class="text-lg font-semibold text-emerald-400 mb-4">Выбранные услуги:</h4>
      <div class="selected-services-list">
        <div 
          v-for="selectedService in getSelectedServicesForDisplay()" 
          :key="selectedService.key"
          class="selected-service-item"
        >
          <div class="selected-service-info">
            <span class="selected-service-name">{{ selectedService.serviceName }}</span>
            <span class="selected-service-details">{{ selectedService.tariffName }} - {{ selectedService.price }}₽</span>
          </div>
          <button 
            @click="removeService(selectedService.serviceId)"
            class="remove-service-btn"
            title="Убрать услугу"
          >
            ✕
          </button>
        </div>
      </div>
    </div>

    <!-- Дополнительные опции -->
    <div v-if="!loading && additionalOptions.length > 0" class="additional-options bg-[#16243a] rounded-2xl p-6 mb-6">
      <h4 class="text-lg font-semibold text-white mb-4">Дополнительные опции</h4>
      <div class="options-grid">
        <div 
          v-for="option in additionalOptions" 
          :key="option.id"
          class="option-item"
        >
          <div class="option-info">
            <div class="option-name">{{ option.name }}</div>
            <div class="option-description">{{ option.description }}</div>
          </div>
          <div class="option-controls">
            <div class="option-price">{{ option.price }}₽</div>
            <input 
              type="checkbox" 
              :id="`option-${option.id}`"
              v-model="selectedOptions[option.id]"
              @change="updateTotalPrice"
              class="option-checkbox"
            />
            <label :for="`option-${option.id}`" class="option-checkbox-label"></label>
          </div>
        </div>
      </div>
    </div>

    <!-- Итоговая стоимость -->
    <div v-if="!loading" class="total-price-section bg-[#0D1F31] rounded-2xl p-6">
      <div class="total-price-content">
        <div class="total-price-info">
          <h4 class="text-lg font-semibold text-white">Итоговая стоимость</h4>
          <p class="text-gray-400 text-sm">Включает выбранные услуги и опции</p>
        </div>
        <div class="total-price-amount">
          <span class="total-price-value">{{ totalPrice }}₽</span>
          <span class="total-price-note">*третья и каждая последующая правка 250 рублей</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TariffTable',
  props: {
    workTypeId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      selectedTariff: null,
      selectedServices: {},
      selectedOptions: {},
      totalPrice: 0,
      tariffs: [],
      services: [],
      additionalOptions: [],
      servicePrices: {},
      loading: false,
      currentTooltip: null, // Текущая открытая подсказка
      lastSelected: {}, // Отслеживаем последний выбранный элемент для каждой услуги
      tooltipData: {
        1: { // work_type_id = 1 (Дизайн карточки для МП)
          1: { // Базовый тариф
            name: 'Базовый тариф',
            includes: [
              '1 вариант дизайна',
              '2 правки включены',
              'Готовые файлы в PNG/JPG',
              'Базовые элементы дизайна'
            ],
            example: {
              title: 'Пример базового дизайна',
              description: 'Простая и чистая карточка с основными элементами: фото товара, название, цена, краткое описание'
            }
          },
          2: { // Комфорт тариф
            name: 'Комфорт тариф',
            includes: [
              '2 варианта дизайна на выбор',
              '3 правки включены',
              'Готовые файлы в PNG/JPG + PSD',
              'Расширенные элементы дизайна',
              'Инфографика и иконки'
            ],
            example: {
              title: 'Пример комфорт дизайна',
              description: 'Привлекательная карточка с инфографикой, качественными иконками, акцентами и продуманной композицией'
            }
          },
          3: { // Рич тариф
            name: 'Рич тариф',
            includes: [
              '3 варианта дизайна на выбор',
              '5 правок включены',
              'Все форматы файлов + исходники',
              'Премиум элементы дизайна',
              'Анимированные элементы',
              'A/B тестирование вариантов'
            ],
            example: {
              title: 'Пример премиум дизайна',
              description: 'Профессиональная карточка с анимацией, премиум графикой, детальной инфографикой и максимальной конверсией'
            }
          }
        },
        2: { // work_type_id = 2 (Дизайн визитки)
          1: { // Базовый тариф
            name: 'Базовый тариф',
            includes: [
              '1 вариант дизайна',
              '2 правки включены',
              'Готовые файлы в PNG/JPG',
              'Базовые элементы дизайна'
            ],
            example: {
              title: 'Пример базовой визитки',
              description: 'Простая и элегантная визитка с основными контактными данными и логотипом компании'
            }
          },
          2: { // Комфорт тариф
            name: 'Комфорт тариф',
            includes: [
              '2 варианта дизайна на выбор',
              '3 правки включены',
              'Готовые файлы в PNG/JPG + PSD',
              'Расширенные элементы дизайна',
              'Дополнительные элементы брендинга'
            ],
            example: {
              title: 'Пример комфорт визитки',
              description: 'Стильная визитка с продуманной типографикой, цветовой схемой и дополнительными элементами дизайна'
            }
          },
          3: { // Рич тариф
            name: 'Рич тариф',
            includes: [
              '3 варианта дизайна на выбор',
              '5 правок включены',
              'Все форматы файлов + исходники',
              'Премиум элементы дизайна',
              'Специальные эффекты',
              'Полный брендинг'
            ],
            example: {
              title: 'Пример премиум визитки',
              description: 'Эксклюзивная визитка с премиум материалами, специальными эффектами и полным соответствием бренду'
            }
          }
        },
        3: { // work_type_id = 3 (Видео)
          1: { // Базовый тариф
            name: 'Базовый тариф',
            includes: [
              '1 вариант видео',
              '2 правки включены',
              'Готовое видео в MP4',
              'Базовые эффекты и переходы',
              'Простая анимация'
            ],
            example: {
              title: 'Пример базового видео',
              description: 'Простое и понятное видео с базовыми эффектами, переходами и простой анимацией'
            }
          },
          2: { // Комфорт тариф
            name: 'Комфорт тариф',
            includes: [
              '2 варианта видео на выбор',
              '3 правки включены',
              'Готовое видео в MP4 + исходники',
              'Расширенные эффекты и переходы',
              'Сложная анимация',
              'Звуковое сопровождение'
            ],
            example: {
              title: 'Пример комфорт видео',
              description: 'Качественное видео с продвинутыми эффектами, сложной анимацией и профессиональным звуковым сопровождением'
            }
          },
          3: { // Рич тариф
            name: 'Рич тариф',
            includes: [
              '3 варианта видео на выбор',
              '5 правок включены',
              'Все форматы видео + исходники',
              'Премиум эффекты и переходы',
              '3D анимация',
              'Профессиональный звук',
              'Цветокоррекция'
            ],
            example: {
              title: 'Пример премиум видео',
              description: 'Кинематографическое видео с премиум эффектами, 3D анимацией, профессиональным звуком и цветокоррекцией'
            }
          }
        }
      }
    }
  },
  methods: {
    selectTariff(tariffId) {
      this.selectedTariff = tariffId
      this.updateTotalPrice()
    },
    
    toggleService(serviceId, tariffId) {
      if (tariffId !== this.selectedTariff) return
      
      const key = `${serviceId}-${tariffId}`
      const lastSelectedKey = `service-${serviceId}`
      
      // Если кликнули на уже выбранный элемент, отменяем выбор
      if (this.lastSelected[lastSelectedKey] === key) {
        delete this.selectedServices[key]
        delete this.lastSelected[lastSelectedKey]
      } else {
        // Удаляем предыдущий выбор для этой услуги (если был)
        if (this.lastSelected[lastSelectedKey]) {
          delete this.selectedServices[this.lastSelected[lastSelectedKey]]
        }
        
        // Устанавливаем новый выбор
        this.selectedServices[key] = true
        this.lastSelected[lastSelectedKey] = key
      }
      
      this.updateTotalPrice()
    },
    
    isServiceSelected(serviceId, tariffId) {
      return !!this.selectedServices[`${serviceId}-${tariffId}`]
    },
    
    getServicePrice(serviceId, tariffId) {
      return this.servicePrices[serviceId]?.[tariffId] || 0
    },
    
    updateTotalPrice() {
      let total = 0
      
      // Добавляем стоимость выбранных услуг
      Object.keys(this.selectedServices).forEach(key => {
        const [serviceId, tariffId] = key.split('-').map(Number)
        if (this.selectedServices[key]) {
          const servicePrice = this.getServicePrice(serviceId, tariffId)
          total += servicePrice
        }
      })
      
      // Добавляем стоимость дополнительных опций
      Object.keys(this.selectedOptions).forEach(optionId => {
        if (this.selectedOptions[optionId]) {
          const option = this.additionalOptions.find(o => o.id === Number(optionId))
          if (option) {
            total += option.price
          }
        }
      })
      
      this.totalPrice = total
      this.$emit('price-updated', total)
    },
    
    getSelectedServices() {
      const services = []
      Object.keys(this.selectedServices).forEach(key => {
        if (this.selectedServices[key]) {
          const [serviceId, tariffId] = key.split('-').map(Number)
          services.push({
            serviceId,
            tariffId,
            price: this.getServicePrice(serviceId, tariffId)
          })
        }
      })
      return services
    },
    
    getSelectedOptions() {
      return Object.keys(this.selectedOptions)
        .filter(key => this.selectedOptions[key])
        .map(key => Number(key))
    },
    
    // Методы для управления подсказками
    toggleTooltip(tariffId) {
      if (this.currentTooltip === tariffId) {
        // Закрываем подсказку
        this.currentTooltip = null
      } else {
        // Открываем подсказку
        if (this.shouldShowTooltip(tariffId)) {
          this.currentTooltip = tariffId
        }
      }
    },
    
    shouldShowTooltip(tariffId) {
      return this.tooltipData[this.workTypeId] && this.tooltipData[this.workTypeId][tariffId]
    },
    
    getTooltipData(tariffId) {
      if (this.shouldShowTooltip(tariffId)) {
        return this.tooltipData[this.workTypeId][tariffId]
      }
      return null
    },
    
    removeService(serviceId) {
      // Находим и удаляем выбранную услугу
      const lastSelectedKey = `service-${serviceId}`
      if (this.lastSelected[lastSelectedKey]) {
        delete this.selectedServices[this.lastSelected[lastSelectedKey]]
        delete this.lastSelected[lastSelectedKey]
        this.updateTotalPrice()
      }
    },
    
    getSelectedServicesForDisplay() {
      // Возвращаем массив выбранных услуг для отображения с возможностью удаления
      const selected = []
      Object.keys(this.selectedServices).forEach(key => {
        if (this.selectedServices[key]) {
          const [serviceId, tariffId] = key.split('-').map(Number)
          const service = this.services.find(s => s.id === serviceId)
          const tariff = this.tariffs.find(t => t.id === tariffId)
          if (service && tariff) {
            selected.push({
              serviceId,
              tariffId,
              serviceName: service.name,
              tariffName: tariff.name,
              price: this.getServicePrice(serviceId, tariffId),
              key
            })
          }
        }
      })
      return selected
    },
    
    async loadTariffData() {
      if (!this.workTypeId) return
      
      try {
        this.loading = true
        
        const { data: tariffs } = await this.$axios.get('/tariffs')
        this.tariffs = tariffs
        
        const { data: servicesData } = await this.$axios.get(`/tariffs/work-type/${this.workTypeId}/services`)
        this.services = servicesData.services
        
        // Формируем объект цен услуг
        this.servicePrices = {}
        this.services.forEach(service => {
          this.servicePrices[service.id] = service.prices || {}
        })
        
        const { data: options } = await this.$axios.get('/tariffs/additional-options')
        this.additionalOptions = options
        
        // По умолчанию выбираем первый тариф
        if (this.tariffs.length > 0) {
          this.selectTariff(this.tariffs[0].id)
        }
      } catch (error) {
        console.error('Ошибка загрузки тарифных данных:', error)
        this.tariffs = []
        this.services = []
        this.additionalOptions = []
      } finally {
        this.loading = false
      }
    }
  },
  
  async mounted() {
    await this.loadTariffData()
  },
  
  watch: {
    workTypeId: {
      handler: 'loadTariffData',
      immediate: true
    }
  }
}
</script>

<style scoped>
.tariff-table-container {
  width: 100%;
}

.tariff-table-wrapper {
  overflow-x: auto;
}

.tariff-table {
  min-width: 600px;
  border-collapse: collapse;
}

.tariff-header-row {
  display: flex;
  border-bottom: 2px solid #22304a;
  margin-bottom: 1rem;
}

.tariff-row {
  display: flex;
  border-bottom: 1px solid #22304a;
  padding: 1rem 0;
}

.tariff-cell {
  flex: 1;
  padding: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.service-header {
  flex: 2;
  justify-content: flex-start;
}

.tariff-header {
  flex-direction: column;
  gap: 0.5rem;
  text-align: center;
  border-radius: 0.75rem;
  transition: all 0.3s ease;
  cursor: pointer;
  position: relative;
}

.tariff-header:hover {
  background: rgba(59, 130, 246, 0.05);
}

.tariff-header.selected {
  background: rgba(59, 130, 246, 0.1);
  border: 1px solid #3b82f6;
}

.tariff-header.active {
  background: rgba(59, 130, 246, 0.1) !important;
  border: 1px solid #3b82f6;
}

.tariff-name {
  font-weight: 600;
  color: white;
  font-size: 0.875rem;
}

.tariff-price {
  font-size: 1.25rem;
  font-weight: 700;
  color: #3b82f6;
}

.tariff-select-btn {
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  border: 1px solid #22304a;
  background: #071727;
  color: white;
  font-size: 0.75rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.tariff-select-btn.selected {
  background: #3b82f6;
  border-color: #3b82f6;
}

.service-cell {
  flex: 2;
  justify-content: flex-start;
}

.service-info {
  text-align: left;
}

.service-name {
  font-weight: 600;
  color: white;
  margin-bottom: 0.25rem;
}

.service-description {
  font-size: 0.75rem;
  color: #9ca3af;
}

.price-cell {
  flex-direction: column;
  gap: 0.5rem;
  transition: all 0.3s ease;
}

.price-cell.selected {
  background: rgba(59, 130, 246, 0.05);
}

.price-amount {
  font-size: 1.125rem;
  font-weight: 600;
  color: #3b82f6;
}

.service-checkbox {
  display: none;
}

.service-checkbox-label {
  width: 1.5rem;
  height: 1.5rem;
  border: 2px solid #22304a;
  border-radius: 0.375rem;
  cursor: pointer;
  position: relative;
  transition: all 0.3s ease;
}

.service-checkbox-label:hover {
  border-color: #3b82f6;
}

.service-checkbox:checked + .service-checkbox-label {
  background: #3b82f6;
  border-color: #3b82f6;
}

.service-checkbox:checked + .service-checkbox-label::after {
  content: '✓';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: white;
  font-size: 0.875rem;
  font-weight: bold;
}

.service-checkbox-label.disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.additional-options {
  margin-top: 1.5rem;
}

.options-grid {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.option-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background: #0D1F31;
  border-radius: 0.75rem;
}

.option-info {
  flex: 1;
}

.option-name {
  font-weight: 600;
  color: white;
  margin-bottom: 0.25rem;
}

.option-description {
  font-size: 0.875rem;
  color: #9ca3af;
}

.option-controls {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.option-price {
  font-weight: 600;
  color: #3b82f6;
}

.option-checkbox {
  display: none;
}

.option-checkbox-label {
  width: 1.25rem;
  height: 1.25rem;
  border: 2px solid #22304a;
  border-radius: 0.25rem;
  cursor: pointer;
  position: relative;
  transition: all 0.3s ease;
}

.option-checkbox-label:hover {
  border-color: #3b82f6;
}

.option-checkbox:checked + .option-checkbox-label {
  background: #3b82f6;
  border-color: #3b82f6;
}

.option-checkbox:checked + .option-checkbox-label::after {
  content: '✓';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: white;
  font-size: 0.75rem;
  font-weight: bold;
}

.total-price-section {
  margin-top: 1.5rem;
}

.total-price-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.total-price-info h4 {
  margin-bottom: 0.25rem;
}

.total-price-amount {
  text-align: right;
}

.total-price-value {
  display: block;
  font-size: 2rem;
  font-weight: 700;
  color: #3b82f6;
  margin-bottom: 0.25rem;
}

.total-price-note {
  font-size: 0.75rem;
  color: #9ca3af;
}

/* Стили для подсказок */
.tooltip-icon {
  position: absolute;
  top: 8px;
  right: 8px;
  font-size: 14px;
  opacity: 0.7;
  transition: opacity 0.3s ease;
}

.tariff-header:hover .tooltip-icon,
.tariff-header.active .tooltip-icon {
  opacity: 1;
}

.tariff-tooltip {
  animation: fadeInUp 0.3s ease-out;
  box-shadow: 0 8px 32px rgba(59, 130, 246, 0.2);
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.tooltip-content {
  max-width: 100%;
}

.tooltip-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  border-bottom: 2px solid #3b82f6;
  padding-bottom: 8px;
  margin-bottom: 16px;
}

.tooltip-title {
  color: #fff;
  margin: 0;
  flex: 1;
}

.tooltip-section {
  margin-bottom: 16px;
}

.tooltip-subtitle {
  color: #60a5fa;
  margin-bottom: 8px;
}

.tooltip-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.tooltip-list-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 8px;
  padding: 4px 0;
}

.tooltip-checkmark {
  color: #22c55e;
  font-weight: bold;
  margin-right: 8px;
  font-size: 1rem;
  flex-shrink: 0;
  margin-top: 2px;
}

.tooltip-text {
  color: #e5e7eb;
  line-height: 1.5;
}

.tooltip-example {
  color: #d1d5db;
  line-height: 1.6;
  font-style: italic;
  background: rgba(59, 130, 246, 0.1);
  padding: 12px;
  border-radius: 8px;
  border-left: 3px solid #3b82f6;
}

/* Стили для выбранных услуг */
.selected-services {
  border: 2px solid #10b981;
}

.selected-services-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.selected-service-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: rgba(16, 185, 129, 0.1);
  padding: 12px 16px;
  border-radius: 8px;
  border-left: 3px solid #10b981;
  transition: background 0.2s ease;
}

.selected-service-item:hover {
  background: rgba(16, 185, 129, 0.15);
}

.selected-service-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.selected-service-name {
  color: #ffffff;
  font-weight: 600;
  font-size: 0.95rem;
}

.selected-service-details {
  color: #10b981;
  font-size: 0.875rem;
  font-weight: 500;
}

.remove-service-btn {
  background: #ef4444;
  color: white;
  border: none;
  width: 28px;
  height: 28px;
  border-radius: 50%;
  font-size: 0.875rem;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}

.remove-service-btn:hover {
  background: #dc2626;
  transform: scale(1.1);
}

.remove-service-btn:active {
  transform: scale(0.95);
}

/* Адаптивные стили для подсказок */
@media (max-width: 768px) {
  .tariff-tooltip {
    padding: 1rem;
    margin: 0 -1rem 1.5rem -1rem;
    border-radius: 1rem;
  }
  
  .tooltip-title {
    font-size: 1rem;
  }
  
  .tooltip-subtitle {
    font-size: 0.875rem;
  }
  
  .tooltip-text {
    font-size: 0.875rem;
  }
  
  .tooltip-example {
    font-size: 0.875rem;
    padding: 8px;
  }
  
  .selected-service-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
  
  .remove-service-btn {
    align-self: flex-end;
    margin-top: -32px;
  }
}
</style> 