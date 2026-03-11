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
    description:
      'イベント名を入力し、カレンダーから候補日程を選択するだけでセットアップ完了。日付や時間帯の指定も直感的な操作で、迷うことなく専用のURLを発行できます。',
    image: stepCreateImg,
    reverse: false,
    glow: 'bg-blue-400',
  },
  {
    number: '02',
    title: 'メンバーに入力してもらう',
    description:
      '発行されたURLを共有するだけ。受け取ったメンバーはログインやアプリのインストール不要で、回答画面から自分の空き時間を即座に登録できます。',
    image: stepAnswerImg,
    reverse: true, // 画像が左
    glow: 'bg-indigo-400',
  },
  {
    number: '03',
    title: 'メンバーの予定を確認',
    description:
      '全員の回答は自動で集計され、見やすい一覧表として可視化されます。誰がいつ空いているのかを一瞬で把握することが可能です。',
    image: stepShowImg,
    reverse: false,
    glow: 'bg-blue-400',
  },
  {
    number: '04',
    title: '候補時間を抽出して確定',
    description:
      'ワンタップで選択したメンバーの空いている日時を抽出。そのまま共有用のテキストをコピーして、参加者に送るだけで調整完了です。',
    image: stepExtractImg,
    reverse: true, // 画像が左
    glow: 'bg-indigo-400',
  },
]

const faqs = [
  {
    question: '会員登録やアプリのインストールが必要ですか？',
    answer:
      '一切不要です。幹事の方が発行したURLをブラウザで開くだけで、誰でもすぐに回答できます。LINEなどのSNSでURLを共有するだけで完結します。',
  },
  {
    question: '利用に料金はかかりますか？',
    answer: 'いいえ、完全無料ですべての機能をご利用いただけます。',
  },
]
</script>

<template>
  <div class="min-h-screen bg-slate-50 font-sans text-gray-800">
    <section
      class="relative flex min-h-dvh w-full flex-col items-center justify-center overflow-hidden bg-slate-50 px-4 py-20"
    >
      <div
        class="absolute inset-0 z-0 bg-cover bg-top bg-no-repeat opacity-100"
        style="
          background-image: url('https://images.unsplash.com/photo-1506784983877-45594efa4cbe?q=80&w=2068&auto=format&fit=crop');
        "
      ></div>

      <div
        class="absolute inset-0 z-0 bg-linear-to-b from-blue-900/10 via-slate-50/80 to-slate-50 backdrop-blur-[2px]"
      ></div>

      <div class="relative z-10 mx-auto max-w-4xl pt-10 text-center">
        <div
          class="mb-8 inline-flex items-center gap-2 rounded-full border border-gray-200/60 bg-white/80 px-4 py-1.5 text-xs font-bold tracking-widest text-gray-600 uppercase shadow-sm backdrop-blur-md"
        >
          <span class="relative flex h-2 w-2">
            <span
              class="absolute inline-flex h-full w-full animate-ping rounded-full bg-blue-400 opacity-75"
            ></span>
            <span class="relative inline-flex h-2 w-2 rounded-full bg-blue-500"></span>
          </span>
          SCHEDUTCH
        </div>

        <h1
          class="animate-fade-in-up mb-6 text-4xl leading-[1.15] font-extrabold tracking-tight text-gray-900 md:text-6xl lg:text-7xl"
        >
          空いてる時間が<br />
          <span
            class="bg-linear-to-r from-blue-600 via-indigo-500 to-purple-600 bg-clip-text text-transparent"
            >一瞬でわかる</span
          >
        </h1>

        <p
          class="animate-fade-in-up animation-delay-200 mx-auto mb-10 max-w-2xl text-base leading-relaxed text-gray-600 md:text-lg"
        >
          SCHEDUTCHは、「大量の予定」を調整するための特化型ツール。<br class="hidden md:block" />
          メンバーの回答から最適な時間帯を自動抽出し、1クリックで共有できます。
        </p>

        <div
          class="animate-fade-in-up animation-delay-400 flex flex-col items-center justify-center"
        >
          <router-link
            to="/new"
            class="group relative inline-flex items-center justify-center rounded-full bg-linear-to-r from-blue-600 to-indigo-600 px-8 py-4 text-base font-bold text-white transition-all duration-300 hover:-translate-y-1 hover:shadow-[0_8px_30px_rgb(79,70,229,0.3)] active:scale-95"
          >
            新しく予定を作成する
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2.5"
              stroke="currentColor"
              class="-mr-1 ml-2 h-5 w-5 transition-transform duration-300 group-hover:translate-x-1.5"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3"
              />
            </svg>
          </router-link>

          <p class="mt-4 text-sm font-medium text-gray-500">完全無料・すぐにお使いいただけます</p>
        </div>
      </div>
    </section>

    <section class="relative w-full overflow-hidden py-24 sm:py-32">
      <div
        class="absolute inset-0 z-0 bg-gray-100 [clip-path:polygon(0_5vw,100%_0,100%_100%,0_100%)]"
      ></div>

      <div class="relative z-10 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div class="mb-24 text-center sm:mb-32">
          <span class="mb-3 block text-sm font-extrabold tracking-widest text-blue-600 uppercase">
            How to use
          </span>
          <h2 class="text-3xl font-black tracking-tight text-gray-900 md:text-5xl">
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

    <section class="mb-5 w-full bg-gray-100 py-14 sm:py-22">
      <div class="mx-auto max-w-3xl px-4 sm:px-6">
        <div class="mb-16 text-center">
          <span class="mb-3 block text-sm font-extrabold tracking-widest text-blue-600 uppercase">
            FAQ
          </span>
          <h2 class="text-3xl font-black tracking-tight text-gray-900 md:text-4xl">
            よくあるご質問
          </h2>
        </div>

        <div
          class="rounded-3xl border border-gray-100 bg-white p-4 shadow-sm transition-shadow duration-300 hover:shadow-md sm:p-6"
        >
          <FaqItem
            v-for="(faq, index) in faqs"
            :key="index"
            :question="faq.question"
            :answer="faq.answer"
          />
        </div>
      </div>
    </section>

    <footer class="w-full border-t border-slate-200 bg-gray-500 py-3">
      <div class="mx-auto flex max-w-5xl items-center justify-center gap-6 px-6">
        <a
          href="https://github.com/Ryo0u/schedutch"
          target="_blank"
          rel="noopener noreferrer"
          class="text-slate-400 transition-colors hover:text-white"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="20"
            height="20"
            fill="currentColor"
            viewBox="0 0 16 16"
          >
            <path
              d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.012 8.012 0 0 0 16 8c0-4.42-3.58-8-8-8z"
            />
          </svg>
        </a>
        <div class="pt-0.5 font-mono text-[10px] tracking-wider text-slate-400 sm:text-xs">
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
