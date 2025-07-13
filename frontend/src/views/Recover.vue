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
      <h1 class="text-4xl font-sans font-semibold mb-4">Восстановление пароля</h1>
      <p class="text-gray-400 mt-2 mb-6 text-center text-sm">
        Введите почту, указанную при регистрации
      </p>
      <form @submit.prevent="recover" class="space-y-4 w-full max-w-sm">
        <input
            class="w-full p-3 rounded-[10px] border border-warmGray-100 bg-gray-900 text-warmGray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-warmGray-100"
            v-model="email"
            type="email"
            placeholder="Почта"
            required />
        <button type="submit" class="w-full p-3 rounded-[10px] bg-blue-500 hover:bg-blue-600 text-white font-sans transition">
          Восстановить доступ
        </button>
        <div v-if="message" class="text-green-500 text-sm mt-2 text-center">{{ message }}</div>
        <div v-if="error" class="text-red-500 text-sm mt-2 text-center">{{ error }}</div>
        
        <router-link to="/login" class="block text-blue-500 text-sm mt-2 text-center">Вернуться на страницу входа</router-link>
      
      </form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      message: '',
      error: ''
    }
  },
  methods: {
    async recover() {
      this.message = ''
      this.error = ''
      try {
        // Здесь должен быть запрос к API восстановления пароля
        // await this.$axios.post('/password/email', { email: this.email })
        this.message = 'Если почта найдена, инструкция будет отправлена на email.'
      } catch (e) {
        this.error = e.response?.data?.message || 'Ошибка восстановления доступа'
      }
    }
  }
}
</script> 