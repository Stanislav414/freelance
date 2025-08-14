<template>
  <div>
    <Portfolio :user="user" />
  </div>
</template>

<script>
import Portfolio from './Portfolio.vue'

export default {
  name: 'ExecutorProfile',
  components: {
    Portfolio
  },
  data() {
    return {
      user: {}
    }
  },
  mounted() {
    this.user = JSON.parse(localStorage.getItem('user') || '{}');
  }
}
</script> 