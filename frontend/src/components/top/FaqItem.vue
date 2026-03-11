<template>
  <div class="border-b border-gray-100 last:border-0">
    <button
      @click="isOpen = !isOpen"
      class="flex justify-between items-center w-full py-6 text-left group hover:text-blue-600 transition-colors duration-300"
    >
      <span class="font-bold text-gray-800 group-hover:text-blue-600 text-base sm:text-lg pr-4">
        <span class="text-blue-500 mr-2">Q.</span>{{ question }}
      </span>
      
      <span class="relative shrink-0 w-6 h-6 text-gray-400 group-hover:text-blue-500 transition-colors">
        <svg :class="{'rotate-180 opacity-0': isOpen, 'rotate-0 opacity-100': !isOpen}" class="absolute inset-0 w-6 h-6 transition-all duration-300 transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
        </svg>
        <svg :class="{'rotate-0 opacity-100': isOpen, '-rotate-180 opacity-0': !isOpen}" class="absolute inset-0 w-6 h-6 transition-all duration-300 transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" />
        </svg>
      </span>
    </button>

    <div 
      class="grid transition-all duration-300 ease-in-out"
      :class="isOpen ? 'grid-rows-[1fr] opacity-100' : 'grid-rows-[0fr] opacity-0'"
    >
      <div class="overflow-hidden">
        <div class="pb-6 text-gray-600 leading-relaxed text-sm sm:text-base flex">
          <span class="text-indigo-400 font-bold mr-2 mt-0.5">A.</span>
          <p>{{ answer }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

defineProps({
  question: { type: String, required: true },
  answer: { type: String, required: true }
})

// 開閉状態を管理する変数（最初は閉じているので false）
const isOpen = ref(false)
</script>