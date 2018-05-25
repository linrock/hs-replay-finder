<template lang="pug">
  .class-winrates(v-if="classWinrate")
    .label-row
      .class-label class
      .winrate-label winrate
    .stats-row(
      :class="[{ active: !store.hover.class && store.query.archetype === `any` }]"
      @click="visitClass()"
    )
      .name {{ className }}
      .winrate {{ classWinrate }}%
    .archetype-selector
      .stats-row(
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
      return { store }
    },

    computed: {
      classes() {
        return store.legendStats.classes
      },
      className() {
        return store.hover.class || store.query.class
      },
      classWinrate() {
        if (this.className !== "any") {
          return this.classes[this.className]["winrate"]
        } else if (store.hover.class) {
          return this.classes[store.hover.class]["winrate"]
        }
      },
      classNameLower() {
        return store.query.class.toLowerCase()
      },
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
      visitClass() {
        this.$router.push({ path: this.classNameLower })
      },
      visitArchetype(archetypeName) {
        const archetypeNameLower = archetypeName.toLowerCase().replace(/\s+/, '-')
        this.$router.push({ path: `${archetypeNameLower}-${this.classNameLower}` })
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .class-winrates
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
