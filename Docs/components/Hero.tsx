import type { AppReleaseData } from '../pages/types'

import Image from "next/image"

import Screenshot3D from '../components/Screenshot3D'
import DownloadButton from '../components/DownloadButton'
import ReleaseInfo from '../components/ReleaseInfo'
import GitHubButton from '../components/GitHubButton'

import logo from '../images/logo.png'

const Hero = ({ latest }: { latest: AppReleaseData }) => (
  <div className="relative max-w-5xl p-6 mx-auto pt-28">
    <div className="hidden md:block float-right">
      <Screenshot3D />
    </div>

    <div className="flex items-center">
      <Image className="-ml-4" src={logo} alt="logo" height={72} width={72} priority />

      <span className="text-3xl lg:text-5xl font-bold tracking-wide ml-4 font-mulish inline">
        PaimonMenuBar
      </span>
    </div>

    <div className="mt-16 text-xl lg:text-3xl max-w-lg tracking-wide">
      Track your Genshin Impact daily resin, expeditions, and more — straight in
      your macOS menu bar.
    </div>

    <div className="text-lg mt-16">
      <div className="opacity-60 text-xs lg:text-base mb-4">
        Made with SwiftUI, designed for macOS. Works with —
      </div>

      <div className="flex items-center space-x-4">
        <div className="border rounded-lg p-2">
          <div className="text-xs">天空岛 | 世界树</div>
          <div className="font-bold font-mulish tracking-wider">🇨🇳 CN</div>
        </div>
        <div className="opacity-60">&</div>
        <div className="border rounded-lg p-2">
          <div className="text-xs">NA | EU | Asia | SAR</div>
          <div className="font-bold font-mulish tracking-wider">🌍 Global</div>
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
      Requires macOS 11 Big Sur or later.
    </div>

    <ReleaseInfo
      htmlUrl={latest.html_url}
      publishedAt={latest.published_at}
      downloadCount={latest.assets[0].download_count}
      reactions={latest.reactions}
    />
  </div>
)
export default Hero
