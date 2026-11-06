/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#0F172A',
          light: '#1E293B',
          container: '#131B2E',
          foreground: '#FFFFFF',
        },
        secondary: {
          DEFAULT: '#D97706',
          light: '#F59E0B',
          container: '#FE932C',
          surfaceTint: '#FEF3C7',
          foreground: '#FFFFFF',
        },
        tertiary: {
          DEFAULT: '#059669',
          light: '#10B981',
          container: '#002114',
          surfaceTint: '#D1FAE5',
          foreground: '#FFFFFF',
        },
        surface: {
          base: '#F8FAFC',
          raised: '#FFFFFF',
          subtle: '#F1F5F9',
        },
        onSurface: {
          DEFAULT: '#0B1C30',
          variant: '#64748B',
        },
      },
      fontFamily: {
        sans: ['var(--font-jakarta)', 'sans-serif'],
        inter: ['var(--font-inter)', 'sans-serif'],
      },
    },
  },
  plugins: [],
};
