<script setup>
</script>

<template>
  <header class="w-full bg-blue-50">
    <div class="max-w-5xl mx-auto h-15 sm:h-20 flex items-center justify-center sm:justify-start">
      <img src="@/assets/AppLogo.png" class="h-30 md:h-35 w-auto object-contain"/>
    </div>
  </header>
  
  <div class="bg-blue-50">
    <router-view/>
  </div>
</template>