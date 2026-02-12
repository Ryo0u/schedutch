<script setup>
import { ref, reactive, computed, watch, onMounted, onUnmounted } from "vue"

const props = defineProps({
  event: {
    type: Object,
    required: true
  }
})

const STATUS = {
  OK: 1,      // ⚪︎
  MAYBE: 2,   // △
  NG: 3       // ×
}

const emit = defineEmits(['submit-data'])

const activeSlots = ref(new Set())

const isDragging =ref(false)
const currentMode = ref(STATUS.OK)

const userResponses = reactive({})


const candidateDates = computed(() => {
  if (!props.event || !props.event.candidates) return []
  const dates = props.event.candidates.map(c => c.start_time.split("T")[0])
  return [...new Set(dates)].sort()
})

// データ用
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

const formatDateHeader = (dateStr) => {
  const date = new Date(dateStr)
  return new Intl.DateTimeFormat('ja-JP', {year: 'numeric', month: 'numeric', day: 'numeric', weekday: 'short' }).format(date)
}

const getKey = (date, time) => `${date}T${time}`

const calculateActiveSlots = () => {
  if (!props.event || !props.event.candidates) return
  
  const newSet = new Set()
  
  candidateDates.value.forEach(date => {
    timeSlots.value.forEach(time => {
      
      const isActive = props.event.candidates.some(c => {
        const cDate = c.start_time.split("T")[0]
        const cStart = c.start_time.split("T")[1].substring(0, 5)
        const cEnd =c.end_time.split("T")[1].substring(0, 5)
        
        return date === cDate && time >= cStart && time < cEnd
      })
      
      if (isActive) {
        newSet.add(`${date}T${time}`)
      }
    })
  })
  
  activeSlots.value = newSet
}

const isSlotActive = (date, time) => {
  const key = getKey(date, time)
  return activeSlots.value.has(key)
}

const getStatus = (date, time) => {
  const key = getKey(date, time)
  return userResponses[key]
}

const updateStatus = (date, time) => {
  if (!isSlotActive(date, time)) return
  const key = getKey(date, time)
  userResponses[key] = currentMode.value
}


const startDrag = (date, time) => {
  isDragging.value = true
  updateStatus(date, time)
}


const onMouseEnter = (date, time) => {
  if (isDragging.value) {
    updateStatus(date, time)
  }
}

const stopDrag = () => {
  isDragging.value = false
}

// 画面のどこでマウスを離してもドラッグを終了させるための設定
onMounted(() => {
  window.addEventListener('mouseup', stopDrag)
})

onUnmounted(() => {
  window.removeEventListener('mouseup', stopDrag)
})

// 全部OKで初期化
watch(() => props.event, () => {
  if (!props.event || !props.event.candidates) return

  calculateActiveSlots()
  
  candidateDates.value.forEach(date => {
    timeSlots.value.forEach(time => {
      if (isSlotActive(date, time)) {
        const key = getKey(date, time)
        if (userResponses[key] === undefined) {
          userResponses[key] = STATUS.OK
        }
      }
    })
  })
}, { immediate: true, deep: true })



const submit = () => {
	const payload = {
		responses: userResponses
	}
	
	emit("submit-data", payload)
}

defineExpose({ submit })

</script>
<template>
	<div class="flex gap-4">
      <button 
        @click="currentMode = STATUS.OK"
        class="flex items-center gap-2 px-4 rounded-full border transition-all"
        :class="currentMode === STATUS.OK ? 'bg-blue-50 border-blue-500 text-blue-600 font-bold ring-2 ring-blue-200' : 'bg-white border-gray-300 text-gray-500'"
      >
        <span class="text-xl">⚪︎</span> 参加
      </button>

      <button 
        @click="currentMode = STATUS.MAYBE"
        class="flex items-center gap-2 px-4 rounded-full border transition-all"
        :class="currentMode === STATUS.MAYBE ? 'bg-yellow-50 border-yellow-500 text-yellow-600 font-bold ring-2 ring-yellow-200' : 'bg-white border-gray-300 text-gray-500'"
      >
        <span class="text-xl">△</span> 未定
      </button>

      <button 
        @click="currentMode = STATUS.NG"
        class="flex items-center gap-2 px-4 rounded-full border transition-all"
        :class="currentMode === STATUS.NG ? 'bg-gray-50 border-gray-500 text-gray-600 font-bold ring-2 ring-gray-200' : 'bg-white border-gray-300 text-gray-500'"
      >
        <span class="text-xl">×</span> 不参加
      </button>
    </div>
	
	<div class="w-full overflow-x-auto">
		<div class="min-w-full my-6 text-center">         
			<div class="inline-block min-w-max px-4 mx-auto text-left">
				<table class="border-separate border-spacing-0 table-fixed">
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
							
						<tr class="transition">
							<td 
								v-for="(time, index) in timeSlots" 
								:key="date + time"
								
								@mousedown.prevent="startDrag(date, time)"
                @mouseenter="onMouseEnter(date, time)"
								
								class="border-b-2 border-gray-400 h-6 p-0 text-center relative w-4 text-xs"
								:class="[
									isSlotActive(date, time)
										? (	getStatus(date, time) === STATUS.OK ? 'bg-blue-300 text-white' :
												getStatus(date, time) === STATUS.MAYBE ? 'bg-yellow-300 text-yellow-600' :
												getStatus(date, time) === STATUS.NG ? 'bg-gray-300 text-gray-500' :
												'bg-white hover:bg-gray-50')
										: 'bg-gray-200 cursor-not-allowed',
										
										(isSlotActive(date, time) && index !== 0) ? 'border-l border-l-gray-300' : ''
								]"
							>
								<span v-if="isSlotActive(date, time)" class="pointer-events-none">
                    {{ 
                      getStatus(date, time) === STATUS.OK ? '⚫︎' : 
                      getStatus(date, time) === STATUS.MAYBE ? '▲' : 
                      getStatus(date, time) === STATUS.NG ? '×' : '' 
                    }}
                </span>
							</td>

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
</template>