<script setup>
import { ref } from 'vue'
</script>

<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 via-white to-indigo-100 font-sans text-gray-800">
    
    <section class="max-w-5xl mx-auto px-4 pt-40 pb-35 text-center mb-5">
			`<h1 class="animate-fade-in-up text-4xl md:text-5xl lg:text-6xl font-extrabold tracking-tight mb-6 leading-tight text-gray-900">
				全員の空いてる時間が、<br class="block" />
				<span class="text-transparent bg-clip-text bg-linear-to-r from-blue-400 to-indigo-600">一瞬でわかる。</span>
			</h1>
			
			<p class="animate-fade-in-up animation-delay-200 text-sm md:text-xl text-gray-600 mb-2 max-w-2xl mx-auto leading-relaxed">
				SCHEDUTCHは、「大量の予定」を調整するための特化型ツール<br class="block" />
				メンバーの回答を考慮して最適な時間帯を自動抽出<br class="block" />
				どんなに多い候補日でも、全員の回答を一瞬で集計・視覚化<br class="block" />
				結果は1クリックでコピーして参加者に共有
			</p>
			
			<p class="animate-fade-in-up animation-delay-400 text-xs text-gray-400 mt-4">※ログイン・会員登録は一切不要です。</p>
		</section>`

    <section class="max-w-5xl mx-auto px-4 py-20">
      <h2 class="text-2xl md:text-3xl font-bold text-center mb-12 text-gray-700">使い方・特徴</h2>
      
      <div class="max-w-5xl grid md:grid-cols-2 gap-8">
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow duration-300">
          <div class="border-b border-gray-100 aspect-video relative flex items-center justify-center p-4">
            <div class="absolute top-3 left-3 bg-gray-900 text-white w-8 h-8 rounded-full flex items-center justify-center font-bold shadow-md z-10">1</div>
            <div class="w-full h-full border-2 border-dashed border-gray-300 rounded-lg flex flex-col items-center justify-center text-gray-400 bg-white">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-8 mb-2"><path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 0 1 2.25-2.25h13.5A2.25 2.25 0 0 1 21 7.5v11.25m-18 0A2.25 2.25 0 0 0 5.25 21h13.5A2.25 2.25 0 0 0 21 18.75m-18 0v-7.5A2.25 2.25 0 0 1 5.25 9h13.5A2.25 2.25 0 0 1 21 11.25v7.5" /></svg>
              <span class="text-xs">作成画面のスクショ</span>
            </div>
          </div>
          <div class="p-6">
            <h3 class="font-bold text-gray-800 mb-2 text-center">イベントを作成</h3>
            <p class="text-sm text-gray-600 text-center leading-relaxed">イベント名と候補日を選んで、専用のURLを発行します。</p>
          </div>
        </div>
        
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow duration-300">
          <div class="border-b border-gray-100 aspect-video relative flex items-center justify-center p-4">
            <div class="absolute top-3 left-3 bg-gray-900 text-white w-8 h-8 rounded-full flex items-center justify-center font-bold shadow-md z-10">2</div>
            <div class="w-full h-full border-2 border-dashed border-gray-300 rounded-lg flex flex-col items-center justify-center text-gray-400 bg-white">
               <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-8 mb-2"><path stroke-linecap="round" stroke-linejoin="round" d="M7.217 10.907a2.25 2.25 0 1 0 0 2.186m0-2.186c.18.324.283.696.283 1.093s-.103.77-.283 1.093m0-2.186 9.566-5.314m-9.566 7.5 9.566 5.314m0 0a2.25 2.25 0 1 0 3.935 2.186 2.25 2.25 0 0 0-3.935-2.186Zm0-12.814a2.25 2.25 0 1 0 3.933-2.185 2.25 2.25 0 0 0-3.933 2.185Z" /></svg>
              <span class="text-xs">入力画面のスクショ</span>
            </div>
          </div>
          <div class="p-6">
            <h3 class="font-bold text-gray-800 mb-2 text-center">メンバーに入力してもらう</h3>
            <p class="text-sm text-gray-600 text-center leading-relaxed">URLをLINEなどで共有し、メンバーに出欠を入力してもらいます。</p>
          </div>
        </div>
        
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-shadow duration-300">
          <div class="border-b border-gray-100 aspect-video relative flex items-center justify-center p-4">
            <div class="absolute top-3 left-3 bg-gray-900 text-white w-8 h-8 rounded-full flex items-center justify-center font-bold shadow-md z-10">3</div>
            <div class="w-full h-full border-2 border-dashed border-gray-300 rounded-lg flex flex-col items-center justify-center text-gray-400 bg-white">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-8 mb-2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h3.75M9 15h3.75M9 18h3.75m3 .75H18a2.25 2.25 0 0 0 2.25-2.25V6.108c0-1.135-.845-2.098-1.976-2.192a48.424 48.424 0 0 0-1.123-.08m-5.801 0c-.065.21-.1.433-.1.664 0 .414.336.75.75.75h4.5a.75.75 0 0 0 .75-.75 2.25 2.25 0 0 0-.1-.664m-5.8 0A2.251 2.251 0 0 1 13.5 2.25H15c1.012 0 1.867.668 2.15 1.586m-5.8 0c-.376.023-.75.05-1.124.08C9.095 4.01 8.25 4.973 8.25 6.108V8.25m0 0H4.875c-.621 0-1.125.504-1.125 1.125v11.25c0 .621.504 1.125 1.125 1.125h9.75c.621 0 1.125-.504 1.125-1.125V9.375c0-.621-.504-1.125-1.125-1.125H8.25ZM6.75 12h.008v.008H6.75V12Zm0 3h.008v.008H6.75V15Zm0 3h.008v.008H6.75V18Z" /></svg>
              <span class="text-xs">抽出画面のスクショ</span>
            </div>
          </div>
          <div class="p-6">
            <h3 class="font-bold text-gray-800 mb-2 text-center">候補時間を抽出して確定</h3>
            <p class="text-sm text-gray-600 text-center leading-relaxed">全員の予定が合う時間をワンタップで抽出し、コピペして日程確定！</p>
          </div>
        </div>
      </div>
    </section>
		
		<div class="pb-52"></div>

    <section class="w-full bg-blue-500 py-10 text-center px-4 fixed bottom-0 left-0 z-10">
      <h2 class="text-2xl md:text-3xl font-bold text-white mb-6">さっそく予定を合わせてみましょう</h2>
      <router-link 
        to="/new" 
        class="inline-flex items-center justify-center bg-white text-blue-500 text-lg font-bold px-10 py-4 rounded-full shadow-lg hover:shadow-xl hover:-translate-y-1 hover:bg-gray-50 transition-all duration-300 active:scale-95"
      >
        新しく予定を作成する
      </router-link>
    </section>

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