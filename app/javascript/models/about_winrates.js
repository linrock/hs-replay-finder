export default class AboutWinrates {

  constructor(about) {
    this.about = about
  }

  get daysSince() {
    const since = new Date(this.about.since)
    const secondsSince = (new Date() - since) / 1000
    return parseInt(secondsSince / 86400, 10)
  }

  get numReplays() {
    return this.about.count
  }
}
