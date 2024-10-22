const Joi = require("joi")


const AlbumPayloadSchema = Joi.object({
    name: Joi.string().required(),
    year: Joi.number().min(1900).max(2024).required()
})

module.exports = { AlbumPayloadSchema }