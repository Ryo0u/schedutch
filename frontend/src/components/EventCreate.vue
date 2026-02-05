<script setup>
import {ref, computed} from 'vue'
import axios from 'axios';
import { useRouter } from 'vue-router';
import { bottom } from '@popperjs/core';

const title = ref('')
const description = ref('')
const password = ref('')

const selectionMode = ref('range')
const range = ref({start: null,end: null})
const singleData = ref(null)
const defaultStartTime = ref('06:00')
const defaultEndTime = ref('21:00')
</script>

<template>
	<div class="max-w-6xl mx-auto p-6">
		<h2 class="text-3xl font-bold text-center text-gray-800 mb-8">
			イベント新規作成
		</h2>
		
		<div class="flex flex-col lg:flex-row gap-8">
			
			<div class="flex-1 min-w-75 bg-white p-6 rounded-xl shadow-sm border border-gray-100">
				
				<h3 class="text-center text-xl font-bold border-b-2 border-b-blue-500 pb-2 mb-6 text-gray-700">
					Step1 基本情報
				</h3>
				
				<div class="mb-7">
					<label class="block font-bold mb-2 text-gray-600 after:ml-0.5 after:text-red-500 after:content-['*']">イベント名</label>
					<input 
						v-model="title" type="text" placeholder="(例) ⚪︎⚪︎の練習日程 "
						class="w-full p-2 border border-gray-400 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
					>
				</div>
				
				<div class="mb-7">
					<label class="block font-bold mb-2 text-gray-600">詳細・備考</label>
					<textarea
						v-model="description" rows="5" placeholder="(例) 持ち物や集合場所"
						class="w-full p-2 border border-gray-400 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
					>
					</textarea>
				</div>
				
				<div class="mb-3">
					<label class="block font-bold mb-2 text-gray-600 after:ml-0.5 after:text-red-500 after:content-['*']">編集用パスワード</label>
					<input 
						v-model="password" type="password"
						class="w-full p-2 border border-gray-400 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition"
					>
				</div>
				
			</div>
			
			<div class="flex-3 min-w-75 bg-white p-6 rounded-xl shadow-sm border border-gray-100">
				
				<h3 class="text-center text-xl font-bold border-b-2 border-b-blue-500 pb-2 mb-4 text-gray-700">
					Step2  候補日を選択
				</h3>
				
				<div class="flex flex-col lg:flex-row items-center gap-3 mb-6">
					<div class=" flex-none flex justify-center">
						<div class="inline-flex bg-gray-200 p-2 rounded-lg">
							<button
								@click="selectionMode = 'range'"
								:class="selectionMode == 'range' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500 hover:text-gray-700'"
								class="px-6 py-1 rounded-md text-sm font-bold transition-all duration-200 cursor-pointer"
							>
								範囲選択
							</button>
	
							<button
								@click="selectionMode = 'single'"
								:class="selectionMode == 'single' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500 hover:text-gray-700'"
								class="px-6 py-1 rounded-md text-sm font-bold transition-all duration-200 cursor-pointer"
							>
								個別選択
							</button>
						</div>
					</div>
					
					<p class="flex-1 w-full text-sm text-blue-700 text-center bg-blue-50 rounded-full py-2">
							日付を
							<span v-if="selectionMode =='range'" class="font-bold border-b-2 border-blue-600">ドラッグ</span>
							<span v-else class="font-bold border-b-2 border-blue-600">クリック</span>
							して選択してください
					</p>
				</div>
				
				<div class="mb-6 flex justify-center">
  				<template v-if="selectionMode == 'range'">
						<div class="block sm:hidden w-full">
							<VDatePicker v-model.range="range" :columns="1" expanded transparent class="w-full" />
						</div>
						
						<div class="hidden sm:block w-full">
							<VDatePicker v-model.range="range" :columns="2" expanded transparent class="w-full" />
						</div>
  				</template>

					<template v-else>
						<div class="block sm:hidden w-full">
							<VDatePicker v-model="singleData" :columns="1" expanded transparent class="w-full" />
						</div>
						
						<div class="hidden sm:block w-full">
							<VDatePicker v-model="singleData" :columns="2" expanded transparent class="w-full" />
						</div>
					</template>
				</div>
				
				<div class="flex flex-col lg:flex-row items-center justify-between gap-4">
					<div class="flex items-center gap-2">
						<span class="font-bold text-gray-600 text-sm">時間：</span>
						<input v-model="defaultStartTime" type="time" class="p-2 border border-gray-400 rounded bg-white text-gray-700 outline-none">
						<span class="text-gray-600">〜</span>
						<input v-model="defaultEndTime" type="time" class="p-2 border border-gray-400 rounded bg-white text-gray-700 outline-none">
					</div>
					
					<button
						@click="addCandidates"
						class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-6 rounded-full shadow-md transition transform hover:transform-y-0.5 cursor-pointer"
					>
						↓ リストに追加
					</button>
				</div>
			</div>
		</div>
		
	</div>
</template>

<style scoped>
</style>