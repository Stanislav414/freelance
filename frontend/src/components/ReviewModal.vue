<template>
  <div class="modal-overlay" @click.self="$emit('close')">
    <div class="modal-content review-modal">
      <button class="close-btn" @click="$emit('close')">&times;</button>
      
      <div class="review-header">
        <h3 class="review-title">{{ reviewTitle }}</h3>
        <p class="review-subtitle">{{ reviewSubtitle }}</p>
      </div>

      <div class="rating-section">
        <label class="rating-label">Оценка:</label>
        <div class="stars-container">
          <button
            v-for="star in 5"
            :key="star"
            @click="rating = star"
            class="star-btn"
            :class="{ 'filled': star <= rating, 'hover': star <= hoverRating }"
            @mouseenter="hoverRating = star"
            @mouseleave="hoverRating = 0"
          >
            ★
          </button>
        </div>
        <div class="rating-text">{{ ratingText }}</div>
      </div>

      <div class="form-section">
        <label class="form-label">Ваш отзыв:</label>
        <textarea
          v-model="reviewText"
          placeholder="Расскажите о качестве работы, сроках выполнения и общем впечатлении..."
          class="review-textarea"
          rows="4"
          maxlength="1000"
        ></textarea>
        <div class="char-count">{{ reviewText.length }}/1000</div>
      </div>

      <div class="actions">
        <button @click="$emit('close')" class="btn btn-secondary">Отмена</button>
        <button 
          @click="submitReview" 
          :disabled="!canSubmit || submitting"
          class="btn btn-primary"
        >
          <span v-if="submitting">Отправка...</span>
          <span v-else>Отправить отзыв</span>
        </button>
      </div>

      <div v-if="error" class="error-message">{{ error }}</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ReviewModal',
  props: {
    order: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      rating: 0,
      hoverRating: 0,
      reviewText: '',
      submitting: false,
      error: ''
    }
  },
  computed: {
    canSubmit() {
      return this.rating > 0 && this.reviewText.trim().length >= 10;
    },
    ratingText() {
      const texts = {
        1: 'Очень плохо',
        2: 'Плохо',
        3: 'Удовлетворительно',
        4: 'Хорошо',
        5: 'Отлично'
      };
      return this.rating > 0 ? texts[this.rating] : 'Выберите оценку';
    },
    reviewSubtitle() {
      // Получаем текущего пользователя
      const user = JSON.parse(localStorage.getItem('user') || '{}');
      const currentUserId = user.id;
      
      // Определяем роль пользователя в этом заказе
      let userRole = 'unknown';
      let targetRole = 'unknown';
      
      if (this.order.user_id == currentUserId) {
        userRole = 'customer';
        targetRole = 'executor';
      } else if (this.order.executor_id == currentUserId) {
        userRole = 'executor';
        targetRole = 'customer';
      }
      
      if (this.order.status === 'completed') {
        if (userRole === 'customer') {
          return 'Заказ завершен. Вы можете оставить отзыв на исполнителя. Он появится у него в профиле.';
        } else if (userRole === 'executor') {
          return 'Заказ завершен. Вы можете оставить отзыв на заказчика. Он появится у него в профиле.';
        } else {
          return 'Заказ завершен. Вы можете оставить отзыв.';
        }
      } else if (this.order.status === 'cancelled') {
        if (userRole === 'customer') {
          return 'Заказ отменен. Вы можете оставить отзыв на исполнителя о причинах отмены.';
        } else if (userRole === 'executor') {
          return 'Заказ отменен. Вы можете оставить отзыв на заказчика о причинах отмены.';
        } else {
          return 'Заказ отменен. Вы можете оставить отзыв о том, почему заказ был отменен.';
        }
      } else {
        return 'Вы можете оставить отзыв о заказе.';
      }
    },
    
    // Добавляем вычисляемое свойство для заголовка
    reviewTitle() {
      const user = JSON.parse(localStorage.getItem('user') || '{}');
      const currentUserId = user.id;
      
      if (this.order.user_id == currentUserId) {
        return 'Отзыв на исполнителя';
      } else if (this.order.executor_id == currentUserId) {
        return 'Отзыв на заказчика';
      } else {
        return 'Оставить отзыв';
      }
    }
  },
  methods: {
    async submitReview() {
      if (!this.canSubmit) return;
      
      this.submitting = true;
      this.error = '';
      
      try {
        const { data } = await this.$axios.post('/reviews', {
          order_id: this.order.id,
          rating: this.rating,
          text: this.reviewText.trim()
        });
        
        this.$emit('review-submitted', data.review);
        this.$emit('close');
      } catch (error) {
        console.error('Ошибка отправки отзыва:', error);
        this.error = error.response?.data?.error || 'Не удалось отправить отзыв';
      } finally {
        this.submitting = false;
      }
    }
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  inset: 0;
  z-index: 1000;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.modal-content {
  background: #0D1F31;
  color: #fff;
  border-radius: 16px;
  width: 100%;
  max-width: 500px;
  padding: 24px;
  position: relative;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
}

.close-btn {
  position: absolute;
  top: 16px;
  right: 20px;
  background: none;
  border: none;
  color: #aab3c5;
  font-size: 24px;
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;
  transition: all 0.2s;
}

.close-btn:hover {
  background: #22304a;
  color: #fff;
}

.review-header {
  text-align: center;
  margin-bottom: 24px;
}

.review-title {
  font-size: 24px;
  font-weight: 700;
  margin: 0 0 8px;
  color: #fff;
}

.review-subtitle {
  color: #bfc9da;
  font-size: 14px;
  line-height: 1.5;
  margin: 0;
}

.rating-section {
  margin-bottom: 24px;
  text-align: center;
}

.rating-label {
  display: block;
  font-weight: 600;
  margin-bottom: 12px;
  color: #fff;
}

.stars-container {
  display: flex;
  justify-content: center;
  gap: 8px;
  margin-bottom: 8px;
}

.star-btn {
  background: none;
  border: none;
  font-size: 32px;
  color: #4a5568;
  cursor: pointer;
  transition: all 0.2s;
  padding: 4px;
  border-radius: 4px;
}

.star-btn:hover {
  transform: scale(1.1);
}

.star-btn.filled {
  color: #fbbf24;
}

.star-btn.hover {
  color: #fbbf24;
}

.rating-text {
  font-size: 14px;
  color: #bfc9da;
  font-weight: 500;
}

.form-section {
  margin-bottom: 24px;
}

.form-label {
  display: block;
  font-weight: 600;
  margin-bottom: 8px;
  color: #fff;
}

.review-textarea {
  width: 100%;
  background: #19223a;
  border: 2px solid #2a3950;
  color: #fff;
  border-radius: 12px;
  padding: 12px;
  font-size: 14px;
  resize: vertical;
  min-height: 100px;
  transition: border-color 0.2s;
}

.review-textarea:focus {
  outline: none;
  border-color: #3b82f6;
}

.char-count {
  text-align: right;
  font-size: 12px;
  color: #8aa0b8;
  margin-top: 4px;
}

.actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
}

.btn {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-primary {
  background: #3b82f6;
  color: #fff;
}

.btn-primary:hover:not(:disabled) {
  background: #2563eb;
}

.btn-secondary {
  background: #4b5563;
  color: #fff;
}

.btn-secondary:hover {
  background: #374151;
}

.error-message {
  margin-top: 16px;
  padding: 12px;
  background: #dc2626;
  color: #fff;
  border-radius: 8px;
  font-size: 14px;
  text-align: center;
}
</style>
