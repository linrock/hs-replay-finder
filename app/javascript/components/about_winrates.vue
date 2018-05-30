<template lang="pug">
  .about-winrates
    a.title(
      v-if="notViewingStats"
      href="javascript:"
      @click="aboutActive = !aboutActive"
    ) About winrates
    .explanation(v-if="aboutActive && notViewingStats")
      | Winrates calculated from {{ $store.getters.numReplays }}
      | replays over the past {{ $store.getters.sinceDays }} days.
      | Archetypes with less than 50 games not shown.
      a(href="https://github.com/linrock/hs-replay-finder" target="_blank").source Source code
</template>

<script>
  export default {
    data() {
      return {
        aboutActive: false,
      }
    },

    computed: {
      notViewingStats() {
        return !this.$store.getters.currentRoute.class && !this.$store.state.hoverClassName
      },
    }
  }
</script>

<style lang="stylus" scoped>
  .about-winrates
    font-size 12px
    padding 0 10px
    width 240px

    a
      color inherit
      text-decoration none

      &:hover
        text-decoration underline

      &.title
        opacity 0.35

      &.source
        display block
        margin-top 10px

        &:hover
          color #45ABFE

  .explanation
    margin-top 10px
    font-size 12px
    line-height 19px
    opacity 0.7

</style>
