<script setup>
const props = defineProps({
  event: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(['openModal', 'deleteEvent'])
</script>
<template>
  <div class=" flex flex-col lg:flex-row gap-5  mb-6">

    <div class="flex-2 bg-white p-4 rounded-lg shadow border border-gray-100">
      <div class="flex  items-baseline justify-between border-b border-gray-300">
        <h1 class="text-3xl text-gray-800 font-bold pb-2 ">{{ props.event.title }}</h1>
        <p 
          @click="emit('deleteEvent')"
          class="text-xs text-gray-400  hover:text-red-600 cursor-pointer transition-colors duration-200"
          >
            イベントを削除する
          </p>
      </div>
      
      <div v-if="event.description" class="flex items-start gap-2 mt-3">
        <span class="text-xs font-bold text-blue-600 bg-blue-100 px-2 py-1 rounded-md whitespace-nowrap mt-1">
        詳細・備考
        </span>
        
        <p class="text-gray-600 leading-relaxed whitespace-pre-wrap">
          {{ props.event.description }}
        </p>
      </div>
    </div>
    
    <div class="flex-1 bg-white p-4 rounded-lg shadow border border-gray-100">
      <button 
        @click="emit('openModal')"
        class="w-full bg-blue-600 text-white text-md font-bold mb-4 py-3 px-6 rounded-full shadow-lg hover:bg-blue-700 hover:-translate-y-1 transition transform"
      >
        <div class="flex justify-center items-center gap-4">
          <span>→</span>
          <span>あなたの予定を追加する</span>
        </div>
      </button>
      
      <p class="mt-2 text-xs text-gray-400 text-center">
        参加者の方はこちらから予定を追加してください
      </p>
    </div>
    
  </div>
</template>