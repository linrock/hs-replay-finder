<template lang="pug">
  main#app
    section#sidebar
      class-selector
      about-stats
      class-winrates
      archetype-selector
    section#replays(:class="[{ loading: isLoading }]")
      h3.replay-feed-title {{ replayFeedTitle }}
      .loading-text(v-if="store.replays.length === 0") Loading...
      .replay-feed
        replay-list
        replay-timestamps

</template>

<script>
  import { store } from './store'
  import fetchReplays from './api'
  import AboutStats from './components/about_stats'
  import ArchetypeSelector from './components/archetype_selector'
  import ClassSelector from './components/class_selector'
  import ClassWinrates from './components/class_winrates'
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
          if (this.query.class === data.query.class &&
              this.query.archetype === data.query.archetype) {
            this.store.replays = data.replays
            this.isLoading = false
            this.setReplayFeedTitle()
            window.scrollTo(0, 0)
          }
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
          class: store.query.class.toLowerCase(),
          archetype: store.query.archetype.toLowerCase(),
        }
      },
    },

    watch: {
      query(newQuery, oldQuery) {
        this.fetchReplays()
      },
    },

    components: {
      AboutStats,
      ArchetypeSelector,
      ClassSelector,
      ClassWinrates,
      ReplayList,
      ReplayTimestamps,
    },
  }
</script>

<style lang="stylus" scoped>
  #sidebar
    position fixed
    left 50px
    top 169px

  #replays
    position relative
    margin-left 350px
    width 510px + 100px

  section.loading
    opacity 0.45
    transition 0.2s opacity 0.15s ease-in-out

  .loading-text
    position absolute
    text-align center
    margin-top 25px
    width 510px

  .replay-feed-title
    font-size 18px
    font-weight bold
    margin-top 21px
    text-align center
    padding-bottom 15px
    margin-bottom 10px
    width 510px

  .replay-feed
    display flex
    width 100%

</style>
