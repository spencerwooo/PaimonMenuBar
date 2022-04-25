import type { GetStaticProps } from 'next'
import type { AppReleaseData } from './types'
import Head from 'next/head'
import Image from 'next/image'

import DownloadButton from '../components/DownloadButton'
import ReleaseInfo from '../components/ReleaseInfo'
import Screenshot3D from '../components/Screenshot3D'
import logo from '../images/logo.png'
import Footer from '../components/Footer'
import GitHubButton from '../components/GitHubButton'

const Home = ({ latest }: { latest: AppReleaseData }) => {
  return (
    <>
      <Head>
        <title>PaimonMenuBar</title>
        <meta name="description" content="Paimon is now in your macOS menubar!" />
        <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
        <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
        <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
        <link rel="manifest" href="/site.webmanifest" />
      </Head>

      <div className="min-h-screen flex flex-col items-center bg-secondary text-primary">
        <div className="min-h-[60vh] flex space-x-4 items-center">
          <div className="hidden md:block">
            <Screenshot3D />
          </div>

          <div className="max-w-md p-4 space-y-2">
            <Image src={logo} alt="PaimonMenuBar logo" height={140} width={140} priority />
            <h1 className="text-white font-bold text-xl">PaimonMenuBar</h1>
            <h3 className="tracking-wider">yes, paimon now lives in your macos menubar</h3>

            <p className="tracking-wider text-xs opacity-60 pb-8">
              * we dont want a logo clash with the game itself, so ... love from Hu Tao! (credits to{' '}
              <a href="https://www.pixiv.net/en/artworks/92415888" target="_blank" rel="noopener noreferrer">
                @chawong
              </a>{' '}
              for the logo)
            </p>

            <div className="flex space-x-4 items-center">
              <DownloadButton tagName={latest.tag_name} downloadUrl={latest.assets[0].browser_download_url} />
              <GitHubButton />
            </div>

            <ReleaseInfo
              htmlUrl={latest.html_url}
              publishedAt={latest.published_at}
              downloadCount={latest.assets[0].download_count}
              reactions={latest.reactions}
            />
          </div>
        </div>

        <div className="border max-w-xl w-full">Hi</div>

        <Footer />
      </div>
    </>
  )
}

export const getStaticProps: GetStaticProps = async () => {
  const resp = await fetch('https://api.github.com/repos/spencerwooo/PaimonMenuBar/releases/latest')
  const latest = (await resp.json()) as AppReleaseData
  return { props: { latest } }
}

export default Home
