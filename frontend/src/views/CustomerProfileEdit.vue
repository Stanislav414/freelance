<template>
  <div class="edit-profile-bg min-h-screen w-full flex justify-center items-start py-8">
    <div class="edit-profile-container w-full max-w-[800px] flex flex-col gap-8">
      <!-- Header с кнопкой назад -->
      <div class="flex items-center gap-4">
        <button @click="goBack" class="back-btn">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M19 12H5M12 19l-7-7 7-7" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          Назад
        </button>
        <h1 class="text-2xl font-bold">Редактировать профиль</h1>
      </div>

      <!-- Форма редактирования -->
      <div class="edit-form-card">
        <form @submit.prevent="saveProfile" class="edit-form">
          <!-- Аватар -->
          <div class="avatar-section">
            <div class="avatar-preview static">
              <img 
                :src="getAvatarForCustomer()" 
                alt="Avatar" 
                class="avatar-image"
                @error="onImageError"
              />
            </div>
            <p class="avatar-hint">
              📷 Загрузка собственных аватарок будет доступна в ближайшем обновлении
            </p>
            <p class="avatar-hint secondary">
              Пока используется стандартная аватарка для заказчиков
            </p>
          </div>

          <!-- Основная информация -->
          <div class="form-section">
            <h3 class="section-title">Основная информация</h3>
            
            <div class="form-row">
              <div class="form-group">
                <label for="firstName">Имя *</label>
                <input 
                  id="firstName"
                  v-model="formData.name" 
                  type="text" 
                  placeholder="Введите имя"
                  required
                  class="form-input"
                />
              </div>
              
              <div class="form-group">
                <label for="lastName">Фамилия *</label>
                <input 
                  id="lastName"
                  v-model="formData.surname" 
                  type="text" 
                  placeholder="Введите фамилию"
                  required
                  class="form-input"
                />
              </div>
            </div>

            <div class="form-group">
              <label for="customer_description">О заказчике</label>
              <textarea 
                id="customer_description"
                v-model="formData.customer_description" 
                placeholder="Расскажите о своих предпочтениях в работе, опыте заказов, требованиях к исполнителям..."
                rows="4"
                class="form-textarea"
              ></textarea>
              <p class="form-hint">Это поможет исполнителям лучше понять ваши требования и предпочтения</p>
            </div>
          </div>

          <!-- Кнопки действий -->
          <div class="form-actions">
            <button type="button" @click="goBack" class="btn-secondary">
              Отмена
            </button>
            <button type="submit" class="btn-primary" :disabled="isSaving">
              <span v-if="isSaving" class="loading-spinner"></span>
              {{ isSaving ? 'Сохранение...' : 'Сохранить изменения' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import customerAvatar from '@/assets/customer.png';

export default {
  name: 'CustomerProfileEdit',
  data() {
    return {
      customer: {},
      formData: {
        name: '',
        surname: '',
        customer_description: ''
      },
      previewAvatar: null,
      selectedAvatar: null,
      isSaving: false
    }
  },
  mounted() {
    console.log('CustomerProfileEdit mounted, route params:', this.$route.params);
    this.fetchCustomerData();
  },
  methods: {
    async fetchCustomerData() {
      try {
        console.log('fetchCustomerData called');
        const customerId = this.$route.params.id;
        console.log('Customer ID from route:', customerId);
        
        // Сначала загружаем из localStorage для быстрого отображения
        const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
        if (currentUser.id == customerId) {
          this.formData = {
            name: currentUser.name || '',
            surname: currentUser.surname || '',
            customer_description: currentUser.customer_description || ''
          };
        }
        
        // Затем загружаем актуальные данные с сервера
        const { data: customer } = await this.$axios.get(`/users/${customerId}`);
        this.customer = customer;
        
        // Заполняем форму актуальными данными
        this.formData = {
          name: customer.name || '',
          surname: customer.surname || '',
          customer_description: customer.customer_description || ''
        };
        
        // Обновляем localStorage если это профиль текущего пользователя
        if (currentUser.id == customerId) {
          const updatedUser = { ...currentUser, ...customer };
          localStorage.setItem('user', JSON.stringify(updatedUser));
        }
        
        console.log('Данные профиля заказчика загружены:', customer);
      } catch (error) {
        console.error('Ошибка загрузки данных пользователя:', error);
        alert('Не удалось загрузить данные профиля');
      }
    },

    getAvatarForCustomer() {
      // Пока возвращаем статичную аватарку для заказчика
      console.log('getAvatarForCustomer called, customerAvatar:', customerAvatar);
      return customerAvatar || '/src/assets/customer.png';
    },
    
    onImageError(event) {
      console.error('Avatar image failed to load:', event);
      event.target.src = '/src/assets/customer.png';
    },

    async saveProfile() {
      if (this.isSaving) return;

      try {
        this.isSaving = true;

        const customerId = this.$route.params.id;
        
        // Создаем JSON данные для отправки, только заполненные поля
        const profileData = {};
        
        if (this.formData.name && this.formData.name.trim()) {
          profileData.name = this.formData.name.trim();
        }
        if (this.formData.surname && this.formData.surname.trim()) {
          profileData.surname = this.formData.surname.trim();
        }
        if (this.formData.customer_description && this.formData.customer_description.trim()) {
          profileData.customer_description = this.formData.customer_description.trim();
        }
        
        // Аватарки пока не поддерживаются - будут добавлены позже

        // Отладочная информация
        const token = localStorage.getItem('token');
        const currentUserInfo = JSON.parse(localStorage.getItem('user') || '{}');
        console.log('Sending profile update request:', {
          customerId,
          token: token ? 'present' : 'missing',
          tokenLength: token ? token.length : 0,
          currentUserId: currentUserInfo.id || 'null',
          currentUserName: currentUserInfo.name || 'null',
          profileData: profileData
        });
        
        // Отправляем запрос на обновление профиля заказчика
        const response = await this.$axios.post('/profile/update-customer', profileData);

        console.log('Profile update response:', response.data);

        // Обновляем данные в localStorage, если это профиль текущего пользователя
        const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
        if (currentUser.id == customerId) {
          currentUser.name = this.formData.name;
          currentUser.surname = this.formData.surname;
          currentUser.customer_description = this.formData.customer_description;
          if (this.previewAvatar) {
            currentUser.avatar = this.previewAvatar;
          }
          localStorage.setItem('user', JSON.stringify(currentUser));
        }

        alert('Профиль успешно обновлен!');
        this.goBack();
      } catch (error) {
        console.error('Ошибка сохранения профиля:', error);
        
        // Детальная информация об ошибке
        if (error.response) {
          console.error('Response data:', error.response.data);
          console.error('Response status:', error.response.status);
          console.error('Response headers:', error.response.headers);
          
          if (error.response.data && error.response.data.errors) {
            console.error('Validation errors:', error.response.data.errors);
            alert(`Ошибка валидации: ${JSON.stringify(error.response.data.errors)}`);
          } else {
            alert(`Ошибка: ${error.response.data.message || 'Не удалось сохранить профиль'}`);
          }
        } else if (error.request) {
          console.error('Request error:', error.request);
          alert('Ошибка сети. Проверьте подключение к интернету.');
        } else {
          console.error('Error message:', error.message);
          alert('Произошла ошибка при сохранении профиля.');
        }
      } finally {
        this.isSaving = false;
      }
    },

    goBack() {
      this.$router.go(-1);
    }
  }
}
</script>

<style scoped>
.edit-profile-bg {
  background: #071727;
  color: #fff;
  position: relative;
  z-index: 1;
}

.edit-profile-container {
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

.edit-form-card {
  background: #0D1F31;
  border-radius: 24px;
  padding: 32px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.1);
}

.edit-form {
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
}

.avatar-preview {
  position: relative;
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
  border: 4px solid #22304a;
  transition: border-color 0.2s;
}

.avatar-preview.static {
  cursor: default;
}

.avatar-preview.static:hover {
  border-color: #22304a;
}

.avatar-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.2s;
  color: #fff;
}

.avatar-preview:hover .avatar-overlay {
  opacity: 1;
}

.hidden-input {
  display: none;
}

.avatar-hint {
  color: #bfc9da;
  font-size: 14px;
  text-align: center;
}

.avatar-hint.secondary {
  color: #9ca3af;
  font-size: 12px;
  margin-top: -8px;
}

.form-section {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.section-title {
  font-size: 20px;
  font-weight: 600;
  color: #fff;
  margin-bottom: 8px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

@media (max-width: 640px) {
  .form-row {
    grid-template-columns: 1fr;
  }
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-weight: 500;
  color: #bfc9da;
  font-size: 14px;
}

.form-input, .form-textarea {
  background: #16243a;
  border: 1px solid #22304a;
  border-radius: 12px;
  padding: 12px 16px;
  color: #fff;
  font-size: 16px;
  transition: border-color 0.2s;
}

.form-input:focus, .form-textarea:focus {
  outline: none;
  border-color: #2563eb;
}

.form-textarea {
  resize: vertical;
  min-height: 100px;
}

.form-hint {
  color: #9ca3af;
  font-size: 12px;
  font-style: italic;
}

.form-actions {
  display: flex;
  gap: 16px;
  justify-content: flex-end;
  padding-top: 16px;
  border-top: 1px solid #22304a;
}

.btn-secondary, .btn-primary {
  padding: 12px 24px;
  border-radius: 12px;
  border: none;
  font-weight: 600;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 8px;
}

.btn-secondary {
  background: #374151;
  color: #bfc9da;
}

.btn-secondary:hover {
  background: #4b5563;
}

.btn-primary {
  background: #2563eb;
  color: #fff;
}

.btn-primary:hover:not(:disabled) {
  background: #1d4ed8;
}

.btn-primary:disabled {
  background: #6b7280;
  cursor: not-allowed;
}

.loading-spinner {
  width: 16px;
  height: 16px;
  border: 2px solid transparent;
  border-top: 2px solid #fff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Адаптивность */
@media (max-width: 768px) {
  .edit-profile-container {
    padding: 0 16px;
  }
  
  .edit-form-card {
    padding: 24px;
  }
  
  .form-actions {
    flex-direction: column;
  }
  
  .btn-secondary, .btn-primary {
    width: 100%;
    justify-content: center;
  }
}
</style>
