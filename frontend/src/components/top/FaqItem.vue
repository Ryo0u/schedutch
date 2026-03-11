<template>
  <div class="border-b border-gray-100 last:border-0">
    <button
      @click="isOpen = !isOpen"
      class="group flex w-full items-center justify-between py-6 text-left transition-colors duration-300 hover:text-blue-600"
    >
      <span class="pr-4 text-base font-bold text-gray-800 group-hover:text-blue-600 sm:text-lg">
        <span class="mr-2 text-blue-500">Q.</span>{{ question }}
      </span>

      <span
        class="relative h-6 w-6 shrink-0 text-gray-400 transition-colors group-hover:text-blue-500"
      >
        <svg
          :class="{ 'rotate-180 opacity-0': isOpen, 'rotate-0 opacity-100': !isOpen }"
          class="absolute inset-0 h-6 w-6 transform transition-all duration-300"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          stroke-width="2"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M12 4.5v15m7.5-7.5h-15"
          />
        </svg>
        <svg
          :class="{ 'rotate-0 opacity-100': isOpen, '-rotate-180 opacity-0': !isOpen }"
          class="absolute inset-0 h-6 w-6 transform transition-all duration-300"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          stroke-width="2"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M19.5 12h-15"
          />
        </svg>
      </span>
    </button>

    <div
      class="grid transition-all duration-300 ease-in-out"
      :class="isOpen ? 'grid-rows-[1fr] opacity-100' : 'grid-rows-[0fr] opacity-0'"
    >
      <div class="overflow-hidden">
        <div class="flex pb-6 text-sm leading-relaxed text-gray-600 sm:text-base">
          <span class="mt-0.5 mr-2 font-bold text-indigo-400">A.</span>
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
  answer: { type: String, required: true },
})

// 開閉状態を管理する変数（最初は閉じているので false）
const isOpen = ref(false)
</script>
