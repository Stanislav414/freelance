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
        <h1 class="text-4xl font-bold mb-4 text-white drop-shadow-lg">
          Создать первый заказ — бесплатно
        </h1>
        <p class="text-gray-400 mt-2 mb-6 text-center text-sm">
            Вы можете быть заказчиком и исполнителем одновременно
        </p>

        <!-- Карточки ролей слайдер с анимацией -->
        <div class="relative w-[340px] h-96 mb-4 flex flex-col items-center overflow-visible">
          <div class="absolute inset-0 flex items-center justify-center" style="perspective: 1200px;">
            <div
              v-for="(role, idx) in roles"
              :key="role.title"
              :style="getCardStyle(idx)"
              class="role-card w-80 h-96 rounded-3xl shadow-lg overflow-hidden flex flex-col justify-end transition-all duration-500 ease-in-out absolute cursor-pointer"
              @click="handleCardClick(idx)"
            >
              <!-- Размытый фон -->
              <img :src="role.bg" alt="Фон" class="absolute inset-0 w-full h-full object-cover blur-sm scale-110" />
              <!-- Затемнение -->
              <div class="absolute inset-0 bg-[#071727]/60"></div>
              <!-- Аватарка -->
              <img :src="role.avatar" alt="Аватарка" class="absolute left-6 top-40 w-16 h-16 rounded-full shadow-md object-cover z-10" />
              <!-- Контент -->
              <div class="relative z-10 p-6 pt-28">
                <div class="text-2xl font-bold mb-2">{{ role.title }}</div>
                <div class="text-base opacity-90 leading-snug">
                  {{ role.desc }}
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- Навигация (точки) -->
        <div class="flex justify-center gap-2 mb-8">
          <button
            v-for="(role, idx) in roles"
            :key="'dot-' + idx"
            @click="currentIndex = idx"
            :class="['w-3 h-3 rounded-full', currentIndex === idx ? 'bg-white' : 'bg-white/40']"
            style="transition: background 0.2s;"
            aria-label="Переключить роль"
          ></button>
        </div>

        <button class="w-full max-w-xs bg-blue-500 hover:bg-blue-600 text-white py-3 rounded-2xl font-bold mb-4" @click="$router.push('/register')">
          Зарегистрироваться
        </button>
      <div class="text-gray-400 text-sm">
        У вас уже есть аккаунт?
        <router-link to="/login" class="text-blue-500 hover:underline">Войдите</router-link>
      </div>
   
      </div>
    </div>
  </template>
  
  
     


<script>
import cards2 from '@/assets/cards2.png' // фон карточки
import performer_cards from '@/assets/performer_cards.png' // фон карточки
import customer from '@/assets/customer.png' // аватарка заказчика
import performer from '@/assets/performer.png' // аватарка исполнителя

export default {
  data() {
    return {
      roles: [
        {
          title: 'Заказчик',
          desc: 'Найдите талантливых исполнителей, принимайте быстрые и качественные заказы',
          bg: cards2,
          avatar: customer,
        },
        {
          title: 'Исполнитель',
          desc: 'Выполняйте интересные задания, получайте опыт, отзывы и пополняйте портфолио',
          bg: performer_cards,
          avatar: performer,
        },
      ],
      currentIndex: 0,
    }
  },
  methods: {
    getCardStyle(idx) {
      const offset = idx - this.currentIndex;
      const baseZ = 10 - Math.abs(offset);
      return {
        transform: `translateX(${offset * 40}px) scale(${offset === 0 ? 1 : 0.92})`,
        zIndex: baseZ,
        opacity: Math.abs(offset) > 1 ? 0 : 1,
        pointerEvents: Math.abs(offset) > 1 ? 'none' : 'auto',
        transition: 'transform 0.5s cubic-bezier(.4,2,.6,1), opacity 0.3s',
      };
    },
    handleCardClick(idx) {
      const offset = idx - this.currentIndex;
      if (offset < 0) {
        this.currentIndex = idx;
      } else if (offset > 0) {
        this.currentIndex = idx;
      } else if (offset === 0) {
        this.currentIndex = (this.currentIndex + 1) % this.roles.length;
      }
    },
  },
}
</script>

<style scoped>
/* Добавь стили для step, role-card, selected и т.д. */
.role-card {
  box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
  transition: transform 0.2s;
}
.role-card:hover {
  transform: translateY(-4px) scale(1.03);
}
</style>
