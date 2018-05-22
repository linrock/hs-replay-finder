<template lang="pug">
  .class-stats(v-if="classWinrate && archetypes")
    .stats-row
      .name {{ store.query.class }}
      .winrate {{ classWinrate }}%
    .stats-row.archetype(
      v-for="(winrate, name) in archetypes"
      @click="selectArchetype(name)"
    )
      .name {{ name }}
      .winrate {{ winrate }}%

</template>

<script>
  import { store } from '../store'

  export default {
    data() {
      return {
        archetypeStats: window.archetypeStats,
        store,
      }
    },

    computed: {
      classWinrate() {
        const className = store.query.class
        if (className != "any") {
          return this.archetypeStats[className]["winrate"]
        }
      },
      archetypes() {
        const className = store.query.class
        if (className != "any") {
          return this.archetypeStats[className]["archetypes"]
        }
      },
    },

    methods: {
      selectArchetype(archetypeName) {
        console.log(`selected archetype ${archetypeName}`)
        store.query.archetype = archetypeName
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .class-stats
    margin-top 30px

    .stats-row
      display flex
      line-height 24px
      width 240px

      &.archetype
        opacity 0.8

        &:hover
          cursor pointer

      .name
        width 180px

      .winrate
        width 60px
        text-align right

</style>
