<template>
  <footer class="bg-white border-t border-beige-200 mt-12">
    <div class="container mx-auto px-4 py-8">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
        <div>
          <div class="flex items-center space-x-2 mb-4">
            <div class="w-8 h-8 bg-gradient-to-br from-primary-500 to-primary-700 rounded-lg flex items-center justify-center">
              <span class="text-white text-sm font-bold">唐</span>
            </div>
            <span class="text-lg font-semibold text-ink-900">全唐诗</span>
          </div>
          <p class="text-ink-600 text-sm leading-relaxed">
            收录唐代诗人作品，传承中华经典文化。<br/>
            提供诗词阅读、鉴赏、学习的综合平台。
          </p>
        </div>
        
        <div>
          <h3 class="font-semibold text-ink-900 mb-4">快速导航</h3>
          <nav class="flex flex-col space-y-2">
            <NuxtLink to="/poems" class="text-ink-600 hover:text-primary-600 text-sm">诗文列表</NuxtLink>
            <NuxtLink to="/poets" class="text-ink-600 hover:text-primary-600 text-sm">诗人列表</NuxtLink>
          </nav>
        </div>
        
        <div>
          <h3 class="font-semibold text-ink-900 mb-4">诗词分类</h3>
          <div class="flex flex-wrap gap-2">
            <NuxtLink 
              v-for="tag in tags" 
              :key="tag" 
              :to="`/poems?tag=${tag}`"
              class="tag-badge"
            >
              {{ tag }}
            </NuxtLink>
          </div>
        </div>
      </div>
      
      <div class="border-t border-beige-200 mt-8 pt-6 text-center">
        <p class="text-ink-500 text-sm">
          数据来源：<a href="https://github.com/chinese-poetry/chinese-poetry" target="_blank" class="text-primary-600 hover:underline">chinese-poetry</a>
        </p>
      </div>
    </div>
  </footer>
</template>

<script setup lang="ts">
const tags = ['山水', '思乡', '边塞', '送别', '抒情', '写景', '咏物', '爱情']
</script>
