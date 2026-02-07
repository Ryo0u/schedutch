<script setup>
defineProps({
  users: {
    type: Array,
    default: () => []
  }
})
</script>

<template>
    <h2 class="text-xl font-bold text-gray-700  bg-gray-100 p-3 rounded-t-lg flex items-center gap-2">
      <span class="w-1 h-6 bg-blue-400 rounded-full"></span> 参加者一覧
      <span class="text-sm font-normal text-gray-500 ml-2">
        ({{ users ? users.length : 0 }}人)
      </span>
    </h2>
      
    <div class="bg-white rounded-b-lg shadow-sm border border-gray-100 overflow-hidden mb-10">
      <div v-if="users && users.length > 0">
        <ul>
            <li 
                v-for="(user, index) in users" 
                :key="user.id || index"
                class="py-2 px-4 border-b border-gray-100 last:border-none flex items-center gap-3"
              >
                <div class="w-8 h-8 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center font-bold text-sm shrink-0">
                  {{ user.name ? user.name.charAt(0) : '?' }}
                </div>

                <div class="flex items-baseline gap-3 min-w-0">
                  <span class="font-bold text-gray-800 text-sm whitespace-nowrap">
                    {{ user.name }}
                  </span>
                  
                  <span v-if="user.comment" class="text-xs text-gray-600 truncate">
                    {{ user.comment }}
                  </span>
                </div>
              </li>
          </ul>
      </div>
        
      <div v-else class="p-8 text-center text-gray-400">
        <p>まだ回答はありません</p>
      </div>
    </div>
</template>