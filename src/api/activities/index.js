const routes = require('./routes');
const ActivitiesHandler = require('./handler');

module.exports = {
    name: 'activities',
    version: '1.0.0',
    register: async (server, { activitiesService, playlistsService, validator }) => {
        const activitiesHandler = new ActivitiesHandler(activitiesService, playlistsService, validator)
        server.route(routes(activitiesHandler));
    },
};