<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'

const router = useRouter()

const title = ref('')
const description = ref('')
const password = ref('')

const selectionMode = ref('range')
const range = ref({ start: null, end: null })
const singleDate = ref(null)
const columns = ref(2)

const defaultStartTime = ref('06:00')
const defaultEndTime = ref('21:00')

const candidates = ref([])

const isSubmitting = ref(false)

const updateColumns = () => {
  columns.value = window.innerWidth < 640 ? 1 : 2
}

onMounted(() => {
  updateColumns()
  window.addEventListener('resize', updateColumns)
})

onUnmounted(() => {
  window.removeEventListener('resize', updateColumns)
})

const changeMode = (mode) => {
  selectionMode.value = mode

  range.value = { start: null, end: null }
  singleDate.value = null
}

const formatDate = (date) => {
  const y = date.getFullYear()
  const m = ('00' + (date.getMonth() + 1)).slice(-2)
  const d = ('00' + date.getDate()).slice(-2)
  return `${y}-${m}-${d}`
}

const formatDisplayDate = (dateStr) => {
  if (!dateStr) return ''

  const date = new Date(dateStr)

  const options = { year: 'numeric', month: 'numeric', day: 'numeric', weekday: 'short' }
  const formatter = new Intl.DateTimeFormat('ja-JP', options)

  return formatter.format(date)
}

const disabledDates = computed(() => {
  return candidates.value.map((c) => new Date(c.date))
})

const addCandidates = () => {
  if (selectionMode.value == 'range') {
    if (!range.value || !range.value.start || !range.value.end) {
      alert('日付を選択してください')
      return
    }

    let current = new Date(range.value.start)
    const end = new Date(range.value.end)

    while (current <= end) {
      const dateStr = formatDate(current)
      const exists = candidates.value.some((c) => c.date === dateStr)

      if (!exists) {
        candidates.value.push({
          date: dateStr,
          start: defaultStartTime.value,
          end: defaultEndTime.value,
        })
      }

      current.setDate(current.getDate() + 1)
    }

    range.value = { start: null, end: null }
  } else {
    if (!singleDate.value) {
      alert('日付を選択してください')
      return
    }

    const dateStr = formatDate(singleDate.value)

    const exists = candidates.value.some((c) => c.date === dateStr)
    if (!exists) {
      candidates.value.push({
        date: dateStr,
        start: defaultStartTime.value,
        end: defaultEndTime.value,
      })
    }
    singleDate.value = null
  }

  candidates.value.sort((a, b) => a.date.localeCompare(b.date))
}

const removeCandidate = (index) => {
  candidates.value.splice(index, 1)
}

const createEvent = async () => {
  if (!title.value || !password.value) {
    alert('イベント名とパスワードを両方入力してください。')
    return
  }

  if (candidates.value.length === 0) {
    alert('候補日が選択されていません。カレンダーから追加してください。')
    return
  }

  const invalidCandidates = candidates.value.filter((c) => !c.start || !c.end)
  if (invalidCandidates.length > 0) {
    alert(
      '時間が入力されていない候補日があります。\n時間を入力するか、不要な場合は「×」ボタンで削除してください。',
    )
    return
  }

  isSubmitting.value = true

  try {
    // 全てチェックOKなので、整形してAPIへ
    const candidatesForApi = candidates.value.map((c) => {
      return {
        start_time: `${c.date}T${c.start}`,
        end_time: `${c.date}T${c.end}`,
      }
    })

    const response = await axios.post('/api/v1/events', {
      event: {
        title: title.value,
        description: description.value,
        password: password.value,
        password_confirmation: password.value,
        candidates_attributes: candidatesForApi,
      },
    })

    router.push(`/events/${response.data.url_token}`)
  } catch (error) {
    console.error(error)
    alert('イベントの作成に失敗しました。')
  } finally {
    isSubmitting.value = false
  }
}

const timeOptions = computed(() => {
  const times = []
  for (let h = 0; h < 24; h++) {
    const hour = String(h).padStart(2, '0')
    times.push(`${hour}:00`)
    times.push(`${hour}:30`)
  }
  times.push('24:00')
  return times
})
</script>

