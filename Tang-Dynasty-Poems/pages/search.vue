<template>
  <div class="container mx-auto px-4 py-8">
    <div class="mb-8">
      <h1 class="text-2xl md:text-3xl font-bold text-ink-900 mb-2">搜索结果</h1>
      <p class="text-ink-600">
        搜索 "<span class="text-primary-600 font-medium">{{ query }}</span>" 找到 {{ total }} 条结果
      </p>
    </div>
    
    <div class="mb-6">
      <div class="relative max-w-lg">
        <input 
          v-model="searchInput"
          type="text" 
          placeholder="搜索诗词、诗人..." 
          class="search-input pr-10"
          @keyup.enter="handleSearch"
        />
        <button 
          @click="handleSearch"
          class="absolute right-3 top-1/2 -translate-y-1/2 text-ink-400 hover:text-primary-600"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </button>
      </div>
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
    
    <div v-else>
      <div v-if="poems.length === 0" class="text-center py-16">
        <div class="text-6xl mb-4">🔍</div>
        <h2 class="text-xl font-semibold text-ink-900 mb-2">未找到相关结果</h2>
        <p class="text-ink-600 mb-6">请尝试其他关键词</p>
        <NuxtLink to="/poems" class="inline-flex items-center px-6 py-3 bg-primary-600 text-white rounded-lg font-medium hover:bg-primary-700 transition-colors">
          浏览全部诗文
        </NuxtLink>
      </div>
      
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <PoemCard v-for="poem in poems" :key="poem.id" :poem="poem" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const router = useRouter()

const query = computed(() => (route.query.q as string) || '')
const searchInput = ref(query.value)

const { data, pending } = await useFetch('/api/poems', {
  query: computed(() => ({
    q: query.value,
    limit: 50
  }))
})

const poems = computed(() => data.value?.poems || [])
const total = computed(() => data.value?.total || 0)

const handleSearch = () => {
  if (searchInput.value.trim()) {
    router.push(`/search?q=${encodeURIComponent(searchInput.value.trim())}`)
  }
}

watch(query, (newQuery) => {
  searchInput.value = newQuery
})

useHead({
  title: computed(() => `搜索: ${query.value} - 全唐诗`)
})
</script>
