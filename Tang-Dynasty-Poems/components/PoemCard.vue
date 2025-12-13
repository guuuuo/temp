<template>
  <article class="poem-card">
    <div class="p-5">
      <div class="flex items-start justify-between mb-3">
        <NuxtLink :to="`/poem/${poem.id}`" class="poem-title flex-1 mr-4">
          {{ poem.title }}
        </NuxtLink>
        <span class="dynasty-tag shrink-0">唐代</span>
      </div>
      
      <div class="flex items-center mb-4">
        <NuxtLink :to="`/poet/${poem.author}`" class="flex items-center group">
          <div class="w-10 h-10 rounded-full bg-gradient-to-br from-beige-300 to-beige-400 flex items-center justify-center mr-3 group-hover:from-primary-300 group-hover:to-primary-400 transition-all">
            <span class="text-white text-sm font-medium">{{ poem.author?.charAt(0) || '佚' }}</span>
          </div>
          <span class="poem-author">{{ poem.author || '佚名' }}</span>
        </NuxtLink>
      </div>
      
      <div class="poem-content mb-4">
        <p v-for="(line, index) in displayedContent" :key="index" class="mb-1">
          {{ line }}
        </p>
        <p v-if="hasMore" class="text-ink-400">...</p>
      </div>
      
      <div v-if="poem.tags && poem.tags.length > 0" class="flex flex-wrap gap-2 mb-4">
        <span 
          v-for="tag in poem.tags.slice(0, 4)" 
          :key="tag" 
          class="tag-badge"
        >
          {{ tag }}
        </span>
      </div>
      
      <div class="flex items-center justify-between pt-3 border-t border-beige-100">
        <div class="flex items-center space-x-2">
          <button class="btn-action" title="收藏">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
            </svg>
          </button>
          <button class="btn-action" title="复制" @click="copyPoem">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
            </svg>
          </button>
          <button class="btn-action" title="朗读">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z" />
            </svg>
          </button>
        </div>
        <NuxtLink :to="`/poem/${poem.id}`" class="text-primary-600 hover:text-primary-700 text-sm font-medium">
          阅读全文 →
        </NuxtLink>
      </div>
    </div>
  </article>
</template>

<script setup lang="ts">
interface Poem {
  id: string
  title: string
  author: string
  paragraphs: string[]
  tags?: string[]
}

const props = defineProps<{
  poem: Poem
}>()

const displayedContent = computed(() => {
  return props.poem.paragraphs?.slice(0, 4) || []
})

const hasMore = computed(() => {
  return (props.poem.paragraphs?.length || 0) > 4
})

const copyPoem = async () => {
  if (typeof window === 'undefined' || !navigator.clipboard) return
  const text = `${props.poem.title}\n${props.poem.author}\n\n${props.poem.paragraphs?.join('\n') || ''}`
  try {
    await navigator.clipboard.writeText(text)
  } catch (e) {
    console.error('Copy failed', e)
  }
}
</script>
