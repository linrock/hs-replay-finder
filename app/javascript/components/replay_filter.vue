<template lang="pug">
  .replay-filter
    .instructions
      | Find replays and stats of games
      | by legend-rank players. Choose
      | a class and archetype to filter
      | the list.
    class-selector
    class-stats
    archetype-selector

</template>

<script>
  import ArchetypeSelector from './archetype_selector'
  import ClassSelector from './class_selector'
  import ClassStats from "./class_stats"

  export default {
    computed: {
      query() {
        return {
          class: store.query.class,
          archetype: store.query.archetype,
        }
      },
    },

    components: {
      ArchetypeSelector,
      ClassSelector,
      ClassStats,
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-filter
    position fixed
    left 50px
    top 65px

    .instructions
      font-size 14px
      line-height 22px
      opacity 0.7
      width 240px
      margin-bottom 30px

</style>
