const Joi = require("joi");


const ExportPlaylistPayload = Joi.object({
    targetEmail: Joi.string().email({tlds: true}).required()
})

module.exports = ExportPlaylistPayload