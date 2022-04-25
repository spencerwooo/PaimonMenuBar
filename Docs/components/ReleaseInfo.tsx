import type { AppReleaseData } from '../pages/types'

const reactionToEmoji = {
  '+1': '👍',
  '-1': '👎',
  laugh: '😂',
  confused: '😕',
  heart: '❤️',
  hooray: '🎉',
  rocket: '🚀',
  eyes: '👀',
} as const
type reactionKeys = keyof typeof reactionToEmoji

const ReleaseInfo = ({
  htmlUrl,
  publishedAt,
  downloadCount,
  reactions,
}: {
  htmlUrl: string
  publishedAt: string
  downloadCount: number
  reactions: AppReleaseData['reactions']
}) => {
  const reactionsNonZero = Object.entries(reactions).filter(
    ([key, count]) => key !== 'total_count' && count > 0
  ) as Array<[reactionKeys, number]>

  return (
    <div className="flex flex-wrap items-center text-xs gap-x-2 py-2 opacity-60 hover:opacity-80 transition-all duration-150">
      <span>on {new Date(publishedAt).toLocaleDateString()},</span>
      <span>{downloadCount} downloads,</span>

      <a href={htmlUrl} target="_blank" rel="noopener noreferrer">
        goto release.
      </a>

      {reactionsNonZero.map(([key, val]: [key: reactionKeys, val: number]) => (
        <span key={key}>
          {reactionToEmoji[key]} {val}
        </span>
      ))}
    </div>
  )
}

export default ReleaseInfo
