<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import ModalTable from './ModalTable.vue'

const props = defineProps({
  event: {
    type: Object,
    required: true,
  },

  editingUser: {
    type: Object,
    default: null,
  },

  editPassword: {
    type: String,
    default: '',
  },
})

const emit = defineEmits(['closeModal', 'userUpdated'])

const isExpanded = ref(true)
const isEditMode = computed(() => !!props.editingUser)
const isLoading = ref(false)

const name = ref('')
const password = ref('')
const comment = ref('')
const tableRef = ref(null)

onMounted(() => {
  if (isEditMode.value) {
    name.value = props.editingUser.name
    comment.value = props.editingUser.comment
    password.value = props.editPassword
  }
})

const toggleMinimize = () => {
  isExpanded.value = !isExpanded.value
}

const triggerSubmit = () => {
  tableRef.value?.submit()
  isLoading.value = true
}

const submitData = async (data) => {
  if (!name.value || !password.value) {
    alert('名前とパスワードを入力してください')
    return
  }

  const formattedResponses = Object.entries(data.responses)
    .map(([time, status]) => {
      return {
        start_time: `${time}:00`,
        status: status,
      }
    })
    .filter((res) => res.status !== 1)

  try {
    let response

    if (isEditMode.value) {
      // 予定更新
      response = await axios.patch(`/api/v1/users/${props.editingUser.id}`, {
        user: {
          name: name.value,
          password: password.value,
          comment: comment.value,
        },
        responses: formattedResponses,
      })
    } else {
      // 新規登録
      response = await axios.post(`/api/v1/events/${props.event.url_token}/users`, {
        user: {
          name: name.value,
          password: password.value,
          comment: comment.value,
        },
        responses: formattedResponses,
      })
    }
    emit('userUpdated', response.data.user)
    emit('closeModal')
  } catch (e) {
    console.error(e)
    isLoading.value = false
  }
}
</script>

<template>
  <div
    class="fixed inset-0 z-50 flex p-4 pt-30 transition-all duration-300"
    :class="
      isExpanded
        ? 'items-center justify-center bg-black/50'
        : 'pointer-events-none items-end justify-end'
    "
  >
    <div
      class="pointer-events-auto flex flex-col overflow-hidden rounded-xl border-5 border-blue-100 bg-white shadow-2xl transition-all duration-300"
      :class="isExpanded ? 'max-h-[90vh] w-full max-w-4xl' : 'w-60 shadow-lg'"
    >
      <div
        class="flex cursor-pointer items-center justify-between bg-blue-100 p-1 sm:p-4"
        @click="isExpanded = true"
      >
        <h3
          class="truncate font-bold text-gray-500"
          :class="isExpanded ? 'text-lg sm:text-xl' : 'text-xs'"
        >
          {{ isExpanded ? 'あなたの予定を入力する' : '入力を再開する' }}
        </h3>

        <div class="flex shrink-0 items-baseline gap-2">
          <button
            :disabled="isLoading"
            @click.stop="toggleMinimize"
            class="text-md flex h-6 w-6 cursor-pointer items-center justify-center rounded-full text-gray-400 transition hover:bg-gray-200 hover:text-gray-600 sm:h-8 sm:w-8 sm:text-xl"
          >
            {{ isExpanded ? 'ー' : '◻︎' }}
          </button>

          <button
            :disabled="isLoading"
            @click="emit('closeModal')"
            class="flex h-6 w-6 cursor-pointer items-center justify-center rounded-full pb-1.5 text-lg text-gray-400 transition hover:bg-gray-200 hover:text-gray-600 sm:h-8 sm:w-8 sm:text-2xl"
          >
            ×
          </button>
        </div>
      </div>

      <div
        v-show="isExpanded"
        class="overflow-y-auto p-4 sm:p-6"
      >
        <div class="mx-auto max-w-5xl">
          <div class="mb-3 border-b border-gray-200 pb-5 sm:pb-8">
            <div class="mb-6 flex flex-col gap-6 md:flex-row">
              <div class="flex w-full items-center gap-4 md:w-1/2">
                <span class="w-20 shrink-0 text-sm font-bold whitespace-nowrap text-gray-600"
                  >名前:</span
                >
                <input
                  v-model="name"
                  type="text"
                  class="w-full rounded border-2 border-gray-400 px-3 py-1 text-gray-700 focus:border-blue-500 focus:outline-none sm:py-2"
                />
              </div>

              <div class="flex w-full items-center gap-4 md:w-1/2">
                <span class="w-20 shrink-0 text-sm font-bold whitespace-nowrap text-gray-600"
                  >パスワード:</span
                >
                <input
                  v-model="password"
                  type="text"
                  class="w-full rounded border-2 border-gray-400 px-3 py-1 text-gray-700 focus:border-blue-500 focus:outline-none sm:py-2"
                />
              </div>
            </div>

            <div class="flex gap-4">
              <span class="w-20 shrink-0 pt-2 text-sm font-bold whitespace-nowrap text-gray-600"
                >コメント:</span
              >
              <textarea
                v-model="comment"
                rows="2"
                class="w-full rounded border-2 border-gray-400 px-3 py-1 text-gray-700 focus:border-blue-500 focus:outline-none sm:py-2"
              ></textarea>
            </div>
          </div>

          <ModalTable
            :event="props.event"
            :editingUser="props.editingUser"
            @submit-data="submitData"
            ref="tableRef"
          />

          <div>
            <button
              @click="triggerSubmit"
              class="text-md mt-3 flex w-full transform items-center justify-center rounded-full px-6 py-3 font-bold text-white shadow-lg transition"
              :class="[
                isLoading || !name || !password
                  ? 'cursor-not-allowed bg-gray-300'
                  : 'bg-blue-400 hover:-translate-y-1 hover:bg-blue-500',
              ]"
              :disabled="isLoading || !name || !password"
            >
              <template v-if="isLoading">
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
                登録中...
              </template>
              <template v-else> 予定を追加する </template>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
