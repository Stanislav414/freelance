<template>
  <div class="order-card" @click="$emit('view-details', order)">
    <div class="order-title">{{ order.work_type_name }}</div>
    <div class="order-title-main">{{ order.title }}</div>
    <div class="order-status-row">
      <div v-if="order.status !== 'open'" class="order-status-badge" :class="statusClass(order.status)">{{ statusText(order.status) }}</div>
    </div>
    <div class="order-description">{{ order.description }}</div>
    <div v-if="order.user" class="order-customer">
      <span class="customer-label">Заказчик:</span>
      <span class="customer-name clickable" @click.stop="goToCustomerProfile(order.user.id)">{{ order.user.name }}</span>
    </div>
    <div v-if="order.executor" class="order-executor">
      <span class="executor-label">Исполнитель:</span>
      <span class="executor-name clickable" @click.stop="goToExecutorProfile(order.executor.id)">{{ order.executor.name }}</span>
    </div>
    <div class="order-info-box">
      <div class="order-info-rect">
        <span class="order-info-value">{{ order.deadline_human }}</span>
        <span class="order-info-label">срок</span>
      </div>
      <div class="order-info-rect">
        <span class="order-info-value">{{ formatPrice(order.budget) }}₽</span>
        <span class="order-info-label">стоимость</span>
      </div>
      <div v-if="order.revision_count != null && shouldShowRevisions(order.status)" class="order-info-rect">
        <span class="order-info-value">{{ order.revision_count }}</span>
        <span class="order-info-label">доработки</span>
      </div>
    </div>
    
    <!-- Кнопка "Взять заказ" для исполнителей -->
    <button v-if="order.status === 'open' && userRole === 'executor' && order.user_id !== user.id && !order.executor_id" class="order-btn" @click.stop="$emit('take', order)">Взять заказ</button>
    
    <!-- Кнопки для заказчика когда заказ на согласовании (создан без исполнителя) -->
    <div v-if="order.status === 'pending_approval' && userRole === 'customer' && order.user_id === user.id && order.executor_id && order.was_created_without_executor" class="order-actions">
      <button class="order-btn accept-btn" @click.stop="$emit('accept-executor', order)">Принять исполнителя</button>
      <button class="order-btn decline-btn" @click.stop="$emit('decline-executor', order)">Отказаться</button>
    </div>
    
    <!-- Кнопки для заказчика когда заказ на согласовании (создан с исполнителем) -->
    <div v-if="order.status === 'pending_approval' && userRole === 'customer' && order.user_id === user.id && order.executor_id && !order.was_created_without_executor" class="order-actions">
      <button class="order-btn decline-btn" @click.stop="$emit('cancel-order', order)">Отменить заказ</button>
      <button class="order-btn accept-btn" @click.stop="$emit('change-executor', order)">Сменить исполнителя</button>
    </div>
    
    <!-- Кнопка удаления заказа для заказчика (open / pending_approval) -->
    <div v-if="userRole === 'customer' && order.user_id === user.id && (order.status === 'open' || order.status === 'pending_approval')" class="order-actions">
      <button class="order-btn decline-btn" @click.stop="$emit('delete-order', order)">Удалить заказ</button>
    </div>

    <!-- Кнопки для исполнителя когда заказ на согласовании (создан заказчиком с исполнителем) -->
    <div v-if="order.status === 'pending_approval' && userRole === 'executor' && order.executor_id === user.id && !order.was_created_without_executor" class="order-actions">
      <button class="order-btn accept-btn" @click.stop="$emit('accept-order', order)">Принять заказ</button>
      <button class="order-btn decline-btn" @click.stop="$emit('decline-order', order)">Отклонить заказ</button>
    </div>
    


    <!-- Кнопка для исполнителя когда заказ на согласовании (исполнитель сам взял заказ) -->
    <div v-if="order.status === 'pending_approval' && userRole === 'executor' && order.executor_id === user.id && order.was_created_without_executor" class="order-actions">
      <button class="order-btn decline-btn" @click.stop="$emit('decline-order', order)">Отклонить заказ</button>
    </div>

    <!-- Действия для заказов в работе -->
    <div v-if="(order.status === 'in_progress' || order.status === 'revision' || order.status === 'pending_review') && (userRole === 'customer' || userRole === 'executor')" class="order-actions">
      <OrderActions 
        :order="order" 
        :userRole="userRole"
        @order-updated="$emit('order-updated', $event)"
      />
    </div>

    <!-- Кнопка для оставления отзыва (для участников завершенных заказов) -->
    <div v-if="order.status === 'completed' && shouldShowReviewButton()" class="order-actions">
      <button class="order-btn review-btn" @click.stop="$emit('leave-review', order)">Оставить отзыв</button>
    </div>
  </div>
