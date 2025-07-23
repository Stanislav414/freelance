<template>
  <div class="relative">
    <div class="flex items-center gap-3 bg-[#0D1F31] rounded-4xl p-4 cursor-pointer min-w-0" @click="toggleDropdown">
      <img :src="user.avatar || defaultAvatar" class="w-12 h-12 rounded-full object-cover" alt="Аватар" />
      <span class="font-semibold text-base whitespace-nowrap">{{ user.name }} {{ user.surname }}</span>
      <svg :class="{'rotate-180': dropdownOpen}" class="ml-auto transition-transform" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></svg>
    </div>
    <div v-if="dropdownOpen" class="absolute left-0 mt-2 w-full bg-[#19223a] rounded-2xl shadow-lg z-10">
      <div class="p-3 text-center text-blue-400 hover:bg-[#146AF128] rounded-2xl cursor-pointer" @click="goToProfile">Профиль</div>
      <div class="border-t border-[#22304a] my-2"></div>
      <div class="p-3 text-center text-red-400 hover:bg-[#146AF128] rounded-2xl cursor-pointer" @click="logout">Выйти</div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    user: { type: Object, required: true },
    defaultAvatar: { type: String, default: '/default-avatar.png' }
  },
  data() {
    return {
      dropdownOpen: false
    }
  },
  methods: {
    toggleDropdown() {
      this.dropdownOpen = !this.dropdownOpen
    },
    goToProfile() {
      this.$router.push('/profile')
      this.dropdownOpen = false
    },
    logout() {
      this.$emit('logout')
      this.dropdownOpen = false
    },
    handleClickOutside(event) {
      if (!this.$el.contains(event.target)) {
        this.dropdownOpen = false
      }
    }
  },
  mounted() {
    document.addEventListener('click', this.handleClickOutside)
  },
  beforeDestroy() {
    document.removeEventListener('click', this.handleClickOutside)
  }
}
</script>

<style scoped>
.rotate-180 {
  transform: rotate(180deg);
}
</style> 