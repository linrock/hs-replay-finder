<template lang="pug">
  section.replay-list
    replay-row(v-for="replay in replays" :replay="replay")

</template>

<script>
  import { store } from '../store'
  import ReplayRow from "./replay_row"

  export default {
    data() {
      return {
        store,
      }
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
