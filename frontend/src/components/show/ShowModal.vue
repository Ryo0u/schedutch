<script setup>
import { ref } from "vue"
import ModalTable from "./ModalTable.vue"

const props = defineProps({
  event: {
    type: Object,
    required: true
  }
})

const emit = defineEmits(["close"])

const isExpanded = ref(true)

const toggleMinimize = () => {
  isExpanded.value = !isExpanded.value
}
</script>

<template>
  <div
    class="fixed inset-0 z-40 flex p-4 transition-all duration-300"
    :class="isExpanded ? 'bg-black/50 justify-center items-center' : 'pointer-events-none justify-end items-end'"
  >
    <div 
      class="bg-white rounded-xl shadow-2xl flex flex-col border-5 border-blue-100 overflow-hidden transition-all duration-300 pointer-events-auto"
      :class="isExpanded ? 'w-full max-w-4xl max-h-[90vh]' : 'w-60 shadow-lg'"
    >
      <div class="bg-blue-100 flex items-center justify-between p-4 border-b border-gray-100" @click="isExpanded = true">
        <h3 class="font-bold text-gray-500 truncate" :class="isExpanded ? 'text-xl' : 'text-xs'">
          {{ isExpanded ? 'あなたの予定を入力する' : '入力を再開する' }}
        </h3>
        
        <div class="flex item-center gap-2 shrink-0">
          <button 
            @click.stop="toggleMinimize"
            class="text-xl text-gray-400 hover:text-gray-600 w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-200 transition cursor-pointer"
          >
            {{ isExpanded ? 'ー' : '◻︎' }}
          </button>
          
          <button
            @click="emit('close')"
            class="text-2xl text-gray-400 hover:text-gray-600 w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-200 transition pb-1.5  cursor-pointer"
          >
            ×
          </button>
        </div>
        
      </div>
      
      <div v-if="isExpanded" class="p-6 overflow-y-auto">
        <div class="max-w-5xl mx-auto">	
					<div class="border-b border-gray-200 pb-8 mb-3">

						<div class="flex flex-col md:flex-row gap-6 mb-6">
							
							<div class="w-full md:w-1/2 flex items-center gap-4">
								<span class="w-20 text-sm font-bold text-gray-600 whitespace-nowrap shrink-0">名前:</span>
								<input type="text" class="w-full border-2 border-gray-400 rounded px-3 py-2 text-gray-700 focus:outline-none focus:border-blue-500">
							</div>

							<div class="w-full md:w-1/2 flex items-center gap-4">
								<span class="w-20 text-sm font-bold text-gray-600 whitespace-nowrap shrink-0">パスワード:</span>
								<input type="text" class="w-full border-2 border-gray-400 rounded px-3 py-2 text-gray-700 focus:outline-none focus:border-blue-500">
							</div>
							
						</div>

						<div class="flex gap-4">
							<span class="w-20 text-sm font-bold text-gray-600 whitespace-nowrap shrink-0 pt-2">コメント:</span>
							<textarea rows="2" class="w-full border-2 border-gray-400 rounded px-3 py-2 text-gray-700 focus:outline-none focus:border-blue-500"></textarea>
						</div>

					</div>
					
					<ModalTable
           :event="props.event"
          />
          
				</div>
      </div>
    </div>
  </div>
</template>