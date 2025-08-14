import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import { VitePWA } from "vite-plugin-pwa";

// https://vite.dev/config/
export default defineConfig({
  plugins: [
      vue(),
      tailwindcss(),
      VitePWA({
        registerType: 'autoUpdate',
        manifest: {
            name: 'Название приложения',
            short_name: 'Название',
            description: 'Описание',
            background_color: '#071727',
            theme_color: '#071727',
            display: 'standalone',
            start_url: '/'
        }
      })
  ],
  build: {
    base: '/',
    outDir: '../public',
    emptyOutDir: false,
  },
    resolve: {
        alias: {
            '@': '/src'
        }
    },
    server: {
      proxy: {
        '/api': {
          target: 'http://127.0.0.1:8000',
          //target: 'https://3124dfbd3763.ngrok-free.app',
          changeOrigin: true,
          secure: false
        }
      }
    }
})
