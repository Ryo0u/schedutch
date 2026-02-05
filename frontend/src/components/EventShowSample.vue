<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import { useRoute } from 'vue-router'

const route = useRoute()
const event = ref(null)
const loading = ref(true)
const error = ref(null)

// 1. 日付リスト
const tableDates = computed(() => {
  if (!event.value || !event.value.candidates) return []
  const dates = event.value.candidates.map(c => c.start_time.split('T')[0])
  return [...new Set(dates)].sort()
})

// 2. 時間リスト
const timeSlots = computed(() => {
  const slots = []
  let current = new Date('2000-01-01T00:00:00')
  const end = new Date('2000-01-01T23:30:00')

  while (current <= end) {
    const timeStr = current.toTimeString().slice(0, 5)
    slots.push(timeStr)
    current.setMinutes(current.getMinutes() + 30)
  }
  return slots
})

// 3. ヘッダー用
const headerTimes = computed(() => {
  const slots = [...timeSlots.value]
  if (slots.length === 0) return []

  const lastTime = slots[slots.length - 1]
  const date = new Date(`2000-01-01T${lastTime}`)
  date.setMinutes(date.getMinutes() + 30)
  const endTime = date.toTimeString().slice(0, 5)
  slots.push(endTime === '00:00' ? '24:00' : endTime)
  
  return slots
})

const formatHour = (timeStr) => {
  return timeStr.split(':')[0]
}

const isHourMark = (timeStr) => {
  return timeStr.endsWith('00') || timeStr === '24:00'
}

const isSlotActive = (date, time) => {
  if (!event.value) return false
  return event.value.candidates.some(c => {
    const cDate = c.start_time.split('T')[0]
    const cStart = c.start_time.split('T')[1].substring(0, 5)
    const cEnd = c.end_time.split('T')[1].substring(0, 5)
    return cDate === date && time >= cStart && time < cEnd
  })
}

const formatDateHeader = (dateStr) => {
  const date = new Date(dateStr)
  return new Intl.DateTimeFormat('ja-JP', { month: 'numeric', day: 'numeric', weekday: 'short' }).format(date)
}

onMounted(async () => {
  try {
    const token = route.params.url_token
    const response = await axios.get(`http://localhost:3000/api/v1/events/${token}`)
    event.value = response.data
  } catch (err) {
    console.error(err)
    error.value = 'イベントが見つかりませんでした。'
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="w-full px-2 lg:px-8 py-6">
    
    <div v-if="loading" class="text-center py-20 text-gray-500">読み込み中... ⏳</div>
    <div v-else-if="error" class="text-center py-20 text-red-500 font-bold">{{ error }}</div>

    <div v-else class="animate-fade-in">
      
      <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 mb-8 text-center max-w-4xl mx-auto">
        <h1 class="text-3xl font-bold text-gray-800 mb-3">{{ event.title }}</h1>
        <p class="text-gray-600 whitespace-pre-wrap leading-relaxed">{{ event.description }}</p>
      </div>

      <div class="bg-white p-4 rounded-xl shadow-sm border border-gray-100 overflow-x-auto text-center">
        
        <div class="inline-block min-w-max align-middle text-left">
          <table class="border-collapse w-full">
            
            <tbody v-for="date in tableDates" :key="date">
              
              <tr class="h-6">
                <th class="w-20 bg-white left-0 z-20 border-r border-gray-200 relative">
                  <span class="absolute bottom-1 right-1 text-[10px] text-gray-400 font-bold leading-none">
                    {{ formatHour(headerTimes[0]) }}
                  </span>
                </th>

                <th 
                  v-for="(time, index) in headerTimes" 
                  :key="time"
                  class="px-0 pb-1 font-normal text-left align-bottom relative"
                  :class="index === headerTimes.length - 1 ? 'w-0' : 'w-0'" 
                >
                  <span 
                    v-if="isHourMark(time) && index !== 0" 
                    class="absolute bottom-1 left-0 transform -translate-x-full pr-0.5 w-4 text-right text-[10px] text-gray-400 font-bold leading-none"
                  >
                    {{ formatHour(time) }}
                  </span>
                  
                  <div 
                    class="absolute bottom-0 left-0 border-l border-gray-300"
                    :class="isHourMark(time) ? 'h-1.5' : 'h-1'"
                  ></div>
                </th>
              </tr>

              <tr class="transition">
                <td class="py-2 px-2 border-r bg-white sticky left-0 z-10 text-xs font-bold text-gray-700 shadow-[2px_0_5px_rgba(0,0,0,0.05)] whitespace-nowrap w-20 text-center border-y border-gray-300">
                  {{ formatDateHeader(date) }}
                </td>
                
                <td 
                  v-for="time in timeSlots" 
                  :key="date + time"
                  class="border-y border-gray-300 h-0 p-0 text-center relative w-4"
                  :class="isSlotActive(date, time) ? 'bg-white' : 'bg-gray-200'"
                >
                  </td>
                
                <td class="h-0 p-0 border-l border-gray-300 w-0"></td>
              </tr>

              <tr class="h-6 border-none bg-transparent">
                <td :colspan="headerTimes.length"></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="mt-8 text-center">
        <button class="bg-blue-600 text-white text-lg font-bold py-3 px-12 rounded-full shadow-lg hover:bg-blue-700 hover:-translate-y-1 transition transform">
          出欠を入力する
        </button>
      </div>

    </div>
  </div>
</template>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.5s ease-out;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>