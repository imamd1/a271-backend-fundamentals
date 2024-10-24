const routes = (handler) => [

    {
        method: 'POST',
        path: '/albums/{albumId}/likes',
        handler: handler.postLikeAlbumHandler,
        options: {
            auth: 'songsapp_jwt',
        },
    },
    {
        method: 'GET',
        path: '/albums/{albumId}/likes',
        handler: handler.getLikesAlbumHandler,
    },
    {
        method: 'DELETE',
        path: '/albums/{albumId}/likes',
        handler: handler.deleteLikeAlbumHandler,
        options: {
            auth: 'songsapp_jwt',
        },
    }
]

module.exports = routes