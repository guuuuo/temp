<template>
  <div class="min-h-screen flex flex-col bg-beige-50 bg-paper">
    <AppHeader />
    <main class="flex-1">
      <slot />
    </main>
    <AppFooter />
  </div>
</template>
