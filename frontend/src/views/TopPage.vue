<script setup>
import { ref } from 'vue'
</script>

<template>
  <div class="min-h-screen bg-linear-to-br from-blue-50 via-white to-indigo-100 font-sans text-gray-800">
    
    <section class="relative w-full mx-auto px-4 pt-25 sm:pt-40 pb-20 sm:pb-52 text-center mb-5 bg-cover bg-center bg-no-repeat"
             style="background-image: url('https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=2070&auto=format&fit=crop');"
    >
      <div class="absolute inset-0 bg-gray-900/70 z-0"></div>
      
      <div class="relative z-10 max-w-5xl mx-auto px-4">
        <h1 class="animate-fade-in-up text-4xl md:text-5xl lg:text-6xl font-extrabold tracking-tight mb-6 leading-tight text-white">
          全員の空いてる時間が、<br class="block" />
          <span class="text-transparent bg-clip-text bg-linear-to-r from-blue-400 to-indigo-600">一瞬でわかる。</span>
        </h1>
        
        <p class="animate-fade-in-up animation-delay-200 text-sm md:text-xl text-white mb-2 max-w-2xl mx-auto leading-relaxed">
          SCHEDUTCHは、「大量の予定」を調整するための特化型ツール<br class="block" />
          メンバーの回答を考慮して最適な時間帯を自動抽出<br class="block" />
          どんなに多い候補日でも、全員の回答を一瞬で集計・視覚化<br class="block" />
          結果は1クリックでコピーして参加者に共有
        </p>
        
        <p class="animate-fade-in-up animation-delay-400 text-xs text-gray-300 mt-4">※ログイン・会員登録は一切不要です。</p>
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
		
		<div class="pb-20 sm:pb-52"></div>

    <section class="w-full bg-blue-500 py-5 sm:py-10 text-center px-4 fixed bottom-0 left-0 z-10">
      <h2 class="text-lg sm:text-2xl md:text-3xl font-bold text-white mb-3 sm:mb-6">さっそく予定を合わせてみましょう</h2>
      <router-link 
        to="/new" 
        class="inline-flex items-center justify-center bg-white text-blue-500 text-md sm:text-lg font-bold px-10 py-4 rounded-full shadow-lg hover:shadow-xl hover:-translate-y-1 hover:bg-gray-50 transition-all duration-300 active:scale-95"
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