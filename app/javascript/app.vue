<template lang="pug">
  main
    section#sidebar
      class-image-selector
      about-winrates
      class-winrates
    section#replays(:class="[{ loading: isLoading }]")
      h3.replay-feed-title {{ replayFeedTitle }}
      .loading-text(v-if="$store.state.replays.length === 0") Loading...
      .replay-feed
        .replay-list
          replay-row(v-for="replay in $store.state.replays" :replay="replay")
        replay-timestamps

</template>

<script>
  import AboutWinrates from './components/about_winrates'
  import ClassImageSelector from './components/class_image_selector'
  import ClassWinrates from './components/class_winrates'
  import ReplayRow from './components/replay_row'
  import ReplayTimestamps from './components/replay_timestamps'

  import ReplayStats from './models/replay_stats'
  import fetchReplays from './api'
  import { classPath } from './utils'

  export default {
    data() {
      return {
        isLoading: false,
        replayFeedTitle: ``,
      }
    },

    created() {
      this.$store.dispatch(`setReplayStats`, new ReplayStats(window.legendStats))
      const query = this.$store.getters.routeMap[this.$route.params.path]
      if (!query) {
        this.$router.replace({ path: `/` })
      }
      this.$store.dispatch(`setQuery`, query || {})
    },

    methods: {
      setReplayFeedTitle() {
        const archetype = this.$store.state.query.archetype
        const className = this.$store.state.query.class
        if (archetype === `any`) {
          this.replayFeedTitle = className === `any` ? `Recent replays` : className
        } else {
          this.replayFeedTitle = `${archetype} ${className}`
        }
      },
    },

    computed: {
      queryParams() {
        return this.$store.getters.queryParams
      },
    },

    watch: {
      $route(to, from) {
        const query = this.$store.getters.routeMap[to.params.path]
        if (!query && to.path !== `/`) {
          this.$router.replace({ path: `/` })
        }
        this.$store.dispatch('setQuery', query || {})
      },
      queryParams(newQueryParams, oldQueryParams) {
        // fetch replays
        this.isLoading = true
        return fetchReplays(this.queryParams).then(data => {
          if (this.queryParams.class === data.query.class &&
              this.queryParams.archetype === data.query.archetype) {
            this.$store.dispatch(`setReplays`, data.replays)
            this.isLoading = false
            this.setReplayFeedTitle()
            window.scrollTo(0, 0)
          }
        })
      },
    },

    components: {
      AboutWinrates,
      ClassImageSelector,
      ClassWinrates,
      ReplayRow,
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

    .replay-list
      margin-bottom 100px

</style>
