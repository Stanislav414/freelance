<template>
  <div class="chat-interface-container">
    <!-- Tabs only (like target mock) -->
    <div class="tabs-bar">
      <button @click="setCategory('active')" :class="['tab',{active:activeCategory==='active'}]">
        Заказы в работе <span v-if="counts.active!==null" class="muted">({{ counts.active }})</span>
      </button>
      <button @click="setCategory('archive')" :class="['tab',{active:activeCategory==='archive'}]">
        Архив <span v-if="counts.archive!==null" class="muted">({{ counts.archive }})</span>
      </button>
      <button @click="setCategory('support')" :class="['tab',{active:activeCategory==='support'}]">
        Техническая поддержка
      </button>
    </div>

    <div class="chat-layout">
      <div class="chat-list-panel">
        <ChatList 
          ref="chatList"
          :selectedChat="selectedChat"
          :currentRole="currentRole"
          :showTabs="false"
          @chat-selected="selectChat"
          @category-changed="onCategoryChanged"
          @counts-updated="onCountsUpdated"
        />
      </div>
      <div class="chat-window-panel">
        <ChatWindow 
          :chat="selectedChat"
          @message-sent="onMessageSent"
          @messages-read="onMessagesRead"
          @chat-category-changed="onChatCategoryChanged"
          @review-submitted="onReviewSubmitted"
        />
      </div>
    </div>
  </div>
</template>

<script>
import ChatList from './ChatList.vue'
import ChatWindow from './ChatWindow.vue'

export default {
  name: 'ChatInterface',
  components: { ChatList, ChatWindow },
  props: { currentRole: { type: String, required: true, default: 'customer' } },
  data() { 
    return { 
      selectedChat: null,
      activeCategory: (typeof window!== 'undefined' && localStorage.getItem('chatActiveCategory')) || 'active',
      counts: { active: null, archive: null, support: null }
    }
  },
      mounted() {
      // Component mounted
    },
          watch: {
          currentRole: {
            handler(newRole, oldRole) {
              this.selectedChat = null;
              // Принудительно обновляем чаты при смене роли
              this.$nextTick(() => {
                if (this.$refs.chatList) {
                  this.$refs.chatList.fetchChats();
                }
              });
            },
            immediate: true
          }
        },
  methods: {
    selectChat(chat) { this.selectedChat = chat },
    onMessageSent() { 
      // Очищаем кэш при отправке сообщения для обновления списка
      this.$refs.chatList?.clearCache();
    },
    onMessagesRead() { this.$refs.chatList?.fetchChats() },
    onChatCategoryChanged() { this.$refs.chatList?.fetchChats(); this.$refs.chatList?.fetchAllChats() },
    setCategory(category){
      this.activeCategory=category;
      try{ localStorage.setItem('chatActiveCategory', category) }catch{}
      this.$refs.chatList?.setCategory(category)
    },
    onCategoryChanged(category){
      this.activeCategory=category;
      try{ localStorage.setItem('chatActiveCategory', category) }catch{}
    },
    onCountsUpdated(payload){ this.counts = { ...this.counts, ...payload } },
    onReviewSubmitted() { this.$refs.chatList?.fetchChats() }
  }
}
</script>

<style scoped>
.chat-interface-container { height: calc(100vh - 140px); background:#0D1F31; border-radius:16px; overflow:hidden; display:flex; flex-direction:column }
.tabs-bar{padding:14px 18px 6px; border-bottom:1px solid #22304a; display:flex; gap:22px}
.tab{background:none;border:none;color:#aeb9cd;font-weight:800;font-size:18px;cursor:pointer;position:relative;padding:2px 0}
.tab.active{color:#fff}
.tab.active::after{content:"";position:absolute;left:0;right:0;bottom:-10px;height:3px;background:#2563eb;border-radius:2px}
.tab .muted{color:#95a7c2;font-weight:700}
.chat-layout { display:grid; grid-template-columns: 320px 1fr; height:calc(100% - 60px); overflow:hidden }
.chat-list-panel { background:#0D1F31; border-right:1px solid #22304a; overflow-y:auto; overflow-x:hidden }
.chat-window-panel { display:flex; flex-direction:column; height:100%; overflow:hidden }

/* Мобильная адаптация для чата */
@media(max-width: 900px){ 
  .chat-layout{ 
    grid-template-columns: 1fr; 
    height: calc(100vh - 200px);
  } 
  
  .chat-window-panel{ 
    display: none; 
  }
  
  .chat-interface-container {
    height: calc(100vh - 200px);
  }
  
  .tabs-bar {
    padding: 12px 16px 8px;
    gap: 16px;
  }
  
  .tab {
    font-size: 16px;
    padding: 4px 0;
  }
  
  .tab.active::after {
    bottom: -8px;
    height: 2px;
  }
}

/* Очень маленькие экраны */
@media(max-width: 480px) {
  .chat-layout {
    height: calc(100vh - 180px);
  }
  
  .chat-interface-container {
    height: calc(100vh - 180px);
  }
  
  .tabs-bar {
    padding: 10px 12px 6px;
    gap: 12px;
  }
  
  .tab {
    font-size: 14px;
  }
}
</style>
