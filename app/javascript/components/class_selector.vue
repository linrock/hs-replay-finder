<template lang="pug">
  .class-selector(@mouseleave="store.hover.class = null")
    img(
      v-for="className in classNames"
      :src="imgSrc(className)"
      :class="[{ active: classIsActive(className) }]"
      @mouseenter="hoverOverClass(className)"
      @click="selectClass(className)"
    )
</template>

<script>
  import { store } from '../store'

  export default {
    data() {
      return {
        archetypeStats: window.archetypeStats,
        store
      }
    },

    computed: {
      classNames() {
        return Object.entries(this.archetypeStats)
          .sort((a,b) => parseFloat(b[1].winrate) - parseFloat(a[1].winrate))
          .map(row => row[0])
      }
    },

    methods: {
      imgSrc(className) {
        return `assets/classes/${className.toLowerCase()}.png`
      },
      classIsActive(className) {
        return [`any`, className].includes(store.query.class)
      },
      selectClass(className) {
        store.query.archetype = `any`
        store.hover.class = null
        store.query.class = store.query.class === className ? `any` : className
      },
      hoverOverClass(className) {
        if (store.query.class === `any`) {
          store.hover.class = className
        }
      },
    },
  }
</script>

<style lang="stylus" scoped>
  .class-selector
    width 240px
    height 240px
    display flex
    flex-wrap wrap
    justify-content space-between
    align-items center

  img
    width 77px
    height 77px
    display block
    opacity 0.3
    border-radius 2px
    margin auto
    margin-left 0
    transition opacity 0.2s ease-in-out

    &.active
      opacity 1

    &:hover
      cursor pointer

</style>
