<template>
  <div class="chat-list-container redesigned">
    <!-- Top nav like the mock (can be hidden) -->
    <div v-if="showTabs" class="nav">
      <button @click="setCategory('active')" :class="['nav-link',{active:currentCategory==='active'}]">Заказы в работе ({{ getCategoryCount('active') }})</button>
      <button @click="setCategory('archive')" :class="['nav-link',{active:currentCategory==='archive'}]">Архив ({{ getCategoryCount('archive') }})</button>
      <button @click="setCategory('support')" :class="['nav-link',{active:currentCategory==='support'}]">Техническая поддержка ({{ getCategoryCount('support') }})</button>
    </div>

    <div v-if="loading" class="loading">Загрузка чатов...</div>

<div v-else-if="chats.length>0" class="list">
      <div v-for="chat in chats" :key="chat.id" @click="selectChat(chat)" :class="['item',{selected:selectedChat?.id===chat.id}]">
        <div class="ava">{{ getInitials(chat.other_user) }}</div>
        <div class="info">
          <div class="row">
            <div class="name">{{ chat.other_user?.name || 'Пользователь' }}</div>
            <div class="pill" :class="statusClass(chat.order?.status)">{{ getOrderStatusText(chat.order?.status) }}</div>
          </div>
          <div class="role">{{ getRoleText(chat) }}</div>
          <div v-if="chat.order" class="order">Заказ #{{ chat.order.id }} — {{ getWorkTypeName(chat.order.work_type) }}</div>
          <div v-if="chat.last_message" class="last">
            <span class="from">{{ chat.last_message.user?.name }}:</span>
            <span class="text">{{ chat.last_message.content }}</span>
            <span class="time">{{ formatTime(chat.last_message.created_at) }}</span>
          </div>
        </div>
        <div v-if="chat.unread_count>0" class="badge">{{ chat.unread_count>99?'99+':chat.unread_count }}</div>
      </div>
    </div>

    <div v-else class="empty">Нет сообщений</div>
  </div>
</template>

<script>
export default {
  name:'ChatList',
  props:{ 
    selectedChat:Object, 
    currentRole:{type:String,required:true,default:'customer'},
    showTabs:{type:Boolean,default:true}
  },
  data(){return{
    chats:[],
    loading:false,
    currentCategory:'active',
    allChats:[],
    chatsCache: {}, // Кэш для чатов по категориям
    lastFetchTime: 0, // Время последней загрузки
    cacheTimeout: 30000 // 30 секунд кэш
  }},
  watch:{ 
    currentRole:{handler:'fetchChats',immediate:true}, 
    currentCategory:{handler(val){ this.$emit('category-changed', val) }}
  },
  mounted(){ 
    this.updateInterval=setInterval(()=>this.fetchChats(),30000); // Увеличили интервал до 30 секунд
    this.fetchChats() 
  },
  beforeUnmount(){ if(this.updateInterval) clearInterval(this.updateInterval)},
  methods:{
    setCategory(category){ if(this.currentCategory!==category){ this.currentCategory=category; this.fetchChats() }},
            async fetchChats(){
          try{
            // Проверяем кэш
            const cacheKey = `${this.currentRole}_${this.currentCategory}`;
            const now = Date.now();
            
            if (this.chatsCache[cacheKey] && (now - this.lastFetchTime) < this.cacheTimeout) {
              this.chats = this.chatsCache[cacheKey];
              return;
            }
            
            this.loading=true;
            const { data } = await this.$axios.get(`/chats`,{ params: { role: this.currentRole, category: this.currentCategory } });
            this.chats=data;
            
            // Сохраняем в кэш
            this.chatsCache[cacheKey] = data;
            this.lastFetchTime = now;
            
            // Загружаем все чаты только один раз
            if(this.allChats.length===0) {
              await this.fetchAllChats();
            }
          }catch(e){
            console.error('Error fetching chats:', e);
            this.chats=[]
          }finally{ this.loading=false }
        },
            async fetchAllChats(){
          try{
            const results=await Promise.all(['active','archive','support'].map(c=>this.$axios.get(`/chats`,{ params: { role: this.currentRole, category: c } }).then(r=>r.data)));
            this.allChats=results.flat();
            this.$emit('counts-updated', {
              active: this.getCategoryCount('active'),
              archive: this.getCategoryCount('archive'),
              support: this.getCategoryCount('support')
            })
          }catch(e){
            console.error('Error fetching all chats:', e);
            this.allChats=[]
          }
        },
    getCategoryCount(category){ return this.allChats.filter(c=>c.category===category).length },
    getRoleText(chat){ if(chat?.other_user_role) return chat.other_user_role==='customer'?'Заказчик':'Исполнитель'; const role=localStorage.getItem('currentRole')||'customer'; return role==='customer'?'Исполнитель':'Заказчик' },
    statusClass(status){ 
      switch(status){
        case 'in_progress': return 'green-pill'; 
        case 'pending_approval': return 'yellow-pill'; 
        case 'pending_review': return 'purple-pill';
        case 'open': return 'blue-pill'; 
        case 'revision': return 'orange-pill'; 
        case 'completed': return 'green2-pill'; 
        case 'cancelled': return 'red-pill'; 
        case 'disputed': return 'red2-pill';
        default: return 'gray-pill' 
      }
    },
    getOrderStatusText(status){ switch(status){case 'open':return 'Открыт';case 'pending_approval':return 'На согласовании';case 'in_progress':return 'В работе';case 'pending_review':return 'На проверке';case 'revision':return 'На доработке';case 'completed':return 'Завершен';case 'cancelled':return 'Отменен';case 'disputed':return 'Спор';default:return 'Новый'}},
    selectChat(chat){ this.$emit('chat-selected', chat) },
    getInitials(user){ if(!user?.name) return '?'; return user.name.split(' ').map(w=>w[0]).join('').toUpperCase().slice(0,2) },
    formatTime(ts){ if(!ts) return ''; const d=new Date(ts), now=new Date(), h=(now-d)/36e5; if(h<24) return d.toLocaleTimeString('ru-RU',{hour:'2-digit',minute:'2-digit'}); if(h<48) return 'Вчера'; return d.toLocaleDateString('ru-RU',{day:'2-digit',month:'2-digit'}) },
    getWorkTypeName(w){ if(!w) return 'Не указан'; if(typeof w==='object'&&w.name) return w.name; if(typeof w==='string') return w; return 'Не указан' },
    
    clearCache() {
      // Очищаем кэш при изменении данных
      this.chatsCache = {};
      this.lastFetchTime = 0;
    }
  }
}
</script>

