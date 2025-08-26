<template>
  <!-- Модальное окно создания заказа -->
  <div class="modal-overlay active">
    <div class="modal-window">
      <!-- Заголовок модального окна -->
      <div class="modal-header">
        <button class="modal-close" @click="closeModal">×</button>
        <h1 class="modal-title">Создание заказа</h1>
        <p class="modal-subtitle">Заполните форму для создания нового заказа</p>
        
        <!-- Индикатор шагов -->
        <div class="steps-indicator">
          <div :class="['step-indicator', step === 1 ? 'active' : '', step > 1 ? 'completed' : '']">
            <div class="step-number">1</div>
            <span>Тип работы</span>
          </div>
          <div class="step-connector"></div>
          <div :class="['step-indicator', step === 2 ? 'active' : '', step > 2 ? 'completed' : '']">
            <div class="step-number">2</div>
            <span>Детали и тарифы</span>
          </div>
          <div class="step-connector"></div>
          <div :class="['step-indicator', step === 3 ? 'active' : '']">
            <div class="step-number">3</div>
            <span>Исполнитель</span>
          </div>
        </div>
      </div>

      <!-- Содержимое модального окна -->
      <div class="modal-body">
        <!-- Шаг 1: Выбор типа работы -->
        <div v-if="step === 1" class="step-content active">
          <div class="step-container">
            <div class="work-type-selection">
              <div class="work-type-header">
                <h2 class="work-type-title">Тип заказа</h2>
                <div class="search-box">
                  <span class="search-icon">🔍</span>
                  <input type="text" class="search-input" placeholder="Поиск..." v-model="searchTerm" @input="filterWorkTypes">
                </div>
              </div>
              
              <div v-if="workTypes.length === 0" class="loading-state">
                <div class="loading-spinner"></div>
                <p class="loading-text">Загрузка типов работ...</p>
              </div>
              
              <div v-else-if="filteredWorkTypes.length === 0" class="empty-state">
                <p class="empty-text">Типы работ не найдены</p>
              </div>
              
              <div v-else class="work-type-grid">
                <div v-for="type in filteredWorkTypes" :key="type.id" 
                     :class="['work-type-card', selectedWorkType && selectedWorkType.id === type.id ? 'selected' : '']"
                     @click="selectWorkType(type)">
                  <div class="work-type-card-header">
                    <div class="work-type-icon">
                      <img :src="getWorkTypeIcon(type)" class="w-6 h-6" alt="icon" />
                    </div>
                    <div class="work-type-info">
                      <div class="work-type-name">{{ type.name }}</div>
                      <div class="work-type-desc">{{ type.description }}</div>
                    </div>
                  </div>
                  <div class="work-type-details">
                    <span class="work-type-time">{{ type.average_time || '2 часа' }}<br><small>сред. время</small></span>
                    <span class="work-type-price">{{ type.average_price || '300' }}₽<br><small>сред. цена</small></span>
                  </div>
                </div>
              </div>
              <div v-if="errors.work_type_id" class="text-red-400 mt-4 text-center">{{ errors.work_type_id }}</div>
            </div>
          </div>
        </div>

        <!-- Шаг 2: Детали и тарифы -->
        <div v-if="step === 2" class="step-content active">
          <div class="step-container">
            <div class="order-form">
              <!-- Левая колонка - Форма -->
              <div class="form-section">
                <div class="form-content">
                  <!-- Секция "О заказе" -->
                  <div class="order-section mb-8">
                    <h3 class="section-title mb-4">О заказе</h3>
                    <div class="order-card">
                      <div class="order-header">
                        <div class="order-icon">
                          <img :src="getWorkTypeIcon(selectedWorkType)" class="w-8 h-8" alt="icon" />
                        </div>
                        <div class="order-info">
                          <h4 class="order-title">{{ selectedWorkType?.name }}</h4>
                          <p class="order-description">{{ selectedWorkType?.description }}</p>
                        </div>
                      </div>
                      <div class="order-meta">
                        <div class="meta-item">
                          <div class="meta-value">{{ selectedWorkType?.average_time || '2 дня' }}</div>
                          <div class="meta-sub">среднее время</div>
                        </div>
                        <div class="meta-item">
                          <div class="meta-value">{{ formatPrice(selectedWorkType?.average_price || '800') }}₽</div>
                          <div class="meta-sub">средняя цена</div>
                        </div>
                      </div>
                    </div>
                    
                    <div class="description-section mt-6">
                      <label class="block mb-3 font-semibold text-base text-white">Описание задачи</label>
                      <textarea 
                        v-model="form.description" 
                        rows="6" 
                        class="w-full p-4 rounded-2xl bg-[#071727] text-white border-2 border-[#22304a] focus:border-blue-500 focus:outline-none transition-colors resize-none text-lg placeholder-gray-400" 
                        :placeholder="selectedWorkType?.description || 'Подробно опишите вашу задачу, детали, пожелания, требования к результату...'"
                      ></textarea>
                      <div v-if="errors.description" class="text-red-400 mt-2 text-sm">{{ errors.description }}</div>
                    </div>
                  </div>

                  <!-- Секция "Характеристики заказа" -->
                  <div class="order-section mb-8">
                    <h3 class="section-title mb-6">Характеристики заказа</h3>
                    <div class="characteristics-grid-wide">
                      <div v-for="field in dynamicFields.slice(0, 3)" :key="field.id" class="characteristic-item-wide">
                        <label class="block mb-3 font-semibold text-base text-white">{{ field.label }}</label>
                        <select 
                          v-if="field.values && field.values.length" 
                          v-model="form.attributes[field.id]" 
                          class="w-full p-4 rounded-2xl bg-[#071727] text-white border-2 border-[#22304a] focus:border-blue-500 focus:outline-none transition-colors text-lg"
                        >
                          <option disabled value="">Выберите {{ field.label.toLowerCase() }}</option>
                          <option v-for="val in field.values" :key="val.id" :value="val.id">{{ val.label }}</option>
                        </select>
                        <input 
                          v-else 
                          v-model="form.attributes[field.id]" 
                          class="w-full p-4 rounded-2xl bg-[#071727] text-white border-2 border-[#22304a] focus:border-blue-500 focus:outline-none transition-colors text-lg" 
                          :placeholder="field.label" 
                        />
                        <div v-if="errors['attr_' + field.id]" class="text-red-400 mt-2 text-sm">{{ errors['attr_' + field.id] }}</div>
                      </div>
                    </div>
                  </div>

                  <!-- Секция "Технические требования" -->
                  <div class="order-section mb-8">
                    <h3 class="section-title mb-6">Технические требования</h3>
                    <div class="characteristics-grid-wide">
                      <div v-for="field in dynamicFields.slice(3, 6)" :key="field.id" class="characteristic-item-wide">
                        <label class="block mb-3 font-semibold text-base text-white">{{ field.label }}</label>
                        <select 
                          v-if="field.values && field.values.length" 
                          v-model="form.attributes[field.id]" 
                          class="w-full p-4 rounded-2xl bg-[#071727] text-white border-2 border-[#22304a] focus:border-blue-500 focus:outline-none transition-colors text-lg"
                        >
                          <option disabled value="">Выберите {{ field.label.toLowerCase() }}</option>
                          <option v-for="val in field.values" :key="val.id" :value="val.id">{{ val.label }}</option>
                        </select>
                        <input 
                          v-else 
                          v-model="form.attributes[field.id]" 
                          class="w-full p-4 rounded-2xl bg-[#071727] text-white border-2 border-[#22304a] focus:border-blue-500 focus:outline-none transition-colors text-lg" 
                          :placeholder="field.label" 
                        />
                        <div v-if="errors['attr_' + field.id]" class="text-red-400 mt-2 text-sm">{{ errors['attr_' + field.id] }}</div>
                      </div>
                    </div>
                  </div>

                  <!-- Секция "Количество слайдов" (только для "Дизайн карточки для МП") -->
                  <div v-if="selectedWorkType?.name === 'Дизайн карточки для МП'" class="order-section mb-8">
                    <h3 class="section-title mb-4">Количество слайдов</h3>
                    <div class="characteristics-grid-wide">
                      <div class="characteristic-item-wide">
                        <label class="block mb-3 font-semibold text-base text-white">Количество слайдов</label>
                        <div class="flex items-center gap-4">
                          <input 
                            v-model="form.slidesQuantity" 
                            type="number" 
                            min="1" 
                            max="20"
                            class="flex-1 p-4 rounded-2xl bg-[#071727] text-white border-2 border-[#22304a] focus:border-blue-500 focus:outline-none transition-colors text-lg" 
                            placeholder="Укажите количество"
                          />
                          <div class="text-gray-400 text-sm">
                            от 1 до 20 слайдов
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Секция "Материалы" -->
                  <div class="order-section mb-8">
                    <h3 class="section-title mb-4">Материалы для работы</h3>
                    <div class="materials-section">
                      <div v-for="(mat, index) in form.materials" :key="index" class="material-item mb-4">
                        <div class="material-header">
                          <span class="material-number">#{{ index + 1 }}</span>
                          <button 
                            v-if="form.materials.length > 1" 
                            @click="removeMaterial(index)" 
                            class="remove-material-btn"
                            title="Убрать материал">✕</button>
                        </div>
                        <div class="material-fields">
                          <div class="material-field">
                            <label class="block mb-2 font-medium text-white">Тип материала</label>
                            <input 
                              v-model="mat.type" 
                              class="w-full p-3 rounded-xl bg-[#071727] text-white border border-[#22304a] focus:border-blue-500 focus:outline-none transition-colors placeholder-gray-400" 
                              placeholder="Например: Логотип, Фото, Текст..."
                            />
                          </div>
                          <div class="material-field">
                            <label class="block mb-2 font-medium text-white">Описание</label>
                            <textarea 
                              v-model="mat.description" 
                              rows="3" 
                              class="w-full p-3 rounded-xl bg-[#071727] text-white border border-[#22304a] focus:border-blue-500 focus:outline-none transition-colors resize-none placeholder-gray-400" 
                              placeholder="Подробное описание материала..."
                            ></textarea>
                          </div>
                          <div class="material-field">
                            <label class="block mb-2 font-medium text-white">Файл (URL)</label>
                            <input 
                              v-model="mat.file_url" 
                              class="w-full p-3 rounded-xl bg-[#071727] text-white border border-[#22304a] focus:border-blue-500 focus:outline-none transition-colors placeholder-gray-400" 
                              placeholder="Ссылка на файл (Google Drive, Dropbox, etc.)"
                            />
                          </div>
                        </div>
                      </div>
                      <button 
                        @click="addMaterial" 
                        class="add-material-btn"
                        type="button">
                        <span class="add-icon">+</span>
                        Добавить материал
                      </button>
                    </div>
                  </div>

                  <!-- Секция "Сроки выполнения" -->
                  <div class="order-section mb-8">
                    <h3 class="section-title mb-4">Сроки выполнения</h3>
                    <div class="characteristics-grid-wide">
                      <div class="characteristic-item-wide">
                        <label class="block mb-3 font-semibold text-base text-white">Срок выполнения</label>
                        <input 
                          v-model="form.deadline" 
                          type="date" 
                          :min="minDate"
                          class="w-full p-4 rounded-2xl bg-[#071727] text-white border-2 border-[#22304a] focus:border-blue-500 focus:outline-none transition-colors text-lg" 
                        />
                        <div v-if="errors.deadline" class="text-red-400 mt-2 text-sm">{{ errors.deadline }}</div>
                      </div>
                    </div>
                  </div>

                  <!-- Секция "Тарифы и услуги" -->
                  <div class="order-section">
                    <h3 class="section-title mb-6">Тарифы и услуги</h3>
                    <div v-if="tariffLoading" class="py-8">
                      <div class="flex items-center justify-center gap-3">
                        <div class="loading-spinner small"></div>
                        <p class="text-gray-400">Загрузка тарифов...</p>
                      </div>
                    </div>
                    
                    <div v-else-if="tariffs.length > 0" class="tariff-section">
                      <div class="tariff-table-container">
                        <table class="tariff-table">
                          <thead>
                            <tr class="border-b border-gray-600">
                              <th class="px-4 py-3 text-left text-white font-semibold">Услуга</th>
                              <th 
                                v-for="tariff in tariffs" 
                                :key="tariff.id"
                               class="px-4 py-3 text-center text-white font-semibold cursor-pointer has-tooltip relative"
                                :class="{ 'tooltip-active': hoveredTariff && hoveredTariff.id === tariff.id && tooltipVisible }"
                                @click="toggleTooltip(tariff)"
                              >
                                <div v-if="shouldShowTooltip(tariff)" class="tooltip-icon absolute -top-2 -right-2 text-sm">ℹ️</div>
                                {{ tariff.name }}
                              </th>
                            </tr>
                          </thead>
                          <tbody>
                            <!-- Базовые услуги -->
                            <tr v-for="service in services" :key="service.id" class="hover:bg-gray-700/30">
                              <td class="px-4 py-3 text-white font-medium">
                                <label class="flex items-center cursor-pointer">
                                  <input 
                                    type="checkbox" 
                                    :checked="selectedServices[service.id]?.enabled || false"
                                    @change="toggleService(service.id)"
                                    class="w-4 h-4 text-blue-600 bg-gray-700 border-gray-600 focus:ring-blue-500 mr-2"
                                  >
                                  {{ service.name }}
                                </label>
                              </td>
                              <td 
                                v-for="tariff in tariffs" 
                                :key="tariff.id"
                                class="px-4 py-3 text-center"
                              >
                                <label class="flex flex-col items-center cursor-pointer" :class="{ 'opacity-50': !selectedServices[service.id]?.enabled }">
                                  <input 
                                    type="radio" 
                                    :name="'service-' + service.id"
                                    :value="tariff.id"
                                    :checked="selectedServices[service.id]?.tariffId === tariff.id"
                                    :disabled="!selectedServices[service.id]?.enabled"
                                    @change="selectServiceTariff(service.id, tariff.id)"
                                    class="w-4 h-4 text-blue-600 bg-gray-700 border-gray-600 focus:ring-blue-500"
                                  >
                                  <span class="text-green-400 font-semibold mt-1">{{ formatPrice(getServicePrice(service.id, tariff.id)) }}₽</span>
                                </label>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                      
                      <!-- Подсказка для тарифов -->
                       <div v-if="tooltipVisible && hoveredTariff && getTooltipData(hoveredTariff)" class="tariff-tooltip bg-[#0D1F31] rounded-2xl p-6 mb-6 border-2 border-blue-500">
                        <div class="tooltip-content">
                          <h4 class="tooltip-title text-lg font-bold text-white mb-4">{{ getTooltipData(hoveredTariff).name }}</h4>
                          
                          <div class="tooltip-section mb-4">
                            <h5 class="tooltip-subtitle text-md font-semibold text-blue-400 mb-2">Что входит в тариф:</h5>
                             <ul class="tooltip-list">
                               <li v-for="item in getTooltipData(hoveredTariff).includes" :key="item" class="tooltip-list-item">
                                <span class="tooltip-checkmark">✓</span>
                                <span class="tooltip-text">{{ item }}</span>
                              </li>
                            </ul>
                          </div>
                          
                          <div class="tooltip-section">
                              <h5 class="tooltip-subtitle text-md font-semibold text-blue-400 mb-2">{{ getTooltipData(hoveredTariff).example.title }}</h5>
                              <p class="tooltip-example text-gray-300">{{ getTooltipData(hoveredTariff).example.description }}</p>
            <div v-if="getTooltipData(hoveredTariff).example.images && getTooltipData(hoveredTariff).example.images.length" class="tooltip-images mt-4">
              <h6 class="tooltip-subtitle text-sm font-semibold text-blue-400 mb-3">Примеры работ:</h6>
              <div class="tooltip-images-grid">
                <div 
                  v-for="(img, idx) in getTooltipData(hoveredTariff).example.images" 
                  :key="img" 
                  class="tooltip-image-item"
                  @click="openImageModal(img)"
                >
                  <img :src="getAssetUrl(img)" :alt="`Пример ${idx + 1}`" class="tooltip-image-preview" @error="handleImageError" />
                  <div class="tooltip-image-overlay">
                    <span class="tooltip-image-text">Пример {{ idx + 1 }}</span>
                  </div>
                </div>
              </div>
            </div>
                          </div>
                        </div>
                      </div>
                      

                    </div>
                    
                    <!-- Нет данных -->
                    <div v-else class="text-gray-400 text-center py-8">
                      Тарифы не найдены для выбранного типа работы
                    </div>
                    
                    <!-- Кнопка перезагрузки -->
                    <button @click="loadTariffData" class="mt-4 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg mb-0">
                      Перезагрузить тарифы
                    </button>
                  </div>
                </div>
              </div>
              
              <!-- Правая колонка - Итоги -->
              <div class="summary-section">
                <!-- Превью заказа -->
                <div class="summary-card">
                  <h3 class="summary-title">📋 Превью заказа</h3>
                  <div class="order-preview">
                    <div class="preview-item">
                      <span class="preview-label">Тип работы:</span>
                      <span class="preview-value">{{ selectedWorkType?.name || '—' }}</span>
                    </div>
                    <div class="preview-item">
                      <span class="preview-label">Срок:</span>
                      <span class="preview-value">{{ form.deadline || '—' }}</span>
                    </div>
                    <div class="preview-item">
                      <span class="preview-label">Итоговая стоимость:</span>
                      <span class="preview-value">{{ formatPrice(totalPrice) }}₽</span>
                    </div>
                  </div>
                </div>

                <!-- Выбранные услуги -->
                <div v-if="getSelectedServicesForDisplay().length > 0" class="selected-services">
                  <div class="selected-services-title">✨ Выбранные услуги</div>
                  <div class="selected-services-list">
                    <div v-for="selectedService in getSelectedServicesForDisplay()" 
                         :key="`${selectedService.serviceId}-${selectedService.tariffName}`"
                         class="selected-service">
                      <div class="service-info">
                        <div class="service-name">{{ selectedService.serviceName }}</div>
                        <div class="service-details">{{ selectedService.tariffName }} - {{ selectedService.price }}₽</div>
                      </div>
                      <button @click="removeService(selectedService.serviceId)"
                              class="remove-btn"
                              title="Убрать услугу">✕</button>
                    </div>
                  </div>
                </div>
                
                <!-- Кнопки действий (всегда отображаются) -->
                <div class="mt-2 space-y-3">
                  <button 
                    @click="goToStep3" 
                    :disabled="loading || getSelectedServicesForDisplay().length === 0" 
                    class="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-xl transition-colors disabled:opacity-50"
                  >
                    {{ loading ? 'Загрузка...' : 'Выбрать исполнителя' }}
                  </button>
                  
                  <button 
                    @click="createOrderWithoutExecutor" 
                    :disabled="loading || getSelectedServicesForDisplay().length === 0" 
                    class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-6 rounded-xl transition-colors disabled:opacity-50"
                  >
                    {{ loading ? 'Загрузка...' : 'Создать заказ без исполнителя' }}
                  </button>
                  
                  <button 
                    @click="goToPrevStep" 
                    class="w-full bg-gray-600 hover:bg-gray-700 text-white font-semibold py-3 px-6 rounded-xl transition-colors"
                  >
                    ← Назад
                  </button>
                </div>


              </div>
            </div>
          </div>
        </div>
        
        <!-- Шаг 3: Выбор исполнителя -->
        <div v-if="step === 3" class="step-content active">
          <div class="step-container">
            <div class="executor-selection">
              <div class="mb-6">
                <h3 class="text-xl font-bold mb-4">Подходящие исполнители</h3>
                <div class="bg-[#16243a] rounded-2xl p-6 mb-6">
                  <div class="flex items-center gap-4 mb-4">
                    <img :src="getWorkTypeIcon(selectedWorkType)" class="w-12 h-12 rounded-lg" alt="icon" />
                    <div>
                      <h4 class="font-semibold text-lg">{{ selectedWorkType?.name }}</h4>
                      <p class="text-gray-400 text-sm">{{ form.description }}</p>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Список исполнителей -->
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div v-for="executor in filteredExecutors" :key="executor.id" 
                     class="bg-[#16243a] rounded-2xl p-4 cursor-pointer hover:bg-[#1a2a3a] transition-colors">
                  <div class="flex items-start justify-between mb-3">
                    <div class="flex items-center gap-3">
                      <div class="relative">
                        <img :src="getExecutorAvatar(executor)"
                             @error="onAvatarError"
                             class="w-12 h-12 rounded-full object-cover" :alt="executor.name" />
                        <div v-if="executor.is_verified" 
                             class="absolute -bottom-1 -right-1 bg-green-500 text-white w-5 h-5 rounded-full flex items-center justify-center text-xs">
                          ✓
                        </div>
                      </div>
                      <div>
                        <h5 class="font-semibold">{{ executor.name }}</h5>
                        <div class="flex items-center gap-2 mt-1">
                          <div class="flex items-center gap-1">
                            <span class="text-yellow-400">⭐</span>
                            <span class="text-sm text-gray-300">{{ executor.rating || '0.0' }}</span>
                          </div>
                          <span class="text-gray-500 text-xs">•</span>
                          <span class="text-sm text-gray-400">{{ executor.completed_orders || 0 }} заказов</span>
                        </div>
                      </div>
                    </div>
                  </div>
                  <div class="text-sm text-gray-400 mb-3">
                    <!-- Специализации -->
                    <div v-if="executor.specializations && executor.specializations.length" class="mt-2">
                      <p class="text-xs text-gray-500 mb-1">Специализации:</p>
                      <div class="flex flex-wrap gap-1">
                        <span v-for="spec in executor.specializations" :key="spec" 
                              class="text-xs bg-blue-600 text-white px-2 py-1 rounded-full">
                          {{ getSpecializationLabel(spec) }}
                        </span>
                      </div>
                    </div>
                  </div>
                  <button @click="selectExecutor(executor.id)" 
                          class="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-lg transition-colors">
                    Выбрать исполнителя
                  </button>
                </div>
              </div>
              
              <!-- Кнопки действий для шага 3 -->
              <div class="mt-6 space-y-3">
                <button 
                  @click="createOrderWithoutExecutor" 
                  :disabled="loading || getSelectedServicesForDisplay().length === 0" 
                  class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-6 rounded-xl transition-colors disabled:opacity-50"
                >
                  {{ loading ? 'Загрузка...' : 'Создать заказ без исполнителя' }}
                </button>
                
                <button 
                  @click="goToPrevStep" 
                  class="w-full bg-gray-600 hover:bg-gray-700 text-white font-semibold py-3 px-6 rounded-xl transition-colors"
                >
                  ← Назад
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Модальное окно для просмотра изображений -->
      <div v-if="showImageModal" class="image-modal-overlay" @click="closeImageModal">
        <div class="image-modal-content" @click.stop>
          <div class="image-modal-header">
            <h3 class="image-modal-title">Пример работы</h3>
            <button @click="closeImageModal" class="image-modal-close">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <div class="image-modal-body">
            <img v-if="selectedImage" :src="getAssetUrl(selectedImage)" :alt="selectedImage" class="image-modal-image" @error="handleImageError" />
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<script>
import performerIcon from '@/assets/performer.png';

