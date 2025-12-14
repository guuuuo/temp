/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './components/**/*.{js,vue,ts}',
    './layouts/**/*.vue',
    './pages/**/*.vue',
    './plugins/**/*.{js,ts}',
    './app.vue',
    './error.vue'
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#fef7f0',
          100: '#fdeedd',
          200: '#fad8b8',
          300: '#f6bc89',
          400: '#f19557',
          500: '#ec7733',
          600: '#dd5d25',
          700: '#b74620',
          800: '#923921',
          900: '#76311e',
          950: '#40170d'
        },
        accent: {
          50: '#f6f5f0',
          100: '#e9e7db',
          200: '#d5d0ba',
          300: '#bdb492',
          400: '#a89a72',
          500: '#998763',
          600: '#836f54',
          700: '#6a5846',
          800: '#5a4a3e',
          900: '#4e4138',
          950: '#2c231d'
        },
        ink: {
          50: '#f7f7f7',
          100: '#e3e3e3',
          200: '#c8c8c8',
          300: '#a4a4a4',
          400: '#818181',
          500: '#666666',
          600: '#515151',
          700: '#434343',
          800: '#383838',
          900: '#313131',
          950: '#1a1a1a'
        }
      },
      fontFamily: {
        serif: ['Noto Serif SC', 'STSong', 'SimSun', 'serif'],
        sans: ['Noto Sans SC', 'PingFang SC', 'Microsoft YaHei', 'sans-serif']
      }
    }
  },
  plugins: []
}
