<template lang="pug">
  .archetype-selector
    .archetype-row(
      v-for="archetype in archetypes"
      :class="[{ active: store.query.archetype === archetype.name }]"
      @click="visitArchetype(archetype.name)"
    )
      .name {{ archetype.name }}
      .winrate {{ archetype.winrate }}%

</template>

<script>
  import { store } from '../store'

  export default {
    data() {
      return {
        classes: window.legendStats.classes,
        store,
      }
    },

    computed: {
      archetypes() {
        const className = store.query.class
        if (className !== "any") {
          return Object.entries(this.classes[className]["archetypes"])
            .sort((a,b) => parseFloat(b[1]) - parseFloat(a[1]))
            .map(row => ({ name: row[0], winrate: row[1] }))
        }
      },
    },

    methods: {
      visitArchetype(archetypeName) {
        const archetypeNameLower = archetypeName.toLowerCase().replace(/\s+/, '-')
        const classNameLower = store.query.class.toLowerCase()
        this.$router.push({ path: `${archetypeNameLower}-${classNameLower}` })
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
    border-radius 2px

    &:hover, &.active
      color #45ABFE
      cursor pointer

    .name
      width 180px

    .winrate
      width 60px
      text-align right

</style>
