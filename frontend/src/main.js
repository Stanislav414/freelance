import { createApp } from 'vue'
import App from '../App.vue'
import router from './router'
import axios from 'axios'
import './styles.css'

// Всегда используем полный URL для отладки

//axios.defaults.baseURL = 'http://127.0.0.1:8000/api'

axios.defaults.baseURL = 'https://3124dfbd3763.ngrok-free.app/api'
axios.defaults.withCredentials = true

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
