<template>
  <div class="py-8 max-w-6xl mx-auto px-4">
    <div class="mb-8">
      <h1 class="text-3xl font-serif font-bold text-ink-800 mb-2">我的收藏</h1>
      <p class="text-ink-500">您收藏的诗词作品</p>
    </div>

    <div v-if="loading" class="bg-white rounded-xl shadow-sm border border-accent-200 p-8 text-center text-ink-500">
      加载中...
    </div>

    <div v-else-if="favoriteWorks.length > 0" class="space-y-4">
      <NuxtLink
        v-for="work in favoriteWorks"
        :key="work.work_id"
        :to="`/works/${work.work_id}`"
        class="block bg-white rounded-xl shadow-sm border border-accent-200 p-6 hover:shadow-md hover:border-primary-300 transition-all"
      >
        <h3 class="text-xl font-serif font-bold text-ink-800 mb-1">
          {{ work.title }}
        </h3>
        <p class="text-sm text-ink-500 mb-3">
          <span v-if="work.dynasty_name">〔{{ work.dynasty_name }}〕</span>
          {{ work.author_name || '佚名' }}
        </p>
        <p class="text-ink-600 line-clamp-2 font-serif">
          {{ work.content }}
        </p>
      </NuxtLink>
    </div>

    <div v-else class="bg-white rounded-xl shadow-sm border border-accent-200 p-8 text-center">
      <p class="text-ink-500 mb-4">您还没有收藏任何诗词</p>
      <NuxtLink to="/works" class="text-primary-600 hover:text-primary-700">
        去浏览诗词 →
      </NuxtLink>
    </div>
  </div>
</template>

<script setup lang="ts">
const favoriteWorks = ref<any[]>([])
const loading = ref(true)

onMounted(async () => {
  const favorites = JSON.parse(localStorage.getItem('favorites') || '[]')
  if (favorites.length > 0) {
    const works = await Promise.all(
      favorites.map((id: string) => 
        $fetch(`/api/works/${id}`).catch(() => null)
      )
    )
    favoriteWorks.value = works.filter(Boolean)
  }
  loading.value = false
})

useSeoMeta({
  title: '我的收藏 - 皮皮谷',
  description: '查看您收藏的诗词作品'
})
</script>
