const { nanoid } = require("nanoid");
const { Pool } = require("pg");
const InvariantError = require('../exceptions/InvariantError');
const NotFoundError = require('../exceptions/NotFoundError');
const AuthorizationError = require('../exceptions/AuthorizationError');


class PlaylistsService {

    constructor(collaborationsService) {
        this._pool = new Pool();
        this._collaborationsService = collaborationsService;
    }

    async addPlaylist({name, owner}) {

        const id = `playlist-${nanoid(10)}`;
        const query = {
            text: 'INSERT INTO playlists VALUES($1, $2, $3) RETURNING id',
            values: [id, name, owner]
        }

        const result = await this._pool.query(query);

        if(!result.rowCount) {
            throw new InvariantError('Playlist gagal ditambahkan;')
        }
        
        return result.rows[0].id;
    }

    async getPlaylists(owner) {
        const query = {            
            text: `SELECT p.id, p.name, u.username
            FROM playlists p
            LEFT JOIN users u ON p.owner = u.id
            LEFT JOIN collaborations c ON c.playlist_id = p.id
            WHERE p.owner = $1 OR c.user_id = $1`,
            values: [owner]
        };
    
        const result = await this._pool.query(query);
        return result.rows;

    }

    async deletePlaylistById(playlistId) {
        const query = {
            text: 'DELETE FROM playlists WHERE id = $1 RETURNING id',
            values: [playlistId],
        };

        const result = await this._pool.query(query);

        if (!result.rowCount) {
            throw new NotFoundError('Playlist gagal dihapus. Id tidak ditemukan');
        }
    }

    async verifyPlaylistOwner(playlistId, owner) {
        const query = {
            text: 'SELECT * FROM playlists WHERE id = $1',
            values: [playlistId],
        };

        const result = await this._pool.query(query);  

        if (!result.rowCount) {
            throw new NotFoundError('Playlist tidak ditemukan');
        }

        const playlist = result.rows[0];
        
        if (playlist.owner !== owner) {
            throw new AuthorizationError('Anda tidak berhak mengakses playlist ini');
        }
    }

    async verifyPlaylistAccess(playlistId, userId) {
        try{
            await this.verifyPlaylistOwner(playlistId, userId);
        } catch (error) {
            if (error instanceof NotFoundError) {
                throw error;
            }
            try {
                await this._collaborationsService.verifyCollaborator(playlistId, userId);
            } catch {
                throw error;
            }
        }
    }
}

module.exports = PlaylistsService;