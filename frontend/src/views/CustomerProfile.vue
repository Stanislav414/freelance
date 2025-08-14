<template>
  <div class="portfolio-bg min-h-screen w-full flex justify-center items-start py-8">
    <div class="portfolio-container w-full max-w-[1200px] flex flex-col gap-8">
      <!-- Header с кнопкой назад -->
      <div class="flex items-center gap-4">
        <button @click="$router.go(-1)" class="back-btn">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M19 12H5M12 19l-7-7 7-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          Назад
        </button>
        <h1 class="text-2xl font-bold">Профиль заказчика</h1>
      </div>

      <!-- Основная информация о заказчике -->
      <div class="customer-info-card">
        <div class="customer-header">
          <div class="customer-avatar">
            <img :src="customer.avatar || getDefaultAvatar('customer')" alt="Avatar" class="w-20 h-20 rounded-full object-cover" />
          </div>
          <div class="customer-details">
            <h2 class="customer-name">{{ customer.name }} {{ customer.surname }}</h2>
            <p class="customer-role">Заказчик</p>
            <div class="customer-rating">
              <div class="stars">
                <span v-for="i in 5" :key="i" class="star" :class="{ 'filled': i <= customer.rating }">★</span>
              </div>
              <span class="rating-text">{{ customer.rating || 0 }}/5</span>
            </div>
          </div>
          <div class="customer-actions">
            <button v-if="isOwnProfile" @click="editProfile" class="edit-profile-btn">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="m18.5 2.5 3 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Редактировать профиль
            </button>
            <button v-else @click="contactCustomer" class="contact-btn">
              Связаться
            </button>
          </div>
        </div>
        
        <div class="customer-description">
          <p>{{ customer.customer_description || 'Описание заказчика пока не добавлено.' }}</p>
        </div>
      </div>

      <!-- Статистика заказчика -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon">📊</div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.completedOrders || 0 }}</div>
            <div class="stat-label">Завершено заказов</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">💰</div>
          <div class="stat-content">
            <div class="stat-value">{{ formatPrice(stats.avgProjectPrice) }}₽</div>
            <div class="stat-label">Средняя цена заказа</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">⭐</div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.receivedReviewsCount || 0 }}</div>
            <div class="stat-label">Получено отзывов</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">💬</div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.givenReviewsCount || 0 }}</div>
            <div class="stat-label">Оставлено отзывов</div>
          </div>
        </div>
      </div>

      <!-- Завершенные заказы -->
      <div class="projects-section">
        <div class="section-header">
          <h3 class="section-title">Завершенные заказы</h3>
          <div class="section-count">{{ projects.length }} заказов</div>
        </div>
        
        <div v-if="projects.length === 0" class="empty-state">
          <div class="empty-icon">📋</div>
          <p class="empty-text">Пока нет завершенных заказов</p>
        </div>
        
        <div v-else class="projects-grid">
          <div v-for="project in projects" :key="project.id" class="project-card">
            <div class="project-image">
                              <img :src="project.image || getAssetUrl('infographic.png')" :alt="project.title" class="w-full h-48 object-cover rounded-lg" />
            </div>
            <div class="project-content">
              <h4 class="project-title">{{ project.title }}</h4>
              <p class="project-description">{{ project.description }}</p>
              <div class="project-meta">
                <span class="project-price">{{ formatPrice(project.price) }}₽</span>
                <span class="project-date">{{ formatDate(project.completed_at) }}</span>
                <span class="project-role" :class="'role-' + project.role">{{ getRoleLabel(project.role) }}</span>
              </div>
              <div class="project-review-status">
                <span class="review-status" :class="{ 'has-review': project.has_review }">
                  {{ project.review_status }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Отзывы на заказчика -->
      <div class="reviews-section">
        <div class="section-header">
          <h3 class="section-title">Отзывы на заказчика</h3>
          <div class="section-count">{{ customerReviews.length }} отзывов</div>
        </div>
        
        <div v-if="customerReviews.length === 0" class="empty-state">
          <div class="empty-icon">💬</div>
          <p class="empty-text">Пока нет отзывов</p>
        </div>
        
        <div v-else class="reviews-list">
          <div v-for="review in customerReviews" :key="review.id" class="review-card">
            <div class="review-header">
              <div class="reviewer-info">
                <img :src="review.reviewer.avatar || getDefaultAvatar('executor')" alt="Reviewer" class="reviewer-avatar" />
                <div>
                  <div class="reviewer-name">{{ review.reviewer.name }} {{ review.reviewer.surname }}</div>
                  <div class="review-date">{{ formatDate(review.created_at) }}</div>
                  <div class="review-order">Заказ: {{ review.order.title }}</div>
                </div>
              </div>
              <div class="review-rating">
                <span v-for="i in 5" :key="i" class="star" :class="{ 'filled': i <= review.rating }">★</span>
              </div>
            </div>
            <p class="review-text">{{ review.text }}</p>
          </div>
        </div>
      </div>


    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomerProfile',
  components: {},
  data() {
    return {
      customer: {},
      stats: {},
      projects: [],
      customerReviews: []
    }
  },
  computed: {
    isOwnProfile() {
      const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
      return currentUser.id == this.$route.params.id;
    }
  },
  mounted() {
    this.fetchCustomerData();
  },
  
  watch: {
    // Следим за изменениями роли в localStorage
    '$route': {
      handler() {
        this.fetchCustomerData();
      },
      immediate: true
    }
  },
  methods: {
    async fetchCustomerData() {
      try {
        const customerId = this.$route.params.id;
        
        // Получаем актуальные данные пользователя
        const { data: customer } = await this.$axios.get(`/users/${customerId}`)
        this.customer = customer
        
        // Обновляем данные в localStorage если это профиль текущего пользователя
        const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
        if (currentUser.id == customerId) {
          const updatedUser = {
            ...currentUser,
            ...customer
          };
          localStorage.setItem('user', JSON.stringify(updatedUser));
        }
        
        const { data: stats } = await this.$axios.get(`/customers/${customerId}/stats`)
        this.stats = stats
        
        const { data: projects } = await this.$axios.get(`/customers/${customerId}/projects`)
        this.projects = projects
        
        // Получаем отзывы на заказчика
        const { data: customerReviewsData } = await this.$axios.get(`/reviews/user/${customerId}/by-type`)
        this.customerReviews = customerReviewsData.customer_reviews || []
        
        console.log('Данные профиля заказчика загружены:', customer);
      } catch (error) {
        console.error('Ошибка загрузки данных профиля заказчика:', error);
      }
    },
    
    formatPrice(price) {
      if (!price) return '—';
      return parseInt(price, 10).toLocaleString('ru-RU');
    },
    
    formatDate(date) {
      if (!date) return '—';
      return new Date(date).toLocaleDateString('ru-RU', { 
        day: 'numeric', 
        month: 'long', 
        year: 'numeric' 
      });
    },
    
    getRoleLabel(role) {
      return role === 'customer' ? 'Заказчик' : 'Исполнитель';
    },
    
    contactCustomer() {
      // Заглушка для связи с заказчиком
      alert('Функция связи с заказчиком будет реализована позже');
    },
    
    editProfile() {
      this.$router.push(`/profile/customer/${this.$route.params.id}/edit`);
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
import customerIcon from '@/assets/customer.png';
import performerIcon from '@/assets/performer.png';
</script>

<style scoped>
.portfolio-bg {
  background: #071727;
  color: #fff;
}

.portfolio-container {
  max-width: 1200px;
}

.back-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  background: #0D1F31;
  border: none;
  color: #fff;
  padding: 12px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.2s;
}

.back-btn:hover {
  background: #16243a;
}

.customer-info-card {
  background: #0D1F31;
  border-radius: 24px;
  padding: 32px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.1);
}

.customer-header {
  display: flex;
  align-items: center;
  gap: 24px;
  margin-bottom: 24px;
}

.customer-avatar img {
  border: 4px solid #22304a;
}

.customer-details {
  flex: 1;
}

.customer-name {
  font-size: 28px;
  font-weight: 700;
  margin-bottom: 8px;
}

.customer-role {
  color: #bfc9da;
  font-size: 16px;
  margin-bottom: 12px;
}

.customer-rating {
  display: flex;
  align-items: center;
  gap: 8px;
}

.stars {
  display: flex;
  gap: 2px;
}

.star {
  color: #4a5568;
  font-size: 18px;
}

.star.filled {
  color: #fbbf24;
}

.rating-text {
  color: #bfc9da;
  font-size: 14px;
}

.customer-actions {
  display: flex;
  gap: 12px;
}

.edit-profile-btn, .contact-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  border-radius: 12px;
  border: none;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.edit-profile-btn {
  background: #2563eb;
  color: #fff;
}

.edit-profile-btn:hover {
  background: #1d4ed8;
}

.contact-btn {
  background: #059669;
  color: #fff;
}

.contact-btn:hover {
  background: #047857;
}

.customer-description {
  color: #bfc9da;
  line-height: 1.6;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 24px;
}

.stat-card {
  background: #0D1F31;
  border-radius: 20px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.1);
}

