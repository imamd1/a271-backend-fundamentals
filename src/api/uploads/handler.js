const autoBind = require('auto-bind');

class UploadsHandler {
  constructor(storageService, albumsService, validator) {
    this._storageService = storageService;
    this._albumsService = albumsService;
    this._validator = validator;
    autoBind(this);
  }

  async postUploadCoverImageHandler(request, h) {
    const { id } = request.params;
    const { cover } = request.payload;
    if (!cover || !cover.hapi) {
      const response = h.response({
        status: 'fail',
        message: 'Invalid file upload payload',
      });
      response.code(400);
      return response;
    }
    this._validator.validateImageHeaders(cover.hapi.headers);

    const filename = await this._storageService.writeFile(cover, cover.hapi);
    // insert into database
    const coverUrl = `http://${process.env.HOST}:${process.env.PORT}/uploads/images/${filename}`;
  
    await this._albumsService.editCoverAlbumById(id, coverUrl);


    // response json
    const response = h.response({
      status: 'success',
      message: 'Sampul berhasil diunggah',
      cover: {
        coverUrl: `http://${process.env.HOST}:${process.env.PORT}/uploads/images/${filename}`,
      },
    });
    response.code(201);
    return response;
  }
}

module.exports = UploadsHandler;
