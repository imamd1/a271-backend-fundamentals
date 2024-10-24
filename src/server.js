require('dotenv').config()

const Hapi = require('@hapi/hapi')
const Jwt = require('@hapi/jwt')
const path = require('path')
const Inert = require('@hapi/inert')

const ClientError = require('./exceptions/ClientError')
const songs = require('./api/songs')
const SongsService = require('./services/SongsService')
const SongsValidator = require('./validators/songs')

const albums = require('./api/albums')
const AlbumsService = require('./services/AlbumsService')
const AlbumsValidator = require('./validators/albums')

const users = require('./api/users')
const UsersService = require('./services/UsersService')
const UsersValidator = require('./validators/users')

const authentications = require('./api/authentications')
const AuthenticationsService = require('./services/AuthenticationsService')
const AuthenticationValidator = require('./validators/authentications')
const TokenManager = require('./tokenize/TokenManager')

const playlists = require('./api/playlists')
const PlaylistsService = require('./services/PlaylistsService')
const PlaylistValidator = require('./validators/playlists')

const playlistSongs = require('./api/playlistSongs')
const PlaylistSongsService = require('./services/PlaylistSongsService')
const PlaylistSongsValidator = require('./validators/playlistSongs')

const collaborations = require('./api/collaborations')
const CollaborationsService = require('./services/CollaborationsService')
const CollaborationsValidator = require('./validators/collaborations')

const activities = require('./api/activities')
const ActivitiesService = require('./services/ActivitiesService')
const ActivitiesValidator = require('./validators/activities')

const _exports = require('./api/exports')
const ExportPlaylistsService = require('./services/ExportPlaylistsService')
const ExportPlaylistValidator = require('./validators/exports')

const uploads = require('./api/uploads')
const StorageService = require('./services/StorageService')
const UploadsValidator = require('./validators/uploads')

const albumLikes = require('./api/albumLikes')
const AlbumLikesService = require('./services/AlbumLikesService')
const AlbumLikeValidator = require('./validators/albumLikes')

const CacheService = require('./services/CacheService')

const init = async () => {
  const cacheService = new CacheService()
  const songService = new SongsService()
  const albumsService = new AlbumsService()
  const usersService = new UsersService()
  const collaborationsService = new CollaborationsService()
  const authenticationsService = new AuthenticationsService()
  const playlistsService = new PlaylistsService(collaborationsService)
  const playlistSongsService = new PlaylistSongsService()
  const activitiesService = new ActivitiesService()
  const storageService = new StorageService(
    path.resolve(__dirname, 'api/uploads/file/images'),
  )
  const albumLikesService = new AlbumLikesService(cacheService)
  

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
      plugin: Jwt,
    },
    { plugin: Inert },
  ])

  server.auth.strategy('songsapp_jwt', 'jwt', {
    keys: process.env.ACCESS_TOKEN_KEY,
    verify: {
      aud: false,
      iss: false,
      sub: false,
      maxAgeSec: process.env.ACCESS_TOKEN_AGE,
    },
    validate: (artifacts) => ({
      isValid: true,
      credentials: {
        id: artifacts.decoded.payload.id,
      },
    }),
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
        service: albumsService,
        validator: AlbumsValidator,
      },
    },
    {
      plugin: users,
      options: {
        service: usersService,
        validator: UsersValidator,
      },
    },
    {
      plugin: authentications,
      options: {
        authenticationsService,
        usersService,
        tokenManager: TokenManager,
        validator: AuthenticationValidator,
      },
    },
    {
      plugin: playlists,
      options: {
        service: playlistsService,
        validator: PlaylistValidator,
      },
    },
    {
      plugin: playlistSongs,
      options: {
        playlistSongsService,
        playlistsService,
        activitiesService,
        validator: PlaylistSongsValidator,
      },
    },
    {
      plugin: collaborations,
      options: {
        collaborationsService,
        playlistsService,
        usersService,
        validator: CollaborationsValidator,
      },
    },
    {
      plugin: activities,
      options: {
        activitiesService,
        playlistsService,
        validator: ActivitiesValidator,
      },
    },
    {
      plugin: _exports,
      options: {
        service: ExportPlaylistsService,
        validator: ExportPlaylistValidator,
      },
    },
    {
      plugin: uploads,
      options: {
        storageService,
        albumsService,
        validator: UploadsValidator,
      },
    },
    {
      plugin: albumLikes,
      options: {
        albumLikesService,
        albumsService,
        validator: AlbumLikeValidator
      }
    }
  ])

  server.ext('onPreResponse', (request, h) => {
    // mendapatkan konteks response dari request
    const { response } = request
    // console.log(response)
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
