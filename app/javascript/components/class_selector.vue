<template lang="pug">
  .class-selector
    img(
      v-for="className in classes"
      :src="imgSrc(className)"
      @click="selectClass(className)"
    )

</template>

<script>
  import { store } from '../store'

  const classes = [
    "paladin",
    "rogue",
    "warlock",
    "priest",
    "druid",
    "shaman",
    "mage",
    "hunter",
    "warrior"
  ]

  export default {
    data() {
      return { classes }
    },

    methods: {
      imgSrc(className) {
        return `assets/classes/${className}`
      },
      selectClass(className) {
        console.log(`selected ${className}`)
        store.query.class = `${className[0].toUpperCase()}${className.slice(1)}`
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

    &:hover
      cursor pointer

</style>
