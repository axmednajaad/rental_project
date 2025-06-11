const pool = require('../config/db'); 


class Booking {
  static async create({ property_id, user_id, check_in_date, check_out_date }) {
    const [result] = await pool.query(
      'INSERT INTO Bookings (property_id, user_id, check_in_date, check_out_date) VALUES (?, ?, ?, ?)',
      [property_id, user_id, check_in_date, check_out_date]
    );
    return result.insertId;
  }

  static async findAll() {
    const [rows] = await pool.query(`
      SELECT b.*, p.name as property_name, u.name as user_name 
      FROM Bookings b
      JOIN Properties p ON b.property_id = p.property_id
      JOIN Users u ON b.user_id = u.user_id
    `);
    return rows;
  }

  static async findById(booking_id) {
    const [rows] = await pool.query(`
      SELECT b.*, p.name as property_name, u.name as user_name 
      FROM Bookings b
      JOIN Properties p ON b.property_id = p.property_id
      JOIN Users u ON b.user_id = u.user_id
      WHERE b.booking_id = ?
    `, [booking_id]);
    return rows[0];
  }

  static async findByUser(user_id) {
    const [rows] = await pool.query(`
      SELECT b.*, p.name as property_name 
      FROM Bookings b
      JOIN Properties p ON b.property_id = p.property_id
      WHERE b.user_id = ?
    `, [user_id]);
    return rows;
  }

  static async update(booking_id, { property_id, user_id, check_in_date, check_out_date }) {
    const [result] = await pool.query(
      'UPDATE Bookings SET property_id = ?, user_id = ?, check_in_date = ?, check_out_date = ? WHERE booking_id = ?',
      [property_id, user_id, check_in_date, check_out_date, booking_id]
    );
    return result.affectedRows;
  }

  static async delete(booking_id) {
    const [result] = await pool.query('DELETE FROM Bookings WHERE booking_id = ?', [booking_id]);
    return result.affectedRows;
  }
}

module.exports = Booking;