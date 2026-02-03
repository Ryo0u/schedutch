<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const message = ref('Railsに問い合わせ中...')

onMounted(async () => {
  try {
    const res = await axios.get('http://localhost:3000/api/v1/tests')
    // 返ってきたデータを画面の変数に入れる
    message.value = res.data.message
  } catch (error) {
    message.value = 'エラー！通信に失敗しました😭'
    console.error(error)
  }
})
</script>

<template>
  <div style="text-align: center; margin-top: 100px;">
    <h1>通信テスト結果：</h1>
    <p style="font-size: 24px; color: green; font-weight: bold;">
      {{ message }}
    </p>
  </div>
</template>