</template>

<script>
import OrderActions from './OrderActions.vue'

export default {
  name: 'OrderCard',
  components: {
    OrderActions
  },
  props: {
    order: {
      type: Object,
      required: true
    },
    userRole: {
      type: String,
      default: ''
    },
    user: {
      type: Object,
      required: true
    }
  },
  methods: {
    formatPrice(val) {
      if (val == null) return '—';
      // Если число, убираем дробную часть
      return parseInt(val, 10);
    },
    statusText(status) {
      switch (status) {
        case 'open': return 'Открыт';
        case 'pending_approval': return 'На согласовании';
        case 'in_progress': return 'В работе';
        case 'pending_review': return 'На проверке';
        case 'revision': return 'На доработке';
        case 'completed': return 'Завершен';
        case 'cancelled': return 'Отменен';
        case 'disputed': return 'Спор';
        case 'waiting_payment': return 'Ожидание оплаты';
        case 'done': return 'Завершён';
        default: return status || '—';
      }
    },
    statusClass(status) {
      switch (status) {
        case 'open': return 'badge-open';
        case 'pending_approval': return 'badge-pending';
        case 'in_progress': return 'badge-inprogress';
        case 'pending_review': return 'badge-pending-review';
        case 'revision': return 'badge-revision';
        case 'completed': return 'badge-completed';
        case 'cancelled': return 'badge-cancelled';
        case 'disputed': return 'badge-disputed';
        case 'waiting_payment': return 'badge-waiting';
        case 'done': return 'badge-done';
        default: return 'badge-default';
      }
    },
    shouldShowRevisions(status) {
      // Показываем поле "доработки" только для заказов, которые действительно могут иметь доработки
      return ['revision', 'pending_review', 'in_progress', 'completed'].includes(status);
    },
    shouldShowReviewButton() {
      return this.order.status === 'completed' && this.order.can_review;
    },
    goToCustomerProfile(userId) {
      // Переходим к профилю заказчика
      this.$router.push(`/profile/customer/${userId}`);
    },
    goToExecutorProfile(userId) {
      // Переходим к портфолио исполнителя
      this.$router.push(`/portfolio/${userId}`);
    }
  }
}
</script>

