<template>
  <div class="py-8 max-w-6xl mx-auto px-4">
    <div v-if="author" class="space-y-8">
      <div class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 md:p-8">
        <div class="flex flex-col md:flex-row gap-6">
          <div class="w-24 h-24 md:w-32 md:h-32 rounded-full bg-accent-100 flex items-center justify-center text-4xl md:text-5xl font-serif text-primary-600 flex-shrink-0 mx-auto md:mx-0">
            {{ author.author_name?.charAt(0) }}
          </div>
          <div class="flex-1 text-center md:text-left">
            <h1 class="text-3xl font-serif font-bold text-ink-800 mb-2">{{ author.author_name }}</h1>
            <p class="text-ink-500 mb-4">
              <span v-if="author.dynasty_name">〔{{ author.dynasty_name }}〕</span>
              <span v-if="author.birth_year || author.death_year">
                {{ author.birth_year || '?' }} - {{ author.death_year || '?' }}
              </span>
            </p>
            <div class="flex flex-wrap gap-4 justify-center md:justify-start text-sm">
              <span v-if="author.courtesy_name" class="text-ink-600">
                <span class="text-ink-400">字</span> {{ author.courtesy_name }}
              </span>
              <span v-if="author.pseudonym" class="text-ink-600">
                <span class="text-ink-400">号</span> {{ author.pseudonym }}
              </span>
              <span v-if="author.birthplace" class="text-ink-600">
                <span class="text-ink-400">籍贯</span> {{ author.birthplace }}
              </span>
            </div>
          </div>
        </div>

        <div v-if="author.short_description || author.biography" class="mt-6 pt-6 border-t border-accent-100">
          <h2 class="text-lg font-bold text-ink-800 mb-3">简介</h2>
          <p class="text-ink-600 leading-relaxed whitespace-pre-line">
            {{ author.biography || author.short_description }}
          </p>
        </div>
      </div>

      <div v-if="author.works && author.works.length > 0">
        <h2 class="text-2xl font-serif font-bold text-ink-800 mb-4">作品列表</h2>
        <div class="grid md:grid-cols-2 gap-4">
          <NuxtLink
            v-for="work in author.works"
            :key="work.work_id"
            :to="`/works/${work.work_id}`"
            class="bg-white rounded-xl shadow-sm border border-accent-200 p-4 hover:shadow-md hover:border-primary-300 transition-all"
          >
            <h3 class="font-serif font-bold text-ink-800">{{ work.title }}</h3>
            <p v-if="work.category_name" class="text-sm text-ink-500 mt-1">{{ work.category_name }}</p>
            <p v-if="work.first_line" class="text-sm text-ink-600 mt-2 line-clamp-1 font-serif">
              {{ work.first_line }}
            </p>
          </NuxtLink>
        </div>
      </div>
    </div>

    <div v-else class="bg-white rounded-xl shadow-sm border border-accent-200 p-8 text-center text-ink-500">
      作者不存在
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const { data: author } = await useFetch(`/api/authors/${route.params.id}`)

useSeoMeta({
  title: () => author.value ? `${author.value.author_name} - 皮皮谷` : '作者详情 - 皮皮谷',
  description: () => author.value?.short_description || author.value?.biography?.slice(0, 160) || ''
})
</script>
