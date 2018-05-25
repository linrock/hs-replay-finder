<template lang="pug">
  .class-image-selector(@mouseleave="$store.dispatch(`hoverOverClass`, null)")
    img(
      v-for="className in classNames"
      :src="imgSrc(className)"
      :class="[{ active: classIsActive(className) }]"
      @mouseenter="hoverOverClass(className)"
      @click="selectClass(className)"
    )
</template>

<script>
  import { classPath } from '../utils'

  export default {
    computed: {
      classNames() {
        return Object.entries(this.$store.getters.classes)
          .sort((a,b) => parseFloat(b[1].winrate) - parseFloat(a[1].winrate))
          .map(row => row[0])
      }
    },

    methods: {
      imgSrc(className) {
        return `assets/classes/${className.toLowerCase()}.png`
      },
      classIsActive(className) {
        return [`any`, className].includes(this.$store.state.query.class)
      },
      selectClass(className) {
        if (this.$store.state.query.class === className) {
          this.$router.push({ path: `/` })
          this.$store.dispatch(`hoverOverClass`, className)
        } else {
          this.$router.push({ path: classPath(className) })
          this.$store.dispatch(`hoverOverClass`, null)
        }
      },
      hoverOverClass(className) {
        this.$store.dispatch(`hoverOverClass`, className)
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
