import axios from 'axios'

export default function fetchReplays(path) {
  path = path || `/`
  return axios.get(`replays.json?path=${path}`).then(response => response.data)
}
