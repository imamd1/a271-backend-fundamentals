const { nanoid } = require("nanoid");
const { Pool } = require("pg");
const InvariantError = require("../exceptions/InvariantError");
const NotFoundError = require("../exceptions/NotFoundError");


class ActivitiesService {
    constructor() {
        this._pool = new Pool()
    }

    async addActivity(playlistId, songId, userId, action) {
        const id = `activity-${nanoid(10)}`
        const time = new Date().toISOString()

        const query = {
            text: `INSERT INTO playlist_song_activities VALUES($1,$2,$3,$4,$5,$6) RETURNING id`,
            values: [id, playlistId, songId, userId, action, time]
        }

        const result = await this._pool.query(query)

        if (!result.rowCount) {
            throw new InvariantError('Gagal menambahkan aktivitas')
        }

        return result.rows[0].id
    }

    async getActivities(playlistId) {

        const query = {
            text: `SELECT u.username AS username, s.title AS title, ac.action, ac.time
            FROM playlist_song_activities ac
            LEFT JOIN users u ON ac.user_id = u.id
            LEFT JOIN songs s ON ac.song_id = s.id
            WHERE ac.playlist_id = $1`,
            values: [playlistId]
        }

        const result = await this._pool.query(query)

        if (!result.rowCount) {
            throw new NotFoundError('Gagal menampilkan aktivitas. Id playlist tidak ditemukan')
        }

        return result.rows
    }
}

module.exports = ActivitiesService