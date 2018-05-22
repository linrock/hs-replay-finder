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
    if (secondsSinceFound < 3600) {
      timeAgo = `just now`
    } else {
      const hoursSinceFound = secondsSinceFound / 3600
      if (hoursSinceFound < 24) {
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
      return {
        store,
      }
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
    padding 8px 0
    height 32px

</style>
