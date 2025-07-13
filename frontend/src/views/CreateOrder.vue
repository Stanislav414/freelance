<template>
  <div class="flex justify-center items-center min-h-screen bg-[#071727] text-white">
    <div class="w-full max-w-3xl bg-[#0D1F31] rounded-3xl p-8 shadow-lg relative">
      <button @click="closeModal" class="absolute top-4 right-4 text-gray-400 hover:text-white text-2xl">&times;</button>
      <!-- Прогресс-бар шагов -->
      <div class="flex items-center justify-center gap-4 mb-8">
        <div :class="['step-indicator', step === 1 ? 'active' : '']">1</div>
        <div class="h-1 w-12 bg-[#22304a] rounded"></div>
        <div :class="['step-indicator', step === 2 ? 'active' : '']">2</div>
      </div>
      <div class="flex items-center justify-center gap-8 mb-6 text-sm">
        <span :class="step === 1 ? 'font-bold text-white' : 'text-gray-400'">Выбор типа работы</span>
        <span :class="step === 2 ? 'font-bold text-white' : 'text-gray-400'">Характеристики заказа</span>
      </div>
      <div v-if="step === 1">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div v-for="type in workTypes" :key="type.id" @click="selectWorkType(type)"
               :class="['cursor-pointer flex bg-[#19223a] rounded-2xl overflow-hidden transition-shadow border-2',
                 selectedWorkType && selectedWorkType.id === type.id ? 'border-blue-500 ring-2 ring-blue-400' : 'border-transparent hover:border-blue-400']">
            <div class="flex items-center justify-center w-32 h-32 bg-[#2a3950]">
              <img :src="getWorkTypeIcon(type)" class="w-16 h-16 object-contain" alt="icon" />
            </div>
            <div class="flex-1 flex flex-col justify-between p-4">
              <div>
                <div class="font-bold text-lg mb-1">{{ type.name }}</div>
                <div class="text-sm mb-2">{{ type.description }}</div>
              </div>
              <div class="flex gap-4 mt-2">
                <div class="text-xs bg-[#22304a] rounded-xl px-3 py-1">{{ type.average_time || '—' }}<br>сред. время</div>
                <div class="text-xs bg-[#22304a] rounded-xl px-3 py-1">{{ type.average_price || '—' }}₽<br>сред. цена</div>
              </div>
            </div>
          </div>
        </div>
        <div v-if="errors.work_type_id" class="text-red-400 mt-2">{{ errors.work_type_id }}</div>
      </div>
      <form v-else @submit.prevent="submitOrder" class="flex flex-col gap-6 mt-2">
        <label class="block mb-2 font-semibold">О заказе</label>
        <textarea v-model="form.description" rows="3" class="w-full p-3 rounded-xl bg-[#071727] text-white mb-1" placeholder="Опишите задачу, детали, пожелания..."></textarea>
        <div v-if="errors.description" class="text-red-400 mb-2">{{ errors.description }}</div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block mb-2 font-semibold">Тип ролика</label>
            <select v-model="form.type" class="w-full p-3 rounded-xl bg-[#071727] text-white">
              <option disabled value="">Выберите тип</option>
              <option>Рекламный</option>
              <option>Блог</option>
              <option>Презентация</option>
              <option>Обзор</option>
              <option>Другое</option>
            </select>
            <div v-if="errors.type" class="text-red-400">{{ errors.type }}</div>
          </div>
          <div>
            <label class="block mb-2 font-semibold">Цель</label>
            <select v-model="form.goal" class="w-full p-3 rounded-xl bg-[#071727] text-white">
              <option disabled value="">Выберите цель</option>
              <option>Презентация товара</option>
              <option>Продвижение</option>
              <option>Обучение</option>
              <option>Развлечение</option>
              <option>Другое</option>
            </select>
            <div v-if="errors.goal" class="text-red-400">{{ errors.goal }}</div>
          </div>
          <div>
            <label class="block mb-2 font-semibold">Платформа</label>
            <select v-model="form.platform" class="w-full p-3 rounded-xl bg-[#071727] text-white">
              <option disabled value="">Выберите платформу</option>
              <option>Instagram</option>
              <option>TikTok</option>
              <option>YouTube</option>
              <option>VK</option>
              <option>Другое</option>
            </select>
            <div v-if="errors.platform" class="text-red-400">{{ errors.platform }}</div>
          </div>
          <div>
            <label class="block mb-2 font-semibold">Формат</label>
            <select v-model="form.format" class="w-full p-3 rounded-xl bg-[#071727] text-white">
              <option disabled value="">Выберите формат</option>
              <option v-if="form.type === 'Рекламный' || form.type === 'Блог' || form.type === 'Презентация' || form.type === 'Обзор'">1080p (Full HD)</option>
              <option v-if="form.type === 'Рекламный' || form.type === 'Блог' || form.type === 'Презентация' || form.type === 'Обзор'">4K</option>
              <option v-if="form.type === 'Рекламный' || form.type === 'Блог' || form.type === 'Презентация' || form.type === 'Обзор'">720p</option>
              <option v-if="form.type === 'Другое'">JPEG</option>
              <option v-if="form.type === 'Другое'">PNG</option>
              <option v-if="form.type === 'Другое'">WEBP</option>
            </select>
            <div v-if="errors.format" class="text-red-400">{{ errors.format }}</div>
          </div>
          <div>
            <label class="block mb-2 font-semibold">Звук</label>
            <select v-model="form.sound" class="w-full p-3 rounded-xl bg-[#071727] text-white">
              <option disabled value="">Выберите звук</option>
              <option>Фоновая музыка</option>
              <option>Без звука</option>
              <option>Оригинальный звук</option>
            </select>
            <div v-if="errors.sound" class="text-red-400">{{ errors.sound }}</div>
          </div>
          <div>
            <label class="block mb-2 font-semibold">Срок выполнения</label>
            <input type="date" v-model="form.deadline" class="w-full p-3 rounded-xl bg-[#071727] text-white" />
            <div v-if="errors.deadline" class="text-red-400">{{ errors.deadline }}</div>
          </div>
          <div>
            <label class="block mb-2 font-semibold">Стоимость (₽)</label>
            <input type="number" v-model="form.budget" min="0" class="w-full p-3 rounded-xl bg-[#071727] text-white" />
            <div v-if="errors.budget" class="text-red-400">{{ errors.budget }}</div>
          </div>
        </div>
        <!-- Исходные материалы и пожелания оставляем -->
        <div>
          <label class="block mb-2 font-semibold">Исходные материалы</label>
          <div v-for="(mat, idx) in form.materials" :key="idx" class="flex gap-2 mb-2">
            <input v-model="mat.type" placeholder="Тип (например, Видео, Логотип)" class="flex-1 p-2 rounded-xl bg-[#071727] text-white" />
            <input v-model="mat.description" placeholder="Описание" class="flex-1 p-2 rounded-xl bg-[#071727] text-white" />
            <input v-model="mat.file_url" placeholder="Ссылка" class="flex-1 p-2 rounded-xl bg-[#071727] text-white" />
            <button type="button" @click="removeMaterial(idx)" class="text-red-400">&times;</button>
          </div>
          <button type="button" @click="addMaterial" class="mt-2 text-blue-400 hover:underline">+ Добавить материал</button>
        </div>
        <div>
          <label class="block mb-2 font-semibold">Дополнительные пожелания</label>
          <div class="flex flex-wrap gap-4">
            <label v-for="wish in wishesList" :key="wish.value" class="flex items-center gap-2">
              <input type="checkbox" v-model="form.wishes" :value="wish.value" />
              <span>{{ wish.label }}</span>
            </label>
          </div>
        </div>
        <div class="flex gap-4 justify-end mt-4">
          <button type="button" @click="step = 1" class="px-6 py-3 rounded-3xl bg-gray-600 hover:bg-gray-700">Назад</button>
          <button type="submit" :disabled="loading" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold px-6 py-3 rounded-3xl transition-colors">
            {{ loading ? 'Создание...' : 'Создать заказ' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CreateOrder',
  data() {
    return {
      step: 1,
      workTypes: [],
      attributeTypes: [],
      wishesList: [
        { value: 'subtitles', label: 'Субтитры' },
        { value: 'sound_fx', label: 'Звуковые эффекты' },
        { value: 'animation', label: 'Анимация' },
        { value: 'vfx', label: 'Спецэффекты' },
        { value: '3d', label: '3D элементы' },
      ],
      selectedWorkType: null,
      form: {
        work_type_id: '',
        title: '',
        attributes: {},
        description: '',
        deadline: '',
        budget: '',
        materials: [],
        wishes: [],
      },
      errors: {},
      loading: false,
    }
  },
  mounted() {
    this.fetchWorkTypes();
    this.fetchAttributeTypes();
  },
  methods: {
    closeModal() {
      this.resetForm();
      this.$emit('close');
    },
    resetForm() {
      this.step = 1;
      this.selectedWorkType = null;
      this.form = {
        work_type_id: '',
        title: '',
        attributes: {},
        description: '',
        deadline: '',
        budget: '',
        materials: [],
        wishes: [],
      };
      this.errors = {};
      this.loading = false;
    },
    async fetchWorkTypes() {
      const res = await fetch('/api/work-types');
      this.workTypes = await res.json();
    },
    async fetchAttributeTypes() {
      const res = await fetch('/api/order-attribute-types');
      this.attributeTypes = await res.json();
    },
    selectWorkType(type) {
      this.selectedWorkType = type;
      this.form.work_type_id = type.id;
      if (type.is_custom) {
        this.form.title = '';
        this.form.description = '';
      } else {
        this.form.title = type.name;
        this.form.description = type.description;
      }
      this.errors = {};
      this.step = 2;
    },
    getWorkTypeIcon(type) {
      if (!type) return '';
      const name = type.name ? type.name.toLowerCase() : '';
      if (name.includes('фото')) return new URL('@/assets/customer.png', import.meta.url).href;
      if (name.includes('сторис')) return new URL('@/assets/cards2.png', import.meta.url).href;
      if (name.includes('30')) return new URL('@/assets/cards.png', import.meta.url).href;
      if (name.includes('1 минут')) return new URL('@/assets/performer_cards.png', import.meta.url).href;
      if (name.includes('2 минут')) return new URL('@/assets/orders.png', import.meta.url).href;
      if (type.is_custom) return new URL('@/assets/performer.png', import.meta.url).href;
      return new URL('@/assets/orders.png', import.meta.url).href;
    },
    addMaterial() {
      this.form.materials.push({ type: '', description: '', file_url: '' });
    },
    removeMaterial(idx) {
      this.form.materials.splice(idx, 1);
    },
    validateForm() {
      const errors = {};
      if (!this.form.work_type_id) errors.work_type_id = 'Выберите тип работы';
      if (this.selectedWorkType && this.selectedWorkType.is_custom) {
        if (!this.form.title) errors.title = 'Введите название заказа';
        if (!this.form.description) errors.description = 'Введите описание заказа';
      } else {
        if (!this.form.description) errors.description = 'Введите описание заказа';
      }
      for (const attrType of this.attributeTypes) {
        if (!this.form.attributes[attrType.id]) {
          errors['attr_' + attrType.id] = `Выберите ${attrType.label.toLowerCase()}`;
        }
      }
      if (!this.form.deadline) errors.deadline = 'Укажите срок выполнения';
      if (!this.form.budget) errors.budget = 'Укажите бюджет';
      return errors;
    },
    async submitOrder() {
      this.errors = this.validateForm();
      if (Object.keys(this.errors).length > 0) return;
      this.loading = true;
      try {
        const token = localStorage.getItem('token');
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        const attributes = Object.entries(this.form.attributes).map(([attribute_type_id, value_id]) => ({ attribute_type_id, value_id }));
        const materials = this.form.materials.filter(m => m.type || m.description || m.file_url);
        const wishes = this.form.wishes.map(w => ({ type: 'wish', description: w }));
        const body = {
          user_id: user.id,
          work_type_id: this.form.work_type_id,
          title: this.form.title || (this.selectedWorkType ? this.selectedWorkType.name : 'Без названия'),
          description: this.form.description,
          deadline: this.form.deadline,
          budget: this.form.budget,
          type: this.form.type,
          goal: this.form.goal,
          platform: this.form.platform,
          format: this.form.format,
          orientation: this.form.orientation,
          sound: this.form.sound,
          attributes,
          materials: [...materials, ...wishes],
        };
        const res = await fetch('/api/orders', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            ...(token ? { 'Authorization': 'Bearer ' + token } : {})
          },
          body: JSON.stringify(body)
        });
        if (!res.ok) throw new Error('Ошибка создания заказа');
        this.resetForm();
        this.$emit('order-created');
      } catch (e) {
        alert(e.message || 'Ошибка создания заказа');
      } finally {
        this.loading = false;
      }
    }
  }
}
</script>

<style scoped>
.step-indicator {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 50%;
  background: #22304a;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 1.2rem;
  border: 2px solid #22304a;
  transition: background 0.2s, border 0.2s;
}
.step-indicator.active {
  background: #2563eb;
  border-color: #2563eb;
  color: #fff;
}
</style> 