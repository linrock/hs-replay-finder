<template lang="pug">
  .replay-stats
    .replay-count {{ replaysCount }}
    .winrate(v-if="winrate") {{ winrate }}% winrate

</template>

<script>
  import { store } from '../store'

  export default {
    data() {
      return { store }
    },

    computed: {
      replays() {
        return this.store.replays
      },
      meta() {
        return this.store.meta
      },
      replaysCount() {
        const nReplays = this.count
        return nReplays > 0 ? `${nReplays} replays found` : ``
      },
      count() {
        return this.meta.count
      },
      winrate() {
        return this.meta.winrate
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-stats
    position fixed
    left 50px
    top 220px

    div
      line-height 24px

</style>
