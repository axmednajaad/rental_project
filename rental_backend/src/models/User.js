const pool = require('../config/db'); 


class User {
  static async create({ name, email, phone, role }) {
    const [result] = await pool.query(
      'INSERT INTO Users (name, email, phone, role) VALUES (?, ?, ?, ?)',
      [name, email, phone, role]
    );
    return result.insertId;
  }

  static async findAll() {
    const [rows] = await pool.query('SELECT * FROM Users');
    return rows;
  }

  static async findById(user_id) {
    const [rows] = await pool.query('SELECT * FROM Users WHERE user_id = ?', [user_id]);
    return rows[0];
  }

  static async findByEmail(email) {
    const [rows] = await pool.query('SELECT * FROM Users WHERE email = ?', [email]);
    return rows[0];
  }

  static async update(user_id, { name, email, phone, role }) {
    const [result] = await pool.query(
      'UPDATE Users SET name = ?, email = ?, phone = ?, role = ? WHERE user_id = ?',
      [name, email, phone, role, user_id]
    );
    return result.affectedRows;
  }

  static async delete(user_id) {
    const [result] = await pool.query('DELETE FROM Users WHERE user_id = ?', [user_id]);
    return result.affectedRows;
  }
}

module.exports = User;