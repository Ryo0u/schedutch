<script setup>
import { ref } from 'vue'

const isCopied = ref(false)

const shareApp = async () => {
  const shareData = {
    title: 'SCHEDUTCH (スケダッチ)',
    text: 'ログイン不要でサクッと日程調整！回答を考慮して最適な時間を自動抽出します。',
    url: window.location.origin,
  }

  if (navigator.share) {
    try {
      await navigator.share(shareData)
    } catch {
      console.log('シェアがキャンセルされました')
    }
  } else {
    try {
      await navigator.clipboard.writeText(shareData.title + shareData.text + shareData.url)

      isCopied.value = true
      setTimeout(() => {
        isCopied.value = false
      }, 2000)
    } catch {
      alert('コピーに失敗しました。URLを手動でコピーしてください。')
    }
  }
}
</script>

<template>
  <header
    class="sticky top-0 z-50 w-full border-t-4 border-b border-t-blue-500 border-b-gray-100 bg-white shadow-sm backdrop-blur-md transition-all"
  >
    <div class="mx-auto flex h-16 items-center justify-between px-2 sm:h-20 sm:px-4">
      
      <router-link
        to="/"
        class="relative -top-0.5 flex shrink-0 items-center transition-transform hover:-translate-y-0.5 hover:opacity-80"
      >
        <img
          src="@/assets/images/AppTitle.png"
          class="h-13 w-auto object-contain sm:h-18"
          alt="SCHEDUTCH"
        />
      </router-link>

      <div class="flex items-center gap-1 sm:gap-5">
        <router-link
          to="/"
          class="group flex flex-col items-center justify-center rounded-full border border-gray-200 bg-white px-4 py-1.5 leading-tight text-gray-700 shadow-sm transition-all duration-300 hover:-translate-y-0.5 hover:border-blue-300 hover:text-blue-600 hover:shadow-md active:scale-95 sm:px-10"
        >
          <span class="flex items-center gap-1 text-xs font-bold sm:text-sm">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="size-3.5"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="m2.25 12 8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25"
              />
            </svg>
            Top
          </span>
          <span
            class="mt-0.5 hidden text-[10px] font-medium text-gray-400 transition-colors group-hover:text-blue-400 sm:block"
            >トップ</span
          >
        </router-link>

        <router-link
          to="/new"
          class="group flex flex-col items-center justify-center rounded-full border border-gray-200 bg-white px-4 py-1.5 leading-tight text-gray-700 shadow-sm transition-all duration-300 hover:-translate-y-0.5 hover:border-blue-300 hover:text-blue-600 hover:shadow-md active:scale-95 sm:px-10"
        >
          <span class="flex items-center gap-1 text-xs font-bold sm:text-sm">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="size-4 transition-transform duration-300"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M12 4.5v15m7.5-7.5h-15"
              />
            </svg>
            New
          </span>
          <span
            class="mt-0.5 hidden text-[10px] font-medium text-gray-400 transition-colors group-hover:text-blue-400 sm:block"
            >予定作成</span
          >
        </router-link>

        <div class="hidden h-8 w-px bg-gray-200 sm:block"></div>

        <button
          @click="shareApp"
          class="flex cursor-pointer items-center justify-center transition-all duration-300 hover:-translate-y-0.5"
          :class="isCopied ? 'text-green-500' : 'text-gray-400 hover:text-gray-800'"
          title="アプリをシェアする"
        >
          <svg
            v-if="isCopied"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="2.5"
            stroke="currentColor"
            class="block h-6 w-6 sm:h-7 sm:w-7"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="m4.5 12.75 6 6 9-13.5"
            />
          </svg>

          <svg
            v-else
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.8"
            stroke="currentColor"
            class="block h-5 w-5 sm:h-7 sm:w-7"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M7.217 10.907a2.25 2.25 0 1 0 0 2.186m0-2.186c.18.324.283.696.283 1.093s-.103.77-.283 1.093m0-2.186 9.566-5.314m-9.566 7.5 9.566 5.314m0 0a2.25 2.25 0 1 0 3.935 2.186 2.25 2.25 0 0 0-3.935-2.186Zm0-12.814a2.25 2.25 0 1 0 3.933-2.185 2.25 2.25 0 0 0-3.933 2.185Z"
            />
          </svg>
        </button>
      </div>
    </div>
  </header>

  <div class="relative min-h-screen overflow-hidden bg-slate-100">
    <div
      class="absolute inset-0 z-0 opacity-[0.06]"
      style="
        background-image:
          linear-gradient(#3b82f6 1px, transparent 1px),
          linear-gradient(90deg, #3b82f6 1px, transparent 1px);
        background-size: 40px 40px;
      "
    ></div>

    <div class="relative z-10">
      <router-view />
    </div>
  </div>
  
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
</template>
