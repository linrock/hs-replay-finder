<template lang="pug">
  .rank
    .rank-num(:class="rankClass") {{ player.rank }}
    svg(:class="hexagonClass")
      use(xlink:href="#hexagon")

</template>

<script>
  export default {
    props: {
      player: {
        required: true,
        type: Object,
      },
    },

    computed: {
      classPrefix() {
        return this.player.is_legend ? `legend` : `rank`
      },
      rankClass() {
        return `${this.classPrefix}-rank`
      },
      hexagonClass() {
        return `hexagon ${this.classPrefix}-hexagon`
      },
    }
  }
</script>

<style lang="stylus" scoped>
  .rank
    font-size 10px
    position relative
    text-align center
    width 50px

  .rank-num
    position relative
    z-index 3

  .hexagon
    position absolute
    left 50%
    top 50%
    margin-top -12px
    margin-left -11px
    width 22px
    height 25px
    z-index 1

    &.legend-hexagon
      fill #fff100
      stroke #ffcd00
      stroke-width 2px
      opacity 0.7

    &.rank-hexagon
      fill none
      stroke #737373
      stroke-width 1px
      opacity 0.7

</style>
