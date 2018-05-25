<template lang="pug">
  section.replay-list
    replay-row(v-for="replay in $store.state.replays" :replay="replay")

</template>

<script>
  import ReplayRow from "./replay_row"

  export default {
    components: {
      ReplayRow,
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-list
    margin-bottom 100px

</style>
