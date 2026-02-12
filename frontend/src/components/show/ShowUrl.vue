<script setup>
import { ref } from "vue"

const currentUrl = window.location.href
const isCopied = ref(false)

const copyURL = async () => {
	await navigator.clipboard.writeText(currentUrl)
	
	isCopied.value = true
	
	setTimeout(() => {
		isCopied.value = false
	}, 1000)
}

</script>
<template>
	
	<div class="bg-gray-100 p-4 rounded-t-lg shadow border border-gray-100">
		<h2 class="text-md font-bold text-gray-700 rounded-t-lg flex items-center gap-2">
      <span class="w-1 h-6 bg-blue-400 rounded-full"></span> イベントURLをシェアする
    </h2>
	</div>
	
	<div class="bg-white rounded-b-lg shadow-sm border border-gray-100 overflow-hidden p-4 mb-10">
		<div class="flex items-center justify-center gap-5">
			<input
				type="text"
				:value="currentUrl"
				readonly
				class="bg-gray-50 border border-gray-300 text-gray-600 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 cursor-pointer selection:bg-blue-200"
				@click="$event.target.select()"
			>
			
			<button
				@click="copyURL"
				class="shrink-0 font-bold py-2.5 px-5 rounded-lg text-sm text-gray-600  w-33"
				:class="[
					isCopied 
					? 'bg-blue-100 cursor-default' 
					: 'bg-blue-50 cursor-pointer hover:bg-blue-100 hover:-translate-y-1 transform transition-all duration-200'
				]"
			>
				<span v-if="isCopied" class="flex items-center justify-center gap-1">
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="size-4">
            <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" />
          </svg>
          コピー完了
				</span>
					
				<span v-else>URLをコピー</span>	
			</button>
		</div>
		
		<p class="mt-3 text-xs text-gray-400">
      このURLをLINEやメールで参加者に送ってください。<br>
      URLを知っている人だけがイベントにアクセスできます。
    </p>
	</div>
</template>