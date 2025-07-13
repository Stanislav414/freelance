import { createRouter, createWebHistory } from 'vue-router'
import Login from './views/Login.vue'
import Register from './views/Register.vue'
import Dashboard from './views/Dashboard.vue'
import Recover from './views/Recover.vue'
import CreateOrder from './views/CreateOrder.vue'

const routes = [
    { path: '/login', component: Login, meta: { guest: true } },
    { path: '/register', component: Register, meta: { guest: true } },
    { path: '/dashboard', component: Dashboard, meta: { requiresAuth: true } },
    { path: '/recover', component: Recover, meta: { guest: true } },
    { path: '/orders/create', component: CreateOrder, meta: { requiresAuth: true } },
    { path: '/', component: () => import('./views/Start.vue') },
    { path: '/:pathMatch(.*)*', redirect: '/login' },
]

const router = createRouter({
    history: createWebHistory('/'),
    routes,
})

router.beforeEach((to, from, next) => {
    const token = localStorage.getItem('token')

    if (to.meta.requiresAuth && !token) {
        return next('/login')
    }
    if (to.meta.guest && token) {
        return next('/dashboard')
    }
    next()
})

export default router