<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router' // URLの情報を取るやつ
import axios from 'axios'

const route = useRoute()
const event = ref(null) // イベントデータを入れる箱
const loading = ref(true)
const error = ref(null)

// 画面が表示された瞬間に実行される
onMounted(async () => {
  try {
    // URLの :id 部分（トークン）を取得
    const token = route.params.id
    
    // Railsからデータを取ってくる
    const response = await axios.get(`http://localhost:3000/api/v1/events/${token}`)
    event.value = response.data
  } catch (err) {
    error.value = "イベントが見つかりませんでした..."
    console.error(err)
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div style="padding: 20px;">
    <div v-if="loading">読み込み中...</div>

    <div v-else-if="error" style="color: red;">{{ error }}</div>

    <div v-else-if="event">
      <h1>{{ event.title }}</h1>
      <p style="white-space: pre-wrap;">{{ event.description }}</p>
      
      <hr>
      <p>候補日: (まだ空っぽ)</p>
    </div>
  </div>
</template>