<template lang="pug">
  .about-winrates
    a.title(
      v-if="notViewingStats"
      href="javascript:"
      @click="aboutActive = !aboutActive"
    ) About winrates
    .explanation(v-if="notViewingStats && aboutActive")
      | Winrates calculated from {{ $store.getters.aboutWinrates.count }}
      | replays over the past {{ sinceDays }} days.
      | Archetypes with less than 50 games not shown.

</template>

<script>
  export default {
    data() {
      return {
        aboutActive: false,
      }
    },

    computed: {
      sinceDays() {
        const since = new Date(this.$store.getters.aboutWinrates.since)
        const secondsSince = (new Date() - since) / 1000
        return parseInt(secondsSince / 86400, 10)
      },
      notViewingStats() {
        return this.$store.state.query.class === `any` && !this.$store.state.hover.class
      },
    }
  }
</script>

<style lang="stylus" scoped>
  .about-winrates
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

  .explanation
    margin-top 10px
    font-size 12px
    line-height 19px
    opacity 0.7

</style>
