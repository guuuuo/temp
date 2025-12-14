<template>
  <div class="py-8 max-w-6xl mx-auto px-4">
    <div class="mb-8">
      <h1 class="text-3xl font-serif font-bold text-ink-800 mb-2">诗文列表</h1>
      <p class="text-ink-500">浏览中华经典诗词文</p>
    </div>

    <div class="bg-white rounded-xl shadow-sm border border-accent-200 p-4 mb-8">
      <div class="flex flex-wrap gap-4">
        <div class="flex-1 min-w-[200px]">
          <input
            v-model="search"
            type="text"
            placeholder="搜索诗词..."
            class="w-full px-4 py-2 rounded-lg border border-accent-300 focus:outline-none focus:ring-2 focus:ring-primary-500"
            @input="debouncedSearch"
          >
        </div>
        <select
          v-model="selectedDynasty"
          class="px-4 py-2 rounded-lg border border-accent-300 focus:outline-none focus:ring-2 focus:ring-primary-500"
          @change="loadWorks"
        >
          <option value="">全部朝代</option>
          <option v-for="d in dynasties" :key="d.dynasty_code" :value="d.dynasty_code">
            {{ d.dynasty_name }}
          </option>
        </select>
        <select
          v-model="selectedCategory"
          class="px-4 py-2 rounded-lg border border-accent-300 focus:outline-none focus:ring-2 focus:ring-primary-500"
          @change="loadWorks"
        >
          <option value="">全部分类</option>
          <option v-for="c in mainCategories" :key="c.category_code" :value="c.category_code">
            {{ c.category_name }}
          </option>
        </select>
      </div>
    </div>

    <div v-if="works.length > 0" class="space-y-4">
      <NuxtLink
        v-for="work in works"
        :key="work.work_id"
        :to="`/works/${work.work_id}`"
        class="block bg-white rounded-xl shadow-sm border border-accent-200 p-6 hover:shadow-md hover:border-primary-300 transition-all"
      >
        <div class="flex flex-col md:flex-row md:items-start gap-4">
          <div class="flex-1">
            <h3 class="text-xl font-serif font-bold text-ink-800 mb-1">
              {{ work.title }}
              <span v-if="work.subtitle" class="text-base text-ink-500 font-normal">· {{ work.subtitle }}</span>
            </h3>
            <p class="text-sm text-ink-500 mb-3">
              <span v-if="work.dynasty_name">〔{{ work.dynasty_name }}〕</span>
              {{ work.author_name || '佚名' }}
              <span v-if="work.category_name" class="ml-2 text-primary-600">{{ work.category_name }}</span>
            </p>
            <p class="text-ink-600 line-clamp-3 font-serif leading-relaxed whitespace-pre-line">
              {{ work.content }}
            </p>
          </div>
          <div class="flex items-center gap-4 text-sm text-ink-400">
            <span>阅读 {{ work.view_count || 0 }}</span>
          </div>
        </div>
      </NuxtLink>
    </div>

    <div v-else class="bg-white rounded-xl shadow-sm border border-accent-200 p-8 text-center text-ink-500">
      暂无诗文数据
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
const selectedCategory = ref(route.query.category as string || '')

const { data: dynasties } = await useFetch('/api/dynasties')
const { data: categories } = await useFetch('/api/categories')

const mainCategories = computed(() => {
  return (categories.value || []).filter((c: any) => !c.parent_code)
})

const { data: worksData, refresh } = await useFetch('/api/works', {
  query: {
    page,
    dynasty: selectedDynasty,
    category: selectedCategory,
    search,
    limit: 10
  }
})

const works = computed(() => worksData.value?.data || [])
const pagination = computed(() => worksData.value?.pagination || { page: 1, totalPages: 1 })

let searchTimeout: any = null
function debouncedSearch() {
  clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    page.value = 1
    loadWorks()
  }, 300)
}

function loadWorks() {
  router.push({
    query: {
      ...route.query,
      page: page.value,
      dynasty: selectedDynasty.value || undefined,
      category: selectedCategory.value || undefined,
      search: search.value || undefined
    }
  })
  refresh()
}

function goToPage(newPage: number) {
  page.value = newPage
  loadWorks()
}

useSeoMeta({
  title: '诗文列表 - 皮皮谷',
  description: '浏览中华经典诗词文，包括唐诗、宋词、元曲等历代名篇。'
})
</script>
