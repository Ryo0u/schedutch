<script setup>
import {ref} from "vue"

const password = ref("")
const isLoading = ref(false)

const emit = defineEmits(["closeDelete", "submitDelete"])
</script>
<template>
	<div class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center">
		<div class="bg-white p-6 rounded-lg shadow-lg w-96">
			<h2 class="text-xl text-center font-bold text-gray-600 mb-4">イベントを削除する</h2>
			<p class="text-sm text-gray-600 text-center mb-4">削除するには編集用パスワードを入力してください</p>	
			
			<input 
        v-model="password"
        type="text" 
        placeholder="パスワード"
        class="w-full border border-gray-500 p-2 rounded mb-4"
      />
			
			<button
				@click="emit('submitDelete', password), isLoading=true"
				class="w-full border font-bold py-2 rounded-lg flex justify-center items-center transition-all mb-4"
				:class="[
					(!password || isLoading )
						? 'bg-gray-50 text-red-300 border-red-100 cursor-not-allowed'
						: 'bg-white text-red-500 border-red-200 hover:bg-red-50 hover:-translate-y-0.5'
				]"
				:disabled="!password || isLoading"
				
			>
				<template v-if=isLoading>
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="text-red-500 opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            削除中...
				</template>
				<template v-else>
					削除する
				</template>
			</button>
			
			<button
				@click="emit('closeDelete')"
				 class="w-full text-sm text-gray-400 hover:text-gray-600 underline decoration-gray-300 underline-offset-4"
			>
				キャンセルして戻る
			</button>
				
		</div>
	</div>
</template>