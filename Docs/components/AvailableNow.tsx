import type { AppReleaseData } from '../pages/types'
import Image from 'next/image'

import DownloadButton from './DownloadButton'

import logo from '../images/logo.png'

const AvailableNow = ({ latest }: { latest: AppReleaseData }) => (
  <div className="relative py-8 px-4 md:px-8 border-y border-white/20 bg-[#232c33]">
    <div className="max-w-5xl mx-auto p-6 md:flex md:items-center md:justify-between">
      <div className="flex items-center">
        <Image
          className="-ml-4 mr-4"
          src={logo}
          alt="logo"
          height={120}
          width={120}
          layout="raw"
        />

        <div>
          <div className="font-bold font-mulish text-2xl md:text-4xl">
            Available on GitHub
          </div>
          <div className="font-medium opacity-60 mt-4 text-xs md:text-base">
            Requires macOS 11 Big Sur or later.
          </div>
        </div>
      </div>

      <DownloadButton
        tagName={latest.tag_name}
        downloadUrl={latest.assets[0].browser_download_url}
        tailwindStyles={'block mt-6 md:mt-0 py-2.5 text-center'}
      />
    </div>
  </div>
)
export default AvailableNow
