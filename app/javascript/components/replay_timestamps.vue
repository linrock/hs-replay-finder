<template lang="pug">
  section.replay-timestamps
    .time-ago(v-for="timeAgo in timesAgo") {{ timeAgo }}

</template>

<script>
  import { timeAgo } from '../utils'

  export default {
    computed: {
      timesAgo() {
        const timesAgo = []
        let lastDifferentTimeAgo = null
        this.$store.state.replays.forEach(replay => {
          const lastTimeAgo = timeAgo(replay.found_at)
          if (lastDifferentTimeAgo !== lastTimeAgo) {
            lastDifferentTimeAgo = lastTimeAgo
            timesAgo.push(lastDifferentTimeAgo)
          } else {
            timesAgo.push(``)
          }
        })
        timesAgo.pop()
        timesAgo.push(lastDifferentTimeAgo)
        return timesAgo
      }
    },
  }
</script>

<style lang="stylus" scoped>
  .replay-timestamps
    width 100px

    .time-ago
      color #111
      font-size 12px
      opacity 0.4
      height 32px
      line-height 32px
      padding-left 10px

</style>
