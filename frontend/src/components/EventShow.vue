<script setup>
import {ref, onMounted} from "vue"
import axios from "axios"
import { useRoute } from "vue-router";

const route = useRoute()
const event = ref(null)
const loading = ref(true)
const error = ref(null)

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
</script>
<template>
  <div v-if="loading" class="text-gray-400 text-center text-2xl py-20 font-bold tracking-widest animate-pulse">
      イベント読み込み中.....
  </div>
  
  <div v-else-if="error" class="text-blue-800 text-center text-3xl font-bold py-20">
      {{ error }}
  </div>
  
  <div v-else class="max-w-5xl mx-auto p-8">
    <div class=" flex flex-col lg:flex-row gap-5  mb-6">
  
      <div class="flex-2 bg-gray-50 p-4 rounded-lg shadow border border-gray-100">
        <h1 class="text-3xl text-gray-800 font-bold mb-4 pb-2 border-b border-gray-300">{{ event.title }}</h1>
          <div v-if="event.description" class="flex items-start gap-2">
            <span class="text-xs font-bold text-blue-600 bg-blue-100 px-2 py-1 rounded-md whitespace-nowrap mt-1">
            詳細・備考
            </span>
            
            <p class="text-gray-600 leading-relaxed whitespace-pre-wrap">
              {{ event.description }}
            </p>
          </div>
      </div>
      
      <div class="flex-1 bg-gray-50 p-4 rounded-lg shadow border border-gray-100">
        <button class="w-full bg-blue-600 text-white text-md font-bold mb-4 py-3 px-6 rounded-full shadow-lg hover:bg-blue-700 hover:-translate-y-1 transition transform">
          → あなたの予定を追加する
        </button>
        <p class="mt-2 text-xs text-gray-400 text-center">
          参加者の方はこちらから予定を追加してください
        </p>
      </div>
      
    </div>
    
    <h2 class="text-xl font-bold text-gray-700 mb-4 flex items-center gap-2">
      <span class="w-1 h-6 bg-blue-400 rounded-full"></span> 参加者一覧
      <span class="text-sm font-normal text-gray-500 ml-2">
        ({{ event.users ? event.users.length : 0 }}人)
      </span>
    </h2>
      
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
      <div v-if="event.users && event.users.length > 0">
        <ul>
            <li 
                v-for="(user, index) in event.users" 
                :key="user.id || index"
                class="py-2 px-4 border-b border-gray-100 last:border-non flex items-center gap-3"
              >
                <div class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-sm flex-shrink-0">
                  {{ user.name ? user.name.charAt(0) : '?' }}
                </div>

                <div class="flex items-baseline gap-3 min-w-0">
                  <span class="font-bold text-gray-800 text-sm whitespace-nowrap">
                    {{ user.name }}
                  </span>
                  
                  <span v-if="user.comment" class="text-xs text-gray-600 truncate">
                    {{ user.comment }}
                  </span>
                </div>
              </li>
          </ul>
      </div>
        
      <div v-else class="p-8 text-center text-gray-400">
        <p>まだ回答はありません</p>
      </div>
      
    </div>
    
  </div>
  

</template>

<style></style>