import { RiGithubLine } from 'react-icons/ri'

const GitHubButton = () => {
  return (
    <a
      className="px-4 py-2 rounded-lg font-mulish text-lg cursor-pointer border border-gradient-to-b from-slate-50 to-gray-300 transition-all duration-150 hover:scale-105 hover:shadow-lg"
      href="https://github.com/spencerwooo/PaimonMenuBar"
      target="_blank"
      rel="noopener noreferrer"
    >
      GitHub
      <RiGithubLine className="inline ml-2" size={20} />
    </a>
  )
}

export default GitHubButton
