<template lang="pug">
  .archetype-selector
    .archetype-row(
      v-for="archetype in archetypes"
      :class="[{ active: store.query.archetype === archetype.name }]"
      @click="store.query.archetype = archetype.name"
    )
      .name {{ archetype.name }}
      .winrate {{ archetype.winrate }}%

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
      archetypes() {
        const className = store.query.class
        if (className !== "any") {
          return Object.entries(this.archetypeStats[className]["archetypes"])
            .sort((a,b) => parseFloat(b[1]) - parseFloat(a[1]))
            .map(row => ({ name: row[0], winrate: row[1] }))
        }
      },
    }
  }
</script>

<style lang="stylus" scoped>
  .archetype-row
    display flex
    line-height 24px
    width 240px
    padding 2px 8px
    opacity 0.7
    border-radius 2px

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
