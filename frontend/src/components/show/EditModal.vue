<script setup>
import { ref } from "vue"

defineProps({
  userName: {
    type: String,
    default: ''
  }
})

const password = ref("")

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
      	/>
			</div>
				
				<div class="flex gap-6 mb-3">
        
        <button
          @click="emit('submitEdit', password)"
          class="w-full bg-blue-500 text-white font-bold py-2 rounded-lg shadow hover:bg-blue-600 hover:-translate-y-0.5 transition-all"
          :disabled="!password"
        >
          編集画面へ進む
        </button>
        
        <button
          @click="emit('submitDelete', password)"
          class="w-full bg-white text-red-500 border border-red-200 font-bold py-2 rounded-lg hover:bg-red-50 hover:-translate-y-0.5 transition-all"
          :disabled="!password"
        >
          削除する
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