import { RiDownloadCloud2Line } from 'react-icons/ri'

const DownloadButton = ({ tag_name }: { tag_name: string }) => {
  return (
    <button
      onClick={() => open('https://github.com/spencerwooo/PaimonMenuBar/releases/latest')}
      className="px-4 py-2 flex items-center space-x-2 bg-primary text-secondary rounded-md"
    >
      <RiDownloadCloud2Line />
      <span>Download {tag_name}</span>
    </button>
  )
}

export default DownloadButton
