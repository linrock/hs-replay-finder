export default class Replays {

  constructor() {
    this.clearReplays()
  }

  // returns a list of all replays
  addReplays(replays) {
    replays.forEach(replay => {
      if (!this.replaySet.has(replay.link)) {
        this.replaySet.add(replay.link)
        this.replayList.push(replay)
      }
    })
    return this.replayList
  }

  clearReplays() {
    this.replayList = []
    this.replaySet = new Set()
  }
}
