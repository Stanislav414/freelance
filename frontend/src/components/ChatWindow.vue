<template>
  <div class="chat-window-container">
    <!-- Заголовок чата -->
    <div v-if="chat" class="chat-header bg-[#16243a] rounded-t-lg p-3 border-b border-[#22304a]">
      <div class="flex items-center justify-between">
        <div class="flex items-center">
          <div class="w-10 h-10 bg-blue-600 rounded-full flex items-center justify-center mr-3">
            <span class="text-white font-semibold text-sm">
              {{ getInitials(chat.other_user) }}
            </span>
          </div>
          <div>
            <h3 class="text-white font-semibold text-base clickable-user" @click="goToUserProfile()">{{ chat.other_user?.name || 'Пользователь' }}</h3>
            <p class="text-gray-400 text-xs">{{ getRoleText() }}</p>
            <div v-if="chat.order" class="mt-1">
              <p class="text-blue-400 text-xs font-medium">
                Заказ #{{ chat.order.id }} - {{ getWorkTypeName(chat.order.work_type) }}
              </p>
            </div>
          </div>
        </div>
        <div class="flex items-center space-x-2">
          <span 
            :class="[
              'pill',
              getOrderStatusClass(chat.order?.status)
            ]"
          >
            {{ getOrderStatusText(chat.order?.status) }}
          </span>
          
          <!-- Кнопка "Оставить отзыв" для завершенных заказов -->
          <button
            v-if="shouldShowReviewButton()"
            @click="openReviewModal"
            class="review-btn bg-[#146AF1] hover:bg-[#0f5cd9] text-white px-4 py-2 rounded-lg text-sm font-medium transition-all duration-200 flex items-center space-x-2"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"></path>
            </svg>
            <span>Оставить отзыв</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Пустое состояние -->
    <div v-else class="empty-chat bg-[#16243a] rounded-lg p-6 text-center">
      <div class="text-gray-400 mb-3">
        <svg class="w-12 h-12 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>
        </svg>
      </div>
      <h3 class="text-white font-semibold mb-1 text-sm">Выберите чат</h3>
      <p class="text-gray-400 text-xs">Выберите чат из списка слева для начала переписки</p>
    </div>

    <!-- Окно чата -->
    <div v-if="chat" class="chat-content">
      <!-- Сообщения -->
      <div ref="messagesContainer" class="messages-container bg-[#0D1F31] flex-1 overflow-y-auto p-4">
        <div v-if="loading" class="text-center py-6">
          <div class="animate-spin rounded-full h-5 w-5 border-b-2 border-blue-500 mx-auto mb-2"></div>
          <span class="text-gray-400 text-xs">Загрузка сообщений...</span>
        </div>

        <div v-else-if="messages.length > 0" class="messages-list space-y-3 max-w-2xl mx-auto">
          <div 
            v-for="message in messages" 
            :key="message.id"
            :class="[
              'message-item flex',
              message.type === 'system' ? 'justify-center' : 
              message.user_id === currentUserId ? 'justify-end' : 'justify-start'
            ]"
          >
            <div 
              :class="[
                'message-bubble px-4 py-3 rounded-2xl max-w-full sm:max-w-2xl',
                message.type === 'system' 
                  ? 'bg-gray-600/70 text-gray-200 border border-gray-500/60' 
                  : message.user_id === currentUserId 
                    ? 'bg-blue-600 text-white shadow-lg shadow-blue-900/40' 
                    : 'bg-[#1a2a44] text-white border border-[#22304a]'
              ]"
            >
              <div class="message-content">
                <p class="text-sm leading-relaxed whitespace-pre-wrap break-words">{{ message.content }}</p>
              </div>
              <div :class="['message-meta flex items-center mt-2 gap-2', (message.user_id===currentUserId && message.type!=='system') ? 'justify-end' : 'justify-start']">
                <span class="text-[11px] opacity-75">{{ formatTime(message.created_at) }}</span>
                <span v-if="message.user_id===currentUserId && message.type!=='system'" class="flex items-center ml-2">
                  <img v-if="!message.read_at" :src="getAsset('shipped.png')" alt="sent" class="tick-img" />
                  <img v-else :src="getAsset('read.png')" alt="read" class="tick-img" />
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Пустое состояние для сообщений -->
        <div v-else class="empty-messages text-center py-6">
          <div class="text-gray-400 mb-3">
            <svg class="w-10 h-10 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>
            </svg>
          </div>
          <h3 class="text-white font-semibold mb-1 text-sm">Нет сообщений</h3>
          <p class="text-gray-400 text-xs">Начните переписку, отправив первое сообщение</p>
        </div>
      </div>

      <!-- Форма отправки сообщения -->
      <div class="message-input-container bg-[#16243a] rounded-b-lg p-3 border-t border-[#22304a]">
        <div class="flex items-center space-x-3 max-w-5xl mx-auto w-full">
          <div class="flex-1 flex items-center">
            <textarea
              v-model="newMessage"
              @keydown.enter.prevent="handleEnterKey"
              @input="autoResize"
              placeholder="Начните писать сообщение..."
              class="w-full bg-[#0D1F31] text-white border-2 border-[#22304a] rounded-xl px-4 py-3 resize-none focus:border-blue-500 focus:outline-none transition-all duration-200 text-sm min-h-[48px] max-h-[120px]"
              rows="1"
              ref="messageInput"
            ></textarea>
          </div>
          <button
            type="submit"
            :disabled="!newMessage.trim() || sending"
            @click="sendMessage"
            class="send-button bg-[#146AF1] hover:bg-[#0f5cd9] disabled:bg-gray-600 disabled:cursor-not-allowed text-white p-3 rounded-xl transition-all duration-200 flex items-center justify-center min-w-[48px] h-[48px] shadow-lg hover:shadow-xl transform hover:scale-105 active:scale-95 flex-shrink-0"
          >
            <div v-if="sending" class="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
            <img v-else :src="getAsset('button_chat.png')" alt="Отправить" class="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
    
    <!-- Модальное окно отзыва -->
    <ReviewModal
      v-if="showReviewModal"
      :order="chat?.order"
      @close="showReviewModal = false"
      @review-submitted="onReviewSubmitted"
    />
  </div>
