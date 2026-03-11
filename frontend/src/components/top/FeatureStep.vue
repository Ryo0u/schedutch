<script setup>
defineProps({
  stepNumber: { type: String, required: true },
  title: { type: String, required: true },
  description: { type: String, required: true },
  imageSrc: { type: String, required: true },
  isReverse: { type: Boolean, default: false }, // trueなら画像が左に来る
  glowColor: { type: String, default: 'bg-blue-400' },
})
</script>

<template>
  <div
    :class="[
      'flex flex-col items-center gap-12 lg:flex-row lg:gap-16',
      isReverse ? 'lg:flex-row-reverse' : '',
    ]"
  >
    <div class="w-full text-center lg:w-5/12 lg:text-left">
      <span class="mb-2 block text-7xl leading-none font-black text-gray-300 md:text-8xl">{{
        stepNumber
      }}</span>
      <h3 class="mb-4 text-2xl font-bold text-gray-800 sm:text-3xl">{{ title }}</h3>
      <p class="mx-auto max-w-lg text-base leading-relaxed text-gray-600 sm:text-lg lg:mx-0">
        {{ description }}
      </p>
    </div>

    <div class="group relative z-0 w-full lg:w-7/12">
      <div
        :class="[
          'absolute top-20 -bottom-8 -z-10 rounded-2xl border border-gray-100 bg-white shadow-sm transition-transform duration-500 group-hover:-translate-y-1 sm:top-50 sm:-bottom-16 sm:rounded-3xl',
          isReverse
            ? '-right-4 -left-16 sm:-right-10 sm:-left-32 lg:-left-80'
            : '-right-16 -left-4 sm:-right-32 sm:-left-10 lg:-right-80',
        ]"
      ></div>

      <div
        class="hover:shadow-3xl relative z-10 overflow-hidden rounded-xl border border-gray-200/60 bg-white shadow-2xl ring-1 ring-black/5 transition-all duration-500 hover:-translate-y-2 sm:rounded-2xl"
      >
        <div class="flex h-10 items-center gap-2 border-b border-gray-200 bg-gray-50 px-4 sm:h-12">
          <div class="h-3 w-3 rounded-full border border-red-500/20 bg-red-400"></div>
          <div class="h-3 w-3 rounded-full border border-amber-500/20 bg-amber-400"></div>
          <div class="h-3 w-3 rounded-full border border-green-500/20 bg-green-400"></div>
        </div>
        <div class="relative overflow-hidden bg-gray-100">
          <img
            :src="imageSrc"
            :alt="title"
            class="block h-auto w-full"
          />
        </div>
      </div>
    </div>
  </div>
</template>
