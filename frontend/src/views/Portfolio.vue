<template>
  <div class="portfolio-bg min-h-screen w-full flex justify-center items-start py-8">
    <div class="portfolio-container w-full max-w-[1200px] flex flex-col gap-8">
      <!-- Мобильная навигация -->
      <BottomNav />
      <!-- Header с кнопкой назад -->
      <div class="flex items-center gap-4">
        <button @click="$router.go(-1)" class="back-btn">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M19 12H5M12 19l-7-7 7-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          Назад
        </button>
        <h1 class="text-2xl font-bold">Портфолио исполнителя</h1>
      </div>

      <!-- Основная информация об исполнителе -->
      <div class="executor-info-card">
        <div class="executor-header">
          <div class="executor-avatar">
            <img :src="getUserAvatar(executor, 'executor')" alt="Avatar" class="w-20 h-20 rounded-full object-cover" />
          </div>
          <div class="executor-details">
            <h2 class="executor-name">{{ executor.name }} {{ executor.surname }}</h2>
            <p class="executor-specialization">Исполнитель</p>
            <div class="executor-rating">
              <div class="stars">
                <span v-for="i in 5" :key="i" class="star" :class="{ 'filled': i <= executor.rating }">★</span>
              </div>
              <span class="rating-text">{{ executor.rating || 0 }}/5</span>
            </div>
          </div>
          <div class="executor-actions">
            <button v-if="isOwnPortfolio" @click="showAddProjectModal = true" class="add-project-btn">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 5v14M5 12h14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Добавить работу в портфолио
            </button>
            <button v-if="isOwnPortfolio" @click="editProfile" class="edit-profile-btn">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="m18.5 2.5 3 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              Редактировать профиль
            </button>
            <button v-else @click="contactExecutor" class="contact-btn">
              Связаться
            </button>
          </div>
        </div>
        
        <div class="executor-description">
          <div v-if="executor.specializations && executor.specializations.length > 0" class="specializations-section">
            <h4 class="specializations-title">Специализации:</h4>
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
          <p>{{ executor.executor_description || 'Описание исполнителя пока не добавлено.' }}</p>
        </div>
      </div>

      <!-- Лучшие работы исполнителя -->
      <div class="best-works-section">
        <div class="section-header">
          <h3 class="section-title">Лучшие работы</h3>
          <div class="section-count">{{ bestWorks.length }} работ</div>
        </div>
        
        <div v-if="bestWorks.length === 0" class="empty-state">
          <div class="empty-icon">✨</div>
          <p class="empty-text">Пока нет работ в портфолио</p>
          <p v-if="isOwnPortfolio" class="empty-hint">Добавьте свои лучшие работы, чтобы привлечь клиентов</p>
        </div>
        
        <div v-else class="best-works-grid">
          <div 
            v-for="work in bestWorks" 
            :key="work.id" 
            class="work-card"
            @click="openWorkView(work)"
          >
            <div class="work-header">
              <div class="work-type-badge">{{ getWorkTypeName(work.specialization) }}</div>
                             <div class="work-actions">
                 <button class="work-action-btn view-btn" title="Посмотреть">
                   <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                     <path d="M1 12S5 4 12 4s11 8 11 8-4 8-11 8S1 12 1 12z" stroke="currentColor" stroke-width="2"/>
                     <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="2"/>
                   </svg>
                 </button>
                 <button v-if="work.url" class="work-action-btn link-btn" title="Открыть ссылку" @click.stop="openWorkLink(work.url)">
                   <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                     <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" stroke="currentColor" stroke-width="2"/>
                     <polyline points="15,3 21,3 21,9" stroke="currentColor" stroke-width="2"/>
                     <line x1="10" y1="14" x2="21" y2="3" stroke="currentColor" stroke-width="2"/>
                   </svg>
                 </button>
                 <button v-if="isOwnPortfolio" class="work-action-btn delete-btn" title="Удалить работу" @click.stop="deleteWork(work)">
                   <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                     <path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0v14m4-14v14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                   </svg>
                 </button>
               </div>
            </div>
            <div class="work-content">
              <h4 class="work-title">{{ work.title }}</h4>
            </div>
            <div class="work-description-wrapper">
              <p class="work-description">{{ truncateText(work.description, 100) }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Статистика исполнителя -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon">📊</div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.completedOrdersAsExecutor || 0 }}</div>
            <div class="stat-label">Выполнено заказов</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">💰</div>
          <div class="stat-content">
            <div class="stat-value">{{ formatPrice(stats.avgProjectPrice) }}₽</div>
            <div class="stat-label">Средняя цена проекта</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">⭐</div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.executorReviewsCount || 0 }}</div>
            <div class="stat-label">Получено отзывов</div>
          </div>
        </div>
        <div class="stat-card">
          <div class="stat-icon">⏱️</div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.avgResponseTime || '—' }}</div>
            <div class="stat-label">Среднее время ответа</div>
          </div>
        </div>
      </div>

      <!-- Выполненные проекты -->
      <div class="projects-section">
        <div class="section-header">
          <h3 class="section-title">Выполненные проекты</h3>
          <div class="section-count">{{ projects.length }} работ</div>
        </div>
        
        <div v-if="projects.length === 0" class="empty-state">
          <div class="empty-icon">🎨</div>
          <p class="empty-text">Пока нет выполненных проектов</p>
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
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Отзывы на исполнителя -->
      <div class="reviews-section">
        <div class="section-header">
          <h3 class="section-title">Отзывы на исполнителя</h3>
          <div class="section-count">{{ executorReviews.length }} отзывов</div>
        </div>
        
        <div v-if="executorReviews.length === 0" class="empty-state">
          <div class="empty-icon">💬</div>
          <p class="empty-text">Пока нет отзывов</p>
        </div>
        
        <div v-else class="reviews-list">
          <div v-for="review in executorReviews" :key="review.id" class="review-card">
            <div class="review-header">
              <div class="reviewer-info">
                <img :src="review.reviewer.avatar || getDefaultAvatar('customer')" alt="Reviewer" class="reviewer-avatar" />
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

    <!-- Модальное окно добавления проекта -->
    <transition name="fade">
      <div v-if="showAddProjectModal" class="modal-overlay" @click.self="showAddProjectModal = false">
        <div class="modal-content">
          <div class="modal-header">
            <div class="modal-title-section">
              <div class="modal-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M12 2L13.09 8.26L20 9L13.09 9.74L12 16L10.91 9.74L4 9L10.91 8.26L12 2Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </div>
              <div>
                <h3>Добавить работу в портфолио</h3>
                <p>Покажите свои лучшие проекты потенциальным клиентам</p>
              </div>
            </div>
            <button @click="showAddProjectModal = false" class="modal-close">×</button>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label>Название проекта</label>
              <input v-model="newProject.title" type="text" placeholder="Введите название проекта" />
            </div>
            <div class="form-group">
              <label>Тип работы</label>
              <select v-model="newProject.specialization" class="form-select">
                <option value="">Выберите специализацию</option>
                <option value="video">Видео</option>
                <option value="color_correction">Цветокоррекция</option>
                <option value="motion_design">Моушн-дизайн</option>
                <option value="video_editing">Монтаж видео</option>
                <option value="graphic_design">Графический дизайн</option>
                <option value="logo_design">Дизайн логотипов</option>
                <option value="branding">Брендинг</option>
                <option value="presentation">Презентации</option>
                <option value="advertising">Рекламные макеты</option>
                <option value="social_media">Контент для соцсетей</option>
                <option value="mp_card_design">Дизайн карточки для МП</option>
                <option value="business_card_design">Дизайн визитки</option>
              </select>
            </div>
            <div class="form-group">
              <label>Описание</label>
              <textarea v-model="newProject.description" placeholder="Опишите проект и технологии, которые использовались" rows="4"></textarea>
            </div>
            <div class="form-group">
              <label>Ссылка на работу <span class="optional">(обязательно)</span></label>
              <input v-model="newProject.url" type="text" placeholder="https://behance.net/mywork или dribbble.com/myshot" />
              <small class="form-hint">Введите корректную ссылку на вашу работу в Behance, Dribbble или другом портфолио</small>
            </div>
            <div class="form-group">
              <label>Изображение проекта <span class="coming-soon">(скоро)</span></label>
              <div class="coming-soon-placeholder">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M21 19V5a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2z" stroke="currentColor" stroke-width="2"/>
                  <circle cx="8.5" cy="8.5" r="1.5" stroke="currentColor" stroke-width="2"/>
                  <path d="m21 15-5-5L5 21" stroke="currentColor" stroke-width="2"/>
                </svg>
                <p>Загрузка изображений будет доступна в ближайшее время</p>
                <small>Сейчас вы можете добавить работу без изображения</small>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button @click="showAddProjectModal = false" class="btn-secondary">Отмена</button>
            <button @click="addProject" class="btn-primary">Добавить</button>
          </div>
        </div>
      </div>
    </transition>

    <!-- Модальное окно просмотра работы -->
    <transition name="fade">
      <div v-if="showWorkViewModal && selectedWork" class="modal-overlay" @click.self="showWorkViewModal = false">
        <div class="work-view-modal">
          <button @click="showWorkViewModal = false" class="modal-close work-close">×</button>
          
          <div class="work-view-content">
            <div class="work-view-info">
              <div class="work-view-header">
                <div class="work-view-type">{{ getWorkTypeName(selectedWork.specialization) }}</div>
                <h2 class="work-view-title">{{ selectedWork.title }}</h2>
              </div>
              
              <div class="work-view-description">
                <h4>Описание проекта</h4>
                <p>{{ selectedWork.description }}</p>
              </div>
              
              <div class="work-view-executor">
                <div class="executor-mini">
                  <img :src="executor.avatar || getDefaultAvatar('executor')" alt="Avatar" class="executor-mini-avatar" />
                  <div>
                    <div class="executor-mini-name">{{ executor.name }} {{ executor.surname }}</div>
                    <div class="executor-mini-role">Исполнитель</div>
                  </div>
                </div>
              </div>
              
                             <div class="work-view-actions">
                 <button v-if="selectedWork.url" @click="openWorkLink(selectedWork.url)" class="btn-view-link">
                   <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                     <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" stroke="currentColor" stroke-width="2"/>
                     <polyline points="15,3 21,3 21,9" stroke="currentColor" stroke-width="2"/>
                     <line x1="10" y1="14" x2="21" y2="3" stroke="currentColor" stroke-width="2"/>
                   </svg>
                   Посмотреть проект
                 </button>
                 <button v-if="!isOwnPortfolio" @click="contactExecutor" class="btn-contact">
                   Связаться с исполнителем
                 </button>
                 <button v-if="isOwnPortfolio" @click="deleteWork(selectedWork)" class="btn-delete">
                   <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                     <path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0v14m4-14v14" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                   </svg>
                   Удалить работу
                 </button>
               </div>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
