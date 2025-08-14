<template>
  <div class="profile-edit-bg min-h-screen w-full flex justify-center items-start py-8">
    <div class="profile-edit-container w-full max-w-[800px] flex flex-col gap-8">
      <!-- Header -->
      <div class="flex items-center gap-4">
        <button @click="$router.go(-1)" class="back-btn">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M19 12H5M12 19l-7-7 7-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          Назад
        </button>
        <h1 class="text-2xl font-bold">Редактирование профиля</h1>
      </div>

      <!-- Форма редактирования -->
      <div class="profile-edit-form">
        <div class="form-section">
          <h3 class="section-title">Основная информация</h3>
          
          <div class="form-group">
            <label>Имя</label>
            <input v-model="profile.name" type="text" placeholder="Введите имя" />
          </div>
          
          <div class="form-group">
            <label>Фамилия</label>
            <input v-model="profile.surname" type="text" placeholder="Введите фамилию" />
          </div>
          
          <div class="form-group">
            <label>Email</label>
            <input v-model="profile.email" type="email" placeholder="Введите email" disabled />
          </div>
        </div>

        <div class="form-section">
          <h3 class="section-title">Специализация</h3>
          
          <div class="form-group">
            <label>Чем занимаетесь?</label>
            <div class="specializations-container">
              <div class="specialization-options">
                <label v-for="spec in specializationOptions" :key="spec.value" class="specialization-option">
                  <input 
                    type="checkbox" 
                    :value="spec.value" 
                    v-model="profile.specializations"
                    class="specialization-checkbox"
                  />
                  <span class="specialization-label">{{ spec.label }}</span>
                </label>
              </div>
              <div v-if="profile.specializations.length > 0" class="selected-specializations">
                <span class="selected-label">Выбрано специализаций: {{ profile.specializations.length }}</span>
                <div class="specialization-tags">
                  <span 
                    v-for="spec in selectedSpecializations" 
                    :key="spec.value" 
                    class="specialization-tag"
                  >
                    {{ spec.label }}
                    <button @click="removeSpecialization(spec.value)" class="remove-spec-btn" title="Удалить">×</button>
                  </span>
                </div>
              </div>
              <div v-else class="no-specializations">
                <span class="no-spec-text">Выберите хотя бы одну специализацию</span>
              </div>
            </div>
          </div>
          
          <div class="form-group">
            <label>О исполнителе</label>
            <textarea v-model="profile.executor_description" placeholder="Расскажите о своих навыках, опыте, образовании, подходах к работе..." rows="5"></textarea>
            <p class="form-hint">Это поможет заказчикам понять ваш уровень и стиль работы</p>
          </div>
        </div>

        <div class="form-section">
          <h3 class="section-title">Аватар</h3>
          
          <div class="avatar-upload">
            <div class="avatar-preview static">
              <img :src="getAvatarForExecutor()" alt="Avatar" class="avatar-img" @error="onImageError" />
            </div>
            <div class="avatar-hint-wrapper">
              <p class="avatar-hint">
                📷 Загрузка собственных аватарок будет доступна в ближайшем обновлении
              </p>
              <p class="avatar-hint secondary">
                Пока используется стандартная аватарка для исполнителей
              </p>
            </div>
          </div>
        </div>

        <div class="form-actions">
          <button @click="$router.go(-1)" class="btn-secondary" :disabled="isLoading">Отмена</button>
          <button @click="saveProfile" class="btn-primary" :disabled="isLoading">
            <span v-if="isLoading">Сохранение...</span>
            <span v-else>Сохранить</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import performerAvatar from '@/assets/performer.png';

