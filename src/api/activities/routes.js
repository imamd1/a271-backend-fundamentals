const routes = (handler) => [
    {
        method: 'GET',
        path: '/playlists/{playlistId}/activities',
        handler: handler.getActivitiesHandler,
        options: {
            auth: 'songsapp_jwt',
          },
    }
]

module.exports = routes