export default {
  name: 'CreateOrder',
  components: {
  },
  data() {
    return {
      performerIcon,
      step: 1,
      workTypes: [],
      attributeTypes: [],
             dynamicFields: [], // новые динамические поля
      selectedWorkType: null,
              form: {
          work_type_id: '',
          title: '',
          attributes: {},
          description: '',
          deadline: '',
          materials: [],
          slidesQuantity: 1, // Количество слайдов для "Дизайн карточки для МП"
        },
      errors: {},
      loading: false,
      showExecutorsModal: false,
      createdOrder: null,
      executors: [],
      selectedExecutorId: null,
      // Данные для тарифов
      tariffs: [],
      services: [],
      servicePrices: [],
      totalPrice: 0,
      tariffLoading: false,
      tariffError: null,
      selectedTariff: null,
      selectedServices: {}, // Изменено: теперь объект {serviceId: {enabled: boolean, tariffId: number}}
      hoveredTariff: null,
      tooltipVisible: false,
      lastSelected: {}, // Отслеживаем последний выбранный элемент для каждой услуги
      // Подсказки по ID (если ID совпадает)
      tooltipData: {
        1: { // Дизайн карточки для МП (если id = 1)
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
              description: 'Простая и чистая карточка с основными элементами: фото товара, название, цена, краткое описание',
              images: ['1_baza.png','2_baza.PNG','3_baza.PNG']
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
              description: 'Привлекательная карточка с инфографикой, качественными иконками, акцентами и продуманной композицией',
              images: ['1_comfort.PNG','2_comfort.PNG','3_comfort.PNG']
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
              description: 'Профессиональная карточка с анимацией, премиум графикой, детальной инфографикой и максимальной конверсией',
              images: ['1_rich.PNG','2_rich.PNG','3_rich.PNG']
            }
          }
        }
      },
      // Подсказки по названию типа работы — работает независимо от ID
      tooltipDataByName: {
        'Дизайн карточки для МП': {
          'Базовый': {
            name: 'Базовый тариф',
            includes: [
              '1 вариант дизайна',
              '2 правки включены',
              'Готовые файлы в PNG/JPG',
              'Базовые элементы дизайна'
            ],
            example: {
              title: 'Пример базового дизайна',
              description: 'Простая и чистая карточка с основными элементами: фото товара, название, цена, краткое описание',
              images: ['1_baza.png', '2_baza.PNG', '3_baza.PNG']
            }
          },
          'Комфорт': {
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
              description: 'Привлекательная карточка с инфографикой, качественными иконками, акцентами и продуманной композицией',
              images: ['1_comfort.PNG', '2_comfort.PNG', '3_comfort.PNG']
            }
          },
          'Рич': {
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
              description: 'Профессиональная карточка с анимацией, премиум графикой, детальной инфографикой и максимальной конверсией',
              images: ['1_rich.PNG', '2_rich.PNG', '3_rich.PNG']
            }
          }
        },
        'Дизайн визитки': {
          'Базовый': {
            name: 'Базовый тариф',
            includes: [
              '1 вариант дизайна визитки',
              '2 правки включены',
              'Готовые файлы в PNG/JPG',
              'Минимальные фирменные элементы'
            ],
            example: {
              title: 'Пример базовой визитки',
              description: 'Элегантная визитка с контактами, логотипом и аккуратной версткой',
              images: ['1_baza_vizitka.png', '2_baza_vizitka.png', '3_baza_vizitka.png']
            }
          },
          'Комфорт': {
            name: 'Комфорт тариф',
            includes: [
              '2 варианта дизайна на выбор',
              '3 правки включены',
              'PNG/JPG + исходники (PSD/AI)',
              'Расширенные элементы брендинга',
              'Подбор фирменной типографики'
            ],
            example: {
              title: 'Пример комфорт визитки',
              description: 'Стильная визитка с продуманной типографикой, цветовой схемой и деталями бренда',
              images: ['1_comfort_vizitka.png', '2_comfort_vizitka.png', '3_comfort_vizitka.png']
            }
          },
          'Рич': {
            name: 'Рич тариф',
            includes: [
              '3 варианта дизайна на выбор',
              '5 правок включены',
              'Полный пакет исходников',
              'Премиум материалы/эффекты (тиснение, фольга — макет)',
              'Полный брендинг визитки'
            ],
            example: {
              title: 'Пример премиум визитки',
              description: 'Эксклюзивная визитка с премиум визуалом и полной интеграцией под бренд'
            }
          }
        },
        'Видео': {
          'Базовый': {
            name: 'Базовый тариф',
            includes: [
              '1 вариант видео',
              '2 правки включены',
              'Экспорт MP4',
              'Базовые эффекты и переходы'
            ],
            example: {
              title: 'Пример базового видео',
              description: 'Короткое видео с базовыми переходами и простыми титрами'
            }
          },
          'Комфорт': {
            name: 'Комфорт тариф',
            includes: [
              '2 варианта видео на выбор',
              '3 правки включены',
              'MP4 + исходники проекта',
              'Расширенные эффекты, сложнее анимация',
              'Звуковое сопровождение'
            ],
            example: {
              title: 'Пример комфорт видео',
              description: 'Качественное видео с продвинутыми эффектами, анимацией и звуком',
             
            }
          },
          'Рич': {
            name: 'Рич тариф',
            includes: [
              '3 варианта видео на выбор',
              '5 правок включены',
              'Все форматы + исходники',
              '3D/премиум эффекты, продвинутая анимация',
              'Профессиональный звук и цветокоррекция'
            ],
            example: {
              title: 'Пример премиум видео',
              description: 'Кинематографическое видео с премиум визуальными эффектами, звуком и цветокоррекцией',
              
            }
          }
        },
        // Совместимость со старыми названиями
        'Видео до 30 секунд': {
          'Базовый': {
            name: 'Базовый тариф',
            includes: [
              '1 вариант видео',
              '2 правки включены',
              'Экспорт MP4',
              'Базовые эффекты и переходы'
            ],
            example: {
              title: 'Пример базового видео',
              description: 'Короткое видео с базовыми переходами и простыми титрами'
            }
          },
          'Комфорт': {
            name: 'Комфорт тариф',
            includes: [
              '2 варианта видео на выбор',
              '3 правки включены',
              'MP4 + исходники проекта',
              'Расширенные эффекты, сложнее анимация',
              'Звуковое сопровождение'
            ],
            example: {
              title: 'Пример комфорт видео',
              description: 'Качественное видео с продвинутыми эффектами, анимацией и звуком',
              
            }
          },
          'Рич': {
            name: 'Рич тариф',
            includes: [
              '3 варианта видео на выбор',
              '5 правок включены',
              'Все форматы + исходники',
              '3D/премиум эффекты, продвинутая анимация',
              'Профессиональный звук и цветокоррекция'
            ],
            example: {
              title: 'Пример премиум видео',
              description: 'Кинематографическое видео с премиум визуальными эффектами, звуком и цветокоррекцией',
              
            }
          }
        }
      },
      // Новые данные для модального окна
      searchTerm: '',
      filteredWorkTypes: [],
      showImageModal: false,
      selectedImage: null
    }
  },
  computed: {
    filteredExecutors() {
      // Исключаем текущего пользователя из списка исполнителей
      const currentUserId = this.getCurrentUserId();
      return this.executors.filter(executor => executor.id !== currentUserId);
    },
    minDate() {
      // Минимальная дата - завтра от текущей даты
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      return tomorrow.toISOString().split('T')[0];
    }
  },
  mounted() {
    this.fetchWorkTypes();
    // Добавляем один пустой материал по умолчанию
    if (this.form.materials.length === 0) {
      this.addMaterial();
    }
    // Добавляем обработчик клавиши Escape
    document.addEventListener('keydown', this.handleKeydown);
  },
  
  beforeUnmount() {
    // Удаляем обработчик при размонтировании
    document.removeEventListener('keydown', this.handleKeydown);
  },
  watch: {
    workTypes: {
      handler(newWorkTypes) {
        this.filteredWorkTypes = newWorkTypes || [];
      },
      immediate: true
    },
    'form.slidesQuantity': {
      handler(newVal, oldVal) {
        this.calculateTotalPrice();
      },
      immediate: false
    }
  },
  methods: {
    getAssetUrl(name) {
      try {
        const url = new URL(`../assets/${name}`, import.meta.url).href;
        console.log(`Loading image: ${name} -> ${url}`);
        return url;
      } catch (error) {
        console.error(`Error loading image ${name}:`, error);
        return '#';
      }
    },
    
    openImageModal(imageName) {
      this.selectedImage = imageName;
      this.showImageModal = true;
    },
    
    closeImageModal() {
      this.showImageModal = false;
      this.selectedImage = null;
    },
    
    handleImageError(event) {
      console.error('Image failed to load:', event.target.src);
      // Можно добавить fallback изображение
      event.target.style.display = 'none';
    },
    closeModal() {
      console.log('Закрытие модального окна');
      if (this.step === 3) {
        // Если мы на шаге 3, просто закрываем модал
        this.$emit('close');
      } else {
        // Если мы на других шагах, сбрасываем форму
        this.resetForm();
        this.$emit('close');
      }
    },
    
    handleKeydown(event) {
      if (event.key === 'Escape') {
        this.closeModal();
      }
    },
    resetForm() {
      this.step = 1;
      this.selectedWorkType = null;
      this.form = {
        work_type_id: '',
        title: '',
        attributes: {},
        description: '',
        deadline: '',
        materials: [],
        slidesQuantity: 1,
      };
      // Добавляем один пустой материал по умолчанию
      this.addMaterial();
      this.errors = {};
      this.loading = false;
      this.executors = [];
      this.selectedExecutorId = null;
      this.createdOrder = null;
      this.selectedTariff = null;
      this.selectedServices = {};
      this.totalPrice = 0;
      this.tariffs = [];
      this.services = [];
      this.servicePrices = [];
    },
    async fetchWorkTypes() {
      try {
        const res = await this.$axios.get('/work-types')
        this.workTypes = res.data
        this.filteredWorkTypes = res.data // Инициализируем отфильтрованные типы
      } catch (error) {
        console.error('Ошибка загрузки типов работ:', error)
        this.workTypes = []
        this.filteredWorkTypes = []
      }
    },
    async fetchDynamicFields(workTypeId) {
      const { data: rawFields } = await this.$axios.get(`/work-types/${workTypeId}/attributes`)
      // Убираем дублирующее поле количества слайдов из динамических полей
      this.dynamicFields = (rawFields || []).filter(f => f.name !== 'slides_count');
      // Сбросить значения атрибутов при смене типа заказа
      this.form.attributes = {};
      
      // Загружаем тарифы после выбора типа работы
      await this.loadTariffData();
    },
    selectWorkType(type) {
      this.selectedWorkType = type;
      this.form.work_type_id = type.id;
      this.form.title = type.name;
      this.form.description = ''; // Очищаем поле описания, чтобы placeholder был виден
      this.errors = {};
      
      // Автоматический переход на второй шаг через задержку (как в тестовом файле)
      setTimeout(() => {
        this.step = 2;
        this.fetchDynamicFields(type.id);
      }, 500);
    },

    // Новые методы для навигации
    goToNextStep() {
      if (this.step === 1 && this.selectedWorkType) {
        this.step = 2;
        this.fetchDynamicFields(this.selectedWorkType.id);
      }
    },

    goToPrevStep() {
      if (this.step > 1) {
        this.step--;
      }
    },

    // Метод для поиска типов работы
    filterWorkTypes() {
      if (!this.searchTerm) {
        this.filteredWorkTypes = this.workTypes;
        return;
      }
      
      const searchTerm = this.searchTerm.toLowerCase();
      this.filteredWorkTypes = this.workTypes.filter(type => {
        return type.name.toLowerCase().includes(searchTerm) ||
               type.description.toLowerCase().includes(searchTerm);
      });
    },
    getWorkTypeIcon(type) {
      if (!type) return '';
      if (type.image) {
        try {
          return new URL(`../assets/${type.image}`, import.meta.url).href;
        } catch {
          return new URL('../assets/orders.png', import.meta.url).href;
        }
      }
      return new URL('../assets/orders.png', import.meta.url).href;
    },
    
          async loadTariffData() {
        if (!this.selectedWorkType?.id) return;
        
        try {
          this.tariffLoading = true;
          this.tariffError = null;
          
          // Загружаем тарифы
          const { data: tariffs } = await this.$axios.get('/tariffs')
          this.tariffs = tariffs
          
          // Загружаем услуги для выбранного типа работы
          const { data: servicesData } = await this.$axios.get(`/tariffs/work-type/${this.selectedWorkType.id}/services`)
          this.services = servicesData.services || []
          
          // Инициализируем selectedServices для каждой услуги
          this.services.forEach(service => {
            if (!this.selectedServices[service.id]) {
              this.selectedServices[service.id] = {
                enabled: false,
                tariffId: null
              };
            }
          });
          
          // Автоматически выбираем первый тариф по умолчанию
          if (this.tariffs.length > 0 && !this.selectedTariff) {
            this.selectedTariff = this.tariffs[0];
          }
          
          // Рассчитываем базовую цену
          this.calculateTotalPrice();
          
        } catch (error) {
          console.error('Ошибка загрузки тарифных данных:', error);
          this.tariffError = error.message;
          this.tariffs = [];
          this.services = [];
          this.selectedTariff = null;
          this.selectedServices = {};
        } finally {
          this.tariffLoading = false;
        }
      },
    
          calculateTotalPrice() {
      let total = 0;
      
      for (const [serviceId, serviceData] of Object.entries(this.selectedServices)) {
        
        if (serviceData.enabled && serviceData.tariffId) {
          const priceNum = Number(this.getServicePrice(parseInt(serviceId), parseInt(serviceData.tariffId))) || 0;
          const service = this.services.find(s => s.id === parseInt(serviceId));
          
          if (this.selectedWorkType?.name === 'Дизайн карточки для МП' && service && service.name === '1 слайд в карточке') {
            const quantity = parseInt(this.form.slidesQuantity) || 1;
            total += priceNum * quantity;
          } else {
            total += priceNum;
          }
        }
      }
      
      this.totalPrice = Math.round((Number(total) || 0) * 100) / 100;
    },
    
    addMaterial() {
      this.form.materials.push({ type: '', description: '', file_url: '' });
    },
    removeMaterial(idx) {
      this.form.materials.splice(idx, 1);
    },
    
    // Нормализация URL - добавляем https:// если протокол отсутствует
    normalizeUrl(url) {
      if (!url || url.trim() === '') return '';
      const trimmedUrl = url.trim();
      if (!/^https?:\/\//.test(trimmedUrl)) {
        return 'https://' + trimmedUrl;
      }
      return trimmedUrl;
    },
    async submitOrder() {
      this.errors = this.validateForm();
      if (Object.keys(this.errors).length > 0) return;
      this.loading = true;
      try {
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        // Собираем массив attributes с value_id для select и value для input
        const attributes = this.dynamicFields.map(field => {
          const value = this.form.attributes[field.id];
          if (field.values && field.values.length) {
            // select: value_id должен быть выбран
            return { attribute_type_id: field.id, value_id: value };
          } else {
            // input: value_id не нужен, можно добавить value (если потребуется на бэке)
            return { attribute_type_id: field.id, value: value };
          }
        });
        const materials = this.form.materials
          .filter(m => m.type || m.description || m.file_url)
          .map(m => ({
            ...m,
            file_url: m.file_url ? this.normalizeUrl(m.file_url) : ''
          }));
        const calculatedPrice = this.totalPrice || 1000;
        const body = {
          user_id: user.id,
          work_type_id: this.form.work_type_id,
          title: this.form.title || (this.selectedWorkType ? this.selectedWorkType.name : 'Без названия'),
          description: this.form.description,
          deadline: this.form.deadline,
          budget: calculatedPrice,
          attributes,
          materials: materials,
          // добавлено: данные тарифной системы и слайды
          selected_services: this.selectedServices,
          calculated_price: calculatedPrice,
          slides_quantity: this.selectedWorkType?.name === 'Дизайн карточки для МП' ? this.form.slidesQuantity : null
        };
        
        console.log('Отправляем данные заказа:', body);
        console.log('Материалы для отправки:', materials);
        const { data: orderData } = await this.$axios.post('/orders', body)
        
        this.createdOrder = {
          ...orderData,
          title: this.selectedWorkType.name,
          description: this.form.description,
          average_time: this.selectedWorkType.average_time,
          average_price: this.selectedWorkType.average_price,
          image: this.selectedWorkType.image
        };
        
        // Загружаем исполнителей и переходим к шагу 3
        await this.loadExecutors();
        this.step = 3;
        
        // НЕ сбрасываем форму, чтобы данные остались для шага 3
        this.loading = false;
        
        this.$emit('order-created');
      } catch (e) {
        alert(e.message || 'Ошибка создания заказа');
      } finally {
        this.loading = false;
      }
    },
    validateForm() {
      const errors = {};
      
      // Проверка минимальной даты
      if (this.form.deadline) {
        const selectedDate = new Date(this.form.deadline);
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        tomorrow.setHours(0, 0, 0, 0); // Сбрасываем время
        selectedDate.setHours(0, 0, 0, 0); // Сбрасываем время
        
        if (selectedDate < tomorrow) {
          errors.deadline = 'Дата выполнения должна быть не раньше завтрашнего дня';
        }
      }
      
      return errors;
    },
    
    editCreatedOrder() {
      // Возвращаемся к редактированию заказа
      this.showExecutorsModal = false;
      this.step = 2;
      // Восстанавливаем данные формы
      this.selectedWorkType = this.createdOrder;
      this.form.work_type_id = this.createdOrder.id;
      this.form.title = this.createdOrder.title;
      this.form.description = this.createdOrder.description;
    },
    

    
    compareExecutors() {
      // Логика для сравнения исполнителей
      alert('Функция сравнения исполнителей будет реализована позже');
    },
    
    async selectExecutor(executorId) {
      try {
        this.loading = true;
        
        // Создаем заказ с исполнителем
        const order = await this.createOrder(executorId);
        
        // Закрываем окно создания заказа
        this.$emit('close');
        this.$emit('order-created', order);
        
        // Показываем уведомление
        alert('Заказ успешно создан и отправлен исполнителю на согласование!');
      } catch (error) {
        console.error('Ошибка создания заказа с исполнителем:', error);
        alert('Ошибка создания заказа: ' + error.message);
      } finally {
        this.loading = false;
      }
    },

    async createOrderWithoutExecutor() {
      this.loading = true;
      
      try {
        // Создаем заказ без исполнителя
        const order = await this.createOrder();
        
        // Закрываем модальное окно и обновляем список заказов
        this.$emit('close');
        this.$emit('order-created', order);
        
        // Показываем уведомление
        alert('Заказ создан успешно!');
      } catch (error) {
        console.error('Ошибка создания заказа:', error);
        alert('Ошибка создания заказа: ' + error.message);
      } finally {
        this.loading = false;
      }
    },

    async createOrder(executorId = null) {
      const user = JSON.parse(localStorage.getItem('user') || '{}');
      
      // Собираем массив attributes с value_id для select и value для input
      const attributes = this.dynamicFields.map(field => {
        const value = this.form.attributes[field.id];
        if (field.values && field.values.length && value) {
          return { attribute_type_id: field.id, value_id: value };
        } else if (value) {
          return { attribute_type_id: field.id, value: value };
        }
        // Если значение не заполнено, пропускаем атрибут
        return null;
      }).filter(attr => attr !== null); // Убираем пустые атрибуты
      
      const materials = this.form.materials
        .filter(m => m.type || m.description || m.file_url)
        .map(m => ({
          ...m,
          file_url: m.file_url ? this.normalizeUrl(m.file_url) : ''
        }));
      
      // Используем данные из новой системы выбора тарифов
const calculatedPrice = this.totalPrice || 1000;
       
      const body = {
        user_id: user.id,
        work_type_id: this.form.work_type_id || 1,
        title: this.form.title || (this.selectedWorkType ? this.selectedWorkType.name : 'Тестовый заказ'),
        description: this.form.description || 'Описание заказа',
        deadline: this.form.deadline || new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
        budget: calculatedPrice, // Используем рассчитанную цену
        attributes: attributes || [],
        materials: materials,
        executor_id: executorId,
        status: executorId ? 'pending_approval' : 'open', // Если есть исполнитель - статус "На согласовании", иначе "Открыт"
        selected_services: this.selectedServices, // {serviceId: {enabled: boolean, tariffId: number}}
        calculated_price: calculatedPrice,
        slides_quantity: this.selectedWorkType?.name === 'Дизайн карточки для МП' ? this.form.slidesQuantity : null
      };
      
      console.log('Данные заказа перед отправкой (createOrder):', body);
      console.log('Материалы для отправки (createOrder):', materials);
      
      const { data } = await this.$axios.post('/orders', body)
      return data
    },

    async createOrderWithExecutor(executorId) {
      return await this.createOrder(executorId);
    },

    async loadExecutors() {
      try {
        // Определяем специализацию на основе типа заказа
        const specialization = this.getSpecializationFromOrder();
        console.log('Loading executors for specialization:', specialization);
        
        try {
          const { data } = await this.$axios.get(`/executors/by-specialization`, { 
            params: { specialization },
            timeout: 10000 // 10 секунд timeout
          })
          console.log('Executors loaded:', data);
          this.executors = Array.isArray(data) ? data : []
        } catch (error) {
          console.error('Ошибка загрузки исполнителей:', error);
          console.error('Error details:', error.response?.data);
          console.log('Используем мок-данные');
          // Показываем тестовые данные
          this.executors = this.getMockExecutors();
        }
      } catch (error) {
        console.error('Общая ошибка:', error);
        this.executors = this.getMockExecutors();
      }
    },
    
    getSpecializationFromOrder() {
      // Маппинг типов заказов на специализации
      const orderTypeToSpecialization = {
        'Дизайн карточки для МП': 'mp_card_design',
        'Видео': 'video',
        'Видео до 30 секунд': 'video',
        'Цветокоррекция фото': 'color_correction',
        'Оформление сторис': 'social_media',
        'Дизайн визитки': 'business_card_design'
      };
      
      return orderTypeToSpecialization[this.selectedWorkType?.name] || 'graphic_design';
    },
    
    getMockExecutors() {
      return [
        {
          id: 1,
          name: 'Станислав Пузынин',
          avatar: '',
          completed_orders: 12,
          hourly_rate: 500,
          is_verified: true,
          specializations: ['mp_card_design', 'business_card_design']
        },
        {
          id: 2,
          name: 'тестовый тест',
          avatar: '',
          completed_orders: 8,
          hourly_rate: 500,
          is_verified: true,
          specializations: ['business_card_design', 'mp_card_design']
        },
        {
          id: 3,
          name: 'Второй Тестовый',
          avatar: '',
          completed_orders: 15,
          hourly_rate: 500,
          is_verified: true,
          specializations: ['mp_card_design']
        }
      ];
    },

    async loadExecutorsByWorkType() {
      try {
        const token = localStorage.getItem('token');
        const specialization = this.getSpecializationFromWorkType(this.selectedWorkType.name);
        
        try {
          const { data } = await this.$axios.get(`/executors/by-specialization`, { params: { specialization } })
          this.executors = data
        } catch (e) {
          console.error('Ошибка загрузки исполнителей:', e?.message)
          this.executors = this.getMockExecutors()
        }
      } catch (error) {
        console.error('Ошибка:', error);
        this.executors = this.getMockExecutors();
      }
    },

    getSpecializationFromWorkType(workTypeName) {
      const workTypeToSpecialization = {
        'Дизайн карточки для МП': 'mp_card_design',
        'Видео': 'video',
        'Видео до 30 секунд': 'video',
        'Цветокоррекция фото': 'color_correction',
        'Оформление сторис': 'social_media',
        'Дизайн визитки': 'business_card_design'
      };
      
      return workTypeToSpecialization[workTypeName] || 'graphic_design';
    },

    getSpecializationLabel(spec) {
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
      return specializationMap[spec] || spec;
    },

    getMockExecutors() {
      return [
        {
          id: 1,
          name: 'Станислав Пузынин',
          avatar: '',
          completed_orders: 12,
          hourly_rate: 500,
          is_verified: true,
          specializations: ['mp_card_design', 'business_card_design']
        },
        {
          id: 2,
          name: 'тестовый тест',
          avatar: '',
          completed_orders: 8,
          hourly_rate: 500,
          is_verified: true,
          specializations: ['business_card_design', 'mp_card_design']
        },
        {
          id: 3,
          name: 'Второй Тестовый',
          avatar: '',
          completed_orders: 15,
          hourly_rate: 500,
          is_verified: true,
          specializations: ['mp_card_design']
        }
      ];
    },

    getExecutorAvatar(executor) {
      const avatar = (executor && executor.avatar) || '';
      if (!avatar) return this.performerIcon;
      // Игнорируем заглушки типа default-avatar
      if (typeof avatar === 'string' && avatar.toLowerCase().includes('default-avatar')) {
        return this.performerIcon;
      }
      // Пропускаем валидные абсолютные URL и data URI
      if (/^(https?:)?\/\//i.test(avatar) || avatar.startsWith('data:')) return avatar;
      try {
        // Преобразуем возможные относительные пути в абсолютные
        const url = new URL(avatar, window.location.origin);
        return url.href;
      } catch {
        return this.performerIcon;
      }
    },
    onAvatarError(e) {
      e.target.src = this.performerIcon;
    },

    selectTariff(tariff) {
      this.selectedTariff = tariff;
      this.calculateTotalPrice();
    },

          getServicePrice(serviceId, tariffId) {
      const service = this.services.find(s => s.id === serviceId);
      if (!service || !service.prices) {
        return 0;
      }
      const raw = service.prices[tariffId];
      const price = typeof raw === 'string' ? parseFloat(raw) : Number(raw || 0);
      return Number.isFinite(price) ? price : 0;
    },

    formatPrice(price) {
      return Math.round(Number(price) || 0).toString();
    },

    async goToStep3() {
      const errors = this.validateForm();
      if (Object.keys(errors).length > 0) {
        this.errors = errors;
        return;
      }

      // Проверяем, что выбрана хотя бы одна услуга
      const hasSelectedServices = this.getSelectedServicesForDisplay().length > 0;
      if (!hasSelectedServices) {
        alert('Пожалуйста, выберите хотя бы одну услугу перед переходом к выбору исполнителя');
        return;
      }
      
      this.loading = true;
      
      try {
        // Загружаем исполнителей и переходим к шагу 3
        await this.loadExecutors();
        this.step = 3;
      } catch (error) {
        alert('Ошибка: ' + error.message);
      } finally {
        this.loading = false;
      }
    },

          selectServiceTariff(serviceId, tariffId) {
      if (!this.selectedServices[serviceId]) {
        this.selectedServices[serviceId] = { enabled: false, tariffId: null };
      }
      
      const lastSelectedKey = `service-${serviceId}`;
      const currentSelection = `${serviceId}-${tariffId}`;
      
      // Если кликнули на уже выбранный элемент, отменяем выбор
      if (this.lastSelected[lastSelectedKey] === currentSelection && this.selectedServices[serviceId].enabled) {
        this.selectedServices[serviceId].enabled = false;
        this.selectedServices[serviceId].tariffId = null;
        delete this.lastSelected[lastSelectedKey];
      } else {
        // Для визиток - отключаем все остальные услуги (только одна может быть активна)
        if (this.selectedWorkType?.name === 'Дизайн визитки') {
          for (const [id, serviceData] of Object.entries(this.selectedServices)) {
            if (parseInt(id) !== parseInt(serviceId)) {
              serviceData.enabled = false;
              serviceData.tariffId = null;
              delete this.lastSelected[`service-${id}`];
            }
          }
        }
        
        // Устанавливаем новый выбор
        this.selectedServices[serviceId].tariffId = tariffId;
        this.selectedServices[serviceId].enabled = true;
        this.lastSelected[lastSelectedKey] = currentSelection;
      }
      
      this.calculateTotalPrice();
    },

    toggleService(serviceId) {
      if (!this.selectedServices[serviceId]) {
        this.selectedServices[serviceId] = { enabled: false, tariffId: null };
      }
      
      if (this.selectedWorkType?.name === 'Дизайн визитки') {
        for (const [id, serviceData] of Object.entries(this.selectedServices)) {
          if (parseInt(id) !== parseInt(serviceId)) {
            serviceData.enabled = false;
            serviceData.tariffId = null;
          }
        }
        this.selectedServices[serviceId].enabled = true;
      } else {
        this.selectedServices[serviceId].enabled = !this.selectedServices[serviceId].enabled;
        if (!this.selectedServices[serviceId].enabled) {
          this.selectedServices[serviceId].tariffId = null;
        } else if (!this.selectedServices[serviceId].tariffId) {
          // Автовыбор тарифа по умолчанию при включении услуги
          this.selectedServices[serviceId].tariffId = this.tariffs[0]?.id || null;
        }
      }
      
      this.calculateTotalPrice();
    },

    getCurrentUserId() {
      const user = JSON.parse(localStorage.getItem('user') || '{}');
      return user.id;
    },
    
    // Методы для управления подсказками
    toggleTooltip(tariff) {
      // Кликаем по заголовку тарифа: показываем/скрываем подсказку
      if (!this.shouldShowTooltip(tariff)) return
      if (this.hoveredTariff && this.hoveredTariff.id === tariff.id) {
        this.hoveredTariff = null
        this.tooltipVisible = false
      } else {
        this.hoveredTariff = tariff
        this.tooltipVisible = true
      }
    },
    
    shouldShowTooltip(tariff) {
      // Работает по названию и/или по ID, чтобы не зависеть от конкретного числа
      const byId = this.selectedWorkType?.id && this.tooltipData[this.selectedWorkType.id] && this.tooltipData[this.selectedWorkType.id][tariff.id]
      const byName = this.selectedWorkType?.name && this.tooltipDataByName[this.selectedWorkType.name] && this.tooltipDataByName[this.selectedWorkType.name][this.getTooltipKey(tariff)]
      return Boolean(byId || byName)
    },
    
    getTooltipData(tariff) {
      if (!tariff) return null
      if (!this.shouldShowTooltip(tariff)) return null
      const byId = this.selectedWorkType?.id && this.tooltipData[this.selectedWorkType.id] && this.tooltipData[this.selectedWorkType.id][tariff.id]
      if (byId) return byId
      const byName = this.selectedWorkType?.name && this.tooltipDataByName[this.selectedWorkType.name] && this.tooltipDataByName[this.selectedWorkType.name][this.getTooltipKey(tariff)]
      return byName || null
    },

    getTooltipKey(tariff) {
      // Нормализуем названия: "Базовый тариф" -> "Базовый", и т.п.
      const name = (tariff?.name || '').toLowerCase()
      if (name.includes('базов')) return 'Базовый'
      if (name.includes('комфорт')) return 'Комфорт'
      if (name.includes('rich') || name.includes('рич')) return 'Рич'
      // fallback: вернуть исходное название
      return tariff?.name
    },
    
    // Методы для управления выбранными услугами
    removeService(serviceId) {
      if (this.selectedServices[serviceId]) {
        this.selectedServices[serviceId].enabled = false;
        this.selectedServices[serviceId].tariffId = null;
        delete this.lastSelected[`service-${serviceId}`];
        this.calculateTotalPrice();
      }
    },
    
    getSelectedServicesForDisplay() {
      const selected = [];
      Object.keys(this.selectedServices).forEach(serviceId => {
        const serviceData = this.selectedServices[serviceId];
        if (serviceData.enabled && serviceData.tariffId) {
          const service = this.services.find(s => s.id === parseInt(serviceId));
          const tariff = this.tariffs.find(t => t.id === serviceData.tariffId);
          if (service && tariff) {
            selected.push({
              serviceId: parseInt(serviceId),
              serviceName: service.name,
              tariffName: tariff.name,
              price: this.getServicePrice(parseInt(serviceId), serviceData.tariffId)
            });
          }
        }
      });
      return selected;
    },
  }
}
</script>

