<template>
  <div class="profile-bg min-h-screen w-full flex justify-center items-start py-8">
    <div class="profile-container w-full max-w-[1100px] flex flex-col gap-8">
      <!-- Мобильная навигация -->
      <BottomNav />
      <div class="flex items-center gap-4 mb-6">
        <h1 class="text-2xl font-bold">Профиль пользователя</h1>
      </div>
      <div class="profile-tabs flex gap-2 mb-6">
        <button :class="['tab-btn', mode==='customer' ? 'active' : '']" @click="mode='customer'">Заказчик</button>
        <button :class="['tab-btn', mode==='executor' ? 'active' : '']" @click="mode='executor'">Исполнитель</button>
      </div>
      <div v-if="mode==='customer'" class="customer-profile-layout">
        <!-- Левая колонка - информация о заказчике -->
        <div class="left-column">
          <!-- Блок профиля заказчика -->
          <div class="profile-block">
            <div class="customer-header">
              <img :src="user.avatar || getDefaultAvatar('customer')" class="customer-avatar" alt="Avatar" />
              <div class="customer-info">
                <h2 class="customer-name">{{ user.name }} {{ user.surname }}</h2>
                <div class="customer-rating">
                  <span class="rating-badge">{{ user.rating || 0 }}</span>
                </div>
              </div>
            </div>
            
            <!-- Статистика заказчика -->
            <div class="stats-grid">
              <div class="stat-item">
                <div class="stat-value">{{ customerStats.ordersCreated || 0 }}</div>
                <div class="stat-label">заказов создал</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">{{ customerStats.avgResponseTime || '—' }}</div>
                <div class="stat-label">среднее время ответа</div>
              </div>
              <div class="stat-item">
                <div class="stat-value">{{ formatPrice(customerStats.avgProjectPrice) }}₽</div>
                <div class="stat-label">средняя цена проекта</div>
              </div>
            </div>
            
            <!-- Кнопка написать сообщение -->
            <button class="message-btn">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Написать сообщение
            </button>
          </div>
          
          <!-- Блок "О заказчике" -->
          <div class="about-block">
            <h3 class="section-title">О заказчике</h3>
            <p class="about-text">{{ user.description || 'Описание заказчика пока не добавлено.' }}</p>
          </div>
          
          <!-- Блок отзывов -->
          <div class="reviews-block">
            <div class="reviews-header">
              <h3 class="section-title">Отзывы</h3>
              <a href="#" class="all-reviews-link">Все отзывы</a>
            </div>
            <div v-if="customerReviews.length === 0" class="empty-reviews">
              <p>Пока нет отзывов</p>
            </div>
            <div v-else class="reviews-list">
              <div v-for="review in customerReviews.slice(0, 2)" :key="review.id" class="review-card">
                <div class="review-card-header">
                  <img :src="review.reviewer_avatar || getDefaultAvatar('executor')" class="reviewer-avatar" alt="Reviewer" />
                  <div class="reviewer-info">
                    <div class="reviewer-name">{{ review.reviewer_name }}</div>
                    <div class="review-stars">
                      <span v-for="i in 5" :key="i" class="star" :class="{ 'filled': i <= review.rating }">★</span>
                    </div>
                  </div>
                </div>
                <p class="review-text">{{ review.text }}</p>
                <div class="review-tags">
                  <span v-for="tag in review.tags" :key="tag" class="review-tag">{{ tag }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Правая колонка - выполненные проекты -->
        <div class="right-column">
          <div class="projects-header">
            <div class="search-box">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              <input type="text" placeholder="Поиск" class="search-input" />
            </div>
            <h3 class="section-title">Выполненные проекты</h3>
          </div>
          
          <div v-if="customerProjects.length === 0" class="empty-projects">
            <div class="empty-icon">📁</div>
            <p>Нет выполненных проектов</p>
          </div>
          
          <div v-else class="projects-grid">
            <div v-for="project in customerProjects" :key="project.id" class="project-card">
              <div class="project-image">
                <img :src="project.image || getAssetUrl('infographic.png')" :alt="project.title" class="project-img" />
                <div class="play-overlay">
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M8 5v14l11-7z" fill="currentColor"/>
                  </svg>
                </div>
              </div>
              <div class="project-info">
                <h4 class="project-title">{{ project.title }}</h4>
                <p class="project-price">{{ formatPrice(project.price) }}₽</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-else>
        <!-- Блок профиля исполнителя (портфолио) -->
        <div class="profile-block">
          <div class="flex items-center gap-6 mb-6">
            <img :src="user.avatar || getDefaultAvatar('executor')" class="w-20 h-20 rounded-full object-cover border-4 border-blue-900" />
            <div>
              <div class="text-xl font-bold">{{ user.name }} {{ user.surname }}</div>
              <div class="text-gray-400">{{ user.specialization || 'Исполнитель' }}</div>
              <div class="flex items-center gap-2 mt-1">
                <span v-for="i in 5" :key="i" class="star" :class="{filled: i <= (user.rating || 0)}">★</span>
                <span class="text-gray-400 ml-2">{{ user.rating || 0 }}/5</span>
              </div>
            </div>
          </div>
          <div class="mb-4">
            <div class="font-semibold mb-2">О себе</div>
            <div class="text-gray-300">{{ user.description || 'Описание не указано.' }}</div>
          </div>
          <div class="mb-4">
            <div class="font-semibold mb-2">Выполненные проекты</div>
            <div v-if="executorProjects.length === 0" class="text-gray-400">Пока нет проектов</div>
            <ul v-else class="project-list">
              <li v-for="project in executorProjects" :key="project.id" class="project-item">
                <span class="project-title">{{ project.title }}</span>
                <span class="project-price">{{ formatPrice(project.price) }}₽</span>
              </li>
            </ul>
          </div>
          <div class="mb-4">
            <div class="font-semibold mb-2">Отзывы клиентов</div>
            <div v-if="executorReviews.length === 0" class="text-gray-400">Пока нет отзывов</div>
            <ul v-else class="review-list">
              <li v-for="review in executorReviews" :key="review.id" class="review-item">
                <div class="review-header">
                  <span class="reviewer-name">{{ review.reviewer_name }}</span>
                  <span class="review-rating">{{ review.rating }}★</span>
                </div>
                <div class="review-text">{{ review.text }}</div>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Profile',
  data() {
    return {
      mode: 'customer',
      user: {},
      customerOrders: [],
      customerReviews: [],
      customerProjects: [],
      customerStats: {},
      executorProjects: [],
      executorReviews: []
    }
  },
  mounted() {
    this.fetchUser();
    this.fetchCustomerOrders();
    this.fetchCustomerReviews();
    this.fetchExecutorProjects();
    this.fetchExecutorReviews();
  },
  methods: {
    async fetchUser() {
      // Получаем текущего пользователя (можно заменить на API)
      this.user = JSON.parse(localStorage.getItem('user') || '{}');
    },
    async fetchCustomerOrders() {
      // Заглушка: получить заказы пользователя как заказчика
      this.customerOrders = [];
    },
    async fetchCustomerReviews() {
      // Заглушка: получить отзывы о заказчике
      this.customerReviews = [];
    },
    async fetchCustomerProjects() {
      // Заглушка: получить выполненные проекты заказчика
      this.customerProjects = [];
    },
    async fetchCustomerStats() {
      // Заглушка: получить статистику заказчика
      this.customerStats = {
        ordersCreated: 0,
        avgResponseTime: '—',
        avgProjectPrice: 0
      };
    },
    async fetchExecutorProjects() {
      // Заглушка: получить проекты исполнителя
      this.executorProjects = [];
    },
    async fetchExecutorReviews() {
      // Заглушка: получить отзывы об исполнителе
      this.executorReviews = [];
    },
    statusText(status) {
      switch (status) {
        case 'open': return 'Открыт';
        case 'in_progress': return 'В работе';
        case 'done': return 'Завершён';
        default: return status || '—';
      }
    },
    formatPrice(val) {
      if (!val) return '—';
      return parseInt(val, 10).toLocaleString('ru-RU');
    },
    
    getDefaultAvatar(role = 'customer') {
      return role === 'customer' ? customerIcon : performerIcon;
    },
    
    getAssetUrl(name) {
      try {
        return new URL(`../assets/${name}`, import.meta.url).href;
      } catch (error) {
        console.error(`Error loading asset ${name}:`, error);
        return '#';
      }
    }
  }
}
</script>

