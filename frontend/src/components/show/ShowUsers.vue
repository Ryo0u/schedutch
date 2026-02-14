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
    <h2 class="text-xl font-bold text-gray-700  bg-gray-100 p-3 rounded-t-lg flex items-center gap-2">
      <span class="w-1 h-6 bg-blue-400 rounded-full"></span> 参加者一覧
      <span class="text-sm font-normal text-gray-500 ml-2">
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
                  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6 text-blue-600">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                  </svg>

  
                  <div class="flex items-baseline gap-3 min-w-0">
                    <span class="font-bold text-gray-800 text-sm whitespace-nowrap">
                      {{ user.name }}
                    </span>
                    
                    <div v-if="user.comment" class="relative ml-2 px-3 py-1 bg-white text-gray-600 text-sm rounded-lg max-w-180 border border-gray-400">
                      <div class="absolute top-1/2 -left-[3.5px] -translate-y-1/2 w-1.5 h-1.5 bg-white rotate-45 border-l border-b border-gray-400"></div>

                      <span class="relative z-10 truncate">
                        {{ user.comment }}
                      </span>
                    </div>
                  </div>
                </div>
               
                <button
                  @click="emit('openEdit',user)"
                  class="text-xs text-blue-400 hover:text-blue-500 font-bold border-b border-blue-400 hover:border-b-blue-500 px-1 py-0.5  transition-colors whitespace-nowrap cursor-pointer"
                >
                  予定を編集
                </button>

              </li>
          </ul>
      </div>
        
      <div v-else class="p-8 text-center text-gray-400">
        <p>まだ回答はありません</p>
      </div>
    </div>
</template>