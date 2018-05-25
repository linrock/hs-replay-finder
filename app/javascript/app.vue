<template lang="pug">
  main
    section#sidebar
      class-image-selector
      about-winrates
      class-winrates
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
        store,
      }
    },

    created() {
      const query = this.routeToQueryMap[this.$route.params.path]
      if (query) {
        Object.assign(store.query, query)
      } else {
        this.$router.replace({ path: `/` })
      }
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
      query(newQuery, oldQuery) {
        this.fetchReplays()
      },
      $route(to, from) {
        const query = this.routeToQueryMap[this.$route.params.path]
        if (query) {
          store.query.class = query.class
          store.query.archetype = query.archetype
        } else {
          if (to.path !== `/`) {
            this.$router.replace({ path: `/` })
          }
          store.query.class = `any`
          store.query.archetype = `any`
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
