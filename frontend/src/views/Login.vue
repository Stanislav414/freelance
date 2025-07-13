<template>
  <div class="h-screen flex flex-col md:flex-row">

    <!-- Левая часть -->
    <div class="hidden md:flex w-1/2 bg-[#146AF1] flex-col justify-center p-8 text-white relative">

      <div class="absolute top-1 left-1 p-4 flex gap-5 items-center">
        <h1 class="text-4xl font-sans font-semibold leading-none">Название</h1>
        <div class="w-[193px] overflow-hidden">
          <p class="text-[13px] opacity-80 break-words leading-none">
            Биржа фриланса Кемеровского государственного университета
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
        <h2 class="text-3xl font-sans font-semibold mt-8">Твой доход — твои правила</h2>
        <p class="opacity-80 mt-4 max-w-2xl mx-auto">
          Студенты берут заказы от вуза и проверенных заказчиков, получают экспертные отзывы и строят портфолио. Заказчики — доступ к проверенным исполнителям из числа студентов. Гибкий график, первый опыт и доход без отрыва от учебы
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
              type="password"
              placeholder="Пароль"
              required />
          <router-link to="/recover" class="absolute right-2 top-1/2 -translate-y-1/2 bg-gray-700 text-gray-200 text-xs px-3 py-2 rounded-md hover:bg-gray-600 transition">Забыли пароль?</router-link>
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
      success: false
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
        this.success = true
        setTimeout(() => {
          this.$router.push('/dashboard')
        }, 700)
      } catch (e) {
        this.error = true
      } finally {
        this.loading = false
      }
    }
  }
}
</script>