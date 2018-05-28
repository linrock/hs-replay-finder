<template lang="pug">
  .class-winrates(v-if="currentClassName")
    .label-row
      .class-label class
      .winrate-label winrate
    router-link.stats-row(
      :class="[{ active: currentRoute.class && !currentRoute.archetype }]"
      :to="currentClassName.toLowerCase()"
    )
      .name {{ currentClassName }}
      .winrate {{ currentClassWinrate }}%
    transition(name="fade")
      .archetype-selector(v-if="classArchetypeRows.length > 0")
        router-link.stats-row(
          v-for="([path, route]) in classArchetypeRows"
          :class="[{ active: currentRoute.archetype === route.archetype }]"
          :to="path"
        )
          .name {{ route.archetype }}
          .winrate {{ route.winrate }}%

</template>

<script>
  export default {
    computed: {
      currentRoute() {
        return this.$store.getters.currentRoute
      },
      currentClassName() {
        if (this.currentRoute && this.currentRoute.class) {
          return this.currentRoute.class
        } else {
          return this.$store.state.hoverClassName
        }
      },
      currentClassWinrate() {
        return this.$store.getters.routeMap(this.currentClassName.toLowerCase()).winrate
      },
      classArchetypeRows() {
        if (this.currentRoute.class) {
          return this.$store.getters.classArchetypeRows(this.currentRoute.class)
        } else {
          return []
        }
      },
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
      text-decoration none
      color #333

      &:hover, &.active
        color #45ABFE
        cursor pointer

      .name
        width 180px
        font-weight bold

      .winrate
        width 60px
        text-align right

    .fade-enter-active, .fade-leave-active
      transition all 0.2s ease
      transform translate3d(0, 0, 0)
      opacity 1

    .fade-enter, .fade-leave-to
      transform translate3d(0, -4px, 0)
      opacity 0

</style>
