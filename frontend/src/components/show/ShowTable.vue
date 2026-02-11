<script setup>
import { computed } from "vue"

const props = defineProps({
  event: {
    type: Object,
    required: true
  }
})

const candidateDates = computed(() => {
  if (!props.event || !props.event.candidates) return []
  const dates = props.event.candidates.map(c => c.start_time.split("T")[0])
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
  if (!props.event) return false
  
  return props.event.candidates.some(c => {
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

const getStatusClass = (user, date, time) => {
  if (!isSlotActive(date, time)) {
    return "bg-gray-200" 
  }
  
  const target = `${date}T${time}`
  const response = user.responses.find(res => res.start_time.startsWith(target))
  const status = response ? response.status : 0
  
  switch (status) {
    case 1:
      return "bg-blue-300 text-white border-l border-l-gray-200"
    case 2 :
      return "bg-yellow-300 text-yellow-600 border-l border-l-gray-200"
    case 3 :
      return "bg-gray-300 text-gray-500 border-l border-l-gray-200"
    default:
      return "bg-white"
  }  
}

const getStatusSymbol = (user, date, time) => {
  
  const target = `${date}T${time}`
  const response = user.responses.find(res => res.start_time.startsWith(target))
  const status = response ? response.status : 0
  
  switch (status) {
    case 1: return '⚫︎'
    case 2: return '▲'
    case 3: return '×'
    default: return ''
  }
}
</script>
<template>
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
                  class="px-0 pb-0.5 font-normal text-left align-bottom relative bg-white border-t-2 border-gray-400 border-b"
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
                
              <tr>
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
              
              <template v-for="user in props.event.users" :key="user.id">
                <tr class="h-1 border-none">
              	  <td :colspan="headerLabels.length + 1" class="border-none bg-transparent"></td>
                </tr>
                
                <tr class="h-6">
                  
                  <td class="py-1 px-2 bg-white text-xs font-bold text-gray-700 whitespace-nowrap w-20 text-center border-y-2 border-l-2 border-r-2 border-gray-400 rounded-l-lg">
                    {{ user.name }}
                  </td>
                  
                  <td 
                    v-for="(time, index) in timeSlots" :key="index"
                    class="border-t-2 border-b-2 border-t-gray-400 border-b-gray-400 text-center text-xs"
                    :class="[
                      getStatusClass(user, date, time),
                    ]"
                  >
                    <span class="pointer-event-none">
                      {{ getStatusSymbol(user, date, time) }}
                    </span>
                  </td>
                  
                  <td 
                  class="h-6 p-0 border-b-2 border-r-2 border-gray-400  overflow-hidden w-0 bg-white"
                  ></td>
                </tr>
              </template>
              
              
              <tr class="h-5 border-none">
              	<td :colspan="headerLabels.length + 1" class="border-none bg-transparent"></td>
              </tr>
              
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div> 
</template>