<style scoped>
/* Модальное окно */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(8px);
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 1;
  visibility: visible;
  transition: all 0.3s ease;
}

.modal-window {
  background: #071727;
  border: 1px solid rgba(71, 85, 105, 0.5);
  border-radius: 24px;
  width: 90%;
  max-width: 1200px;
  height: fit-content;
  max-height: 85vh;
  overflow: hidden;
  backdrop-filter: blur(20px);
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
  transform: scale(1);
  transition: transform 0.3s ease;
}

.modal-header {
  padding: 20px 30px 15px;
  border-bottom: 1px solid rgba(71, 85, 105, 0.3);
  text-align: center;
  position: relative;
}

.modal-close {
  position: absolute;
  top: 20px;
  right: 25px;
  background: rgba(71, 85, 105, 0.2);
  border: 2px solid rgba(71, 85, 105, 0.3);
  color: #94a3b8;
  font-size: 24px;
  cursor: pointer;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.modal-close:hover {
  background: rgba(239, 68, 68, 0.2);
  border-color: rgba(239, 68, 68, 0.4);
  color: #fca5a5;
  transform: scale(1.1);
}

.modal-close:active {
  transform: scale(0.95);
}

.modal-title {
  color: #60a5fa;
  font-size: 26px;
  margin-bottom: 6px;
  font-weight: 700;
}

.modal-subtitle {
  color: #94a3b8;
  font-size: 16px;
}

.modal-body {
  padding: 0;
  height: auto;
  min-height: 400px;
  max-height: calc(85vh - 160px);
  overflow-y: auto;
}

/* Индикатор шагов */
.steps-indicator {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 10px;
  padding: 0 30px;
}

.step-indicator {
  display: flex;
  align-items: center;
  color: #64748b;
  font-size: 14px;
  font-weight: 500;
}

.step-indicator.active {
  color: #3b82f6;
}

.step-indicator.completed {
  color: #10b981;
}

.step-number {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: #374151;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12px;
  font-weight: 600;
  font-size: 16px;
}

.step-indicator.active .step-number {
  background: #3b82f6;
  color: white;
  font-weight: 700;
}

.step-indicator.completed .step-number {
  background: #10b981;
  color: white;
  font-weight: 700;
}

.step-indicator .step-number {
  background: #374151;
  color: #9ca3af;
  font-weight: 600;
}

.step-connector {
  width: 80px;
  height: 2px;
  background: #374151;
  margin: 0 20px;
}

.step-indicator.completed + .step-indicator .step-connector {
  background: #10b981;
}

/* Шаги в модальном окне */
.step-container {
  padding: 20px 30px;
  min-height: 400px;
}

.step-content {
  display: none;
}

.step-content.active {
  display: block;
}

/* Шаг 1 - Выбор типа работы */
.work-type-selection {
  padding: 0;
}

.work-type-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding: 0 10px;
}

