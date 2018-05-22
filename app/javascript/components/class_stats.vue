<template lang="pug">
  .class-stats(v-if="classWinrate && archetypes")
    .winrate-label winrate
    .stats-row(
      :class="[{ active: store.query.archetype === `any` }]"
      @click="clearActiveArchetype"
    )
      .name {{ store.query.class }}
      .winrate {{ classWinrate }}%

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
      clearActiveArchetype() {
        store.query.archetype = `any`
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .class-stats
    margin-top 30px

    .winrate-label
      width 240px
      text-align right
      font-size 10px
      letter-spacing 0.4px
      text-transform uppercase
      opacity 0.5
      margin-bottom 8px
      padding-right 8px

    .stats-row
      display flex
      line-height 24px
      width 240px
      padding 0 8px

      &:hover
        background #f0f0f0
        cursor pointer

      &.active
        background #f0f0f0

      .name
        width 180px

      .winrate
        width 60px
        text-align right

</style>
