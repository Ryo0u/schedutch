<script setup>
import { ref } from 'vue'

const props = defineProps({
  event: { type: Object, required: true },
})

const includeTriangle = ref(false)

const selectedUsers = ref([])
const extractedTimes = ref('')

const isCopied = ref(false)

const extractTimes = () => {
  if (selectedUsers.value.length === 0) {
    extractedTimes.value = 'メンバーを選択してください'
    return
  }

  const targetUsers = props.event.users.filter((u) => selectedUsers.value.includes(u.id))

  const memberNames = targetUsers.map((u) => u.name).join('、')
  const namesHeader = `【参加者】\n${memberNames}\n`

  // 全ての候補時間を用意
  const allActiveSlots = []
  props.event.candidates.forEach((c) => {
    let current = new Date(c.start_time)
    const end = new Date(c.end_time)

    while (current < end) {
      allActiveSlots.push(current.toISOString())
      current.setMinutes(current.getMinutes() + 30)
    }
  })

  const okTimes = allActiveSlots
    .filter((time) => {
      return targetUsers.every((u) => isOK(u, time))
    })
    .sort()

  if (okTimes.length === 0) {
    extractedTimes.value = '選択したメンバーの予定が合う時間はありませんでした...'
    return
  }

  const dayResult = {}
  let current = null

  okTimes.forEach((isoString) => {
    const date = isoString.split('T')[0]
    const time = isoString.split('T')[1].substring(0, 5)

    const isTriangle = targetUsers.some((u) => {
      const res = u.responses.find((r) => r.start_time === isoString)
      return res && res.status === 2
    })

    if (!current) {
      current = { date, start: time, end: time, hasTriangle: isTriangle }
    } else {
      if (current.date === date && getNextSlot(current.end) === time) {
        current.end = time
        if (isTriangle) current.hasTriangle = true
      } else {
        if (!dayResult[current.date]) dayResult[current.date] = []
        const mark = current.hasTriangle ? '(▲)' : ''
        dayResult[current.date].push(`${current.start} 〜 ${getNextSlot(current.end)}${mark}`)

        current = { date, start: time, end: time, hasTriangle: isTriangle }
      }
    }
  })

  if (current) {
    if (!dayResult[current.date]) dayResult[current.date] = []
    const mark = current.hasTriangle ? '(▲)' : ''
    dayResult[current.date].push(`${current.start} 〜 ${getNextSlot(current.end)}${mark}`)
  }

  const formatedTimes = Object.keys(dayResult).map((dateStr) => {
    return `${formatDate(dateStr)}\n${dayResult[dateStr].join(' ')}`
  })

  extractedTimes.value = namesHeader + `【日程】\n` + formatedTimes.join('\n')
}

const isOK = (user, isoTime) => {
  const res = user.responses.find((r) => r.start_time === isoTime)
  const status = res ? res.status : 1

  return includeTriangle.value ? status === 1 || status === 2 : status === 1
}