.work-type-title {
  color: #f1f5f9;
  font-size: 20px;
  font-weight: 600;
  margin: 0;
}

.search-box {
  position: relative;
  width: 300px;
}

.search-input {
  width: 100%;
  background: rgba(15, 23, 42, 0.8);
  border: 2px solid rgba(71, 85, 105, 0.5);
  border-radius: 16px;
  padding: 14px 16px 14px 50px;
  color: white;
  font-size: 16px;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.search-input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
  background: rgba(15, 23, 42, 0.9);
}

.search-input::placeholder {
  color: #64748b;
  font-size: 16px;
}

.search-icon {
  position: absolute;
  left: 18px;
  top: 50%;
  transform: translateY(-50%);
  color: #64748b;
  font-size: 18px;
  transition: color 0.3s ease;
}

.search-input:focus + .search-icon {
  color: #3b82f6;
}

/* Сетка карточек - 2 колонки для двух типов заказов */
.work-type-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  padding: 0 10px;
  max-width: 800px;
  margin: 0 auto;
}

.work-type-card {
  background: rgba(51, 65, 85, 0.6);
  border: 2px solid rgba(71, 85, 105, 0.3);
  border-radius: 16px;
  padding: 20px 15px;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: left;
  position: relative;
  backdrop-filter: blur(10px);
  min-height: 140px;
  display: flex;
  flex-direction: column;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.work-type-card:hover {
  background: rgba(59, 130, 246, 0.1);
  border-color: #3b82f6;
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(59, 130, 246, 0.2);
}

.work-type-card.selected {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(37, 99, 235, 0.1));
  border-color: #3b82f6;
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(59, 130, 246, 0.3);
}

