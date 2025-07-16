<template>
  <div class="order-card" @click="$emit('take', order)">
    <div class="order-title">{{ order.work_type_name }}</div>
    <div class="order-title-main">{{ order.title }}</div>
    <div class="order-status-row">
      <div class="order-status-badge" :class="statusClass(order.status)">{{ statusText(order.status) }}</div>
    </div>
    <div class="order-description">{{ order.description }}</div>
    <div class="order-info-box">
      <div class="order-info-rect">
        <span class="order-info-value">{{ order.deadline_human }}</span>
        <span class="order-info-label">срок</span>
      </div>
      <div class="order-info-rect">
        <span class="order-info-value">{{ formatPrice(order.budget) }}₽</span>
        <span class="order-info-label">стоимость</span>
      </div>
    </div>
    <button v-if="order.status === 'open'" class="order-btn" @click.stop="$emit('take', order)">Взять заказ</button>
  </div>
</template>

<script>
export default {
  name: 'OrderCard',
  props: {
    order: {
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
        case 'in_progress': return 'В работе';
        case 'waiting_payment': return 'Ожидание оплаты';
        case 'done': return 'Завершён';
        default: return status || '—';
      }
    },
    statusClass(status) {
      switch (status) {
        case 'open': return 'badge-open';
        case 'in_progress': return 'badge-inprogress';
        case 'waiting_payment': return 'badge-waiting';
        case 'done': return 'badge-done';
        default: return 'badge-default';
      }
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
</style>