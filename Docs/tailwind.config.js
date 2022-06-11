const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        "mulish": ["Mulish", ...defaultTheme.fontFamily.sans],
      }
    },
  },
  plugins: [require('@tailwindcss/typography')],
}
