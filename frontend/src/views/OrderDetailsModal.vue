<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content order-details-modal">
      <button class="absolute top-4 right-4 text-gray-400 hover:text-white text-2xl" @click="$emit('close')">&times;</button>
      <div v-if="loading" class="flex items-center justify-center min-h-[300px] text-lg text-gray-300">Загрузка...</div>
      <div v-else-if="order">
        <!-- Верхний блок -->
        <div class="flex gap-8 mb-8 items-start">
          <div class="w-44 h-44 bg-[#22304a] rounded-2xl flex items-center justify-center mr-6 shrink-0">
            <span class="text-7xl">📷</span>
          </div>
          <div class="flex-1">
            <h2 class="text-4xl font-bold leading-tight mb-2">{{ order.title }}</h2>
            <div class="text-base text-gray-300 mb-4">{{ order.description }}</div>
            <div class="flex gap-4 items-center">
              <div class="bg-[#22304a] rounded-xl px-6 py-3 text-base text-center">
                <div class="font-semibold text-xl">{{ order.deadline ? order.deadline : '—' }}</div>
                <div class="text-xs text-gray-400">срок</div>
              </div>
              <div class="bg-[#22304a] rounded-xl px-6 py-3 text-base text-center">
                <div class="font-semibold text-xl">{{ order.budget ? order.budget + '₽' : '—' }}</div>
                <div class="text-xs text-gray-400">стоимость</div>
              </div>
            </div>
          </div>
        </div>
        <!-- Основная сетка -->
        <div class="grid grid-cols-2 gap-8 mb-8">
          <!-- Левая колонка -->
          <div>
            <h3 class="font-semibold mb-3 text-lg">Характеристики заказа</h3>
            <div v-if="order.attributes && order.attributes.length">
              <div v-for="attr in order.attributes" :key="attr.id" class="mb-3 order-attribute-row">
                <label class="order-attribute-label">{{ attr.attribute_type?.label || attr.attribute_type?.name || '—' }}</label>
                <div class="order-attribute-value">{{ attr.value?.label || attr.value?.value || attr.value || '—' }}</div>
              </div>
            </div>
            <div v-else class="text-gray-500 text-xs mb-4">Нет характеристик</div>
          </div>
          <!-- Правая колонка -->
          <div>
            <h3 class="font-semibold mb-3 text-lg">Исходные материалы</h3>
            <div v-if="order.materials && order.materials.length">
              <div class="flex items-center gap-4 mb-2">
                <div class="w-20 h-14 bg-[#19223a] rounded-xl flex items-center justify-center overflow-hidden">
                  <span class="text-3xl">🎬</span>
                </div>
                <div>
                  <div class="font-semibold">Видеофайл №1</div>
                  <div class="text-xs text-gray-400 truncate max-w-[180px]">{{ order.materials[0]?.description || '—' }}</div>
                </div>
              </div>
              <div v-if="order.materials.length > 1" class="text-xs text-gray-400 mb-4">И еще {{ order.materials.length - 1 }} материала</div>
            </div>
            <div v-else class="text-gray-500 text-xs mb-4">Нет материалов</div>
            <h3 class="font-semibold mt-8 mb-3 text-lg">Дополнительные пожелания</h3>
            <div class="flex flex-wrap gap-3 mb-4">
              <div v-for="(wish, idx) in order.wishes || []" :key="idx" class="flex items-center gap-2 bg-[#22304a] rounded-xl px-4 py-2 text-sm">
                <input type="checkbox" checked disabled class="accent-blue-500 w-4 h-4" />
                <span>{{ wish }}</span>
              </div>
              <span v-if="!order.wishes || !order.wishes.length" class="text-gray-500 text-xs">Нет пожеланий</span>
            </div>
            <h3 class="font-semibold mt-8 mb-3 text-lg">Чат с заказчиком</h3>
            <div class="bg-[#19223a] rounded-xl px-4 py-3 text-base flex items-center gap-3">
              <img v-if="order.customer && order.customer.avatar" :src="order.customer.avatar" class="w-10 h-10 rounded-full object-cover" alt="аватар" />
              <span v-else class="w-10 h-10 rounded-full bg-gray-500 inline-block"></span>
              <div>
                <div class="font-semibold">{{ order.customer?.name || '—' }}</div>
                <div class="text-xs text-gray-300">{{ order.chat?.lastMessage || 'Нет сообщений' }}</div>
              </div>
            </div>
          </div>
        </div>
        <!-- Кнопки -->
        <div class="flex gap-4 justify-end mt-4">
          <button v-if="canTake" :disabled="taking" @click="takeOrder" class="px-6 py-3 rounded-3xl bg-green-600 hover:bg-green-700 text-white font-semibold">
            {{ taking ? 'Берём...' : 'Взять в работу' }}
          </button>
          <button class="px-5 py-3 rounded-2xl bg-blue-600 hover:bg-blue-700 text-white font-semibold">Перейти к полному описанию</button>
          <button class="w-12 h-12 flex items-center justify-center rounded-2xl bg-[#22304a] hover:bg-red-600 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="w-6 h-6 text-white">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6M1 7h22M8 7V5a2 2 0 012-2h4a2 2 0 012 2v2" />
            </svg>
          </button>
        </div>
        <div v-if="error" class="text-red-400 text-sm mt-2">{{ error }}</div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "OrderDetailsModal",
  props: {
    order: Object,
    loading: Boolean
  },
  data() {
    return {
      taking: false,
      user: JSON.parse(localStorage.getItem('user') || '{}'),
      error: ''
    }
  },
  computed: {
    canTake() {
      if (!this.order || !this.user || !this.user.id) return false;
      // Только если заказ открыт, пользователь не заказчик и не исполнитель
      return this.order.status === 'open' && this.order.user_id !== this.user.id && this.order.executor_id !== this.user.id;
    }
  },
  methods: {
    async takeOrder() {
      this.taking = true;
      this.error = '';
      try {
        const token = localStorage.getItem('token');
        const res = await fetch(`/api/orders/${this.order.id}/take`, {
          method: 'POST',
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + token
          }
        });
        if (!res.ok) {
          const err = await res.json();
          this.error = err.message || 'Ошибка';
          return;
        }
        const data = await res.json();
        this.$emit('order-updated', data);
        window.alert('Вы взяли заказ в работу!');
      } catch (e) {
        this.error = 'Ошибка';
      } finally {
        this.taking = false;
      }
    }
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  z-index: 100;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(10, 20, 40, 0.6);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
}
.modal-content.order-details-modal {
  background: #0D1F31;
  border-radius: 2rem;
  box-shadow: 0 8px 32px rgba(0,0,0,0.25);
  padding: 2.5rem 2.5rem 2rem 2.5rem;
  min-width: 800px;
  max-width: 1000px;
  position: relative;
  color: #fff;
}
.order-details-modal label {
  font-size: 0.95rem;
  font-weight: 500;
}
.order-details-modal input[type="checkbox"] {
  accent-color: #2563eb;
}
.order-attribute-row {
  display: flex;
  align-items: center;
  border: 1px solid #2a3950;
  border-radius: 0.75rem;
  background: #19223a;
  padding: 0.5rem 1rem;
  margin-bottom: 1rem;
}
.order-attribute-label {
  flex: 0 0 180px;
  color: #a0aec0;
  font-size: 1rem;
  margin-right: 1.5rem;
}
.order-attribute-value {
  flex: 1;
  color: #fff;
  font-size: 1.1rem;
  font-weight: 500;
}
</style>
