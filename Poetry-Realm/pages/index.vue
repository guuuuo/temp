<template>
  <div>
    <section class="bg-gradient-to-b from-primary-50 to-accent-50 py-12 md:py-20">
      <div class="max-w-6xl mx-auto px-4 text-center">
        <h1 class="text-4xl md:text-5xl font-serif font-bold text-ink-800 mb-4">
          皮皮谷
        </h1>
        <p class="text-lg md:text-xl text-ink-600 mb-8">
          传承中华诗词文化，品味千年文学之美
        </p>
        
        <div class="max-w-2xl mx-auto">
          <div class="flex gap-2">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="搜索诗词、作者..."
              class="flex-1 px-4 py-3 rounded-lg border border-accent-300 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
              @keyup.enter="handleSearch"
            >
            <button
              @click="handleSearch"
              class="px-6 py-3 bg-primary-600 text-white rounded-lg hover:bg-primary-700 transition-colors"
            >
              搜索
            </button>
          </div>
        </div>
      </div>
    </section>

    <section class="py-12 max-w-6xl mx-auto px-4">
      <div class="mb-8">
        <h2 class="text-2xl font-serif font-bold text-ink-800 mb-2">每日一诗</h2>
        <p class="text-ink-500">每天为您精选一首经典诗词</p>
      </div>

      <div v-if="dailyQuote" class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 md:p-8">
        <NuxtLink :to="`/works/${dailyQuote.work_id}`" class="block hover:opacity-80 transition-opacity">
          <h3 class="text-xl md:text-2xl font-serif font-bold text-ink-800 mb-2">
            {{ dailyQuote.title }}
            <span v-if="dailyQuote.subtitle" class="text-lg text-ink-500 font-normal">· {{ dailyQuote.subtitle }}</span>
          </h3>
          <p class="text-ink-500 mb-4">
            <span v-if="dailyQuote.dynasty_name">〔{{ dailyQuote.dynasty_name }}〕</span>
            {{ dailyQuote.author_name || '佚名' }}
          </p>
          <div class="font-serif text-lg leading-loose text-ink-700 whitespace-pre-line">
            {{ dailyQuote.content }}
          </div>
        </NuxtLink>
      </div>
      <div v-else class="bg-white rounded-xl shadow-sm border border-accent-200 p-8 text-center text-ink-500">
        暂无推荐诗词，请先添加诗词数据
      </div>
    </section>

    <section class="py-12 max-w-6xl mx-auto px-4">
      <div class="flex items-center justify-between mb-8">
        <div>
          <h2 class="text-2xl font-serif font-bold text-ink-800 mb-2">诗文分类</h2>
          <p class="text-ink-500">按类型浏览诗词文</p>
        </div>
        <NuxtLink to="/categories" class="text-primary-600 hover:text-primary-700">
          查看全部 →
        </NuxtLink>
      </div>

      <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-7 gap-4">
        <NuxtLink
          v-for="cat in mainCategories"
          :key="cat.category_code"
          :to="`/works?category=${cat.category_code}`"
          class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 text-center hover:shadow-md hover:border-primary-300 transition-all"
        >
          <div class="text-3xl font-serif font-bold text-primary-600 mb-2">{{ cat.category_name }}</div>
          <div class="text-sm text-ink-500">{{ cat.work_count || 0 }} 篇</div>
        </NuxtLink>
      </div>
    </section>

    <section class="py-12 max-w-6xl mx-auto px-4">
      <div class="flex items-center justify-between mb-8">
        <div>
          <h2 class="text-2xl font-serif font-bold text-ink-800 mb-2">朝代</h2>
          <p class="text-ink-500">按朝代浏览诗词</p>
        </div>
      </div>

      <div class="flex flex-wrap gap-3">
        <NuxtLink
          v-for="dynasty in dynasties"
          :key="dynasty.dynasty_code"
          :to="`/works?dynasty=${dynasty.dynasty_code}`"
          class="px-4 py-2 bg-white rounded-lg border border-accent-200 text-ink-600 hover:border-primary-300 hover:text-primary-600 transition-all"
        >
          {{ dynasty.dynasty_name }}
        </NuxtLink>
      </div>
    </section>

    <section v-if="featuredWorks.length > 0" class="py-12 max-w-6xl mx-auto px-4">
      <div class="flex items-center justify-between mb-8">
        <div>
          <h2 class="text-2xl font-serif font-bold text-ink-800 mb-2">精选诗文</h2>
          <p class="text-ink-500">编辑推荐的经典作品</p>
        </div>
        <NuxtLink to="/works" class="text-primary-600 hover:text-primary-700">
          查看全部 →
        </NuxtLink>
      </div>

      <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        <NuxtLink
          v-for="work in featuredWorks"
          :key="work.work_id"
          :to="`/works/${work.work_id}`"
          class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 hover:shadow-md hover:border-primary-300 transition-all"
        >
          <h3 class="text-lg font-serif font-bold text-ink-800 mb-1">{{ work.title }}</h3>
          <p class="text-sm text-ink-500 mb-3">
            <span v-if="work.dynasty_name">〔{{ work.dynasty_name }}〕</span>
            {{ work.author_name || '佚名' }}
          </p>
          <p class="text-ink-600 line-clamp-3 font-serif">
            {{ work.content?.split('\n').slice(0, 2).join('\n') }}
          </p>
        </NuxtLink>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
const searchQuery = ref('')

const { data: dailyQuote } = await useFetch('/api/daily-quote')
const { data: categoriesData } = await useFetch('/api/categories')
const { data: dynasties } = await useFetch('/api/dynasties')
const { data: worksData } = await useFetch('/api/works', {
  query: { featured: 'true', limit: 6 }
})

const mainCategories = computed(() => {
  return (categoriesData.value || []).filter((c: any) => !c.parent_code)
})

const featuredWorks = computed(() => {
  return worksData.value?.data || []
})

const router = useRouter()

function handleSearch() {
  if (searchQuery.value.trim()) {
    router.push(`/works?search=${encodeURIComponent(searchQuery.value.trim())}`)
  }
}

useSeoMeta({
  title: '皮皮谷 - 中华诗词文库',
  description: '皮皮谷是一个传承中华诗词文化的在线平台，收录古诗、词、曲、赋等经典文学作品，提供译文、注释、赏析等功能。',
  ogTitle: '皮皮谷 - 中华诗词文库',
  ogDescription: '传承中华诗词文化，收录古诗、词、曲、赋等经典文学作品'
})
</script>
