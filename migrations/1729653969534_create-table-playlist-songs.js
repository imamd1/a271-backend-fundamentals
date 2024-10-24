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
    pgm.createTable('playlist_songs', {
        id: {
            type: 'VARCHAR(30)',
            primaryKey: true
        },
        playlist_id: {
            type: 'VARCHAR(30)',
            notNull: true
        },
        song_id: {
            type: 'VARCHAR(20)',
            notNull: true
        }
    })

    pgm.addConstraint('playlist_songs', 'playlist_songs.playlist_id_to_playlists.id', {
        foreignKeys: {
            columns: 'playlist_id',
            references: 'playlists(id)',
            onDelete: 'CASCADE'
        }
    })
    pgm.addConstraint('playlist_songs', 'playlist_songs.song_id_to_songs.id', {
        foreignKeys: {
            columns: 'song_id',
            references: 'songs(id)',
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
    pgm.dropTable('playlist_songs')
    pgm.dropConstraint('playlist_songs','playlist_songs.playlist_id_to_playlists.id')
    pgm.dropConstraint('playlist_songs','playlist_songs.user_id_to_users.id')
    pgm.dropConstraint()

};
