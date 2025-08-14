import { createRouter, createWebHistory } from 'vue-router'
import Login from './views/Login.vue'
import Register from './views/Register.vue'
import Dashboard from './views/Dashboard.vue'
import Recover from './views/Recover.vue'
import CreateOrder from './views/CreateOrder.vue'
import CustomerProfile from './views/CustomerProfile.vue'
import CustomerProfileEdit from './views/CustomerProfileEdit.vue'
import ExecutorProfile from './views/ExecutorProfile.vue'
import Portfolio from './views/Portfolio.vue'
import Profile from './views/Profile.vue'
import ExecutorProfileEdit from './views/ExecutorProfileEdit.vue'
import Settings from './views/Settings.vue'

const routes = [
    { path: '/login', component: Login, meta: { guest: true } },
    { path: '/register', component: Register, meta: { guest: true } },
    { path: '/dashboard', component: Dashboard, meta: { requiresAuth: true } },
    { path: '/recover', component: Recover, meta: { guest: true } },
    { path: '/orders/create', component: CreateOrder, meta: { requiresAuth: true } },
    { path: '/', component: () => import('./views/Start.vue') },
    { path: '/profile/customer', component: CustomerProfile, meta: { requiresAuth: true } },
    { path: '/profile/executor/:id', component: ExecutorProfile, meta: { requiresAuth: true } },
    { path: '/profile/executor/:id/edit', component: ExecutorProfileEdit, meta: { requiresAuth: true } },
    { path: '/profile/customer/:id', component: CustomerProfile, meta: { requiresAuth: true } },
    { path: '/profile/customer/:id/edit', component: CustomerProfileEdit, meta: { requiresAuth: true } },
    { path: '/portfolio/:id', component: Portfolio },
    { path: '/profile', component: Profile, meta: { requiresAuth: true } },
    { path: '/settings', component: Settings, meta: { requiresAuth: true } },
    {
        path: '/profile-old',
        redirect: () => {
            const role = localStorage.getItem('role')
            if (role === 'customer') return '/profile/customer'
            if (role === 'executor') return '/profile/executor'
            return '/dashboard'
        }
    },
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