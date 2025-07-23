<template>
  <div class="dashboard-bg min-h-screen w-full flex justify-center items-start py-8">
    <div class="dashboard-container w-full max-w-[1400px] flex gap-8">
      <!-- Левая панель -->
      <aside class="w-72 flex flex-col gap-6">
        <UserDropdown :user="user" @logout="logout" class="mb-2" />
        <div class="menu-block bg-[#0D1F31] rounded-3xl w-full p-3 flex flex-col gap-2">
          <div class="role-switcher-oval flex items-center justify-between rounded-full p-1 mb-2 bg-[#16243a] w-full" style="box-sizing: border-box;">
            <button :class="['role-btn-oval', role === 'customer' ? 'active' : '']" @click="setRole('customer')">Заказчик</button>
            <button :class="['role-btn-oval', role === 'performer' ? 'active' : '']" @click="setRole('performer')">Исполнитель</button>
          </div>
          <div v-for="item in currentMenu" :key="item.label" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-[#146AF128] cursor-pointer"
            :class="{ 'bg-[#22304a]': currentTab === item.value }"
            @click="currentTab = item.value">
            <img v-if="item.icon" :src="item.icon" class="w-7 h-7" alt="icon" />
            <span>{{ item.label }}</span>
          </div>
          <div class="flex flex-col gap-1">
            <button v-if="role === 'customer'" @click="showCreateOrderModal = true" class="menu-action-btn">
              Создать новый заказ
            </button>
            <button v-if="role === 'performer'" class="menu-action-btn" @click="goToPortfolio">
              <span class="flex items-center justify-center w-full">
                Моё портфолио
                <span class="portfolio-icon-circle ml-2">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M16.862 3.487a2.5 2.5 0 0 1 3.535 3.535l-9.193 9.193a2 2 0 0 1-.707.464l-4.11 1.37a.5.5 0 0 1-.632-.632l1.37-4.11a2 2 0 0 1 .464-.707l9.193-9.193Z" stroke="#4F8CFF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M15 6l3 3" stroke="#4F8CFF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                </span>
              </span>
            </button>
          </div>
        </div>
      </aside>

      <!-- Центральная часть -->
      <main class="flex-1 flex flex-col gap-8">
        <div class="flex items-center gap-4 justify-between">
          <input type="text" placeholder="Поиск" class="bg-[#0D1F31] text-white px-5 py-3 rounded-4xl w-full focus:outline-none focus:ring-2 focus:ring-blue-500" />
          
        </div>
        <section>
          <div class="orders-header-row mb-4 flex items-center justify-between gap-4">
            <h2 class="text-xl font-bold">{{ currentTabLabel }}</h2>
            <div class="order-filter-box flex gap-3">
              <!-- Сортировка -->
              <button :class="['filter-btn', sortBy === 'az' && 'active']" @click="sortBy = sortBy === 'az' ? 'za' : 'az'">
                А<span style="font-size:1.1em;">&#8595;</span>Я
              </button>
              <!-- Фильтр по статусу -->
              <div class="relative">
                <button :class="['filter-btn', 'dropdown-btn', statusDropdownOpen && 'open']" @click="statusDropdownOpen = !statusDropdownOpen">
                  {{ statusFilterLabel }} <span class="arrow">&#9660;</span>
                </button>
                <div v-if="statusDropdownOpen" class="dropdown-list">
                  <div class="dropdown-item" @click="setStatusFilter('all')">Все заказы</div>
                  <div class="dropdown-item" @click="setStatusFilter('open')">Открыт</div>
                  <div class="dropdown-item" @click="setStatusFilter('in_progress')">В работе</div>
                  <div class="dropdown-item" @click="setStatusFilter('done')">Завершён</div>
                  <div class="dropdown-item" @click="setStatusFilter('archived')">Архив</div>
                </div>
              </div>
              <!-- Фильтр по виду работ -->
              <div class="relative">
                <button :class="['filter-btn', 'dropdown-btn', workTypeDropdownOpen && 'open']" @click="workTypeDropdownOpen = !workTypeDropdownOpen">
                  {{ workTypeFilterLabel }} <span class="arrow">&#9660;</span>
                </button>
                <div v-if="workTypeDropdownOpen" class="dropdown-list">
                  <div class="dropdown-item" @click="setWorkTypeFilter('all')">Все виды работ</div>
                  <div v-for="type in workTypes" :key="type.id" class="dropdown-item" @click="setWorkTypeFilter(type.id)">{{ type.name }}</div>
                </div>
              </div>
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
import ordersIcon from '@/assets/orders.png';
import storyIcon from '@/assets/story.png';
import infographicIcon from '@/assets/infographic.png';
import cardsIcon from '@/assets/cards.png';
import customerIcon from '@/assets/customer.png';
import performerIcon from '@/assets/performer.png';
import editIco from '@/assets/edit_ico.png';

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
      role: localStorage.getItem('role') || 'customer',
      customerMenu: [
        { label: 'Все заказы', value: 'all', icon: ordersIcon },
        { label: 'Заказы в работе', value: 'in_progress', icon: ordersIcon },
        { label: 'Завершённые заказы', value: 'done', icon: ordersIcon },
        { label: 'Архив', value: 'archive', icon: ordersIcon },
        { label: 'Сообщения', value: 'messages', icon: ordersIcon },
      ],
      performerMenu: [
        { label: 'Все заказы', value: 'all', icon: ordersIcon },
        { label: 'Заказы в работе', value: 'in_progress', icon: ordersIcon },
        { label: 'Завершённые заказы', value: 'done', icon: ordersIcon },
        { label: 'Архив', value: 'archive', icon: ordersIcon },
        { label: 'Сообщения', value: 'messages', icon: ordersIcon },
      ],
      currentTab: 'all',
      statusFilter: 'all',
      workTypes: [],
      workTypeFilter: 'all',
      editIco, // <-- добавил сюда
      sortBy: 'az', // 'az' или 'za'
      statusDropdownOpen: false,
      workTypeDropdownOpen: false,
    }
  },
  computed: {
    currentMenu() {
      return this.role === 'customer' ? this.customerMenu : this.performerMenu;
    },
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
      // Сортировка по алфавиту
      base = base.slice().sort((a, b) => {
        const nameA = (a.title || '').toLowerCase();
        const nameB = (b.title || '').toLowerCase();
        if (this.sortBy === 'az') return nameA.localeCompare(nameB);
        else return nameB.localeCompare(nameA);
      });
      return base;
    },
    currentTabLabel() {
      const found = this.currentMenu.find(m => m.value === this.currentTab);
      return found ? found.label : '';
    },
    statusFilterLabel() {
      switch(this.statusFilter) {
        case 'open': return 'Открыт';
        case 'in_progress': return 'В работе';
        case 'done': return 'Завершён';
        case 'archived': return 'Архив';
        default: return 'Все заказы';
      }
    },
    workTypeFilterLabel() {
      if (this.workTypeFilter === 'all') return 'Все виды работ';
      const found = this.workTypes.find(t => String(t.id) === String(this.workTypeFilter));
      return found ? found.name : 'Все виды работ';
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
    },
    setRole(role) {
      this.role = role;
      localStorage.setItem('role', role);
    },
    goToPortfolio() {
      this.$router.push('/portfolio');
    },
    setStatusFilter(val) {
      this.statusFilter = val;
      this.statusDropdownOpen = false;
    },
    setWorkTypeFilter(val) {
      this.workTypeFilter = val;
      this.workTypeDropdownOpen = false;
    },
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
/* Кастомные фильтры заказов и выпадающие списки */
.order-filter-box {
  margin-top: 0.5rem;
}
.filter-btn {
  background: #19223a;
  color: #fff;
  border-radius: 14px;
  padding: 6px 18px;
  font-weight: 500;
  font-size: 0.98rem;
  border: none;
  outline: none;
  transition: background 0.2s;
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
}
.filter-btn.active, .filter-btn:focus, .filter-btn.open {
  background: #22304a;
  color: #fff;
}
.filter-btn .arrow {
  font-size: 1.1em;
}
.dropdown-btn {
  position: relative;
}
.dropdown-list {
  position: absolute;
  top: 110%;
  left: 0;
  min-width: 150px;
  background: #19223a;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.18);
  z-index: 20;
  padding: 4px 0;
}
.dropdown-item {
  padding: 8px 16px;
  color: #fff;
  cursor: pointer;
  border-radius: 10px;
  transition: background 0.15s;
}
.dropdown-item:hover {
  background: #22304a;
}
.orders-header-row {
  margin-bottom: 1.5rem;
}
.profile-block {
  background: #0D1F31;
  border-radius: 2rem;
  margin-bottom: 0.5rem;
  padding-bottom: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}
