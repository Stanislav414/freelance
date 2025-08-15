import { createApp } from 'vue'
import App from '../App.vue'
import router from './router'
import axios from 'axios'
import './styles.css'

// Базовый URL API берём из env, по умолчанию используем относительный '/api'
const apiBaseUrl = import.meta.env.VITE_API_BASE_URL || '/api'
axios.defaults.baseURL = apiBaseUrl
// Для Bearer-токена куки не нужны
axios.defaults.withCredentials = false

axios.interceptors.request.use(config => {
    const token = localStorage.getItem('token')
    if (token) {
        config.headers.Authorization = `Bearer ${token}`
    }
    
    // Добавляем информацию о текущей роли пользователя
    const role = localStorage.getItem('role')
    if (role) {
        config.headers['X-User-Role'] = role
    }
    
    return config
})

const app = createApp(App)
app.use(router)
app.config.globalProperties.$axios = axios
app.mount('#app')
