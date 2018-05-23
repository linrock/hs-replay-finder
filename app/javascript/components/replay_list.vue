<template lang="pug">
  section.replay-list
    replay-row(v-for="replay in store.replays" :replay="replay")

</template>

<script>
  import { store } from '../store'
  import ReplayRow from "./replay_row"

  export default {
    data() {
      return { store }
    },

    components: {
      ReplayRow,
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-list
    margin-left 350px
    margin-bottom 100px

</style>
