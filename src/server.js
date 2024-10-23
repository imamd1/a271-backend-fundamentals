require('dotenv').config()

const Hapi = require('@hapi/hapi')

const songs = require('./api/songs')
const SongsService = require('./services/SongsService')
const SongsValidator = require('./validators/songs')

const albums = require('./api/albums')
const AlbumsService = require('./services/AlbumsService')
const AlbumsValidator = require('./validators/albums')
const ClientError = require('./exceptions/ClientError')

const init = async () => {
  const songService = new SongsService()
  const albumService = new AlbumsService()

  const server = Hapi.server({
    port: process.env.PORT,
    host: process.env.HOST,
    routes: {
      cors: {
        origin: ['*'],
      },
    },
  })

  await server.register([
    {
      plugin: songs,
      options: {
        service: songService,
        validator: SongsValidator,
      },
    },
    {
      plugin: albums,
      options: {
        service: albumService,
        validator: AlbumsValidator,
      },
    },
  ])

  server.ext('onPreResponse', (request, h) => {
    // mendapatkan konteks response dari request
    const { response } = request

    if (response instanceof Error) {
      // penanganan client error secara internal.
      if (response instanceof ClientError) {
        const newResponse = h.response({
          status: 'fail',
          message: response.message,
        })
        newResponse.code(response.statusCode)
        return newResponse
      }
      // mempertahankan penanganan client error oleh hapi secara native, seperti 404, etc.
      if (!response.isServer) {
        return h.continue
      }
      // penanganan server error sesuai kebutuhan
      const newResponse = h.response({
        status: 'error',
        message: 'terjadi kegagalan pada server kami',
      })
      newResponse.code(500)
      return newResponse
    }

    // jika bukan error, lanjutkan dengan response sebelumnya (tanpa terintervensi)
    return h.continue
  })
  await server.start()
  console.log(`Server berjalan pada ${server.info.uri}`)
}

init()
