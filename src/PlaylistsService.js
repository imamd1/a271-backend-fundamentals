const { Pool } = require("pg");


class PlaylistsService {
    constructor() {
        this._pool = new Pool()
    }

    async getPlaylists(userId) {
        const query = {
            text: `SELECT p.id, p.name, u.username
                FROM playlists p
                LEFT JOIN users u ON p.owner = u.id
                LEFT JOIN collaborations c ON c.playlist_id = p.id
                WHERE p.owner = $1 OR c.user_id = $1`,
            values: [userId],
        }

        const playlistResult = await this._pool.query(query)


        if (!playlistResult.rowCount) {
            throw new NotFoundError('Playlist tidak ditemukan')
        }

        const songQuery = {
            text: `SELECT s.id, s.title, s.performer
                FROM playlist_songs ps
                JOIN songs s ON ps.song_id = s.id
                LEFT JOIN playlists p ON ps._playlist_id = p.id
                LEFT JOIN users u ON p.owner = u.id
                LEFT JOIN collaborations c ON c.playlist_id = p.id
                WHERE p.owner = $1 OR c.user_id = $1`,
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
}

module.exports = PlaylistsService