const getNextSlot = (timeStr) => {
  const [hour, min] = timeStr.split(':').map(Number)
  const d = new Date(2000, 0, 1, hour, min + 30)
  return `${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
}

const formatDate = (dateStr) => {
  const date = new Date(dateStr)

  const dayLabels = ['日', '月', '火', '水', '木', '金', '土']
  const day = dayLabels[date.getDay()]

  return `${date.getMonth() + 1}/${date.getDate()}(${day})`
}

const copyText = async () => {
  await navigator.clipboard.writeText(extractedTimes.value)

  isCopied.value = true

  setTimeout(() => {
    isCopied.value = false
  }, 1000)
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
      class="size-6"
    >
      <path
        fill-rule="evenodd"
        d="M10.5 3.75a6.75 6.75 0 1 0 0 13.5 6.75 6.75 0 0 0 0-13.5ZM2.25 10.5a8.25 8.25 0 1 1 14.59 5.28l4.69 4.69a.75.75 0 1 1-1.06 1.06l-4.69-4.69A8.25 8.25 0 0 1 2.25 10.5Z"
        clip-rule="evenodd"
      />
    </svg>

    予定を合わせる
  </h2>

  <div class="mb-6 overflow-hidden rounded-b-lg border border-gray-100 bg-white p-4 shadow-sm">
    <div class="flex flex-col gap-4 sm:flex-row">
      <div class="sm:w-1/3">
        <p class="mb-1 text-xs font-bold text-gray-400">メンバー選択</p>
        <div
          class="mb-3 flex max-h-40 grow flex-col overflow-y-auto rounded border border-gray-100 p-1"
        >
          <label
            v-for="user in event.users"
            :key="user.id"
            class="flex cursor-pointer items-center gap-2 rounded p-1.5 transition hover:bg-blue-50"
          >
            <input
              type="checkbox"
              :value="user.id"
              v-model="selectedUsers"
              class="h-4 w-4 rounded text-blue-500 focus:ring-blue-500"
            />
            <span class="text-sm font-medium text-gray-700">{{ user.name }}</span>
          </label>
        </div>

        <button
          @click="extractTimes"
          class="mt-auto w-full rounded-lg bg-blue-500 px-4 py-2 font-bold text-white shadow transition-all hover:-translate-y-0.5 hover:bg-blue-600 disabled:transform-none disabled:cursor-not-allowed disabled:bg-gray-300"
          :disabled="selectedUsers.length === 0"
        >
          抽出する
        </button>

        <label class="mt-3 flex cursor-pointer items-center">
          <div class="relative">
            <input
              type="checkbox"
              v-model="includeTriangle"
              class="peer sr-only"
            />
            <div
              class="peer h-6 w-10 rounded-full bg-gray-200 transition-colors peer-checked:bg-blue-500 peer-focus:outline-none"
            ></div>
            <div
              class="absolute top-1 left-1 h-4 w-4 rounded-full border border-gray-300 bg-white transition-transform peer-checked:translate-x-4 peer-checked:border-white"
            ></div>
          </div>
          <span class="ml-2 bg-yellow-300 px-0.5 text-sm font-medium text-yellow-600 select-none"
            >▲</span
          >
          <span class="ml-1 text-sm font-medium text-gray-500 select-none">を含める</span>
        </label>
      </div>

      <div class="flex flex-col sm:w-2/3">
        <div class="mb-2 flex items-center justify-between">
          <p class="text-xs font-medium text-gray-400">
            <span v-if="includeTriangle">⚫︎または▲</span>
            <span v-else>⚫︎</span>
            の時間帯
          </p>

          <button
            @click="copyText"
            class="shrink-0 text-sm text-gray-600"
            :class="[
              isCopied
                ? 'cursor-default'
                : 'transform cursor-pointer transition-all duration-200 hover:-translate-y-1',
            ]"
          >
            <template v-if="isCopied">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2.5"
                stroke="currentColor"
                class="size-5"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="m4.5 12.75 6 6 9-13.5"
                />
              </svg>
            </template>

            <template v-else>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="size-5"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M15.666 3.888A2.25 2.25 0 0 0 13.5 2.25h-3c-1.03 0-1.9.693-2.166 1.638m7.332 0c.055.194.084.4.084.612v0a.75.75 0 0 1-.75.75H9a.75.75 0 0 1-.75-.75v0c0-.212.03-.418.084-.612m7.332 0c.646.049 1.288.11 1.927.184 1.1.128 1.907 1.077 1.907 2.185V19.5a2.25 2.25 0 0 1-2.25 2.25H6.75A2.25 2.25 0 0 1 4.5 19.5V6.257c0-1.108.806-2.057 1.907-2.185a48.208 48.208 0 0 1 1.927-.184"
                />
              </svg>
            </template>
          </button>
        </div>
        <textarea
          readonly
          class="h-50 w-full rounded-lg border bg-gray-50 p-3 font-mono text-sm text-gray-700 placeholder-gray-400 focus:outline-none sm:grow"
          :value="extractedTimes"
          :placeholder="`左のリストから予定を合わせたいメンバーを選び、「抽出する」ボタンを押してください。\n抽出した結果は、右上のコピーボタンからコピーしてLINEなどに貼り付けることができます。`"
        ></textarea>
      </div>
    </div>
  </div>
</template>
