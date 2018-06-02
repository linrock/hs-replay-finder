interface Replay {
  link: string
}

export default class Replays {
  replayList: Array<Replay>
  replaySet: Set<string>

  constructor() {
    this.replayList = []
    this.replaySet = new Set()
  }

  // returns a list of all replays
  addReplays(replays): Array<Replay> {
    replays.forEach(replay => {
      if (!this.replaySet.has(replay.link)) {
        this.replaySet.add(replay.link)
        this.replayList.push(replay)
      }
    })
    return this.replayList
  }
}
