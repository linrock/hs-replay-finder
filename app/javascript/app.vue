<template>
  <main id="app">
    <section id="sidebar">
      <replay-filter/>
      <replay-stats/>
    </section>

    <replay-list/>
  </main>
</template>

<script>
  import ReplayFilter from "./components/replay_filter"
  import ReplayList from "./components/replay_list"
  import ReplayStats from "./components/replay_stats"

  export default {
    components: {
      ReplayFilter,
      ReplayList,
      ReplayStats,
    },
  }
</script>

<style lang="stylus" scoped>
  p
    font-size 2em
    text-align center

</style>
