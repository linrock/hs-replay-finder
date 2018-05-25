<template lang="pug">
  .class-winrates(v-if="classWinrate")
    .label-row
      .class-label class
      .winrate-label winrate
    .stats-row(
      :class="[{ active: className !== `any` && $store.state.query.archetype === `any` }]"
      @click="visitClass()"
    )
      .name {{ $store.state.hover.class }}
      .winrate {{ classWinrate }}%
    .archetype-selector
      .stats-row(
        v-for="archetype in $store.getters.classArchetypes(className)"
        :class="[{ active: $store.state.query.archetype === archetype.name }]"
        @click="visitArchetype(archetype.name)"
      )
        .name {{ archetype.name }}
        .winrate {{ archetype.winrate }}%

</template>

<script>
  import { classPath } from '../utils'

  export default {
    computed: {
      className() {
        return this.$store.state.query.class
      },
      classStats() {
        return this.$store.getters.classStats
      },
      classWinrate() {
        if (this.className !== `any`) {
          return this.classStats[this.className].winrate
        } else if (this.$store.state.hover.class) {
          return this.classStats[this.$store.state.hover.class].winrate
        }
      },
    },

    methods: {
      visitClass() {
        this.$router.push({ path: classPath(this.$store.state.query.class) })
      },
      visitArchetype(archetypeName) {
        const path = classPath(this.$store.state.query.class, archetypeName)
        this.$router.push({ path })
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .class-winrates
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

      &:hover, &.active
        color #45ABFE
        cursor pointer

      .name
        width 180px
        font-weight bold

      .winrate
        width 60px
        text-align right

</style>
