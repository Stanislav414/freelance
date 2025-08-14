<template>
  <div class="relative">
    <div class="flex items-center gap-2 bg-[#0D1F31] rounded-2xl p-2 cursor-pointer min-w-0 user-dropdown-trigger" @click="toggleDropdown">
      <img :src="userAvatar" class="w-10 h-10 rounded-full object-cover" alt="Аватар" />
      <span class="font-semibold text-[15px] whitespace-nowrap">{{ user.name }} {{ user.surname }}</span>
      <svg :class="{'rotate-180': dropdownOpen}" class="ml-auto transition-transform" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M6 9l6 6 6-6"/></svg>
    </div>
    <div v-if="dropdownOpen" class="absolute left-0 mt-1 w-full bg-[#19223a] rounded-xl shadow-lg z-10 user-dropdown-menu">
      <div class="dropdown-item text-blue-400" @click="goToProfile">Профиль</div>
      <div class="dropdown-item text-gray-300" @click="goToSettings">Настройки</div>
      <div class="border-t border-[#22304a] my-1"></div>
      <div class="dropdown-item text-red-400" @click="logout">Выйти</div>
    </div>
  </div>
</template>

<script>
import customerIcon from '@/assets/customer.png';
import performerIcon from '@/assets/performer.png';

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
  computed: {
    userAvatar() {
      // Пока используем только статичные аватарки по роли
      const role = localStorage.getItem('role') || 'customer';
      return role === 'customer' ? customerIcon : performerIcon;
    }
  },
  methods: {
    toggleDropdown() {
      this.dropdownOpen = !this.dropdownOpen
    },
    goToProfile() {
      const role = localStorage.getItem('role') || 'customer';
      if (role === 'executor') {
        this.$router.push('/profile/executor/' + this.user.id);
      } else {
        this.$router.push('/profile/customer/' + this.user.id);
      }
      this.dropdownOpen = false
    },
    goToSettings() {
      this.$router.push('/settings');
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
.user-dropdown-trigger {
  min-height: 44px;
  transition: background 0.15s;
}
.user-dropdown-trigger:hover {
  background: #16243a;
}
.user-dropdown-menu {
  min-width: 140px;
  padding: 4px 0;
}
.dropdown-item {
  padding: 8px 0;
  text-align: center;
  font-size: 15px;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.15s, color 0.15s;
}
.dropdown-item:hover {
  background: #22304a;
  color: #fff !important;
}
</style> 