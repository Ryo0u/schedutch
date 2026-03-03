<script setup>
import {ref, computed} from "vue"

const props = defineProps({
  event: { type: Object, required: true }
})

const selectedUsers = ref([])
const extractedTimes = ref("")

const extractTimes = () => {
	if (selectedUsers.value.length === 0) {
		extractedTimes.value = "メンバーを選択してください"
		return
	}
	
	const targetUsers = props.event.users.filter(u => selectedUsers.value.includes(u.id))
	
	const memberNames = targetUsers.map(u => u.name).join("、")
	const namesHeader = `【参加者】\n${memberNames}\n`
	
	const baseAvailableTimes = targetUsers[0].responses.filter(res => res.status === 1).map(res => res.start_time)
	
	const okTimes = baseAvailableTimes.filter(time =>{
		return targetUsers.slice(1).every(u => {
			const res = u.responses.find(r => r.start_time === time)
			return res && res.status === 1
		})
	}).sort()
	
	if (okTimes.length === 0) {
		extractedTimes.value = "選択したメンバーの予定が合う時間はありませんでした..."
		return
	}
	
	const dayResult = {}
	let current = null
	
	okTimes.forEach(isoString => {
		const date = isoString.split("T")[0]
		const time = isoString.split("T")[1].substring(0, 5)
		
		if (!current) {
			current = {date, start: time, end: time}
		} else {
			if (current.date === date && getNextSlot(current.end) === time) {
				current.end= time
			} else {
				if (!dayResult[current.date]) dayResult[current.date] = []
				dayResult[current.date].push(`${current.start} 〜 ${getNextSlot(current.end)}`)
				current = {date, start: time, end: time}
			}
		}
	})
	
	if (current) {
    if (!dayResult[current.date]) dayResult[current.date] = []
    dayResult[current.date].push(`${current.start} 〜 ${getNextSlot(current.end)}`)
  }
	
	const formatedTimes = Object.keys(dayResult).map(dateStr => {
		return `${formatDate(dateStr)}\n${dayResult[dateStr].join(" ")}`
	})
	
	extractedTimes.value = namesHeader + `【日程】\n` + formatedTimes.join("\n")
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

</script>

<template>
    <h2 class="text-lg sm:text-xl font-bold text-gray-700  bg-gray-100 p-3 rounded-t-lg flex items-center gap-2">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
				<path fill-rule="evenodd" d="M10.5 3.75a6.75 6.75 0 1 0 0 13.5 6.75 6.75 0 0 0 0-13.5ZM2.25 10.5a8.25 8.25 0 1 1 14.59 5.28l4.69 4.69a.75.75 0 1 1-1.06 1.06l-4.69-4.69A8.25 8.25 0 0 1 2.25 10.5Z" clip-rule="evenodd" />
			</svg>
			
      予定を合わせる
    </h2>
    
    <div class="bg-white rounded-b-lg shadow-sm border border-gray-100 overflow-hidden mb-6 p-4">
      <div class="flex flex-col sm:flex-row gap-4">
				<div class="sm:w-1/3">
					<p class="text-xs font-bold text-gray-400 mb-1">メンバー選択</p>
					<div class="flex flex-col grow overflow-y-auto max-h-40 mb-3 border border-gray-100 rounded p-1">
            <label v-for="user in event.users" :key="user.id" class="flex items-center gap-2 p-1.5 hover:bg-blue-50 rounded cursor-pointer transition">
              <input type="checkbox" :value="user.id" v-model="selectedUsers" class="w-4 h-4 rounded text-blue-500 focus:ring-blue-500">
              <span class="text-sm font-medium text-gray-700">{{ user.name }}</span>
            </label>
          </div>
          
          <button 
            @click="extractTimes"
            class="w-full bg-blue-500 text-white font-bold py-2 px-4 rounded-lg shadow hover:bg-blue-600 hover:-translate-y-0.5 transition-all disabled:bg-gray-300 disabled:cursor-not-allowed disabled:transform-none mt-auto"
            :disabled="selectedUsers.length === 0"
          >
            抽出する
          </button>
      	</div>
				
				<div class="sm:w-2/3">
					<p class="text-xs font-bold text-gray-400 mb-2">全員⚫︎の時間帯</p>
					<textarea 
						readonly 
						class="w-full h-40 p-3 bg-gray-50 border rounded-lg text-sm font-mono focus:outline-none"
						:value="extractedTimes"
					></textarea>
      	</div>
			</div>
    </div>
</template>