.work-type-card:active {
  transform: translateY(-1px);
  transition: transform 0.1s ease;
}

.work-type-card-header {
  display: flex;
  align-items: flex-start;
  margin-bottom: 12px;
}

.work-type-icon {
  width: 50px;
  height: 50px;
  background: rgba(71, 85, 105, 0.4);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  margin-right: 15px;
  flex-shrink: 0;
}

.work-type-info {
  flex: 1;
}

.work-type-name {
  color: #f1f5f9;
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 4px;
  line-height: 1.3;
}

.work-type-desc {
  color: #94a3b8;
  font-size: 12px;
  line-height: 1.4;
  margin-bottom: 8px;
}

.work-type-details {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: auto;
}

.work-type-time {
  color: #64748b;
  font-size: 11px;
}

.work-type-price {
  color: #f1f5f9;
  font-weight: 600;
  font-size: 14px;
}

/* Состояния загрузки */
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(59, 130, 246, 0.3);
  border-top: 3px solid #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 20px;
}

.loading-spinner.small {
  width: 20px;
  height: 20px;
  margin-bottom: 0;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-text {
  color: #94a3b8;
  font-size: 16px;
  margin: 0;
}

.empty-state {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 60px 20px;
  text-align: center;
}

.empty-text {
  color: #64748b;
  font-size: 16px;
  margin: 0;
}

/* Шаг 2 - Форма с тарифами */
.order-form {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 25px;
  height: 100%;
  min-height: 400px;
}

.form-section {
  overflow-y: auto;
  max-height: calc(90vh - 260px);
  padding-bottom: 0;
  height: 100%;
}

.form-content {
  padding-bottom: 0;
}

.summary-section {
  display: flex;
  flex-direction: column;
  gap: 15px;
  flex-shrink: 0;
}

/* Правая панель - Итоги */
.summary-card {
  background: rgba(30, 41, 59, 0.8);
  border: 1px solid rgba(71, 85, 105, 0.3);
  border-radius: 16px;
  padding: 15px;
  height: fit-content;
}

.summary-title {
  color: #f1f5f9;
  font-size: 16px;
  font-weight: 700;
  margin-bottom: 12px;
  text-align: center;
}

.order-preview {
  margin-bottom: 0;
}

.preview-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 6px;
  padding: 4px 0;
  border-bottom: 1px solid rgba(71, 85, 105, 0.2);
}

