<template>
  <div class="py-8 max-w-4xl mx-auto px-4">
    <div v-if="work" class="space-y-6">
      <div class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 md:p-8">
        <div class="text-center mb-8">
          <h1 class="text-3xl md:text-4xl font-serif font-bold text-ink-800 mb-2">
            {{ work.title }}
          </h1>
          <p v-if="work.subtitle" class="text-lg text-ink-500 mb-4">{{ work.subtitle }}</p>
          <p class="text-ink-500">
            <NuxtLink 
              v-if="work.author_id" 
              :to="`/authors/${work.author_id}`"
              class="hover:text-primary-600"
            >
              <span v-if="work.dynasty_name">〔{{ work.dynasty_name }}〕</span>
              {{ work.author_name || '佚名' }}
            </NuxtLink>
            <span v-else>
              <span v-if="work.dynasty_name">〔{{ work.dynasty_name }}〕</span>
              {{ work.author_name || '佚名' }}
            </span>
          </p>
        </div>

        <div v-if="work.preface" class="text-center text-ink-500 mb-6 italic">
          {{ work.preface }}
        </div>

        <div class="font-serif text-xl md:text-2xl leading-loose text-ink-800 text-center">
          <p 
            v-for="(para, index) in work.paragraphs" 
            :key="para.paragraph_id"
            class="mb-4"
            :class="{ 'font-bold': para.is_title_line }"
          >
            {{ para.content }}
          </p>
        </div>

        <div class="flex justify-center gap-4 mt-8 pt-6 border-t border-accent-100">
          <button
            @click="toggleFavorite"
            class="flex items-center gap-2 px-4 py-2 rounded-lg border transition-all"
            :class="isFavorited ? 'bg-primary-50 border-primary-300 text-primary-600' : 'border-accent-300 text-ink-600 hover:border-primary-300'"
          >
            <span>{{ isFavorited ? '已收藏' : '收藏' }}</span>
          </button>
          <button
            @click="copyLink"
            class="flex items-center gap-2 px-4 py-2 rounded-lg border border-accent-300 text-ink-600 hover:border-primary-300 transition-all"
          >
            <span>{{ copied ? '已复制' : '分享' }}</span>
          </button>
        </div>
      </div>

      <div class="flex gap-2 flex-wrap justify-center">
        <button
          v-for="tab in tabs"
          :key="tab.key"
          @click="activeTab = tab.key"
          class="px-4 py-2 rounded-lg transition-all"
          :class="activeTab === tab.key ? 'bg-primary-600 text-white' : 'bg-white border border-accent-200 text-ink-600 hover:border-primary-300'"
        >
          {{ tab.label }}
        </button>
      </div>

      <div v-if="activeTab === 'translation'" class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 md:p-8">
        <h2 class="text-xl font-bold text-ink-800 mb-4">译文</h2>
        <div v-if="work.translation" class="text-ink-600 leading-relaxed whitespace-pre-line">
          {{ work.translation }}
        </div>
        <p v-else class="text-ink-400">暂无译文</p>
      </div>

      <div v-if="activeTab === 'pinyin'" class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 md:p-8">
        <h2 class="text-xl font-bold text-ink-800 mb-4">拼音</h2>
        <div class="font-serif text-lg leading-loose text-center">
          <p v-for="para in work.paragraphs" :key="para.paragraph_id" class="mb-4">
            <span class="text-ink-800">{{ para.content }}</span>
          </p>
        </div>
        <p class="text-ink-400 text-center mt-4">拼音功能开发中...</p>
      </div>

      <div v-if="activeTab === 'annotations'" class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 md:p-8">
        <h2 class="text-xl font-bold text-ink-800 mb-4">注释</h2>
        <div v-if="work.annotations && work.annotations.length > 0" class="space-y-4">
          <div v-for="ann in work.annotations" :key="ann.annotation_id" class="border-b border-accent-100 pb-4 last:border-0">
            <span class="font-bold text-primary-600">{{ ann.term }}</span>
            <span v-if="ann.pronunciation" class="text-ink-400 ml-2">[{{ ann.pronunciation }}]</span>
            <p class="text-ink-600 mt-1">{{ ann.explanation }}</p>
          </div>
        </div>
        <p v-else class="text-ink-400">暂无注释</p>
      </div>

      <div v-if="activeTab === 'appreciation'" class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 md:p-8">
        <h2 class="text-xl font-bold text-ink-800 mb-4">赏析</h2>
        <div v-if="work.appreciations && work.appreciations.length > 0" class="space-y-6">
          <div v-for="app in work.appreciations" :key="app.appreciation_id">
            <p class="text-ink-600 leading-relaxed whitespace-pre-line">{{ app.content }}</p>
            <p v-if="app.author_name || app.source" class="text-ink-400 text-sm mt-2">
              —— {{ app.author_name }}{{ app.source ? ` 《${app.source}》` : '' }}
            </p>
          </div>
        </div>
        <div v-else-if="work.introduction" class="text-ink-600 leading-relaxed whitespace-pre-line">
          {{ work.introduction }}
        </div>
        <p v-else class="text-ink-400">暂无赏析</p>
      </div>

      <div v-if="work.author_description" class="bg-white rounded-xl shadow-sm border border-accent-200 p-6 md:p-8">
        <h2 class="text-xl font-bold text-ink-800 mb-4">关于作者</h2>
        <NuxtLink 
          :to="`/authors/${work.author_id}`"
          class="block hover:bg-accent-50 -m-2 p-2 rounded-lg transition-colors"
        >
          <p class="font-bold text-ink-800 mb-2">{{ work.author_name }}</p>
          <p class="text-ink-600">{{ work.author_description }}</p>
        </NuxtLink>
      </div>
    </div>

    <div v-else class="bg-white rounded-xl shadow-sm border border-accent-200 p-8 text-center text-ink-500">
      作品不存在
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const { data: work } = await useFetch(`/api/works/${route.params.id}`)

const tabs = [
  { key: 'translation', label: '译文' },
  { key: 'pinyin', label: '拼音' },
  { key: 'annotations', label: '注释' },
  { key: 'appreciation', label: '赏析' }
]

const activeTab = ref('translation')
const isFavorited = ref(false)
const copied = ref(false)

onMounted(() => {
  if (work.value) {
    const favorites = JSON.parse(localStorage.getItem('favorites') || '[]')
    isFavorited.value = favorites.includes(work.value.work_id)
  }
})

function toggleFavorite() {
  if (!work.value) return
  const favorites = JSON.parse(localStorage.getItem('favorites') || '[]')
  const index = favorites.indexOf(work.value.work_id)
  if (index > -1) {
    favorites.splice(index, 1)
    isFavorited.value = false
  } else {
    favorites.push(work.value.work_id)
    isFavorited.value = true
  }
  localStorage.setItem('favorites', JSON.stringify(favorites))
}

function copyLink() {
  navigator.clipboard.writeText(window.location.href)
  copied.value = true
  setTimeout(() => { copied.value = false }, 2000)
}

useSeoMeta({
  title: () => work.value ? `${work.value.title} - ${work.value.author_name || '佚名'} - 皮皮谷` : '诗文详情 - 皮皮谷',
  description: () => {
    if (!work.value) return ''
    const content = work.value.paragraphs?.map((p: any) => p.content).join(' ').slice(0, 160)
    return `${work.value.title} - ${work.value.author_name || '佚名'}。${content}`
  },
  ogTitle: () => work.value ? `${work.value.title} - 皮皮谷` : '诗文详情',
  ogDescription: () => work.value?.paragraphs?.map((p: any) => p.content).join(' ').slice(0, 160)
})
</script>
