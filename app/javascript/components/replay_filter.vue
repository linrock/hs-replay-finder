<template lang="pug">
  .replay-filter
    .filter
      .label class
      .select
        select
          option Rogue
          option Shaman
          option Paladin

    .filter
      .label archetype
      .select
        select
          option Odd

    .filter
      .label outcome
      .select
        select
          option Win
          option Loss
          option Any

    .filter
      .label rank
      .select Legend

</template>

<script>
  export default {

  }
</script>

<style lang="stylus" scoped>
  .replay-filter
    position fixed
    left 50px
    top 65px

    .filter
      display flex
      margin 5px 0

      .label
        width 100px

</style>
