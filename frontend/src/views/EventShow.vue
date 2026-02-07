<script setup>
import {ref, computed, onMounted} from "vue"
import axios from "axios"
import { useRoute } from "vue-router";

import ShowHeader from '@/components/show/ShowHeader.vue'
import ShowUsers from '@/components/show/ShowUsers.vue'
import ShowTable from '@/components/show/ShowTable.vue'

const route = useRoute()
const event = ref(null)
const loading = ref(true)
const error = ref(null)

// 予定入力画面用
const showModal = ref(false)

onMounted(async () => {
  try {
    const token = route.params.url_token
    const response = await axios.get(`http://localhost:3000/api/v1/events/${token}`)
    event.value = response.data
    
    // ダミーデータ
    if (!event.value.users) {
      event.value.users = [
        { id: 1, name: '山田 太郎', comment: 'よろしくお願いします！' },
        { id: 2, name: '鈴木 花子', comment: '遅れるかもです' },
        { id: 3, name: '佐藤 次郎', comment: '' },
      ]
    }
    //　ここまで
    
  } catch (err) {
    console.error(err)
    error.value = 'イベントが見つかりませんでした。'
    
  } finally {
    loading.value = false
  }
})

const handleOpenModal = () => {
  console.log("モーダルを開く処理")
  showModal.value = true
}

</script>
<template>
  <div v-if="loading" class="fixed inset-0 flex flex-col items-center justify-center bg-white">
  
    <div class="flex gap-5 mb-4">
      <div class="flex gap-5">
        <div class="animate-spin h-8 w-8 bg-blue-300 rounded-xl"></div>
        <div class="animate-spin h-8 w-8 bg-blue-400 rounded-xl" style="animation-delay: 0.1s"></div>
        <div class="animate-spin h-8 w-8 bg-blue-500 rounded-xl" style="animation-delay: 0.2s"></div>
      </div>
    </div>

    <div class="text-gray-400 text-center text-2xl font-bold tracking-widest animate-pulse">
      イベント読み込み中.....
    </div>
  
  </div>
  
  <div v-else-if="error" class="fixed inset-0 flex flex-col items-center justify-center p-4 bg-white">
    <div class="text-blue-800 text-center text-3xl font-bold tracking-tight">
      {{ error }}
    </div>
  </div>
  
  <div v-else class="max-w-5xl mx-auto p-8">
    <ShowHeader 
      :event="event" 
      @open-modal="handleOpenModal" 
    />

    <ShowUsers
      :users="event.users"
    />

    <ShowTable
      :event="event"
    /> 
  </div>
</template>

<style></style>