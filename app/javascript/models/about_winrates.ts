interface About {
  since: string,
  count: string,
}

export default class AboutWinrates {

  constructor(private about: About) {
    this.about = about
  }

  get sinceDays(): number {
    const since = new Date(this.about.since).getTime()
    const secondsSince = ((new Date()).getTime() - since) / 1000
    return Math.round(secondsSince / 86400)
  }

  get numReplays(): string {
    return this.about.count
  }
}
