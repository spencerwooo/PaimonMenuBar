export type AppReleaseData = {
  html_url: string
  tag_name: string
  name: string
  published_at: string
  assets: Array<{
    size: number
    download_count: number
    browser_download_url: string
  }>
  reactions: {
    total_count: number
    '+1': number
    '-1': number
    laugh: number
    confused: number
    heart: number
    hooray: number
    rocket: number
    eyes: number
  }
}
