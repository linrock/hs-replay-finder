const now = new Date()

export function timeAgo(timestamp) {
  let timeAgo = ``
  const date = new Date(timestamp)
  const secondsSinceFound = (now - date) / 1000
  const minutesSinceFound = secondsSinceFound / 60
  if (minutesSinceFound < 60) {
    const minutes = parseInt(minutesSinceFound, 10)
    if (minutes >= 30) {
      timeAgo = `30 minutes ago`
    } else if (minutes >= 15) {
      timeAgo = `15 minutes ago`
    } else if (minutes >= 5) {
      timeAgo = `5 minutes ago`
    } else {
      timeAgo = `just now`
    }
  } else {
    const hoursSinceFound = parseInt(minutesSinceFound / 60, 10)
    if (hoursSinceFound === 1) {
      timeAgo = `1 hour ago`
    } else if (hoursSinceFound < 24) {
      timeAgo = `${parseInt(hoursSinceFound, 10)} hours ago`
    } else {
      const daysSinceFound = parseInt(hoursSinceFound / 24, 10)
      if (daysSinceFound === 1) {
        timeAgo = `1 day ago`
      } else {
        timeAgo = `${daysSinceFound} days ago`
      }
    }
  }
  return timeAgo
}
