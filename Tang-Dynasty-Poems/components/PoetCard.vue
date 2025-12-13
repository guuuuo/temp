<template>
  <NuxtLink :to="`/poet/${poet.name}`" class="block poem-card group">
    <div class="p-5">
      <div class="flex items-center">
        <div class="w-16 h-16 rounded-full bg-gradient-to-br from-beige-300 to-beige-500 flex items-center justify-center mr-4 group-hover:from-primary-300 group-hover:to-primary-500 transition-all shadow-sm">
          <span class="text-white text-2xl font-semibold">{{ poet.name?.charAt(0) || '佚' }}</span>
        </div>
        <div class="flex-1">
          <h3 class="text-lg font-semibold text-ink-900 group-hover:text-primary-700 transition-colors mb-1">
            {{ poet.name }}
          </h3>
          <span class="dynasty-tag text-xs">唐代</span>
          <p v-if="poet.desc" class="text-sm text-ink-600 mt-2 line-clamp-2">
            {{ poet.desc }}
          </p>
        </div>
      </div>
    </div>
  </NuxtLink>
</template>

<script setup lang="ts">
interface Poet {
  id?: string
  name: string
  desc?: string
}

defineProps<{
  poet: Poet
}>()
</script>
