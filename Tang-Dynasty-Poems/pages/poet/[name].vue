<template>
  <div class="container mx-auto px-4 py-8">
    <div v-if="pending" class="max-w-4xl mx-auto">
      <div class="animate-pulse">
        <div class="flex items-center mb-8">
          <div class="w-24 h-24 bg-beige-200 rounded-full mr-6"></div>
          <div>
            <div class="h-8 bg-beige-200 rounded w-32 mb-2"></div>
            <div class="h-4 bg-beige-200 rounded w-48"></div>
          </div>
        </div>
      </div>
    </div>
    
    <div v-else-if="error" class="text-center py-16">
      <div class="text-6xl mb-4">👤</div>
      <h2 class="text-xl font-semibold text-ink-900 mb-2">诗人未找到</h2>
      <p class="text-ink-600 mb-6">抱歉，您查找的诗人不存在</p>
      <NuxtLink to="/poets" class="inline-flex items-center px-6 py-3 bg-primary-600 text-white rounded-lg font-medium hover:bg-primary-700 transition-colors">
        返回诗人列表
      </NuxtLink>
    </div>
    
    <div v-else class="max-w-4xl mx-auto">
      <nav class="flex items-center space-x-2 text-sm text-ink-500 mb-6">
        <NuxtLink to="/" class="hover:text-primary-600">首页</NuxtLink>
        <span>/</span>
        <NuxtLink to="/poets" class="hover:text-primary-600">诗人</NuxtLink>
        <span>/</span>
        <span class="text-ink-800">{{ data?.poet?.name }}</span>
      </nav>
      
      <div class="bg-white rounded-2xl shadow-sm border border-beige-200 overflow-hidden mb-8">
        <div class="p-6 md:p-10">
          <div class="flex flex-col md:flex-row items-center md:items-start">
            <div class="w-24 h-24 md:w-32 md:h-32 rounded-full bg-gradient-to-br from-primary-400 to-primary-600 flex items-center justify-center mb-4 md:mb-0 md:mr-8 shadow-lg">
              <span class="text-white text-4xl md:text-5xl font-bold">{{ data?.poet?.name?.charAt(0) }}</span>
            </div>
            <div class="text-center md:text-left">
              <h1 class="text-3xl md:text-4xl font-bold text-ink-900 mb-2">{{ data?.poet?.name }}</h1>
              <span class="dynasty-tag mb-4 inline-block">唐代</span>
              <p v-if="data?.poet?.desc" class="text-ink-600 leading-relaxed max-w-2xl">
                {{ data.poet.desc }}
              </p>
            </div>
          </div>
        </div>
      </div>
      
      <section>
        <h2 class="section-title">作品列表 ({{ data?.poems?.length || 0 }}首)</h2>
        
        <div v-if="!data?.poems || data.poems.length === 0" class="text-center py-12 bg-white rounded-xl border border-beige-200">
          <div class="text-4xl mb-4">📜</div>
          <p class="text-ink-600">暂无收录该诗人的作品</p>
        </div>
        
        <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <PoemCard v-for="poem in data.poems" :key="poem.id" :poem="poem" />
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const name = decodeURIComponent(route.params.name as string)

const { data, pending, error } = await useFetch(`/api/poets/${encodeURIComponent(name)}`)

useHead({
  title: computed(() => data.value?.poet ? `${data.value.poet.name} - 诗人介绍 - 全唐诗` : '加载中... - 全唐诗')
})
</script>