<style scoped>
.chat-list-container.redesigned{height:100%;padding:12px;background:#0D1F31;overflow-y:auto}
.nav{display:flex;gap:16px;margin:2px 6px 12px}
.nav-link{background:none;border:none;color:#aeb9cd;font-weight:800;font-size:14px;cursor:pointer;padding:6px 0;position:relative}
.nav-link.active{color:#fff}
.nav-link.active::after{content:"";position:absolute;left:0;right:0;bottom:-6px;height:3px;background:#2563eb;border-radius:2px}
.loading,.empty{color:#9fb0c8;text-align:center;padding:16px}
.list{display:flex;flex-direction:column;gap:8px}
.item{display:flex;gap:10px;align-items:flex-start;background:#0E1A2A;border:1px solid transparent;border-radius:12px;padding:10px;cursor:pointer;transition:.15s}
.item:hover{background:#132235}
.item.selected{border-color:#2563eb;background:#132235}
.ava{width:36px;height:36px;border-radius:50%;background:#2563eb;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800}
.info{flex:1;min-width:0}
.row{display:flex;align-items:center;justify-content:space-between}
.name{color:#fff;font-weight:700;font-size:14px}
.pill{border-radius:999px;padding:4px 10px;font-size:10px;font-weight:800}
.green-pill{background:#10b981;color:#fff}
.green2-pill{background:#34d399;color:#fff}
.yellow-pill{background:#f59e0b;color:#fff}
.purple-pill{background:#8b5cf6;color:#fff}
.orange-pill{background:#f97316;color:#fff}
.red-pill{background:#ef4444;color:#fff}
.red2-pill{background:#dc2626;color:#fff}
.blue-pill{background:#3b82f6;color:#fff}
.gray-pill{background:#6b7280;color:#fff}
.role{color:#9fb0c8;font-size:12px}
.order{color:#60a5fa;font-size:12px;font-weight:700;margin-top:2px}
.last{color:#d1d5db;font-size:12px;margin-top:4px;display:flex;gap:6px;align-items:center;white-space:nowrap;overflow:hidden}
.from{font-weight:700}
.text{flex:1;overflow:hidden;text-overflow:ellipsis}
.time{color:#9fb0c8;font-size:10px}
.badge{background:#64748b;color:#fff;border-radius:999px;min-width:22px;height:22px;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:800;margin-left:8px}
</style>
