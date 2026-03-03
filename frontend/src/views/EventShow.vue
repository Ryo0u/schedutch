<script setup>
import {ref, onMounted} from "vue"
import axios from "axios"
import { useRoute, useRouter } from "vue-router";

import ShowHeader from '@/components/show/ShowHeader.vue'
import ShowUsers from '@/components/show/ShowUsers.vue'
import ShowTable from '@/components/show/ShowTable.vue'
import ExtractTime from "@/components/show/ExtractTime.vue"
import ShowUrl from "@/components/show/ShowUrl.vue"
import ShowModal from '@/components/show/ShowModal.vue'
import DeleteModal from "@/components/show/DeleteModal.vue";
import EditModal from "@/components/show/EditModal.vue";

const route = useRoute()
const router = useRouter()
const event = ref(null)
const isLoading = ref(true)
const error = ref(null)

const showModal = ref(false)
const showDelete = ref(false)
const showEdit = ref(false)
const editingUser = ref(null)
const tempPassword = ref("")

onMounted(async () => {
  try {
    const token = route.params.url_token
    const response = await axios.get(`/api/v1/events/${token}`)
    event.value = response.data
    
  } catch (err) {
    console.error(err)
    error.value = 'イベントが見つかりませんでした。'
    
  } finally {
    isLoading.value = false
  }
})

const deleteEvent = async (password) => {
  try {
    const token = route.params.url_token
    
    await axios.delete(`/api/v1/events/${token}`, {
      data: {password: password}
    })
    
    alert("イベントを排除しました")
    showDelete.value = false
    editingUser.value = null
    router.push("/")
    
  } catch (err) {
    console.error(err)
    
    if (err.response && err.response.status === 401) {
      alert('パスワードが間違っています')
    } else {
      alert('削除に失敗しました')
    }
  }
}

const editRequest = (user) => {
  editingUser.value = user
  showEdit.value = true
}

const editUser = async (password) => {
  try {
    const userId = editingUser.value.id
    
    await axios.post(`/api/v1/users/${userId}/authenticate`, {
      password: password
    })
    
    tempPassword.value = password
    
    showEdit.value = false
    showModal.value = true
    
  } catch (err) {
     console.error(err)
     if (err.response && err.response.status === 401) {
      alert('パスワードが間違っています')
    } else {
      alert('通信に失敗しました')
    }
  }
}

const deleteUser = async (password) => {
  
  try {
    const userId = editingUser.value.id
    
    await axios.delete(`/api/v1/users/${userId}`, {
      data: { password: password }
    })
    removeUserFromList(userId)
    
    showEdit.value = false
    editingUser.value = null
    
  } catch (err) {
     console.error(err)
     if (err.response && err.response.status === 401) {
      alert('パスワードが間違っています')
    } else {
      alert('通信に失敗しました')
    }
  }
}

const updateUserList = (updatedUser) => {
  const index = event.value.users.findIndex(u => u.id === updatedUser.id)
  
  if (index !== -1) {
    // 編集の場合
    event.value.users.splice(index, 1, updatedUser)
  } else {
    // 新規の場合
    event.value.users.push(updatedUser)
  }
  
  event.value.users = [...event.value.users]
  
  showModal.value = false
  editingUser.value = null
  tempPassword.value = ''
}

const removeUserFromList = (deletedUserId) => {
  event.value.users = event.value.users.filter(u => u.id !== deletedUserId)
}
</script>
<template>
  <div v-if="isLoading" class="fixed inset-0 flex flex-col items-center justify-center bg-white">
  
    <div class="flex gap-5 mb-4">
      <div class="flex gap-5">
        <div class="animate-spin h-8 w-8 bg-blue-300 rounded-xl"></div>
        <div class="animate-spin h-8 w-8 bg-blue-400 rounded-xl" style="animation-delay: 0.1s"></div>
        <div class="animate-spin h-8 w-8 bg-blue-500 rounded-xl" style="animation-delay: 0.2s"></div>
      </div>
    </div>

    <div class="text-gray-400 text-center text-2xl font-bold tracking-widest animate-pulse">
      イベント読み込み中.....
    </div>
  
  </div>
  
  <div v-else-if="error" class="fixed inset-0 flex flex-col items-center justify-center p-4 bg-white">
    <div class="text-blue-800 text-center text-3xl font-bold tracking-tight">
      {{ error }}
    </div>
  </div>
  
  <div v-else class="max-w-5xl mx-auto p-8">
    <ShowHeader 
      :event="event" 
      @openModal="showModal = true" 
      @deleteEvent="showDelete = true"
    />

    <ShowUsers
      :users="event.users"
      @openEdit="editRequest"
    />

    <ShowTable
      :event="event"
    />
    
    <ExtractTime
      :event="event"
    />

    <ShowUrl/>
    
    <ShowModal
      v-if="showModal" 
      :event="event"
      :editingUser="editingUser"
      :editPassword="tempPassword"
      @userUpdated="updateUserList"
      @closeModal="showModal = false, editingUser = null, tempPassword = ''"
    />
    
    <DeleteModal
      v-if="showDelete === true"
      @closeDelete="showDelete = false"
      @submitDelete="deleteEvent"
    />
    
    <EditModal
      v-if="showEdit === true"
      :userName="editingUser?.name"
      @closeEdit="showEdit = false, editingUser = null, tempPassword = ''"
      @submitEdit="editUser"
      @submitDelete="deleteUser"
    />
  </div>
</template>

<style></style>