.portfolio-btn {
  font-size: 1rem;
  font-weight: 500;
  margin-top: 0.5rem;
  transition: background 0.2s;
}
.menu-block {
  background: #0D1F31;
  border-radius: 1.5rem;
  min-width: 0;
  padding: 0.7rem 0.5rem 0.7rem 0.5rem;
  margin-bottom: 0.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}
.role-switcher {
  background: #16243a;
  border-radius: 1.1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.15rem 0.15rem;
  margin-bottom: 0.7rem;
  gap: 0.3rem;
}
.role-btn {
  flex: 1;
  background: transparent;
  border: none;
  color: #b0b8c1;
  font-weight: 600;
  font-size: 1rem;
  border-radius: 1rem;
  padding: 0.45rem 1.1rem;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
  margin: 0 0.1rem;
}
.role-btn.active {
  background: #22304a;
  color: #fff;
}
.logout-btn {
  font-size: 1rem;
  font-weight: 500;
  margin-top: 0.5rem;
  transition: background 0.2s;
  background: #19223a;
  color: #fff;
}
.logout-btn:hover {
  background: #22304a;
}
.portfolio-btn2 {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #222C3A;
  color: #fff;
  border: none;
  border-radius: 1.5rem;
  padding: 0.9rem 1.5rem;
  font-size: 1.1rem;
  font-weight: 500;
  margin-top: 0.5rem;
  transition: background 0.2s;
  cursor: pointer;
}
.portfolio-btn2:hover {
  background: #22304a;
}
.portfolio-icon-circle {
  background: #2e3a4d;
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.role-switcher-oval {
  background: #16243a;
  border-radius: 2.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.18rem 0.18rem;
  margin-bottom: 0.7rem;
  gap: 0.15rem;
  width: 100%;
  box-sizing: border-box;
}
.role-btn-oval {
  flex: 1 1 0;
  background: transparent;
  border: none;
  color: #b0b8c1;
  font-weight: 600;
  font-size: 1.1rem;
  border-radius: 2rem;
  padding: 0.7rem 0;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
  margin: 0;
  min-width: 0;
}
.role-btn-oval.active {
  background: #22304a;
  color: #fff;
  font-weight: 700;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}
/* Одинаковый стиль для обеих кнопок */
.menu-action-btn {
  width: 100%;
  min-height: 48px;
  padding: 0 0;
  border-radius: 16px;
  font-weight: 600;
  font-size: 1rem;
  transition: background 0.2s;
  margin: 0;
  background: #2563eb;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
}
.menu-action-btn:hover {
  background: #1d4ed8;
}
.menu-action-btn:active {
  background: #1e40af;
}
.portfolio-icon-circle {
  background: #2e3a4d;
  width: 32px;
  height: 32px;
  min-width: 32px;
  min-height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>