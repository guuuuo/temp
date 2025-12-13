<template>
  <div class="container mx-auto px-4 py-8">
    <section class="mb-12">
      <div class="bg-gradient-to-r from-primary-600 to-primary-800 rounded-2xl p-8 md:p-12 text-white relative overflow-hidden">
        <div class="absolute inset-0 opacity-10">
          <div class="absolute top-4 right-4 text-9xl font-bold opacity-20">詩</div>
        </div>
        <div class="relative z-10">
          <h1 class="text-3xl md:text-4xl font-bold mb-4">全唐诗</h1>
          <p class="text-lg md:text-xl text-primary-100 mb-6 max-w-2xl">
            收录唐代诗人作品四万余首，传承中华千年诗词文化
          </p>
          <div class="flex flex-wrap gap-4">
            <NuxtLink to="/poems" class="inline-flex items-center px-6 py-3 bg-white text-primary-700 rounded-lg font-medium hover:bg-primary-50 transition-colors">
              浏览诗文
              <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
              </svg>
            </NuxtLink>
            <NuxtLink to="/poets" class="inline-flex items-center px-6 py-3 border-2 border-white/50 text-white rounded-lg font-medium hover:bg-white/10 transition-colors">
              诗人列表
            </NuxtLink>
          </div>
        </div>
      </div>
    </section>
    
    <section class="mb-12">
      <div class="flex items-center justify-between mb-6">
        <h2 class="section-title mb-0">精选推荐</h2>
        <NuxtLink to="/poems" class="text-primary-600 hover:text-primary-700 font-medium text-sm">
          查看全部 →
        </NuxtLink>
      </div>
      
      <div v-if="pending" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div v-for="i in 6" :key="i" class="poem-card animate-pulse">
          <div class="p-5">
            <div class="h-6 bg-beige-200 rounded w-3/4 mb-4"></div>
            <div class="flex items-center mb-4">
              <div class="w-10 h-10 bg-beige-200 rounded-full mr-3"></div>
              <div class="h-4 bg-beige-200 rounded w-16"></div>
            </div>
            <div class="space-y-2">
              <div class="h-4 bg-beige-200 rounded w-full"></div>
              <div class="h-4 bg-beige-200 rounded w-5/6"></div>
            </div>
          </div>
        </div>
      </div>
      
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <PoemCard v-for="poem in poems" :key="poem.id" :poem="poem" />
      </div>
    </section>
    
    <section class="mb-12">
      <h2 class="section-title">诗词分类</h2>
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
        <NuxtLink 
          v-for="category in categories" 
          :key="category.name"
          :to="`/poems?tag=${category.name}`"
          class="bg-white rounded-lg p-4 text-center hover:shadow-md transition-shadow border border-beige-200 group"
        >
          <div class="text-3xl mb-2">{{ category.icon }}</div>
          <h3 class="font-medium text-ink-800 group-hover:text-primary-600 transition-colors">{{ category.name }}</h3>
          <p class="text-xs text-ink-500 mt-1">{{ category.count }}首</p>
        </NuxtLink>
      </div>
    </section>
    
    <section>
      <div class="flex items-center justify-between mb-6">
        <h2 class="section-title mb-0">著名诗人</h2>
        <NuxtLink to="/poets" class="text-primary-600 hover:text-primary-700 font-medium text-sm">
          查看全部 →
        </NuxtLink>
      </div>
      
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        <PoetCard v-for="poet in featuredPoets" :key="poet.id" :poet="poet" />
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
const { data, pending } = await useFetch('/api/poems', {
  query: { limit: 6 }
})

const poems = computed(() => data.value?.poems || [])

const { data: poetsData } = await useFetch('/api/poets', {
  query: { limit: 4 }
})

const featuredPoets = computed(() => poetsData.value?.poets || [])

const categories = [
  { name: '山水', icon: '🏔️', count: 2300 },
  { name: '思乡', icon: '🏠', count: 1850 },
  { name: '边塞', icon: '⚔️', count: 1200 },
  { name: '送别', icon: '👋', count: 1650 },
  { name: '抒情', icon: '💭', count: 3200 },
  { name: '咏物', icon: '🌸', count: 2100 }
]

useHead({
  title: '全唐诗 - 中国古典诗词典藏'
})
</script>
