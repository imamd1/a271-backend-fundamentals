const { nanoid } = require('nanoid')
const { Pool } = require('pg')
const InvariantError = require('../exceptions/InvariantError')
const NotFoundError = require('../exceptions/NotFoundError')

class PlaylistSongsService {
  constructor() {
    this._pool = new Pool()
  }

  async addSongPlaylist(playlistId, songId) {
    const id = `playlistsong-${nanoid(10)}`

    const query = {
      text: `INSERT INTO playlist_songs VALUES($1,$2,$3) RETURNING id`,
      values: [id, playlistId, songId],
    }

    const result = await this._pool.query(query)

    if (!result.rowCount) {
      throw new InvariantError('Gagal menambahkan lagu ke dalam playlist')
    }
    return result.rows[0].id
  }

  async getPlaylistSongs(playlistId) {
    const query = {
      text: `SELECT p.id, p.name, u.username as username
                    FROM playlists p
                    JOIN users u ON p.owner = u.id
                    WHERE p.id = $1`,
      values: [playlistId],
    }

    const playlistResult = await this._pool.query(query)  


    if (!playlistResult.rowCount) {
      throw new NotFoundError('Playlist tidak ditemukan')
    }

    const songQuery = {
      text: `SELECT s.id, s.title, s.performer
        FROM playlist_songs ps
        JOIN songs s ON ps.song_id = s.id 
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
        id: playlistResult.rows[0].id,
        name: playlistResult.rows[0].name,
        username: playlistResult.rows[0].username,
        songs: songs
    }

    return playlist
  }

  async deletePlaylistSong(playlistId, songId) {
    const query = {
      text: `DELETE FROM playlist_songs WHERE playlist_id = $1 AND song_id = $2`,
      values: [playlistId, songId],
    }

    const result = await this._pool.query(query)
    if (!result.rowCount) {
      throw new InvariantError('Gagal menghapus lagu dari Playlist')
    }
  }

  async verifySong(songId) {
    const query = {
      text: `SELECT id FROM songs WHERE id = $1`,
      values: [songId]
    }

    const result = await this._pool.query(query)

    if(!result.rowCount) {
      throw new NotFoundError('Lagu tidak ditemukan')
    }
  }
}

module.exports = PlaylistSongsService
