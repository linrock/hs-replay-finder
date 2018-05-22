<template>
  <main id="app">
    <section id="sidebar">
      <replay-filter/>
      <replay-stats/>
    </section>

    <section id="replays">
      <replay-list/>
      <replay-timestamps/>
    </section>
  </main>
</template>

<script>
  import ReplayFilter from "./components/replay_filter"
  import ReplayList from "./components/replay_list"
  import ReplayStats from "./components/replay_stats"
  import ReplayTimestamps from "./components/replay_timestamps"

  export default {
    components: {
      ReplayFilter,
      ReplayList,
      ReplayStats,
      ReplayTimestamps,
    },
  }
</script>

<style lang="stylus" scoped>
  #replays
    display flex

</style>
