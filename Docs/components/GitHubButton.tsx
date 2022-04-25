import { RiGithubLine } from 'react-icons/ri'

const GitHubButton = () => {
  return (
    <a
      className="no-underline"
      href="https://github.com/spencerwooo/PaimonMenuBar"
      target="_blank"
      rel="noopener noreferrer"
    >
      <button className="px-4 py-2 flex items-center space-x-2 border border-primary text-primary rounded-md">
        <RiGithubLine />
        <span>GitHub</span>
      </button>
    </a>
  )
}

export default GitHubButton
