<template lang="pug">
  main
    section#sidebar
      rank-filter
      class-image-selector
      about-winrates
      class-winrates
    section#replays
      h3.replay-feed-title {{ $store.state.replayFeedTitle }}
      template(v-if="$store.getters.replays.length === 0")
        .loading-text(v-if="isLoading") Loading...
        .loading-text(v-else) No replays found
      .error-text(v-if="error") Failed to fetch replays :(
      .replay-feed-container
        .replay-feed
          .replay-list
            replay-row(
              v-for="replay in $store.getters.replays"
              :key="replay.link"
              :replay="replay"
            )
          replay-timestamps
        .bottom(ref="bottom")
          .back-to-top(
            v-if="$store.getters.currentPage > 1 && !infiniteScrollOn"
            @click="backToTop()"
          ) Back to top

</template>

<script>
  import axios from 'axios'

  import AboutWinrates from './components/about_winrates'
  import ClassImageSelector from './components/class_image_selector'
  import ClassWinrates from './components/class_winrates'
  import RankFilter from './components/rank_filter'
  import ReplayRow from './components/replay_row'
  import ReplayTimestamps from './components/replay_timestamps'

  const infScrollTriggerDistance = 500
  const infScrollPollInterval = 300

  export default {
    data() {
      return {
        error: false,
        isLoading: false,
        pageTitlePrefix: document.getElementsByTagName(`title`)[0].text,
        infiniteScrollOn: false,
        scrollPoller: null,
      }
    },

    created() {
      const { legendStats, replayData } = window.hsrpf
      const routeMap = legendStats.route_map
      const aboutWinrates = legendStats.about_winrates
      this.$store.dispatch(`setInitialData`, { routeMap, aboutWinrates })
      const path = this.$route.params.path || `/`
      if (this.routeExists(path)) {
        this.$store.dispatch(`setPath`, path)
      } else {
        this.$router.replace({ path: `/` })
      }
      const replays = replayData.replays
      if (replays && replays.length > 0 && replayData.path == path) {
        this.setReplaysAndPageTitle(replays)
      } else {
        this.fetchReplays()
      }
      this.enableInfiniteScroll()
      this.scrollPoller = setInterval(() => {
        const d = this.distanceFromBottom()
        if (d < infScrollTriggerDistance && !this.isLoading && this.infiniteScrollOn) {
          this.fetchReplays(this.$store.getters.currentPage + 1)
        }
      }, infScrollPollInterval)
    },

    computed: {
      path() {
        return this.$store.state.path
      },
      filter() {
        return this.$store.state.filter
      },
    },

    methods: {
      getRoute(path) {
        return this.$store.getters.routeMap(path)
      },
      routeExists(path) {
        return Object.keys(this.getRoute(path)).length > 0
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
      enableInfiniteScroll() {
        setTimeout(() => this.infiniteScrollOn = true, 1000)
      },
      distanceFromBottom() {
        if (!this.$refs.bottom) {
          return Infinity
        } else {
          return this.$refs.bottom.offsetTop - (window.scrollY + window.innerHeight)
        }
      },
      apiQuery(page) {
        let query = `replays.json?path=${this.path || `/`}`
        if (this.filter) {
          query = `${query}&filter=${this.filter}`
        }
        if (page) {
          query = `${query}&page=${page}`
        }
        return query
      },
      fetchReplays(page) {
        this.isLoading = true
        this.error = false
        page = page || 1
        axios.get(this.apiQuery(page))
          .then(response => response.data)
          .then(data => {
            if (this.path !== data.path) {
              return
            }
            this.isLoading = false
            this.$store.dispatch(`setPage`, data.page)
            if (data.page === 1) {
              this.setReplaysAndPageTitle(data.replays)
              if (data.replays.length === data.page_size) {
                this.enableInfiniteScroll()
              } else {
                this.infiniteScrollOn = false
              }
              this.backToTop()
            } else {
              this.$store.dispatch(`addReplays`, data.replays)
              if (data.page < page || data.replays.length === 0) {
                this.infiniteScrollOn = false
              }
            }
          })
          .catch(error => {
            console.error(error)
            this.infiniteScrollOn = false
            this.isLoading = false
            this.error = true
          })
        if (window.gtag) {
          window.gtag('event', 'fetch replays', {
            event_category: this.path,
            event_label: page
          })
        }
      },
      backToTop() {
        window.scrollTo(0, 0)
      }
    },

    watch: {
      $route(to, from) {
        let path = to.params.path || `/`
        let newPageTitle = this.pageTitlePrefix
        if (!this.routeExists(path) && path !== `/`) {
          path = `/`
          this.$router.replace({ path })
        }
        this.$store.dispatch(`setPath`, path)
        this.fetchReplays()
      },
      filter() {
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

  .loading-text
    position absolute
    top 240px
    text-align center
    font-size 30px
    opacity 0.5
    width replay-feed-width

  .error-text
    width replay-feed-width
    text-align center
    font-size 20px
    padding 27px
    background white
    position fixed
    top 271px
    border 1px solid rgba(0,0,0,0.3)
    z-index 5

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

  .bottom
    height 100px
    width replay-feed-width

    .back-to-top
      text-align center
      margin-top 35px
      opacity 0.4

      &:hover
        cursor pointer
        opacity 0.9

</style>
