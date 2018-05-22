<template>
  <div class="replay-filter">
    <div class="filter">
      <div class="label">class</div>
      <div class="select">
        <select>
          <option>Rogue</option>
          <option>Shaman</option>
          <option>Paladin</option>
        </select>
      </div>
    </div>

    <div class="filter">
      <div class="label">archetype</div>
      <div class="select">
        <select>
          <option>Odd</option>
        </select>
      </div>
    </div>

    <div class="filter">
      <div class="label">outcome</div>
      <div class="select">
        <select>
          <option>Win</option>
          <option>Loss</option>
          <option>Any</option>
        </select>
      </div>
    </div>

    <div class="filter">
      <div class="label">rank</div>
      <div class="select">Legend</div>
    </div>
  </div>
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
