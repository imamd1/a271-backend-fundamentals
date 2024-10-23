
const autoBind = require('auto-bind')
class ActivitiesHandler {

    constructor(activitiesService, playlistsService) {
        this._service = activitiesService
        this._playlistsService = playlistsService

        autoBind(this)
    }

    async getActivitiesHandler(request) {
        const { playlistId } = request.params
        const { id: userId } = request.auth.credentials

        await this._playlistsService.verifyPlaylistAccess(playlistId, userId)
        const activities = await this._service.getActivities(playlistId)

        return {
            status: 'success',
            data: {
                playlistId,
                activities
            }
        };

    }
}

module.exports = ActivitiesHandler