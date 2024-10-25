const autoBind = require('auto-bind')

class AlbumLikesHandler {
  constructor(service, albumsService, validator) {
    this._service = service
    this._albumsService = albumsService
    this._validator = validator


    autoBind(this)
  }

  async postLikeAlbumHandler(request, h) {
    const { id: userId } = request.auth.credentials
    const { albumId } = request.params

    await this._albumsService.getAlbumById(albumId)
    await this._service.verifyUserLikeAlbum(albumId, userId)
    await this._service.addLikeAlbum(albumId, userId)

    const response = h.response({
      status: 'success',
      message: 'berhasil menyukai album',
    })
    response.code(201)
    return response
  }

  async getLikesAlbumHandler(request, h) {
    const { albumId } = request.params

    const { like, isCache } = await this._service.getAlbumLikesByAlbumId(
      albumId,
    )

    const response = h.response({
      status: 'success',
      data: {
        likes: like
      }
    })
    if (isCache) {
      response.header('X-Data-Source', 'cache')
    } else {
      response.header('X-Data-Source', 'not-cache')
    }
    return response
  }

  async deleteLikeAlbumHandler(request) {
    const { albumId } = request.params
    const { id: userId } = request.auth.credentials

    await this._service.deleteLikeAlbum(albumId, userId)

    return {
      status: 'success',
      message: 'Album batal disukai',
    }
  }
}

module.exports = AlbumLikesHandler
