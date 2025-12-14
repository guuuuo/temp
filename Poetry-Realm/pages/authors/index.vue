<template>
  <div class="py-8 max-w-6xl mx-auto px-4">
    <div class="mb-8">
      <h1 class="text-3xl font-serif font-bold text-ink-800 mb-2">作者列表</h1>
      <p class="text-ink-500">浏览历代诗词作者</p>
    </div>

    <div class="bg-white rounded-xl shadow-sm border border-accent-200 p-4 mb-8">
      <div class="flex flex-wrap gap-4">
        <div class="flex-1 min-w-[200px]">
          <input
            v-model="search"
            type="text"
            placeholder="搜索作者..."
            class="w-full px-4 py-2 rounded-lg border border-accent-300 focus:outline-none focus:ring-2 focus:ring-primary-500"
            @input="debouncedSearch"
          >
        </div>
        <select
          v-model="selectedDynasty"
          class="px-4 py-2 rounded-lg border border-accent-300 focus:outline-none focus:ring-2 focus:ring-primary-500"
          @change="loadAuthors"
        >
          <option value="">全部朝代</option>
          <option v-for="d in dynasties" :key="d.dynasty_code" :value="d.dynasty_code">
            {{ d.dynasty_name }}
          </option>
        </select>
      </div>
    </div>

    <div v-if="authors.length > 0" class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
      <NuxtLink
        v-for="author in authors"
        :key="author.author_id"
        :to="`/authors/${author.author_id}`"
        class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 hover:shadow-md hover:border-primary-300 transition-all"
      >
        <div class="flex items-start gap-4">
          <div class="w-16 h-16 rounded-full bg-accent-100 flex items-center justify-center text-2xl font-serif text-primary-600 flex-shrink-0">
            {{ author.author_name?.charAt(0) }}
          </div>
          <div class="flex-1 min-w-0">
            <h3 class="text-lg font-serif font-bold text-ink-800">{{ author.author_name }}</h3>
            <p class="text-sm text-ink-500">
              <span v-if="author.dynasty_name">〔{{ author.dynasty_name }}〕</span>
              <span v-if="author.courtesy_name">字 {{ author.courtesy_name }}</span>
            </p>
            <p class="text-sm text-primary-600 mt-1">{{ author.work_count || 0 }} 篇作品</p>
            <p v-if="author.short_description" class="text-sm text-ink-500 mt-2 line-clamp-2">
              {{ author.short_description }}
            </p>
          </div>
        </div>
      </NuxtLink>
    </div>

    <div v-else class="bg-white rounded-xl shadow-sm border border-accent-200 p-8 text-center text-ink-500">
      暂无作者数据
    </div>

    <div v-if="pagination.totalPages > 1" class="flex justify-center gap-2 mt-8">
      <button
        :disabled="page <= 1"
        @click="goToPage(page - 1)"
        class="px-4 py-2 rounded-lg border border-accent-300 disabled:opacity-50 hover:bg-accent-50"
      >
        上一页
      </button>
      <span class="px-4 py-2 text-ink-600">
        {{ page }} / {{ pagination.totalPages }}
      </span>
      <button
        :disabled="page >= pagination.totalPages"
        @click="goToPage(page + 1)"
        class="px-4 py-2 rounded-lg border border-accent-300 disabled:opacity-50 hover:bg-accent-50"
      >
        下一页
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const router = useRouter()

const page = ref(parseInt(route.query.page as string) || 1)
const search = ref(route.query.search as string || '')
const selectedDynasty = ref(route.query.dynasty as string || '')

const { data: dynasties } = await useFetch('/api/dynasties')

const { data: authorsData, refresh } = await useFetch('/api/authors', {
  query: {
    page,
    dynasty: selectedDynasty,
    search,
    limit: 12
  }
})

const authors = computed(() => authorsData.value?.data || [])
const pagination = computed(() => authorsData.value?.pagination || { page: 1, totalPages: 1 })

let searchTimeout: any = null
function debouncedSearch() {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    page.value = 1
    loadAuthors()
  }, 300)
}

function loadAuthors() {
  router.push({
    query: {
      ...route.query,
      page: page.value,
      dynasty: selectedDynasty.value || undefined,
      search: search.value || undefined
    }
  })
  refresh()
}

function goToPage(newPage: number) {
  page.value = newPage
  loadAuthors()
}

useSeoMeta({
  title: '作者列表 - 皮皮谷',
  description: '浏览历代诗词作者，包括唐代李白、杜甫、宋代苏轼、李清照等著名诗人词人。'
})
</script>
