<template>
  <div class="container mx-auto px-4 py-8">
    <div v-if="pending" class="max-w-3xl mx-auto">
      <div class="animate-pulse">
        <div class="h-8 bg-beige-200 rounded w-1/2 mb-4"></div>
        <div class="h-4 bg-beige-200 rounded w-1/4 mb-8"></div>
        <div class="space-y-4">
          <div class="h-6 bg-beige-200 rounded w-full"></div>
          <div class="h-6 bg-beige-200 rounded w-5/6"></div>
          <div class="h-6 bg-beige-200 rounded w-full"></div>
          <div class="h-6 bg-beige-200 rounded w-4/5"></div>
        </div>
      </div>
    </div>
    
    <div v-else-if="error" class="text-center py-16">
      <div class="text-6xl mb-4">📜</div>
      <h2 class="text-xl font-semibold text-ink-900 mb-2">诗文未找到</h2>
      <p class="text-ink-600 mb-6">抱歉，您查找的诗文不存在</p>
      <NuxtLink to="/poems" class="inline-flex items-center px-6 py-3 bg-primary-600 text-white rounded-lg font-medium hover:bg-primary-700 transition-colors">
        返回诗文列表
      </NuxtLink>
    </div>
    
    <div v-else class="max-w-3xl mx-auto">
      <nav class="flex items-center space-x-2 text-sm text-ink-500 mb-6">
        <NuxtLink to="/" class="hover:text-primary-600">首页</NuxtLink>
        <span>/</span>
        <NuxtLink to="/poems" class="hover:text-primary-600">诗文</NuxtLink>
        <span>/</span>
        <span class="text-ink-800">{{ poem?.title }}</span>
      </nav>
      
      <article class="bg-white rounded-2xl shadow-sm border border-beige-200 overflow-hidden">
        <div class="p-6 md:p-10">
          <header class="text-center mb-8 pb-8 border-b border-beige-200">
            <span class="dynasty-tag mb-4 inline-block">唐代</span>
            <h1 class="text-3xl md:text-4xl font-bold text-ink-900 mb-4">{{ poem?.title }}</h1>
            <NuxtLink :to="`/poet/${poem?.author}`" class="inline-flex items-center text-ink-600 hover:text-primary-600 transition-colors">
              <div class="w-12 h-12 rounded-full bg-gradient-to-br from-beige-300 to-beige-500 flex items-center justify-center mr-3">
                <span class="text-white text-xl font-semibold">{{ poem?.author?.charAt(0) }}</span>
              </div>
              <span class="text-lg">{{ poem?.author }}</span>
            </NuxtLink>
          </header>
          
          <div class="text-center py-8">
            <div class="poem-content text-xl md:text-2xl leading-loose">
              <p v-for="(line, index) in poem?.paragraphs" :key="index" class="mb-4">
                {{ line }}
              </p>
            </div>
          </div>
          
          <div v-if="poem?.tags && poem.tags.length > 0" class="flex flex-wrap justify-center gap-2 pt-8 border-t border-beige-200">
            <NuxtLink 
              v-for="tag in poem.tags" 
              :key="tag"
              :to="`/poems?tag=${tag}`"
              class="tag-badge text-sm"
            >
              {{ tag }}
            </NuxtLink>
          </div>
        </div>
        
        <div class="bg-beige-50 px-6 py-4 flex items-center justify-between border-t border-beige-200">
          <div class="flex items-center space-x-4">
            <button class="btn-action flex items-center space-x-2 text-sm" title="收藏">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
              </svg>
              <span class="hidden sm:inline">收藏</span>
            </button>
            <button class="btn-action flex items-center space-x-2 text-sm" title="复制" @click="copyPoem">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
              </svg>
              <span class="hidden sm:inline">复制</span>
            </button>
            <button class="btn-action flex items-center space-x-2 text-sm" title="朗读">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" />
              </svg>
              <span class="hidden sm:inline">朗读</span>
            </button>
          </div>
          <NuxtLink to="/poems" class="text-primary-600 hover:text-primary-700 text-sm font-medium">
            ← 返回列表
          </NuxtLink>
        </div>
      </article>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const id = route.params.id as string

const { data: poem, pending, error } = await useFetch(`/api/poems/${id}`)

const copyPoem = async () => {
  if (!poem.value || typeof window === 'undefined' || !navigator.clipboard) return
  const text = `${poem.value.title}\n${poem.value.author}\n\n${poem.value.paragraphs?.join('\n') || ''}`
  try {
    await navigator.clipboard.writeText(text)
  } catch (e) {
    console.error('Copy failed', e)
  }
}

useHead({
  title: computed(() => poem.value ? `${poem.value.title} - ${poem.value.author} - 全唐诗` : '加载中... - 全唐诗')
})
</script>
