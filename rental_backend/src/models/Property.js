const pool = require('../config/db'); 


class Property {
  static async create({ name, description, type, size, location, price }) {
    const [result] = await pool.query(
      'INSERT INTO Properties (name, description, type, size, location, price) VALUES (?, ?, ?, ?, ?, ?)',
      [name, description, type, size, location, price]
    );
    return result.insertId;
  }

  static async findAll() {
    const [rows] = await pool.query('SELECT * FROM Properties');
    return rows;
  }

  static async findById(property_id) {
    const [rows] = await pool.query('SELECT * FROM Properties WHERE property_id = ?', [property_id]);
    return rows[0];
  }

  static async update(property_id, { name, description, type, size, location, price }) {
    const [result] = await pool.query(
      'UPDATE Properties SET name = ?, description = ?, type = ?, size = ?, location = ?, price = ? WHERE property_id = ?',
      [name, description, type, size, location, price, property_id]
    );
    return result.affectedRows;
  }

  static async delete(property_id) {
    const [result] = await pool.query('DELETE FROM Properties WHERE property_id = ?', [property_id]);
    return result.affectedRows;
  }
}

module.exports = Property;