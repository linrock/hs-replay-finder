<template lang="pug">
  section.replay-timestamps
    .time-ago(v-for="timeAgo in timesAgo") {{ timeAgo }}

</template>

<script>
  import { store } from '../store'

  const now = new Date()
  const timeAgo = replay => {
    let timeAgo = ``
    const date = new Date(replay.found_at)
    const secondsSinceFound = (now - date)/1000
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
        const daysSinceFound = hoursSinceFound / 24
        timeAgo = `${parseInt(daysSinceFound, 10)} days ago`
      }
    }
    return timeAgo
  }

  export default {
    data() {
      return { store }
    },

    computed: {
      replays() {
        return this.store.replays
      },
      timesAgo() {
        const timesAgo = []
        let lastDifferentTimeAgo = null
        this.replays.forEach(replay => {
          const lastTimeAgo = timeAgo(replay)
          if (lastDifferentTimeAgo !== lastTimeAgo) {
            lastDifferentTimeAgo = lastTimeAgo
            timesAgo.push(lastDifferentTimeAgo)
          } else {
            timesAgo.push(``)
          }
        })
        return timesAgo
      }
    },
  }
</script>

<style lang="stylus" scoped>
  .replay-timestamps
    margin-left 30px

  .time-ago
    color #111
    font-size 12px
    opacity 0.6
    height 32px
    line-height 32px

</style>
