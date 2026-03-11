import { createRouter, createWebHistory } from 'vue-router'
import TopPage from '@/views/TopPage.vue'
import EventCreate from '@/views/EventCreate.vue'
import EventShow from '@/views/EventShow.vue'
const routes = [
  {
    path: '/',
    name: 'TopPage',
    component: TopPage,
  },
  {
    path: '/new',
    name: 'EventCreate',
    component: EventCreate,
  },
  {
    path: '/events/:url_token',
    name: 'EventShow',
    component: EventShow,
  },
]

const router = createRouter({
  history: createWebHistory(),
  routes,

  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    }
    return { top: 0, behavior: 'smooth' }
  },
})

export default router
