
class AlbumsHandler {
    constructor(service, validator) {
        this._service = service
        this._validator = validator

        this.postAlbumHandler = this.postAlbumHandler.bind(this)
        this.getAlbumByIdHandler = this.getAlbumByIdHandler.bind(this)
        this.putAlbumByIdHandler = this.putAlbumByIdHandler.bind(this)
        this.deleteAlbumByIdHandler = this.deleteAlbumByIdHandler.bind(this)
    }

    async postAlbumHandler(request, h) {
        this._validator.validateAlbumPayload(request.payload) 
        const {name, year} = request.payload
        const albumId = await this._service.addAlbum({name, year})

        const response = h.response({
            status: 'success',
            message: 'Album berhasil ditambahkan',
            data: {
                albumId,
            },
        });
        response.code(201);
        return response;
    }

    async getAlbumByIdHandler(request, h) {
        const {albumId} = request.params

        const album = await this._service.getAlbumById(albumId)
        const response = h.response({
            status: 'success',
            message: 'Data berhasil ditampilkan',
            data: {
                album,
            },
        });
        response.code(200);
        return response;
    }

    async putAlbumByIdHandler(request) {
        this._validator.validateAlbumPayload(request.payload)
        const {albumId} = request.params

        await this._service.editAlbumById(albumId, request.payload)

        return {
            status: 'success',
            message: 'Album berhasil diperbarui',
        };
    }

    async deleteAlbumByIdHandler(request) {
        const {albumId} = request.params

        await this._service.deleteAlbumById(albumId)

        return {
            status: 'success',
            message: 'Album berhasil dihapus',
        };
    }

}

module.exports = AlbumsHandler