import BottomNav from '../components/BottomNav.vue';

export default {
  name: 'Portfolio',
  components: {
    BottomNav
  },
  data() {
    return {
      executor: {},
      stats: {},
      projects: [],
      reviews: [],
      executorReviews: [],
      bestWorks: [],
      showAddProjectModal: false,
      showWorkViewModal: false,
      selectedWork: null,
      newProject: {
        title: '',
        description: '',
        url: '',
        specialization: ''
      }
    }
  },
  computed: {
    isOwnPortfolio() {
      const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
      const isOwn = currentUser.id == this.$route.params.id;
      
      // Отладочная информация
      console.log('Проверка isOwnPortfolio:', {
        currentUserId: currentUser.id,
        routeParamsId: this.$route.params.id,
        isOwn: isOwn,
        currentUser: currentUser
      });
      
      return isOwn;
    }
  },
  mounted() {
    this.fetchPortfolioData();
    // Добавляем обработчик ESC для закрытия модального окна
    document.addEventListener('keydown', this.handleEscKey);
  },

  beforeDestroy() {
    // Удаляем обработчик при уничтожении компонента
    document.removeEventListener('keydown', this.handleEscKey);
  },
  methods: {
    async fetchPortfolioData() {
      try {
        const executorId = this.$route.params.id;
        
        const { data: executor } = await this.$axios.get(`/users/${executorId}`)
        this.executor = executor
        
        const { data: stats } = await this.$axios.get(`/executors/${executorId}/stats`)
        this.stats = stats
        
        const { data: projects } = await this.$axios.get(`/executors/${executorId}/projects`)
        this.projects = projects

        // Получаем лучшие работы исполнителя
        try {
          const { data: bestWorks } = await this.$axios.get(`/portfolio/projects/${executorId}`)
          this.bestWorks = bestWorks
        } catch (error) {
          console.log('Ошибка загрузки лучших работ:', error);
          this.bestWorks = []
        }
        
        const { data: reviews } = await this.$axios.get(`/executors/${executorId}/reviews`)
        this.reviews = reviews
        
        // Получаем отзывы на исполнителя
        const { data: executorReviewsData } = await this.$axios.get(`/reviews/user/${executorId}/by-type`)
        this.executorReviews = executorReviewsData.executor_reviews || []
      } catch (error) {
        console.error('Ошибка загрузки данных портфолио:', error);
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
    

    
    async addProject() {
      // Валидация
      if (!this.newProject.title.trim()) {
        alert('Пожалуйста, введите название проекта');
        return;
      }
      if (!this.newProject.specialization) {
        alert('Пожалуйста, выберите тип работы');
        return;
      }
      if (!this.newProject.description.trim()) {
        alert('Пожалуйста, добавьте описание проекта');
        return;
      }
      
      // Валидация URL (если указан)
      if (this.newProject.url && this.newProject.url.trim()) {
        const urlPattern = /^(https?:\/\/)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\/.*)?$/;
        if (!urlPattern.test(this.newProject.url.trim())) {
          alert('Пожалуйста, введите корректную ссылку (например: https://behance.net/mywork или behance.net/mywork)');
          return;
        }
        
        // Добавляем https:// если протокол не указан
        if (!this.newProject.url.startsWith('http://') && !this.newProject.url.startsWith('https://')) {
          this.newProject.url = 'https://' + this.newProject.url;
        }
      }

      try {
        const formData = new FormData();
        formData.append('title', this.newProject.title);
        formData.append('description', this.newProject.description);
        formData.append('specialization', this.newProject.specialization);
        if (this.newProject.url) {
          formData.append('url', this.newProject.url);
        }
        
        const response = await this.$axios.post('/portfolio/projects', formData, { 
          headers: { 'Content-Type': 'multipart/form-data' } 
        });
        
        console.log('Работа добавлена:', response.data);
        alert('Работа успешно добавлена в портфолио!');
        this.showAddProjectModal = false;
        this.resetForm();
        this.fetchPortfolioData();
      } catch (error) {
        console.error('Ошибка добавления проекта:', error);
        
        // Обработка ошибок валидации от backend
        if (error.response && error.response.status === 422 && error.response.data.errors) {
          const errors = error.response.data.errors;
          let errorMessage = 'Ошибки валидации:\n';
          
          if (errors.title) errorMessage += `• Название: ${errors.title[0]}\n`;
          if (errors.description) errorMessage += `• Описание: ${errors.description[0]}\n`;
          if (errors.specialization) errorMessage += `• Тип работы: ${errors.specialization[0]}\n`;
          if (errors.url) errorMessage += `• Ссылка: ${errors.url[0]}\n`;
          if (errors.image) errorMessage += `• Изображение: ${errors.image[0]}\n`;
          
          alert(errorMessage);
        } else if (error.response && error.response.data.message) {
          alert('Ошибка: ' + error.response.data.message);
        } else {
          alert('Произошла ошибка при добавлении работы. Попробуйте еще раз.');
        }
      }
    },

    resetForm() {
      this.newProject = { 
        title: '', 
        description: '', 
        url: '', 
        specialization: '' 
      };
    },

    handleEscKey(event) {
      if (event.key === 'Escape') {
        if (this.showAddProjectModal) {
          this.showAddProjectModal = false;
        }
        if (this.showWorkViewModal) {
          this.showWorkViewModal = false;
        }
      }
    },

    openWorkView(work) {
      this.selectedWork = work;
      this.showWorkViewModal = true;
    },

         openWorkLink(url) {
       window.open(url, '_blank');
     },

     async deleteWork(work) {
       if (!confirm(`Вы уверены, что хотите удалить работу "${work.title}"?`)) {
         return;
       }

       try {
         await this.$axios.delete(`/portfolio/projects/${work.id}`);
         alert('Работа успешно удалена!');
         
         // Закрываем модальное окно если оно открыто
         if (this.showWorkViewModal) {
           this.showWorkViewModal = false;
           this.selectedWork = null;
         }
         
         // Обновляем список работ
         this.fetchPortfolioData();
       } catch (error) {
         console.error('Ошибка удаления работы:', error);
         
         if (error.response && error.response.data.message) {
           alert('Ошибка: ' + error.response.data.message);
         } else {
           alert('Произошла ошибка при удалении работы. Попробуйте еще раз.');
         }
       }
     },

    getWorkTypeName(specialization) {
      const types = {
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
      return types[specialization] || specialization || 'Другое';
    },

    truncateText(text, maxLength) {
      if (!text) return '';
      if (text.length <= maxLength) return text;
      return text.substring(0, maxLength) + '...';
    },
    
    async contactExecutor() {
      try {
        // Проверяем, авторизован ли пользователь
        const token = localStorage.getItem('token');
        if (!token) {
          this.$router.push('/login');
          return;
        }

        // Получаем роль текущего пользователя
        const currentRole = localStorage.getItem('role');
        if (currentRole !== 'customer') {
          alert('Связаться с исполнителем могут только заказчики');
          return;
        }

        // Получаем ID текущего пользователя
        const currentUserId = localStorage.getItem('user_id');
        if (!currentUserId) {
          alert('Ошибка: не удалось определить пользователя');
          return;
        }

        // Получаем ID исполнителя из URL
        const executorId = this.$route.params.id;

        // Создаем новый заказ с выбранным исполнителем
        const orderData = {
          title: `Заказ для ${this.executor.name}`,
          description: 'Заказ создан через портфолио исполнителя',
          work_type_id: 1, // Базовый тип работы
          budget: 0, // Бюджет будет обсужден в чате
          deadline: null, // Срок будет обсужден в чате
          executor_id: executorId, // Назначаем исполнителя сразу
          status: 'pending_approval' // Статус ожидания подтверждения
        };

        // Отправляем запрос на создание заказа
        const response = await fetch('/api/orders', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`,
            'Accept': 'application/json'
          },
          body: JSON.stringify(orderData)
        });

        if (!response.ok) {
          throw new Error('Ошибка при создании заказа');
        }

        const order = await response.json();

        // Создаем чат для заказа
        const chatResponse = await fetch(`/api/chats/order/${order.id}`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Accept': 'application/json'
          }
        });

        if (!chatResponse.ok) {
          throw new Error('Ошибка при создании чата');
        }

        const chat = await chatResponse.json();

        // Переходим к чату
        this.$router.push(`/dashboard?tab=messages&chat=${chat.id}`);

      } catch (error) {
        console.error('Ошибка при связи с исполнителем:', error);
        alert('Произошла ошибка при попытке связаться с исполнителем. Попробуйте позже.');
      }
    },
    editProfile() {
      this.$router.push(`/profile/executor/${this.$route.params.id}/edit`);
    },
    
    getDefaultAvatar(role = 'executor') {
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
    getUserAvatar(user, role = 'executor') {
      // Пока используем только статичные аватарки
      return this.getDefaultAvatar(role);
    },
    getSpecializationName(specialization) {
      const specializations = {
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
      return specializations[specialization] || specialization;
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

.executor-info-card {
  background: #0D1F31;
  border-radius: 24px;
  padding: 32px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.1);
}

.executor-header {
  display: flex;
  align-items: center;
  gap: 24px;
  margin-bottom: 24px;
}

.executor-avatar img {
  border: 4px solid #22304a;
}

.executor-details {
  flex: 1;
}

.executor-name {
  font-size: 28px;
  font-weight: 700;
  margin-bottom: 8px;
}

.executor-specialization {
  color: #bfc9da;
  font-size: 16px;
  margin-bottom: 12px;
}

.executor-specializations {
  margin-bottom: 12px;
}

.specialization-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.specialization-tag {
  display: inline-flex;
  align-items: center;
  padding: 4px 8px;
  background: #2563eb;
  color: #fff;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.executor-rating {
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

.executor-actions {
  display: flex;
  gap: 12px;
}

.add-project-btn, .contact-btn, .edit-profile-btn {
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

.add-project-btn {
  background: #2563eb;
  color: #fff;
}

.add-project-btn:hover {
  background: #1d4ed8;
}

.contact-btn {
  background: #059669;
  color: #fff;
}

.contact-btn:hover {
  background: #047857;
}

.edit-profile-btn {
  background: #2563eb;
  color: #fff;
}

.edit-profile-btn:hover {
  background: #1d4ed8;
}

.executor-description {
  color: #bfc9da;
  line-height: 1.6;
  font-size: 16px;
}

.specializations-section {
  margin-bottom: 16px;
}

.specializations-title {
  font-size: 16px;
  font-weight: 600;
  color: #fff;
  margin-bottom: 8px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.stat-card {
  background: #0D1F31;
  border-radius: 16px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 4px 16px rgba(0,0,0,0.1);
}

.stat-icon {
  font-size: 32px;
  width: 60px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #22304a;
  border-radius: 12px;
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

.best-works-section, .projects-section, .reviews-section {
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
}

.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: #bfc9da;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.empty-text {
  font-size: 16px;
}

.empty-hint {
  font-size: 14px;
  color: #6b7280;
  margin-top: 8px;
}

.best-works-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}

.work-card {
  background: #1f2937;
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 1px solid #374151;
  padding: 20px;
}

.work-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(0, 0, 0, 0.2);
  border-color: #2563eb;
}

.work-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.work-type-badge {
  background: #2563eb;
  color: white;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
}

.work-actions {
  display: flex;
  gap: 8px;
  align-self: flex-end;
}

.work-action-btn {
  width: 36px;
  height: 36px;
  background: rgba(255, 255, 255, 0.9);
  border: none;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  color: #1f2937;
}

.work-action-btn:hover {
  background: white;
  transform: scale(1.1);
}

.work-action-btn.delete-btn {
  background: rgba(239, 68, 68, 0.9);
  color: white;
}

.work-action-btn.delete-btn:hover {
  background: #ef4444;
}

.work-content {
  padding: 16px;
}

.work-title {
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 8px 0;
  color: #f3f4f6;
}

.work-description-wrapper {
  padding: 0 16px 16px 16px;
}

.work-description {
  font-size: 14px;
  color: #9ca3af;
  line-height: 1.4;
  margin: 0;
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
}

.project-price {
  font-weight: 600;
  color: #10b981;
}

.project-date {
  color: #bfc9da;
  font-size: 12px;
}

.reviews-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.review-card {
  background: #16243a;
  border-radius: 16px;
  padding: 24px;
}

.review-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.reviewer-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.reviewer-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
}

.reviewer-name {
  font-weight: 600;
  margin-bottom: 4px;
}

.review-date {
  color: #bfc9da;
  font-size: 12px;
}

.review-order {
  color: #bfc9da;
  font-size: 12px;
  margin-top: 2px;
}



.review-rating {
  display: flex;
  gap: 2px;
}

.review-text {
  color: #bfc9da;
  line-height: 1.6;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.7);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: #0D1F31;
  border-radius: 24px;
  padding: 0;
  max-width: 600px;
  width: 95%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
  border: 1px solid #374151;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px 32px;
  border-bottom: 1px solid #374151;
}

.modal-title-section {
  display: flex;
  align-items: center;
  gap: 16px;
}

.modal-icon {
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #2563eb, #3b82f6);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.modal-title-section h3 {
  margin: 0;
  font-size: 20px;
  font-weight: 700;
  color: #f3f4f6;
}

.modal-title-section p {
  margin: 4px 0 0 0;
  font-size: 14px;
  color: #9ca3af;
}

.modal-close {
  background: none;
  border: none;
  color: #bfc9da;
  font-size: 24px;
  cursor: pointer;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  transition: background 0.2s;
}

.modal-close:hover {
  background: #22304a;
}

.modal-body {
  padding: 32px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #bfc9da;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 12px 16px;
  background: #16243a;
  border: 1px solid #22304a;
  border-radius: 12px;
  color: #fff;
  font-size: 14px;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
  outline: none;
  border-color: #2563eb;
}

.form-select {
  width: 100%;
  padding: 12px 16px;
  background: #16243a;
  border: 1px solid #22304a;
  border-radius: 12px;
  color: #fff;
  font-size: 14px;
  cursor: pointer;
}

.form-select option {
  background: #16243a;
  color: #fff;
}

.form-hint {
  display: block;
  margin-top: 6px;
  font-size: 12px;
  color: #6b7280;
}

.optional {
  font-weight: 400;
  color: #6b7280;
  font-size: 14px;
}

.coming-soon {
  font-weight: 400;
  color: #f59e0b;
  font-size: 14px;
}

.coming-soon-placeholder {
  border: 2px dashed #374151;
  border-radius: 12px;
  padding: 32px;
  text-align: center;
  background: #1f2937;
  color: #9ca3af;
  cursor: not-allowed;
}

.coming-soon-placeholder svg {
  margin-bottom: 16px;
  opacity: 0.5;
}

.coming-soon-placeholder p {
  font-size: 16px;
  margin-bottom: 8px;
  color: #d1d5db;
}

.coming-soon-placeholder small {
  font-size: 14px;
  color: #6b7280;
}

.file-upload-area {
  border: 2px dashed #374151;
  border-radius: 12px;
  padding: 32px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  background: #111827;
}

.file-upload-area:hover {
  border-color: #2563eb;
  background: #1e293b;
}

.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  color: #9ca3af;
}

.upload-placeholder svg {
  opacity: 0.6;
}

.upload-placeholder p {
  margin: 0;
  font-size: 16px;
  font-weight: 500;
}

.upload-placeholder small {
  font-size: 12px;
  opacity: 0.7;
}

.upload-preview {
  position: relative;
  display: inline-block;
}

.preview-image {
  max-width: 200px;
  max-height: 150px;
  border-radius: 8px;
  object-fit: cover;
}

.remove-image {
  position: absolute;
  top: -8px;
  right: -8px;
  width: 24px;
  height: 24px;
  background: #ef4444;
  color: white;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  line-height: 1;
}

.modal-footer {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  padding: 24px 32px;
  background: #1f2937;
  border-top: 1px solid #374151;
  border-radius: 0 0 24px 24px;
}

.btn-secondary,
.btn-primary {
  padding: 14px 28px;
  border-radius: 12px;
  border: none;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
}

.btn-secondary {
  background: transparent;
  color: #9ca3af;
  border: 1px solid #374151;
}

.btn-secondary:hover {
  background: #374151;
  color: #f3f4f6;
}

.btn-primary {
  background: linear-gradient(135deg, #2563eb, #3b82f6);
  color: #fff;
  box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
}

.btn-primary:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
}

.btn-primary:active {
  transform: translateY(0);
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter, .fade-leave-to {
  opacity: 0;
}

/* Work View Modal */
.work-view-modal {
  background: #0D1F31;
  border-radius: 24px;
  max-width: 900px;
  width: 95%;
  max-height: 90vh;
  overflow: hidden;
  position: relative;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
  border: 1px solid #374151;
}

.work-close {
  position: absolute;
  top: 20px;
  right: 20px;
  z-index: 10;
  width: 40px;
  height: 40px;
  background: rgba(0, 0, 0, 0.7);
  color: white;
  border-radius: 50%;
  font-size: 20px;
}

.work-close:hover {
  background: rgba(0, 0, 0, 0.9);
}

.work-view-content {
  display: flex;
  min-height: 500px;
}

.work-view-info {
  flex: 1;
  padding: 32px;
  display: flex;
  flex-direction: column;
  gap: 24px;
  background: #1f2937;
}



.work-view-header {
  border-bottom: 1px solid #374151;
  padding-bottom: 16px;
}

.work-view-type {
  background: #2563eb;
  color: white;
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  display: inline-block;
  margin-bottom: 12px;
}

.work-view-title {
  font-size: 24px;
  font-weight: 700;
  margin: 0;
  color: #f3f4f6;
  line-height: 1.3;
}

.work-view-description h4 {
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 12px 0;
  color: #f3f4f6;
}

.work-view-description p {
  font-size: 14px;
  color: #d1d5db;
  line-height: 1.6;
  margin: 0;
}

.work-view-executor {
  padding: 16px;
  background: #111827;
  border-radius: 12px;
  border: 1px solid #374151;
}

.executor-mini {
  display: flex;
  align-items: center;
  gap: 12px;
}

.executor-mini-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  object-fit: cover;
}

.executor-mini-name {
  font-size: 14px;
  font-weight: 600;
  color: #f3f4f6;
}

.executor-mini-role {
  font-size: 12px;
  color: #9ca3af;
}

.work-view-actions {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: auto;
}

.btn-view-link {
  background: linear-gradient(135deg, #2563eb, #3b82f6);
  color: white;
  border: none;
  padding: 14px 20px;
  border-radius: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-size: 14px;
}

.btn-view-link:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
}

.btn-contact {
  background: transparent;
  color: #9ca3af;
  border: 1px solid #374151;
  padding: 14px 20px;
  border-radius: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
}

.btn-contact:hover {
  background: #374151;
  color: #f3f4f6;
}

.btn-delete {
  background: transparent;
  color: #ef4444;
  border: 1px solid #ef4444;
  padding: 14px 20px;
  border-radius: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.btn-delete:hover {
  background: #ef4444;
  color: white;
}

@media (max-width: 768px) {
  .executor-header {
    flex-direction: column;
    text-align: center;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .best-works-grid {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  
  .projects-grid {
    grid-template-columns: 1fr;
  }

  .work-view-content {
    flex-direction: column;
    min-height: auto;
  }

  .work-view-info {
    padding: 24px;
  }

  .work-view-actions {
    flex-direction: column;
  }
}
</style> 