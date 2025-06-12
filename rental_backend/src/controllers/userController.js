const User = require('../models/User');

exports.createUser = async (req, res) => {
  try {
    console.log('Creating user with data:', req.body);
    // check if the user with this email already exists
    const existingUser = await User.findByEmail(req.body.email);
    if (existingUser) {
      return res.status(400).json({ message: 'User with this email already exists' });
    }

    const { password, ...userData } = req.body;

    // If password is provided, include it; otherwise, set a default
    const userDataWithPassword = {
      ...userData,
      password: password || '123' // You might want to handle this differently
    };

    const userId = await User.create(userDataWithPassword);

    // Return user data without password
    res.status(201).json({ id: userId, ...userData });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.findAll();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.updateUser = async (req, res) => {
  try {
    const affectedRows = await User.update(req.params.id, req.body);
    if (affectedRows === 0) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json({ message: 'User updated successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deleteUser = async (req, res) => {
  try {
    const affectedRows = await User.delete(req.params.id);
    if (affectedRows === 0) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json({ message: 'User deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};