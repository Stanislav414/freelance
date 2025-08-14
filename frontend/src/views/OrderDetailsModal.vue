<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content order-details-modal">
      <button class="close-btn" @click="$emit('close')">&times;</button>

      <div v-if="loading" class="loading">Загрузка...</div>
      <div v-else-if="order" class="order-content">
        
        <!-- Header Section -->
        <div class="order-header">
          <div class="order-icon">📋</div>
          <div class="order-info">
            <h2 class="order-title">{{ order.title }}</h2>
            <div class="order-customer">
              <span>Заказчик:</span> 
              <span class="customer-name clickable" @click="goToCustomerProfile()">{{ getCustomerName() }}</span>
            </div>
          </div>

        </div>

        <!-- Description -->
        <div class="order-description">
          <h3 class="section-title">Описание заказа</h3>
          <p>{{ order.description || 'Описание заказа не указано' }}</p>
        </div>

        <!-- Unified Info Section -->
        <div class="unified-info-section">
          <div class="info-card unified-card">
            <!-- Basic Info -->
            <div class="info-section">
              <h3 class="section-title">Основная информация</h3>
              <div class="info-item">
                <span class="info-label">Стоимость:</span>
                <span class="info-value price">{{ formatPrice(order.calculated_price ?? order.budget) }}₽</span>
              </div>
              <div class="info-item">
                <span class="info-label">Срок выполнения:</span>
                <span class="info-value">{{ formatDate(order.deadline) }}</span>
              </div>
              <div v-if="order.slides_quantity" class="info-item">
                <span class="info-label">Количество слайдов:</span>
                <span class="info-value">{{ order.slides_quantity }}</span>
              </div>
            </div>

            <!-- Characteristics -->
            <div v-if="displayAttributes.length > 0" class="info-section">
              <h3 class="section-title">Характеристики</h3>
              <div v-for="attr in displayAttributes.slice(0, 6)" :key="attr.id" class="info-item">
                <span class="info-label">{{ attr.label }}:</span>
                <span class="info-value">{{ attr.displayValue }}</span>
              </div>
            </div>

            <!-- Materials -->
            <div class="info-section">
              <h3 class="section-title">Материалы</h3>
              <div v-if="order.materials && order.materials.length" class="materials-list">
                <div v-for="(material, index) in order.materials.slice(0, 3)" :key="index" class="material-item">
                  <span class="material-type">{{ material.type || 'Материал' }}</span>
                  <span class="material-desc">{{ material.description || 'Без описания' }}</span>
                </div>
                <div v-if="order.materials.length > 3" class="materials-more">
                  И ещё {{ order.materials.length - 3 }} материалов
                </div>
              </div>
              <div v-else class="empty-state">Материалы не прикреплены</div>
            </div>
          </div>
        </div>

        <!-- Actions -->
        <div class="modal-actions">
          <button 
            v-if="canTake" 
            @click="takeOrder" 
            :disabled="taking"
            class="btn btn-success"
          >
            <span v-if="taking">Взятие заказа...</span>
            <span v-else>Взять заказ</span>
          </button>
          
          <button 
            class="btn btn-primary" 
            @click="openChat()"
            :disabled="openingChat"
          >
            <span v-if="openingChat">Открытие чата...</span>
            <span v-else>Открыть чат</span>
          </button>
          
          <button class="btn btn-secondary" @click="$emit('close')">Закрыть</button>
        </div>

        <div v-if="error" class="error">{{ error }}</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'OrderDetailsModal',
  props: { order: Object, loading: Boolean },
  data() {
    return {
      taking: false,
      user: JSON.parse(localStorage.getItem('user') || '{}'),
      error: '',
      attributeTypes: [],
      openingChat: false,
    }
  },
  computed: {
    canTake() {
      const role = localStorage.getItem('role') || 'customer'
      // Исполнитель может взять заказ только если:
      // 1. Он в роли исполнителя
      // 2. Заказ имеет статус "open" (открыт)
      // 3. Он не является заказчиком этого заказа
      // 4. Заказ еще не назначен другому исполнителю
      return role === 'executor' && 
             this.order?.status === 'open' && 
             this.order?.user_id !== this.user.id && 
             !this.order?.executor_id
    },
    canAcceptExecutor() { return false },
    canCancelOrder() { return false },
    canAcceptOrder() { return false },
    canDeclineOrder() { return false },

    displayAttributes() {
      if (!this.order) return []
      const byTypeId = new Map((this.order.attributes || []).map(a => [a.attribute_type_id, a]))
      return (this.attributeTypes || []).map(t => {
        const attr = byTypeId.get(t.id)
        let value = attr?.value?.label || attr?.value?.value || attr?.value_text || attr?.value || '—'
        if ((t.name === 'slides_count' || /слайд/i.test(t.label || '')) && (this.order.slides_quantity ?? null) !== null) {
          value = String(this.order.slides_quantity)
        }
        return { id: t.id, label: t.label || t.name, displayValue: value }
      })
    },
    characteristicAttributes() {
      return this.displayAttributes.slice(0, 3)
    },
    technicalAttributes() {
      return this.displayAttributes.slice(3)
    }
  },
  watch: {
    order: { handler() { this.loadAttributeTypes() }, immediate: true }
  },
  methods: {
    async loadAttributeTypes() {
      try {
        if (!this.order?.work_type_id) return
        const { data } = await this.$axios.get(`/work-types/${this.order.work_type_id}/attributes`)
        this.attributeTypes = data
      } catch { this.attributeTypes = [] }
    },
    
    async openChat() {
      this.openingChat = true;
      this.error = ''; // Сбрасываем предыдущие ошибки
      
      try {
        console.log('Создание чата для заказа:', this.order.id);
        
        // Создаем чат для заказа
        const { data } = await this.$axios.post(`/orders/${this.order.id}/create-chat`);
        
        console.log('Чат создан успешно:', data);
        
        // Эмитим событие для открытия чата
        this.$emit('chat-opened', data);
        
        // Закрываем модальное окно заказа
        this.$emit('close');
      } catch (error) {
        console.error('Ошибка создания чата:', error);
        
        // Показываем понятную ошибку пользователю
        if (error.response?.status === 403) {
          this.error = 'У вас нет прав для создания чата с этим заказом';
        } else if (error.response?.data?.error) {
          this.error = error.response.data.error;
        } else {
          this.error = 'Не удалось открыть чат. Попробуйте еще раз.';
        }
      } finally {
        this.openingChat = false;
      }
    },
    async takeOrder() {
      this.taking = true;
      try {
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        
        // Используем единый метод update-status для взятия заказа
        const { data } = await this.$axios.post(`/orders/${this.order.id}/update-status`, { 
          status: 'pending_approval', 
          executor_id: user.id 
        });
        
        this.$emit('order-taken', data.order || data)
      } catch (error) {
        this.error = error.response?.data?.message || error.message || 'Не удалось взять заказ'
      } finally {
        this.taking = false;
      }
    },
    getCustomerName() {
      // Проверяем разные варианты получения имени заказчика
      if (this.order?.customer?.name) {
        return this.order.customer.name;
      }
      if (this.order?.user?.name) {
        const surname = this.order.user.surname || '';
        return (this.order.user.name + ' ' + surname).trim();
      }
      return '—';
    },
    goToCustomerProfile() {
      // Получаем ID заказчика из order.user_id или order.user.id
      const customerId = this.order?.user_id || this.order?.user?.id || this.order?.customer?.id;
      if (customerId) {
        this.$router.push(`/profile/customer/${customerId}`);
        this.$emit('close'); // Закрываем модальное окно
      }
    },
    

    
    formatPrice(price) {
      if (!price || price === 0) return '—';
      return parseInt(price, 10).toLocaleString('ru-RU');
    },
    
    formatDate(date) {
      if (!date) return '—';
      const d = new Date(date);
      return d.toLocaleDateString('ru-RU', { day: 'numeric', month: 'long', year: 'numeric' });
    }
  }
}
</script>

