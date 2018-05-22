<template>
  <section class="replay-list">
    <replay-row v-for="replay in replays" :replay="replay"/>
  </section>
</template>

<script>
  import fetchReplays from '../api'
  import { store } from '../store'
  import ReplayRow from "./replay_row"

  export default {
    data() {
      return {
        store,
      }
    },

    created() {
      const query = {}
      fetchReplays(query).then(data => {
        console.log(`${data.replays.length} replays found`)
        this.store.replays = data.replays
      })
    },

    computed: {
      replays() {
        return this.store.replays
      }
    },

    components: {
      ReplayRow,
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-list
    margin-left 400px

</style>
