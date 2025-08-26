<template>
  <div class="h-screen flex flex-col md:flex-row">
    <!-- Левая часть -->
    <div class="hidden md:flex w-1/2 bg-[#146AF1] flex-col justify-center p-8 text-white relative">
      <div class="absolute top-1 left-1 p-4 flex gap-5 items-center">
        <h1 class="text-4xl font-sans font-semibold leading-none">SuriTask</h1>
        <div class="w-[193px] overflow-hidden">
          <p class="text-[13px] opacity-80 break-words leading-none">
            Умная фриланс платформа
          </p>
        </div>
      </div>
      <div class="mt-8 mb-4 flex justify-center items-center ">
        <img
            src="@/assets/cards.png"
            alt="Карточки"
            class="w-3/4 h-auto"
        >
      </div>
      <div class="text-center">
        <h2 class="text-3xl font-sans font-semibold mt-8">Когда дедлайн был "ещё вчера"</h2>
        <p class="opacity-80 mt-4 max-w-2xl mx-auto">
          Найдите дизайнера или монтажёра быстрее, чем приедет такси!
        </p>
      </div>
    </div>
    
    <!-- Правая часть -->
    <div class="w-full md:w-1/2 bg-[#071727] text-gray-100 flex flex-col justify-center items-center p-6">
      <!-- Шаг 1: Ввод email -->
      <div v-if="step === 1" class="w-full max-w-sm">
        <h1 class="text-4xl font-sans font-semibold mb-4 text-center">Восстановление пароля</h1>
        <p class="text-gray-400 mt-2 mb-6 text-center text-sm">
          Введите почту, указанную при регистрации
        </p>
        
        <form @submit.prevent="sendCode" class="space-y-4">
          <input
            class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100"
            v-model="email"
            type="email"
            placeholder="Почта"
            required 
          />
          <button 
            type="submit" 
            :disabled="loading"
            class="w-full p-3 rounded-[10px] bg-blue-500 hover:bg-blue-600 disabled:bg-gray-600 disabled:cursor-not-allowed text-white font-sans transition"
          >
            <span v-if="loading">Отправка...</span>
            <span v-else>Отправить код</span>
          </button>
        </form>
      </div>

      <!-- Шаг 2: Ввод кода -->
      <div v-if="step === 2" class="w-full max-w-sm">
        <h1 class="text-4xl font-sans font-semibold mb-4 text-center">Введите код</h1>
        <p class="text-gray-400 mt-2 mb-6 text-center text-sm">
          Код отправлен на {{ email }}
        </p>
        
        <form @submit.prevent="verifyCode" class="space-y-4">
          <div class="flex gap-2 justify-center">
            <input
              v-for="(digit, index) in 6"
              :key="index"
              v-model="code[index]"
              @input="handleCodeInput(index, $event)"
              @keydown="handleCodeKeydown(index, $event)"
              class="w-12 h-12 text-center text-xl font-bold rounded-lg border border-warmGray-100 bg-gray-900 text-warmGray-100 focus:outline-none focus:ring-2 focus:ring-warmGray-100"
              type="text"
              maxlength="1"
              required
            />
          </div>
          
          <button 
            type="submit" 
            :disabled="loading || code.join('').length !== 6"
            class="w-full p-3 rounded-[10px] bg-blue-500 hover:bg-blue-600 disabled:bg-gray-600 disabled:cursor-not-allowed text-white font-sans transition"
          >
            <span v-if="loading">Проверка...</span>
            <span v-else>Подтвердить код</span>
          </button>
          
          <button 
            type="button"
            @click="resendCode"
            :disabled="resendCooldown > 0"
            class="w-full p-2 text-blue-400 hover:text-blue-300 disabled:text-gray-600 text-sm"
          >
            <span v-if="resendCooldown > 0">Отправить повторно через {{ resendCooldown }}с</span>
            <span v-else>Отправить код повторно</span>
          </button>
        </form>
      </div>

      <!-- Шаг 3: Новый пароль -->
      <div v-if="step === 3" class="w-full max-w-sm">
        <h1 class="text-4xl font-sans font-semibold mb-4 text-center">Новый пароль</h1>
        <p class="text-gray-400 mt-2 mb-6 text-center text-sm">
          Придумайте новый надежный пароль
        </p>
        
        <form @submit.prevent="resetPassword" class="space-y-4">
          <div class="relative">
            <input
              class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100 pr-12"
              v-model="newPassword"
              :type="showPassword ? 'text' : 'password'"
              placeholder="Новый пароль"
              @input="validatePassword"
              required
            />
            <button 
              type="button"
              @click="togglePasswordVisibility"
              class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-300"
            >
              <svg v-if="showPassword" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.878 9.878L3 3m6.878 6.878L21 21"></path>
              </svg>
              <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
              </svg>
            </button>
          </div>

          <!-- Индикатор силы пароля -->
          <div v-if="newPassword" class="space-y-2">
            <div class="flex items-center justify-between text-sm">
              <span>Сила пароля:</span>
              <span :class="{
                'text-red-500': passwordStrength.color === 'red',
                'text-yellow-500': passwordStrength.color === 'yellow',
                'text-blue-500': passwordStrength.color === 'blue',
                'text-green-500': passwordStrength.color === 'green'
              }">{{ passwordStrength.text }}</span>
            </div>
            <div class="w-full bg-gray-700 rounded-full h-2">
              <div 
                class="h-2 rounded-full transition-all duration-300"
                :class="{
                  'bg-red-500': passwordStrength.color === 'red',
                  'bg-yellow-500': passwordStrength.color === 'yellow',
                  'bg-blue-500': passwordStrength.color === 'blue',
                  'bg-green-500': passwordStrength.color === 'green'
                }"
                :style="{ width: (passwordStrength.strength / 5) * 100 + '%' }"
              ></div>
            </div>
          </div>

          <!-- Ошибки валидации пароля -->
          <div v-if="passwordErrors.length > 0" class="space-y-1">
            <div 
              v-for="error in passwordErrors" 
              :key="error"
              class="text-red-400 text-sm flex items-center"
            >
              <svg class="w-4 h-4 mr-2 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>
              {{ error }}
            </div>
          </div>
          
          <input
            class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100"
            v-model="confirmPassword"
            type="password"
            placeholder="Подтвердите пароль"
            required
          />

          <!-- Проверка совпадения паролей -->
          <div v-if="confirmPassword && newPassword !== confirmPassword" class="text-red-400 text-sm flex items-center">
            <svg class="w-4 h-4 mr-2 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            Пароли не совпадают
          </div>
          
          <button 
            type="submit" 
            :disabled="loading || !isPasswordValid || newPassword !== confirmPassword"
            class="w-full p-3 rounded-[10px] bg-blue-500 hover:bg-blue-600 disabled:bg-gray-600 disabled:cursor-not-allowed text-white font-sans transition"
          >
            <span v-if="loading">Смена пароля...</span>
            <span v-else>Сменить пароль</span>
          </button>
        </form>
      </div>

      <!-- Сообщения -->
      <div v-if="message" class="text-green-500 text-sm mt-4 text-center">{{ message }}</div>
      <div v-if="error" class="text-red-500 text-sm mt-4 text-center">{{ error }}</div>
      
      <!-- Навигация -->
      <div class="mt-6 text-center">
        <button 
          v-if="step > 1" 
          @click="goBack" 
          class="text-blue-400 hover:text-blue-300 text-sm mr-4"
        >
          Назад
        </button>
        <router-link to="/login" class="text-blue-400 hover:text-blue-300 text-sm">
          Вернуться на страницу входа
        </router-link>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      step: 1,
      email: '',
      code: ['', '', '', '', '', ''],
      newPassword: '',
      confirmPassword: '',
      showPassword: false,
      loading: false,
      message: '',
      error: '',
      resendCooldown: 0,
      passwordErrors: [],
      passwordStrength: {
        text: '',
        color: '',
        strength: 0
      },
      isPasswordValid: false
    }
  },
  methods: {
    async sendCode() {
      this.loading = true
      this.message = ''
      this.error = ''
      
      try {
        await this.$axios.post('/password/send-code', { email: this.email })
        this.message = 'Код отправлен на ваш email'
        this.step = 2
        this.startResendCooldown()
      } catch (e) {
        this.error = e.response?.data?.message || 'Ошибка отправки кода'
      } finally {
        this.loading = false
      }
    },

    async verifyCode() {
      this.loading = true
      this.message = ''
      this.error = ''
      
      try {
        const codeString = this.code.join('')
        await this.$axios.post('/password/verify-code', { 
          email: this.email, 
          code: codeString 
        })
        this.step = 3
      } catch (e) {
        this.error = e.response?.data?.message || 'Неверный код'
        this.code = ['', '', '', '', '', '']
        // Остаемся на шаге 2, не переходим к шагу 3
      } finally {
        this.loading = false
      }
    },

    async resetPassword() {
      this.loading = true
      this.message = ''
      this.error = ''
      
      try {
        const codeString = this.code.join('')
        await this.$axios.post('/password/reset', {
          email: this.email,
          code: codeString,
          password: this.newPassword,
          password_confirmation: this.confirmPassword
        })
        
        this.message = 'Пароль успешно изменен! Перенаправление на страницу входа...'
        setTimeout(() => {
          this.$router.push('/login')
        }, 2000)
      } catch (e) {
        this.error = e.response?.data?.message || 'Ошибка смены пароля'
      } finally {
        this.loading = false
      }
    },

    handleCodeInput(index, event) {
      const value = event.target.value
      if (value && /^\d$/.test(value)) {
        this.code[index] = value
        if (index < 5) {
          this.$nextTick(() => {
            event.target.nextElementSibling?.focus()
          })
        }
      } else {
        this.code[index] = ''
      }
    },

    handleCodeKeydown(index, event) {
      if (event.key === 'Backspace' && !this.code[index] && index > 0) {
        this.code[index - 1] = ''
        this.$nextTick(() => {
          event.target.previousElementSibling?.focus()
        })
      }
    },

    async resendCode() {
      if (this.resendCooldown > 0) return
      
      this.loading = true
      this.error = ''
      
      try {
        await this.$axios.post('/password/send-code', { email: this.email })
        this.message = 'Код отправлен повторно'
        this.startResendCooldown()
      } catch (e) {
        this.error = e.response?.data?.message || 'Ошибка отправки кода'
      } finally {
        this.loading = false
      }
    },

    startResendCooldown() {
      this.resendCooldown = 60
      const timer = setInterval(() => {
        this.resendCooldown--
        if (this.resendCooldown <= 0) {
          clearInterval(timer)
        }
      }, 1000)
    },

    togglePasswordVisibility() {
      this.showPassword = !this.showPassword
    },

    goBack() {
      if (this.step > 1) {
        this.step--
        this.message = ''
        this.error = ''
      }
    },

    async validatePassword() {
      if (!this.newPassword) {
        this.passwordErrors = []
        this.passwordStrength = { text: '', color: '', strength: 0 }
        this.isPasswordValid = false
        return
      }

      try {
        const response = await this.$axios.post('/password/validate', {
          password: this.newPassword
        })
        
        this.passwordErrors = response.data.errors || []
        this.passwordStrength = {
          text: response.data.strengthText,
          color: response.data.strengthColor,
          strength: response.data.strength
        }
        this.isPasswordValid = response.data.valid
      } catch (e) {
        console.error('Ошибка валидации пароля:', e)
      }
    }
  }
}
</script> 