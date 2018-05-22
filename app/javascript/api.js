import axios from 'axios'

export default function fetchReplays(query) {
  return axios.get('replays.json').then(response => {
    if (response.status === 200) {
      return response.data
    } else {
      console.error('api request failed')
    }
  })
}
