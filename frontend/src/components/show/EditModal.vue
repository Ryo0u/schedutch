<script setup>
import { ref } from 'vue'

defineProps({
  userName: {
    type: String,
    default: '',
  },
  isEditing: {
    type: String,
  },
})

const password = ref('')

const emit = defineEmits(['closeEdit', 'submitEdit', 'submitDelete'])
</script>
<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
    <div class="w-120 rounded-lg bg-white p-6 shadow-lg">
      <h2 class="mb-4 text-center text-xl font-bold text-gray-600">
        <span>{{ userName }}</span
        >さんの予定を編集する
      </h2>
      <p class="mb-4 text-center text-sm text-gray-600">
        予定の変更・削除を行う場合はパスワードを入力してください
      </p>

      <div class="flex items-center justify-center gap-3">
        <input
          v-model="password"
          type="text"
          placeholder="パスワード"
          class="mb-4 w-full rounded border border-gray-500 p-2"
          :disabled="isEditing !== null"
        />
      </div>

      <div class="mb-3 flex gap-6">
        <button
          @click="emit('submitEdit', password)"
          class="flex w-full items-center justify-center rounded-lg py-2 font-bold shadow transition-all"
          :class="[
            !password || isEditing != null
              ? 'cursor-not-allowed bg-blue-300 text-white'
              : 'bg-blue-500 text-white hover:-translate-y-0.5 hover:bg-blue-600',
          ]"
          :disabled="!password || isEditing != null"
        >
          <template v-if="isEditing === 'edit'">
            <svg
              class="mr-2 -ml-1 h-4 w-4 animate-spin text-white"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
            >
              <circle
                class="opacity-25"
                cx="12"
                cy="12"
                r="10"
                stroke="currentColor"
                stroke-width="4"
              ></circle>
              <path
                class="opacity-75"
                fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
              ></path>
            </svg>
            確認中...
          </template>
          <template v-else> 編集画面へ進む </template>
        </button>

        <button
          @click="emit('submitDelete', password)"
          class="flex w-full items-center justify-center rounded-lg border py-2 font-bold transition-all"
          :class="[
            !password || isEditing !== null
              ? 'cursor-not-allowed border-red-100 bg-gray-50 text-red-300'
              : 'border-red-200 bg-white text-red-500 hover:-translate-y-0.5 hover:bg-red-50',
          ]"
          :disabled="!password || isEditing != null"
        >
          <template v-if="isEditing === 'delete'">
            <svg
              class="mr-2 -ml-1 h-4 w-4 animate-spin text-white"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
            >
              <circle
                class="text-red-500 opacity-25"
                cx="12"
                cy="12"
                r="10"
                stroke="currentColor"
                stroke-width="4"
              ></circle>
              <path
                class="opacity-75"
                fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
              ></path>
            </svg>
            削除中...
          </template>
          <template v-else> 削除する </template>
        </button>
      </div>

      <button
        :disabled="isEditing !== null"
        @click="emit('closeEdit')"
        class="w-full py-2 text-sm text-gray-400 underline decoration-gray-300 underline-offset-4 hover:text-gray-600"
      >
        キャンセルして戻る
      </button>
    </div>
  </div>
</template>
