<template lang="pug">
  a.replay-link(:href="replay.link" target="_blank" @click="trackClick")
    .player.player1
      .win-indicator
        svg.crown(v-if="replay.winner === `p1`")
          use(xlink:href="#crown")
      .archetype {{ replay.p1.archetype }}
    player-rank(:player="replay.p1")
    .vs vs
    player-rank(:player="replay.p2")
    .player.player2
      .archetype {{ replay.p2.archetype }}
      .win-indicator
        svg.crown(v-if="replay.winner === `p2`")
          use(xlink:href="#crown")

</template>

<script>
  import PlayerRank from "./player_rank"

  export default {
    props: {
      replay: {
        required: true,
        type: Object,
      },
    },

    methods: {
      trackClick() {
        if (window.gtag) {
          window.gtag('event', 'click', {
            event_category: 'link',
            event_label: this.replay.link
          })
        }
      }
    },

    components: {
      PlayerRank,
    }
  }
</script>

<style lang="stylus" scoped>
  a.replay-link
    align-items center
    color #111
    display flex
    text-decoration none
    justify-content center
    font-size 15px
    width 510px
    border-radius 2px

    &:hover
      opacity 1

      .player
        color #45ABFE

    &:visited
      color #999
      opacity 0.7

    > div
      height 34px
      line-height 34px

  .player
    display flex
    width 190px

    &.player1
      justify-content flex-end

    &.player2
      justify-content flex-start

  .vs
    font-weight 300
    text-align center
    width 20px
    opacity 0.5

  .win-indicator
    width 30px
    display flex
    text-align center
    align-items center
    justify-content center

  .crown
    width 22px
    height 16px
    fill #ffcd00
    stroke #737373
    stroke-width 1px
    z-index 2

</style>
