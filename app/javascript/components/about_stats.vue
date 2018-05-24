<template lang="pug">
  section.about
    a.title(
      v-if="notViewingStats"
      href="javascript:"
      @click="store.about.active = !store.about.active"
    ) About stats
    .about-stats(v-if="notViewingStats && store.about.active")
      | Stats calculated from {{ stats.count }}
      | replays over the past {{ sinceDays }} days.
      | Archetypes with less than 50 games not shown.

</template>

<script>
  import { store } from '../store'

  export default {
    data() {
      return {
        stats: window.legendStats.meta,
        store
      }
    },

    computed: {
      sinceDays() {
        const secondsSince = (new Date() - new Date(this.stats.since))/1000
        return parseInt(secondsSince / 86400, 10)
      },
      notViewingStats() {
        return store.query.class === `any` && !store.hover.class
      },
    }
  }
</script>

<style lang="stylus" scoped>
  .about
    margin-top 35px
    font-size 12px
    padding 0 10px
    width 240px

    a
      color inherit
      text-decoration none
      opacity 0.3

      &:hover
        text-decoration underline

  .about-stats
    margin-top 8px
    font-size 13px
    line-height 20px
    opacity 0.7

</style>
