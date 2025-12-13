<template>
  <header class="bg-white/90 backdrop-blur-sm shadow-sm sticky top-0 z-50 border-b border-beige-200">
    <div class="container mx-auto px-4">
      <div class="flex items-center justify-between h-16">
        <NuxtLink to="/" class="flex items-center space-x-2">
          <div class="w-10 h-10 bg-gradient-to-br from-primary-500 to-primary-700 rounded-lg flex items-center justify-center">
            <span class="text-white text-lg font-bold">唐</span>
          </div>
          <span class="text-xl font-semibold text-ink-900 hidden sm:block">全唐诗</span>
        </NuxtLink>
        
        <nav class="hidden md:flex items-center space-x-8">
          <NuxtLink to="/" class="nav-link" active-class="nav-link-active">推荐</NuxtLink>
          <NuxtLink to="/poems" class="nav-link" active-class="nav-link-active">诗文</NuxtLink>
          <NuxtLink to="/poets" class="nav-link" active-class="nav-link-active">诗人</NuxtLink>
        </nav>
        
        <div class="flex items-center space-x-4">
          <div class="hidden sm:block relative">
            <input 
              v-model="searchQuery"
              type="text" 
              placeholder="搜索诗词、诗人..." 
              class="search-input w-48 lg:w-64 text-sm"
              @keyup.enter="handleSearch"
            />
            <button 
              @click="handleSearch"
              class="absolute right-3 top-1/2 -translate-y-1/2 text-ink-400 hover:text-primary-600"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
              </svg>
            </button>
          </div>
          
          <button 
            @click="toggleMobileMenu" 
            class="md:hidden p-2 rounded-lg hover:bg-beige-100"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path v-if="!mobileMenuOpen" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
              <path v-else stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>
      
      <div v-if="mobileMenuOpen" class="md:hidden py-4 border-t border-beige-200">
        <div class="mb-4">
          <input 
            v-model="searchQuery"
            type="text" 
            placeholder="搜索诗词、诗人..." 
            class="search-input w-full text-sm"
            @keyup.enter="handleSearch"
          />
        </div>
        <nav class="flex flex-col space-y-3">
          <NuxtLink to="/" class="nav-link py-2" @click="mobileMenuOpen = false">推荐</NuxtLink>
          <NuxtLink to="/poems" class="nav-link py-2" @click="mobileMenuOpen = false">诗文</NuxtLink>
          <NuxtLink to="/poets" class="nav-link py-2" @click="mobileMenuOpen = false">诗人</NuxtLink>
        </nav>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
const router = useRouter()
const searchQuery = ref('')
const mobileMenuOpen = ref(false)

const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value
}

const handleSearch = () => {
  if (searchQuery.value.trim()) {
    router.push(`/search?q=${encodeURIComponent(searchQuery.value.trim())}`)
    mobileMenuOpen.value = false
  }
}
</script>
