<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

// 入力データを格納する変数
const title = ref('')
const description = ref('')
const password = ref('')

const router = useRouter()

// ボタンを押した時の処理
const createEvent = async () => {
  try {
    // Railsにデータを送る (POSTリクエスト)
    const response = await axios.post('http://localhost:3000/api/v1/events', {
      event: {
        title: title.value,
        description: description.value,
        password: password.value,
        password_confirmation: password.value 
      }
    })

    // 成功したらここに来る
    console.log('成功！:', response.data)
    router.push(`/events/${response.data.url_token}`)
    

    title.value = ''
    description.value = ''
    password.value = ''

  } catch (error) {
    // 失敗したらここに来る
    console.error('エラー:', error.response)
    alert('作成に失敗しました...\n理由: ' + JSON.stringify(error.response.data))
  }
}
</script>

<template>
  <div style="padding: 20px; border: 1px solid #ccc; max-width: 400px; margin: 20px auto;">
    <h2>イベント作成テスト</h2>
    
    <div style="margin-bottom: 10px;">
      <label>イベント名:</label><br>
      <input v-model="title" type="text" placeholder="例: サークル新歓">
    </div>

    <div style="margin-bottom: 10px;">
      <label>説明（メモ）:</label><br>
      <textarea v-model="description" placeholder="例: 19時に駅集合"></textarea>
    </div>

    <div style="margin-bottom: 10px;">
      <label>パスワード:</label><br>
      <input v-model="password" type="password">
    </div>

    <button @click="createEvent" style="padding: 10px 20px; cursor: pointer;">
      イベントを作成！
    </button>
  </div>
</template>