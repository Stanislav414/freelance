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
      <h1 class="text-4xl font-sans font-semibold mb-4">Войдите в аккаунт</h1>
      <p class="text-gray-400 mt-2 mb-6 text-center text-sm">
        Если у вас уже есть аккаунт, войдите в него и продолжите работу
      </p>

      <form @submit.prevent="login" class="space-y-4 w-full max-w-sm">
        <input
            class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100"
            v-model="email"
            type="email"
            placeholder="Почта"
            required />
        <div class="relative">
          <input
              class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100 pr-36"
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
            <router-link to="/recover" class="bg-gray-700 text-gray-200 text-xs px-3 py-2 rounded-md hover:bg-gray-600 transition">Забыли пароль?</router-link>
          </div>
        </div>
        <button type="submit" class="w-full p-3 rounded-[10px] bg-blue-500 hover:bg-blue-600 text-white font-sans transition">
          Войти
        </button>
        <div v-if="success" class="text-green-500 text-sm mt-2 text-center">Успешно</div>
        <div v-if="error" class="text-red-500 text-sm mt-2 text-center">Неверные данные</div>
      </form>

      <p class="text-gray-400 mt-4 text-sm">
        У вас нет аккаунта?
        <router-link to="/register" class="text-blue-500 hover:underline">Зарегистрируйтесь</router-link>
      </p>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      password: '',
      error: '',
      loading: false,
      success: false,
      showPassword: false
    }
  },
  methods: {
    async login() {
      this.error = ''
      this.loading = true
      this.success = false
      
      try {
        const res = await this.$axios.post('/login', {
          email: this.email,
          password: this.password
        })
        
        localStorage.setItem('token', res.data.token)
        localStorage.setItem('user', JSON.stringify(res.data.user))
        localStorage.setItem('role', res.data.user.role)
        this.success = true
        // Показать модалку о тестовом режиме после авторизации
        localStorage.setItem('showTestNotice', '1')
        setTimeout(() => {
          this.$router.push('/dashboard')
        }, 700)
      } catch (e) {
        this.error = true
      } finally {
        this.loading = false
      }
    },
    togglePasswordVisibility() {
      this.showPassword = !this.showPassword
    }
  }
}
</script>