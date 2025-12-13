<template>
  <div class="container mx-auto px-4 py-8">
    <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
      <div>
        <h1 class="text-2xl md:text-3xl font-bold text-ink-900 mb-2">诗文列表</h1>
        <p class="text-ink-600">共收录 {{ total }} 首唐诗</p>
      </div>
      
      <div class="mt-4 md:mt-0 flex flex-wrap gap-2">
        <button 
          v-for="tag in tags" 
          :key="tag"
          @click="toggleTag(tag)"
          :class="[
            'px-3 py-1.5 rounded-full text-sm font-medium transition-colors',
            selectedTag === tag 
              ? 'bg-primary-600 text-white' 
              : 'bg-beige-100 text-ink-600 hover:bg-primary-100 hover:text-primary-700'
          ]"
        >
          {{ tag }}
        </button>
      </div>
    </div>
    
    <div v-if="pending" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="i in 9" :key="i" class="poem-card animate-pulse">
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
        <div class="text-6xl mb-4">📜</div>
        <p class="text-ink-600 text-lg">暂无相关诗文</p>
      </div>
      
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <PoemCard v-for="poem in poems" :key="poem.id" :poem="poem" />
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
const selectedTag = ref(route.query.tag as string || '')

const tags = ['全部', '山水', '思乡', '边塞', '送别', '抒情', '咏物', '写景', '爱情']

const { data, pending, refresh } = await useFetch('/api/poems', {
  query: computed(() => ({
    page: currentPage.value,
    limit: 12,
    tag: selectedTag.value && selectedTag.value !== '全部' ? selectedTag.value : undefined
  }))
})

const poems = computed(() => data.value?.poems || [])
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

const toggleTag = (tag: string) => {
  selectedTag.value = tag === '全部' ? '' : tag
  currentPage.value = 1
  updateUrl()
}

const goToPage = (page: number) => {
  if (page >= 1 && page <= totalPages.value) {
    currentPage.value = page
    updateUrl()
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

const updateUrl = () => {
  const query: Record<string, string> = {}
  if (currentPage.value > 1) query.page = String(currentPage.value)
  if (selectedTag.value) query.tag = selectedTag.value
  router.push({ query })
}

watch(() => route.query, () => {
  currentPage.value = parseInt(route.query.page as string) || 1
  selectedTag.value = (route.query.tag as string) || ''
})

useHead({
  title: '诗文列表 - 全唐诗'
})
</script>
