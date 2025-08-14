<template>
  <div class="order-actions">


    <!-- Действия для заказчика -->
    <div v-if="isCustomer" class="customer-actions">
      <!-- Завершить заказ -->
      <button
        v-if="canBeCompleted"
        @click.stop="completeOrder"
        :disabled="loading"
        class="bg-green-600 hover:bg-green-700 disabled:bg-gray-600 text-white rounded-lg font-medium transition-colors flex items-center justify-center"
      >
        <svg v-if="loading" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <svg v-else class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
        </svg>
        Завершить заказ
      </button>

      <!-- Отправить на доработку -->
      <button
        v-if="canBeRevised && !showRevisionModal"
        @click.stop="showRevisionModal = true"
        :disabled="loading"
        class="bg-orange-600 hover:bg-orange-700 disabled:bg-gray-600 text-white rounded-lg font-medium transition-colors flex items-center justify-center"
      >
        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
        </svg>
        Отправить на доработку
      </button>

      <!-- Встроенное поле доработки (без модалки) -->
      <div v-if="showRevisionModal" class="bg-[#0D1F31] text-white border border-[#22304a] rounded-2xl p-4 space-y-3" @click.stop @mousedown.stop>
        <label class="block text-sm font-medium text-gray-300">Комментарий к доработке</label>
        <textarea
          v-model="revisionComment"
          placeholder="Опишите подробно, что нужно доработать..."
          class="w-full rounded-xl p-3 resize-none bg-[#16243a] text-white border border-[#22304a] placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-orange-500"
          @click.stop @mousedown.stop
          rows="4"
        ></textarea>
        <div class="flex justify-between items-center text-xs text-gray-500">
          <span>{{ revisionComment.length }}/1000 символов</span>
          <span v-if="revisionComment.length > 900" class="text-orange-400">Осталось {{ 1000 - revisionComment.length }} символов</span>
        </div>
        <div class="flex flex-col gap-2">
          <button
            @click="closeRevisionModal"
            class="w-full bg-gray-600 hover:bg-gray-500 text-white py-2 px-3 rounded-lg font-medium"
          >
            Отмена
          </button>
          <button
            @click="sendToRevision"
            :disabled="!revisionComment.trim() || loading || revisionComment.length > 1000"
            class="w-full bg-orange-600 hover:bg-orange-700 disabled:bg-gray-600 disabled:cursor-not-allowed text-white py-2 px-3 rounded-lg font-medium flex items-center justify-center"
          >
            <svg v-if="loading" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            <span>{{ loading ? 'Отправка...' : 'Отправить на доработку' }}</span>
          </button>
        </div>
      </div>

      <!-- Отменить заказ -->
      <button
        v-if="canBeCancelled"
        @click.stop="cancelOrder"
        :disabled="loading"
        class="bg-red-600 hover:bg-red-700 disabled:bg-gray-600 text-white rounded-lg font-medium transition-colors flex items-center justify-center"
      >
        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
        Отменить заказ
      </button>

      <!-- Создать спор -->
      <button
        v-if="canBeDisputed"
        @click.stop="showDisputeModal = true"
        :disabled="loading"
        class="bg-red-500 hover:bg-red-600 disabled:bg-gray-600 text-white rounded-lg font-medium transition-colors flex items-center justify-center"
      >
        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"></path>
        </svg>
        Создать спор
      </button>
    </div>

    <!-- Действия для исполнителя -->
    <div v-if="isExecutor" class="executor-actions">
      <!-- Завершить работу -->
      <button
        v-if="canBeCompleted && !showFinishForm"
        @click.stop="showFinishForm = true"
        :disabled="loading"
        class="bg-blue-600 hover:bg-blue-700 disabled:bg-gray-600 text-white rounded-lg font-medium transition-colors flex items-center justify-center"
      >
        <svg v-if="loading" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938л3-2.647z"></path>
        </svg>
        <svg v-else class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
        </svg>
        Завершить работу
      </button>

      <!-- Встроенная форма отправки ссылки на готовую работу (для исполнителя) -->
      <div v-if="showFinishForm" class="bg-[#0D1F31] text-white border border-[#22304a] rounded-2xl p-4 space-y-3" @click.stop @mousedown.stop>
        <label class="block text-sm font-medium text-gray-300">Ссылка на готовую работу</label>
        <input
          v-model="finishWorkLink"
          type="url"
          placeholder="https://..."
          class="w-full rounded-xl p-3 bg-[#16243a] text-white border border-[#22304a] placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-600"
          @click.stop @mousedown.stop
        />
        <div class="text-xs text-gray-500" v-if="finishWorkLink && !isValidFinishLink">
          Укажите корректную ссылку, начинающуюся с http:// или https://
        </div>
        <div class="flex flex-col gap-2">
          <button
            @click="closeFinishForm"
            class="w-full bg-gray-600 hover:bg-gray-500 text-white py-2 px-3 rounded-lg font-medium"
          >
            Отмена
          </button>
          <button
            @click="submitFinishWork"
            :disabled="!isValidFinishLink || loading"
            class="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-gray-600 disabled:cursor-not-allowed text-white py-2 px-3 rounded-lg font-medium flex items-center justify-center"
          >
            <svg v-if="loading" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938л3-2.647z"></path>
            </svg>
            <span>{{ loading ? 'Отправка...' : 'Отправить ссылку и завершить' }}</span>
          </button>
        </div>
      </div>

      <!-- Отменить заказ -->
      <button
        v-if="canBeCancelled"
        @click.stop="cancelOrder"
        :disabled="loading"
        class="bg-red-600 hover:bg-red-700 disabled:bg-gray-600 text-white rounded-lg font-medium transition-colors flex items-center justify-center"
      >
        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
        </svg>
        Отменить заказ
      </button>

      <!-- Создать спор -->
      <button
        v-if="canBeDisputed"
        @click.stop="showDisputeModal = true"
        :disabled="loading"
        class="bg-red-500 hover:bg-red-600 disabled:bg-gray-600 text-white rounded-lg font-medium transition-colors flex items-center justify-center"
      >
        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"></path>
        </svg>
        Создать спор
      </button>
    </div>

    <!-- Модальное окно для спора -->
    <div v-if="showDisputeModal" class="fixed inset-0 bg-[#0D1F31] z-50 modal-backdrop">
      <div class="h-full flex flex-col">
        <!-- Заголовок -->
        <div class="flex items-center justify-between p-6 border-b border-[#22304a] bg-[#16243a]">
          <div class="flex items-center">
            <div class="w-12 h-12 bg-red-600 rounded-full flex items-center justify-center mr-4">
              <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"></path>
              </svg>
            </div>
            <div>
              <h3 class="text-2xl font-bold text-white">Создать спор</h3>
              <p class="text-gray-400 text-base">Опишите причину возникновения спора</p>
            </div>
          </div>
          <button 
            @click="closeDisputeModal"
            class="text-gray-400 hover:text-white transition-colors p-3 rounded-xl hover:bg-[#22304a]"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6л12 12"></path>
            </svg>
          </button>
        </div>

        <!-- Содержимое -->
        <div class="flex-1 p-6 overflow-y-auto">
          <div class="max-w-4xl mx-auto">
            <!-- Информация о заказе -->
            <div class="bg-[#16243a] rounded-2xl p-6 mb-8 border border-[#22304a]">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div class="flex items-center justify-between">
                  <span class="text-gray-400 text-base">Заказ:</span>
                  <span class="font-semibold text-lg text-white">{{ order.title }}</span>
                </div>
                <div class="flex items-center justify-between">
                  <span class="text-gray-400 text-base">Статус:</span>
                  <span class="px-3 py-1 bg-red-600 text-red-100 text-sm rounded-full font-medium">Спор</span>
                </div>
              </div>
            </div>

            <!-- Предупреждение -->
            <div class="bg-red-900/20 border border-red-600/30 rounded-2xl p-6 mb-8">
              <div class="flex items-start">
                <svg class="w-6 h-6 text-red-400 mt-1 mr-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01м-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"></path>
                </svg>
                <div>
                  <h4 class="text-red-400 font-bold text-lg mb-2">Внимание!</h4>
                  <p class="text-red-300 text-base leading-relaxed">Создание спора приведет к приостановке работы над заказом. Спор будет рассмотрен администрацией платформы.</p>
                </div>
              </div>
            </div>

            <!-- Поле для причины спора -->
            <div class="mb-8">
              <label class="block text-lg font-semibold text-white mb-4">
                Причина спора
              </label>
              <textarea
                v-model="disputeReason"
                placeholder="Подробно опишите причину возникновения спора. Укажите конкретные факты и обстоятельства..."
                class="w-full rounded-2xl p-6 resize-none bg-[#16243a] text-white border border-[#22304a] placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-all duration-200 text-base"
                rows="8"
              ></textarea>
              <div class="flex justify-between items-center mt-3">
                <span class="text-sm text-gray-500">
                  {{ disputeReason.length }}/1000 символов
                </span>
                <span v-if="disputeReason.length > 900" class="text-sm text-red-400 font-medium">
                  Осталось {{ 1000 - disputeReason.length }} символов
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Кнопки -->
        <div class="p-6 border-т border-[#22304a] bg-[#16243a]">
          <div class="max-w-4xl mx-auto flex space-x-4">
            <button
              @click="closeDisputeModal"
              class="flex-1 bg-gray-600 hover:bg-gray-500 text-white py-4 px-6 rounded-2xl font-semibold text-lg transition-colors duration-200"
            >
              Отмена
            </button>
            <button
              @click="createDispute"
              :disabled="!disputeReason.trim() || loading || disputeReason.length > 1000"
              class="flex-1 bg-red-600 hover:bg-red-700 disabled:bg-gray-600 disabled:cursor-not-allowed text-white py-4 px-6 rounded-2xl font-semibold text-lg transition-colors duration-200 flex items-center justify-center"
            >
              <svg v-if="loading" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938л3-2.647z"></path>
              </svg>
              <svg v-else class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01м-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"></path>
              </svg>
              {{ loading ? 'Создание...' : 'Создать спор' }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'OrderActions',
  props: {
    order: {
      type: Object,
      required: true
    },
    userRole: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      loading: false,
      showRevisionModal: false,
      showDisputeModal: false,
      showFinishForm: false,
      revisionComment: '',
      disputeReason: '',
      finishWorkLink: ''
    }
  },
  computed: {
    isCustomer() {
      return this.userRole === 'customer';
    },
    isExecutor() {
      return this.userRole === 'executor';
    },
    // Проверяем, можно ли завершить заказ
    canBeCompleted() {
      // Для исполнителя кнопка "Завершить работу" не должна отображаться в статусе "На проверке"
      if (this.userRole === 'executor') {
        return ['in_progress', 'revision'].includes(this.order.status);
      }
      // Для заказчика кнопка "Завершить заказ" отображается в статусах: в работе, на доработке, на проверке
      return ['in_progress', 'revision', 'pending_review'].includes(this.order.status);
    },
    // Проверяем, можно ли отправить на доработку
    canBeRevised() {
      // Кнопка доступна только заказчику и только когда исполнитель завершил работу (pending_review)
      return this.userRole === 'customer' && this.order.status === 'pending_review';
    },
    // Проверяем, можно ли отменить заказ
    canBeCancelled() {
      // Для исполнителей можно отменить заказ в статусах: открыт, на согласовании, в работе, на проверке
      if (this.userRole === 'executor') {
        return ['open', 'pending_approval', 'in_progress', 'pending_review'].includes(this.order.status);
      }
      // Для заказчиков можно отменить заказ в любом статусе кроме завершенного
      return ['open', 'pending_approval', 'in_progress', 'pending_review', 'revision'].includes(this.order.status);
    },
    // Проверяем, можно ли создать спор
    canBeDisputed() {
      return ['in_progress', 'revision'].includes(this.order.status);
    },
    isValidFinishLink() {
      if (!this.finishWorkLink) return false;
      try {
        const url = new URL(this.finishWorkLink);
        return url.protocol === 'http:' || url.protocol === 'https:';
      } catch (_) {
        return false;
      }
    }
  },
  mounted() {
    // Добавляем обработчик для закрытия модального окна по Escape
    document.addEventListener('keydown', this.handleEscape);
  },
  beforeUnmount() {
    // Удаляем обработчик при размонтировании компонента
    document.removeEventListener('keydown', this.handleEscape);
  },
  methods: {
    handleEscape(event) {
      if (event.key === 'Escape') {
        if (this.showRevisionModal) {
          this.closeRevisionModal();
        }
        if (this.showDisputeModal) {
          this.closeDisputeModal();
        }
      }
    },
    closeRevisionModal() {
      this.showRevisionModal = false;
      this.revisionComment = '';
    },
    closeDisputeModal() {
      this.showDisputeModal = false;
      this.disputeReason = '';
    },
    closeFinishForm() {
      this.showFinishForm = false;
      this.finishWorkLink = '';
    },
    async completeOrder() {
      try {
        this.loading = true;
        const { data: result } = await this.$axios.post(`/orders/${this.order.id}/complete`)
        this.$emit('order-updated', result.order);
        alert('Заказ успешно завершен!');
      } catch (error) {
        console.error('Ошибка завершения заказа:', error);
        alert(error.message);
      } finally {
        this.loading = false;
      }
    },

    async sendToRevision() {
      try {
        this.loading = true;
        const { data: result } = await this.$axios.post(`/orders/${this.order.id}/revision`, { revision_comment: this.revisionComment })
        this.$emit('order-updated', result.order);
        this.closeRevisionModal();
        alert('Заказ отправлен на доработку!');
      } catch (error) {
        console.error('Ошибка отправки на доработку:', error);
        alert(error.message);
      } finally {
        this.loading = false;
      }
    },

    async cancelOrder() {
      if (!confirm('Вы уверены, что хотите отменить заказ?')) {
        return;
      }

      try {
        this.loading = true;
        const { data: result } = await this.$axios.post(`/orders/${this.order.id}/cancel`)
        this.$emit('order-updated', result.order);
        alert('Заказ успешно отменен!');
      } catch (error) {
        console.error('Ошибка отмены заказа:', error);
        alert(error.message);
      } finally {
        this.loading = false;
      }
    },

    async createDispute() {
      try {
        this.loading = true;
        const { data: result } = await this.$axios.post(`/orders/${this.order.id}/dispute`, { dispute_reason: this.disputeReason })
        this.$emit('order-updated', result.order);
        this.closeDisputeModal();
        alert('Спор по заказу создан!');
      } catch (error) {
        console.error('Ошибка создания спора:', error);
        alert(error.message);
      } finally {
        this.loading = false;
      }
    },

    async submitFinishWork() {
      if (!this.isValidFinishLink) return;
      try {
        this.loading = true;
        // 1) Завершаем работу (статус -> pending_review)
        const { data: result } = await this.$axios.post(`/orders/${this.order.id}/finish-work`, { work_link: this.finishWorkLink.trim() });
        this.$emit('order-updated', result.order);

        // 2) Гарантируем наличие чата и отправляем ссылку заказчику
        let chatId = null;
        try {
          const { data: chat } = await this.$axios.post(`/orders/${this.order.id}/create-chat`);
          chatId = chat?.id;
        } catch (e) {
          console.warn('Не удалось создать/получить чат заказа', e);
        }
        if (chatId) {
          const content = `Ссылка на готовую работу: ${this.finishWorkLink.trim()}`;
          try {
            await this.$axios.post(`/chats/${chatId}/messages`, { content });
          } catch (e) {
            console.warn('Не удалось отправить ссылку в чат', e);
          }
        }

        alert('Работа завершена и отправлена на проверку! Ссылка направлена заказчику.');
        this.closeFinishForm();
      } catch (error) {
        console.error('Ошибка завершения работы:', error);
        alert(error.message);
      } finally {
        this.loading = false;
      }
    }
  }
}
</script>

