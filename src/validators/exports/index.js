const ExportPlaylistPayload = require("./schema")
const InvariantError = require('../../exceptions/InvariantError')


const ExportPlaylistValidator = {
    validateExportPlaylistPayload: (payload) => {
        const validationResult = ExportPlaylistPayload.validate(payload)
        if(validationResult.error) {
            throw new InvariantError(validationResult.error.message)
        }
    }
}

module.exports = ExportPlaylistValidator