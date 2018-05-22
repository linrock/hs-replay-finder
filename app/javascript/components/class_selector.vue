<template lang="pug">
  .class-selector
    img(
      v-for="className in classes"
      :src="imgSrc(className)"
      :class="[{ active: classIsActive(className) }]"
      @click="selectClass(className)"
    )
</template>

<script>
  import { store } from '../store'

  const classes = [
    "Paladin",
    "Rogue",
    "Warlock",
    "Priest",
    "Druid",
    "Shaman",
    "Mage",
    "Hunter",
    "Warrior"
  ]

  export default {
    data() {
      return {
        store,
        classes
      }
    },

    methods: {
      imgSrc(className) {
        return `assets/classes/${className.toLowerCase()}`
      },
      classIsActive(className) {
        return [`any`, className].includes(store.query.class)
      },
      selectClass(className) {
        store.query.archetype = `any`
        store.query.class = store.query.class === className ? `any` : className
      }
    },
  }
</script>

<style lang="stylus" scoped>
  .class-selector
    width 240px
    height 240px

  img
    width 80px
    height 80px
    float left
    opacity 0.3
    transition opacity 0.2s ease-in-out

    &.active
      opacity 1

    &:hover
      cursor pointer

</style>
