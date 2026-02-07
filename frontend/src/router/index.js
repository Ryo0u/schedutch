import { createRouter, createWebHistory } from 'vue-router'
import EventCreate from '../views/EventCreate.vue'
import EventShow from '../views/EventShow.vue'
const routes = [
  {
    path: '/',
    name: 'Home',
    component: EventCreate
  },
  {
    path: '/events/:url_token',
    name: 'EventShow',
    component: EventShow
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router