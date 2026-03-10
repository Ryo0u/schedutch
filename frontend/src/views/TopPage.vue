<script setup>
</script>

<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 via-white to-indigo-100 font-sans text-gray-800">
    
    <section class="relative w-full min-h-[calc(100dvh-4rem)] sm:min-h-[calc(100dvh-5rem)] flex flex-col justify-center items-center px-4 text-center bg-slate-50 overflow-hidden">
  
      <div class="absolute inset-0 overflow-hidden pointer-events-none z-0">
        <div class="absolute -top-[20%] -right-[10%] w-[70%] h-[70%] rounded-full bg-linear-to-br from-blue-200/50 to-indigo-300/40 blur-[100px] sm:blur-[150px]"></div>
        <div class="absolute -bottom-[20%] -left-[10%] w-[60%] h-[60%] rounded-full bg-linear-to-tr from-cyan-100/50 to-blue-200/40 blur-[100px] sm:blur-[150px]"></div>
      </div>

      <div class="relative z-10 max-w-4xl mx-auto w-full pt-10">
        
        <p class="animate-fade-in-up text-blue-700 font-bold tracking-[0.25em] text-xs sm:text-sm mb-6 uppercase">
          Smart Scheduling
        </p>

        <h1 class="animate-fade-in-up animation-delay-200 text-4xl md:text-5xl lg:text-6xl font-extrabold tracking-tight mb-8 leading-tight text-slate-800">
          空いてる時間が<br class="block" />
          <span class="text-transparent bg-clip-text bg-linear-to-r from-blue-600 to-indigo-600">一瞬でわかる。</span>
        </h1>
        
        <p class="animate-fade-in-up animation-delay-400 text-sm md:text-lg text-slate-500 mb-8 max-w-2xl mx-auto leading-relaxed font-medium">
          SCHEDUTCHは「大量の予定」を調整するための特化型ツール。<br class="hidden sm:block" />
          メンバーの回答を考慮して最適な時間帯を自動抽出し、<br class="hidden sm:block" />
          どんなに多い候補日でも、全員の回答を集計・視覚化します。
        </p>
        
        <div class="animate-fade-in-up animation-delay-400 flex justify-center mb-6">
          <router-link 
            to="/new" 
            class="group inline-flex items-center justify-center gap-2 bg-white/80 backdrop-blur-md border border-slate-200 text-slate-600 text-sm sm:text-base font-bold px-8 py-3.5 rounded-full shadow-sm hover:shadow-md hover:border-blue-300 hover:text-blue-600 hover:-translate-y-0.5 transition-all duration-300 active:scale-95"
          >
            <span>新しく予定を作成する</span>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4 group-hover:translate-x-1 transition-transform duration-300">
              <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3" />
            </svg>
          </router-link>
        </div>

        <p class="animate-fade-in-up animation-delay-400 text-xs text-slate-400">
          ※登録不要・完全無料ですぐに使えます。
        </p>
      </div>

      <div class="absolute bottom-4 sm:bottom-8 left-1/2 -translate-x-1/2 animate-bounce flex flex-col items-center gap-2 text-slate-300 z-10 pointer-events-none">
        <span class="text-[10px] tracking-[0.2em] uppercase font-bold">Scroll</span>
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
          <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
        </svg>
      </div>
    </section>

    <section class="max-w-5xl mx-auto px-4 py-20">
      <h2 class="text-2xl md:text-3xl font-bold text-center mb-12 text-gray-700">使い方・特徴</h2>
      
      <div class="max-w-5xl grid md:grid-cols-2 gap-8">
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow duration-300">
          <div class="border-b border-gray-100 aspect-video relative flex items-center justify-center p-4">
            <div class="absolute top-3 left-3 bg-gray-900 text-white w-8 h-8 rounded-full flex items-center justify-center font-bold shadow-md z-10">1</div>
            <img
							src="@/assets/images/step_create.png"
							alt="イベント作成画面"
							class="shadow-md shadow-indigo-200"
						/>
          </div>
          <div class="p-6">
            <h3 class="font-bold text-gray-800 mb-2 text-center">イベントを作成</h3>
            <p class="text-sm text-gray-600 text-center leading-relaxed">イベント名と候補日・時間を選んで、専用のURLを発行します。</p>
          </div>
        </div>
        
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow duration-300">
          <div class="border-b border-gray-100 aspect-video relative flex items-center justify-center p-4">
            <div class="absolute top-3 left-3 bg-gray-900 text-white w-8 h-8 rounded-full flex items-center justify-center font-bold shadow-md z-10">2</div>
            <img
							src="@/assets/images/step_answer.png"
							alt="予定入力画面"
							class="shadow-md shadow-indigo-200"
						/>
          </div>
          <div class="p-6">
            <h3 class="font-bold text-gray-800 mb-2 text-center">メンバーに入力してもらう</h3>
            <p class="text-sm text-gray-600 text-center leading-relaxed">発行したURLをLINEなどで共有。メンバーはログイン不要で即座に出欠を入力できます。</p>
          </div>
        </div>
        
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow duration-300">
          <div class="border-b border-gray-100 aspect-video relative flex items-center justify-center p-4">
            <div class="absolute top-3 left-3 bg-gray-900 text-white w-8 h-8 rounded-full flex items-center justify-center font-bold shadow-md z-10">3</div>
            <img
							src="@/assets/images/step_show.png"
							alt="予定閲覧画面"
							class="shadow-md shadow-indigo-200"
						/>
          </div>
          <div class="p-6">
            <h3 class="font-bold text-gray-800 mb-2 text-center">メンバーの予定を確認</h3>
            <p class="text-sm text-gray-600 text-center leading-relaxed">誰がいつ空いているか、直感的な表でパッと一目で確認できます。</p>
          </div>
        </div>
				
				<div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow duration-300">
          <div class="border-b border-gray-100 aspect-video relative flex items-center justify-center p-4">
            <div class="absolute top-3 left-3 bg-gray-900 text-white w-8 h-8 rounded-full flex items-center justify-center font-bold shadow-md z-10">4</div>
            <img
							src="@/assets/images/step_extract.png"
							alt="予定抽出画面"
							class="shadow-md shadow-indigo-200"
						/>
          </div>
          <div class="p-6">
            <h3 class="font-bold text-gray-800 mb-2 text-center">候補時間を抽出して確定</h3>
            <p class="text-sm text-gray-600 text-center leading-relaxed">候補時間をワンタップで抽出し、最適な日程をサクッと決定！</p>
          </div>
        </div>
      </div>
    </section>
		
    <footer class="w-full bg-gray-500 text-slate-300 py-12">
      <div class="max-w-5xl mx-auto px-4 flex flex-col md:flex-row justify-between items-center md:items-start gap-8">
        
        <div class="flex flex-col items-center md:items-start">
          <router-link to="/" class="flex items-center gap-2 mb-3 hover:opacity-80 transition-opacity">
            <img src="@/assets/images/AppLogo.png" alt="SCHEDUTCH" class="h-8 w-auto grayscale brightness-200" />
          </router-link>
          <p class="text-xs text-slate-400">サクッと決まる、日程調整の最適解。</p>
        </div>

        <div class="flex flex-wrap justify-center gap-6 text-sm font-medium">
          <a href="#" class="hover:text-white transition-colors">利用規約</a>
          <a href="#" class="hover:text-white transition-colors">プライバシーポリシー</a>
          <a href="https://github.com/Ryo0u/schedutch" target="_blank" rel="noopener noreferrer" class="hover:text-white transition-colors flex items-center gap-1">
            GitHub
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
              <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 6H5.25A2.25 2.25 0 0 0 3 8.25v10.5A2.25 2.25 0 0 0 5.25 21h10.5A2.25 2.25 0 0 0 18 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" />
            </svg>
          </a>
        </div>
        
      </div>
      
      <div class="max-w-5xl mx-auto px-4 mt-8 pt-8 border-t border-slate-700 text-center text-xs text-slate-500 font-mono">
        &copy; 2026 SCHEDUTCH. All rights reserved.
      </div>
    </footer>

    

  </div>
</template>
<style scoped>
@keyframes fadeInUp {
  0% {
    opacity: 0;
    transform: translateY(20px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in-up {
  opacity: 0; 
  animation: fadeInUp 0.8s ease-out forwards;
}


.animation-delay-200 {
  animation-delay: 0.2s;
}

.animation-delay-400 {
  animation-delay: 0.4s;
}
</style>