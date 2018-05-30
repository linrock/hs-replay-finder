<template lang="pug">
  main
    section#sidebar
      rank-filter
      class-image-selector
      about-winrates
      class-winrates
    section#replays(:class="[{ loading: isLoading }]")
      h3.replay-feed-title {{ $store.state.replayFeedTitle }}
      template(v-if="$store.state.replays.length === 0")
        .loading-text(v-if="isLoading") Loading...
        .loading-text(v-else) No replays found
      .error-text(v-if="error") Failed to fetch replays :(
      .replay-feed
        .replay-list
          replay-row(v-for="replay in $store.state.replays" :replay="replay")
        replay-timestamps

</template>

<script>
  import axios from 'axios'

  import AboutWinrates from './components/about_winrates'
  import ClassImageSelector from './components/class_image_selector'
  import ClassWinrates from './components/class_winrates'
  import RankFilter from './components/rank_filter'
  import ReplayRow from './components/replay_row'
  import ReplayTimestamps from './components/replay_timestamps'

  export default {
    data() {
      return {
        error: false,
        isLoading: false,
        pageTitlePrefix: document.getElementsByTagName(`title`)[0].text,
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
        this.setReplaysAndPageTitle(replays)
      } else {
        this.fetchReplays()
      }
    },

    computed: {
      path() {
        return this.$store.state.path
      },
      filter() {
        return this.$store.state.filter
      },
      apiQuery() {
        let query = `replays.json?path=${this.path || `/`}`
        if (this.filter) {
          query = `${query}&filter=${this.filter}`
        }
        return query
      },
      currentRoute() {
        return this.getRoute(this.path)
      },
    },

    methods: {
      getRoute(path) {
        return this.$store.getters.routeMap(path)
      },
      setReplaysAndPageTitle(replays) {
        this.$store.dispatch(`setReplays`, replays)
        let newPageTitle = this.pageTitlePrefix
        const route = this.getRoute(this.path)
        if (route.class && route.archetype) {
          newPageTitle = `${this.pageTitlePrefix} | ${route.archetype} ${route.class}`
        } else if (route.class) {
          newPageTitle = `${this.pageTitlePrefix} | ${route.class}`
        }
        document.title = newPageTitle
      },
      fetchReplays() {
        this.isLoading = true
        this.error = false
        axios.get(this.apiQuery).then(response => response.data)
          .then(data => {
            if (this.path === data.path) {
              this.isLoading = false
              this.setReplaysAndPageTitle(data.replays)
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
        let newPageTitle = this.pageTitlePrefix
        const route = this.getRoute(path)
        if (Object.keys(route).length === 0 && path !== `/`) {
          path = `/`
          this.$router.replace({ path })
        }
        this.$store.dispatch(`setPath`, path)
      },
      apiQuery() {
        console.log(`apiQueryChanged: ${JSON.stringify(this.apiQuery)}`)
        this.fetchReplays()
      },
    },

    components: {
      AboutWinrates,
      ClassImageSelector,
      ClassWinrates,
      RankFilter,
      ReplayRow,
      ReplayTimestamps,
    },
  }
</script>

<style lang="stylus" scoped>
  replay-feed-width = 510px

  #sidebar
    position fixed
    left 30px
    top 145px

  #replays
    position relative
    margin-left 280px

  section.loading
    opacity 0.45
    transition 0.2s opacity 0.15s ease-in-out

  .loading-text
    position absolute
    top 240px
    text-align center
    font-size 30px
    opacity 0.5
    width replay-feed-width

  .error-text
    position absolute
    top 244px
    text-align center
    font-size 20px
    width replay-feed-width

  h3.replay-feed-title
    width replay-feed-width
    font-size 16px
    font-weight bold
    margin 20px 0
    text-align center

  .replay-feed
    display flex
    width 100%
    min-height 1200px

    .replay-list
      margin-bottom 100px

</style>
