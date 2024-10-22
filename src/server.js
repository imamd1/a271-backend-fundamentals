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
                origin: ['*']
            }
        }
    });

    await server.register([
        {
            plugin: songs,
            options: {
                service: songService,
                validator: SongsValidator,
            }
        },
        {
            plugin: albums,
            options: {
                service: albumService,
                validator: AlbumsValidator
            }
        }
    ])

    server.ext('onPreResponse', (request, h) => {
        // mendapatkan konteks response dari request
        const { response } = request;
        if (response instanceof ClientError) {
            // membuat response baru dari response toolkit sesuai kebutuhan error handling
            const newResponse = h.response({
                status: 'fail',
                message: response.message,
            });
            newResponse.code(response.statusCode);
            return newResponse;
        }
        // jika bukan ClientError, lanjutkan dengan response sebelumnya (tanpa terintervensi)
        return h.continue;
    });

    await server.start()
    console.log(`Server berjalan pada ${server.info.uri}`)
}

init();