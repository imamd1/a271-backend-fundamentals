const autoBind = require('auto-bind')

class PlaylistsHandler {
  constructor(service, validator) {
    this._service = service
    this._validator = validator

    autoBind(this)
  }

  async postPlaylistHandler(request, h) {
    this._validator.validatePlaylistPayload(request.payload)
    const { id: credentialId } = request.auth.credentials
    const { name } = request.payload
    const playlistId = await this._service.addPlaylist({
      name,
      owner: credentialId,
    })

    const response = h.response({
      status: 'success',
      message: 'Playlist berhasil ditambahkan',
      data: {
        playlistId,
      },
    })
    response.code(201)
    return response
  }

  async getPlaylistsHandler(request) {
    const { id: credentialId } = request.auth.credentials
    const playlists = await this._service.getPlaylists(credentialId)
    return {
      status: 'success',
      data: {
        playlists,
      },
    }
  }

  async getPlaylistByIdHandler(request) {
    const { id: owner } = request.auth.credentials
    const playlists = await this._service.getPlaylists(owner)
    return {
      status: 'success',
      data: {
        playlists,
      },
    }
  }

  async deletePlaylistByIdHandler(request) {
    const { playlistId } = request.params
    const { id: credentialId } = request.auth.credentials
    await this._service.verifyPlaylistOwner(playlistId, credentialId)
    await this._service.deletePlaylistById(playlistId)

    return {
      status: 'success',
      message: 'Playlist berhasil dihapus',
    }
  }
}

module.exports = PlaylistsHandler
