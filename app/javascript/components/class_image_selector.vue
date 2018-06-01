<template lang="pug">
  .class-image-selector(@mouseleave="hoverOverClassImage(null)")
    router-link(
      tag="img"
      v-for="([path, route]) in $store.getters.classArray"
      :src="imgSrc(path)"
      :class="[{ active: !currentRoute.class || currentRoute.class === route.class }]"
      :key="path"
      :to="$store.state.path === path ? `/` : path"
      @mouseenter.native="hoverOverClassImage(path)"
    )
</template>

<script>
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
      hoverOverClassImage(path) {
        this.$store.dispatch(`hoverOverClassImage`, path)
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