</template>

<script>
import ReviewModal from './ReviewModal.vue'

export default {
  name: 'ChatWindow',
  components: { ReviewModal },
  props: { chat: { type: Object, default: null } },
  data() {
    return { 
      messages: [], 
      newMessage: '', 
      loading: false, 
      sending: false, 
      currentUserId: null, 
      showCategoryMenu: false,
      showReviewModal: false
    }
  },
  watch: {
    chat: { handler: 'loadMessages', immediate: true },
    messages: {
      handler() { this.$nextTick(() => this.scrollToBottom()) },
      deep: true
    }
  },
  mounted(){ const user = JSON.parse(localStorage.getItem('user') || '{}'); this.currentUserId = user.id },
  methods: {
    async loadMessages(){
      if(!this.chat){ this.messages=[]; return }
      try{
        this.loading=true;
        // Загружаем только последние 200 сообщений для скорости
        const { data } = await this.$axios.get(`/chats/${this.chat.id}/messages`, { params: { limit: 200 } });
        this.messages = data;
        // Бэкэнд уже отметил как прочитанные перед отдачей, поэтому повторно не дергаем
        // Скролл вниз сразу и через небольшой таймаут, чтобы учесть рендер и возможную подгрузку контента
        this.$nextTick(()=>{ this.scrollToBottom() });
        setTimeout(()=> this.scrollToBottom(), 80);
        setTimeout(()=> this.scrollToBottom(), 200);
      }catch(e){
        console.error('Ошибка загрузки сообщений:',e); this.messages=[]
      }finally{ this.loading=false }
    },
    async markMessagesAsRead(){ /* больше не требуется отдельный вызов */ },
    async sendMessage(){ if(!this.newMessage.trim()||!this.chat) return; try{ this.sending=true; const { data:newMessage } = await this.$axios.post(`/chats/${this.chat.id}/messages`,{content:this.newMessage.trim()}); this.messages.push(newMessage); this.newMessage=''; this.$nextTick(()=>{ this.scrollToBottom(); this.$refs.messageInput?.focus(); this.resetTextareaHeight(); }); this.$emit('message-sent', newMessage); this.$emit('messages-read'); setTimeout(()=>{ newMessage.status='delivered' },1000); setTimeout(()=>{ newMessage.status='read' },2000) }catch(e){ console.error('Ошибка отправки сообщения:',e); alert('Ошибка отправки сообщения') }finally{ this.sending=false }},
    async changeCategory(category){ if(!this.chat) return; try{ await this.$axios.put(`/chats/${this.chat.id}/category`,{category}); this.chat.category=category; this.showCategoryMenu=false; this.$emit('chat-category-changed', {chatId:this.chat.id, category}); alert('Категория чата изменена') }catch(e){ console.error('Ошибка изменения категории:',e); alert('Ошибка изменения категории') }},
    getRoleText(){ if(this.chat?.other_user_role){ return this.chat.other_user_role==='customer'?'Заказчик':'Исполнитель' } const currentRole=localStorage.getItem('currentRole')||'customer'; return currentRole==='customer'?'Исполнитель':'Заказчик' },
    getOrderStatusClass(status) {
      switch (status) {
        case 'open':
          return 'blue-pill';
        case 'pending_approval':
          return 'yellow-pill';
        case 'in_progress':
          return 'green-pill';
        case 'pending_review':
          return 'purple-pill';
        case 'revision':
          return 'orange-pill';
        case 'completed':
          return 'green2-pill';
        case 'cancelled':
          return 'red-pill';
        case 'disputed':
          return 'red2-pill';
        default:
          return 'gray-pill';
      }
    },
    getOrderStatusText(status){ switch(status){case 'open':return 'Открыт';case 'pending_approval':return 'На согласовании';case 'in_progress':return 'В работе';case 'pending_review':return 'На проверке';case 'revision':return 'На доработке';case 'completed':return 'Завершен';case 'cancelled':return 'Отменен';case 'disputed':return 'Спор';default:return 'Новый'} },
    scrollToBottom(){ const el=this.$refs.messagesContainer; if(el){ el.scrollTop=el.scrollHeight } },
    getInitials(user){ if(!user?.name) return '?'; return user.name.split(' ').map(w=>w.charAt(0)).join('').toUpperCase().slice(0,2) },
    formatTime(ts){ if(!ts) return ''; const d=new Date(ts), now=new Date(), h=(now-d)/36e5; if(h<24) return d.toLocaleTimeString('ru-RU',{hour:'2-digit',minute:'2-digit'}); if(h<48) return 'Вчера '+d.toLocaleTimeString('ru-RU',{hour:'2-digit',minute:'2-digit'}); return d.toLocaleDateString('ru-RU',{day:'2-digit',month:'2-digit',hour:'2-digit',minute:'2-digit'}) },
    getWorkTypeName(w){ if(!w) return 'Не указан'; if(typeof w==='object'&&w.name) return w.name; if(typeof w==='string') return w; return 'Не указан' }
    ,getMessageStatusLabel(){ return '' }
    ,getAsset(name){ try{ return new URL(`../assets/${name}`, import.meta.url).href }catch{ return '' } }
    ,autoResize(){
      const el = this.$refs.messageInput;
      if (el) {
        el.style.height = 'auto';
        el.style.height = el.scrollHeight + 'px';
      }
    },
    resetTextareaHeight(){
      const el = this.$refs.messageInput;
      if (el) {
        el.style.height = '48px';
      }
    },
    handleEnterKey(event) {
      if (event.shiftKey) {
        // Shift + Enter - добавляем новую строку
        this.newMessage += '\n';
      } else {
        // Enter - отправляем сообщение
        this.sendMessage();
      }
    },
    shouldShowReviewButton() {
      // Проверяем, что заказ завершен и пользователь может оставить отзыв
      if (!this.chat?.order || this.chat.order.status !== 'completed') {
        return false;
      }
      
      // Используем флаг can_review из backend
      return this.chat.order.can_review === true;
    },
    openReviewModal() {
      this.showReviewModal = true;
    },
    onReviewSubmitted() {
      this.showReviewModal = false;
      this.$emit('review-submitted');
    },
    goToUserProfile() {
      if (!this.chat?.other_user?.id) return;
      
      // Определяем роль другого пользователя на основе заказа
      const isOtherUserCustomer = this.chat.order?.user_id === this.chat.other_user.id;
      const isOtherUserExecutor = this.chat.order?.executor_id === this.chat.other_user.id;
      
      if (isOtherUserCustomer) {
        // Другой пользователь - заказчик, переходим к профилю заказчика
        this.$router.push(`/profile/customer/${this.chat.other_user.id}`);
      } else if (isOtherUserExecutor) {
        // Другой пользователь - исполнитель, переходим к портфолио
        this.$router.push(`/portfolio/${this.chat.other_user.id}`);
      } else {
        // Если роль не определена, переходим к портфолио по умолчанию
        this.$router.push(`/portfolio/${this.chat.other_user.id}`);
      }
    }
  }
}
</script>

