<script setup>
import {ref} from "vue"

const props = defineProps({
  event: { type: Object, required: true }
})

const includeTriangle = ref(false)

const selectedUsers = ref([])
const extractedTimes = ref("")

const isCopied = ref(false)

const extractTimes = () => {
	if (selectedUsers.value.length === 0) {
		extractedTimes.value = "メンバーを選択してください"
		return
	}
	
	const targetUsers = props.event.users.filter(u => selectedUsers.value.includes(u.id))
	
	const memberNames = targetUsers.map(u => u.name).join("、")
	const namesHeader = `【参加者】\n${memberNames}\n`
	
	
	const isOK = (status) => {
		return includeTriangle.value ? (status === 1 || status === 2) : status === 1
	}
	
	const baseAvailableTimes = targetUsers[0].responses.filter(res => isOK(res.status)).map(res => res.start_time)
	
	const okTimes = baseAvailableTimes.filter(time =>{
		return targetUsers.slice(1).every(u => {
			const res = u.responses.find(r => r.start_time === time)
			return res && isOK(res.status)
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
		
		const isTriangle = targetUsers.some(u => {
			const res = u.responses.find(r => r.start_time === isoString)
			return res && res.status === 2
		})
		
		if (!current) {
			current = {date, start: time, end: time, hasTriangle: isTriangle}
		} else {
			if (current.date === date && getNextSlot(current.end) === time) {
				current.end= time
				if (isTriangle) current.hasTriangle = true
			} else {
				if (!dayResult[current.date]) dayResult[current.date] = []
				const mark = current.hasTriangle ? "(▲)" : ""
				dayResult[current.date].push(`${current.start} 〜 ${getNextSlot(current.end)}${mark}`)
				
				current = {date, start: time, end: time, hasTriangle: isTriangle}
			}
		}
	})
	
	if (current) {
    if (!dayResult[current.date]) dayResult[current.date] = []
		const mark = current.hasTriangle ? "(▲)" : ""
    dayResult[current.date].push(`${current.start} 〜 ${getNextSlot(current.end)}${mark}`)
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

const copyText = async () => {
	await navigator.clipboard.writeText(extractedTimes.value)
	
	isCopied.value = true
	
	setTimeout(() => {
		isCopied.value = false
	}, 1000)
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
					
					<label class="flex items-center cursor-pointer mt-3">
            <div class="relative">
              <input type="checkbox" v-model="includeTriangle" class="sr-only peer">
              <div class="w-10 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:bg-blue-500 transition-colors"></div>
              <div class="absolute left-1 top-1 bg-white border border-gray-300 rounded-full h-4 w-4 transition-transform peer-checked:translate-x-4 peer-checked:border-white"></div>
            </div>
						<span class="ml-2 text-sm text-yellow-600 bg-yellow-300 px-0.5 font-medium select-none">▲</span>
            <span class="ml-1 text-sm text-gray-500 font-medium select-none">を含める</span>
          </label>
      	</div>
				
				<div class="sm:w-2/3 flex flex-col">
					<div class="flex justify-between items-center mb-2">
						<p class="text-xs font-medium text-gray-400">
							全員
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
								: 'cursor-pointer hover:-translate-y-1 transform transition-all duration-200'
							]"
						>
							<template v-if="isCopied">
								<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="size-5">
									<path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" />
								</svg>
							</template>
								
							<template v-else>
								<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="size-5">
									<path stroke-linecap="round" stroke-linejoin="round" d="M15.666 3.888A2.25 2.25 0 0 0 13.5 2.25h-3c-1.03 0-1.9.693-2.166 1.638m7.332 0c.055.194.084.4.084.612v0a.75.75 0 0 1-.75.75H9a.75.75 0 0 1-.75-.75v0c0-.212.03-.418.084-.612m7.332 0c.646.049 1.288.11 1.927.184 1.1.128 1.907 1.077 1.907 2.185V19.5a2.25 2.25 0 0 1-2.25 2.25H6.75A2.25 2.25 0 0 1 4.5 19.5V6.257c0-1.108.806-2.057 1.907-2.185a48.208 48.208 0 0 1 1.927-.184" />
								</svg>
							</template>
						</button>
					</div>
					<textarea 
						readonly 
						class="w-full grow  p-3 bg-gray-50 border rounded-lg text-sm font-mono focus:outline-none text-gray-700 placeholder-gray-400"
						:value="extractedTimes"
						:placeholder="`左のリストから予定を合わせたいメンバーを選び、「抽出する」ボタンを押してください。\n抽出した結果は、右上のコピーボタンからコピーしてLINEなどに貼り付けることができます。`"
					></textarea>
      	</div>
			</div>
    </div>
</template>