<template>
  <div class="mx-auto max-w-5xl p-6">
    <div class="mb-8 rounded-xl bg-white p-3 shadow-sm">
      <h2 class="flex items-center gap-2 text-2xl font-bold text-gray-700">
        <span class="h-7 w-1 rounded-full bg-blue-500"></span> イベント新規作成
      </h2>
    </div>

    <div class="mb-8 flex flex-col gap-8 lg:flex-row">
      <div class="min-w-75 flex-1 rounded-xl border border-gray-100 bg-white p-6 shadow-sm">
        <h3
          class="mb-6 border-b-2 border-b-blue-500 pb-2 text-center text-xl font-bold text-gray-700"
        >
          Step1 基本情報
        </h3>

        <div class="mb-7">
          <label
            class="mb-2 block font-bold text-gray-600 after:ml-0.5 after:text-red-500 after:content-['*']"
            >イベント名</label
          >
          <input
            v-model="title"
            type="text"
            placeholder="(例) ⚪︎⚪︎の練習日程 "
            class="w-full rounded-lg border border-gray-400 p-2 transition outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div class="mb-7">
          <label class="mb-2 block font-bold text-gray-600">詳細・備考</label>
          <textarea
            v-model="description"
            rows="5"
            placeholder="(例) 持ち物や集合場所"
            class="w-full rounded-lg border border-gray-400 p-2 transition outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
          >
          </textarea>
        </div>

        <div class="mb-3">
          <label
            class="mb-2 block font-bold text-gray-600 after:ml-0.5 after:text-red-500 after:content-['*']"
            >編集用パスワード</label
          >
          <input
            v-model="password"
            type="text"
            class="w-full rounded-lg border border-gray-400 p-2 transition outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
          />
        </div>
      </div>

      <div class="min-w-75 flex-3 rounded-xl border border-gray-100 bg-white p-6 shadow-sm">
        <h3
          class="mb-4 border-b-2 border-b-blue-500 pb-2 text-center text-xl font-bold text-gray-700"
        >
          Step2 候補日を選択
        </h3>

        <div class="mb-6 flex flex-col items-center gap-3 lg:flex-row">
          <div class="flex flex-none justify-center">
            <div class="inline-flex rounded-lg bg-gray-200 p-2">
              <button
                @click="changeMode('range')"
                :class="
                  selectionMode == 'range'
                    ? 'bg-white text-blue-600 shadow-sm'
                    : 'text-gray-500 hover:text-gray-700'
                "
                class="cursor-pointer rounded-md px-6 py-1 text-sm font-bold transition-all duration-200"
              >
                範囲選択
              </button>

              <button
                @click="changeMode('single')"
                :class="
                  selectionMode == 'single'
                    ? 'bg-white text-blue-600 shadow-sm'
                    : 'text-gray-500 hover:text-gray-700'
                "
                class="cursor-pointer rounded-md px-6 py-1 text-sm font-bold transition-all duration-200"
              >
                個別選択
              </button>
            </div>
          </div>

          <p class="w-full flex-1 rounded-full bg-blue-100 py-2 text-center text-sm text-gray-700">
            日付を
            <span
              v-if="selectionMode == 'range'"
              class="border-b-2 border-blue-600 font-bold text-blue-700"
              >ドラッグ</span
            >
            <span
              v-else
              class="border-b-2 border-blue-600 font-bold text-blue-700"
              >クリック</span
            >
            して選択してください
          </p>
        </div>

        <div class="mb-6 flex justify-center">
          <template v-if="selectionMode === 'range'">
            <VDatePicker
              v-model.range="range"
              :columns="columns"
              :disabled-dates="disabledDates"
              expanded
              transparent
              class="w-full"
            />
          </template>

          <template v-else>
            <VDatePicker
              v-model="singleDate"
              :columns="columns"
              :disabled-dates="disabledDates"
              expanded
              transparent
              class="w-full"
            />
          </template>
        </div>

        <div class="flex flex-col items-center justify-between gap-4 lg:flex-row">
          <div class="flex items-center gap-2">
            <span class="text-sm font-bold text-gray-600">時間：</span>

            <div class="relative">
              <select
                v-model="defaultStartTime"
                class="cursor-pointer appearance-none rounded border border-gray-400 bg-white p-2 pr-8 text-gray-700 outline-none hover:bg-gray-50"
              >
                <option
                  v-for="time in timeOptions"
                  :key="time"
                  :value="time"
                >
                  {{ time }}
                </option>
              </select>
              <div
                class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-500"
              >
                <svg
                  class="h-4 w-4 fill-current"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 20 20"
                >
                  <path
                    d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
                  />
                </svg>
              </div>
            </div>

            <span class="text-gray-600">〜</span>

            <div class="relative">
              <select
                v-model="defaultEndTime"
                class="cursor-pointer appearance-none rounded border border-gray-400 bg-white p-2 pr-8 text-gray-700 outline-none hover:bg-gray-50"
              >
                <option
                  v-for="time in timeOptions"
                  :key="time"
                  :value="time"
                >
                  {{ time }}
                </option>
              </select>
              <div
                class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-500"
              >
                <svg
                  class="h-4 w-4 fill-current"
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 20 20"
                >
                  <path
                    d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
                  />
                </svg>
              </div>
            </div>
          </div>

          <button
            @click="addCandidates"
            :disabled="selectionMode === 'range' ? !range?.start || !range?.end : !singleDate"
            class="transform cursor-pointer rounded-full bg-blue-600 px-6 py-2 font-bold text-white shadow-md transition hover:-translate-y-0.5 hover:bg-blue-700 disabled:transform-none disabled:cursor-not-allowed disabled:opacity-50"
          >
            ↓ リストに追加
          </button>
        </div>
      </div>
    </div>

    <div class="rounded-xl border border-gray-100 bg-white p-6 shadow-sm">
      <h3
        class="mb-6 border-b-2 border-b-blue-500 pb-2 text-center text-xl font-bold text-gray-700"
      >
        Step3 登録リスト確認
      </h3>

      <div
        v-if="candidates.length == 0"
        class="rounded-lg border-2 border-dashed border-gray-200 py-10 text-center text-gray-400"
      >
        <p>
          まだ候補日がありません。 <br />
          上のカレンダーから候補日を追加してください。
        </p>
      </div>

      <div
        v-else
        class="mb-8 grid grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-4"
      >
        <div
          v-for="(candidate, index) in candidates"
          :key="index"
          class="relative rounded-lg border border-gray-200 bg-white p-2 shadow-sm transition hover:shadow-md"
        >
          <div
            class="absolute -top-2 -left-2 flex h-5 w-5 items-center justify-center rounded-full bg-blue-400 text-xs font-bold text-white shadow-sm"
          >
            {{ index + 1 }}
          </div>

          <button
            @click="removeCandidate(index)"
            class="absolute -top-2 -right-2 flex h-5 w-5 items-center justify-center rounded-full bg-red-500 text-white shadow-sm transition hover:bg-red-600"
          >
            ×
          </button>

          <div class="text-center">
            <div class="text-md pb-2 font-bold text-gray-800">
              {{ formatDisplayDate(candidate.date) }}
            </div>
            <div class="flex flex-col gap-2 px-2 pb-2">
              <div class="flex items-center gap-2">
                <label class="w-8 text-right text-xs font-bold text-gray-500">開始</label>
                <div class="relative flex-1">
                  <select
                    v-model="candidate.start"
                    class="flex w-full appearance-none rounded border border-gray-300 bg-white p-2 text-sm outline-none focus:ring-1 focus:ring-blue-500"
                  >
                    <option
                      v-for="t in timeOptions"
                      :key="t"
                      :value="t"
                    >
                      {{ t }}
                    </option>
                  </select>
                  <div
                    class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-1 text-gray-400"
                  >
                    <svg
                      class="h-3 w-3 fill-current"
                      viewBox="0 0 20 20"
                    >
                      <path
                        d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
                      />
                    </svg>
                  </div>
                </div>
              </div>

              <div class="flex items-center gap-2">
                <label class="w-8 text-right text-xs font-bold text-gray-500">終了</label>
                <div class="relative flex-1">
                  <select
                    v-model="candidate.end"
                    class="flex w-full appearance-none rounded border border-gray-300 bg-white p-2 text-sm outline-none focus:ring-1 focus:ring-blue-500"
                  >
                    <option
                      v-for="t in timeOptions"
                      :key="t"
                      :value="t"
                    >
                      {{ t }}
                    </option>
                  </select>
                  <div
                    class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-1 text-gray-400"
                  >
                    <svg
                      class="h-3 w-3 fill-current"
                      viewBox="0 0 20 20"
                    >
                      <path
                        d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"
                      />
                    </svg>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="mt-8 flex items-center justify-center border-t border-gray-100 pt-6">
        <button
          @click="createEvent"
          :disabled="isSubmitting || !title || !password || !candidates.length"
          class="text-md w-full transform rounded-full bg-blue-600 px-12 py-3 font-bold text-white shadow-lg transition hover:-translate-y-1 hover:bg-blue-700 hover:shadow-xl disabled:cursor-not-allowed disabled:opacity-50 sm:text-lg lg:w-auto"
        >
          <span v-if="isSubmitting">作成中... </span>
          <span v-else>イベントを作成して公開！</span>
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
