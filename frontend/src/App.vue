<script setup>
</script>

<template>
  <header class="w-full top-0 z-40 bg-white backdrop-blur-md border-b border-b-gray-100 border-t-4 border-t-blue-500 shadow-sm transition-all">
    <div class="max-w-5xl mx-auto px-4 h-16 sm:h-20 flex items-center justify-between">
      
      <router-link to="/" class="flex items-center transition-transform hover:-translate-y-0.5 hover:opacity-80 shrink-0">
        <img src="@/assets/AppLogo.png" class="h-13 sm:h-18 w-auto object-contain" alt="SCHEDUTCH" />
      </router-link>

      <div class="flex items-center gap-3 sm:gap-6">
        <router-link to="/" class="group flex flex-col items-center justify-center bg-white text-gray-700 px-4 py-1.5 sm:px-6 rounded-full shadow-sm border border-gray-200 hover:border-blue-300 hover:text-blue-600 hover:shadow-md hover:-translate-y-0.5 transition-all duration-300 active:scale-95 leading-tight">
          <span class="text-xs sm:text-sm font-bold flex items-center gap-1">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="size-3.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="m2.25 12 8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
            </svg>
            Top
          </span>
          <span class="text-[10px] text-gray-400 font-medium mt-0.5 group-hover:text-blue-400 transition-colors">トップ</span>
        </router-link>
        
        <router-link to="/events/new" class="group flex flex-col items-center justify-center bg-linear-to-r from-blue-500 to-indigo-500 text-white px-4 py-1.5 sm:px-6 rounded-full shadow-md shadow-blue-500/30 hover:shadow-lg hover:shadow-blue-500/50 hover:-translate-y-0.5 transition-all duration-300 active:scale-95 leading-tight border border-transparent">
          <span class="text-xs sm:text-sm font-bold flex items-center gap-1">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="size-4 transition-transform duration-300">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
            New
          </span>
          <span class="text-[10px] text-blue-100 font-medium mt-0.5 group-hover:text-white transition-colors">予定作成</span>
        </router-link>
      </div>
      
    </div>
  </header>
  
  <div class="bg-blue-50 min-h-screen">
    <router-view/>
  </div>
</template>