/**
 * @type {import('node-pg-migrate').ColumnDefinitions | undefined}
 */
exports.shorthands = undefined;

/**
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.up = (pgm) => {
    pgm.createTable('collaborations', {
        id: {
            type: 'VARCHAR(30)',
            primaryKey: true
        },
        playlist_id: {
            type: 'VARCHAR(30)',
            notNull: true
        },
        user_id: {
            type: 'VARCHAR(30)',
            notNull: true
        }
    })

    pgm.addConstraint('collaborations', 'collaborations.playlist_id_to_playlists.id', {
        foreignKeys: {
            columns: 'playlist_id',
            references: 'playlists(id)',
            onDelete: 'CASCADE'
        }
    })

    pgm.addConstraint('collaborations', 'collaborations.user_id_to_users.id', {
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
    pgm.dropTable('collaborations')
    pgm.dropConstraint('collaborations','collaborations.playlist_id_to_playlists.id')
    pgm.dropConstraint('collaborations','collaborations.user_id_to_users.id')

};
