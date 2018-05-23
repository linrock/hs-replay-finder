<template lang="pug">
  span.rank
    span(:class="rankClass") {{ player.rank }}
    svg(class="crown" v-if="winner")
      use(xlink:href="#crown")
    svg(:class="hexagonClass")
      use(xlink:href="#hexagon")

</template>

<script>
  export default {
    props: {
      player: {
        required: true,
      },
      winner: {
        required: true,
        type: Boolean
      }
    },

    computed: {
      rankClass() {
        return this.player.is_legend ? `legend-rank` : `rank-rank`
      },
      hexagonClass() {
        return `hexagon ${this.player.is_legend ? `legend-hexagon` : `rank-hexagon`}`
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

  .crown
    position absolute
    left 50%
    top -15px
    width 22px
    height 16px
    margin-left -11px
    fill #ffcd00
    stroke #737373
    stroke-width 1px

  .hexagon
    position absolute
    left 50%
    top 50%
    margin-top -12px
    margin-left -11px
    width 22px
    height 25px
    z-index -1

    &.legend-hexagon
      fill #fff100
      stroke #737373
      stroke-width 1px
      opacity 0.7

    &.rank-hexagon
      fill none
      stroke #737373
      stroke-width 1px
      opacity 0.7

</style>
