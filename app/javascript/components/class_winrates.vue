<template lang="pug">
  .class-winrates(v-if="currentClassName")
    .label-row
      .class-label class
      .winrate-label winrate
    .stats-row(
      :class="[{ active: currentRoute.class && !currentRoute.archetype }]"
      @click="visitClass()"
    )
      .name {{ currentClassName }}
      .winrate {{ classWinrate }}%
    .archetype-selector
      .stats-row(
        v-for="([path, route]) in classArchetypeRows"
        :class="[{ active: currentRoute.archetype === route.archetype }]"
        @click="visitArchetype(path)"
      )
        .name {{ route.archetype }}
        .winrate {{ route.winrate }}%

</template>

<script>
  import { classPath } from '../utils'

  export default {
    computed: {
      currentClassName() {
        if (this.currentRoute && this.currentRoute.class) {
          return this.currentRoute.class
        } else {
          return this.hoverClassName
        }
      },
      hoverClassName() {
        return this.$store.state.hoverClassName
      },
      currentRoute() {
        return this.$store.getters.currentRoute
      },
      classWinrate() {
        return this.$store.getters.routeMap(this.currentClassName.toLowerCase()).winrate
      },
      classArchetypeRows() {
        if (this.currentRoute.class) {
          return this.$store.getters.classArchetypeRows(this.currentRoute.class)
        }
      },
    },

    methods: {
      visitClass() {
        this.$router.push({ path: this.currentRoute.class.toLowerCase() })
      },
      visitArchetype(path) {
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
