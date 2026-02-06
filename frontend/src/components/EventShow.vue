<script setup>
import {ref, computed, onMounted} from "vue"
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

const candidateDates = computed(() => {
  if (!event.value || !event.value.candidates) return []
  const dates = event.value.candidates.map(c => c.start_time.split("T")[0])
  return [...new Set(dates)].sort()
})

// スロット用
const timeSlots = computed(() => {
  const slots = []
  for (let h = 0; h < 24; h++) {
    const hour = String(h).padStart(2, '0')
    slots.push(`${hour}:00`)
    slots.push(`${hour}:30`)
  }
  return slots
})

// 目盛り用
const headerLabels = computed(() => {
  const allTimes = [...timeSlots.value, "24:00"]
  
  return allTimes.map(time => {
    return {
      fullTime: time,
      hourOnly: time.split(":")[0],
      isWholeHour: time.endsWith("00")
    }
  })
})

const isSlotActive = (date, time) => {
  if (!event.value) return false
  
  return event.value.candidates.some(c => {
    const cDate = c.start_time.split("T")[0]
    const cStart = c.start_time.split("T")[1].substring(0, 5)
    const cEnd =c.end_time.split("T")[1].substring(0, 5)
    
    return date === cDate && time >= cStart && time < cEnd
  })
}

const formatDateHeader = (dateStr) => {
  const date = new Date(dateStr)
  return new Intl.DateTimeFormat('ja-JP', {year: 'numeric', month: 'numeric', day: 'numeric', weekday: 'short' }).format(date)
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
    <div class=" flex flex-col lg:flex-row gap-5  mb-6">
  
      <div class="flex-2 bg-gray-100 p-4 rounded-lg shadow border border-gray-100">
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
      
      <div class="flex-1 bg-gray-100 p-4 rounded-lg shadow border border-gray-100">
        <button class="w-full bg-blue-600 text-white text-md font-bold mb-4 py-3 px-6 rounded-full shadow-lg hover:bg-blue-700 hover:-translate-y-1 transition transform">
          → あなたの予定を追加する
        </button>
        <p class="mt-2 text-xs text-gray-400 text-center">
          参加者の方はこちらから予定を追加してください
        </p>
      </div>
      
    </div>
    
    <h2 class="text-xl font-bold text-gray-700  bg-gray-100 p-3 rounded-t-lg flex items-center gap-2">
      <span class="w-1 h-6 bg-blue-400 rounded-full"></span> 参加者一覧
      <span class="text-sm font-normal text-gray-500 ml-2">
        ({{ event.users ? event.users.length : 0 }}人)
      </span>
    </h2>
      
    <div class="bg-white rounded-b-lg shadow-sm border border-gray-100 overflow-hidden mb-10">
      <div v-if="event.users && event.users.length > 0">
        <ul>
            <li 
                v-for="(user, index) in event.users" 
                :key="user.id || index"
                class="py-2 px-4 border-b border-gray-100 last:border-none flex items-center gap-3"
              >
                <div class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-sm shrink-0">
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
    
    <h2 class="text-xl font-bold text-gray-700  bg-gray-100 p-3 rounded-t-lg flex items-center gap-2">
      <span class="w-1 h-6 bg-blue-400 rounded-full"></span>予定一覧
    </h2>

    <div class="bg-white rounded-b-lg shadow-sm border border-gray-100 overflow-hidden mb-10">
  <div class="w-full overflow-x-auto">
    <div class="min-w-full my-6 text-center">
      
      <div class="inline-block min-w-max px-4 mx-auto text-left">
        <table class="border-separate border-spacing-0">
          <tbody v-for="date in candidateDates" :key="date">
            
            <tr class="h-6">
              <td 
                rowspan="2" 
                class="py-1 px-2 bg-white text-xs font-bold text-gray-700 whitespace-nowrap w-20 text-center border-y-2 border-l-2 border-r-2 border-gray-400 rounded-l-lg"
              >
                {{ formatDateHeader(date) }}
              </td>
              
              <th 
                v-for="(label, index) in headerLabels" 
                :key="label.fullTime"
                class="px-0 pb-0.5 font-normal text-left align-bottom relative bg-white border-t-2 border-gray-400 border-b border-gray-300"
                :class="[
                  index === headerLabels.length - 1 
                    ? 'w-0 border-r-2 rounded-tr-lg overflow-hidden' 
                    : 'w-4'
                ]" 
              >
                <span 
                  v-if="label.isWholeHour && index !== 0 && index !== headerLabels.length - 1" 
                  class="absolute bottom-1 left-0 transform -translate-x-full pr-0.5 w-4 text-right text-[10px] text-gray-400 font-bold leading-none"
                >
                  {{ label.hourOnly }}
                </span>
  
                <span 
                  v-if="index === headerLabels.length - 2"
                  class="absolute bottom-1 right-0 w-4 text-center text-[10px] text-gray-400 font-bold leading-none z-10"
                >
                  {{ headerLabels[headerLabels.length - 1]?.hourOnly }}
                </span>
                
                <div class="absolute bottom-0 left-0 border-l border-gray-300" :class="label.isWholeHour ? 'h-2.5' : 'h-1.5'"></div>
              </th>
            </tr>
            
            <tr class="transition">
              <td 
                v-for="(time, index) in timeSlots" 
                :key="date + time"
                class="border-b-2 border-gray-400 h-6 p-0 text-center relative w-4"
                :class="[
                  isSlotActive(date, time) ? 'bg-white' : 'bg-gray-200',
                  (index === timeSlots.length - 1 && headerLabels.length === timeSlots.length) 
                    ? 'border-r-2 border-gray-400 rounded-br-lg overflow-hidden' 
                    : ''
                ]"
              ></td>
  
              <td 
                v-if="headerLabels.length > timeSlots.length" 
                class="h-6 p-0 border-b-2 border-r-2 border-gray-400 rounded-br-lg overflow-hidden w-0 bg-white"
              ></td>
            </tr>
  
            <tr class="h-4 border-none">
              <td :colspan="headerLabels.length + 1" class="border-none bg-transparent"></td>
            </tr>
  
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
    
</div>

  

</template>

<style></style>