<style scoped>
/* Modal Layout */
.modal-overlay {
  position: fixed;
  inset: 0;
  z-index: 100;
  background: rgba(10, 20, 40, 0.7);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.modal-content {
  background: #0D1F31;
  color: #fff;
  border-radius: 24px;
  width: 100%;
  max-width: 800px;
  max-height: 95vh;
  overflow: hidden;
  position: relative;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
  border: 1px solid #374151;
  display: flex;
  flex-direction: column;
}

.order-content {
  padding: 24px;
  flex: 1;
  overflow-y: auto;
  /* Скрываем скроллбар */
  scrollbar-width: none; /* Firefox */
  -ms-overflow-style: none; /* Internet Explorer 10+ */
}

.order-content::-webkit-scrollbar {
  width: 0;
  height: 0;
  display: none; /* Chrome, Safari, Opera */
}

.close-btn {
  position: absolute;
  top: 15px;
  right: 20px;
  color: #9ca3af;
  font-size: 24px;
  background: none;
  border: none;
  cursor: pointer;
  z-index: 10;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.2s;
}

.close-btn:hover {
  background: #374151;
  color: #fff;
}

.loading {
  min-height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #9ca3af;
  font-size: 16px;
}

/* Header */
.order-header {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 24px;
  padding-bottom: 20px;
  border-bottom: 1px solid #374151;
}

.order-icon {
  width: 60px;
  height: 60px;
  background: #374151;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  flex-shrink: 0;
}

.order-info {
  flex: 1;
  min-width: 0;
}

.order-title {
  font-size: 24px;
  font-weight: 700;
  margin: 0 0 8px 0;
  line-height: 1.2;
}



.order-customer {
  color: #9ca3af;
  font-size: 14px;
}

.order-customer span {
  color: #6b7280;
}



/* Description */
.order-description {
  margin-bottom: 24px;
}

.order-description p {
  color: #d1d5db;
  line-height: 1.5;
  margin: 8px 0 0 0;
}

/* Section Title */
.section-title {
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 12px 0;
  color: #f3f4f6;
}

/* Unified Info Section */
.unified-info-section {
  margin-bottom: 24px;
}

.unified-card {
  background: #1f2937;
  border-radius: 16px;
  padding: 24px;
  border: 1px solid #374151;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.info-section {
  display: flex;
  flex-direction: column;
}

.info-section:not(:last-child) {
  padding-bottom: 20px;
  border-bottom: 1px solid #374151;
}

.info-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid #374151;
}

