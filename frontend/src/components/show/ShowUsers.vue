<script setup>
defineProps({
  users: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(["openEdit"])
</script>

<template>
    <h2 class="text-lg sm:text-xl font-bold text-gray-700  bg-gray-100 p-3 rounded-t-lg flex items-center gap-2">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-5 sm:size-6">
        <path fill-rule="evenodd" d="M8.25 6.75a3.75 3.75 0 1 1 7.5 0 3.75 3.75 0 0 1-7.5 0ZM15.75 9.75a3 3 0 1 1 6 0 3 3 0 0 1-6 0ZM2.25 9.75a3 3 0 1 1 6 0 3 3 0 0 1-6 0ZM6.31 15.117A6.745 6.745 0 0 1 12 12a6.745 6.745 0 0 1 6.709 7.498.75.75 0 0 1-.372.568A12.696 12.696 0 0 1 12 21.75c-2.305 0-4.47-.612-6.337-1.684a.75.75 0 0 1-.372-.568 6.787 6.787 0 0 1 1.019-4.38Z" clip-rule="evenodd" />
        <path d="M5.082 14.254a8.287 8.287 0 0 0-1.308 5.135 9.687 9.687 0 0 1-1.764-.44l-.115-.04a.563.563 0 0 1-.373-.487l-.01-.121a3.75 3.75 0 0 1 3.57-4.047ZM20.226 19.389a8.287 8.287 0 0 0-1.308-5.135 3.75 3.75 0 0 1 3.57 4.047l-.01.121a.563.563 0 0 1-.373.486l-.115.04c-.567.2-1.156.349-1.764.441Z" />
      </svg>

      参加者一覧
      
      <span class="text-xs sm:text-sm font-normal text-gray-500 ml-2">
        ({{ users ? users.length : 0 }}人)
      </span>
    </h2>
      
    <div class="bg-white rounded-b-lg shadow-sm border border-gray-100 overflow-hidden mb-6">
      <div v-if="users && users.length > 0">
        <ul>
            <li 
                v-for="(user, index) in users" 
                :key="user.id || index"
                class="py-2 px-4 border-b border-gray-100 last:border-none flex items-center justify-between gap-3"
              >
                <div class="flex items-center gap-3 overflow-hidden py-1">
                  <div class="flex items-center gap-3 min-w-0">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-5 sm:size-6 text-blue-400">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M17.982 18.725A7.488 7.488 0 0 0 12 15.75a7.488 7.488 0 0 0-5.982 2.975m11.963 0a9 9 0 1 0-11.963 0m11.963 0A8.966 8.966 0 0 1 12 21a8.966 8.966 0 0 1-5.982-2.275M15 9.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
                    </svg>
                    
                    <span class="font-bold text-gray-800 text-xs sm:text-sm whitespace-nowrap">
                      {{ user.name }}
                    </span>
                  </div>
                    
                    <div v-if="user.comment" class="relative ml-2 px-3 py-1 bg-white text-gray-600 text-xs sm:text-sm rounded-lg max-w-30 md:max-w-120 lg:max-w-180 border border-gray-400">
                      <div class="absolute top-1/2 -left-[3.5px] -translate-y-1/2 w-1.5 h-1.5 bg-white rotate-45 border-l border-b border-gray-400"></div>

                      <span class="relative z-10">
                        {{ user.comment }}
                      </span>
                    </div>
                </div>
               
                <button
                  @click="emit('openEdit',user)"
                  class="text-xs sm:text-xs text-blue-400 hover:text-blue-500 font-bold border-b border-blue-400 hover:border-b-blue-500 px-1 py-0.5  transition-colors whitespace-nowrap cursor-pointer"
                >
                  予定を編集
                </button>

              </li>
          </ul>
      </div>
        
      <div v-else class="p-6 text-center text-gray-400">
        <p>まだ回答はありません</p>
      </div>
    </div>
</template>