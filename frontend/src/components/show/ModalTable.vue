<script setup>
import { ref, reactive, computed, watch, onMounted, onUnmounted } from 'vue'

const props = defineProps({
  event: {
    type: Object,
    required: true,
  },

  editingUser: {
    type: Object,
    dafault: null,
  },
})

const STATUS = {
  OK: 1, // ⚪︎
  MAYBE: 2, // △
  NG: 3, // ×
}

const emit = defineEmits(['submit-data'])

const activeSlots = ref(new Set())

const isDragging = ref(false)
const currentMode = ref(STATUS.OK)

const userResponses = reactive({})

const candidateDates = computed(() => {
  if (!props.event || !props.event.candidates) return []
  const dates = props.event.candidates.map((c) => c.start_time.split('T')[0])
  return [...new Set(dates)].sort()
})

// 表のデータ用
const timeSlots = computed(() => {
  const slots = []
  for (let h = 0; h < 24; h++) {
    // データは00:00から23:30まで
    const hour = String(h).padStart(2, '0')
    slots.push(`${hour}:00`)
    slots.push(`${hour}:30`)
  }
  return slots
})

// 表の目盛り用
const headerLabels = computed(() => {
  const allTimes = [...timeSlots.value, '24:00']

  return allTimes.map((time) => {
    return {
      fullTime: time,
      hourOnly: time.split(':')[0],
      isWholeHour: time.endsWith('00'),
    }
  })
})

const formatDateHeader = (dateStr) => {
  const date = new Date(dateStr)
  return new Intl.DateTimeFormat('ja-JP', {
    year: 'numeric',
    month: 'numeric',
    day: 'numeric',
    weekday: 'short',
  }).format(date)
}

const getKey = (date, time) => `${date}T${time}`

