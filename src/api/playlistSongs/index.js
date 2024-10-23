const routes = require('./routes')
const PlaylistSongsHandler = require('./handler')

module.exports = {
  name: 'playlistSongs',
  version: '1.0.0',
  register: async (
    server,
    { playlistSongsService, playlistsService, activitiesService, validator },
  ) => {
    const playlistSongsHandler = new PlaylistSongsHandler(
      playlistSongsService,
      playlistsService,
      activitiesService,
      validator,
    )
    server.route(routes(playlistSongsHandler))
  },
}