<style scoped>
.order-card {
  background: #0D1F31;
  border-radius: 1.5rem;
  padding: 1.5rem;
  color: #fff;
  min-width: 260px;
  max-width: 360px;
  width: 100%;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: stretch;
  box-shadow: 0 4px 24px #0002;
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  transition: box-shadow 0.2s, background 0.2s;
  position: relative;
}
.order-card:hover {
  box-shadow: 0 8px 32px #0004;
  background: #13213a;
}
.order-title {
  font-size: 1.1rem;
  font-weight: bold;
  margin-bottom: 0.7rem;
}
.order-title-main {
  font-size: 1.08rem;
  font-weight: 600;
  margin-bottom: 0.2rem;
}
.order-description {
  font-size: 1rem;
  margin-bottom: 1.2rem;
  color: #bfc9da;
}
.order-executor {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
}
.executor-label {
  color: #7a8ca7;
  font-weight: 500;
}
.executor-name {
  color: #fff;
  font-weight: 600;
}
.order-customer {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
}
.customer-label {
  color: #7a8ca7;
  font-weight: 500;
}
.customer-name {
  color: #fff;
  font-weight: 600;
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
.order-info-box {
  display: flex;
  gap: 1rem;
  margin-bottom: 1.2rem;
}
.order-info-rect {
  background: transparent;
  border: 1px solid #ffffff38;
  border-radius: 0.7rem;
  padding: 0.2rem 1rem;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  min-width: 90px;
}
.order-info-value {
  font-size: 1.1rem;
  font-weight: 500;
  margin-bottom: 0.2rem;
}
.order-info-label {
  font-size: 0.8rem;
  color: #7a8ca7;
}
.order-btn {
  background: #22c55e;
  color: #fff;
  border: none;
  border-radius: 0.5rem;
  padding: 0.7rem 0;
  font-weight: bold;
  font-size: 1rem;
  cursor: pointer;
  transition: background 0.2s;
  margin-top: 0.5rem;
}
.order-btn:hover {
  background: #16a34a;
}
.order-actions {
  display: flex;
  gap: 0.5rem;
  margin-top: 0.5rem;
}
.accept-btn {
  background: #22c55e;
  flex: 1;
}
.accept-btn:hover {
  background: #16a34a;
}
.decline-btn {
  background: #ef4444;
  flex: 1;
}
.decline-btn:hover {
  background: #dc2626;
}
.order-status-row {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  margin-bottom: 0.7rem;
}
.order-status-badge {
  display: inline-block;
  padding: 0.18rem 0.7rem;
  border-radius: 0.6rem;
  font-size: 0.93rem;
  font-weight: 600;
  letter-spacing: 0.01em;
  min-width: unset;
  text-align: left;
  box-shadow: none;
}
.badge-open {
  background: #2563eb;
  color: #fff;
}
.badge-pending {
  background: #3b82f6;
  color: #fff;
}
.badge-inprogress {
  background: #facc15;
  color: #222;
}
.badge-waiting {
  background: #38bdf8;
  color: #fff;
}
.badge-done {
  background: #22c55e;
  color: #fff;
}
.badge-default {
  background: #64748b;
  color: #fff;
}

.badge-revision {
  background: #f97316;
  color: #fff;
}

.badge-completed {
  background: #22c55e;
  color: #fff;
}

.badge-cancelled {
  background: #ef4444;
  color: #fff;
}

.badge-disputed {
  background: #dc2626;
  color: #fff;
}

.badge-pending-review {
  background: #f59e0b;
  color: #fff;
}

/* Адаптивные стили для OrderCard */
@media (max-width: 768px) {
  .order-card {
    padding: 1rem;
    min-width: unset;
    max-width: none;
  }
  
  .order-title {
    font-size: 1rem;
  }
  
  .order-title-main {
    font-size: 1.125rem;
  }
  
  .order-description {
    font-size: 0.875rem;
  }
  
  .order-info-box {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .order-info-rect {
    min-width: unset;
    width: 100%;
  }
  
  .order-btn {
    padding: 0.875rem;
    font-size: 0.875rem;
  }
  
  .order-actions {
    flex-direction: column;
    gap: 0.5rem;
  }
  
  /* Улучшенные стили для мобильных карточек */
  .order-card {
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
  }
  
  .order-title-main {
    line-height: 1.3;
    margin-bottom: 8px;
  }
  
  .order-description {
    line-height: 1.4;
    margin-bottom: 12px;
  }
  
  .order-info-box {
    margin-bottom: 16px;
  }
  
  .order-info-rect {
    padding: 12px;
    border-radius: 12px;
  }
  
  .order-btn {
    border-radius: 12px;
    font-weight: 600;
    transition: all 0.2s ease;
  }
  
  .order-btn:active {
    transform: scale(0.98);
  }
}

@media (max-width: 480px) {
  .order-card {
    padding: 0.75rem;
  }
  
  .order-title {
    font-size: 0.875rem;
  }
  
  .order-title-main {
    font-size: 1rem;
  }
  
  .order-description {
    font-size: 0.75rem;
  }
  
  .order-info-value {
    font-size: 1rem;
  }
  
  .order-info-label {
    font-size: 0.75rem;
  }
  
  .order-btn {
    padding: 0.75rem;
    font-size: 0.75rem;
  }
}

/* Hover эффекты */
.order-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 32px #0004;
}

/* Анимации для кнопок */
.order-btn {
  transition: all 0.2s ease;
}

.order-btn:active {
  transform: scale(0.98);
}

/* Стили для кнопки отзыва */
.review-btn {
  background: #10b981;
  color: #fff;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.875rem;
}

.review-btn:hover {
  background: #059669;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

/* Адаптивные стили для статусов */
@media (max-width: 640px) {
  .order-status-badge {
    font-size: 0.875rem;
    padding: 0.15rem 0.5rem;
  }
}
</style>