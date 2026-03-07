<script setup>
import { ref } from 'vue'

const isCopied = ref(false)

const shareApp = async () => {
  const shareData = {
    title: 'SCHEDUTCH (スケダッチ)',
    text: 'ログイン不要でサクッと日程調整！回答を考慮して最適な時間を自動抽出します。',
    url: window.location.origin 
  }
  
  if (navigator.share) {
    try {
      await navigator.share(shareData)
    } catch (err) {
      console.log('シェアがキャンセルされました')
    }
  } 
  else {
    try {
      await navigator.clipboard.writeText(shareData.title + shareData.text + shareData.url)
      
      isCopied.value = true
      setTimeout(() => {
        isCopied.value = false
      }, 2000)
    } catch (err) {
      alert('コピーに失敗しました。URLを手動でコピーしてください。')
    }
  }
}
</script>

<template>
  <header class="w-full bg-white/80 backdrop-blur-md border-b border-b-gray-100 border-t-4 border-t-blue-500 shadow-sm transition-all">
    <div class="mx-auto px-2 sm:px-4 h-16 sm:h-20 flex items-center justify-between">
      
      <router-link to="/" class="relative -top-0.5 flex items-center transition-transform hover:-translate-y-0.5 hover:opacity-80 shrink-0">
        <img src="@/assets/images/AppLogo.png" class="h-13 sm:h-18 w-auto object-contain" alt="SCHEDUTCH" />
      </router-link>

      <div class="flex items-center gap-1 sm:gap-5">
        
        <router-link to="/" class="group flex flex-col items-center justify-center bg-white text-gray-700 px-4 py-1.5 sm:px-10 rounded-full shadow-sm border border-gray-200 hover:border-blue-300 hover:text-blue-600 hover:shadow-md hover:-translate-y-0.5 transition-all duration-300 active:scale-95 leading-tight">
          <span class="text-xs sm:text-sm font-bold flex items-center gap-1">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="size-3.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="m2.25 12 8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
            </svg>
            Top
          </span>
          <span class="text-[10px] text-gray-400 font-medium mt-0.5 group-hover:text-blue-400 transition-colors">トップ</span>
        </router-link>
        
        <router-link to="/new" class="group flex flex-col items-center justify-center bg-white text-gray-700 px-4 py-1.5 sm:px-10 rounded-full shadow-sm border border-gray-200 hover:border-blue-300 hover:text-blue-600 hover:shadow-md hover:-translate-y-0.5 transition-all duration-300 active:scale-95 leading-tight">
          <span class="text-xs sm:text-sm font-bold flex items-center gap-1">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="size-4 transition-transform duration-300">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
            New
          </span>
          <span class="text-[10px] text-gray-400 font-medium mt-0.5 group-hover:text-blue-400 transition-colors">予定作成</span>
        </router-link>

        <div class="hidden sm:block w-px h-8 bg-gray-200"></div>

        <a 
          href="https://github.com/Ryo0u/schedutch" 
          target="_blank" 
          rel="noopener noreferrer"
          class="flex items-center justify-center text-gray-400 hover:text-gray-800 transition-all duration-300 hover:-translate-y-0.5"
          title="GitHubリポジトリを見る"
        >
          <svg viewBox="0 0 24 24" aria-hidden="true" class="h-6 w-6 sm:h-7 sm:w-7 fill-current block">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"></path>
          </svg>
        </a>
        
        <button 
          @click="shareApp"
          class="flex items-center justify-center transition-all duration-300 hover:-translate-y-0.5 cursor-pointer"
          :class="isCopied ? 'text-green-500' : 'text-gray-400 hover:text-gray-800'"
          title="アプリをシェアする"
        >
          <svg v-if="isCopied" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="h-6 w-6 sm:h-7 sm:w-7 block">
            <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5" />
          </svg>
          
          <svg v-else xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.8" stroke="currentColor" class="h-5 w-5 sm:h-7 sm:w-7 block">
            <path stroke-linecap="round" stroke-linejoin="round" d="M7.217 10.907a2.25 2.25 0 1 0 0 2.186m0-2.186c.18.324.283.696.283 1.093s-.103.77-.283 1.093m0-2.186 9.566-5.314m-9.566 7.5 9.566 5.314m0 0a2.25 2.25 0 1 0 3.935 2.186 2.25 2.25 0 0 0-3.935-2.186Zm0-12.814a2.25 2.25 0 1 0 3.933-2.185 2.25 2.25 0 0 0-3.933 2.185Z" />
          </svg>
        </button>

      </div>
    </div>
  </header>
  
  <div class="min-h-screen bg-slate-100 relative overflow-hidden">
  
  <div class="absolute inset-0 z-0 opacity-[0.06]" 
       style="background-image: linear-gradient(#3b82f6 1px, transparent 1px), linear-gradient(90deg, #3b82f6 1px, transparent 1px); background-size: 40px 40px;">
  </div>
  
  <div class="relative z-10">
    <router-view/>
  </div>
</div>
</template>