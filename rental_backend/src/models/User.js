const pool = require('../config/db');
const bcrypt = require('bcrypt');

class User {
  static async create({ name, email, phone, role, password }) {
    // Hash the password before storing
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const [result] = await pool.query(
      'INSERT INTO Users (name, email, phone, role, password) VALUES (?, ?, ?, ?, ?)',
      [name, email, phone, role, hashedPassword]
    );
    return result.insertId;
  }

  static async findAll() {
    const [rows] = await pool.query('SELECT user_id, name, email, phone, role FROM Users');
    return rows;
  }

  static async findById(user_id) {
    const [rows] = await pool.query('SELECT user_id, name, email, phone, role FROM Users WHERE user_id = ?', [user_id]);
    return rows[0];
  }

  static async findByEmail(email) {
    const [rows] = await pool.query('SELECT * FROM Users WHERE email = ?', [email]);
    return rows[0];
  }

  static async validatePassword(email, password) {
    const user = await this.findByEmail(email);
    console.log('User found by email:', user);

    if (!user) {
      return null;
    }

    const isValid = await bcrypt.compare(password, user.password);
    console.log('Password valid:', isValid);

    if (isValid) {
      // Return user without password
      const { password: _, ...userWithoutPassword } = user;
      console.log('User without password:', userWithoutPassword);
      return userWithoutPassword;
    }
    return null;
  }

  static async update(user_id, { name, email, phone, role, password }) {
    let query, params;

    if (password) {
      // If password is provided, hash it and update
      const saltRounds = 10;
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      query = 'UPDATE Users SET name = ?, email = ?, phone = ?, role = ?, password = ? WHERE user_id = ?';
      params = [name, email, phone, role, hashedPassword, user_id];
    } else {
      // If no password provided, update without password
      query = 'UPDATE Users SET name = ?, email = ?, phone = ?, role = ? WHERE user_id = ?';
      params = [name, email, phone, role, user_id];
    }

    const [result] = await pool.query(query, params);
    return result.affectedRows;
  }

  static async delete(user_id) {
    const [result] = await pool.query('DELETE FROM Users WHERE user_id = ?', [user_id]);
    return result.affectedRows;
  }
}

module.exports = User;