<template>
    <div class="h-screen flex flex-col md:flex-row">
  
      <!-- Левая часть -->
      <div class="hidden md:flex w-1/2 bg-[#146AF1] flex-col justify-center p-4 md:p-8 text-white relative">
  
                <div class="text-center mt-2 mb-1">
          <h1 class="text-lg md:text-2xl lg:text-5xl font-bold leading-tight mb-1 md:mb-3 text-white drop-shadow-2xl">
            Когда дедлайн был "ещё вчера"
          </h1>
          <p class="text-xs md:text-base lg:text-xl leading-relaxed text-white drop-shadow-lg">
            Найдите дизайнера или монтажёра быстрее, чем приедет такси!
          </p>
        </div>

        <div class="mt-4 md:mt-10 mb-2 md:mb-6 flex justify-center items-center">
          <img
              src="@/assets/cards.png"
              alt="Карточки"
              class="w-2/3 md:w-4/5 h-auto"
          >
        </div>

        <div class="text-center mt-2 md:mt-6 mb-1">
          <h2 class="text-lg md:text-2xl lg:text-4xl font-bold text-white drop-shadow-2xl mb-1 md:mb-3">
            SuriTask — умная фриланс платформа
          </h2>
          <p class="text-xs md:text-sm lg:text-lg leading-relaxed text-white drop-shadow-lg max-w-xs md:max-w-sm lg:max-w-xl mx-auto">
            где заказчики мгновенно получают готовую подборку подходящих исполнителей, а фрилансеры «в онлайне» первыми берут горящие заказы.
          </p>
        </div>
      </div>
  
      <!-- Правая часть -->
      <div class="w-full md:w-1/2 bg-[#071727] text-gray-100 flex flex-col justify-center items-center p-4 md:p-8">
        <div class="text-center max-w-2xl mx-auto">
          <h1 class="text-xl md:text-2xl lg:text-5xl font-bold mb-2 md:mb-3 text-white drop-shadow-2xl leading-tight">
            Создать первый заказ — бесплатно
          </h1>
          <p class="text-gray-300 mb-4 md:mb-6 text-center text-sm md:text-base lg:text-xl leading-relaxed">
            Система сама найдет проверенных специалистов
          </p>

          <!-- Текстовый блок вместо карточек -->
          <div class="text-center mb-6 md:mb-8">
            <h3 class="text-xl md:text-2xl lg:text-4xl font-bold mb-2 md:mb-3 text-white drop-shadow-2xl">
              Просто укажите, что нужно:
            </h3>
            <div class="text-gray-200 text-center space-y-1 md:space-y-2 max-w-sm md:max-w-md mx-auto">
              <div class="flex items-center justify-center">
                <span class="text-blue-400 mr-2 md:mr-3 text-base md:text-lg">•</span>
                <span class="text-sm md:text-base lg:text-lg">дизайн презентации</span>
              </div>
              <div class="flex items-center justify-center">
                <span class="text-blue-400 mr-2 md:mr-3 text-base md:text-lg">•</span>
                <span class="text-sm md:text-base lg:text-lg">монтаж видео</span>
              </div>
              <div class="flex items-center justify-center">
                <span class="text-blue-400 mr-2 md:mr-3 text-base md:text-lg">•</span>
                <span class="text-sm md:text-base lg:text-lg">инфографика для МП</span>
              </div>
              <div class="flex items-center justify-center">
                <span class="text-blue-400 mr-2 md:mr-3 text-base md:text-lg">•</span>
                <span class="text-sm md:text-base lg:text-lg">ваша задача</span>
              </div>
            </div>
          </div>

          <button class="w-full max-w-sm md:max-w-md bg-blue-500 hover:bg-blue-600 text-white py-3 md:py-4 px-6 md:px-8 rounded-2xl font-bold text-base md:text-lg mb-4 md:mb-6 transition-all duration-200 transform hover:scale-105 shadow-lg hover:shadow-xl" @click="$router.push('/register')">
            Зарегистрироваться
          </button>
          <div class="text-gray-300 text-xs md:text-sm lg:text-base">
            У вас уже есть аккаунт?
            <router-link to="/login" class="text-blue-400 hover:text-blue-300 hover:underline font-medium transition-colors">Войдите</router-link>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  
     


<script>
// Убрали ненужные импорты изображений

export default {
  data() {
    return {
      // Убрали ненужные данные для карточек
    }
  },
  // Убрали ненужные методы
}
</script>

<style scoped>
/* Стили убраны, так как карточки больше не используются */
</style>
