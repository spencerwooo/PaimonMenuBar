import { RiHeartPulseLine, RiHeartsLine } from 'react-icons/ri'

const Footer = () => (
  <div className="relative px-4 py-8 text-sm text-center border-t border-white/20 bg-[#232c33] w-full">
    <div>
      Created with love by{' '}
      <a
        href="https://spencerwoo.com"
        target="_blank"
        rel="noopener noreferrer"
        className="text-[#9CA6A0] underline hover:opacity-90"
      >
        Spencer Woo
      </a>{' '}
    </div>
    <div>
      <RiHeartPulseLine className="inline" /> Love and Kisses from Hu Tao{' '}
      <RiHeartsLine className="inline" />
    </div>
  </div>
)

export default Footer
