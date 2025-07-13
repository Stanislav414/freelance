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
        <input
            class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100"
            v-model="password"
            type="password"
            placeholder="Пароль"
            required />
        <input
            class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100"
            v-model="password_confirmation"
            type="password"
            placeholder="Подтвердите пароль"
            required />
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
      showPasswordError: false
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
    }
  }
}
</script>
