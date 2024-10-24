const { nanoid } = require('nanoid')
const { Pool } = require('pg')
const InvariantError = require('../exceptions/InvariantError')
const NotFoundError = require('../exceptions/NotFoundError')

class AlbumLikesService {
  constructor(cacheService) {
    this._pool = new Pool()
    this._cacheService = cacheService
  }

  async addLikeAlbum(albumId, userId) {
    const id = `like-${nanoid(10)}`
    const query = {
      text: `INSERT INTO user_album_likes VALUES($1,$2,$3) RETURNING id`,
      values: [id, albumId, userId],
    }

    const result = await this._pool.query(query)

    await this._cacheService.delete(`album_like:${albumId}`)
    if (!result.rowCount) {
      throw new InvariantError('Gagal menyukai album')
    }
  }

  async verifyUserLikeAlbum(albumId, userId) {
    const query = {
      text: `SELECT * FROM user_album_likes WHERE album_id = $1 AND user_id = $2`,
      values: [albumId, userId],
    }

    const result = await this._pool.query(query)

    if (result.rowCount > 0) {
      throw new InvariantError('Gagal menyukai album yang sama')
    }
  }

  async getAlbumLikesByAlbumId(albumId) {
    try {
      const result = await this._cacheService.get(`album_like:${albumId}`)
      return {
        isCache: true,
        like: JSON.parse(result),
      }
    } catch (error) {
      const query = {
        text: `SELECT * FROM user_album_likes WHERE album_id = $1`,
        values: [albumId],
      }
      const result = await this._pool.query(query)

      await this._cacheService.set(
        `album_like:${albumId}`,
        JSON.stringify(result.rowCount),
      )

      return {
        isCache: false,
        like: result.rowCount,
      }
    }
  }

  async deleteLikeAlbum(albumId, userId) {
    const query = {
      text: `DELETE FROM user_album_likes WHERE album_id = $1 AND user_id = $2`,
      values: [albumId, userId],
    }

    const result = await this._pool.query(query)

    // if (!result.rowCount) {
    //   throw new InvariantError('Gagal menghapus like pada album')
    // }

    await this._cacheService.delete(`album_like:${albumId}`)
  }
}

module.exports = AlbumLikesService
