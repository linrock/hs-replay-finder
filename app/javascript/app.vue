<template lang="pug">
  main
    section#sidebar
      class-image-selector
      about-winrates
      class-winrates
    section#replays(:class="[{ loading: isLoading }]")
      h3.replay-feed-title {{ $store.state.replayFeedTitle }}
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

  import fetchReplays from './api'

  export default {
    data() {
      return {
        error: false,
        isLoading: false,
      }
    },

    created() {
      const { legendStats, replayData } = window.hsrpf
      const routeMap = legendStats.route_map
      const aboutWinrates = legendStats.about_winrates
      this.$store.dispatch(`setInitialData`, { routeMap, aboutWinrates })
      const path = this.$route.params.path || `/`
      const route = this.getRoute(path)
      if (Object.keys(route).length === 0) {
        this.$router.replace({ path: `/` })
      } else {
        this.$store.dispatch(`setPath`, path)
      }
      const replays = replayData.replays
      if (replays && replays.length > 0 && replayData.path == path) {
        this.setReplays(replays)
      } else {
        this.fetchReplays()
      }
    },

    computed: {
      path() {
        return this.$store.state.path
      },
      currentRoute() {
        return this.getRoute(this.path)
      }
    },

    methods: {
      getRoute(path) {
        return this.$store.getters.routeMap(path)
      },
      setReplays(replays) {
        this.$store.dispatch(`setReplays`, replays)
      },
      fetchReplays() {
        this.isLoading = true
        this.error = false
        fetchReplays(this.path)
          .then(data => {
            if (this.path === data.path) {
              this.isLoading = false
              this.setReplays(data.replays)
              window.scrollTo(0, 0)
            }
          })
          .catch(error => {
            console.error(error)
            this.isLoading = false
            this.error = true
          })
      },
    },

    watch: {
      $route(to, from) {
        let path = to.params.path || `/`
        const route = this.getRoute(path)
        if (!route && path !== `/`) {
          path = `/`
          this.$router.replace({ path })
        }
        this.$store.dispatch(`setPath`, path)
        this.fetchReplays()
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
