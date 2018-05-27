<template lang="pug">
  .class-image-selector(@mouseleave="hoverOverClass(null)")
    img(
      v-for="([path, route]) in $store.getters.classArray"
      :src="imgSrc(path)"
      :class="[{ active: classIsActive(route.class) }]"
      @mouseenter="hoverOverClass(path)"
      @click="selectClass(path)"
    )
</template>

<script>
  import { classPath } from '../utils'

  export default {
    computed: {
      currentRoute() {
        return this.$store.getters.currentRoute
      }
    },

    methods: {
      imgSrc(path) {
        return `assets/classes/${path}.png`
      },
      classIsActive(className) {
        return !this.currentRoute.class || this.currentRoute.class === className
      },
      selectClass(path) {
        if (this.$store.state.path === path) {
          this.$router.push({ path: `/` })
          this.hoverOverClass(path)
        } else {
          this.$router.push({ path })
          this.hoverOverClass(null)
        }
      },
      hoverOverClass(path) {
        const hoverOverClassName = path ? this.$store.getters.routeMap(path).class : null
        this.$store.dispatch(`hoverOverClassName`, hoverOverClassName)
      },
    },
  }
</script>

<style lang="stylus" scoped>
  .class-image-selector
    width 240px
    height 240px
    display flex
    flex-wrap wrap
    justify-content space-between
    align-items center
    margin-bottom 30px

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
