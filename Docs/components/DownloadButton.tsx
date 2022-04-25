import { RiDownloadCloud2Line } from 'react-icons/ri'

const DownloadButton = ({ tagName, downloadUrl }: { tagName: string; downloadUrl: string }) => {
  return (
    <button
      onClick={() => open(downloadUrl)}
      className="px-4 py-2 flex items-center space-x-2 bg-primary text-secondary rounded-md"
    >
      <RiDownloadCloud2Line />
      <div>
        Download <span className="font-mono font-bold text-sm">{tagName}</span>
      </div>
    </button>
  )
}

export default DownloadButton
