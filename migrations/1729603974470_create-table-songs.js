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
    pgm.createTable('songs', {
        id: {
            type: 'VARCHAR(20)',
            primaryKey: true
        },
        title: {
            type: "TEXT",
            notNull: true
        },
        year: {
            type: 'INTEGER',
            notNull: true
        },
        performer: {
            type: 'TEXT',
            notNull: true
        },
        genre: {
            type: 'TEXT',
            notNull: true
        },
        duration: {
            type: 'INTEGER',
            notNull: true
        },
        created_at: {
            type: 'TEXT',
            notNull: true,
        },
        updated_at: {
            type: 'TEXT',
            notNull: true,
        },
    })

};

/**
 * @param pgm {import('node-pg-migrate').MigrationBuilder}
 * @param run {() => void | undefined}
 * @returns {Promise<void> | void}
 */
exports.down = (pgm) => {
    pgm.dropTable('songs')
};