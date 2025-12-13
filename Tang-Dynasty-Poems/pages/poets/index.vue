<template>
  <div class="container mx-auto px-4 py-8">
    <div class="mb-8">
      <h1 class="text-2xl md:text-3xl font-bold text-ink-900 mb-2">诗人列表</h1>
      <p class="text-ink-600">收录唐代著名诗人 {{ total }} 位</p>
    </div>
    
    <div class="mb-6">
      <div class="relative max-w-md">
        <input 
          v-model="searchQuery"
          type="text" 
          placeholder="搜索诗人..." 
          class="search-input pr-10"
          @input="debouncedSearch"
        />
        <svg class="w-5 h-5 absolute right-3 top-1/2 -translate-y-1/2 text-ink-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </div>
    </div>
    
    <div v-if="pending" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
      <div v-for="i in 8" :key="i" class="poem-card animate-pulse">
        <div class="p-5 flex items-center">
          <div class="w-16 h-16 bg-beige-200 rounded-full mr-4"></div>
          <div class="flex-1">
            <div class="h-5 bg-beige-200 rounded w-20 mb-2"></div>
            <div class="h-4 bg-beige-200 rounded w-12 mb-2"></div>
            <div class="h-3 bg-beige-200 rounded w-full"></div>
          </div>
        </div>
      </div>
    </div>
    
    <div v-else>
      <div v-if="poets.length === 0" class="text-center py-16">
        <div class="text-6xl mb-4">👤</div>
        <p class="text-ink-600 text-lg">暂无相关诗人</p>
      </div>
      
      <div v-else class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        <PoetCard v-for="poet in poets" :key="poet.id" :poet="poet" />
      </div>
      
      <div v-if="totalPages > 1" class="flex justify-center mt-10">
        <div class="flex items-center space-x-2">
          <button 
            @click="goToPage(currentPage - 1)"
            :disabled="currentPage === 1"
            class="px-4 py-2 rounded-lg border border-beige-300 text-ink-600 hover:bg-beige-100 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            上一页
          </button>
          
          <div class="flex items-center space-x-1">
            <button 
              v-for="page in visiblePages" 
              :key="page"
              @click="goToPage(page)"
              :class="[
                'w-10 h-10 rounded-lg font-medium transition-colors',
                page === currentPage 
                  ? 'bg-primary-600 text-white' 
                  : 'text-ink-600 hover:bg-beige-100'
              ]"
            >
              {{ page }}
            </button>
          </div>
          
          <button 
            @click="goToPage(currentPage + 1)"
            :disabled="currentPage === totalPages"
            class="px-4 py-2 rounded-lg border border-beige-300 text-ink-600 hover:bg-beige-100 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            下一页
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const router = useRouter()

const currentPage = ref(parseInt(route.query.page as string) || 1)
const searchQuery = ref('')

const { data, pending, refresh } = await useFetch('/api/poets', {
  query: computed(() => ({
    page: currentPage.value,
    limit: 12,
    q: searchQuery.value || undefined
  }))
})

const poets = computed(() => data.value?.poets || [])
const total = computed(() => data.value?.total || 0)
const totalPages = computed(() => Math.ceil(total.value / 12))

const visiblePages = computed(() => {
  const pages = []
  const start = Math.max(1, currentPage.value - 2)
  const end = Math.min(totalPages.value, start + 4)
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  return pages
})

let searchTimeout: ReturnType<typeof setTimeout>
const debouncedSearch = () => {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    currentPage.value = 1
  }, 300)
}

const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    router.push({ query: { page: String(page) } })
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

useHead({
  title: '诗人列表 - 全唐诗'
})
</script>
