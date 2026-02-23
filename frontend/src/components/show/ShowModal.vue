<script setup>
import { ref, computed, onMounted } from "vue"
import axios from 'axios';
import ModalTable from "./ModalTable.vue"

const props = defineProps({
  event: {
    type: Object,
    required: true
  },
  
  editingUser: {
    type: Object,
    default: null
  },
  
  editPassword: {
    type: String,
    default: ""
  }
})

const emit = defineEmits(["closeModal"])

const isExpanded = ref(true)
const isEditMode = computed(() => !!props.editingUser)
const isLoading = ref(false)

const name = ref("")
const password = ref("")
const comment = ref("")
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
    alert("名前とパスワードを入力してください")
    return
  }
  
  const formattedResponses = Object.entries(data.responses).map(([time, status]) => {
    return {
      start_time: `${time}:00`,
      status: status
    }
  })
  
  try {
    if (isEditMode.value) {
      // 予定更新
      await axios.patch(`/api/v1/users/${props.editingUser.id}`, {
          user: {
            name: name.value,
            password: password.value,
            comment: comment.value
          },
          responses: formattedResponses
        }
      )
      
      alert("予定を変更しました")
    } else {
      // 新規登録
      await axios.post(`/api/v1/events/${props.event.url_token}/users`, {
          user: {
            name: name.value,
            password: password.value,
            comment: comment.value
          },
          responses: formattedResponses
        }
      )
      
      alert("予定を登録しました")
    }
    
    emit("closeModal")
    
    location.reload()
    
  } catch (e) {
    console.error(e)
  }
}
</script>

<template>
  <div
    class="fixed inset-0 z-40 flex p-4 transition-all duration-300"
    :class="isExpanded ? 'bg-black/50 justify-center items-center' : 'pointer-events-none justify-end items-end'"
  >
    <div 
      class="bg-white rounded-xl shadow-2xl flex flex-col border-5 border-blue-100 overflow-hidden transition-all duration-300 pointer-events-auto"
      :class="isExpanded ? 'w-full max-w-4xl max-h-[90vh]' : 'w-60 shadow-lg'"
    >
      <div class="bg-blue-100 flex items-center justify-between p-2 sm:p-4 border-b border-gray-100 cursor-pointer" @click="isExpanded = true">
        <h3 class="font-bold text-gray-500 truncate" :class="isExpanded ? 'text-lg sm:text-xl' : 'text-xs'">
          {{ isExpanded ? 'あなたの予定を入力する' : '入力を再開する' }}
        </h3>
        
        <div class="flex items-baseline gap-2 shrink-0">
          <button 
            @click.stop="toggleMinimize"
            class="text-md sm:text-xl text-gray-400 hover:text-gray-600 w-6 sm:w-8 h-6 sm:h-8 flex items-center justify-center rounded-full hover:bg-gray-200 transition cursor-pointer"
          >
            {{ isExpanded ? 'ー' : '◻︎' }}
          </button>
          
          <button
            @click="emit('closeModal')"
            class="text-lg sm:text-2xl text-gray-400 hover:text-gray-600 w-6 sm:w-8 h-6 sm:h-8 flex items-center justify-center rounded-full hover:bg-gray-200 transition pb-1.5  cursor-pointer"
          >
            ×
          </button>
        </div>
        
      </div>
      
      <div v-show="isExpanded" class="p-4 sm:p-6 overflow-y-auto">
        <div class="max-w-5xl mx-auto">	
					<div class="border-b border-gray-200 pb-5 sm:pb-8 mb-3">

						<div class="flex flex-col md:flex-row gap-6 mb-6">
							
							<div class="w-full md:w-1/2 flex items-center gap-4">
								<span class="w-20 text-sm font-bold text-gray-600 whitespace-nowrap shrink-0">名前:</span>
								<input v-model="name"  type="text" class="w-full border-2 border-gray-400 rounded px-3 py-1 sm:py-2 text-gray-700 focus:outline-none focus:border-blue-500">
							</div>

							<div class="w-full md:w-1/2 flex items-center gap-4">
								<span class="w-20 text-sm font-bold text-gray-600 whitespace-nowrap shrink-0">パスワード:</span>
								<input v-model="password" type="text" class="w-full border-2 border-gray-400 rounded px-3 py-1 sm:py-2 text-gray-700 focus:outline-none focus:border-blue-500">
							</div>
							
						</div>

						<div class="flex gap-4">
							<span class="w-20 text-sm font-bold text-gray-600 whitespace-nowrap shrink-0 pt-2">コメント:</span>
							<textarea v-model="comment" rows="2" class="w-full border-2 border-gray-400 rounded px-3 py-1 sm:py-2 text-gray-700 focus:outline-none focus:border-blue-500"></textarea>
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
              class="w-full text-white text-md font-bold mt-3 py-3 px-6 rounded-full shadow-lg transition transform flex justify-center items-center"
              :class="[
                (isLoading || !name || !password)
                  ? 'bg-blue-300 cursor-not-allowed'
                  : 'bg-blue-400 hover:bg-blue-500 hover:-translate-y-1'
              ]"
              :disabled="isLoading || !name || !password"
            >
              <template v-if="isLoading">
                <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                登録中...
              </template>
              <template v-else>
                予定を追加する
              </template>
            </button>
          </div>
				</div>
      </div>
    </div>
  </div>
</template>