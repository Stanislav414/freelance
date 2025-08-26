<template>
  <div class="unified-switcher">
    <!-- Переключатель типа toggle (checkbox) -->
    <div v-if="type === 'toggle'" class="toggle-switcher">
      <label class="relative inline-flex items-center cursor-pointer">
        <input 
          type="checkbox" 
          class="sr-only peer" 
          :checked="modelValue" 
          @change="$emit('update:modelValue', $event.target.checked)"
        >
        <div class="w-11 h-6 bg-[#22304a] peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-[#3b82f6] hover:peer-checked:bg-[#2563eb]"></div>
      </label>
    </div>

    <!-- Переключатель типа segmented (кнопки) -->
    <div v-else-if="type === 'segmented'" class="segmented-switcher">
      <div class="flex items-center justify-between rounded-full p-1 bg-[#16243a] w-full">
        <button 
          v-for="option in options" 
          :key="option.value"
          :class="[
            'segmented-btn',
            modelValue === option.value ? 'active' : ''
          ]"
          @click="$emit('update:modelValue', option.value)"
        >
          {{ option.label }}
        </button>
      </div>
    </div>

    <!-- Переключатель типа dropdown (кастомный) -->
    <div v-else-if="type === 'dropdown'" class="dropdown-switcher">
      <div class="dropdown-container">
        <button 
          @click="toggleDropdown"
          @blur="closeDropdown"
          class="dropdown-button"
          :class="{ 'dropdown-open': isDropdownOpen }"
        >
          <span class="dropdown-text">{{ getCurrentOptionLabel() }}</span>
          <div class="dropdown-arrow" :class="{ 'rotate': isDropdownOpen }">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
            </svg>
          </div>
        </button>
        
        <!-- Кастомное выпадающее меню -->
        <div v-if="isDropdownOpen" class="dropdown-menu">
          <div 
            v-for="option in options" 
            :key="option.value"
            @mousedown="selectOption(option.value)"
            class="dropdown-option"
            :class="{ 'active': modelValue === option.value }"
          >
            {{ option.label }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UnifiedSwitcher',
  props: {
    modelValue: {
      type: [String, Boolean, Number],
      required: true
    },
    type: {
      type: String,
      default: 'toggle',
      validator: value => ['toggle', 'segmented', 'dropdown'].includes(value)
    },
    options: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      isDropdownOpen: false
    }
  },
  emits: ['update:modelValue'],
  methods: {
    toggleDropdown() {
      this.isDropdownOpen = !this.isDropdownOpen;
    },
    closeDropdown() {
      // Небольшая задержка для корректной работы клика
      setTimeout(() => {
        this.isDropdownOpen = false;
      }, 150);
    },
    selectOption(value) {
      this.$emit('update:modelValue', value);
      this.isDropdownOpen = false;
    },
    getCurrentOptionLabel() {
      const currentOption = this.options.find(option => option.value === this.modelValue);
      return currentOption ? currentOption.label : '';
    }
  }
}
</script>

<style scoped>
/* Стили для toggle переключателя */
.toggle-switcher {
  display: flex;
  align-items: center;
}

/* Стили для segmented переключателя */
.segmented-switcher {
  width: 100%;
}

.segmented-btn {
  flex: 1 1 0;
  background: transparent;
  border: none;
  color: #b0b8c1;
  font-weight: 600;
  font-size: 1.1rem;
  border-radius: 2rem;
  padding: 0.7rem 0;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
  margin: 0;
  min-width: 0;
}

.segmented-btn.active {
  background: #22304a;
  color: #fff;
  font-weight: 700;
  box-shadow: 0 2px 8px rgba(0,0,0,0.04);
}

.segmented-btn:hover:not(.active) {
  background: rgba(34, 48, 74, 0.3);
  color: #d1d5db;
}

/* Стили для dropdown переключателя */
.dropdown-switcher {
  position: relative;
}

.dropdown-container {
  position: relative;
  display: inline-block;
}

.dropdown-button {
  background: #16243a;
  border: 1px solid #22304a;
  border-radius: 12px;
  padding: 8px 12px;
  padding-right: 32px;
  color: #fff;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  min-width: 120px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  text-align: left;
  outline: none;
}

.dropdown-button:hover {
  border-color: #3b82f6;
  background: #22304a;
  box-shadow: 0 2px 8px rgba(59, 130, 246, 0.15);
}

.dropdown-button.dropdown-open {
  border-color: #3b82f6;
  background: #22304a;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
}

.dropdown-text {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.dropdown-arrow {
  color: #9ca3af;
  transition: all 0.3s ease;
  margin-left: 6px;
  flex-shrink: 0;
}

.dropdown-arrow.rotate {
  transform: rotate(180deg);
}

.dropdown-container:hover .dropdown-arrow {
  color: #3b82f6;
}

/* Кастомное выпадающее меню */
.dropdown-menu {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: #0D1F31;
  border: 1px solid #22304a;
  border-radius: 8px;
  margin-top: 2px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
  z-index: 1000;
  overflow: hidden;
  animation: dropdownSlide 0.2s ease-out;
}

.dropdown-option {
  padding: 8px 12px;
  color: #fff;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  border-bottom: 1px solid #22304a;
}

.dropdown-option:last-child {
  border-bottom: none;
}

.dropdown-option:hover {
  background: #22304a;
  color: #3b82f6;
}

.dropdown-option.active {
  background: #3b82f6;
  color: #fff;
  font-weight: 600;
}

.dropdown-option.active:hover {
  background: #2563eb;
  color: #fff;
}

/* Анимация появления меню */
@keyframes dropdownSlide {
  from {
    opacity: 0;
    transform: translateY(-4px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Адаптивные стили */
@media (max-width: 768px) {
  .segmented-btn {
    font-size: 1rem;
    padding: 0.6rem 0;
  }
  
  .dropdown-button {
    font-size: 13px;
    padding: 6px 10px;
    padding-right: 28px;
    min-width: 100px;
    border-radius: 10px;
  }
  
  .dropdown-arrow svg {
    width: 14px;
    height: 14px;
  }
  
  .dropdown-option {
    padding: 6px 10px;
    font-size: 13px;
  }
}

@media (max-width: 480px) {
  .dropdown-button {
    font-size: 12px;
    padding: 5px 8px;
    padding-right: 24px;
    min-width: 90px;
    border-radius: 8px;
  }
  
  .dropdown-arrow svg {
    width: 12px;
    height: 12px;
  }
  
  .dropdown-option {
    padding: 5px 8px;
    font-size: 12px;
  }
}
</style>
