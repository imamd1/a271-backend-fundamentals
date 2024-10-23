const NotFoundError = require('../../exceptions/NotFoundError')
const autoBind = require('auto-bind')
class PlaylistSongsHandler {
  constructor(service, playlistsService, activitiesService, validator) {
    this._service = service
    this._playlistsService = playlistsService
    this._activitiesService = activitiesService
    this._validator = validator

    autoBind(this)
  }
  async postPlaylistSongHandler(request, h) {
    const { id: userId } = request.auth.credentials
    const { playlistId, any } = request.params
    if (any !== 'songs') {
      throw new NotFoundError('Resource not found')
    }
    this._validator.validatePlaylistSongPayload(request.payload)
    const { songId } = request.payload
    const action = 'add'
    await this._service.verifySong(songId)
    await this._playlistsService.verifyPlaylistAccess(playlistId, userId)
    const playlistsongId = await this._service.addSongPlaylist(
      playlistId,
      songId,
    )
    await this._activitiesService.addActivity(playlistId, songId, userId, action)

    const response = h.response({
      status: 'success',
      message: 'Lagu berhasil ditambahkan ke playlist',
      data: {
        playlistsongId,
      },
    })
    response.code(201)
    return response
  }
  async getPlaylistSongHandler(request, h) {
    const { id: userId } = request.auth.credentials
    const { playlistId, any } = request.params
    if (any !== 'songs') {
      throw new NotFoundError('Resource not found')
    }
    await this._playlistsService.verifyPlaylistAccess(playlistId, userId)
    const playlist = await this._service.getPlaylistSongs(playlistId)
    return {
      status: 'success',
      data: {
        playlist,
      },
    }
  }

  async deletePlaylistSongHandler(request, h) {
    const { id: userId } = request.auth.credentials
    const { playlistId, any } = request.params
    if (any !== 'songs') {
      throw new NotFoundError('Resource not found')
    }
    this._validator.validatePlaylistSongPayload(request.payload)
    const { songId } = request.payload
    const action = 'delete'
    await this._playlistsService.verifyPlaylistAccess(playlistId, userId)
    await this._activitiesService.addActivity(playlistId, songId, userId, action)
    await this._service.deletePlaylistSong(playlistId, songId)

    return {
      status: 'success',
      message: 'Lagu berhasil dihapus dari playlist',
    }
  }
}
module.exports = PlaylistSongsHandler
