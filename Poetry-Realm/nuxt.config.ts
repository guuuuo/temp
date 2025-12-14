export default defineNuxtConfig({
  compatibilityDate: '2024-11-01',
  devtools: { enabled: false },
  modules: ['@nuxtjs/tailwindcss'],
  
  ssr: true,
  
  app: {
    head: {
      title: '皮皮谷 - 中华诗词文库',
      htmlAttrs: {
        lang: 'zh-CN'
      },
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: '皮皮谷 - 传承中华诗词文化，收录古诗、词、曲、赋等经典文学作品，提供译文、注释、赏析等功能' },
        { name: 'keywords', content: '古诗词,诗词,唐诗,宋词,古文,中国文学,诗词赏析,皮皮谷' },
        { property: 'og:title', content: '皮皮谷 - 中华诗词文库' },
        { property: 'og:description', content: '传承中华诗词文化，收录古诗、词、曲、赋等经典文学作品' },
        { property: 'og:type', content: 'website' },
        { property: 'og:site_name', content: '皮皮谷' }
      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
      ]
    }
  },

  runtimeConfig: {
    databaseUrl: process.env.DATABASE_URL
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
