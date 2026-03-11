<script setup>
import FeatureStep from '@/components/top/FeatureStep.vue'
import FaqItem from '@/components/top/FaqItem.vue'

// Vite環境で画像を扱うため、明示的にimport
import stepCreateImg from '@/assets/images/step_create.png'
import stepAnswerImg from '@/assets/images/step_answer.png'
import stepShowImg from '@/assets/images/step_show.png'
import stepExtractImg from '@/assets/images/step_extract.png'

const steps = [
  {
    number: '01',
    title: 'イベントを作成',
    description: 'イベント名を入力し、カレンダーから候補日程を選択するだけでセットアップ完了。日付や時間帯の指定も直感的な操作で、迷うことなく専用のURLを発行できます。',
    image: stepCreateImg,
    reverse: false,
    glow: 'bg-blue-400'
  },
  {
    number: '02',
    title: 'メンバーに入力してもらう',
    description: '発行されたURLを共有するだけ。受け取ったメンバーはログインやアプリのインストール不要で、回答画面から自分の空き時間を即座に登録できます。',
    image: stepAnswerImg,
    reverse: true, // 画像が左
    glow: 'bg-indigo-400'
  },
  {
    number: '03',
    title: 'メンバーの予定を確認',
    description: '全員の回答は自動で集計され、見やすい一覧表として可視化されます。誰がいつ空いているのかを一瞬で把握することが可能です。',
    image: stepShowImg,
    reverse: false,
    glow: 'bg-blue-400'
  },
  {
    number: '04',
    title: '候補時間を抽出して確定',
    description: 'ワンタップで選択したメンバーの空いている日時を抽出。そのまま共有用のテキストをコピーして、参加者に送るだけで調整完了です。',
    image: stepExtractImg,
    reverse: true, // 画像が左
    glow: 'bg-indigo-400'
  }
]

const faqs = [
  {
    question: '会員登録やアプリのインストールが必要ですか？',
    answer: '一切不要です。幹事の方が発行したURLをブラウザで開くだけで、誰でもすぐに回答できます。LINEなどのSNSでURLを共有するだけで完結します。'
  },
  {
    question: '利用に料金はかかりますか？',
    answer: 'いいえ、完全無料ですべての機能をご利用いただけます。'
  },
]
</script>

<template>
  <div class="min-h-screen bg-slate-50 font-sans text-gray-800">
    
    <section class="relative w-full min-h-dvh flex flex-col justify-center items-center px-4 py-20 bg-slate-50 overflow-hidden">
  
      <div class="absolute inset-0 z-0 bg-cover bg-top bg-no-repeat opacity-100"
          style="background-image: url('https://images.unsplash.com/photo-1506784983877-45594efa4cbe?q=80&w=2068&auto=format&fit=crop');">
      </div>

      <div class="absolute inset-0 z-0 bg-linear-to-b from-blue-900/10 via-slate-50/80 to-slate-50 backdrop-blur-[2px]"></div>

      <div class="relative z-10 max-w-4xl mx-auto text-center pt-10">
        
        <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/80 border border-gray-200/60 text-gray-600 text-xs font-bold tracking-widest uppercase mb-8 shadow-sm backdrop-blur-md">
          <span class="relative flex h-2 w-2">
            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-blue-400 opacity-75"></span>
            <span class="relative inline-flex rounded-full h-2 w-2 bg-blue-500"></span>
          </span>
          SCHEDUTCH
        </div>

        <h1 class="animate-fade-in-up text-4xl md:text-6xl lg:text-7xl font-extrabold tracking-tight text-gray-900 mb-6 leading-[1.15]">
          空いてる時間が<br />
          <span class="text-transparent bg-clip-text bg-linear-to-r from-blue-600 via-indigo-500 to-purple-600">一瞬でわかる</span>
        </h1>

        <p class="animate-fade-in-up animation-delay-200 text-base md:text-lg text-gray-600 mb-10 max-w-2xl mx-auto leading-relaxed">
          SCHEDUTCHは、「大量の予定」を調整するための特化型ツール。<br class="hidden md:block" />
          メンバーの回答から最適な時間帯を自動抽出し、1クリックで共有できます。
        </p>

        <div class="animate-fade-in-up animation-delay-400 flex flex-col items-center justify-center">
          <router-link 
            to="/new" 
            class="group relative inline-flex items-center justify-center px-8 py-4 text-base font-bold text-white transition-all duration-300 bg-linear-to-r from-blue-600 to-indigo-600 rounded-full hover:shadow-[0_8px_30px_rgb(79,70,229,0.3)] hover:-translate-y-1 active:scale-95"
          >
            新しく予定を作成する
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2.5" stroke="currentColor" class="w-5 h-5 ml-2 -mr-1 transition-transform duration-300 group-hover:translate-x-1.5">
              <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3" />
            </svg>
          </router-link>
          
          <p class="mt-4 text-sm text-gray-500 font-medium">完全無料・すぐにお使いいただけます</p>
        </div>

      </div>
    </section>

    <section class="relative w-full py-24 sm:py-32 overflow-hidden">
    
      <div class="absolute inset-0 bg-gray-100 [clip-path:polygon(0_5vw,100%_0,100%_100%,0_100%)] z-0"></div>

      <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        <div class="text-center mb-24 sm:mb-32">
          <span class="text-blue-600 font-extrabold tracking-widest text-sm uppercase mb-3 block">
            How to use
          </span>
          <h2 class="text-3xl md:text-5xl font-black text-gray-900 tracking-tight">
            4ステップで簡単調整
          </h2>
        </div>

        <div class="space-y-32 sm:space-y-48">
          <FeatureStep
            v-for="step in steps"
            :key="step.number"
            :step-number="step.number"
            :title="step.title"
            :description="step.description"
            :image-src="step.image"
            :is-reverse="step.reverse"
            :glow-color="step.glow"
          />
        </div>

      </div>
    </section>
  
    <section class="w-full py-14 sm:py-22 bg-gray-100 mb-5">
      <div class="max-w-3xl mx-auto px-4 sm:px-6">
        
        <div class="text-center mb-16">
          <span class="text-blue-600 font-extrabold tracking-widest text-sm uppercase mb-3 block">
            FAQ
          </span>
          <h2 class="text-3xl md:text-4xl font-black text-gray-900 tracking-tight">
            よくあるご質問
          </h2>
        </div>

        <div class="bg-white rounded-3xl shadow-sm border border-gray-100 p-4 sm:p-6 hover:shadow-md transition-shadow duration-300">
          <FaqItem 
            v-for="(faq, index) in faqs" 
            :key="index"
            :question="faq.question"
            :answer="faq.answer"
          />
        </div>

      </div>
    </section>
		
   <footer class="w-full bg-gray-500 border-t border-slate-200 py-3 ">
      <div class="max-w-5xl mx-auto px-6 flex items-center justify-center gap-6">
        <a href="https://github.com/Ryo0u/schedutch" target="_blank" rel="noopener noreferrer" class="text-slate-400 hover:text-white transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" viewBox="0 0 16 16">
            <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.012 8.012 0 0 0 16 8c0-4.42-3.58-8-8-8z"/>
          </svg>
        </a>
        <div class="text-[10px] sm:text-xs text-slate-400 font-mono tracking-wider pt-0.5">
          &copy; 2026 SCHEDUTCH
        </div>
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