.preview-item:last-child {
  margin-bottom: 0;
  border-bottom: none;
}

.preview-label {
  color: #94a3b8;
  font-size: 13px;
}

.preview-value {
  color: #f1f5f9;
  font-weight: 500;
  font-size: 13px;
}

/* Выбранные услуги */
.selected-services {
  background: rgba(6, 78, 59, 0.3);
  border: 1px solid #10b981;
  border-radius: 12px;
  padding: 15px;
  margin-bottom: 18px;
}

.selected-services-title {
  color: #10b981;
  font-weight: 600;
  margin-bottom: 12px;
  font-size: 14px;
}

.selected-services-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.selected-service {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: rgba(16, 185, 129, 0.1);
  padding: 8px;
  border-radius: 8px;
  margin-bottom: 6px;
}

.service-info {
  flex: 1;
}

.service-name {
  color: #f1f5f9;
  font-weight: 500;
  font-size: 13px;
}

.service-details {
  color: #10b981;
  font-size: 11px;
}

.remove-btn {
  background: #ef4444;
  border: none;
  color: white;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
}

.remove-btn:hover {
  background: #dc2626;
  transform: scale(1.1);
}

/* Итоговая цена */
.total-price {
  background: linear-gradient(135deg, #10b981, #059669);
  border-radius: 12px;
  padding: 16px;
  text-align: center;
  margin-bottom: 20px;
}

.total-label {
  color: rgba(255, 255, 255, 0.8);
  font-size: 13px;
  margin-bottom: 6px;
}

.total-amount {
  color: white;
  font-size: 22px;
  font-weight: 700;
}



/* Стили кнопок */
.btn {
  padding: 12px 24px;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-primary {
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(59, 130, 246, 0.3);
}

.btn-secondary {
  background: rgba(71, 85, 105, 0.6);
  color: #e2e8f0;
  border: 1px solid rgba(71, 85, 105, 0.5);
}

.btn-secondary:hover {
  background: rgba(71, 85, 105, 0.8);
  transform: translateY(-2px);
}

.btn-success {
  background: linear-gradient(135deg, #10b981, #059669);
  color: white;
}

.btn-success:hover:not(:disabled) {
  background: linear-gradient(135deg, #059669, #047857);
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(16, 185, 129, 0.3);
}

/* Адаптивные стили для разрешения 1280x720 и похожих */
@media (min-width: 1200px) and (max-width: 1366px) and (max-height: 768px) {
  .modal-window {
    width: 95%;
    max-width: 1300px;
    max-height: 85vh;
  }
  
  .order-form {
    grid-template-columns: 1fr 300px;
    gap: 20px;
    min-height: 350px;
  }
  
  .summary-section {
    gap: 15px;
  }
  
  .form-section {
    max-height: calc(85vh - 200px);
    min-height: calc(85vh - 200px);
  }
  
  .modal-header {
    padding: 15px 30px 10px;
  }
  
  .modal-title {
    font-size: 24px;
    margin-bottom: 4px;
  }
  
  .steps-indicator {
    margin-bottom: 8px;
  }
  
  .step-container {
    padding: 15px 30px;
    min-height: 350px;
  }
  
  .modal-body {
    height: auto;
    min-height: 350px;
    max-height: calc(85vh - 120px);
  }
  
  .tariff-table th,
  .tariff-table td {
    padding: 14px 10px;
    font-size: 1rem;
  }
  
  .tariff-table {
    font-size: 1rem;
  }
  
  .tariff-table input[type="checkbox"],
  .tariff-table input[type="radio"] {
    width: 18px;
    height: 18px;
  }
  
  .order-section {
    padding: 20px;
  }
  
  .section-title {
    font-size: 1.3rem;
    margin-bottom: 1rem;
  }
  
  .summary-card {
    padding: 12px;
  }
  
  .selected-services {
    padding: 16px;
  }
  
  .summary-title {
    font-size: 1rem;
    margin-bottom: 10px;
  }
  
  .preview-item {
    padding: 3px 0;
    font-size: 0.9rem;
    margin-bottom: 4px;
  }
  
  .selected-service {
    padding: 10px;
    margin-bottom: 8px;
  }
}

/* Адаптивные стили для средних экранов */
@media (min-width: 769px) and (max-width: 1199px) {
  .modal-window {
    width: 92%;
    max-width: 1100px;
  }
  
  .order-form {
    grid-template-columns: 1fr 380px;
    gap: 25px;
  }
}

/* Адаптивные стили */
@media (max-width: 768px) {
  .modal-window {
    width: 98%;
    max-height: 98vh;
    border-radius: 20px;
  }
  
  .modal-header {
    padding: 24px 20px 20px;
  }
  
  .modal-title {
    font-size: 22px;
    margin-bottom: 8px;
  }
  
  .modal-subtitle {
    font-size: 14px;
  }
  
  .step-container {
    padding: 20px;
  }
  
  .steps-indicator {
    flex-direction: column;
    gap: 12px;
    padding: 0 20px;
    margin-bottom: 20px;
    align-items: flex-start;
  }
  
  .step-indicator {
    flex-direction: row;
    align-items: center;
    width: 100%;
    font-size: 14px;
  }
  
  .step-connector {
    width: 2px;
    height: 16px;
    margin: 4px 0;
    align-self: center;
  }
  
  .step-number {
    width: 32px;
    height: 32px;
    font-size: 14px;
    margin-right: 10px;
    color: #fff;
    font-weight: 600;
  }
  
  .search-box {
    width: 100%;
    margin-top: 15px;
  }
  
  .search-input {
    padding: 16px 16px 16px 50px;
    font-size: 16px;
    border-radius: 12px;
  }
  
  .search-icon {
    font-size: 20px;
  }
  
  .work-type-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
  
  .work-type-grid {
    grid-template-columns: 1fr;
    gap: 15px;
    padding: 0 5px;
  }
  
  .order-form {
    grid-template-columns: 1fr;
    gap: 20px;
  }
  
  .summary-section {
    order: -1;
    margin-bottom: 20px;
  }
  
  .form-section {
    max-height: 60vh;
    overflow-y: auto;
  }
  
  .form-content {
    padding: 0;
  }
  
  .form-content input,
  .form-content textarea,
  .form-content select {
    font-size: 16px;
    padding: 14px;
    border-radius: 16px;
  }
  
  .form-content label {
    font-size: 15px;
    margin-bottom: 8px;
    font-weight: 600;
  }
  
  .btn {
    flex: 1;
    max-width: none;
    padding: 14px 20px;
    font-size: 16px;
    border-radius: 14px;
  }
  
  .order-section {
    padding: 20px;
    margin-bottom: 20px;
    border-radius: 20px;
  }
  
  .section-title {
    font-size: 18px;
    margin-bottom: 15px;
  }
  
  .characteristics-grid-wide {
    grid-template-columns: 1fr;
    gap: 15px;
  }
  
  .characteristic-item-wide {
    padding: 20px;
    border-radius: 16px;
  }
  
  .materials-section {
    padding: 20px;
    border-radius: 20px;
  }
  
  .material-item {
    margin-bottom: 20px;
  }
  
  .material-fields {
    gap: 15px;
  }
  
  .material-field input,
  .material-field textarea {
    padding: 14px;
    border-radius: 12px;
    font-size: 16px;
  }
  
  .add-material-btn {
    padding: 14px 20px;
    border-radius: 14px;
    font-size: 16px;
    font-weight: 600;
  }
  
  .tariff-table {
    font-size: 14px;
  }
  
  .tariff-table th,
  .tariff-table td {
    padding: 10px 8px;
  }
  
  .tariff-table input[type="checkbox"],
  .tariff-table input[type="radio"] {
    width: 20px;
    height: 20px;
  }
  
  .summary-card {
    padding: 20px;
    border-radius: 20px;
  }
  
  .selected-services {
    padding: 20px;
    border-radius: 16px;
  }
  
  .selected-service {
    padding: 12px;
    border-radius: 12px;
  }
}

@media (max-width: 480px) {
  .modal-window {
    width: 100%;
    height: 100vh;
    max-height: 100vh;
    border-radius: 0;
  }
  
  .modal-header {
    padding: 20px 16px 16px;
  }
  
  .modal-title {
    font-size: 20px;
  }
  
  .modal-subtitle {
    font-size: 13px;
  }
  
  .step-container {
    padding: 16px;
    min-height: auto;
  }
  
  .steps-indicator {
    padding: 0 16px;
    gap: 10px;
  }
  
  .step-number {
    width: 28px;
    height: 28px;
    font-size: 12px;
  }
  
  .work-type-card {
    min-height: 110px;
    padding: 16px;
    border-radius: 16px;
  }
  
  .work-type-icon {
    width: 36px;
    height: 36px;
  }
  
  .work-type-name {
    font-size: 14px;
    font-weight: 600;
  }
  
  .work-type-desc {
    font-size: 12px;
  }
  
  /* Улучшенные стили для мобильных форм */
  .form-section {
    max-height: 65vh;
    overflow-y: auto;
  }
  
  .form-content {
    padding: 0;
  }
  
  .form-content input,
  .form-content textarea,
  .form-content select {
    font-size: 16px; /* Предотвращает зум на iOS */
    padding: 16px;
    border-radius: 16px;
    border-width: 2px;
  }
  
  .form-content label {
    font-size: 15px;
    margin-bottom: 8px;
    font-weight: 600;
  }
  
  /* Улучшенные кнопки для мобильных */
  .form-actions {
    position: sticky;
    bottom: 0;
    background: #0D1F31;
    border-top: 2px solid #22304a;
    padding: 20px 16px;
    margin: 0 -16px -16px -16px;
    border-radius: 0 0 20px 20px;
  }
  
  .form-actions button {
    padding: 16px 24px;
    font-size: 16px;
    border-radius: 16px;
    font-weight: 600;
  }
  
  /* Улучшенная тарифная таблица */
  .tariff-table {
    font-size: 13px;
    border-radius: 16px;
  }
  
  .tariff-table th,
  .tariff-table td {
    padding: 12px 8px;
  }
  
  .tariff-table input[type="checkbox"],
  .tariff-table input[type="radio"] {
    width: 22px;
    height: 22px;
  }
  
  .order-section {
    padding: 16px;
    margin-bottom: 16px;
    border-radius: 16px;
  }
  
  .section-title {
    font-size: 16px;
    margin-bottom: 12px;
  }
  
  .characteristic-item-wide {
    padding: 16px;
    border-radius: 16px;
  }
  
  .materials-section {
    padding: 16px;
    border-radius: 16px;
  }
  
  .material-item {
    margin-bottom: 16px;
  }
  
  .material-field input,
  .material-field textarea {
    padding: 16px;
    border-radius: 12px;
    font-size: 16px;
  }
  
  .add-material-btn {
    padding: 16px 24px;
    border-radius: 16px;
    font-size: 16px;
    font-weight: 600;
  }
  
  .summary-card {
    padding: 16px;
    border-radius: 16px;
  }
  
  .selected-services {
    padding: 16px;
    border-radius: 16px;
  }
  
  .selected-service {
    padding: 12px;
    border-radius: 12px;
  }
  
  .btn {
    padding: 16px 24px;
    font-size: 16px;
    border-radius: 16px;
    font-weight: 600;
  }
  
  .modal-close {
    top: 16px;
    right: 16px;
    width: 48px;
    height: 48px;
    font-size: 28px;
    background: rgba(239, 68, 68, 0.15);
    border-color: rgba(239, 68, 68, 0.3);
    color: #fca5a5;
  }
}

/* Сохраняем только необходимые стили для скроллбара */
.form-section::-webkit-scrollbar,
.modal-body::-webkit-scrollbar {
  width: 6px;
}

.form-section::-webkit-scrollbar-track,
.modal-body::-webkit-scrollbar-track {
  background: #22304a;
  border-radius: 3px;
}

.form-section::-webkit-scrollbar-thumb,
.modal-body::-webkit-scrollbar-thumb {
  background: #4a5568;
  border-radius: 3px;
}

.form-section::-webkit-scrollbar-thumb:hover,
.modal-body::-webkit-scrollbar-thumb:hover {
  background: #718096;
}

/* Стили для секций заказа */
.order-section {
  background: #0a1a2a;
  border-radius: 1.5rem;
  border: 1px solid #22304a;
  padding: 1.5rem;
  transition: border-color 0.2s ease;
}

/* Тарифная таблица */
.tariff-table-container {
  width: 100%;
  overflow-x: auto;
}

.tariff-table {
  width: 100%;
  border-collapse: collapse;
  border-spacing: 0;
  background: rgba(13, 31, 49, 0.6);
  border-radius: 12px;
  overflow: hidden;
}

.tariff-table th,
.tariff-table td {
  text-align: center;
  vertical-align: middle;
  border-bottom: 1px solid rgba(71, 85, 105, 0.3);
}

.tariff-table th:first-child,
.tariff-table td:first-child {
  text-align: left;
  padding-left: 16px;
}

.tariff-table th {
  background: rgba(22, 36, 58, 0.8);
  font-weight: 600;
  color: #f1f5f9;
}

.order-section:hover {
  border-color: #3b82f6;
}

.section-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: #e2e8f0;
  margin-bottom: 1rem;
}

/* Стили для карточки заказа */
.order-card {
  background: #16243a;
  border-radius: 1rem;
  padding: 1.5rem;
  border: 1px solid #22304a;
}

.order-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1rem;
}

.order-icon {
  width: 3rem;
  height: 3rem;
  background: #2a3950;
  border-radius: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.order-info {
  flex: 1;
}

.order-title {
  font-size: 1.125rem;
  font-weight: 600;
  color: #ffffff;
  margin-bottom: 0.25rem;
}

.order-description {
  font-size: 0.875rem;
  color: #9ca3af;
  line-height: 1.4;
}

.order-meta {
  display: flex;
  gap: 1rem;
}

.meta-item {
  background: #22304a;
  color: #e2e8f0;
  padding: 0.5rem 1rem;
  border-radius: 0.75rem;
  font-size: 0.875rem;
  font-weight: 500;
}

.meta-value {
  font-weight: 700;
  font-size: 1rem;
}

.meta-sub {
  font-size: 0.75rem;
  color: #94a3b8;
  margin-top: 2px;
}

/* Стили для характеристик */
.characteristics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

.characteristic-item {
  background: #16243a;
  padding: 1rem;
  border-radius: 1rem;
  border: 1px solid #22304a;
  transition: border-color 0.2s ease;
}

.characteristic-item:hover {
  border-color: #3b82f6;
}

/* Новые широкие стили для характеристик */
.characteristics-grid-wide {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 2rem;
}

.characteristic-item-wide {
  background: #16243a;
  padding: 1.5rem;
  border-radius: 1.5rem;
  border: 1px solid #22304a;
  transition: border-color 0.2s ease;
}

.characteristic-item-wide:hover {
  border-color: #3b82f6;
}

/* Стили для материалов */
.materials-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-bottom: 1rem;
}

.material-card {
  background: #16243a;
  border-radius: 1rem;
  padding: 1rem;
  border: 1px solid #22304a;
  display: flex;
  align-items: center;
  gap: 1rem;
  position: relative;
  transition: border-color 0.2s ease;
}

.material-card:hover {
  border-color: #3b82f6;
}

.material-preview {
  width: 3rem;
  height: 3rem;
  background: #2a3950;
  border-radius: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
}

.material-content {
  flex: 1;
}

.material-title {
  font-size: 0.875rem;
  font-weight: 600;
  color: #ffffff;
  margin-bottom: 0.25rem;
}

.material-description {
  font-size: 0.75rem;
  color: #9ca3af;
  line-height: 1.3;
}

.material-remove {
  background: none;
  border: none;
  color: #ef4444;
  font-size: 1.5rem;
  cursor: pointer;
  padding: 0.25rem;
  border-radius: 0.5rem;
  transition: all 0.2s ease;
}

.material-remove:hover {
  background: rgba(239, 68, 68, 0.1);
  color: #f87171;
}

.material-inputs {
  background: #16243a;
  border-radius: 1rem;
  padding: 1rem;
  border: 1px solid #22304a;
}

.material-input-row {
  display: flex;
  gap: 1rem;
  margin-bottom: 1rem;
}

.material-input-row:last-child {
  margin-bottom: 0;
}

/* Новые широкие стили для материалов */
.material-input-row-wide {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background: #16243a;
  border-radius: 1.5rem;
  border: 1px solid #22304a;
}

.material-input-row-wide:last-child {
  margin-bottom: 0;
}

.material-input-field {
  display: flex;
  flex-direction: column;
}

.add-material-btn {
  background: #3b82f6;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 0.75rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  width: 100%;
}

.add-material-btn:hover {
  background: #2563eb;
  transform: translateY(-1px);
}

/* Стили для срока выполнения */
.deadline-section {
  background: #16243a;
  border-radius: 1rem;
  padding: 1.5rem;
  border: 1px solid #22304a;
}

.deadline-info {
  margin-bottom: 1rem;
}

.deadline-text {
  color: #e2e8f0;
  font-weight: 500;
}

.deadline-inputs {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

/* Новые широкие стили для срока выполнения */
.deadline-inputs-wide {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 2rem;
}

.deadline-field-wide {
  background: #0a1a2a;
  padding: 1.5rem;
  border-radius: 1.5rem;
  border: 1px solid #22304a;
  transition: border-color 0.2s ease;
}

.deadline-field-wide:hover {
  border-color: #3b82f6;
}

.deadline-field {
  background: #0a1a2a;
  padding: 1rem;
  border-radius: 0.75rem;
  border: 1px solid #22304a;
}

/* Улучшенные стили для полей */
.field-group {
  margin-bottom: 1rem;
  background: #0a1a2a;
  padding: 1.5rem;
  border-radius: 1.5rem;
  border: 1px solid #22304a;
  transition: border-color 0.2s ease;
}

.field-group:hover {
  border-color: #3b82f6;
}

.materials-section {
  margin-top: 1.5rem;
  padding: 1.5rem;
  background: #0a1a2a;
  border-radius: 1.5rem;
  border: 1px solid #22304a;
}

/* Улучшенные отступы для текста */
.form-content label {
  margin-bottom: 0.75rem;
  padding-left: 0;
  color: #e2e8f0;
  font-weight: 600;
}

.form-content input,
.form-content select,
.form-content textarea {
  margin-bottom: 0.5rem;
  font-size: 1rem;
  line-height: 1.5;
}

.form-content .text-red-400 {
  margin-bottom: 1rem;
  padding-left: 0;
}

/* Улучшенные стили для полей ввода */
.form-input {
  font-size: 1rem;
  line-height: 1.5;
}

.form-input:focus {
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* Стили для кнопок */
.form-button {
  font-weight: 600;
  padding: 1rem 2rem;
  border-radius: 1rem;
  transition: all 0.2s ease;
}

.form-button:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.btn-secondary {
  font-weight: 600;
  padding: 1rem 2rem;
  border-radius: 1rem;
  transition: all 0.2s ease;
}

.btn-secondary:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

/* Стилизация скроллбара */
.form-step-container::-webkit-scrollbar {
  width: 6px;
}

.form-step-container::-webkit-scrollbar-track {
  background: #22304a;
  border-radius: 3px;
}

.form-step-container::-webkit-scrollbar-thumb {
  background: #4a5568;
  border-radius: 3px;
}

.form-step-container::-webkit-scrollbar-thumb:hover {
  background: #718096;
}

/* Стили для таблиц тарифов */
table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  border: 1px solid #374151;
  padding: 12px;
  text-align: left;
}

th {
  background-color: #374151;
  font-weight: 600;
  color: white;
}

td {
  background-color: #1f2937;
}

tr:hover td {
  background-color: #374151;
}

/* Адаптивные стили для мобильных устройств */
@media (max-width: 768px) {
  .form-step-container {
    max-height: 60vh;
  }
  
  .form-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  .form-actions {
    padding: 0.75rem 0;
    border-bottom-left-radius: 1.25rem;
    border-bottom-right-radius: 1.25rem;
  }
  
  .form-actions .flex {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .form-actions button {
    width: 100%;
  }
  
  .form-content label {
    padding-left: 0.5rem;
  }
  
  .form-content .text-red-400 {
    padding-left: 0.5rem;
  }
  
  .materials-section {
    padding: 1rem;
  }
  
  .field-group {
    margin-bottom: 1.5rem;
  }
  
  /* Адаптивные стили для нового дизайна */
  .order-section {
    padding: 1rem;
    margin-bottom: 1.5rem;
  }
  
  .section-title {
    font-size: 1.125rem;
  }
  
  .characteristics-grid {
    grid-template-columns: 1fr;
    gap: 0.75rem;
  }
  
  .characteristics-grid-wide {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  .characteristic-item-wide {
    padding: 1rem;
  }
  
  .materials-grid {
    grid-template-columns: 1fr;
    gap: 0.75rem;
  }
  
  .material-input-row {
    flex-direction: column;
    gap: 0.75rem;
  }
  
  .material-input-row-wide {
    grid-template-columns: 1fr;
    gap: 1rem;
    padding: 1rem;
  }
  
  .deadline-inputs {
    grid-template-columns: 1fr;
    gap: 0.75rem;
  }
  
  .deadline-inputs-wide {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  .deadline-field-wide {
    padding: 1rem;
  }
  
  .order-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.75rem;
  }
  
  .order-meta {
    flex-wrap: wrap;
    gap: 0.5rem;
  }
  
  .meta-item {
    font-size: 0.75rem;
    padding: 0.375rem 0.75rem;
  }
}

@media (max-width: 480px) {
  .form-step-container {
    max-height: 50vh;
  }
  
  .modal-content {
    padding: 1rem;
  }
  
  .step-indicator {
    width: 2rem;
    height: 2rem;
    font-size: 1rem;
  }
  
  .form-content label {
    padding-left: 0.75rem;
  }
  
  .form-content .text-red-400 {
    padding-left: 0.75rem;
  }
  
  .materials-section {
    padding: 0.75rem;
  }
  
  .form-actions {
    border-bottom-left-radius: 1rem;
    border-bottom-right-radius: 1rem;
  }
  
  /* Адаптивные стили для маленьких экранов */
  .order-section {
    padding: 0.75rem;
    margin-bottom: 1rem;
  }
  
  .section-title {
    font-size: 1rem;
  }
  
  .order-card {
    padding: 1rem;
  }
  
  .characteristic-item {
    padding: 0.75rem;
  }
  
  .characteristic-item-wide {
    padding: 0.75rem;
  }
  
  .material-card {
    padding: 0.75rem;
  }
  
  .material-preview {
    width: 2.5rem;
    height: 2.5rem;
    font-size: 1.25rem;
  }
  
  .material-input-row-wide {
    padding: 0.75rem;
  }
  
  .deadline-section {
    padding: 1rem;
  }
  
  .deadline-field {
    padding: 0.75rem;
  }
  
  .deadline-field-wide {
    padding: 0.75rem;
  }
}

/* Стили для модального окна создания заказа */
.create-order-modal {
  width: 100%;
  max-width: 98vw;
  background: #0D1F31;
  border-radius: 2rem;
  box-shadow: 0 8px 32px rgba(0,0,0,0.25);
  padding: 2rem;
  position: relative;
  overflow: hidden;
}

@media (max-width: 768px) {
  .create-order-modal {
    max-width: 98vw;
    padding: 1rem;
  }
}

@media (max-width: 480px) {
  .create-order-modal {
    max-width: 100vw;
    padding: 0.75rem;
  }
}

/* Стили для подсказок тарифов */
.tariff-header-cell {
  position: relative;
  cursor: help;
}

.has-tooltip {
  transition: all 0.3s ease;
  cursor: pointer;
}

.has-tooltip:hover {
  background: rgba(59, 130, 246, 0.05);
}

.tooltip-active {
  background: rgba(59, 130, 246, 0.1) !important;
}

.tooltip-icon {
  position: absolute;
  top: 8px;
  right: 8px;
  font-size: 0.875rem;
  opacity: 0.7;
  transition: opacity 0.3s ease;
}

.has-tooltip:hover .tooltip-icon,
.tooltip-active .tooltip-icon {
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

.tooltip-title {
  color: #fff;
  border-bottom: 2px solid #3b82f6;
  padding-bottom: 8px;
  margin-bottom: 16px;
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
  
  /* Адаптивные стили для выбранных услуг */
  @media (max-width: 768px) {
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
  
  /* Стили для изображений в подсказках */
  .tooltip-images {
    border-top: 1px solid rgba(59, 130, 246, 0.2);
    padding-top: 16px;
  }
  
  .tooltip-images-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
  }
  
  .tooltip-image-item {
    position: relative;
    border-radius: 12px;
    overflow: hidden;
    cursor: pointer;
    transition: all 0.3s ease;
    border: 2px solid transparent;
  }
  
  .tooltip-image-item:hover {
    transform: translateY(-2px);
    border-color: #3b82f6;
    box-shadow: 0 8px 25px rgba(59, 130, 246, 0.3);
  }
  
  .tooltip-image-preview {
    width: 100%;
    height: 80px;
    object-fit: cover;
    display: block;
  }
  
  .tooltip-image-overlay {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    background: linear-gradient(transparent, rgba(0, 0, 0, 0.8));
    padding: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .tooltip-image-text {
    color: white;
    font-size: 11px;
    font-weight: 600;
    text-align: center;
  }
  
  /* Модальное окно для изображений */
  .image-modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.9);
    backdrop-filter: blur(8px);
    z-index: 2000;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
  }
  
  .image-modal-content {
    background: #0D1F31;
    border: 1px solid #22304a;
    border-radius: 20px;
    max-width: 80vw;
    max-height: 80vh;
    overflow: hidden;
    box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
  }
  
  .image-modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 24px;
    border-bottom: 1px solid #22304a;
  }
  
  .image-modal-title {
    color: white;
    font-size: 18px;
    font-weight: 600;
    margin: 0;
  }
  
  .image-modal-close {
    background: rgba(71, 85, 105, 0.2);
    border: 1px solid rgba(71, 85, 105, 0.3);
    border-radius: 12px;
    padding: 8px;
    color: #d1d5db;
    cursor: pointer;
    transition: all 0.3s ease;
  }
  
  .image-modal-close:hover {
    background: rgba(71, 85, 105, 0.4);
    border-color: rgba(71, 85, 105, 0.5);
    transform: translateY(-1px);
  }
  
  .image-modal-body {
    padding: 24px;
    display: flex;
    justify-content: center;
    align-items: center;
    overflow-y: auto;
    max-height: 60vh;
    scrollbar-width: thin;
    scrollbar-color: #475569 #1e293b;
  }
  
  .image-modal-body::-webkit-scrollbar {
    width: 6px;
  }
  
  .image-modal-body::-webkit-scrollbar-track {
    background: #1e293b;
    border-radius: 3px;
  }
  
  .image-modal-body::-webkit-scrollbar-thumb {
    background: #475569;
    border-radius: 3px;
  }
  
  .image-modal-body::-webkit-scrollbar-thumb:hover {
    background: #64748b;
  }
  
  .image-modal-image {
    max-width: 100%;
    max-height: 50vh;
    object-fit: contain;
    border-radius: 12px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  }
  
  /* Адаптивные стили для изображений */
  @media (max-width: 768px) {
    .tooltip-images-grid {
      grid-template-columns: repeat(2, 1fr);
      gap: 8px;
    }
    
    .tooltip-image-preview {
      height: 60px;
    }
    
    .tooltip-image-text {
      font-size: 10px;
    }
    
    .image-modal-content {
      max-width: 90vw;
      max-height: 85vh;
    }
    
    .image-modal-header {
      padding: 16px 20px;
    }
    
    .image-modal-body {
      padding: 16px;
      max-height: 50vh;
    }
    
    .image-modal-image {
      max-height: 40vh;
    }
  }
  
  @media (max-width: 480px) {
    .tooltip-images-grid {
      grid-template-columns: 1fr;
      gap: 6px;
    }
    
    .tooltip-image-preview {
      height: 80px;
    }
    
    .image-modal-content {
      max-width: 95vw;
      max-height: 90vh;
    }
    
    .image-modal-header {
      padding: 12px 16px;
    }
    
    .image-modal-title {
      font-size: 16px;
    }
    
    .image-modal-body {
      padding: 12px;
      max-height: 45vh;
    }
    
    .image-modal-image {
      max-height: 35vh;
    }
  }
</style> 