const { Pool } = require('pg')

class PlaylistsService {
  constructor() {
    this._pool = new Pool()
  }

  async getPlaylists(playlistId) {
    const query = {
      text: `SELECT p.id, p.name, u.username
                FROM playlists p
                LEFT JOIN users u ON p.owner = u.id
                WHERE p.id = $1`,
      values: [playlistId],
    }

    const playlistResult = await this._pool.query(query)

    const songQuery = {
      text: `SELECT s.id, s.title, s.performer
                FROM playlist_songs ps
                JOIN songs s ON ps.song_id = s.id
                LEFT JOIN playlists p ON ps.playlist_id = p.id
                WHERE ps.playlist_id = $1`,
      values: [playlistId],
    }

    const songResult = await this._pool.query(songQuery)

    const songs = songResult.rows.map((song) => ({
      id: song.id,
      title: song.title,
      performer: song.performer,
    }))

    const playlist = {
      playlist: {
        id: playlistResult.rows[0].id,
        name: playlistResult.rows[0].name,
        username: playlistResult.rows[0].username,
        songs: songs,
      },
    }

    return playlist
    // console.log(playlist)
  }
}

module.exports = PlaylistsService
