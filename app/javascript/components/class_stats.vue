<template lang="pug">
  .class-stats(v-if="classWinrate && archetypes")
    .label-row
      .class-label class
      .winrate-label winrate
    .stats-row(
      :class="[{ active: store.query.archetype === `any` }]"
      @click="store.query.archetype = `any`"
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
      className() {
        return store.query.class
      },
      classWinrate() {
        if (this.className !== "any") {
          return this.archetypeStats[this.className]["winrate"]
        }
      },
      archetypes() {
        if (this.className !== "any") {
          return this.archetypeStats[this.className]["archetypes"]
        }
      },
    },
  }
</script>

<style lang="stylus" scoped>
  .class-stats
    margin-top 30px

    .label-row
      width 240px
      font-size 10px
      letter-spacing 0.4px
      text-transform uppercase
      display flex
      opacity 0.5
      padding 0 9px
      margin-bottom 8px

      .class-label
        text-align left

      .winrate-label
        text-align right
        margin-left auto

    .stats-row
      display flex
      line-height 24px
      width 240px
      padding 2px 8px
      border-radius 2px

      &:hover
        background #f0f0f0
        cursor pointer

      &.active
        background #f0f0f0

      .name
        font-weight bold
        width 180px

      .winrate
        width 60px
        text-align right

</style>
