/**
 * @type {import('node-pg-migrate').ColumnDefinitions | undefined}
 */

/**
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.up = (pgm) => {
    pgm.createTable('user_album_likes', {
        id: {
            type: "VARCHAR(30)",
            primaryKey: true
        },
        album_id: {
            type: "VARCHAR(20)",
            notNull: true
        },
        user_id: {
            type: "VARCHAR(30)",
            notNull: true
        }
    })
    pgm.addConstraint('user_album_likes', 'user_album_likes.album_id_to_albums.id', {
        foreignKeys: {
            columns: 'album_id',
            references: 'albums(id)',
            onDelete: 'CASCADE'
        }
    })
    pgm.addConstraint('user_album_likes', 'user_album_likes.user_id_to_users.id',{
        foreignKeys: {
            columns: 'user_id',
            references: 'users(id)',
            onDelete: 'CASCADE'
        }
    })
};

/**
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.down = (pgm) => {
    pgm.dropTable('user_album_likes')
    pgm.dropConstraint('user_album_likes.album_id_to_albums.id')
    pgm.dropConstraint('user_album_likes.user_id_to_users.id')
};