.info-item:last-child {
  border-bottom: none;
}

.info-label {
  color: #9ca3af;
  font-size: 14px;
}

.info-value {
  color: #f3f4f6;
  font-weight: 500;
  font-size: 14px;
}

.info-value.price {
  color: #10b981;
  font-weight: 600;
}

/* Materials */
.materials-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.material-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 12px;
  background: #111827;
  border-radius: 12px;
  border: 1px solid #374151;
}

.material-type {
  font-weight: 500;
  color: #f3f4f6;
  font-size: 14px;
}

.material-desc {
  color: #9ca3af;
  font-size: 12px;
}

.materials-more {
  color: #6b7280;
  font-size: 12px;
  font-style: italic;
  margin-top: 8px;
}

.empty-state {
  color: #6b7280;
  font-size: 14px;
  text-align: center;
  padding: 20px;
}

/* Actions */
.modal-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  margin-top: 24px;
  padding-top: 20px;
  border-top: 1px solid #374151;
}

.btn {
  border: none;
  cursor: pointer;
  border-radius: 16px;
  padding: 12px 24px;
  font-weight: 600;
  font-size: 14px;
  transition: all 0.2s;
  min-width: 120px;
}

.btn-success {
  background: #10b981;
  color: #fff;
}

.btn-success:hover {
  background: #059669;
}

.btn-success:disabled {
  background: #6b7280;
  cursor: not-allowed;
}

.btn-primary {
  background: #2563eb;
  color: #fff;
}

.btn-primary:hover {
  background: #1d4ed8;
}

.btn-primary:disabled {
  background: #6b7280;
  cursor: not-allowed;
}

.btn-secondary {
  background: #374151;
  color: #d1d5db;
}

.btn-secondary:hover {
  background: #4b5563;
}

/* Error */
.error {
  margin-top: 16px;
  color: #fca5a5;
  font-size: 14px;
  background: #1f2937;
  padding: 12px;
  border-radius: 8px;
  border-left: 4px solid #ef4444;
}

/* Стили для кликабельных элементов */
.clickable {
  cursor: pointer;
  transition: all 0.2s ease;
  text-decoration: underline;
  text-decoration-color: transparent;
}

.clickable:hover {
  color: #3b82f6 !important;
  text-decoration-color: #3b82f6;
  transform: translateY(-1px);
}

.customer-name {
  font-weight: 600;
}

/* Responsive */
@media (max-width: 768px) {
  .modal-overlay {
    padding: 10px;
  }
  
  .order-content {
    padding: 20px;
  }
  
  .order-header {
    flex-direction: column;
    gap: 12px;
  }
  
  .order-status {
    align-self: flex-start;
  }
  
  .unified-card {
    gap: 20px;
    padding: 20px;
  }
  
  .modal-actions {
    flex-direction: column-reverse;
  }
  
  .btn {
    width: 100%;
  }
}
</style>
