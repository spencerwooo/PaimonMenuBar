import '../styles/globals.css'
import 'atropos/css'

import '@fontsource/mulish/400.css'
import '@fontsource/mulish/700.css'

import type { AppProps } from 'next/app'

function MyApp({ Component, pageProps }: AppProps) {
  return <Component {...pageProps} />
}

export default MyApp