export default {
  name: 'ExecutorProfileEdit',
  data() {
    return {
      profile: {
        name: '',
        surname: '',
        email: '',
        specializations: [],
        executor_description: '',
        avatar: ''
      },
      isLoading: false,
      specializationOptions: [
        { value: 'mp_card_design', label: 'Дизайн карточки для МП' },
        { value: 'business_card_design', label: 'Дизайн визитки' },
        { value: 'video', label: 'Видео' }
      ]
    }
  },
  computed: {
    selectedSpecializations() {
      return this.specializationOptions.filter(spec => 
        this.profile.specializations.includes(spec.value)
      );
    }
  },
  mounted() {
    console.log('ExecutorProfileEdit mounted, route params:', this.$route.params);
    this.loadProfile();
  },
  methods: {
    filterAllowedSpecs(list) {
      const allowed = new Set(this.specializationOptions.map(s => s.value));
      if (!Array.isArray(list)) return [];
      return list.filter(v => allowed.has(v));
    },
    async loadProfile() {
      try {
        // Сначала загружаем из localStorage для быстрого отображения
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        this.profile = {
          name: user.name || '',
          surname: user.surname || '',
          email: user.email || '',
          specializations: this.filterAllowedSpecs(user.specializations ? (Array.isArray(user.specializations) ? user.specializations : JSON.parse(user.specializations)) : []),
          executor_description: user.executor_description || '',
          avatar: user.avatar || ''
        };
        
        // Затем загружаем актуальные данные с сервера
        try {
          const { data: userData } = await this.$axios.get('/user');
          
          // Обновляем профиль актуальными данными
          this.profile = {
            name: userData.name || this.profile.name,
            surname: userData.surname || this.profile.surname,
            email: userData.email || this.profile.email,
            specializations: this.filterAllowedSpecs(userData.specializations ? (Array.isArray(userData.specializations) ? userData.specializations : JSON.parse(userData.specializations)) : this.profile.specializations),
            executor_description: userData.executor_description || this.profile.executor_description,
            avatar: userData.avatar || this.profile.avatar
          };
          
          // Обновляем localStorage
          const updatedUser = { ...user, ...userData };
          localStorage.setItem('user', JSON.stringify(updatedUser));
          
          console.log('Профиль исполнителя загружен с сервера:', userData);
        } catch (apiError) {
          console.warn('Не удалось загрузить данные с сервера, используем localStorage:', apiError);
        }
      } catch (error) {
        console.error('Ошибка загрузки профиля:', error);
        this.profile.specializations = [];
      }
    },
    removeSpecialization(value) {
      this.profile.specializations = this.profile.specializations.filter(spec => spec !== value);
    },
    
    async saveProfile() {
      if (this.isLoading) return;
      
      try {
        this.isLoading = true;
        
        // Валидация на фронтенде
        if (!this.profile.name.trim()) {
          alert('Пожалуйста, введите имя');
          return;
        }
        if (!this.profile.surname.trim()) {
          alert('Пожалуйста, введите фамилию');
          return;
        }
        if (!this.profile.specializations || this.profile.specializations.length === 0) {
          alert('Пожалуйста, выберите хотя бы одну специализацию');
          return;
        }
        
        // Создаем данные для отправки, только заполненные поля
        const profileData = {};
        
        if (this.profile.name && this.profile.name.trim()) {
          profileData.name = this.profile.name.trim();
        }
        if (this.profile.surname && this.profile.surname.trim()) {
          profileData.surname = this.profile.surname.trim();
        }
        if (this.profile.specializations && this.profile.specializations.length > 0) {
          profileData.specializations = this.filterAllowedSpecs(this.profile.specializations);
        }
        if (this.profile.executor_description && this.profile.executor_description.trim()) {
          profileData.executor_description = this.profile.executor_description.trim();
        }
        if (this.profile.avatar) {
          profileData.avatar = this.profile.avatar;
        }
        
        const { data: result } = await this.$axios.post('/profile/update-executor', profileData)
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        const updatedUser = { 
          ...user, 
          ...this.profile,
          specializations: this.profile.specializations
        };
        localStorage.setItem('user', JSON.stringify(updatedUser));
        alert('Профиль успешно обновлен!');
        this.$router.go(-1);
      } catch (error) {
        console.error('Ошибка сохранения:', error);
        alert('Ошибка сохранения профиля. Проверьте подключение к интернету.');
      } finally {
        this.isLoading = false;
      }
    },
    
    getAvatarForExecutor() {
      // Пока возвращаем статичную аватарку для исполнителя
      console.log('getAvatarForExecutor called, performerAvatar:', performerAvatar);
      return performerAvatar || '/src/assets/performer.png';
    },
    
    onImageError(event) {
      console.error('Avatar image failed to load:', event);
      event.target.src = '/src/assets/performer.png';
    },
  }
}
</script>

