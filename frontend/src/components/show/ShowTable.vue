<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  event: {
    type: Object,
    required: true,
  },
})

const activeSlots = ref(new Set())

const candidateDates = computed(() => {
  if (!props.event || !props.event.candidates) return []
  const dates = props.event.candidates.map((c) => c.start_time.split('T')[0])
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
  const key = `${date}T${time}`
  return activeSlots.value.has(key)
}

watch(
  () => props.event,
  () => {
    calculateActiveSlots()
  },
  { immediate: true, deep: true },
)

const getStatusClass = (user, date, time) => {
  if (!isSlotActive(date, time)) {
    return 'bg-gray-200'
  }

  const target = `${date}T${time}`
  const response = user.responses.find((res) => res.start_time.startsWith(target))
  const status = response ? response.status : 1

  switch (status) {
    case 1:
      return 'bg-blue-300 text-white border-l border-l-gray-200'
    case 2:
      return 'bg-yellow-300 text-yellow-600 border-l border-l-gray-200'
    case 3:
      return 'bg-gray-300 text-gray-500 border-l border-l-gray-200'
    default:
      return 'bg-white'
  }
}

const getStatusSymbol = (user, date, time) => {
  if (!isSlotActive(date, time)) return ''

  const target = `${date}T${time}`
  const response = user.responses.find((res) => res.start_time.startsWith(target))
  const status = response ? response.status : 1

  switch (status) {
    case 1:
      return '⚫︎'
    case 2:
      return '▲'
    case 3:
      return '×'
    default:
      return ''
  }
}
</script>
<template>
  <h2
    class="flex items-center gap-2 rounded-t-lg bg-gray-100 p-3 text-lg font-bold text-gray-700 shadow sm:text-xl"
  >
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="currentColor"
      class="size-5 sm:size-6"
    >
      <path
        fill-rule="evenodd"
        d="M6.75 2.25A.75.75 0 0 1 7.5 3v1.5h9V3A.75.75 0 0 1 18 3v1.5h.75a3 3 0 0 1 3 3v11.25a3 3 0 0 1-3 3H5.25a3 3 0 0 1-3-3V7.5a3 3 0 0 1 3-3H6V3a.75.75 0 0 1 .75-.75Zm13.5 9a1.5 1.5 0 0 0-1.5-1.5H5.25a1.5 1.5 0 0 0-1.5 1.5v7.5a1.5 1.5 0 0 0 1.5 1.5h13.5a1.5 1.5 0 0 0 1.5-1.5v-7.5Z"
        clip-rule="evenodd"
      />
    </svg>

    予定一覧
  </h2>

  <div class="mb-10 overflow-hidden rounded-b-lg border border-gray-100 bg-white shadow-sm">
    <div class="w-full overflow-x-auto">
      <div class="my-3 min-w-full text-center sm:my-6">
        <div class="mx-auto inline-block min-w-max px-4 text-left">
          <table class="border-separate border-spacing-0">
            <tbody
              v-for="date in candidateDates"
              :key="date"
            >
              <tr class="h-5 sm:h-6">
                <td
                  rowspan="2"
                  class="sticky left-0 z-20 w-20 border-y-2 border-r-2 border-l-2 border-gray-400 bg-white px-1 py-0.5 text-center text-[10px] font-bold whitespace-nowrap text-gray-700 sm:px-2 sm:py-1 sm:text-xs"
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
                    class="absolute right-0 bottom-1 z-10 w-3 text-center text-[8px] leading-none font-bold text-gray-400 sm:w-4 sm:text-[10px]"
                  >
                    {{ headerLabels[headerLabels.length - 1]?.hourOnly }}
                  </span>

                  <div
                    class="absolute bottom-0 left-0 border-l border-gray-300"
                    :class="label.isWholeHour ? 'h-2.5' : 'h-1.5'"
                  ></div>
                </th>
              </tr>

              <tr>
                <td
                  v-for="(time, index) in timeSlots"
                  :key="date + time"
                  class="relative h-5 w-3 border-b-2 border-gray-400 p-0 text-center sm:h-6 sm:w-4"
                  :class="[
                    isSlotActive(date, time) ? 'bg-white' : 'bg-gray-200',
                    index === timeSlots.length - 1 && headerLabels.length === timeSlots.length
                      ? 'overflow-hidden rounded-br-lg border-r-2 border-gray-400'
                      : '',
                  ]"
                ></td>

                <td
                  v-if="headerLabels.length > timeSlots.length"
                  class="h-5 w-0 overflow-hidden rounded-br-lg border-r-2 border-b-2 border-gray-400 bg-white p-0 sm:h-6"
                ></td>
              </tr>

              <template
                v-for="user in props.event.users"
                :key="user.id"
              >
                <tr class="h-0.5 border-none">
                  <td
                    :colspan="headerLabels.length + 1"
                    class="border-none bg-transparent"
                  ></td>
                </tr>

                <tr class="h-5 sm:h-6">
                  <td
                    class="sticky left-0 z-20 w-20 border-y-2 border-r-2 border-l-2 border-gray-400 bg-white px-2 py-0.5 text-center text-[10px] font-bold whitespace-nowrap text-gray-700 sm:py-1 sm:text-xs"
                  >
                    {{ user.name }}
                  </td>

                  <td
                    v-for="(time, index) in timeSlots"
                    :key="index"
                    class="border-t-2 border-b-2 border-t-gray-400 border-b-gray-400 text-center text-[10px] sm:text-xs"
                    :class="[getStatusClass(user, date, time)]"
                  >
                    <span class="pointer-event-none">
                      {{ getStatusSymbol(user, date, time) }}
                    </span>
                  </td>

                  <td
                    class="h-5 w-0 overflow-hidden border-r-2 border-b-2 border-gray-400 bg-white p-0 sm:h-6"
                  ></td>
                </tr>
              </template>

              <tr class="h-3 border-none sm:h-5">
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
  </div>
</template>