<style scoped>
.chat-window-container {
  height: 100%;
  display: flex;
  flex-direction: column;
  background: #0D1F31;
  border-radius: 16px;
  overflow: hidden;
}

.chat-header {
  flex-shrink: 0;
}

.chat-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.messages-container {
  flex: 1;
  overflow-y: auto;
}

/* Стилизация скроллбара для Webkit браузеров (Chrome, Safari, Edge) */
.messages-container::-webkit-scrollbar {
  width: 6px;
}

.messages-container::-webkit-scrollbar-track {
  background: transparent;
}

.messages-container::-webkit-scrollbar-thumb {
  background: rgba(34, 48, 74, 0.6);
  border-radius: 3px;
  transition: background 0.2s ease;
}

.messages-container::-webkit-scrollbar-thumb:hover {
  background: rgba(34, 48, 74, 0.8);
}

/* Скрываем скроллбар для Firefox */
.messages-container {
  scrollbar-width: thin;
  scrollbar-color: rgba(34, 48, 74, 0.6) transparent;
}

.message-input-container {
  flex-shrink: 0;
}

.pill {
  border-radius: 999px;
  padding: 4px 10px;
  font-size: 10px;
  font-weight: 800;
}

.blue-pill { background: #3b82f6; color: white; }
.yellow-pill { background: #f59e0b; color: white; }
.green-pill { background: #10b981; color: white; }
.purple-pill { background: #8b5cf6; color: white; }
.orange-pill { background: #f97316; color: white; }
.green2-pill { background: #34d399; color: white; }
.red-pill { background: #ef4444; color: white; }
.red2-pill { background: #dc2626; color: white; }
.gray-pill { background: #6b7280; color: white; }

.review-btn {
  box-shadow: 0 2px 8px rgba(20, 106, 241, 0.3);
}

.review-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(20, 106, 241, 0.4);
}

/* Стили для кликабельного имени пользователя */
.clickable-user {
  cursor: pointer;
  transition: all 0.2s ease;
  text-decoration: underline;
  text-decoration-color: transparent;
}

.clickable-user:hover {
  color: #3b82f6 !important;
  text-decoration-color: #3b82f6;
  transform: translateY(-1px);
}

.messages-list {
  padding-bottom: 20px;
}

.message-item {
  margin-bottom: 16px;
}

.message-bubble {
  max-width: 70%;
  word-wrap: break-word;
}

.message-content {
  margin-bottom: 4px;
}

.message-meta {
  font-size: 11px;
  opacity: 0.7;
}

.tick-img {
  width: 16px;
  height: 16px;
  opacity: 0.7;
}

.empty-chat, .empty-messages {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #9ca3af;
}

.send-button {
  transition: all 0.2s ease;
}

.send-button:hover:not(:disabled) {
  transform: scale(1.05);
}

.send-button:active:not(:disabled) {
  transform: scale(0.95);
}
</style>