<script setup>
import BottomNav from '../components/BottomNav.vue';
import customerIcon from '@/assets/customer.png';
import performerIcon from '@/assets/performer.png';
</script>

<style scoped>
.profile-bg {
  background: #071727;
  color: #fff;
}
.profile-container {
  max-width: 1100px;
}
.profile-tabs {
  margin-bottom: 1.5rem;
}
.tab-btn {
  background: #16243a;
  color: #bfc9da;
  border: none;
  border-radius: 14px;
  padding: 10px 28px;
  font-weight: 600;
  font-size: 1.1rem;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}
.tab-btn.active {
  background: #2563eb;
  color: #fff;
}
.profile-block {
  background: #0D1F31;
  border-radius: 2rem;
  padding: 2.5rem;
  box-shadow: 0 8px 32px rgba(0,0,0,0.1);
}
.order-list, .project-list, .review-list {
  list-style: none;
  padding: 0;
  margin: 0;
}
.order-item, .project-item, .review-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-bottom: 1px solid #22304a;
}
.order-title, .project-title {
  font-weight: 500;
}
.order-status.open {
  color: #10b981;
}
.order-status.in_progress {
  color: #fbbf24;
}
.order-status.done {
  color: #a3a3a3;
}
.project-price {
  color: #10b981;
  font-weight: 600;
}
.review-header {
  display: flex;
  gap: 12px;
  align-items: center;
}
.reviewer-name {
  font-weight: 600;
}
.review-rating {
  color: #fbbf24;
  font-weight: 600;
}
.review-text {
  color: #bfc9da;
  margin-top: 4px;
}
.star {
  color: #4a5568;
  font-size: 18px;
}
.star.filled {
  color: #fbbf24;
}
</style>