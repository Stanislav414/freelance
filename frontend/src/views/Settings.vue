<template>
  <div class="settings-page min-h-screen bg-[#0A1428] text-white">
    <div class="container mx-auto px-6 py-8">
      <div class="max-w-6xl mx-auto">
        <!-- Мобильная навигация -->
        <BottomNav />
        <!-- Заголовок страницы -->
        <div class="mb-8">
          <div class="flex items-center gap-4 mb-4">
            <button @click="goBack" class="flex items-center gap-2 px-4 py-2 bg-[#19223a] hover:bg-[#22304a] rounded-xl text-white font-medium transition-colors">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
              </svg>
              Назад
            </button>
          </div>
          <h1 class="text-4xl font-bold mb-2">Настройки</h1>
          <p class="text-gray-400 text-lg">Управление настройками аккаунта</p>
        </div>

        <!-- Основной контент - двухколоночная структура -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <!-- Левая колонка - Профиль -->
          <div class="lg:col-span-1">
            <div class="bg-[#0D1F31] rounded-2xl p-6 sticky top-8">
              <!-- Профиль пользователя -->
                <div class="text-center mb-8">
                 <div class="w-24 h-24 mx-auto mb-4 bg-[#22304a] rounded-full flex items-center justify-center overflow-hidden">
                   <img v-if="user.avatar" :src="user.avatar" class="w-full h-full object-cover" alt="Аватар" />
                   <span v-else class="text-3xl">👤</span>
                 </div>
                 <h2 class="text-xl font-bold mb-2">{{ user.name }} {{ user.surname }}</h2>
                  <button @click="openEditModal" class="px-6 py-3 bg-blue-600 hover:bg-blue-700 rounded-xl text-sm font-medium transition-colors">
                  Редактировать
                </button>
              </div>

              <!-- Навигация по настройкам -->
              <div class="space-y-2">
                <div 
                  v-for="section in settingsSections" 
                  :key="section.id"
                  @click="activeSection = section.id"
                  class="flex items-center gap-3 p-3 rounded-xl cursor-pointer transition-colors"
                  :class="activeSection === section.id ? 'bg-[#22304a] text-blue-400' : 'hover:bg-[#19223a]'"
                >
                  <div class="w-8 h-8 bg-[#19223a] rounded-lg flex items-center justify-center">
                    <span class="text-sm">{{ section.icon }}</span>
                  </div>
                  <span class="font-medium">{{ section.title }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Правая колонка - Содержимое настроек -->
          <div class="lg:col-span-2">
            <!-- Секция "Общие" -->
            <div v-if="activeSection === 'general'" class="space-y-6">
              <h2 class="text-2xl font-bold">Общие</h2>
              <div class="bg-[#0D1F31] rounded-2xl p-6">
                <div class="space-y-4">
                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">🌐</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Язык интерфейса</h3>
                        <p class="text-sm text-gray-400">Выберите предпочитаемый язык</p>
                      </div>
                    </div>
                    <UnifiedSwitcher
                      v-model="settings.language"
                      type="dropdown"
                      :options="[
                        { value: 'ru', label: 'Русский' },
                        { value: 'en', label: 'English' }
                      ]"
                      @update:modelValue="saveSettings"
                    />
                  </div>

                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">🔔</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Уведомления</h3>
                        <p class="text-sm text-gray-400">Получать уведомления о заказах</p>
                      </div>
                    </div>
                    <UnifiedSwitcher
                      v-model="settings.enableNotifications"
                      type="toggle"
                      @update:modelValue="saveSettings"
                    />
                  </div>

                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">🌙</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Темная тема</h3>
                        <p class="text-sm text-gray-400">Использовать темную тему</p>
                      </div>
                    </div>
                    <UnifiedSwitcher
                      v-model="settings.darkTheme"
                      type="toggle"
                      @update:modelValue="applyThemeAndSave"
                    />
                  </div>

                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">👁️</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Скрытый профиль</h3>
                        <p class="text-sm text-gray-400">Скрыть профиль от других пользователей</p>
                      </div>
                    </div>
                    <UnifiedSwitcher
                      v-model="settings.hiddenProfile"
                      type="toggle"
                      @update:modelValue="saveSettings"
                    />
                  </div>
                </div>
              </div>
            </div>

            <!-- Секция "Безопасность" -->
            <div v-if="activeSection === 'security'" class="space-y-6">
              <h2 class="text-2xl font-bold">Безопасность</h2>
              <div class="bg-[#0D1F31] rounded-2xl p-6">
                <div class="space-y-4">
                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl cursor-pointer hover:bg-[#22304a] transition-colors">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">🔒</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Смена пароля</h3>
                        <p class="text-sm text-gray-400">Обновить пароль для входа в аккаунт</p>
                      </div>
                    </div>
                    <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                  </div>

                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl cursor-pointer hover:bg-[#22304a] transition-colors">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-orange-600 rounded-lg flex items-center justify-center">
                        <span class="text-sm">📊</span>
                      </div>
                      <div>
                        <h3 class="font-medium">История входа</h3>
                        <p class="text-sm text-gray-400">Без кода</p>
                      </div>
                    </div>
                    <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                  </div>

                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl cursor-pointer hover:bg-[#22304a] transition-colors">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">📱</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Устройства</h3>
                        <p class="text-sm text-gray-400">Управление подключенными устройствами</p>
                      </div>
                    </div>
                    <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                  </div>

                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl cursor-pointer hover:bg-[#22304a] transition-colors">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">🔐</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Конфиденциальность</h3>
                        <p class="text-sm text-gray-400">Настройки приватности</p>
                      </div>
                    </div>
                    <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                  </div>
                </div>
              </div>
            </div>

            <!-- Секция "Финансы и платежи" -->
            <div v-if="activeSection === 'finance'" class="space-y-6">
              <h2 class="text-2xl font-bold">Финансы и платежи</h2>
              <div class="bg-[#0D1F31] rounded-2xl p-6">
                <div class="space-y-4">
                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">💳</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Платежные системы</h3>
                        <p class="text-sm text-gray-400">Настройка способов оплаты</p>
                      </div>
                    </div>
                    <button class="px-3 py-2 text-sm bg-[#0D1F31] border border-[#22304a] rounded-lg opacity-60 cursor-not-allowed">Скоро</button>
                  </div>

                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl cursor-pointer hover:bg-[#22304a] transition-colors">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">📋</span>
                      </div>
                      <div>
                        <h3 class="font-medium">История транзакций</h3>
                        <p class="text-sm text-gray-400">Просмотр всех платежей</p>
                      </div>
                    </div>
                    <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                  </div>

                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">📧</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Почта для чеков и писем</h3>
                        <p class="text-sm text-gray-400">Email для получения документов</p>
                      </div>
                    </div>
                    <input type="email" v-model="settings.billingEmail" @change="saveSettings" placeholder="you@example.com" class="bg-[#0D1F31] border border-[#22304a] rounded-lg px-3 py-2 text-sm w-56" />
                  </div>
                </div>
              </div>
            </div>

            <!-- Секция "Работа с заказами" -->
            <div v-if="activeSection === 'orders'" class="space-y-6">
              <h2 class="text-2xl font-bold">Работа с заказами</h2>
              <div class="bg-[#0D1F31] rounded-2xl p-6">
                <div class="space-y-4">
                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">🔔</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Уведомления</h3>
                        <p class="text-sm text-gray-400">Получать уведомления о заказах</p>
                      </div>
                    </div>
                    <UnifiedSwitcher
                      v-model="settings.orderNotifications"
                      type="toggle"
                      @update:modelValue="saveSettings"
                    />
                  </div>

                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">📝</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Шаблоны сообщений</h3>
                        <p class="text-sm text-gray-400">Использовать готовые шаблоны</p>
                      </div>
                    </div>
                    <UnifiedSwitcher
                      v-model="settings.messageTemplates"
                      type="toggle"
                      @update:modelValue="saveSettings"
                    />
                  </div>

                  <div class="flex items-center justify-between p-4 bg-[#19223a] rounded-xl">
                    <div class="flex items-center gap-4">
                      <div class="w-10 h-10 bg-[#22304a] rounded-lg flex items-center justify-center">
                        <span class="text-sm">✅</span>
                      </div>
                      <div>
                        <h3 class="font-medium">Авт. прием предложений</h3>
                        <p class="text-sm text-gray-400">Автоматически принимать предложения</p>
                      </div>
                    </div>
                    <UnifiedSwitcher
                      v-model="settings.autoAcceptOffers"
                      type="toggle"
                      @update:modelValue="saveSettings"
                    />
                  </div>
                </div>
              </div>

              <!-- Кнопка удаления аккаунта -->
              <div class="mt-8">
                <button @click="deleteAccount" class="w-full p-4 bg-red-600 hover:bg-red-700 rounded-xl text-white font-medium transition-colors">
                  Удалить аккаунт
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Модальное окно редактирования профиля -->
  <div v-if="editModal.open" class="modal-overlay">
    <div class="modal-card">
      <h3 class="text-xl font-semibold text-white mb-4">Редактирование профиля</h3>
      <div class="space-y-4">
        <div>
          <label class="block text-sm text-gray-300 mb-1">Имя</label>
          <input v-model="editModal.name" class="w-full bg-[#071727] border border-[#22304a] rounded-lg px-3 py-2 text-white" placeholder="Введите имя" />
        </div>
        <div>
          <label class="block text-sm text-gray-300 mb-1">Фамилия</label>
          <input v-model="editModal.surname" class="w-full bg-[#071727] border border-[#22304a] rounded-lg px-3 py-2 text-white" placeholder="Введите фамилию" />
        </div>
      </div>
      <div class="modal-actions mt-6">
        <button @click="closeEditModal" class="px-4 py-2 bg-[#19223a] hover:bg-[#22304a] rounded-lg text-white">Отмена</button>
        <button @click="saveProfile" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 rounded-lg text-white">Сохранить</button>
      </div>
    </div>
  </div>
</template>

<script>
import BottomNav from '../components/BottomNav.vue';
import UnifiedSwitcher from '../components/UnifiedSwitcher.vue';

export default {
  name: 'Settings',
  components: {
    BottomNav,
    UnifiedSwitcher
  },
  data() {
    return {
      user: JSON.parse(localStorage.getItem('user') || '{}'),
      activeSection: 'general',
      editModal: {
        open: false,
        name: '',
        surname: ''
      },
      settings: {
        language: 'ru',
        enableNotifications: true,
        darkTheme: true,
        hiddenProfile: false,
        billingEmail: '',
        orderNotifications: true,
        messageTemplates: true,
        autoAcceptOffers: false
      },
      settingsSections: [
        {
          id: 'general',
          title: 'Общие',
          icon: '⚙️'
        },
        {
          id: 'security',
          title: 'Безопасность',
          icon: '🔒'
        },
        {
          id: 'finance',
          title: 'Финансы и платежи',
          icon: '💳'
        },
        {
          id: 'orders',
          title: 'Работа с заказами',
          icon: '📋'
        }
      ]
    }
  },
  mounted() {
    this.loadSettings();
  },
  methods: {
    // Методы для обработки настроек
    saveSettings() {
      try {
        localStorage.setItem('app_settings', JSON.stringify(this.settings));
      } catch (e) {
        console.error('Не удалось сохранить настройки', e);
      }
    },
    loadSettings() {
      try {
        const raw = localStorage.getItem('app_settings');
        if (raw) {
          const parsed = JSON.parse(raw);
          this.settings = { ...this.settings, ...parsed };
        }
      } catch (e) {
        console.warn('Некорректные данные настроек в localStorage');
      }
      this.applyTheme();
    },
    applyThemeAndSave() {
      this.applyTheme();
      this.saveSettings();
    },
    applyTheme() {
      const root = document.documentElement;
      if (this.settings.darkTheme) {
        root.classList.add('dark');
      } else {
        root.classList.remove('dark');
      }
    },
    openEditModal() {
      this.editModal.name = this.user.name || '';
      this.editModal.surname = this.user.surname || '';
      this.editModal.open = true;
    },
    closeEditModal() {
      this.editModal.open = false;
    },
    saveProfile() {
      const name = (this.editModal.name || '').trim();
      const surname = (this.editModal.surname || '').trim();
      if (!name) {
        alert('Введите имя');
        return;
      }
      // Обновим локально и в localStorage
      this.user = { ...this.user, name, surname };
      try {
        localStorage.setItem('user', JSON.stringify(this.user));
      } catch {}
      this.editModal.open = false;
    },
    
    deleteAccount() {
      if (confirm('Вы уверены, что хотите удалить аккаунт? Это действие нельзя отменить.')) {
        // Логика удаления аккаунта
        console.log('Deleting account...');
      }
    },
    
    goBack() {
      // Возвращаемся на предыдущую страницу или на дашборд
      if (window.history.length > 1) {
        this.$router.go(-1);
      } else {
        this.$router.push('/dashboard');
      }
    }
  }
}
</script>

<style scoped>
/* Модал редактирования профиля */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
}
.modal-card {
  background: #0D1F31;
  border: 1px solid #22304a;
  width: 100%;
  max-width: 420px;
  border-radius: 16px;
  padding: 20px;
}
.modal-actions {
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}
.settings-page {
  min-height: 100vh;
}

/* Адаптивность для мобильных устройств */
@media (max-width: 1024px) {
  .settings-page .grid {
    grid-template-columns: 1fr;
  }
  
  .settings-page .sticky {
    position: relative;
    top: 0;
  }
}



/* Анимации для hover эффектов */
.transition-colors {
  transition: all 0.2s ease-in-out;
}

/* Стили для иконок */
.icon-container {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 0.5rem;
  background-color: #22304a;
}

/* Стили для активной секции навигации */
.nav-item-active {
  background-color: #22304a;
  color: #3b82f6;
}

.nav-item-active .icon-container {
  background-color: #1e40af;
}
</style>