<template lang="pug">
  main#app
    section#sidebar
      class-selector
      class-stats
      archetype-selector
    section#replays
      currently-viewing
      .replay-feed
        replay-list
        replay-timestamps

</template>

<script>
  import { store } from './store'
  import fetchReplays from './api'
  import ArchetypeSelector from './components/archetype_selector'
  import ClassSelector from './components/class_selector'
  import ClassStats from './components/class_stats'
  import CurrentlyViewing from './components/currently_viewing'
  import ReplayList from './components/replay_list'
  import ReplayTimestamps from './components/replay_timestamps'

  export default {
    data() {
      return { store }
    },

    created() {
      this.fetchReplays()
    },

    methods: {
      fetchReplays() {
        return fetchReplays(this.query).then(data => {
          this.store.replays = data.replays
          window.scrollTo(0, 0)
        })
      },
    },

    computed: {
      query() {
        return {
          class: store.query.class,
          archetype: store.query.archetype,
        }
      },
    },

    watch: {
      query(newQuery, oldQuery) {
        this.fetchReplays()
      },
    },

    components: {
      ArchetypeSelector,
      ClassSelector,
      ClassStats,
      CurrentlyViewing,
      ReplayList,
      ReplayTimestamps,
    },
  }
</script>

<style lang="stylus" scoped>
  #sidebar
    position fixed
    left 50px
    top 165px

  .replay-feed
    display flex

</style>
