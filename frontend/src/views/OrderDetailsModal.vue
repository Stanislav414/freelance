<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content">
      <button class="absolute top-4 right-4 text-gray-400 hover:text-white text-2xl" @click="$emit('close')">&times;</button>
      <div v-if="order">
        <!-- Верхний блок -->
        <div class="flex gap-6 mb-8 items-start">
          <div class="w-40 h-40 bg-[#22304a] rounded-2xl flex items-center justify-center mr-6">
            <span class="text-6xl">📷</span>
          </div>
          <div class="flex-1">
            <div class="flex items-start justify-between mb-2">
              <h2 class="text-3xl font-bold leading-tight">{{ order.title }}</h2>
              <div class="flex gap-4 items-center">
                <div class="bg-[#22304a] rounded-xl px-5 py-2 text-base text-center">
                  <div class="font-semibold">{{ order.deadline ? order.deadline : '—' }}</div>
                  <div class="text-xs text-gray-400">срок</div>
                </div>
                <div class="bg-[#22304a] rounded-xl px-5 py-2 text-base text-center">
                  <div class="font-semibold">{{ order.budget ? order.budget + '₽' : '—' }}</div>
                  <div class="text-xs text-gray-400">вы получите</div>
                </div>
              </div>
            </div>
            <div class="text-gray-300 text-base mb-2">{{ order.description }}</div>
          </div>
        </div>
        <!-- Основная сетка -->
        <div class="grid grid-cols-2 gap-8 mb-8">
          <!-- Левая колонка -->
          <div>
            <h3 class="font-semibold mb-3 text-lg">Характеристики заказа</h3>
            <div class="mb-3">
              <div class="text-xs text-gray-400 mb-1">Тип ролика</div>
              <div class="bg-[#19223a] rounded-xl px-4 py-2 text-base">{{ order.type || '—' }}</div>
            </div>
            <div class="mb-3">
              <div class="text-xs text-gray-400 mb-1">Цель</div>
              <div class="bg-[#19223a] rounded-xl px-4 py-2 text-base">{{ order.goal || '—' }}</div>
            </div>
            <div class="mb-8">
              <div class="text-xs text-gray-400 mb-1">Платформа</div>
              <div class="bg-[#19223a] rounded-xl px-4 py-2 text-base">{{ order.platform || '—' }}</div>
            </div>
            <h3 class="font-semibold mb-3 text-lg">Технические требования</h3>
            <div class="mb-3">
              <div class="text-xs text-gray-400 mb-1">Формат</div>
              <div class="bg-[#19223a] rounded-xl px-4 py-2 text-base">{{ order.format || '—' }}</div>
            </div>
            <div class="mb-3">
              <div class="text-xs text-gray-400 mb-1">Ориентация</div>
              <div class="bg-[#19223a] rounded-xl px-4 py-2 text-base">{{ order.orientation || '—' }}</div>
            </div>
            <div>
              <div class="text-xs text-gray-400 mb-1">Звук</div>
              <div class="bg-[#19223a] rounded-xl px-4 py-2 text-base">{{ order.sound || '—' }}</div>
            </div>
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
            <div class="flex flex-wrap gap-2 mb-4">
              <span v-for="(wish, idx) in order.wishes || []" :key="idx" class="bg-[#22304a] rounded-xl px-4 py-2 text-sm flex items-center gap-2">
                <span class="inline-block w-4 h-4 rounded-full border-2 border-blue-400 bg-blue-400 mr-1"></span>
                {{ wish }}
              </span>
              <span v-if="!order.wishes || !order.wishes.length" class="text-gray-500 text-xs">Нет пожеланий</span>
            </div>
          </div>
        </div>
        <!-- Чат с заказчиком -->
        <div class="mb-8">
          <h3 class="font-semibold mb-3 text-lg">Чат с заказчиком</h3>
          <div class="bg-[#19223a] rounded-xl px-4 py-3 text-base flex items-center gap-3">
            <img v-if="order.customer && order.customer.avatar" :src="order.customer.avatar" class="w-10 h-10 rounded-full object-cover" alt="аватар" />
            <span v-else class="w-10 h-10 rounded-full bg-gray-500 inline-block"></span>
            <div>
              <div class="font-semibold">{{ order.customer?.name || '—' }}</div>
              <div class="text-xs text-gray-300">{{ order.chat?.lastMessage || 'Нет сообщений' }}</div>
            </div>
          </div>
        </div>
        <!-- Кнопки -->
        <div class="flex gap-4 justify-end mt-4">
          <button class="px-6 py-3 rounded-3xl bg-blue-600 hover:bg-blue-700 text-white font-semibold">Перейти к полному описанию</button>
          <button class="w-12 h-12 flex items-center justify-center rounded-2xl bg-[#22304a] hover:bg-red-600 transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="w-6 h-6 text-white">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6M1 7h22M8 7V5a2 2 0 012-2h4a2 2 0 012 2v2" />
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "OrderDetailsModal",
  props: {
    order: Object
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
.modal-content {
  background: #0D1F31;
  border-radius: 2rem;
  box-shadow: 0 8px 32px rgba(0,0,0,0.25);
  padding: 2rem;
  min-width: 600px;
  max-width: 90vw;
  position: relative;
  color: #fff;
}
</style>
