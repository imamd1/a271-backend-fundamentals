
const AlbumLikesHandler = require('./handler');
const routes = require('./routes');

module.exports = {
  name: 'albumLikes',
  version: '1.0.0',
  register: async (server, { service, albumsService, cacheService, validator }) => {
 
    const albumLikesHandler = new AlbumLikesHandler(
      service,
      albumsService, cacheService,
      validator,
    );
    server.route(routes(albumLikesHandler));
  },
};
