const { nanoid } = require("nanoid");
const { Pool } = require("pg");
const InvariantError = require("../exceptions/InvariantError");
const mapDBToModel = require("../utils");
const NotFoundError = require("../exceptions/NotFoundError");


class AlbumsService {
    constructor() {
        this._pool = new Pool()
    }

    async addAlbum({ name, year }) {
        const id = `album-${nanoid(10)}`
        const createdAt = new Date().toISOString()

        const query = {
            text: `INSERT INTO albums VALUES($1,$2,$3,$4,$5) RETURNING id`,
            values: [id, name, year, createdAt, createdAt]
        }

        const result = await this._pool.query(query)

        if (!result.rowCount) {
            throw new InvariantError('Gagal menambahkan album')
        }

        return result.rows[0].id
    }

    async getAlbumById(albumId) {
        const query = {
            text: `SELECT id, name, year FROM albums WHERE id = $1`,
            values: [albumId]
        }

        const result = await this._pool.query(query)

        if (!result.rowCount) {
            throw new NotFoundError('Album tidak ditemukan');
        }

        const album = result.rows[0]

        const songQuery = {
            text: `SELECT id, title, performer FROM songs WHERE album_id = $1`,
            values: [albumId]
        }

        const songResult = await this._pool.query(songQuery)

        const songs = songResult.rows.map(mapDBToModel)

        return {
            ...album,
            songs
        }
    }

    async editAlbumById(albumId, {name, year}) {
        const updatedAt = new Date().toISOString()

        const query = {
            text: 'UPDATE albums SET name = $1, year = $2, updated_at = $3 WHERE id = $4',
            values: [name, year, updatedAt, albumId ]
        }

        const result = await this._pool.query(query)

        if(!result.rowCount) {
            throw new NotFoundError('Gagal mengubah Album. Id tidak ditemukan')
        }
    }

    async deleteAlbumById(albumId) {
        const query = {
            text: 'DELETE FROM albums WHERE id = $1',
            values: [albumId]
        }

        const result = await this._pool.query(query)

        if(!result.rowCount) {
            throw new NotFoundError('Gagal menghapus album. Id tidak ditemukan')
        }
    }
}

module.exports = AlbumsService