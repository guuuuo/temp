# 全唐诗 - Tang Poetry Website

## Overview
A responsive Chinese classical poetry website built with NuxtJS 4, Tailwind CSS, and SSR enabled. The design follows the aesthetic of guwendao.net with a classical Chinese style.

## Tech Stack
- **Framework**: NuxtJS 4 (Vue 3)
- **Styling**: Tailwind CSS with custom theme
- **SSR**: Server-side rendering enabled
- **Language**: TypeScript

## Project Structure
```
├── app.vue                 # Root component
├── nuxt.config.ts          # Nuxt configuration
├── tailwind.config.js      # Tailwind CSS configuration
├── assets/
│   └── css/
│       └── main.css        # Global styles with custom components
├── components/
│   ├── AppHeader.vue       # Navigation header
│   ├── AppFooter.vue       # Footer component
│   ├── PoemCard.vue        # Poem card display
│   └── PoetCard.vue        # Poet card display
├── layouts/
│   └── default.vue         # Default layout
├── pages/
│   ├── index.vue           # Homepage
│   ├── poems/
│   │   └── index.vue       # Poems list
│   ├── poem/
│   │   └── [id].vue        # Poem detail
│   ├── poets/
│   │   └── index.vue       # Poets list
│   ├── poet/
│   │   └── [name].vue      # Poet detail
│   └── search.vue          # Search results
└── server/
    ├── api/
    │   ├── poems.get.ts    # Poems API
    │   ├── poems/[id].get.ts
    │   ├── poets.get.ts    # Poets API
    │   └── poets/[name].get.ts
    └── data/
        └── poems.ts        # Sample poem data
```

## Design Theme
- **Colors**: 
  - Primary: Warm brown/amber tones
  - Background: Cream/beige (paper-like)
  - Text: Deep ink colors
- **Typography**: Noto Serif SC for classical Chinese feel
- **Components**: Rounded cards with subtle shadows

## Features
- Responsive design for mobile, tablet, desktop
- SSR for SEO optimization
- Poem browsing with tag filtering
- Poet profiles with their works
- Full-text search functionality
- Copy and share poems

## Running the Project
```bash
npm install
npm run dev
```

The server runs on port 5000.

## Data Source
Sample data based on the chinese-poetry GitHub repository structure.
Future: Load from actual JSON files from https://github.com/chinese-poetry/chinese-poetry
