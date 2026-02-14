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
		<h2 class="text-lg sm:text-xl font-bold text-gray-700 rounded-t-lg flex items-center gap-2">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-5 sm:size-6">
				<path fill-rule="evenodd" d="M19.902 4.098a3.75 3.75 0 0 0-5.304 0l-4.5 4.5a3.75 3.75 0 0 0 1.035 6.037.75.75 0 0 1-.646 1.353 5.25 5.25 0 0 1-1.449-8.45l4.5-4.5a5.25 5.25 0 1 1 7.424 7.424l-1.757 1.757a.75.75 0 1 1-1.06-1.06l1.757-1.757a3.75 3.75 0 0 0 0-5.304Zm-7.389 4.267a.75.75 0 0 1 1-.353 5.25 5.25 0 0 1 1.449 8.45l-4.5 4.5a5.25 5.25 0 1 1-7.424-7.424l1.757-1.757a.75.75 0 1 1 1.06 1.06l-1.757 1.757a3.75 3.75 0 1 0 5.304 5.304l4.5-4.5a3.75 3.75 0 0 0-1.035-6.037.75.75 0 0 1-.354-1Z" clip-rule="evenodd" />
			</svg>

			イベントURLをシェアする
    </h2>
	</div>
	
	<div class="bg-white rounded-b-lg shadow-sm border border-gray-100 overflow-hidden p-4 mb-10">
		<div class="flex items-center justify-center gap-3">
			<input
				type="text"
				:value="currentUrl"
				readonly
				class="bg-gray-50 border border-gray-300 text-gray-600 text-xs sm:text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 cursor-pointer selection:bg-blue-200"
				@click="$event.target.select()"
			>
			
			<button
				@click="copyURL"
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
		
		<p class="mt-3 text-xs text-gray-400">
      このURLをLINEやメールで参加者に送ってください。<br>
      URLを知っている人だけがイベントにアクセスできます。
    </p>
	</div>
</template>