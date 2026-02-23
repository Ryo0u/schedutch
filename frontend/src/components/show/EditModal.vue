<script setup>
import { ref } from "vue"

defineProps({
  userName: {
    type: String,
    default: ''
  }
})

const password = ref("")
const loadingType = ref(null)

const emit = defineEmits(["closeEdit", "submitEdit", "submitDelete"])
</script>
<template>
  <div class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center">
		<div class="bg-white p-6 rounded-lg shadow-lg w-120">
			<h2 class="text-xl text-center font-bold text-gray-600 mb-4">
				<span>{{ userName }}</span>さんの予定を編集する
			</h2>
			<p class="text-sm text-gray-600 text-center mb-4">予定の変更・削除を行う場合はパスワードを入力してください</p>
			
			<div class="flex justify-center items-center gap-3">
				<input 
        v-model="password"
        type="text" 
        placeholder="パスワード"
        class="w-full border border-gray-500 p-2 rounded mb-4"
        :disabled="loadingType"
      	/>
			</div>
				
				<div class="flex gap-6 mb-3">
        
        <button
          @click="emit('submitEdit', password), loadingType='edit'"
          class="w-full font-bold py-2 rounded-lg shadow transition-all flex justify-center items-center"
          :class="[
            (!password || loadingType != null) 
              ? 'bg-blue-300 text-white cursor-not-allowed' 
              : 'bg-blue-500 text-white hover:bg-blue-600 hover:-translate-y-0.5'
          ]"
          :disabled="!password || loadingType != null"
        >
          <template v-if="loadingType === 'edit'">
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            確認中...
          </template>
          <template v-else>
            編集画面へ進む
          </template>
        </button>
        
        <button
          @click="emit('submitDelete', password), loadingType='delete'"
          class="w-full border font-bold py-2 rounded-lg flex justify-center items-center transition-all"
          :class="[
            (!password || loadingType !== null)
              ? 'bg-gray-50 text-red-300 border-red-100 cursor-not-allowed'
              : 'bg-white text-red-500 border-red-200 hover:bg-red-50 hover:-translate-y-0.5'
          ]"
          :disabled="!password || loadingType != null"
        >
          <template v-if="loadingType === 'delete'">
            <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="text-red-500 opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            確認中
          </template>
          <template v-else>
            削除する
          </template>
        </button>

      </div>
      
      <button
        @click="emit('closeEdit')"
        class="w-full text-sm text-gray-400 hover:text-gray-600 underline decoration-gray-300 underline-offset-4 py-2"
      >
        キャンセルして戻る
      </button>
		</div>
	</div>
</template>