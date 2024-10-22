const { nanoid } = require("nanoid");
const { Pool } = require("pg");
const mapDBToModel = require('../utils/index');
const NotFoundError = require("../exceptions/NotFoundError");
const InvariantError = require("../exceptions/InvariantError");


class SongsService {
    constructor() {
        this._pool = new Pool()
    }

    async addSong({ title, year, performer, genre, duration, albumId}) {
        const id = `song-${nanoid(15)}`;
        const createdAt = new Date().toISOString();
        const updatedAt = createdAt;

        const query = {
            text: 'INSERT INTO songs VALUES($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id',
            values: [id, title, year, performer, genre, duration, createdAt, updatedAt, albumId],
        };

        const result = await this._pool.query(query);

        if (!result.rows[0].id) {
            throw new InvariantError('Lagu gagal ditambahkan');
        }

        return result.rows[0].id;
    }

    async getSongs({title = '', performer = ''}) {

        const query = {
            text: `SELECT id, title, performer FROM songs WHERE LOWER(title) LIKE $1 AND LOWER(performer) LIKE $2`,
            values: [`%${title.toLowerCase()}%`, `%${performer.toLowerCase()}%`]
        }

        const result = await this._pool.query(query);
        return result.rows.map(mapDBToModel);
    }

    async getSongById(songId) {
        const query = {
            text: 'SELECT * FROM songs WHERE id = $1',
            values: [songId],
        };
        const result = await this._pool.query(query);

        if (!result.rowCount) {
            throw new NotFoundError('Lagu tidak ditemukan');
        }

        return result.rows.map(mapDBToModel1)[0];
    }

    async editSongById(songId, { title, year, performer, genre, duration }) {
        const updatedAt = new Date().toISOString();
        const query = {
            text: 'UPDATE songs SET title = $1, year = $2, performer = $3, genre = $4, duration = $5, updated_at = $6 WHERE id = $7 RETURNING id',
            values: [title, year, performer, genre, duration, updatedAt, songId],
        };

        const result = await this._pool.query(query);

        if (!result.rowCount) {
            throw new InvariantError('Gagal memperbarui lagu.');
        }
    }

    async deleteSongById(songId) {
        const query = {
            text: 'DELETE FROM songs WHERE id = $1 RETURNING id',
            values: [songId],
        };

        const result = await this._pool.query(query);

        if (!result.rowCount) {
            throw new NotFoundError('Gagal menghapus lagu. Id tidak ditemukan');
        }
    }

}

module.exports = SongsService;