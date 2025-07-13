<template>
  <div class="dashboard-bg min-h-screen w-full flex justify-center items-start py-8">
    <div class="dashboard-container w-full max-w-[1400px] flex gap-8">
      <!-- Левая панель -->
      <aside class="w-72 flex flex-col gap-6">
        <UserDropdown :user="user" @logout="logout" />
        <nav class="flex flex-col gap-2 bg-[#0D1F31] rounded-4xl w-full p-4">
          <div v-for="item in menu" :key="item.label" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-[#146AF128] cursor-pointer">
            <img src="@/assets/orders.png" class="w-8 h-8" alt="icon" />
            <span>{{ item.label }}</span>
          </div>
        </nav>
        <button @click="showCreateOrderModal = true" class="mt-4 bg-blue-600 hover:bg-blue-700 text-white font-semibold px-6 py-5 rounded-2xl transition-colors w-full">Создать новый заказ</button>
      </aside>

      <!-- Центральная часть -->
      <main class="flex-1 flex flex-col gap-8">
        <div class="flex items-center gap-4">
          <input type="text" placeholder="Поиск" class="bg-[#0D1F31] text-white px-5 py-3 rounded-4xl w-full focus:outline-none focus:ring-2 focus:ring-blue-500" />
        </div>
        <section>
          <h2 class="text-xl font-bold mb-4">Все заказы</h2>
          <div v-if="orders.length === 0" class="text-center text-white mt-8">Нет заказов</div>
          <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div
              v-for="order in orders"
              :key="order.id"
              class="bg-[#0D1F31] rounded-3xl p-6 flex flex-col gap-4 shadow-lg relative hover:bg-[#146AF128] cursor-pointer transition-colors"
              @click="openOrderModal(order)"
            >
              <!-- Верх: название и статус -->
              <div class="flex items-center gap-3 mb-2">
                <h3 class="text-lg font-semibold flex-1">{{ order.title }}</h3>
                <span
                  v-if="statusText(order.status)"
                  class="px-3 py-1 rounded-full text-xs font-semibold"
                  :class="statusClass(order.status)"
                >
                  {{ statusText(order.status) }}
                </span>
              </div>
              <!-- Срок -->
              <div class="text-sm text-gray-400 mb-2">
                До {{ order.deadline ? formatDate(order.deadline) : '—' }}
              </div>
              <!-- Описание/комментарий -->
              <div class="flex items-center gap-3 bg-[#19223a] rounded-xl p-3 mb-2">
                <img
                  v-if="order.user && order.user.avatar"
                  :src="order.user.avatar"
                  class="w-8 h-8 rounded-full object-cover"
                  alt="аватар"
                />
                <div>
                  <div class="font-semibold text-sm">{{ order.user?.name || '—' }}</div>
                  <div class="text-xs text-gray-300 truncate max-w-xs">
                    {{ order.description || 'Нет описания' }}
                  </div>
                </div>
              </div>
              <!-- Стоимость -->
              <div class="flex items-center mt-auto">
                <div class="text-xs text-gray-400 mr-2">Вы получите</div>
                <div class="text-lg font-bold">{{ order.budget ? order.budget + '₽' : '—' }}</div>
              </div>
            </div>
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
        :order="selectedOrder"
        @close="closeOrderModal"
      />
    </transition>
  </div>
</template>

<script>
import CreateOrder from "./CreateOrder.vue";
import UserDropdown from "../components/UserDropdown.vue";
import performer from '@/assets/performer.png';
import OrderDetailsModal from "./OrderDetailsModal.vue"; // Added import for OrderDetailsModal

export default {
  components: { CreateOrder, UserDropdown, OrderDetailsModal }, // Added OrderDetailsModal to components
  data() {
    return {
      user: {
        ...JSON.parse(localStorage.getItem('user') || '{}'),
        avatar: performer,
      },
      orders: [],
      showCreateOrderModal: false,
      selectedOrder: null, // Added for order details modal
      showOrderModal: false, // Added for order details modal
      menu: [
        { label: 'Все заказы' },
        { label: 'Заказы в работе' },
        { label: 'Завершенные заказы' },
        { label: 'Архив' },
        { label: 'Чаты с исполнителями' },
      ]
    }
  },
  mounted() {
    this.fetchOrders();
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
    openOrderModal(order) {
      this.selectedOrder = order;
      this.showOrderModal = true;
    },
    closeOrderModal() {
      this.showOrderModal = false;
      this.selectedOrder = null;
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
}
* {
  color: #fff !important;
}
.modal-overlay {
  position: fixed;
  z-index: 50;
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
</style>