<template>
  <div class="dashboard-bg min-h-screen w-full flex justify-center items-start py-8">
    <div class="dashboard-container w-full max-w-[1400px] flex gap-8">
      <!-- Левая панель -->
      <aside class="w-72 flex flex-col gap-6">
        <UserDropdown :user="user" @logout="logout" />
        <nav class="flex flex-col gap-2 bg-[#0D1F31] rounded-4xl w-full p-4">
          <div v-for="item in menu" :key="item.label" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-[#146AF128] cursor-pointer"
            :class="{ 'bg-[#22304a]': currentTab === item.value }"
            @click="currentTab = item.value">
            <img src="@/assets/orders.png" class="w-8 h-8" alt="icon" />
            <span>{{ item.label }}</span>
          </div>
        </nav>
        <button @click="showCreateOrderModal = true" class="mt-4 bg-blue-600 hover:bg-blue-700 text-white font-semibold px-6 py-5 rounded-2xl transition-colors w-full">Создать новый заказ</button>
      </aside>

      <!-- Центральная часть -->
      <main class="flex-1 flex flex-col gap-8">
        <div class="flex items-center gap-4 justify-between">
          <input type="text" placeholder="Поиск" class="bg-[#0D1F31] text-white px-5 py-3 rounded-4xl w-full focus:outline-none focus:ring-2 focus:ring-blue-500" />
          
        </div>
        <section>
          <div class="orders-header-row mb-4 flex items-center justify-between gap-4">
            <h2 class="text-xl font-bold">{{ currentTabLabel }}</h2>
            <div class="order-filter-box gap-2">
              <select v-model="statusFilter" class="order-filter-select">
                <option value="all">Все статусы</option>
                <option value="open">Открыт</option>
                <option value="in_progress">В работе</option>
        
              </select>
              <select v-model="workTypeFilter" class="order-filter-select">
                <option value="all">Все типы</option>
                <option v-for="type in workTypes" :key="type.id" :value="type.id">{{ type.name }}</option>
              </select>
            </div>
          </div>
          <div v-if="filteredOrders.length === 0" class="text-center text-white mt-8">Нет заказов</div>
          <div v-else class="orders-grid">
            <OrderCard
              v-for="order in filteredOrders"
              :key="order.id"
              :order="mapOrder(order)"
              @take="openOrderModal"
            />
          </div>
        </section>
      </main>
    </div>
    <!-- Модальное окно создания заказа -->
    <transition name="fade">
      <div v-if="showCreateOrderModal" class="modal-overlay" @click.self="closeCreateOrderModal">
        <div class="modal-content">
          <CreateOrder @close="closeCreateOrderModal" @order-created="onOrderCreated" />
        </div>
      </div>
    </transition>
    <!-- Модальное окно с подробностями заказа -->
    <transition name="fade">
      <OrderDetailsModal
        v-if="showOrderModal"
        :order="detailedOrder"
        :loading="loadingOrder"
        @close="closeOrderModal"
        @order-updated="onOrderUpdated"
      />
    </transition>
  </div>
</template>

<script>
import CreateOrder from "./CreateOrder.vue";
import UserDropdown from "../components/UserDropdown.vue";
import performer from '@/assets/performer.png';
import OrderDetailsModal from "./OrderDetailsModal.vue";
import OrderCard from "../components/OrderCard.vue";

export default {
  components: { CreateOrder, UserDropdown, OrderDetailsModal, OrderCard },
  data() {
    return {
      user: {
        ...JSON.parse(localStorage.getItem('user') || '{}'),
        avatar: performer,
      },
      orders: [],
      showCreateOrderModal: false,
      detailedOrder: null, // Для подробного заказа
      loadingOrder: false, // Для лоадера
      showOrderModal: false, // Для модального окна
      menu: [
        { label: 'Все заказы', value: 'all' },
        { label: 'Заказы в работе', value: 'in_progress' },
        { label: 'Завершенные заказы', value: 'done' },
        { label: 'Архив', value: 'archive' },
        { label: 'Сообщения', value: 'messages' },
      ],
      currentTab: 'all',
      statusFilter: 'all',
      workTypes: [],
      workTypeFilter: 'all',
    }
  },
  computed: {
    filteredOrders() {
      let base = [];
      if (this.currentTab === 'all') {
        base = this.orders.filter(o => o.status === 'open' || o.status === 'in_progress');
      } else if (this.currentTab === 'in_progress') {
        base = this.orders.filter(o =>
          o.status === 'in_progress' &&
          (o.executor_id === this.user.id || o.user_id === this.user.id)
        );
      } else if (this.currentTab === 'done') {
        base = this.orders.filter(o => o.status === 'done' && (o.executor_id === this.user.id || o.user_id === this.user.id));
      } else if (this.currentTab === 'archive') {
        base = this.orders.filter(o => o.status === 'archived' && (o.executor_id === this.user.id || o.user_id === this.user.id));
      } else if (this.currentTab === 'messages') {
        base = [];
      } else {
        base = this.orders;
      }
      if (this.statusFilter !== 'all') base = base.filter(o => o.status === this.statusFilter);
      if (this.workTypeFilter !== 'all') base = base.filter(o => String(o.work_type_id) === String(this.workTypeFilter));
      return base;
    },
    currentTabLabel() {
      const found = this.menu.find(m => m.value === this.currentTab);
      return found ? found.label : '';
    }
  },
  mounted() {
    this.fetchOrders();
    this.fetchWorkTypes();
  },
  methods: {
    async fetchOrders() {
      try {
        const token = localStorage.getItem('token');
        const res = await fetch('/api/orders', {
          headers: token ? { 'Authorization': 'Bearer ' + token } : {}
        });
        if (!res.ok) throw new Error('Ошибка загрузки заказов');
        const data = await res.json();
        this.orders = Array.isArray(data.data) ? data.data : data;
      } catch (e) {
        this.orders = [];
      }
    },
    async fetchWorkTypes() {
      try {
        const res = await fetch('/api/work-types', { headers: { 'Accept': 'application/json' } });
        if (!res.ok) throw new Error('Ошибка загрузки типов работ');
        this.workTypes = await res.json();
      } catch (e) {
        this.workTypes = [];
      }
    },
    closeCreateOrderModal() {
      this.showCreateOrderModal = false;
    },
    onOrderCreated() {
      this.showCreateOrderModal = false;
      this.fetchOrders();
    },
    logout() {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      this.$router.push('/login')
    },
    async openOrderModal(order) {
      this.loadingOrder = true;
      this.detailedOrder = null;
      this.showOrderModal = true;
      try {
        const token = localStorage.getItem('token');
        const res = await fetch(`/api/orders/${order.id}`, {
          headers: token ? { 'Authorization': 'Bearer ' + token } : {}
        });
        if (!res.ok) throw new Error('Ошибка загрузки заказа');
        const data = await res.json();
        this.detailedOrder = data.data || data;
      } catch (e) {
        this.detailedOrder = null;
      } finally {
        this.loadingOrder = false;
      }
    },
    closeOrderModal() {
      this.showOrderModal = false;
      this.detailedOrder = null;
      this.loadingOrder = false;
    },
    onOrderUpdated(order) {
      this.detailedOrder = order;
      this.fetchOrders();
    },
    statusText(status) {
      switch (status) {
        case 'open': return '';
        case 'in_progress': return 'В работе';
        case 'waiting_payment': return 'Ожидание оплаты';
        case 'done': return 'Завершён';
        default: return status || '—';
      }
    },
    statusClass(status) {
      switch (status) {
        case 'open': return 'bg-green-600 text-white';
        case 'in_progress': return 'bg-yellow-400 text-black';
        case 'waiting_payment': return 'bg-green-400 text-white';
        case 'done': return 'bg-gray-400 text-white';
        default: return 'bg-gray-600 text-white';
      }
    },
    formatDate(date) {
      // форматировать дату как "6 июля"
      const d = new Date(date);
      return d.toLocaleDateString('ru-RU', { day: 'numeric', month: 'long' });
    },
    mapOrder(order) {
      return {
        ...order,
        work_type_name: order.workType?.name || order.work_type_name || '',
        title: order.title,
        deadline_human: order.deadline ? this.formatDate(order.deadline) : '—',
        budget: order.budget || '—',
      };
    }
  }
}
</script>

<style scoped>
.dashboard-bg {
  background: #071727;
}
.dashboard-container {
  min-height: 80vh;
  max-width: 1100px;
}
* {
  color: #fff !important;
}
.orders-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  align-items: stretch;
  justify-content: center;
}
.modal-overlay {
  position: fixed;
  z-index: 50;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(10, 20, 40, 0.3); /* было 0.6, стало 0.3 для большей прозрачности */
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
}
.modal-content {
  background: #0D1F31;
  border-radius: 2rem;
  box-shadow: 0 8px 32px rgba(0,0,0,0.25);
  padding: 0;
  min-width: 400px;
  max-width: 90vw;
}
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.2s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
.order-filter-box {
  min-width: 170px;
  display: flex;
  align-items: center;
  justify-content: flex-end;
}
.order-filter-select {
  background: #19223a;
  color: #fff;
  border: 1px solid #22304a;
  border-radius: 0.7rem;
  padding: 0.5rem 1.2rem;
  font-size: 1rem;
  outline: none;
}
.orders-header-row {
  margin-bottom: 1.5rem;
}
</style>