.stat-icon {
  font-size: 32px;
}

.stat-content {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 4px;
}

.stat-label {
  color: #bfc9da;
  font-size: 14px;
}

.projects-section, .reviews-section {
  background: #0D1F31;
  border-radius: 24px;
  padding: 32px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.section-title {
  font-size: 24px;
  font-weight: 700;
}

.section-count {
  color: #bfc9da;
  font-size: 14px;
  background: #16243a;
  padding: 8px 16px;
  border-radius: 20px;
}

.empty-state {
  text-align: center;
  padding: 48px 24px;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.empty-text {
  color: #bfc9da;
  font-size: 16px;
}

.projects-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 24px;
}

.project-card {
  background: #16243a;
  border-radius: 16px;
  overflow: hidden;
  transition: transform 0.2s;
}

.project-card:hover {
  transform: translateY(-4px);
}

.project-image img {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.project-content {
  padding: 20px;
}

.project-title {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 8px;
}

.project-description {
  color: #bfc9da;
  font-size: 14px;
  margin-bottom: 16px;
  line-height: 1.5;
}

.project-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.project-price {
  color: #10b981;
  font-weight: 600;
}

.project-date {
  color: #9ca3af;
  font-size: 12px;
}

.project-role {
  padding: 4px 8px;
  border-radius: 8px;
  font-size: 12px;
  font-weight: 500;
}

.role-customer {
  background: #1e40af;
  color: #fff;
}

.role-executor {
  background: #059669;
  color: #fff;
}

.project-review-status {
  margin-top: 8px;
}

.review-status {
  padding: 6px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
  background: #374151;
  color: #9ca3af;
}

.review-status.has-review {
  background: #059669;
  color: #fff;
}

.reviews-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.review-card {
  background: #16243a;
  border-radius: 16px;
  padding: 20px;
}

.review-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.reviewer-info, .reviewed-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.reviewer-avatar, .reviewed-avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  object-fit: cover;
}

.reviewer-name, .reviewed-name {
  font-weight: 600;
  margin-bottom: 4px;
}

.review-date {
  color: #9ca3af;
  font-size: 12px;
  margin-bottom: 4px;
}

.review-order {
  color: #bfc9da;
  font-size: 12px;
  margin-bottom: 4px;
}



.reviewer-role, .reviewed-role {
  color: #10b981;
  font-size: 12px;
  font-weight: 500;
}

.review-rating {
  display: flex;
  gap: 2px;
}

.review-text {
  color: #bfc9da;
  line-height: 1.6;
}
</style> 