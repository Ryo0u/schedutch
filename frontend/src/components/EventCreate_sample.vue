<script setup>
import { ref, computed } from 'vue' // computed を忘れずに！

// --- Part 1の変数（そのまま） ---
const title = ref('')
const description = ref('')
const password = ref('')

// --- ▼▼▼ ここから Part 2 (カレンダー用) ▼▼▼ ---

// 1. カレンダーの範囲選択用
const range = ref({ start: null, end: null })

// 2. 候補日リスト（空っぽの配列）
const candidates = ref([])

// 3. 時間のデフォルト値
const defaultStartTime = ref('19:00')
const defaultEndTime = ref('21:00')

// 4. 日付フォーマット関数 (YYYY-MM-DD)
const formatDate = (date) => {
  const y = date.getFullYear()
  const m = ('00' + (date.getMonth() + 1)).slice(-2)
  const d = ('00' + date.getDate()).slice(-2)
  return `${y}-${m}-${d}`
}

// 5. すでに追加された日を選択不可にする設定
const disabledDates = computed(() => {
  return candidates.value.map(c => new Date(c.start_time))
})

// 6. 「追加」ボタンを押したときの処理
const addRange = () => {
  // 範囲が選ばれてなかったら怒る
  if (!range.value || !range.value.start || !range.value.end) {
    alert('カレンダーで期間を選択してください！')
    return
  }

  let current = new Date(range.value.start)
  const end = new Date(range.value.end)

  // 開始日から終了日までループ！
  while (current <= end) {
    const dateStr = formatDate(current)
    
    // 重複チェック
    const exists = candidates.value.some(c => c.start_time.startsWith(dateStr))
    
    if (!exists) {
      candidates.value.push({
        start_time: `${dateStr}T${defaultStartTime.value}`,
        end_time:   `${dateStr}T${defaultEndTime.value}`
      })
    }
    // 1日進める
    current.setDate(current.getDate() + 1)
  }
  
  // 日付順に並び替えて、カレンダー選択をリセット
  candidates.value.sort((a, b) => a.start_time.localeCompare(b.start_time))
  range.value = { start: null, end: null }
}
</script>

<template>
  <div class="max-w-6xl mx-auto p-6">
    
    <h2 class="text-3xl font-bold text-center text-gray-800 mb-8">
      イベント新規作成
    </h2>

    <div class="flex flex-col lg:flex-row gap-8">
      
      <div class="flex-1 min-w-75 bg-white p-6 rounded-xl shadow-sm border border-gray-100">
        
        <h3 class="text-xl font-bold text-center border-b-2 border-emerald-500 pb-2 mb-6 text-gray-700">
          1. 基本情報
        </h3>
        
        <div class="mb-6">
          <label class="block font-bold mb-2 text-gray-600">イベント名</label>
          <input 
            v-model="title" 
            type="text" 
            placeholder="例: 夏の温泉旅行"
            class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition"
          >
        </div>
        
        <div class="mb-6">
          <label class="block font-bold mb-2 text-gray-600">詳細・メモ</label>
          <textarea 
            v-model="description" 
            rows="5" 
            placeholder="持ち物や集合場所など"
            class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition"
          ></textarea>
        </div>

        <div class="mb-2">
          <label class="block font-bold mb-2 text-gray-600">編集用パスワード</label>
          <input 
            v-model="password" 
            type="password"
            class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition"
          >
        </div>
      </div>

      <div class="flex-22 min-w-75 bg-white p-6 rounded-xl shadow-sm border border-gray-100">
        
        <h3 class="text-center text-xl font-bold border-b-2 border-b-blue-500 pb-2 mb-6 text-gray-700">
          Step2 候補日を選択
        </h3>

        <div class="flex justify-center mb-4">
          <div class="inline-flex bg-gray-100 p-1 rounded-lg">
            <button 
              @click="selectionMode = 'range'"
              :class="selectionMode === 'range' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500 hover:text-gray-700'"
              class="px-4 py-2 rounded-md text-sm font-bold transition-all"
            >
              範囲選択モード
            </button>
            
            <button 
              @click="selectionMode = 'single'"
              :class="selectionMode === 'single' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500 hover:text-gray-700'"
              class="px-4 py-2 rounded-md text-sm font-bold transition-all"
            >
              個別選択モード
            </button>
          </div>
        </div>

        <p class="text-sm text-center text-gray-500 mb-4">
          <span v-if="selectionMode === 'range'">期間をドラッグして選択してください</span>
          <span v-else>日付をポチッとクリックしてください</span>
        </p>

        <div class="mb-6 flex justify-center">
          
          <VDatePicker 
            v-if="selectionMode === 'range'"
            v-model.range="range" 
            mode="date"
            :columns="2"
            :disabled-dates="disabledDates"
            expanded borderless transparent
            class="w-full"
          />

          <VDatePicker 
            v-else
            v-model="singleDate" 
            mode="date"
            :columns="2"
            :disabled-dates="disabledDates"
            expanded borderless transparent
            class="w-full"
          />
          
        </div>

        <div class="bg-blue-50 p-4 rounded-xl flex flex-col sm:flex-row items-center justify-between gap-4">
          <div class="flex items-center gap-2">
            <span class="font-bold text-gray-600 text-sm">時間:</span>
            <input v-model="defaultStartTime" type="time" class="p-2 border border-blue-200 rounded bg-white text-gray-700 outline-none">
            <span class="text-gray-400">〜</span>
            <input v-model="defaultEndTime" type="time" class="p-2 border border-blue-200 rounded bg-white text-gray-700 outline-none">
          </div>
          
          <button 
            @click="addCandidates" 
            class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition transform hover:-translate-y-0.5"
          >
            ↓ リストに追加
          </button>
        </div>

      </div>

    </div>
  </div>
</template>

<style scoped>
/* Tailwindを使うので、CSSは空っぽでOKです！ */
</style>