<style scoped>
.profile-edit-bg {
  background: #071727;
  color: #fff;
  position: relative;
  z-index: 1;
}

.profile-edit-container {
  max-width: 800px;
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

.profile-edit-form {
  background: #0D1F31;
  border-radius: 24px;
  padding: 32px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.1);
}

.form-section {
  margin-bottom: 32px;
}

.section-title {
  font-size: 20px;
  font-weight: 700;
  margin-bottom: 20px;
  color: #fff;
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
.form-group textarea,
.form-group select {
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

.form-group input:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.form-select {
  cursor: pointer;
}

.form-select option {
  background: #16243a;
  color: #fff;
}

.specializations-container {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.specialization-options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 12px;
}

.specialization-option {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px;
  background: #16243a;
  border: 1px solid #22304a;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.specialization-option:hover {
  background: #1e2d3a;
  border-color: #2563eb;
}

.specialization-checkbox {
  width: 16px;
  height: 16px;
  accent-color: #2563eb;
}

.specialization-label {
  font-size: 14px;
  color: #fff;
  cursor: pointer;
}

.selected-specializations {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.selected-label {
  font-size: 14px;
  font-weight: 600;
  color: #bfc9da;
}

.specialization-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.specialization-tag {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  background: #2563eb;
  color: #fff;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 500;
}

.remove-spec-btn {
  background: none;
  border: none;
  color: #fff;
  font-size: 14px;
  font-weight: bold;
  cursor: pointer;
  padding: 0;
  width: 16px;
  height: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background 0.2s;
}

.remove-spec-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

.no-specializations {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 16px;
  background: #16243a;
  border: 1px dashed #22304a;
  border-radius: 8px;
  color: #bfc9da;
  font-size: 14px;
  font-weight: 500;
}

.no-spec-text {
  text-align: center;
}

.avatar-upload {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

.avatar-preview.static {
  cursor: default;
}

.avatar-preview {
  flex-shrink: 0;
}

.avatar-img {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid #22304a;
}

.avatar-hint-wrapper {
  display: flex;
  flex-direction: column;
  gap: 8px;
  text-align: center;
}

.avatar-hint {
  color: #bfc9da;
  font-size: 14px;
}

.avatar-hint.secondary {
  color: #9ca3af;
  font-size: 12px;
}

.upload-btn,
.remove-btn {
  padding: 8px 16px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: background 0.2s;
  text-align: center;
}

.upload-btn {
  background: #2563eb;
  color: #fff;
}

.upload-btn:hover {
  background: #1d4ed8;
}

.remove-btn {
  background: #dc2626;
  color: #fff;
}

.remove-btn:hover {
  background: #b91c1c;
}

.hidden {
  display: none;
}

.form-actions {
  display: flex;
  gap: 16px;
  justify-content: flex-end;
  margin-top: 32px;
  padding-top: 24px;
  border-top: 1px solid #22304a;
}

.btn-secondary,
.btn-primary {
  padding: 12px 24px;
  border-radius: 12px;
  border: none;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-secondary {
  background: #374151;
  color: #fff;
}

.btn-secondary:hover:not(:disabled) {
  background: #4b5563;
}

.btn-primary {
  background: #2563eb;
  color: #fff;
}

.btn-primary:hover:not(:disabled) {
  background: #1d4ed8;
}

.btn-secondary:disabled,
.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.form-hint {
  color: #9ca3af;
  font-size: 12px;
  font-style: italic;
  margin-top: 4px;
}

@media (max-width: 768px) {
  .avatar-upload {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .form-actions {
    flex-direction: column;
  }
}
</style> 