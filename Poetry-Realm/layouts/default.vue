<template>
  <div class="min-h-screen bg-accent-50">
    <header class="bg-white shadow-sm border-b border-accent-200">
      <div class="max-w-6xl mx-auto px-4">
        <div class="flex items-center justify-between h-16">
          <NuxtLink to="/" class="flex items-center space-x-2">
            <span class="text-2xl font-serif font-bold text-primary-600">皮皮谷</span>
            <span class="text-sm text-ink-500 hidden sm:inline">中华诗词文库</span>
          </NuxtLink>
          
          <nav class="flex items-center space-x-1 sm:space-x-4">
            <NuxtLink 
              to="/" 
              class="px-3 py-2 text-ink-600 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors"
              active-class="text-primary-600 bg-primary-50"
            >
              首页
            </NuxtLink>
            <NuxtLink 
              to="/categories" 
              class="px-3 py-2 text-ink-600 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors"
              active-class="text-primary-600 bg-primary-50"
            >
              分类
            </NuxtLink>
            <NuxtLink 
              to="/authors" 
              class="px-3 py-2 text-ink-600 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors"
              active-class="text-primary-600 bg-primary-50"
            >
              作者
            </NuxtLink>
            <NuxtLink 
              to="/works" 
              class="px-3 py-2 text-ink-600 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors"
              active-class="text-primary-600 bg-primary-50"
            >
              诗文
            </NuxtLink>
            <NuxtLink 
              to="/favorites" 
              class="px-3 py-2 text-ink-600 hover:text-primary-600 hover:bg-primary-50 rounded-lg transition-colors"
              active-class="text-primary-600 bg-primary-50"
            >
              收藏
            </NuxtLink>
          </nav>
        </div>
      </div>
    </header>

    <main>
      <slot />
    </main>

    <footer class="bg-white border-t border-accent-200 mt-12">
      <div class="max-w-6xl mx-auto px-4 py-8">
        <div class="text-center text-ink-500 text-sm">
          <p class="mb-2">皮皮谷 (www.pipigu.com) - 传承中华诗词文化</p>
          <p>收录古诗、词、曲、赋等经典文学作品</p>
        </div>
      </div>
    </footer>
  </div>
</template>
