<template lang="pug">
  main#app
    section#sidebar
      class-selector
      class-stats
      archetype-selector
    section#replays(:class="[{ loading: isLoading }]")
      .replay-feed-title {{ replayFeedTitle }}
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
  import ReplayList from './components/replay_list'
  import ReplayTimestamps from './components/replay_timestamps'

  export default {
    data() {
      return {
        replayFeedTitle: `Recent replays`,
        isLoading: false,
        store,
      }
    },

    created() {
      this.fetchReplays()
    },

    methods: {
      fetchReplays() {
        this.isLoading = true
        return fetchReplays(this.query).then(data => {
          this.store.replays = data.replays
          this.isLoading = false
          this.setReplayFeedTitle()
          window.scrollTo(0, 0)
        })
      },
      setReplayFeedTitle() {
        const archetype = store.query.archetype
        const className = store.query.class
        if (archetype === `any`) {
          this.replayFeedTitle = className === `any` ? `Recent replays` : className
        } else {
          this.replayFeedTitle = `${archetype} ${className}`
        }
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

  section.loading
    opacity 0.45
    transition 0.2s opacity 0.15s ease-in-out

  .replay-feed-title
    font-weight bold
    margin-left 350px
    margin-top 21px
    width 510px
    text-align center
    padding-bottom 15px
    border-bottom 1px solid #f0f0f0
    margin-bottom 10px

  .replay-feed
    display flex

</style>
