<template>
  <div class="relative">
    <div class="flex items-center gap-3 bg-[#0D1F31] rounded-4xl p-4 cursor-pointer" @click="toggleDropdown">
      <img :src="user.avatar || defaultAvatar" class="w-12 h-12 rounded-full object-cover" alt="Аватар" />
      <div class="flex flex-col">
        <span class="font-semibold text-lg">{{ user.name }} {{ user.surname }}</span>
        <!-- убрано отображение роли и очков -->
      </div>
      <svg :class="{'rotate-180': dropdownOpen}" class="ml-auto transition-transform" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></svg>
    </div>
    <div v-if="dropdownOpen" class="absolute left-0 mt-2 w-full bg-[#19223a] rounded-2xl shadow-lg z-10">
      <div v-for="role in user.roles" :key="role.name" class="flex items-center gap-3 p-3 hover:bg-[#146AF128] rounded-2xl cursor-pointer">
        <img :src="role.avatar || defaultAvatar" class="w-10 h-10 rounded-full object-cover" alt="Аватар" />
        <div class="flex flex-col">
          <span class="font-semibold">{{ role.name }}</span>
          <span class="text-gray-400 text-xs">{{ role.role }}</span>
        </div>
        <span v-if="role.notifications" class="ml-auto bg-green-500 text-white text-xs rounded-full px-2 py-0.5">{{ role.notifications }}</span>
      </div>
      <div class="border-t border-[#22304a] my-2"></div>
      <div class="p-3 text-center text-blue-400 hover:underline cursor-pointer" @click="$emit('logout')">Выйти</div>
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
    }
  }
}
</script>

<style scoped>
.rotate-180 {
  transform: rotate(180deg);
}
</style> 