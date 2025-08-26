<template>
  <div class="h-screen flex flex-col md:flex-row">

    <!-- Левая часть -->
    <div class="hidden md:flex w-1/2 bg-[#146AF1] flex-col justify-center p-8 text-white relative">

      <div class="text-center mt-4 mb-1">
        <h1 class="text-2xl lg:text-4xl font-bold leading-tight mb-2 text-white drop-shadow-2xl">
          Когда дедлайн был "ещё вчера"
        </h1>
        <p class="text-sm lg:text-lg leading-relaxed text-white drop-shadow-lg">
          Найдите дизайнера или монтажёра быстрее, чем приедет такси!
        </p>
      </div>

      <div class="mt-8 mb-4 flex justify-center items-center ">
        <img
            src="@/assets/cards.png"
            alt="Карточки"
            class="w-3/4 h-auto"
        >
      </div>

      <div class="text-center mt-4 mb-1">
        <h2 class="text-xl lg:text-3xl font-bold mb-3 text-white drop-shadow-2xl">
          SuriTask — умная фриланс платформа
        </h2>
        <p class="text-xs lg:text-base leading-relaxed text-white drop-shadow-lg max-w-xs lg:max-w-xl mx-auto">
          где заказчики мгновенно получают готовую подборку подходящих исполнителей, а фрилансеры «в онлайне» первыми берут горящие заказы.
        </p>
      </div>
    </div>



    <!-- Правая часть -->
    <div class="w-full md:w-1/2 bg-[#071727] text-gray-100 flex flex-col justify-center items-center p-6">
      <h1 class="text-4xl font-sans font-semibold mb-4">Создайте аккаунт</h1>
      <p class="text-gray-400 mt-2 mb-6 text-center text-sm">
        Вы можете в любой момент изменить эти значения в настройках
      </p>

      <form @submit.prevent="register" class="space-y-4 w-full max-w-sm">
        <div class="flex gap-4">
          <input
              class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100"
              v-model="name"
              type="text"
              placeholder="Имя"
              required
          />
          <input
              class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100"
              v-model="surname"
              type="text"
              placeholder="Фамилия"
              required
          />
        </div>
        <input
            class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100"
            v-model="email"
            type="email"
            placeholder="Почта"
            required />
        <div v-if="emailError" class="text-red-500 text-sm mt-1">{{ emailError }}</div>
        <div class="relative">
          <input
              class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100 pr-20"
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="Пароль"
              required />
          <div class="absolute right-2 top-1/2 -translate-y-1/2 flex gap-1">
            <button 
              type="button"
              @click="togglePasswordVisibility"
              class="bg-gray-700 text-gray-200 text-xs px-2 py-1 rounded-md hover:bg-gray-600 transition"
              :title="showPassword ? 'Скрыть пароль' : 'Показать пароль'"
            >
              <svg v-if="showPassword" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.878 9.878L3 3m6.878 6.878L21 21"></path>
              </svg>
              <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
              </svg>
            </button>
            <button 
              type="button"
              @click="generatePassword"
              class="bg-blue-600 text-white text-xs px-2 py-1 rounded-md hover:bg-blue-700 transition"
              title="Сгенерировать пароль"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
              </svg>
            </button>
          </div>
        </div>
        <div class="relative">
          <input
              class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100 pr-12"
              v-model="password_confirmation"
              :type="showPasswordConfirmation ? 'text' : 'password'"
              placeholder="Подтвердите пароль"
              required />
          <div class="absolute right-2 top-1/2 -translate-y-1/2">
            <button 
              type="button"
              @click="togglePasswordConfirmationVisibility"
              class="bg-gray-700 text-gray-200 text-xs px-2 py-1 rounded-md hover:bg-gray-600 transition"
              :title="showPasswordConfirmation ? 'Скрыть пароль' : 'Показать пароль'"
            >
              <svg v-if="showPasswordConfirmation" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.878 9.878L3 3m6.878 6.878L21 21"></path>
              </svg>
              <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
              </svg>
            </button>
          </div>
        </div>
        <button type="submit" class="w-full p-3 rounded-[10px] bg-blue-500 hover:bg-blue-600 text-white font-sans transition">
          Зарегистрироваться
        </button>
      </form>
      <div v-if="error && !emailError" class="text-red-500 text-sm mt-2">{{ error }}</div>

      <p class="text-gray-400 mt-4 text-sm">
        У вас уже есть аккаунт?
        <router-link to="/login" class="text-blue-500 hover:underline">Войдите</router-link>
      </p>
    </div>

    <!-- Всплывающее окно для ошибки паролей -->
    <div v-if="showPasswordError" class="fixed inset-0 bg-[#071727]/70 backdrop-blur-md flex items-center justify-center z-50">
      <div class="bg-blue-900 rounded-lg p-6 max-w-sm mx-4">
        <div class="flex items-center mb-4">
          <div class="flex-shrink-0">
            <svg class="h-6 w-6 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
          </div>
          <div class="ml-3">
            <h3 class="text-lg font-medium text-white">Ошибка</h3>
          </div>
        </div>
        <div class="mt-2">
          <p class="text-sm text-gray-300">
            Пароли не совпадают. Пожалуйста, убедитесь, что пароль и его подтверждение одинаковые.
          </p>
        </div>
        <div class="mt-4">
          <button
            @click="closePasswordError"
            class="w-full inline-flex justify-center px-4 py-2 text-sm font-medium text-white bg-red-600 border border-transparent rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition"
          >
            Понятно
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      name: '',
      surname: '',
      email: '',
      password: '',
      password_confirmation: '',
      error: '',
      emailError: '',
      showPasswordError: false,
      showPassword: false,
      showPasswordConfirmation: false
    }
  },
  methods: {
    async register() {
      this.error = ''
      this.emailError = ''
      
      // Проверяем совпадение паролей
      if (this.password !== this.password_confirmation) {
        this.showPasswordError = true
        return
      }
      
      try {
        const res = await this.$axios.post('/register', {
          name: this.name,
          surname: this.surname,
          email: this.email,
          password: this.password,
          password_confirmation: this.password_confirmation,
        })
        localStorage.setItem('token', res.data.token)
        localStorage.setItem('user', JSON.stringify(res.data.user))
        // Показать модалку о тестовом режиме после регистрации
        localStorage.setItem('showTestNotice', '1')
        this.$router.push('/dashboard')
      } catch (e) {
        // Проверяем, есть ли ошибка email
        if (e.response && e.response.data && e.response.data.errors && e.response.data.errors.email) {
          this.emailError = 'Этот email уже используется'
        } else {
          this.error = e.response?.data?.message || 'Ошибка при регистрации'
        }
      }
    },
    closePasswordError() {
      this.showPasswordError = false
    },
    togglePasswordVisibility() {
      this.showPassword = !this.showPassword
    },
    togglePasswordConfirmationVisibility() {
      this.showPasswordConfirmation = !this.showPasswordConfirmation
    },
    generatePassword() {
      // Генерируем безопасный пароль: 12 символов с буквами, цифрами и символами
      const lowercase = 'abcdefghijklmnopqrstuvwxyz'
      const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      const numbers = '0123456789'
      const symbols = '!@#$%^&*()_+-=[]{}|;:,.<>?'
      
      let password = ''
      
      // Добавляем по одному символу каждого типа для гарантии
      password += lowercase[Math.floor(Math.random() * lowercase.length)]
      password += uppercase[Math.floor(Math.random() * uppercase.length)]
      password += numbers[Math.floor(Math.random() * numbers.length)]
      password += symbols[Math.floor(Math.random() * symbols.length)]
      
      // Добавляем остальные символы
      const allChars = lowercase + uppercase + numbers + symbols
      for (let i = 4; i < 12; i++) {
        password += allChars[Math.floor(Math.random() * allChars.length)]
      }
      
      // Перемешиваем символы
      password = password.split('').sort(() => Math.random() - 0.5).join('')
      
      this.password = password
      this.password_confirmation = password
      
      // Показываем пароли для удобства
      this.showPassword = true
      this.showPasswordConfirmation = true
    }
  }
}
</script>
