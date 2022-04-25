import type { GetStaticProps } from 'next'
import type { AppReleaseData } from './types'
import Image from 'next/image'

import DownloadButton from '../components/DownloadButton'
import ReleaseInfo from '../components/ReleaseInfo'
import logo from '../images/logo.png'
import screenshot from '../images/screenshot-transparent-light.png'

const Home = ({ latest }: { latest: AppReleaseData }) => {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-secondary text-primary">
      <div className="flex space-x-4 items-center">
        <Image src={screenshot} alt="PaimonMenuBar screenshot" width={300} height={(300 * 1072) / 652} />
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

          <DownloadButton tagName={latest.tag_name} downloadUrl={latest.assets[0].browser_download_url} />
          <ReleaseInfo
            htmlUrl={latest.html_url}
            publishedAt={latest.published_at}
            downloadCount={latest.assets[0].download_count}
            reactions={latest.reactions}
          />
        </div>
      </div>
    </div>
  )
}

export const getStaticProps: GetStaticProps = async () => {
  const resp = await fetch('https://api.github.com/repos/spencerwooo/PaimonMenuBar/releases/latest')
  const latest = (await resp.json()) as AppReleaseData
  return { props: { latest } }
}

export default Home
