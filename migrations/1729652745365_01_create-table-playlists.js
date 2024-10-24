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
    pgm.createTable('playlists', {
        id: {
            type: 'VARCHAR(25)',
            primaryKey: true
        },
        name: {
            type: 'TEXT',
            notNull: true
        },
        owner: {
            type: 'VARCHAR(30)',
            notNull: true
        }
    })

    pgm.addConstraint('playlists', 'playlists.owner_to_users.id', {
        foreignKeys: {
            columns: 'owner',
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
    pgm.dropTable('playlists')
    pgm.dropConstraint('playlists','playlists.owner_to_users.id')
};
