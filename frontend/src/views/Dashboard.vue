<template>
  <div class="dashboard-bg min-h-screen w-full flex justify-center items-start py-8">
    <div class="dashboard-container w-full max-w-[1400px] flex gap-8 container-padding">
      <!-- Левая панель (скрыта на мобильных) -->
      <aside class="w-72 flex flex-col gap-6 hidden md:flex">
        <UserDropdown :user="userWithAvatar" @logout="logout" class="mb-2" />
        <div class="menu-block bg-[#0D1F31] rounded-3xl w-full p-2 flex flex-col gap-0">
          <div class="role-switcher-oval flex items-center justify-between rounded-full p-1 bg-[#16243a] w-full" style="box-sizing: border-box;">
            <button :class="['role-btn-oval', role === 'customer' ? 'active' : '']" @click="setRole('customer')">Заказчик</button>
            <button :class="['role-btn-oval', role === 'executor' ? 'active' : '']" @click="setRole('executor')">Исполнитель</button>
          </div>
          <div v-for="item in currentMenu" :key="`${menuKey}-${item.value}`" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-[#146AF128] cursor-pointer"
            :class="{ 'bg-[#22304a]': currentTab === item.value }"
            @click="saveCurrentTab(item.value)">
            <img v-if="item.icon" :src="item.icon" class="w-7 h-7" alt="icon" />
            <span>{{ item.label }}</span>
          </div>
          <!-- Кнопка профиля для заказчика -->
          <div v-if="role === 'customer'" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-[#146AF128] cursor-pointer"
            @click="goToCustomerProfile()">
            <img src="@/assets/orders.png" class="w-7 h-7" alt="icon" />
            <span>Профиль заказчика</span>
          </div>
          <!-- Кнопка портфолио для исполнителя -->
          <div v-if="role === 'executor'" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-[#146AF128] cursor-pointer"
            @click="goToExecutorProfile()">
            <img src="@/assets/orders.png" class="w-7 h-7" alt="icon" />
            <span>Портфолио исполнителя</span>
          </div>
          <div class="flex flex-col gap-1">
            <button v-if="role === 'customer'" @click="showCreateOrderModal = true" class="menu-action-btn">
              Создать новый заказ
            </button>
          </div>
        </div>
      </aside>

      <!-- Мобильная навигация -->
      <div class="md:hidden w-full mb-4">
        <!-- Компактная верхняя панель -->
        <div class="bg-[#0D1F31] rounded-2xl p-4 border border-[#22304a] shadow-lg">
          <div class="flex items-center justify-between mb-4">
            <!-- Пользователь и роль -->
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center">
                <span class="text-white font-semibold text-sm">{{ userWithAvatar.name?.charAt(0) || 'U' }}</span>
              </div>
              <div>
                <div class="text-white font-medium text-sm">{{ userWithAvatar.name || 'Пользователь' }}</div>
                <div class="text-gray-400 text-xs">{{ role === 'customer' ? 'Заказчик' : 'Исполнитель' }}</div>
              </div>
            </div>
            
            <!-- Кнопка меню -->
            <button @click="toggleMobileMenu" class="mobile-menu-btn">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
              </svg>
            </button>
          </div>
          
          <!-- Текущий таб -->
          <div class="flex items-center gap-2">
            <img v-if="getCurrentTabIcon()" :src="getCurrentTabIcon()" class="w-5 h-5" alt="icon" />
            <span class="text-white font-medium text-sm">{{ getCurrentTabLabel() }}</span>
          </div>
        </div>
        
        <!-- Выпадающее меню -->
        <div v-if="showMobileMenu" class="mobile-dropdown-menu">
          <!-- Переключатель ролей -->
          <div class="mobile-menu-section">
            <div class="mobile-menu-title">Роль</div>
            <div class="role-switcher-compact">
              <button :class="['role-btn-compact', role === 'customer' ? 'active' : '']" @click="setRole('customer')">
                Заказчик
              </button>
              <button :class="['role-btn-compact', role === 'executor' ? 'active' : '']" @click="setRole('executor')">
                Исполнитель
              </button>
            </div>
          </div>
          
          <!-- Навигация -->
          <div class="mobile-menu-section">
            <div class="mobile-menu-title">Навигация</div>
            <div class="mobile-nav-items">
              <button 
                v-for="item in currentMenu" 
                :key="`mobile-nav-${menuKey}-${item.value}`" 
                :class="['mobile-nav-item', currentTab === item.value ? 'active' : '']"
                @click="saveCurrentTab(item.value); showMobileMenu = false"
              >
                <img v-if="item.icon" :src="item.icon" class="w-5 h-5" alt="icon" />
                <span>{{ item.label }}</span>
                <svg v-if="currentTab === item.value" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12h15m0 0l-6.75-6.75M19.5 12l-6.75 6.75" />
                </svg>
              </button>
            </div>
          </div>
          
          <!-- Быстрые действия -->
          <div class="mobile-menu-section">
            <div class="mobile-menu-title">Действия</div>
            <div class="mobile-action-items">
              <button v-if="role === 'customer'" @click="showCreateOrderModal = true; showMobileMenu = false" class="mobile-action-item primary">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
                </svg>
                <span>Создать заказ</span>
              </button>
              <button v-if="role === 'customer'" @click="goToCustomerProfile(); showMobileMenu = false" class="mobile-action-item">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M17.982 18.725A7.488 7.488 0 0 0 12 15.75a7.488 7.488 0 0 0-5.982 2.975m11.963 0a9 9 0 1 0-11.963 0m11.963 0A8.966 8.966 0 0 1 12 21a8.966 8.966 0 0 1-5.982-2.275M15 9.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
                </svg>
                <span>Профиль заказчика</span>
              </button>
              <button v-if="role === 'executor'" @click="goToExecutorProfile(); showMobileMenu = false" class="mobile-action-item">
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 15.75l5.159-5.159a2.25 2.25 0 013.182 0l5.159 5.159m-1.5-1.5l1.409-1.409a2.25 2.25 0 013.182 0l2.909 2.909m-18 3.75h16.5a1.5 1.5 0 001.5-1.5V6a1.5 1.5 0 00-1.5-1.5H3.75A1.5 1.5 0 002.25 6v12a1.5 1.5 0 001.5 1.5zm10.5-11.25h.008v.008h-.008V8.25zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z" />
                </svg>
                <span>Портфолио</span>
              </button>
            </div>
          </div>
          
          <!-- Выход -->
          <div class="mobile-menu-section">
            <button @click="logout" class="mobile-action-item danger">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 9V5.25A2.25 2.25 0 0013.5 3h-6a2.25 2.25 0 00-2.25 2.25v13.5A2.25 2.25 0 007.5 21h6a2.25 2.25 0 002.25-2.25V15M12 9l-3 3m0 0l3 3m-3-3h12.75" />
              </svg>
              <span>Выйти</span>
            </button>
          </div>
        </div>
      </div>

      <!-- Центральная часть -->
      <main class="flex-1 flex flex-col gap-8">
        <div class="flex items-center gap-4 justify-between search-container">
          <div class="relative flex-1 search-dropdown-container">
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Поиск" 
              class="bg-[#0D1F31] text-white px-5 py-3 rounded-4xl w-full focus:outline-none focus:ring-2 focus:ring-blue-500 search-input" 
              @input="handleSearchInput"
              @focus="showDropdown = true"
              @blur="hideDropdown"
            />
            
            <!-- Выпадающий список результатов -->
            <div v-if="showDropdown && (searchResults.orders.length > 0 || searchResults.executors.length > 0)" 
                 class="search-dropdown">
              
              <!-- Исполнители -->
              <div v-if="searchResults.executors.length > 0" class="search-dropdown-section">
                <div v-for="executor in searchResults.executors" 
                     :key="'executor-' + executor.id" 
                     class="search-dropdown-item executor-item"
                     @mousedown="goToExecutorProfile(executor.id)">
                  <img :src="executor.avatar || getAssetUrl('performer.png')" class="search-item-avatar" alt="Avatar" />
                  <div class="search-item-content">
                    <div class="search-item-name">{{ executor.name }} {{ executor.surname }}</div>
                    <div class="search-item-details">
                      <span class="search-rating">⭐ {{ executor.rating || '0.0' }}</span>
                      <span class="search-separator">•</span>
                      <span class="search-orders">{{ executor.completed_orders || 0 }} заказов</span>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- Заказы -->
              <div v-if="searchResults.orders.length > 0" class="search-dropdown-section">
                <div v-for="order in searchResults.orders" 
                     :key="'order-' + order.id" 
                     class="search-dropdown-item order-item"
                     @mousedown="openOrderModal(order)">
                  <div class="search-order-icon">📋</div>
                  <div class="search-item-content">
                    <div class="search-item-name">{{ order.title }}</div>
                    <div class="search-item-details">
                      <div class="order-meta-row">
                        <span class="order-work-type">{{ order.work_type || 'Заказ' }}</span>
                        <span class="order-budget" v-if="order.budget">{{ formatPrice(order.budget) }} ₽</span>
                      </div>
                      <div class="order-meta-row" v-if="order.user">
                        <span class="order-customer">Заказчик: {{ order.user.name }} {{ order.user.surname || '' }}</span>
                        <span class="order-deadline" v-if="order.deadline">{{ formatDeadline(order.deadline) }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <button @click="handleSearchButton" class="search-btn btn-primary">
            Поиск
          </button>
        </div>
        <section>
          <div v-if="currentTab !== 'messages'" class="orders-header-row mb-4 flex items-center justify-between gap-4">
            <div class="flex items-center gap-3">
              <h2 class="text-xl font-bold">{{ currentTabLabel }}</h2>
              <div v-if="isLoadingOrders" class="loading-indicator">
                <div class="spinner"></div>
                <span>Загрузка...</span>
              </div>
            </div>
            <div class="order-filter-box flex gap-3 filter-container">
              <!-- Сортировка -->
              <button :class="['filter-btn', sortBy === 'az' && 'active']" @click="sortBy = sortBy === 'az' ? 'za' : 'az'">
                А<span style="font-size:1.1em;">&#8595;</span>Я
              </button>
              <!-- Фильтр по статусу (только во вкладке "Заказы в работе") -->
              <div class="relative" v-if="currentTab === 'in_progress'">
                <button :class="['filter-btn', 'dropdown-btn', statusDropdownOpen && 'open']" @click="statusDropdownOpen = !statusDropdownOpen">
                  {{ statusFilterLabel }} <span class="arrow">&#9660;</span>
                </button>
                <div v-if="statusDropdownOpen" class="dropdown-list">
                  <div class="dropdown-item" @click="setStatusFilter('all')">Все статусы</div>
                  <div v-for="opt in statusOptions" :key="opt.value" class="dropdown-item" @click="setStatusFilter(opt.value)">{{ opt.label }}</div>
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
          <!-- Результаты поиска -->
          <div v-if="searchQuery && (searchResults.orders.length > 0 || searchResults.executors.length > 0)" class="search-results">
            <div class="search-results-header">
              <h3 class="text-lg font-semibold mb-4">Результаты поиска</h3>
              <button @click="clearSearch" class="clear-search-btn">Очистить поиск</button>
            </div>
            
            <!-- Найденные заказы -->
            <div v-if="searchResults.orders.length > 0" class="search-section">
              <h4 class="search-section-title">Заказы</h4>
              <div class="orders-grid grid-3">
                <OrderCard
                  v-for="order in searchResults.orders"
                  :key="order.id"
                  :order="mapOrder(order)"
                  :userRole="role"
                  :user="user"
                  @view-details="openOrderModal"
                  @take="takeOrder"
                  @accept-order="acceptOrder"
                  @decline-order="declineOrder"
                  @accept-executor="acceptExecutor"
                  @decline-executor="declineExecutor"
                  @cancel-order="cancelOrder"
                  @delete-order="deleteOrder"
                  @change-executor="changeExecutor"
                  @order-updated="onOrderUpdated"
                  @leave-review="onLeaveReview"
                />
              </div>
            </div>
            
            <!-- Найденные исполнители -->
            <div v-if="searchResults.executors.length > 0" class="search-section">
              <h4 class="search-section-title">Исполнители</h4>
              <div class="executors-grid">
                <div v-for="executor in searchResults.executors" :key="executor.id" class="executor-card" @click="goToExecutorProfile(executor.id)">
                  <img :src="executor.avatar || getAssetUrl('performer.png')" class="executor-avatar" alt="Avatar" />
                  <div class="executor-info">
                    <h5 class="executor-name">{{ executor.name }} {{ executor.surname }}</h5>
                    
                    <!-- Рейтинг и количество заказов -->
                    <div class="executor-stats">
                      <div class="executor-rating">
                        <span class="star-icon">⭐</span>
                        <span class="rating-value">{{ executor.rating || '0.0' }}</span>
                      </div>
                      <span class="stats-separator">•</span>
                      <span class="completed-orders">{{ executor.completed_orders || 0 }} заказов</span>
                    </div>
                    
                    <!-- Специализации -->
                    <div class="executor-specializations" v-if="executor.specializations && executor.specializations.length > 0">
                      <div class="specialization-tags">
                        <span 
                          v-for="spec in getSpecializationsList(executor.specializations)" 
                          :key="spec.value" 
                          class="specialization-tag"
                        >
                          {{ spec.label }}
                        </span>
                      </div>
                    </div>
                    <p v-else class="executor-specialization">{{ executor.specialization || 'Исполнитель' }}</p>
                    
                    <!-- Описание -->
                    <p v-if="executor.description" class="executor-description">{{ executor.description }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Обычные заказы (когда нет поиска) -->
          <div v-else>
            <!-- Чат для вкладки "Сообщения" -->
            <div v-if="currentTab === 'messages'" class="chat-container">
              <ChatInterface :currentRole="role" />
            </div>
            
            <!-- Заказы для остальных вкладок -->
            <div v-else>
              <div v-if="filteredOrders.length === 0" class="text-center text-white mt-8">Нет заказов</div>
              <div v-else class="orders-grid">
                <OrderCard
                  v-for="order in filteredOrders"
                  :key="order.id"
                  :order="mapOrder(order)"
                  :userRole="role"
                  :user="user"
                  @view-details="openOrderModal"
                  @take="takeOrder"
                  @accept-order="acceptOrder"
                  @decline-order="declineOrder"
                  @accept-executor="acceptExecutor"
                  @decline-executor="declineExecutor"
                  @cancel-order="cancelOrder"
                  @delete-order="deleteOrder"
                  @change-executor="changeExecutor"
                  @order-updated="onOrderUpdated"
                  @leave-review="onLeaveReview"
                />
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>
    <!-- Модалка тестового режима -->
    <transition name="fade">
      <div v-if="showTestNotice" class="modal-overlay" @click.self="showTestNotice=false">
        <div class="modal-content test-notice">
          <div class="test-notice-header">
            <div class="icon-circle">⚠️</div>
            <div>
              <h3 class="notice-title">Платформа в тестовом режиме</h3>
              <p class="notice-subtitle">Возможны нестабильная работа и ошибки.</p>
            </div>
          </div>
          <div class="test-notice-body">
            <p>
              Пожалуйста, о всех найденных ошибках сообщайте — это поможет нам быстрее улучшить сервис.
              Благодарим за понимание и обратную связь!
            </p>
          </div>
          <div class="test-notice-actions">
            <button class="btn-primary" @click="dismissTestNotice">Понятно</button>
          </div>
        </div>
      </div>
    </transition>

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
        @chat-opened="onChatOpened"
        @order-taken="onOrderTaken"
      />
    </transition>

    <!-- Модальное окно для оставления отзыва -->
    <transition name="fade">
      <ReviewModal
        v-if="showReviewModal"
        :order="orderForReview"
        @close="showReviewModal = false"
        @review-submitted="onReviewSubmitted"
      />
    </transition>

    <!-- Мобильная навигация -->
    <BottomNav />
  </div>
</template>

<script>
import CreateOrder from "./CreateOrder.vue";
import UserDropdown from "../components/UserDropdown.vue";
import BottomNav from "../components/BottomNav.vue";
import performer from '@/assets/performer.png';
import OrderDetailsModal from "./OrderDetailsModal.vue";
import OrderCard from "../components/OrderCard.vue";
import ChatInterface from "../components/ChatInterface.vue";
import ReviewModal from "../components/ReviewModal.vue";
import ordersIcon from '@/assets/orders.png';
import storyIcon from '@/assets/story.png';
import infographicIcon from '@/assets/infographic.png';
import cardsIcon from '@/assets/cards.png';
import customerIcon from '@/assets/customer.png';
import performerIcon from '@/assets/performer.png';
import editIco from '@/assets/edit_ico.png';

export default {
  components: { CreateOrder, UserDropdown, BottomNav, OrderDetailsModal, OrderCard, ChatInterface, ReviewModal },
  data() {
    return {
      user: {
        ...JSON.parse(localStorage.getItem('user') || '{}'),
      },
      orders: [],
      allOrders: [], // Все заказы для поиска
      allExecutors: [], // Все исполнители для поиска
      userOrders: [], // Кэш заказов пользователя
      openOrders: [], // Кэш открытых заказов
      isLoadingOrders: false, // Индикатор загрузки
      showCreateOrderModal: false,
      detailedOrder: null, // Для подробного заказа
      loadingOrder: false, // Для лоадера
      showOrderModal: false, // Для модального окна
      showReviewModal: false, // Для модального окна отзыва
      showTestNotice: false,
      orderForReview: null, // Заказ для отзыва
      role: localStorage.getItem('role') || 'customer',
      customerMenu: [
        { label: 'Все заказы', value: 'all', icon: ordersIcon },
        { label: 'Заказы в работе', value: 'in_progress', icon: ordersIcon },
        { label: 'Завершённые заказы', value: 'done', icon: ordersIcon },
        { label: 'Сообщения', value: 'messages', icon: ordersIcon },
      ],
      executorMenu: [
        { label: 'Все заказы', value: 'all', icon: ordersIcon },
        { label: 'Заказы в работе', value: 'in_progress', icon: ordersIcon },
        { label: 'Завершённые заказы', value: 'done', icon: ordersIcon },
        { label: 'Сообщения', value: 'messages', icon: ordersIcon },
      ],
      currentTab: localStorage.getItem('currentTab') || 'all',
      statusFilter: 'all',
      statusOptions: [
        { value: 'pending_approval', label: 'На согласовании' },
        { value: 'in_progress', label: 'В работе' },
        { value: 'revision', label: 'На доработке' }
      ],
      workTypes: [],
      workTypeFilter: 'all',
      editIco, // <-- добавил сюда
      sortBy: 'az', // 'az' или 'za'
      statusDropdownOpen: false,
      workTypeDropdownOpen: false,

      searchQuery: '',
      searchResults: {
        orders: [],
        executors: []
      },
      isSearching: false,
      showDropdown: false,
      showMobileMenu: false, // Для мобильного выпадающего меню
    }
  },
  computed: {
    currentMenu() {
      return this.role === 'customer' ? this.customerMenu : this.executorMenu;
    },
    userWithAvatar() {
      return {
        ...this.user,
        avatar: this.getAvatarForRole()
      };
    },
    filteredOrders() {
      let base = [];
      
      // Добавим отладку для проблемы с заказами в работе
      if (this.currentTab === 'in_progress' && this.orders.length === 0) {
        console.log('⚠️ Нет заказов во вкладке "в работе". Проверьте токен авторизации и данные пользователя.');
      }
      
      // Фильтруем заказы в зависимости от роли и вкладки
      if (this.currentTab === 'all') {
        // На вкладке "Все заказы" показываем только открытые заказы для всех пользователей
        // Это общая доска объявлений - все открытые заказы, доступные для взятия в работу
        base = this.orders.filter(o => o.status === 'open');
      } else {
        // Для других вкладок фильтруем по роли и показываем личные заказы
        if (this.role === 'customer') {
          // Заказчик видит только свои заказы (где он user_id)
          base = this.orders.filter(o => o.user_id === this.user.id);
        } else if (this.role === 'executor') {
          // Исполнитель видит заказы где он назначен исполнителем (executor_id)
          base = this.orders.filter(o => o.executor_id === this.user.id);
        }
      }
      
      // Дополнительная фильтрация по вкладкам
      if (this.currentTab === 'in_progress') {
        // Заказы в работе - фильтруем по статусу
        if (this.role === 'customer') {
          // Для заказчика: его заказы со статусом open, pending_approval, in_progress, pending_review, revision
          base = base.filter(o => ['open','pending_approval','in_progress','pending_review','revision'].includes(o.status));
        } else if (this.role === 'executor') {
          // Для исполнителя: только заказы где он назначен исполнителем и не со статусом open
          base = base.filter(o => ['pending_approval','in_progress','pending_review','revision'].includes(o.status));
        }
      } else if (this.currentTab === 'done') {
        base = base.filter(o => o.status === 'completed');
      } else if (this.currentTab === 'messages') {
        base = [];
      }
      // else - показываем все заказы для текущей роли
      
      if (this.currentTab === 'in_progress' && this.statusFilter !== 'all') {
        base = base.filter(o => o.status === this.statusFilter);
      }
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
      if (found) {
        const count = this.filteredOrders.length;
        return `${found.label} (${count})`;
      }
      // Fallback для случаев когда пункт не найден в меню
      switch (this.currentTab) {
        case 'all': return `Все заказы (${this.filteredOrders.length})`;
        case 'in_progress': return `Заказы в работе (${this.filteredOrders.length})`;
        case 'done': return `Завершённые заказы (${this.filteredOrders.length})`;
        case 'messages': return 'Сообщения';
        default: return '';
      }
    },
    statusFilterLabel() {
      if (this.statusFilter === 'all') return 'Все статусы';
      const opt = this.statusOptions.find(o => o.value === this.statusFilter);
      return opt ? opt.label : 'Все статусы';
    },
    workTypeFilterLabel() {
      if (this.workTypeFilter === 'all') return 'Все виды работ';
      const found = this.workTypes.find(t => String(t.id) === String(this.workTypeFilter));
      return found ? found.name : 'Все виды работ';
    },
    availableTabs() {
      return this.role === 'customer' ? this.customerMenu : this.executorMenu;
    },
    menuKey() {
      // Принудительно обновляем меню при смене роли
      return `${this.role}-${Date.now()}`;
    }
  },
  watch: {
    currentTab: {
      handler(newTab) {
        // При смене вкладки перезагружаем заказы
        this.fetchOrders();
        // Обновляем также все заказы для поиска
        this.fetchAllOrdersForSearch();
        // Автоматически сохраняем активную вкладку в localStorage
        if (newTab) {
          localStorage.setItem('currentTab', newTab);
        }
        if (newTab !== 'in_progress') {
          this.statusFilter = 'all';
        }
      },
      immediate: false
    },
    role: {
      handler() {
        this.fetchOrders();
        this.fetchAllOrdersForSearch();
        this.fetchAllExecutorsForSearch();
        // Принудительно обновляем компонент при смене роли
        this.$nextTick(() => {
          this.$forceUpdate();
        });
      },
      immediate: true
    }
  },
  
  mounted() {
    // Слушаем изменения роли в других вкладках
    window.addEventListener('storage', (e) => {
      if (e.key === 'role' && e.newValue) {
        this.role = e.newValue;
        this.updateUserDataForRole(e.newValue);
      }
    });
    
    this.restoreState();
    // Показ уведомления, если установлен флаг после логина/регистрации
    if (localStorage.getItem('showTestNotice') === '1') {
      this.showTestNotice = true;
      // сбросим флаг, чтобы не показывать постоянно
      localStorage.removeItem('showTestNotice');
    }
    this.$nextTick(() => {
      // Принудительно обновляем компонент после восстановления состояния
      this.$forceUpdate();
    });
    
    // Загружаем актуальные данные пользователя
    this.refreshUserData();
    
    // Предварительно загружаем все данные для быстрого переключения вкладок
    this.preloadAllData();
    
    // Обрабатываем URL параметры
    this.handleUrlParams();
    
    // Дополнительная проверка после загрузки данных
    this.$nextTick(() => {
      setTimeout(() => {
        if (this.role && this.currentMenu.length > 0) {
          this.$forceUpdate();
        }
      }, 100);
    });
    
    // Финальная проверка через небольшую задержку
    setTimeout(() => {
      if (this.role && this.currentMenu.length > 0) {
        this.$forceUpdate();
      }
    }, 300);
    
    // Обработчик клика вне мобильного меню
    document.addEventListener('click', this.handleClickOutside);
  },
  
  beforeUnmount() {
    // Удаляем обработчик при размонтировании компонента
    document.removeEventListener('click', this.handleClickOutside);
  },
  methods: {
    // Мобильное меню
    toggleMobileMenu() {
      this.showMobileMenu = !this.showMobileMenu;
    },
    
    getCurrentTabIcon() {
      const currentItem = this.currentMenu.find(item => item.value === this.currentTab);
      return currentItem ? currentItem.icon : null;
    },
    
    getCurrentTabLabel() {
      const currentItem = this.currentMenu.find(item => item.value === this.currentTab);
      return currentItem ? currentItem.label : 'Все заказы';
    },
    
    handleClickOutside(event) {
      // Закрываем мобильное меню при клике вне его
      const mobileMenu = document.querySelector('.mobile-dropdown-menu');
      const menuButton = document.querySelector('.mobile-menu-btn');
      
      if (this.showMobileMenu && mobileMenu && !mobileMenu.contains(event.target) && !menuButton.contains(event.target)) {
        this.showMobileMenu = false;
      }
    },
    
    dismissTestNotice() {
      this.showTestNotice = false;
    },
    async preloadAllData() {
      // Загружаем все данные параллельно для быстрого доступа
      try {
        // Загружаем данные параллельно без блокировки
        const promises = [
          this.loadUserOrders(),
          this.loadOpenOrders(),
          this.fetchWorkTypes(),
          this.fetchAllExecutorsForSearch()
        ];
        
        await Promise.all(promises);
        
        // После загрузки всех данных устанавливаем текущие заказы
        this.updateCurrentOrders();
      } catch (error) {
        console.error('Error preloading data:', error);
      }
    },
    
    async loadUserOrders() {
      try {
        const response = await this.$axios.get('/orders');
        const data = response.data;
        this.userOrders = Array.isArray(data.data) ? data.data : data;
      } catch (e) {
        console.error('Error loading user orders:', e);
        this.userOrders = [];
      }
    },
    
    async loadOpenOrders() {
      try {
        const response = await this.$axios.get('/orders/open/all');
        const data = response.data;
        this.openOrders = Array.isArray(data.data) ? data.data : data;
      } catch (e) {
        console.error('Error loading open orders:', e);
        this.openOrders = [];
      }
    },
    
    updateCurrentOrders() {
      // Обновляем текущие заказы на основе вкладки
      if (this.currentTab === 'all') {
        this.orders = this.openOrders;
      } else {
        this.orders = this.userOrders;
      }
    },
    
    async fetchOrders() {
      if (this.isLoadingOrders) return; // Предотвращаем дублирующиеся запросы
      
      try {
        this.isLoadingOrders = true;
        
        // Если данные уже загружены, используем кэш
        if ((this.currentTab === 'all' && this.openOrders.length > 0) || 
            (this.currentTab !== 'all' && this.userOrders.length > 0)) {
          this.updateCurrentOrders();
          return;
        }
        
        // Иначе загружаем недостающие данные
        if (this.currentTab === 'all') {
          await this.loadOpenOrders();
        } else {
          await this.loadUserOrders();
        }
        
        this.updateCurrentOrders();
      } catch (e) {
        console.error('Error in fetchOrders:', e);
        this.orders = [];
      } finally {
        this.isLoadingOrders = false;
      }
    },
    async fetchAllOrdersForSearch() {
      try {
        // Используем уже загруженные данные или загружаем если нужно
        let openOrders = this.openOrders;
        let userOrders = this.userOrders;
        
        const promises = [];
        
        // Загружаем открытые заказы только если их нет
        if (openOrders.length === 0) {
          promises.push(this.$axios.get('/orders/open/all').then(response => {
            const data = response.data;
            openOrders = Array.isArray(data.data) ? data.data : data;
            this.openOrders = openOrders;
            return openOrders;
          }));
        }
        
        // Загружаем пользовательские заказы только если их нет
        if (userOrders.length === 0) {
          promises.push(this.$axios.get('/orders').then(response => {
            const data = response.data;
            userOrders = Array.isArray(data.data) ? data.data : data;
            this.userOrders = userOrders;
            return userOrders;
          }));
        }
        
        // Ждем загрузки только недостающих данных
        if (promises.length > 0) {
          await Promise.all(promises);
        }
        
        // Объединяем и удаляем дубликаты по ID
        const allOrdersMap = new Map();
        [...openOrders, ...userOrders].forEach(order => {
          allOrdersMap.set(order.id, order);
        });
        
        this.allOrders = Array.from(allOrdersMap.values());
      } catch (e) {
        console.error('Error in fetchAllOrdersForSearch:', e);
        this.allOrders = [...this.orders]; // Fallback к текущим заказам
      }
    },
    async fetchAllExecutorsForSearch() {
      try {
        // Загружаем всех пользователей для поиска
        // Если есть выбранный тип работ, передадим соответствующую специализацию для фильтрации
        let params = {};
        if (this.workTypeFilter !== 'all') {
          const wt = this.workTypes.find(t => String(t.id) === String(this.workTypeFilter));
          const map = {
            'Дизайн карточки для МП': 'mp_card_design',
            'Дизайн визитки': 'business_card_design',
            'Видео': 'video',
            'Видео до 30 секунд': 'video'
          };
          const spec = wt ? map[wt.name] : null;
          if (spec) params.specialization = spec;
        }
        const response = await this.$axios.get('/users/all', { params });
        this.allExecutors = response.data || [];
        console.log('📊 Загружено пользователей для поиска:', this.allExecutors.length);
      } catch (e) {
        console.error('Error in fetchAllExecutorsForSearch:', e);
        this.allExecutors = []; // Fallback к пустому массиву
      }
    },
    async fetchWorkTypes() {
      try {
        const { data } = await this.$axios.get('/work-types');
        this.workTypes = data;
      } catch (e) {
        this.workTypes = [];
      }
    },
    closeCreateOrderModal() {
      this.showCreateOrderModal = false;
    },
    onOrderCreated() {
      this.showCreateOrderModal = false;
      this.clearOrdersCache();
      this.fetchOrders();
      // Обновляем также все заказы для поиска
      this.fetchAllOrdersForSearch();
    },
    
    clearOrdersCache() {
      // Очищаем кэш заказов при изменении данных
      this.userOrders = [];
      this.openOrders = [];
      this.allOrders = [];
    },
    logout() {
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      localStorage.removeItem('currentTab')
      localStorage.removeItem('role')

      this.$router.push('/login')
    },
    async openOrderModal(order) {
      this.loadingOrder = true;
      this.detailedOrder = null;
      this.showOrderModal = true;
      try {
        const { data } = await this.$axios.get(`/orders/${order.id}`);
        this.detailedOrder = data.data || data;

      } catch (e) {
        console.error('Ошибка загрузки заказа:', e);
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
    handleUrlParams() {
      // Обрабатываем параметры URL
      const urlParams = new URLSearchParams(window.location.search);
      const tab = urlParams.get('tab');
      const chatId = urlParams.get('chat');
      
      // Если указана вкладка, переключаемся на неё
      if (tab && this.currentMenu.some(item => item.value === tab)) {
        this.saveCurrentTab(tab);
      }
      
      // Если указан ID чата, открываем его
      if (chatId) {
        this.$nextTick(() => {
          // Небольшая задержка для загрузки чатов
          setTimeout(() => {
            this.openChat(chatId);
          }, 500);
        });
      }
    },
    openChat(chatId) {
      // Метод для открытия конкретного чата
      if (this.currentTab === 'messages') {
        // Если мы уже на вкладке сообщений, просто открываем чат
        this.$emit('open-chat', chatId);
      } else {
        // Если мы не на вкладке сообщений, переключаемся на неё и открываем чат
        this.saveCurrentTab('messages');
        this.$nextTick(() => {
          setTimeout(() => {
            this.$emit('open-chat', chatId);
          }, 100);
        });
      }
    },
    onOrderUpdated(order) {
      this.detailedOrder = order;
      this.afterMutation();
    },
    onChatOpened(chat) {
      
      // закрываем модалку и показываем вкладку сообщений
      this.showOrderModal = false;
      this.saveCurrentTab('messages');
      // Можно дополнительно прокинуть chatId в ChatInterface через состояние/хранилище
    },
    onOrderTaken(order) {
      // Заказ взят исполнителем, закрываем модалку и обновляем данные
      this.showOrderModal = false;
      this.afterMutation();
      // Показываем уведомление об успешном взятии заказа
      alert('Заказ успешно взят в работу! Статус изменен на "На согласовании"');
    },
    onLeaveReview(order) {
      // Открываем модальное окно для оставления отзыва
      this.orderForReview = order;
      this.showReviewModal = true;
    },
    onReviewSubmitted(review) {
      // Отзыв оставлен, закрываем модалка и обновляем данные
      this.showReviewModal = false;
      this.orderForReview = null;
      this.clearOrdersCache();
      this.fetchOrders();
      // Показываем уведомление об успешном оставлении отзыва
      alert('Отзыв успешно оставлен!');
    },
    statusText(status) {
      switch (status) {
        case 'open': return '';
        case 'pending_approval': return 'На согласовании';
        case 'in_progress': return 'В работе';
        case 'waiting_payment': return 'Ожидание оплаты';
        case 'done': return 'Завершён';
        default: return status || '—';
      }
    },
    statusClass(status) {
      switch (status) {
        case 'open': return 'bg-green-600 text-white';
        case 'pending_approval': return 'bg-blue-500 text-white';
        case 'in_progress': return 'bg-yellow-400 text-black';
        case 'waiting_payment': return 'bg-green-400 text-white';
        case 'done': return 'bg-gray-400 text-white';
        default: return 'bg-gray-600 text-white';
      }
    },
    formatDate(date) {
      // форматировать дату как "6 июля"
      if (!date) return '—';
      const d = new Date(date);
      return d.toLocaleDateString('ru-RU', { day: 'numeric', month: 'long' });
    },
    formatPrice(price) {
      if (!price || price === 0) return '—';
      return parseInt(price, 10).toLocaleString('ru-RU');
    },
    formatDeadline(deadline) {
      if (!deadline) return '';
      const d = new Date(deadline);
      const now = new Date();
      const diffTime = d.getTime() - now.getTime();
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
      
      if (diffDays < 0) {
        return 'Просрочен';
      } else if (diffDays === 0) {
        return 'Сегодня';
      } else if (diffDays === 1) {
        return 'Завтра';
      } else if (diffDays <= 7) {
        return `${diffDays} дн.`;
      } else {
        return this.formatDate(deadline);
      }
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
    async setRole(role) {
      this.role = role;
      localStorage.setItem('role', role);
      
      // Проверяем, доступна ли текущая вкладка для новой роли
      const isCurrentTabAvailable = this.availableTabs.some(item => item.value === this.currentTab);
      
      // Если текущая вкладка недоступна для новой роли, переключаемся на подходящую
      if (!isCurrentTabAvailable) {
        // Для всех ролей по умолчанию открываем "Все заказы"
        this.saveCurrentTab('all');
      }
      
      // Обновляем данные пользователя при смене роли
      await this.updateUserDataForRole(role);
      
      // Обновляем аватарку при смене роли
      this.user.avatar = this.getAvatarForRole();
      
      // Принудительно обновляем компонент для корректного рендеринга меню
      this.$nextTick(() => {
        this.$forceUpdate();
      });
      
      // Перезагружаем заказы при смене роли
      this.fetchOrders();
    },
    saveCurrentTab(tab) {
      this.currentTab = tab;
      localStorage.setItem('currentTab', tab);
      
      // Обновляем заказы на основе кэша
      this.updateCurrentOrders();
    },
    switchToTab(tab) {
      this.saveCurrentTab(tab);
    },
    resetToDefaultTab() {
      this.saveCurrentTab('all');
    },
    getLastActiveTab() {
      return localStorage.getItem('currentTab') || 'all';
    },
    isTabAvailable(tab) {
      return this.availableTabs.some(item => item.value === tab);
    },
    safeSwitchToTab(tab) {
      if (this.isTabAvailable(tab)) {
        this.saveCurrentTab(tab);
        return true;
      }
      return false;
    },
    restoreState() {
      // Восстанавливаем данные пользователя из localStorage
      const savedUser = JSON.parse(localStorage.getItem('user') || '{}');
      if (savedUser && Object.keys(savedUser).length > 0) {
        this.user = {
          ...this.user,
          ...savedUser
        };
        // Данные пользователя восстановлены из localStorage
      }
      
      // Восстанавливаем роль
      const savedRole = localStorage.getItem('role');
      if (savedRole && (savedRole === 'customer' || savedRole === 'executor')) {
        this.role = savedRole;
      } else {
        // Если роль не сохранена, устанавливаем по умолчанию
        this.role = 'customer';
        localStorage.setItem('role', 'customer');
      }
      
      // Восстанавливаем активную вкладку
      const savedTab = localStorage.getItem('currentTab');
      if (savedTab && this.isTabAvailable(savedTab)) {
        this.currentTab = savedTab;
      } else {
        // Если сохраненная вкладка недоступна, используем "Все заказы" по умолчанию
        this.currentTab = 'all';
      }
      

      
      // Убеждаемся, что меню корректно инициализировано
      this.$nextTick(() => {
        if (this.currentMenu && this.currentMenu.length > 0) {
          this.$forceUpdate();
        }
      });
      
      // Принудительно обновляем компонент после восстановления состояния
      this.$nextTick(() => {
        this.$forceUpdate();
      });
    },
    goToPortfolio() {
      this.$router.push(`/portfolio/${this.user.id}`);
    },
    goToCustomerProfile() {
      const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
      const userId = currentUser.id || this.user.id;
      
      if (!userId) {
        console.error('Не удалось определить ID пользователя для перехода к профилю');
        alert('Ошибка: не удалось определить пользователя');
        return;
      }
      
      this.$router.push(`/profile/customer/${userId}`);
    },
    goToExecutorProfile(executorId = null) {
      // Проверяем, если передан event объект вместо ID
      if (executorId && typeof executorId === 'object' && executorId.target) {
        executorId = null; // Игнорируем event объект
      }
      
      // Если передан конкретный ID исполнителя (из поиска), используем его
      if (executorId && typeof executorId === 'number') {
        this.$router.push(`/portfolio/${executorId}`);
        return;
      }
      
      // Если это кнопка "Портфолио исполнителя" в меню, используем ID текущего пользователя
      const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
      const userId = currentUser.id || this.user.id;
      
      // Отладочная информация
      console.log('Переход к портфолио исполнителя:', {
        executorId,
        currentUserId: userId,
        thisUserId: this.user.id,
        localStorageUser: currentUser,
        executorIdType: typeof executorId
      });
      
      if (!userId) {
        console.error('Не удалось определить ID пользователя для перехода к портфолио');
        alert('Ошибка: не удалось определить пользователя');
        return;
      }
      
      this.$router.push(`/portfolio/${userId}`);
    },
    setStatusFilter(val) {
      this.statusFilter = val;
      this.statusDropdownOpen = false;
    },
    setWorkTypeFilter(val) {
      this.workTypeFilter = val;
      this.workTypeDropdownOpen = false;
    },

    
    getAvatarForRole() {
      // Пока используем только статичные аватарки по роли
      const role = this.role || localStorage.getItem('role') || 'customer';
      return role === 'customer' ? customerIcon : performerIcon;
    },
    
    getAssetUrl(name) {
      try {
        return new URL(`../assets/${name}`, import.meta.url).href;
      } catch (error) {
        console.error(`Error loading asset ${name}:`, error);
        return '#';
      }
    },
    
    async updateUserDataForRole(role) {
      try {
        // Получаем актуальные данные пользователя с сервера
        const { data: userData } = await this.$axios.get('/user');
        
        // Обновляем данные в localStorage
        const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
        const updatedUser = {
          ...currentUser,
          ...userData,
          // Сохраняем роль
          currentRole: role
        };
        
        localStorage.setItem('user', JSON.stringify(updatedUser));
        
        // Обновляем локальное состояние
        this.user = {
          ...this.user,
          ...userData
        };
        
        console.log('Данные пользователя обновлены для роли:', role, updatedUser);
      } catch (error) {
        console.error('Ошибка обновления данных пользователя:', error);
      }
    },
    
    async refreshUserData() {
      try {
        // Получаем актуальные данные пользователя с сервера
        const { data: userData } = await this.$axios.get('/user');
        
        // Обновляем данные в localStorage
        const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
        const updatedUser = {
          ...currentUser,
          ...userData
        };
        
        localStorage.setItem('user', JSON.stringify(updatedUser));
        
        // Обновляем локальное состояние
        this.user = {
          ...this.user,
          ...userData
        };
        
        console.log('Данные пользователя обновлены:', updatedUser);
      } catch (error) {
        console.error('Ошибка обновления данных пользователя:', error);
      }
    },
    async handleSearchInput() {
      console.log('🔍 Search input triggered:', this.searchQuery);
      
      if (this.searchQuery.trim().length < 2) {
        this.searchResults = { orders: [], executors: [] };
        this.showDropdown = false;
        this.isSearching = false;
        return;
      }
      
      this.isSearching = true;
      
      try {
        console.log('🚀 Making search API call...');
        
        // Используем новый комбинированный поиск
        const response = await this.$axios.get(`/search/combined`, { 
          params: { q: this.searchQuery },
          timeout: 10000
        });
        
        console.log('✅ Search response:', response.data);
        
        this.searchResults.orders = (response.data.orders || []).slice(0, 3);
        this.searchResults.executors = (response.data.executors || []).slice(0, 5);
        this.showDropdown = true;
        
        console.log('📊 Search results:', {
          orders: this.searchResults.orders.length,
          executors: this.searchResults.executors.length
        });
        
      } catch (error) {
        console.error('❌ Search error:', error);
        console.error('Error details:', {
          message: error.message,
          response: error.response?.data,
          status: error.response?.status
        });
        
        // Fallback: локальный поиск по всем заказам и исполнителям
        this.searchResults.orders = this.allOrders.filter(order => 
          order.title.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          order.description.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          (order.workType?.name || '').toLowerCase().includes(this.searchQuery.toLowerCase())
        ).slice(0, 3);
        
        this.searchResults.executors = this.allExecutors.filter(executor => {
          const fullName = `${executor.name || ''} ${executor.surname || ''}`.toLowerCase();
          const description = (executor.executor_description || '').toLowerCase();
          const searchTerm = this.searchQuery.toLowerCase();
          
          return fullName.includes(searchTerm) || description.includes(searchTerm);
        }).slice(0, 5);
        
        this.showDropdown = this.searchResults.orders.length > 0 || this.searchResults.executors.length > 0;
        
        console.log('🔄 Using fallback search, found:', this.searchResults.orders.length, 'orders and', this.searchResults.executors.length, 'executors');
      } finally {
        this.isSearching = false;
      }
    },
    
    handleSearchButton() {
      // При клике на кнопку поиск показываем полные результаты как раньше
      this.showDropdown = false;
      this.handleSearch();
    },
    
    async handleSearch() {
      console.log('🔍 Full search triggered:', this.searchQuery);
      
      if (this.searchQuery.trim().length < 2) {
        this.searchResults = { orders: [], executors: [] };
        this.isSearching = false;
        return;
      }
      
      this.isSearching = true;
      
      try {
        console.log('🚀 Making full search API call...');
        
        // Используем новый комбинированный поиск для полных результатов
        const response = await this.$axios.get(`/search/combined`, { 
          params: { q: this.searchQuery },
          timeout: 15000
        });
        
        console.log('✅ Full search response:', response.data);
        
        this.searchResults.orders = response.data.orders || [];
        this.searchResults.executors = response.data.executors || [];
        
        console.log('📊 Full search results:', {
          orders: this.searchResults.orders.length,
          executors: this.searchResults.executors.length
        });
        
      } catch (error) {
        console.error('❌ Full search error:', error);
        console.error('Error details:', {
          message: error.message,
          response: error.response?.data,
          status: error.response?.status
        });
        
        // Fallback: локальный поиск по всем заказам и исполнителям
        this.searchResults.orders = this.allOrders.filter(order => 
          order.title.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          order.description.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
          (order.workType?.name || '').toLowerCase().includes(this.searchQuery.toLowerCase())
        );
        
        this.searchResults.executors = this.allExecutors.filter(executor => {
          const fullName = `${executor.name || ''} ${executor.surname || ''}`.toLowerCase();
          const description = (executor.executor_description || '').toLowerCase();
          const searchTerm = this.searchQuery.toLowerCase();
          
          return fullName.includes(searchTerm) || description.includes(searchTerm);
        });
        
        console.log('🔄 Using full fallback search, found:', this.searchResults.orders.length, 'orders and', this.searchResults.executors.length, 'executors');
      } finally {
        this.isSearching = false;
      }
    },
    
    hideDropdown() {
      // Задержка, чтобы клик по элементу выпадающего списка успел сработать
      setTimeout(() => {
        this.showDropdown = false;
      }, 200);
    },
           clearSearch() {
         this.searchQuery = '';
         this.searchResults = { orders: [], executors: [] };
         this.isSearching = false;
       },
       getSpecializationsList(specializations) {
         const specializationMap = {
           'video': 'Видео',
           'color_correction': 'Цветокоррекция',
           'motion_design': 'Моушн-дизайн',
           'video_editing': 'Монтаж видео',
           'graphic_design': 'Графический дизайн',
           'logo_design': 'Дизайн логотипов',
           'branding': 'Брендинг',
           'presentation': 'Презентации',
           'advertising': 'Рекламные макеты',
           'social_media': 'Контент для соцсетей',
           'mp_card_design': 'Дизайн карточки для МП',
           'business_card_design': 'Дизайн визитки'
         };
         
         // Если специализации не переданы
         if (!specializations) {
           return [];
         }
         
         // Если это строка, пытаемся распарсить JSON
         if (typeof specializations === 'string') {
           try {
             specializations = JSON.parse(specializations);
           } catch (e) {
             console.warn('Ошибка парсинга специализаций:', e);
             return [];
           }
         }
         
         // Проверяем, что это массив
         if (!Array.isArray(specializations)) {
           console.warn('Специализации не являются массивом:', specializations);
           return [];
         }
         
         // Фильтруем пустые значения и маппим
         return specializations
           .filter(spec => spec && typeof spec === 'string')
           .map(spec => ({
             value: spec,
             label: specializationMap[spec] || spec
           }));
       },
    

    

    
    async acceptOrder(order) {
      try {

        
        await this.$axios.post(`/orders/${order.id}/update-status`, { status: 'in_progress' });
        alert('Заказ принят! Статус изменен на "В работе"');
        this.afterMutation();
      } catch (error) {
        console.error('Ошибка принятия заказа:', error);
        console.error('Ответ сервера:', error.response?.data);
        alert('Ошибка принятия заказа. Проверьте подключение к интернету.');
      }
    },
    
    async declineOrder(order) {
      if (!confirm('Вы уверены, что хотите отклонить этот заказ?')) {
        return;
      }
      
      try {
        await this.$axios.post(`/orders/${order.id}/update-status`, { status: 'open', executor_id: null });
        alert('Заказ отклонен! Статус изменен на "Открыт"');
        this.afterMutation();
      } catch (error) {
        console.error('Ошибка отклонения заказа:', error);
        alert('Ошибка отклонения заказа. Проверьте подключение к интернету.');
      }
    },
    
    async acceptExecutor(order) {
      try {
        await this.$axios.post(`/orders/${order.id}/update-status`, { status: 'in_progress' });
        alert('Исполнитель принят! Заказ переведен в статус "В работе"');
        this.afterMutation();
      } catch (error) {
        console.error('Ошибка принятия исполнителя:', error);
        alert('Ошибка принятия исполнителя. Проверьте подключение к интернету.');
      }
    },
    
    async declineExecutor(order) {
      if (!confirm('Вы уверены, что хотите отказаться от этого исполнителя?')) {
        return;
      }
      
      try {
        await this.$axios.post(`/orders/${order.id}/update-status`, { status: 'open', executor_id: null });
        alert('От исполнителя отказались. Заказ снова открыт для поиска исполнителей.');
        this.afterMutation();
      } catch (error) {
        console.error('Ошибка отказа от исполнителя:', error);
        alert('Ошибка отказа от исполнителя. Проверьте подключение к интернету.');
      }
    },
    
    async cancelOrder(order) {
      if (!confirm('Вы уверены, что хотите отменить этот заказ?')) {
        return;
      }
      
      try {
        await this.$axios.post(`/orders/${order.id}/update-status`, { status: 'cancelled' });
        alert('Заказ отменен!');
        this.afterMutation();
      } catch (error) {
        console.error('Ошибка отмены заказа:', error);
        alert('Ошибка отмены заказа. Проверьте подключение к интернету.');
      }
    },
    
    async changeExecutor(order) {
      if (!confirm('Вы уверены, что хотите сменить исполнителя?')) {
        return;
      }
      
      try {
        await this.$axios.post(`/orders/${order.id}/update-status`, { status: 'open', executor_id: null });
        alert('Исполнитель сменен! Заказ снова открыт для поиска исполнителей.');
        this.afterMutation();
      } catch (error) {
        console.error('Ошибка смены исполнителя:', error);
        alert('Ошибка смены исполнителя. Проверьте подключение к интернету.');
      }
    },
    async deleteOrder(order) {
      if (!confirm('Удалить этот заказ? Действие необратимо.')) return;
      try {
        await this.$axios.delete(`/orders/${order.id}`);
        alert('Заказ удален');
        this.afterMutation();
      } catch (e) {
        console.error('Ошибка удаления заказа:', e);
        alert(e.response?.data?.message || 'Не удалось удалить заказ');
      }
    },
    
    async takeOrder(order) {
      try {
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        
        // Проверяем, что пользователь не пытается взять свой заказ
        if (order.user_id === user.id) {
          alert('Вы не можете взять свой собственный заказ!');
          return;
        }
        
        // Проверяем, что заказ действительно открыт
        if (order.status !== 'open') {
          alert('Этот заказ уже не доступен для взятия в работу!');
          return;
        }
        
        await this.$axios.post(`/orders/${order.id}/update-status`, { status: 'pending_approval', executor_id: user.id });
        alert('Заказ взят! Статус изменен на "На согласовании"');
        this.afterMutation();
      } catch (error) {
        console.error('Ошибка взятия заказа:', error);
        alert('Ошибка взятия заказа. Проверьте подключение к интернету.');
      }
    },
    afterMutation() {
      this.clearOrdersCache();
      this.fetchOrders();
      this.fetchAllOrdersForSearch();
    },
    onChatOpened() {
      this.currentTab = 'messages';
    },
  }
}
</script>

<style scoped>
.chat-container {
  height: calc(100vh - 200px);
  min-height: 500px;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}
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
/* Стили для модалки тестового режима */
.test-notice {
  width: min(680px, 92vw);
  padding: 28px 28px 22px 28px;
}
.test-notice-header {
  display: flex;
  align-items: center;
  gap: 16px;
  padding-bottom: 10px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
}
.icon-circle {
  width: 52px;
  height: 52px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(250, 204, 21, 0.16);
  border: 1px solid rgba(250, 204, 21, 0.28);
  font-size: 24px;
}
.notice-title {
  margin: 0;
  font-size: 22px;
  font-weight: 800;
  color: #fff;
}
.notice-subtitle {
  margin: 4px 0 0 0;
  color: #f59e0b;
  font-weight: 600;
}
.test-notice-body {
  padding: 16px 2px 8px 2px;
  color: #d1d5db;
  line-height: 1.55;
  font-size: 15px;
}
.test-notice-actions {
  display: flex;
  justify-content: flex-end;
  padding-top: 8px;
}
.btn-primary {
  background: #2563eb;
  color: #fff;
  border: none;
  border-radius: 12px;
  padding: 10px 18px;
  font-weight: 600;
  cursor: pointer;
}
.btn-primary:hover { background: #1d4ed8; }
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
  border-radius: 2rem;
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
.executor-status-block {
  margin-top: 12px;
  background: #16243a;
  border-radius: 10px;
  padding: 10px 12px;
}
.executor-status-label {
  color: #b0b8c1;
  font-size: 0.98rem;
  margin-bottom: 6px;
}
.executor-status-options {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.executor-status-option {
  color: #fff;
  font-size: 0.97rem;
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
}
.executor-status-option input[type="radio"] {
  accent-color: #146AF1;
}

/* Стили для поиска */
.search-results {
  margin-top: 20px;
}

.search-results-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.clear-search-btn {
  background: #22304a;
  color: #bfc9da;
  border: none;
  border-radius: 8px;
  padding: 8px 16px;
  font-size: 14px;
  cursor: pointer;
  transition: background 0.2s;
}

.clear-search-btn:hover {
  background: #2d3a4a;
}

.search-section {
  margin-bottom: 30px;
}

.search-section-title {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 16px;
  color: #fff;
}

.executors-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.executor-card {
  background: #0D1F31;
  border-radius: 16px;
  padding: 20px;
  cursor: pointer;
  transition: transform 0.2s, background 0.2s;
  display: flex;
  align-items: center;
  gap: 16px;
}

.executor-card:hover {
  transform: translateY(-2px);
  background: #16243a;
}

.executor-avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #22304a;
}

.executor-info {
  flex: 1;
}

.executor-name {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 4px;
  color: #fff;
}

.executor-specialization {
  color: #bfc9da;
  font-size: 14px;
  margin-bottom: 8px;
}

.executor-specializations {
  margin-bottom: 8px;
}

.specialization-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

.specialization-tag {
  display: inline-flex;
  align-items: center;
  padding: 2px 6px;
  background: #2563eb;
  color: #fff;
  border-radius: 8px;
  font-size: 10px;
  font-weight: 500;
}

.executor-stats {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.executor-rating {
  display: flex;
  align-items: center;
  gap: 4px;
}

.star {
  color: #4a5568;
  font-size: 14px;
}

.star.filled {
  color: #fbbf24;
}

.rating-text {
  color: #bfc9da;
  font-size: 12px;
  margin-left: 4px;
}

.star-icon {
  font-size: 12px;
}

.rating-value {
  color: #fbbf24;
  font-size: 13px;
  font-weight: 500;
}

.stats-separator {
  color: #6b7280;
  font-size: 12px;
}

.completed-orders {
  color: #bfc9da;
  font-size: 13px;
}

.executor-description {
  color: #9ca3af;
  font-size: 12px;
  margin-top: 6px;
  line-height: 1.4;
}

.search-btn {
  background: #2563eb;
  color: #fff;
  border: none;
  border-radius: 12px;
  padding: 12px 24px;
  font-weight: 600;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.2s;
}

.search-btn:hover {
  background: #1d4ed8;
}

/* Стили для выпадающего поиска */
.search-dropdown-container {
  position: relative;
}

.search-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: #0D1F31;
  border: 1px solid #22304a;
  border-radius: 16px;
  margin-top: 8px;
  max-height: 400px;
  overflow-y: auto;
  z-index: 1000;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
}

.search-dropdown-section {
  padding: 8px 0;
}

.search-dropdown-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  cursor: pointer;
  transition: background 0.2s;
  border-bottom: 1px solid rgba(34, 48, 74, 0.3);
}

.search-dropdown-item:hover {
  background: #16243a;
}

.search-dropdown-item:last-child {
  border-bottom: none;
}

.search-item-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid #22304a;
}

.search-order-icon {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #16243a;
  border-radius: 8px;
  font-size: 18px;
}

.search-item-content {
  flex: 1;
  min-width: 0;
}

.search-item-name {
  font-size: 15px;
  font-weight: 600;
  color: #fff;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.search-item-details {
  font-size: 12px;
  color: #9ca3af;
  display: flex;
  align-items: center;
  gap: 6px;
}

/* Для заказов - вертикальное расположение */
.order-item .search-item-details {
  flex-direction: column;
  align-items: stretch;
  gap: 2px;
}

.search-rating {
  color: #fbbf24;
  font-weight: 500;
}

.search-separator {
  color: #6b7280;
}

.search-orders {
  color: #bfc9da;
}

/* Стили для заказов в поиске */
.order-meta-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
  margin-bottom: 2px;
}

.order-meta-row:last-child {
  margin-bottom: 0;
}

.order-work-type {
  color: #3b82f6;
  font-weight: 500;
  font-size: 11px;
}

.order-budget {
  color: #10b981;
  font-weight: 600;
  font-size: 11px;
}

.order-customer {
  color: #9ca3af;
  font-size: 11px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 150px;
}

.order-deadline {
  color: #f59e0b;
  font-weight: 500;
  font-size: 11px;
  white-space: nowrap;
}

/* Индикатор загрузки */
.loading-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #9ca3af;
  font-size: 14px;
}

.spinner {
  width: 16px;
  height: 16px;
  border: 2px solid #374151;
  border-top: 2px solid #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Мобильные стили для навигации */
.mobile-tab-btn {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 16px;
  background: #16243a;
  border: 2px solid #22304a;
  border-radius: 16px;
  color: #aeb9cd;
  font-size: 15px;
  font-weight: 600;
  white-space: nowrap;
  transition: all 0.3s ease;
  cursor: pointer;
  min-width: fit-content;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.mobile-tab-btn.active {
  background: linear-gradient(135deg, #146AF1, #3b82f6);
  border-color: #146AF1;
  color: #fff;
  box-shadow: 0 4px 16px rgba(20, 106, 241, 0.3);
  transform: translateY(-1px);
}

.mobile-tab-btn:hover:not(.active) {
  background: #22304a;
  border-color: #374151;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.mobile-action-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  background: linear-gradient(135deg, #146AF1, #3b82f6);
  border: none;
  border-radius: 14px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  white-space: nowrap;
  box-shadow: 0 4px 12px rgba(20, 106, 241, 0.2);
  min-width: fit-content;
}

.mobile-action-btn.secondary {
  background: linear-gradient(135deg, #374151, #4b5563);
  color: #d1d5db;
  box-shadow: 0 4px 12px rgba(55, 65, 81, 0.2);
}

.mobile-action-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(20, 106, 241, 0.4);
}

.mobile-action-btn.secondary:hover {
  background: linear-gradient(135deg, #4b5563, #6b7280);
  box-shadow: 0 6px 20px rgba(55, 65, 81, 0.4);
}

/* Скрытие скроллбара для мобильных табов */
.scrollbar-hide {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.scrollbar-hide::-webkit-scrollbar {
  display: none;
}

/* Адаптивные стили для мобильной навигации */
@media (max-width: 640px) {
  .mobile-tab-btn {
    padding: 10px 14px;
    font-size: 14px;
    gap: 8px;
  }
  
  .mobile-action-btn {
    padding: 10px 14px;
    font-size: 13px;
    gap: 6px;
  }
  
  .mobile-action-btn span {
    display: none;
  }
  
  .mobile-action-btn svg {
    width: 18px;
    height: 18px;
  }
}

@media (max-width: 480px) {
  .mobile-tab-btn {
    padding: 8px 12px;
    font-size: 13px;
    gap: 6px;
  }
  
  .mobile-action-btn {
    padding: 8px 12px;
    font-size: 12px;
    gap: 4px;
  }
  
  .mobile-action-btn svg {
    width: 16px;
    height: 16px;
  }
}

/* Новые стили для мобильного выпадающего меню */
.mobile-menu-btn {
  background: #22304a;
  border: 1px solid #374151;
  border-radius: 12px;
  padding: 8px;
  color: #d1d5db;
  cursor: pointer;
  transition: all 0.3s ease;
}

.mobile-menu-btn:hover {
  background: #374151;
  border-color: #4b5563;
  transform: translateY(-1px);
}

.mobile-dropdown-menu {
  background: #0D1F31;
  border: 1px solid #22304a;
  border-radius: 16px;
  margin-top: 8px;
  padding: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(12px);
  animation: slideDown 0.3s ease-out;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.mobile-menu-section {
  margin-bottom: 20px;
}

.mobile-menu-section:last-child {
  margin-bottom: 0;
}

.mobile-menu-title {
  font-size: 12px;
  font-weight: 600;
  color: #9ca3af;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 8px;
  padding-left: 4px;
}

.role-switcher-compact {
  display: flex;
  background: #16243a;
  border-radius: 12px;
  padding: 4px;
  gap: 4px;
}

.role-btn-compact {
  flex: 1;
  padding: 8px 12px;
  background: transparent;
  border: none;
  border-radius: 8px;
  color: #9ca3af;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.role-btn-compact.active {
  background: linear-gradient(135deg, #146AF1, #3b82f6);
  color: #fff;
  box-shadow: 0 2px 8px rgba(20, 106, 241, 0.3);
}

.role-btn-compact:hover:not(.active) {
  background: #22304a;
  color: #d1d5db;
}

.mobile-nav-items {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.mobile-nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: transparent;
  border: none;
  border-radius: 12px;
  color: #d1d5db;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: left;
  width: 100%;
}

.mobile-nav-item.active {
  background: linear-gradient(135deg, #146AF1, #3b82f6);
  color: #fff;
  box-shadow: 0 2px 8px rgba(20, 106, 241, 0.3);
}

.mobile-nav-item:hover:not(.active) {
  background: #22304a;
  color: #fff;
}

.mobile-nav-item svg {
  margin-left: auto;
  opacity: 0.7;
}

.mobile-action-items {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.mobile-action-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  background: #22304a;
  border: 1px solid #374151;
  border-radius: 12px;
  color: #d1d5db;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  text-align: left;
  width: 100%;
}

.mobile-action-item.primary {
  background: linear-gradient(135deg, #146AF1, #3b82f6);
  border-color: #3b82f6;
  color: #fff;
  box-shadow: 0 2px 8px rgba(20, 106, 241, 0.3);
}

.mobile-action-item.danger {
  background: linear-gradient(135deg, #dc2626, #ef4444);
  border-color: #ef4444;
  color: #fff;
  box-shadow: 0 2px 8px rgba(220, 38, 38, 0.3);
}

.mobile-action-item:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.mobile-action-item.primary:hover {
  background: linear-gradient(135deg, #1d4ed8, #2563eb);
  box-shadow: 0 4px 12px rgba(20, 106, 241, 0.4);
}

.mobile-action-item.danger:hover {
  background: linear-gradient(135deg, #b91c1c, #dc2626);
  box-shadow: 0 4px 12px rgba(220, 38, 38, 0.4);
}

/* Адаптивные стили для мобильного меню */
@media (max-width: 480px) {
  .mobile-dropdown-menu {
    padding: 12px;
  }
  
  .mobile-nav-item,
  .mobile-action-item {
    padding: 10px 14px;
    font-size: 13px;
  }
  
  .role-btn-compact {
    padding: 6px 10px;
    font-size: 12px;
  }
  
  /* Мобильные стили для поиска */
  .search-container {
    flex-direction: column;
    gap: 12px;
  }
  
  .search-dropdown-container {
    width: 100%;
  }
  
  .search-input {
    width: 100%;
    padding: 14px 16px;
    font-size: 16px;
  }
  
  .search-btn {
    width: 100%;
    padding: 12px 16px;
    font-size: 14px;
    border-radius: 8px;
  }
  
  /* Мобильные стили для нижней навигации */
  .bottom-nav {
    padding: 8px 16px;
  }
  
  .nav-item {
    padding: 8px 12px;
    font-size: 12px;
  }
  
  .nav-item.active {
    background: transparent;
    color: #3b82f6;
  }
  
  .nav-item:not(.active) {
    color: #9ca3af;
  }
}
</style>