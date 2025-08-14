<template>
  <div v-if="show && order" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" @click="closeModal">
    <div class="modal-content" @click.stop>
      <div class="modal-header">
        <h2 class="modal-title">Подходящие исполнители</h2>
        <button @click="closeModal" class="close-btn">&times;</button>
      </div>
      
      <div class="modal-body">
        <!-- Детали заказа -->
        <div class="order-details">
          <div class="order-type">
            <img :src="getWorkTypeIcon(order)" class="work-type-icon" alt="icon" />
            <div class="order-info">
              <h3>{{ order.title }}</h3>
              <p>{{ order.description }}</p>
              <div class="order-metrics">
                <span>{{ order.average_time || '2 дня' }}</span>
                <span>{{ order.average_price || '800' }}₽</span>
              </div>
            </div>
          </div>
          
          <div class="order-actions">
            <button @click="editOrder" class="btn-edit">Редактировать заказ</button>
          </div>
        </div>

        <!-- Список исполнителей -->
        <div class="executors-grid">
          <div v-for="executor in filteredExecutors" :key="executor.id" class="executor-card">
            <div class="executor-header">
              <div class="executor-avatar">
                <img :src="getExecutorAvatar(executor)" :alt="executor.name" />
                <div v-if="executor.is_verified" class="verified-badge">✓</div>
              </div>
            </div>
            
            <div class="executor-info">
              <h4 class="executor-name">{{ executor.name }}</h4>
              <p class="executor-stats">{{ executor.completed_orders }} заказов всего</p>
              <p class="executor-rate">{{ executor.hourly_rate }}₽ почасовая оплата</p>
              <p class="executor-price">{{ executor.hourly_rate }}₽ / ваш заказ</p>
            </div>
            
            <button @click="createOrderWithExecutor(executor.id)" class="btn-create-order">
              Выбрать исполнителя
            </button>
          </div>
        </div>
      </div>
      
      <!-- Кнопки навигации -->
      <div class="modal-footer">
        <div class="flex gap-4 justify-end mt-6">
          <button @click="goBack" class="px-6 py-3 rounded-3xl bg-gray-600 hover:bg-gray-700 text-white font-semibold transition-colors">
            Назад
          </button>
          <button @click="createOrderWithoutExecutor" class="bg-green-600 hover:bg-green-700 text-white font-semibold px-6 py-3 rounded-3xl transition-colors">
            Создать без исполнителя
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import performerIcon from '@/assets/performer.png';

