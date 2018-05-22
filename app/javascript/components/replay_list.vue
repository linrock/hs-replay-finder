<template>
  <section class="replay-list">
    <replay-row v-for="replay in replays" :replay="replay"/>
  </section>
</template>

<script>
  import fetchReplays from '../api'
  import ReplayRow from "./replay_row"

  export default {
    data() {
      return {
        replays: []
      }
    },

    created() {
      fetchReplays({}).then(data => {
        console.log(`${data.replays.length} replays found`)
        this.replays = data.replays
      })
    },

    components: {
      ReplayRow
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-list
    margin-left 400px

</style>
