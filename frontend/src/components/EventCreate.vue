<script setup>
import {ref, computed, onMounted, onUnmounted} from 'vue'
import axios from 'axios';
import { useRouter } from 'vue-router';

const router = useRouter()

const title = ref('')
const description = ref('')
const password = ref('')

const selectionMode = ref('range')
const range = ref({start: null,end: null})
const singleDate = ref(null)
const columns = ref(2)

const defaultStartTime = ref('06:00')
const defaultEndTime = ref('21:00')

const candidates = ref([])

const isSubmitting =ref(false)

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

const changeMode =(mode) => {
	selectionMode.value = mode
	
	range.value = {start: null,end: null}
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
	
  const options = { month: 'numeric', day: 'numeric', weekday: 'short' }
  const formatter = new Intl.DateTimeFormat('ja-JP', options)
  
  return formatter.format(date)
}

const disabledDates = computed(() => {
  return candidates.value.map(c => new Date(c.date))
})

const addCandidates = () => {
	if(selectionMode.value == "range") {
		if (!range.value || !range.value.start || !range.value.end) {
      alert('日付を選択してください')
      return
    }
		
		let current = new Date(range.value.start)
		const end = new Date(range.value.end)
		
		while (current <= end) {
			const dateStr = formatDate(current)
			const exists = candidates.value.some(c => c.date === dateStr)
			
			if (!exists) {
				candidates.value.push({
					date:  dateStr,
          start: defaultStartTime.value,
          end:   defaultEndTime.value
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
		
		const exists = candidates.value.some(c => c.date === dateStr)
    if (!exists) {
      candidates.value.push({
        date:  dateStr,
        start: defaultStartTime.value,
        end:   defaultEndTime.value
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
	
	const invalidCandidates = candidates.value.filter(c => !c.start || !c.end)
	if (invalidCandidates.length > 0) {
		alert('時間が入力されていない候補日があります。\n時間を入力するか、不要な場合は「×」ボタンで削除してください。')
    return
	}
	
	isSubmitting.value = true
	
	try {
    // 全てチェックOKなので、整形してAPIへ
    const candidatesForApi = candidates.value.map(c => {
      return {
        start_time: `${c.date}T${c.start}`,
        end_time:   `${c.date}T${c.end}`
      }
    })

    const response = await axios.post('http://localhost:3000/api/v1/events', {
      event: {
        title: title.value,
        description: description.value,
        password: password.value,
        password_confirmation: password.value,
        candidates_attributes: candidatesForApi
      }
    })
		
		router.push(`/events/${response.data.url_token}`)
		
	} catch (error) {
		console.error(error)
    alert('イベントの作成に失敗しました。')
	} finally {
    isSubmitting.value = false
  }
}

</script>

<template>
	<div class="max-w-6xl mx-auto p-6">
		<h2 class="text-3xl font-bold text-center text-gray-800 mb-8">
			イベント新規作成
		</h2>
		
		<div class="flex flex-col lg:flex-row gap-8 mb-8">
			
			<div class="flex-1 min-w-75 bg-gray-50 p-6 rounded-xl shadow-sm border border-gray-100">
				
				<h3 class="text-center text-xl font-bold border-b-2 border-b-blue-500 pb-2 mb-6 text-gray-700">
					Step1 基本情報
				</h3>
				
				<div class="mb-7">
					<label class="block font-bold mb-2 text-gray-600 after:ml-0.5 after:text-red-500 after:content-['*']">イベント名</label>
					<input 
						v-model="title" type="text" placeholder="(例) ⚪︎⚪︎の練習日程 "
						class="w-full p-2 border border-gray-400 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
					>
				</div>
				
				<div class="mb-7">
					<label class="block font-bold mb-2 text-gray-600">詳細・備考</label>
					<textarea
						v-model="description" rows="5" placeholder="(例) 持ち物や集合場所"
						class="w-full p-2 border border-gray-400 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
					>
					</textarea>
				</div>
				
				<div class="mb-3">
					<label class="block font-bold mb-2 text-gray-600 after:ml-0.5 after:text-red-500 after:content-['*']">編集用パスワード</label>
					<input 
						v-model="password" type="password"
						class="w-full p-2 border border-gray-400 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
					>
				</div>
				
			</div>
			
			<div class="flex-3 min-w-75 bg-gray-50 p-6 rounded-xl shadow-sm border border-gray-100">
				
				<h3 class="text-center text-xl font-bold border-b-2 border-b-blue-500 pb-2 mb-4 text-gray-700">
					Step2  候補日を選択
				</h3>
				
				<div class="flex flex-col lg:flex-row items-center gap-3 mb-6">
					<div class=" flex-none flex justify-center">
						<div class="inline-flex bg-gray-200 p-2 rounded-lg">
							<button
								@click="changeMode('range')"
								:class="selectionMode == 'range' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500 hover:text-gray-700'"
								class="px-6 py-1 rounded-md text-sm font-bold transition-all duration-200 cursor-pointer"
							>
								範囲選択
							</button>
	
							<button
								@click="changeMode('single')"
								:class="selectionMode == 'single' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500 hover:text-gray-700'"
								class="px-6 py-1 rounded-md text-sm font-bold transition-all duration-200 cursor-pointer"
							>
								個別選択
							</button>
						</div>
					</div>
					
					<p class="flex-1 w-full text-sm text-blue-700 text-center bg-blue-50 rounded-full py-2">
							日付を
							<span v-if="selectionMode =='range'" class="font-bold border-b-2 border-blue-600">ドラッグ</span>
							<span v-else class="font-bold border-b-2 border-blue-600">クリック</span>
							して選択してください
					</p>
				</div>
				
				<div class="mb-6 flex justify-center">
          
          <template v-if="selectionMode === 'range'">
            <VDatePicker 
              v-model.range="range" 
              :columns="columns" 
              :disabled-dates="disabledDates"
              expanded transparent 
              class="w-full" 
            />
          </template>

          <template v-else>
            <VDatePicker 
              v-model="singleDate" 
              :columns="columns" 
              :disabled-dates="disabledDates" 
              expanded transparent 
              class="w-full" 
            />
          </template>

        </div>
				
				<div class="flex flex-col lg:flex-row items-center justify-between gap-4">
					<div class="flex items-center gap-2">
						<span class="font-bold text-gray-600 text-sm">時間：</span>
						<input v-model="defaultStartTime" type="time" class="p-2 border border-gray-400 rounded bg-white text-gray-700 outline-none">
						<span class="text-gray-600">〜</span>
						<input v-model="defaultEndTime" type="time" class="p-2 border border-gray-400 rounded bg-white text-gray-700 outline-none">
					</div>
					
					<button
						@click="addCandidates"
						class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition transform hover:-translate-y-0.5 cursor-pointer"
					>
						↓ リストに追加
					</button>
				</div>
			</div>
		</div>
		
		<div class=" bg-gray-50 p-6 rounded-xl shadow-sm border border-gray-100">
			<h3 class="text-center text-xl font-bold border-b-2 border-b-blue-500 pb-2 mb-6 text-gray-700">
					Step3 登録リスト確認
			</h3>
			
			<div v-if="candidates.length == 0" class="text-center py-10 text-gray-400 border-2 border-dashed border-gray-200 rounded-lg"> 
				<p>まだ候補日がありません。 <br> 上のカレンダーから候補日を追加してください。</p>
			</div>
			
			<div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-8">
				<div 
					v-for="(candidate, index) in candidates"
					:key="index"
          class="relative bg-white border border-gray-200 p-2 rounded-lg shadow-sm hover:shadow-md transition"
				>
				
					<div class="absolute -top-2 -left-2 bg-blue-400 text-white w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold shadow-sm">
            {{ index + 1 }}
          </div>
				
					<button 
            @click="removeCandidate(index)"
            class="absolute -top-2 -right-2 bg-red-500 text-white w-5 h-5 rounded-full flex items-center justify-center shadow-sm hover:bg-red-600 transition"
          >
            ×
          </button>
					
					<div class="text-center">
						<div class="text-lg font-bold text-gray-800 pb-2">
							{{ formatDisplayDate(candidate.date) }}
            </div>
						<div class="space-y-1">
              <div class="flex items-center gap-2">
                <label class="text-xs text-gray-500 font-bold w-8 text-right">開始</label>
                <input 
                  v-model="candidate.start" 
                  type="time"
                  class="flex-1 text-sm p-2 border border-gray-300 rounded focus:ring-1 focus:ring-blue-500 outline-none"
                >
              </div>
              
              <div class="flex items-center gap-2">
                <label class="text-xs text-gray-500 font-bold w-8 text-right">終了</label>
                <input 
                  v-model="candidate.end" 
                  type="time"
                  class="flex-1 text-sm p-2 border border-gray-300 rounded focus:ring-1 focus:ring-blue-500 outline-none"
                  >
              </div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="flex items-center justify-center border-t pt-6 border-gray-100 mt-8">
        
        <button 
          @click="createEvent"
          :disabled="isSubmitting"
          class="w-full lg:w-auto bg-blue-600 hover:bg-blue-700 text-white text-lg font-bold py-3 px-12 rounded-full shadow-lg transition transform hover:-translate-y-1 hover:shadow-xl disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span v-if="isSubmitting">作成中... </span>
          <span v-else>イベントを作成して公開！</span>
        </button>
        
      </div>
		</div>
	</div>
</template>

<style scoped>
</style>