export default {
  name: 'ExecutorsModal',
  props: {
    show: {
      type: Boolean,
      default: false
    },
    order: {
      type: Object,
      default: null
    }
  },
  data() {
    return {
      executors: [],
      loading: false,
      bookmarkedExecutors: []
    }
  },
  computed: {
    filteredExecutors() {
      // Исключаем текущего пользователя из списка исполнителей
      const currentUserId = this.getCurrentUserId();
      return this.executors.filter(executor => executor.id !== currentUserId);
    }
  },
  mounted() {
  },
  watch: {
    show(newVal) {
      if (newVal) {
        this.loadExecutors();
      }
    },
    order(newVal) {
    }
  },
  methods: {
    closeModal() {
      this.$emit('close');
    },
    
    async loadExecutors() {
      this.loading = true;
      try {
        // Определяем специализацию на основе типа заказа
        const specialization = this.getSpecializationFromOrder();
        
        try {
          const { data } = await this.$axios.get(`/executors/by-specialization`, { params: { specialization } })
          this.executors = data
        } catch {
          console.error('Ошибка загрузки исполнителей');
          // Показываем тестовые данные
          this.executors = this.getMockExecutors();
        }
      } catch (error) {
        console.error('Ошибка:', error);
        this.executors = this.getMockExecutors();
      } finally {
        this.loading = false;
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
      
      return orderTypeToSpecialization[this.order.title] || 'graphic_design';
    },
    
    getWorkTypeIcon(order) {
      if (order.image) {
        try {
          return new URL(`../assets/${order.image}`, import.meta.url).href;
        } catch {
          return new URL('../assets/orders.png', import.meta.url).href;
        }
      }
      return new URL('../assets/orders.png', import.meta.url).href;
    },
    
    getExecutorAvatar(executor) {
      // Используем статичную аватарку исполнителя
      return performerIcon;
    },
    
    getCurrentUserId() {
      // Получаем ID текущего пользователя из localStorage или токена
      const token = localStorage.getItem('token');
      if (token) {
        try {
          const payload = JSON.parse(atob(token.split('.')[1]));
          return payload.user_id || null;
        } catch (e) {
          console.error('Ошибка парсинга токена:', e);
        }
      }
      return null;
    },

    getMockExecutors() {
      return [
        {
          id: 1,
          name: 'Станислав Пузынин',
          avatar: '/default-avatar.png',
          completed_orders: 12,
          hourly_rate: 500,
          is_verified: true
        },
        {
          id: 2,
          name: 'тестовый тест',
          avatar: '/default-avatar.png',
          completed_orders: 8,
          hourly_rate: 500,
          is_verified: true
        },
        {
          id: 3,
          name: 'Второй Тестовый',
          avatar: '/default-avatar.png',
          completed_orders: 15,
          hourly_rate: 500,
          is_verified: true
        }
      ];
    },
    
    editOrder() {
      this.$emit('edit-order');
    },
    
    compareExecutors() {
      this.$emit('compare-executors');
    },
    
    createOrderWithExecutor(executorId) {
      this.$emit('create-order-with-executor', executorId);
    },

    goBack() {
      this.$emit('go-back');
    },

    createOrderWithoutExecutor() {
      this.$emit('create-order-without-executor');
    }
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: #0D1F31;
  border-radius: 24px;
  max-width: 1200px;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  color: #fff;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px 32px;
  border-bottom: 1px solid #22304a;
}

.modal-title {
  font-size: 24px;
  font-weight: 700;
  margin: 0;
}

.close-btn {
  background: none;
  border: none;
  color: #bfc9da;
  font-size: 24px;
  cursor: pointer;
  padding: 8px;
  border-radius: 8px;
  transition: background 0.2s;
}

.close-btn:hover {
  background: #16243a;
}

.modal-body {
  padding: 32px;
}

.order-details {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 32px;
  padding: 24px;
  background: #16243a;
  border-radius: 16px;
}

.order-type {
  display: flex;
  align-items: center;
  gap: 16px;
}

.work-type-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
}

.order-info h3 {
  margin: 0 0 8px 0;
  font-size: 18px;
  font-weight: 600;
}

.order-info p {
  margin: 0 0 12px 0;
  color: #bfc9da;
  font-size: 14px;
}

.order-metrics {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: #bfc9da;
}

.order-actions {
  display: flex;
  gap: 12px;
}

.btn-edit {
  padding: 8px 16px;
  background: #374151;
  color: #fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  transition: background 0.2s;
}

.btn-edit:hover {
  background: #4b5563;
}

.btn-compare {
  padding: 8px 16px;
  background: #10b981;
  color: #fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  transition: background 0.2s;
}

.btn-compare:hover {
  background: #059669;
}

.executors-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
}

.executor-card {
  background: #16243a;
  border-radius: 16px;
  padding: 20px;
  position: relative;
  transition: transform 0.2s;
}

.executor-card:hover {
  transform: translateY(-2px);
}

.executor-header {
  display: flex;
  justify-content: flex-start;
  align-items: flex-start;
  margin-bottom: 16px;
}

.executor-avatar {
  position: relative;
}

.executor-avatar img {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  object-fit: cover;
}

.verified-badge {
  position: absolute;
  bottom: 0;
  right: 0;
  background: #10b981;
  color: #fff;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: bold;
}

.executor-info {
  margin-bottom: 16px;
}

.executor-name {
  margin: 0 0 8px 0;
  font-size: 16px;
  font-weight: 600;
}

.executor-stats,
.executor-rate,
.executor-price {
  margin: 4px 0;
  font-size: 12px;
  color: #bfc9da;
}

.executor-price {
  color: #fff;
  font-weight: 600;
}

.btn-create-order {
  width: 100%;
  padding: 12px;
  background: #2563eb;
  color: #fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  transition: background 0.2s;
}

.btn-create-order:hover {
  background: #1d4ed8;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter, .fade-leave-to {
  opacity: 0;
}

@media (max-width: 768px) {
  .modal-content {
    width: 95%;
    margin: 20px;
  }
  
  .order-details {
    flex-direction: column;
    gap: 16px;
  }
  
  .executors-grid {
    grid-template-columns: 1fr;
  }
}
</style> 