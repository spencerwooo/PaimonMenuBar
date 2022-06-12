import type { GetStaticProps } from 'next'
import type { AppReleaseData } from './types'
import Head from 'next/head'
import Image from 'next/image'

import hutaoBackground from '../images/hutao-bg.jpg'
import logo from '../images/logo.png'

import Screenshot3D from '../components/Screenshot3D'
import DownloadButton from '../components/DownloadButton'
import ReleaseInfo from '../components/ReleaseInfo'
import GitHubButton from '../components/GitHubButton'
import Features from '../components/Features'
import PaimonCan from '../components/PaimonCan'
import PaimonUses from '../components/PaimonUses'
import PaimonCookie from '../components/PaimonCookie'
import HowToGetMyCookie from '../components/HowToGetMyCookie'
import Footer from '../components/Footer'

const Home = ({ latest }: { latest: AppReleaseData }) => {
  return (
    <>
      <Head>
        <title>PaimonMenuBar</title>
        <meta
          name="description"
          content="Paimon is now in your macOS menubar!"
        />
        <link
          rel="apple-touch-icon"
          sizes="180x180"
          href="/apple-touch-icon.png"
        />
        <link
          rel="icon"
          type="image/png"
          sizes="32x32"
          href="/favicon-32x32.png"
        />
        <link
          rel="icon"
          type="image/png"
          sizes="16x16"
          href="/favicon-16x16.png"
        />
        <link rel="manifest" href="/site.webmanifest" />
      </Head>

      <div className="text-white relative">
        <div className="absolute w-full">
          <Image
            src={hutaoBackground}
            alt="background"
            placeholder="blur"
            layout="responsive"
            priority
          />
          <div className="absolute top-0 bottom-0 left-0 right-0 bg-gradient-to-b from-transparent to-[#2C3740]" />
        </div>

        <div className="relative max-w-5xl p-6 mx-auto pt-28">
          <div className="hidden md:block float-right">
            <Screenshot3D />
          </div>

          <div className="flex items-center">
            <div className="-ml-4 h-[72px] w-[72px]">
              <Image src={logo} alt="logo" height={72} width={72} priority />
            </div>

            <span className="text-3xl lg:text-5xl font-bold tracking-wide ml-4 font-mulish inline">
              PaimonMenuBar
            </span>
          </div>

          <div className="mt-16 text-xl lg:text-3xl max-w-lg tracking-wide">
            Track your Genshin Impact daily resin, expeditions, and more —
            straight in your macOS menu bar.
          </div>

          <div className="text-lg mt-16">
            <div className="opacity-60 text-xs lg:text-base mb-4">
              Made with SwiftUI, designed for macOS. Works with —
            </div>

            <div className="flex items-center space-x-4">
              <div className="border rounded-lg p-2">
                <div className="text-xs">天空岛 | 世界树</div>
                <div className="font-bold font-mulish tracking-wider">
                  🇨🇳 CN
                </div>
              </div>
              <div className="opacity-60">&</div>
              <div className="border rounded-lg p-2">
                <div className="text-xs">NA | EU | Asia | SAR</div>
                <div className="font-bold font-mulish tracking-wider">
                  🌍 Global
                </div>
              </div>
            </div>
          </div>

          <div className="inline-flex items-center space-x-4 mt-16">
            <DownloadButton
              tagName={latest.tag_name}
              downloadUrl={latest.assets[0].browser_download_url}
            />
            <GitHubButton />
          </div>

          <div className="font-medium opacity-80 mt-4">
            Requires macOS 11 Big Sur or later
          </div>

          <ReleaseInfo
            htmlUrl={latest.html_url}
            publishedAt={latest.published_at}
            downloadCount={latest.assets[0].download_count}
            reactions={latest.reactions}
          />
        </div>

        <Features />

        <div className="bg-[#2c3740] relative">
          <div className="max-w-5xl p-6 pt-24 mx-auto">
            <article className="space-y-16">
              <PaimonCan />
              <PaimonUses />
              <PaimonCookie />
              <HowToGetMyCookie />
            </article>
          </div>

          <Footer />
        </div>
      </div>
    </>
  )
}

export const getStaticProps: GetStaticProps = async () => {
  const resp = await fetch(
    'https://api.github.com/repos/spencerwooo/PaimonMenuBar/releases/latest'
  )
  const latest = (await resp.json()) as AppReleaseData
  return { props: { latest }, revalidate: 5 * 60 }
}

export default Home
