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
    pgm.createTable('playlist_song_activities', {
        id: {
            type: 'VARCHAR(30)',
            primaryKey: true
        },
        playlist_id: {
            type: 'VARCHAR(25)',
            notNull: true
        },
        song_id: {
            type: 'VARCHAR(20)',
            notNull: true
        },
        user_id: {
            type: 'VARCHAR(30)',
            notNull: true
        },
        action: {
            type: 'VARCHAR(25)',
            notNull: true
        },
        time: {
            type: 'TEXT',
            notNull: true
        }
    })

    pgm.addConstraint('playlist_song_activities', 'playlist_song_activities.playlist_id_to_playlists.id', {
        foreignKeys: {
            columns: 'playlist_id',
            references: 'playlists(id)',
            onDelete: 'CASCADE'
        }
    })

    pgm.addConstraint('playlist_song_activities', 'playlist_song_activities.song_id_to_songs.id', {
        foreignKeys: {
            columns: 'song_id',
            references: 'songs(id)',
            onDelete: 'CASCADE'
        }
    })
    pgm.addConstraint('playlist_song_activities', 'playlist_song_activities.user_id_to_users.id', {
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
    pgm.dropTable('playlist_song_activities')
    pgm.dropConstraint('playlist_song_activities','playlist_song_activities.playlist_id_to_playlists.id')
    pgm.dropConstraint('playlist_song_activities','playlist_song_activities.song_id_to_songs.id')
    pgm.dropConstraint('playlist_song_activities','playlist_song_activities.user_id_to_users.id')

};
