<script setup>
const props = defineProps({
  event: {
    type: Object,
    required: true,
  },
})

const emit = defineEmits(['openModal', 'deleteEvent'])
</script>
<template>
  <div class="mb-6 flex flex-col gap-5 md:flex-row">
    <div class="flex-2 rounded-lg border border-gray-100 bg-white p-4 shadow">
      <div class="flex items-baseline justify-between border-b border-gray-300">
        <h1 class="flex items-center gap-2 pb-2 text-2xl font-bold text-gray-800 sm:text-3xl">
          <span class="h-7 w-1 rounded-full bg-blue-500"></span> {{ props.event.title }}
        </h1>
        <p
          @click="emit('deleteEvent')"
          class="cursor-pointer text-xs text-gray-400 transition-colors duration-200 hover:text-red-600"
        >
          イベントを削除する
        </p>
      </div>

      <div
        v-if="event.description"
        class="mt-3 flex items-baseline gap-2"
      >
        <span
          class="mt-1 rounded-md bg-blue-100 px-2 py-1 text-xs font-bold whitespace-nowrap text-blue-600 sm:text-sm"
        >
          詳細・備考
        </span>

        <p class="text-xs leading-relaxed whitespace-pre-wrap text-gray-600 sm:text-sm">
          {{ props.event.description }}
        </p>
      </div>
    </div>

    <div class="flex-1 rounded-lg border border-gray-100 bg-white p-4 shadow">
      <button
        @click="emit('openModal')"
        class="sm:text-md mb-4 w-full transform rounded-full bg-blue-600 px-6 py-3 text-sm font-bold text-white shadow-lg transition hover:-translate-y-1 hover:bg-blue-700"
      >
        <div class="flex items-center justify-center gap-4">
          <span>→</span>
          <span>あなたの予定を追加する</span>
        </div>
      </button>

      <p class="mt-2 text-center text-xs text-gray-400">
        参加者の方はこちらから予定を追加してください
      </p>
    </div>
  </div>
</template>
