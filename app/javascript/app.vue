<template lang="pug">
  main#app
    section#sidebar
      replay-filter
    section#replays
      replay-list
      replay-timestamps

</template>

<script>
  import ReplayFilter from "./components/replay_filter"
  import ReplayList from "./components/replay_list"
  import ReplayTimestamps from "./components/replay_timestamps"

  export default {
    components: {
      ReplayFilter,
      ReplayList,
      ReplayTimestamps,
    },
  }
</script>

<style lang="stylus" scoped>
  #replays
    display flex

</style>
