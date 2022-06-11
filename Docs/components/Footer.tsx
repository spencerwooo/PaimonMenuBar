import { RiHeartPulseLine, RiHeartsLine } from 'react-icons/ri'

const Footer = () => (
  <div className="p-4 text-sm text-center bg-black/20 w-full">
    <div>
      created with love by{' '}
      <a
        href="https://spencerwoo.com"
        target="_blank"
        rel="noopener noreferrer"
      >
        @spencerwoo
      </a>{' '}
      with swiftui
    </div>
    <div>
      <RiHeartPulseLine className="inline" /> love and kisses from hu tao{' '}
      <RiHeartsLine className="inline" />
    </div>
  </div>
)

export default Footer
