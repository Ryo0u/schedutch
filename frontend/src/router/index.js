import { createRouter, createWebHistory } from 'vue-router'
import EventCreate from '../components/EventCreate.vue'
import EventShow from '../components/EventShow.vue'
const routes = [
  {
    path: '/',
    name: 'Home',
    component: EventCreate
  },
  {
    path: '/events/:id',
    name: 'EventShow',
    component: EventShow
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router