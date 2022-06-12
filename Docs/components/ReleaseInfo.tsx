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

const formatRelativeDate = (publishedAt: string) => {
  const publishedDate = new Date(publishedAt)
  const deltaTime = (publishedDate.getTime() - Date.now()) / 1000

  const formatter = new Intl.RelativeTimeFormat()
  if (deltaTime > -60 * 60) {
    return formatter.format(Math.floor(deltaTime / 60), 'minute')
  }
  if (deltaTime > -24 * 60 * 60) {
    return formatter.format(Math.floor(deltaTime / 60 / 60), 'hour')
  }
  if (deltaTime > -7 * 24 * 60 * 60) {
    return formatter.format(Math.floor(deltaTime / 60 / 60 / 24), 'day')
  }
  return formatter.format(Math.floor(deltaTime / 60 / 60 / 24 / 7), 'week')
}

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
  const reactionsNonZero = Object.entries(reactions ?? {}).filter(
    ([key, count]) => key !== 'total_count' && count > 0
  ) as Array<[reactionKeys, number]>

  return (
    <>
      <a
        href={htmlUrl}
        target="_blank"
        rel="noopener noreferrer"
        className="text-sm mt-4 opacity-50 hover:opacity-60"
      >
        Last updated {formatRelativeDate(publishedAt)}. Downloads:{' '}
        {downloadCount}.
        <div className="flex md:inline-flex mt-2 md:ml-2 items-center gap-2 text-xs">
          {reactionsNonZero.map(
            ([key, val]: [key: reactionKeys, val: number]) => (
              <span
                key={key}
                className="rounded-lg border border-slate-50/40 px-2 py-0.5"
              >
                {reactionToEmoji[key]} {val}
              </span>
            )
          )}
        </div>
      </a>
    </>
  )
}

export default ReleaseInfo
