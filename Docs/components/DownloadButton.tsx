import { RiDownloadCloud2Line } from 'react-icons/ri'

const DownloadButton = ({
  tagName,
  downloadUrl,
  tailwindStyles,
}: {
  tagName: string
  downloadUrl: string
  tailwindStyles?: string
}) => (
  <a
    href={downloadUrl}
    target="_blank"
    rel="noopener noreferrer"
    className={`px-4 py-2 font-mulish rounded-lg lg:text-lg cursor-pointer bg-gradient-to-b from-slate-50 to-gray-300 text-slate-800 transition-all duration-150 hover:scale-105 hover:shadow-lg ${tailwindStyles}`}
  >
    Download <span className="font-bold">{tagName}</span>
    <RiDownloadCloud2Line className="inline ml-2" size={20} />
  </a>
)

export default DownloadButton