<style scoped>
.order-actions {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.customer-actions,
.executor-actions {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

/* Фиксированная высота и полная ширина для всех кнопок */
.order-actions button {
  min-height: 42px !important;
  width: 100% !important;
  max-width: 100% !important;
  flex: none !important;
  box-sizing: border-box !important;
  margin: 0 !important;
  padding: 8px 16px !important;
}

/* Убеждаемся, что контейнеры кнопок занимают всю ширину и центрируют */
.customer-actions,
.executor-actions {
  width: 100% !important;
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
}

/* Убираем любые ограничения ширины и центрируем */
.order-actions button.w-full {
  width: 100% !important;
  min-width: 100% !important;
  max-width: none !important;
  margin: 0 !important;
}

/* Принудительно применяем стили ко всем кнопкам */
.order-actions button[class*="bg-"] {
  width: 100% !important;
  min-height: 42px !important;
  margin: 0 !important;
}

/* Убираем все возможные отступы и выравнивания */
.order-actions button {
  justify-content: center !important;
  text-align: center !important;
}

/* Анимации и прочие стили могут остаться для модального окна спора */
@keyframes modalFadeIn {
  from { opacity: 0; transform: translateY(-20px); }
  to { opacity: 1; transform: translateY(0); }
}
@keyframes modalFadeOut {
  from { opacity: 1; transform: translateY(0); }
  to { opacity: 0; transform: translateY(-20px); }
}
.modal-enter-active { animation: modalFadeIn 0.4s ease-out; }
.modal-leave-active { animation: modalFadeOut 0.3s ease-in; }
.modal-backdrop { backdrop-filter: blur(8px); transition: all 0.4s ease; }
.modal-content { transition: all 0.4s ease; }
.modal-backdrop > div { animation: modalFadeIn 0.4s ease-out; }
.modal-backdrop .overflow-y-auto { scrollbar-width: thin; scrollbar-color: #22304a #16243a; }
.modal-backdrop .overflow-y-auto::-webkit-scrollbar { width: 8px; }
.modal-backdrop .overflow-y-auto::-webkit-scrollbar-track { background: #16243a; border-radius: 4px; }
.modal-backdrop .overflow-y-auto::-webkit-scrollbar-thumb { background: #22304a; border-radius: 4px; }
.modal-backdrop .overflow-y-auto::-webkit-scrollbar-thumb:hover { background: #2d3f5a; }
</style> 