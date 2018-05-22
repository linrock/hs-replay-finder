<template lang="pug">
  .replay-stats {{ replaysCount }}

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
      replaysCount() {
        const nReplays = this.replays.length
        return nReplays > 0 ? `${nReplays} replays found` : ``
      },
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-stats
    position fixed
    left 50px
    top 220px

</style>
