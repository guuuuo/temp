export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: false },
  ssr: true,
  modules: ['@nuxtjs/tailwindcss'],
  css: ['~/assets/css/main.css'],
  app: {
    head: {
      title: '全唐诗 - 中国古典诗词典藏',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: '全唐诗在线阅读，收录唐代诗人作品，提供诗词鉴赏、诗人介绍等功能' }
      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
      ]
    }
  },
  nitro: {
    preset: 'node-server'
  },
  vite: {
    server: {
      hmr: {
        clientPort: 443
      }
    }
  },
  devServer: {
    host: '0.0.0.0',
    port: 5000
  }
})
