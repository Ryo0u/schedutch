<script setup>
import {ref, computed} from "vue"

const props = defineProps({
  event: { type: Object, required: true },
  candidateDates: { type: Array, required: true }
})

const selectedUsers = ref([])
</script>

<template>
    <h2 class="text-lg sm:text-xl font-bold text-gray-700  bg-gray-100 p-3 rounded-t-lg flex items-center gap-2">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6">
				<path fill-rule="evenodd" d="M10.5 3.75a6.75 6.75 0 1 0 0 13.5 6.75 6.75 0 0 0 0-13.5ZM2.25 10.5a8.25 8.25 0 1 1 14.59 5.28l4.69 4.69a.75.75 0 1 1-1.06 1.06l-4.69-4.69A8.25 8.25 0 0 1 2.25 10.5Z" clip-rule="evenodd" />
			</svg>
			
      予定を探す
    </h2>
    
    <div class="bg-white rounded-b-lg shadow-sm border border-gray-100 overflow-hidden mb-6 p-4">
      <div class="flex flex-col sm:flex-row gap-4">
				<div class="sm:w-1/3">
					<p class="text-xs font-bold text-gray-400 mb-1">メンバー選択</p>
					<label v-for="user in event.users" :key="user.id" class="flex items-center gap-2 p-1 hover:bg-blue-50 rounded cursor-pointer transition">
						<input type="checkbox" :value="user.id" v-model="selectedUsers" class="rounded text-blue-500">
						<span class="text-md">{{ user.name }}</span>
					</label>
      	</div>
				
				<div class="sm:w-2/3">
					<p class="text-xs font-bold text-gray-400 mb-2">全員⚫︎の時間帯</p>
					<textarea 
						readonly 
						class="w-full h-40 p-3 bg-gray-50 border rounded-lg text-sm font-mono focus:outline-none"
						:value="resultText"
					></textarea>
      	</div>
			</div>
    </div>
</template>