<template>
  
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
          <div v-for="field in dynamicFields" :key="field.id">
            <label class="block mb-2 font-semibold">{{ field.label }}</label>
            <select v-if="field.values && field.values.length" v-model="form.attributes[field.id]" class="w-full p-3 rounded-xl bg-[#071727] text-white">
              <option disabled value="">Выберите {{ field.label.toLowerCase() }}</option>
              <option v-for="val in field.values" :key="val.id" :value="val.id">{{ val.label }}</option>
            </select>
            <input v-else v-model="form.attributes[field.id]" class="w-full p-3 rounded-xl bg-[#071727] text-white" :placeholder="field.label" />
            <div v-if="errors['attr_' + field.id]" class="text-red-400">{{ errors['attr_' + field.id] }}</div>
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
  
</template>

<script>
export default {
  name: 'CreateOrder',
  data() {
    return {
      step: 1,
      workTypes: [],
      attributeTypes: [],
      dynamicFields: [], // новые динамические поля
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
      const res = await fetch('/api/work-types', {
        headers: { 'Accept': 'application/json' }
      });
      this.workTypes = await res.json();
    },
    async fetchDynamicFields(workTypeId) {
      const res = await fetch(`/api/work-types/${workTypeId}/attributes`, {
        headers: { 'Accept': 'application/json' }
      });
      this.dynamicFields = await res.json();
      // Сбросить значения атрибутов при смене типа заказа
      this.form.attributes = {};
    },
    selectWorkType(type) {
      this.selectedWorkType = type;
      this.form.work_type_id = type.id;
      this.form.title = type.name;
      this.form.description = type.description;
      this.errors = {};
      this.step = 2;
      this.fetchDynamicFields(type.id);
    },
    getWorkTypeIcon(type) {
      if (!type) return '';
      if (type.image) {
        try {
          return new URL(`../assets/${type.image}`, import.meta.url).href;
        } catch {
          return new URL('../assets/orders.png', import.meta.url).href;
        }
      }
      return new URL('../assets/orders.png', import.meta.url).href;
    },
    addMaterial() {
      this.form.materials.push({ type: '', description: '', file_url: '' });
    },
    removeMaterial(idx) {
      this.form.materials.splice(idx, 1);
    },
    async submitOrder() {
      this.errors = this.validateForm();
      if (Object.keys(this.errors).length > 0) return;
      this.loading = true;
      try {
        const token = localStorage.getItem('token');
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        // Собираем массив attributes с value_id для select и value для input
        const attributes = this.dynamicFields.map(field => {
          const value = this.form.attributes[field.id];
          if (field.values && field.values.length) {
            // select: value_id должен быть выбран
            return { attribute_type_id: field.id, value_id: value };
          } else {
            // input: value_id не нужен, можно добавить value (если потребуется на бэке)
            return { attribute_type_id: field.id, value: value };
          }
        });
        const materials = this.form.materials.filter(m => m.type || m.description || m.file_url);
        const wishes = this.form.wishes.map(w => ({ type: 'wish', description: w }));
        const body = {
          user_id: user.id,
          work_type_id: this.form.work_type_id,
          title: this.form.title || (this.selectedWorkType ? this.selectedWorkType.name : 'Без названия'),
          description: this.form.description,
          deadline: this.form.deadline,
          budget: this.form.budget,
          attributes,
          materials: [...materials, ...wishes],
        };
        const res = await fetch('/api/orders', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            ...(token ? { 'Authorization': 'Bearer ' + token } : {})
          },
          body: JSON.stringify(body)
        });
        if (!res.ok) {
          // Показываем ошибки валидации, если есть
          const err = await res.json();
          if (err.errors) this.errors = err.errors;
          throw new Error(err.message || 'Ошибка создания заказа');
        }
        this.resetForm();
        this.$emit('order-created');
      } catch (e) {
        alert(e.message || 'Ошибка создания заказа');
      } finally {
        this.loading = false;
      }
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
      for (const field of this.dynamicFields) {
        const value = this.form.attributes[field.id];
        if (field.required) {
          if (field.values && field.values.length) {
            if (!value) errors['attr_' + field.id] = `Выберите ${field.label.toLowerCase()}`;
          } else {
            if (!value) errors['attr_' + field.id] = `Заполните поле ${field.label.toLowerCase()}`;
          }
        }
      }
      if (!this.form.deadline) errors.deadline = 'Укажите срок выполнения';
      if (!this.form.budget) errors.budget = 'Укажите бюджет';
      return errors;
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