const calculateActiveSlots = () => {
  if (!props.event || !props.event.candidates) return

  const newSet = new Set()

  candidateDates.value.forEach((date) => {
    timeSlots.value.forEach((time) => {
      const isActive = props.event.candidates.some((c) => {
        const cDate = c.start_time.split('T')[0]
        const cStart = c.start_time.split('T')[1].substring(0, 5)
        const cEnd = c.end_time.split('T')[1].substring(0, 5)

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

// ---表のドラッグ処理---

const startDrag = (date, time) => {
  isDragging.value = true
  updateStatus(date, time)
}

const stopDrag = () => {
  isDragging.value = false
}

// ------------------

// ---マウスイベント---

const onMouseEnter = (date, time) => {
  if (isDragging.value) {
    updateStatus(date, time)
  }
}

// ------------------

// ---タッチイベント---

const onTouchMove = (e) => {
  if (!isDragging.value) return

  if (e.cancelable) {
    e.preventDefault()
  }

  // 位置を取得
  const touch = e.touches[0]
  const x = touch.clientX
  const y = touch.clientY

  // 位置の下にある要素取得
  const element = document.elementFromPoint(x, y)

  if (element && element.dataset.date && element.dataset.time) {
    const date = element.dataset.date
    const time = element.dataset.time
    updateStatus(date, time)
  }
}

//-------------------

onMounted(() => {
  window.addEventListener('mouseup', stopDrag)
  window.addEventListener('touchend', stopDrag)
  window.addEventListener('touchcancel', stopDrag)
})

onUnmounted(() => {
  window.removeEventListener('mouseup', stopDrag)
  window.removeEventListener('touchend', stopDrag)
  window.removeEventListener('touchcancel', stopDrag)
})

// 表を全部OKで初期化
watch(
  () => [props.event, props.editingUser],
  () => {
    if (!props.event || !props.event.candidates) return

    calculateActiveSlots()

    const isEditMode = !!props.editingUser

    candidateDates.value.forEach((date) => {
      timeSlots.value.forEach((time) => {
        if (isSlotActive(date, time)) {
          const key = getKey(date, time)

          if (isEditMode) {
            const existingResponse = props.editingUser.responses.find((res) =>
              res.start_time.startsWith(key),
            )

            userResponses[key] = existingResponse ? existingResponse.status : STATUS.OK
          } else {
            if (userResponses[key] === undefined) {
              userResponses[key] = STATUS.OK
            }
          }
        }
      })
    })
  },
  { immediate: true, deep: true },
)

const submit = () => {
  const filteredResponses = {}

  Object.entries(userResponses).forEach(([key, status]) => {
    if (status !== STATUS.OK) {
      filteredResponses[key] = status
    }
  })

  const payload = {
    responses: filteredResponses,
  }

  emit('submit-data', payload)
}

defineExpose({ submit })
</script>
<template>
  <div class="sticky top-0 left-0 z-30 flex gap-4">
    <button
      @click="currentMode = STATUS.OK"
      class="flex items-center gap-2 rounded-full border px-2 transition-all sm:px-4"
      :class="
        currentMode === STATUS.OK
          ? 'border-blue-500 bg-blue-50 font-bold text-blue-600 ring-2 ring-blue-200'
          : 'border-gray-500 bg-white text-gray-500'
      "
    >
      <span class="text-md sm:text-xl">⚪︎</span> 参加
    </button>

    <button
      @click="currentMode = STATUS.MAYBE"
      class="flex items-center gap-2 rounded-full border px-2 transition-all sm:px-4"
      :class="
        currentMode === STATUS.MAYBE
          ? 'border-yellow-500 bg-yellow-50 font-bold text-yellow-600 ring-2 ring-yellow-200'
          : 'border-gray-500 bg-white text-gray-500'
      "
    >
      <span class="text-md sm:text-xl">△</span> 未定
    </button>

    <button
      @click="currentMode = STATUS.NG"
      class="flex items-center gap-2 rounded-full border px-2 transition-all sm:px-4"
      :class="
        currentMode === STATUS.NG
          ? 'border-gray-500 bg-gray-50 font-bold text-gray-600 ring-2 ring-gray-200'
          : 'border-gray-500 bg-white text-gray-500'
      "
    >
      <span class="text-md sm:text-xl">×</span> 不参加
    </button>
  </div>

  <div class="w-full overflow-x-auto">
    <div class="my-6 min-w-full text-center">
      <div class="mx-auto inline-block min-w-max px-4 text-left">
        <table class="table-fixed border-separate border-spacing-0">
          <tbody
            v-for="date in candidateDates"
            :key="date"
          >
            <tr class="h-5 sm:h-6">
              <td
                rowspan="2"
                class="sticky left-0 z-20 w-20 border-y-2 border-r-2 border-l-2 border-gray-400 bg-white px-1 py-1 text-center text-[10px] font-bold whitespace-nowrap text-gray-700 sm:px-2 sm:text-xs"
              >
                {{ formatDateHeader(date) }}
              </td>

              <th
                v-for="(label, index) in headerLabels"
                :key="label.fullTime"
                class="relative border-t-2 border-b border-gray-400 bg-white px-0 pb-0.5 text-left align-bottom font-normal"
                :class="[
                  index === headerLabels.length - 1
                    ? 'w-0 overflow-hidden rounded-tr-lg border-r-2'
                    : 'w-3 sm:w-4',
                ]"
              >
                <span
                  v-if="label.isWholeHour && index !== 0 && index !== headerLabels.length - 1"
                  class="absolute bottom-1 left-0 w-4 -translate-x-full transform pr-0.5 text-right text-[8px] leading-none font-bold text-gray-400 sm:text-[10px]"
                >
                  {{ label.hourOnly }}
                </span>

                <span
                  v-if="index === headerLabels.length - 2"
                  class="absolute right-0 bottom-1 z-10 w-4 text-center text-[8px] leading-none font-bold text-gray-400 sm:text-[10px]"
                >
                  {{ headerLabels[headerLabels.length - 1]?.hourOnly }}
                </span>

                <div
                  class="absolute bottom-0 left-0 border-l border-gray-300"
                  :class="label.isWholeHour ? 'h-2.5' : 'h-1.5'"
                ></div>
              </th>
            </tr>

            <tr class="transition">
              <td
                v-for="(time, index) in timeSlots"
                :key="date + time"
                :data-date="date"
                :data-time="time"
                @mousedown.prevent="startDrag(date, time)"
                @mouseenter="onMouseEnter(date, time)"
                @touchstart="startDrag(date, time)"
                @touchmove="onTouchMove"
                class="relative h-5 w-3 border-b-2 border-gray-400 p-0 text-center text-xs sm:h-6 sm:w-4 sm:text-xs"
                :class="[
                  isSlotActive(date, time)
                    ? getStatus(date, time) === STATUS.OK
                      ? 'bg-blue-300 text-white'
                      : getStatus(date, time) === STATUS.MAYBE
                        ? 'bg-yellow-300 text-yellow-600'
                        : getStatus(date, time) === STATUS.NG
                          ? 'bg-gray-300 text-gray-500'
                          : 'bg-white hover:bg-gray-50'
                    : 'bg-gray-200',

                  isSlotActive(date, time) && index !== 0 ? 'border-l border-l-gray-300' : '',
                ]"
              >
                <span
                  v-if="isSlotActive(date, time)"
                  class="pointer-events-none"
                >
                  {{
                    getStatus(date, time) === STATUS.OK
                      ? '⚫︎'
                      : getStatus(date, time) === STATUS.MAYBE
                        ? '▲'
                        : getStatus(date, time) === STATUS.NG
                          ? '×'
                          : ''
                  }}
                </span>
              </td>

              <td
                v-if="headerLabels.length > timeSlots.length"
                class="h-5 w-0 overflow-hidden rounded-br-lg border-r-2 border-b-2 border-gray-400 bg-white p-0 sm:h-6"
              ></td>
            </tr>

            <tr class="h-2.5 border-none sm:h-4">
              <td
                :colspan="headerLabels.length + 1"
                class="border-none bg-transparent"
              ></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
