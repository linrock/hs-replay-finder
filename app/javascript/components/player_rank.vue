<template>
  <span class="rank">
    <span :class="rankClass">
      {{ player.rank }}
    </span>
    <svg :class="hexagonClass">
      <use xlink:href="#hexagon"></use>
    </svg>
  </span>
</template>

<script>
  export default {
    props: {
      player: {
        required: true,
      },
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

</style>
