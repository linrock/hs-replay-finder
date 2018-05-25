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
        replay-list
        replay-timestamps

</template>

<script>
  import fetchReplays from './api'
  import AboutWinrates from './components/about_winrates'
  import ClassImageSelector from './components/class_image_selector'
  import ClassWinrates from './components/class_winrates'
  import ReplayList from './components/replay_list'
  import ReplayTimestamps from './components/replay_timestamps'

  export default {
    data() {
      return {
        replayFeedTitle: ``,
        isLoading: false,
      }
    },

    created() {
      this.$store.dispatch(`setLegendStats`, window.legendStats)
      const query = this.routeToQueryMap[this.$route.params.path]
      if (!query) {
        this.$router.replace({ path: `/` })
      }
      this.$store.dispatch(`setQuery`, query || {})
    },

    methods: {
      fetchReplays() {
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
      routeToQueryMap() {
        const map = {}
        Object.entries(window.legendStats.classes).forEach(([className, classData]) => {
          const classNameLower = className.toLowerCase()
          map[classNameLower] = {
            class: className,
            archetype: `any`,
          }
          Object.keys(classData.archetypes).forEach(archetypeName => {
            const archetypeNameLower = archetypeName.toLowerCase().replace(/\s+/, '-')
            map[`${archetypeNameLower}-${classNameLower}`] = {
              class: className,
              archetype: archetypeName,
            }
          })
        })
        return map
      }
    },

    watch: {
      queryParams(newQueryParams, oldQueryParams) {
        this.fetchReplays()
      },
      $route(to, from) {
        const query = this.routeToQueryMap[this.$route.params.path]
        if (query) {
          this.$store.dispatch('setQuery', query)
        } else {
          if (to.path !== `/`) {
            this.$router.replace({ path: `/` })
          }
          this.$store.dispatch('setQuery', { class: `any`, archetype: `any` })
        }
      },
    },

    components: {
      AboutWinrates,
      ClassImageSelector,
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
