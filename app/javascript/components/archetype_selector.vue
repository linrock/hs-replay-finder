<template lang="pug">
  .archetype-selector
    .archetype-row(
      v-for="(winrate, name) in archetypes"
      :class="[{ active: archetypeActive(name) }]"
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
      archetypes() {
        const className = store.query.class
        if (className !== "any") {
          return this.archetypeStats[className]["archetypes"]
        }
      },
    },

    methods: {
      archetypeActive(archetypeName) {
        return store.query.archetype === archetypeName
      },
      selectArchetype(archetypeName) {
        window.scrollTo(0, 0)
        store.query.archetype = archetypeName
      }
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
