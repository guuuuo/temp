<template>
  <div class="py-8 max-w-6xl mx-auto px-4">
    <div class="mb-8">
      <h1 class="text-3xl font-serif font-bold text-ink-800 mb-2">诗文分类</h1>
      <p class="text-ink-500">按类型浏览中华诗词文</p>
    </div>

    <div class="space-y-8">
      <div v-for="parent in parentCategories" :key="parent.category_code" class="bg-white rounded-xl shadow-sm border border-accent-200 p-6">
        <NuxtLink 
          :to="`/works?category=${parent.category_code}`"
          class="flex items-center justify-between mb-4 group"
        >
          <div>
            <h2 class="text-2xl font-serif font-bold text-ink-800 group-hover:text-primary-600 transition-colors">
              {{ parent.category_name }}
            </h2>
            <p class="text-ink-500 mt-1">{{ parent.description }}</p>
          </div>
          <div class="text-ink-400 group-hover:text-primary-600">
            {{ parent.work_count || 0 }} 篇 →
          </div>
        </NuxtLink>

        <div v-if="getChildren(parent.category_code).length > 0" class="flex flex-wrap gap-3 pt-4 border-t border-accent-100">
          <NuxtLink
            v-for="child in getChildren(parent.category_code)"
            :key="child.category_code"
            :to="`/works?category=${child.category_code}`"
            class="px-4 py-2 bg-accent-50 rounded-lg text-ink-600 hover:bg-primary-50 hover:text-primary-600 transition-all"
          >
            {{ child.category_name }}
            <span class="text-ink-400 ml-1">({{ child.work_count || 0 }})</span>
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { data: categories } = await useFetch('/api/categories')

const parentCategories = computed(() => {
  return (categories.value || []).filter((c: any) => !c.parent_code)
})

function getChildren(parentCode: string) {
  return (categories.value || []).filter((c: any) => c.parent_code === parentCode)
}

useSeoMeta({
  title: '诗文分类 - 皮皮谷',
  description: '按类型浏览中华诗词文，包括诗、词、曲、赋、经典、蒙学等分类。'
})
</script>
