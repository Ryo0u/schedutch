<script setup>
import {ref} from "vue"

const password =ref("")
const emit = defineEmits(["closeDelete"])
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
			
			<div class="flex justify-center items-center gap-3">
				<button
					@click="emit('closeDelete')"
					class="w-full text-gray-500 hover:text-gray-700 font-bold"
				>
					キャンセル
				</button>
				
				<button
					@click="emit('submitDelete', password)"
					class="w-full text-gray-500 hover:text-gray-700 font-bold"
				>
					削除する
				</button>
			</div>
		</div>
	</div>
</template>