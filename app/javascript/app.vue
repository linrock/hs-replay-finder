<template lang="pug">
  main
    section#sidebar
      class-image-selector
      about-winrates
      class-winrates
    section#replays(:class="[{ loading: isLoading }]")
      h3.replay-feed-title {{ replayFeedTitle }}
      .loading-text(v-if="isLoading && $store.state.replays.length === 0") Loading...
      .error-text(v-if="error") Failed to fetch replays :(
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
        error: false,
        isLoading: false,
        replayFeedTitle: ``,
      }
    },

    created() {
      const { legendStats, data } = window.hsrpf
      this.$store.dispatch(`setReplayStats`, new ReplayStats(legendStats))
      const query = this.$store.getters.routeMap[this.$route.params.path]
      if (!query) {
        this.$router.replace({ path: `/` })
      }
      const replays = data.replays
      if (replays && replays.length > 0) {
        this.$store.dispatch(`setReplays`, replays)
        this.setReplayFeedTitle()
      } else {
        this.$store.dispatch(`setQuery`, query || {})
      }
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
        this.$store.dispatch(`setQuery`, query || {})
      },
      queryParams(newQueryParams, oldQueryParams) {
        this.isLoading = true
        this.error = false
        fetchReplays(this.queryParams)
          .then(data => {
            if (this.queryParams.class === data.query.class &&
                this.queryParams.archetype === data.query.archetype) {
              this.$store.dispatch(`setReplays`, data.replays)
              this.isLoading = false
              this.setReplayFeedTitle()
              window.scrollTo(0, 0)
            }
          })
          .catch(error => {
            this.isLoading = false
            this.error = true
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
    top 155px

  #replays
    position relative
    margin-left 350px
    width 510px + 100px

  section.loading
    opacity 0.45
    transition 0.2s opacity 0.15s ease-in-out

  .loading-text
    position absolute
    top 240px
    text-align center
    font-size 30px
    width 510px

  .error-text
    position absolute
    top 244px
    text-align center
    font-size 20px
    width 510px

  h3.replay-feed-title
    width 510px
    font-size 16px
    font-weight bold
    margin 20px 0
    text-align center

  .replay-feed
    display flex
    width 100%

    .replay-list
      margin-bottom 100px

</style>
