<script setup>
defineProps({
  stepNumber: { type: String, required: true },
  title: { type: String, required: true },
  description: { type: String, required: true },
  imageSrc: { type: String, required: true },
  isReverse: { type: Boolean, default: false }, // trueなら画像が左に来る
  glowColor: { type: String, default: 'bg-blue-400' }
})
</script>

<template>
  <div :class="['flex flex-col lg:flex-row items-center gap-12 lg:gap-16', isReverse ? 'lg:flex-row-reverse' : '']">
    
    <div class="w-full lg:w-5/12 text-center lg:text-left">
      <span class="text-7xl md:text-8xl font-black text-gray-300 block mb-2 leading-none">{{ stepNumber }}</span>
      <h3 class="text-2xl sm:text-3xl font-bold text-gray-800 mb-4">{{ title }}</h3>
      <p class="text-base sm:text-lg text-gray-600 leading-relaxed max-w-lg mx-auto lg:mx-0">
        {{ description }}
      </p>
    </div>

    <div class="w-full lg:w-7/12 relative group z-0">
      
      <div :class="[
				'absolute top-20 sm:top-50 -bottom-8 sm:-bottom-16 bg-white rounded-2xl sm:rounded-3xl shadow-sm border border-gray-100 -z-10 transition-transform duration-500 group-hover:-translate-y-1',
				isReverse 
					? '-right-4 sm:-right-10 -left-16 sm:-left-32 lg:-left-80' 
					: '-left-4 sm:-left-10 -right-16 sm:-right-32 lg:-right-80'
			]"></div>
      
      <div class="relative z-10 rounded-xl sm:rounded-2xl border border-gray-200/60 shadow-2xl bg-white overflow-hidden ring-1 ring-black/5 hover:shadow-3xl hover:-translate-y-2 transition-all duration-500">
        <div class="h-10 sm:h-12 bg-gray-50 border-b border-gray-200 flex items-center px-4 gap-2">
          <div class="w-3 h-3 rounded-full bg-red-400 border border-red-500/20"></div>
          <div class="w-3 h-3 rounded-full bg-amber-400 border border-amber-500/20"></div>
          <div class="w-3 h-3 rounded-full bg-green-400 border border-green-500/20"></div>
        </div>
        <div class="relative overflow-hidden bg-gray-100">
          <img :src="imageSrc" :alt="title" class="w-full h-auto block" />
        </div>
      </div>

    </div>
    
  </div>
</template>