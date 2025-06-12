const bcrypt = require('bcrypt');

async function generateHashes() {
  const saltRounds = 10;
  
  try {
    // Generate hash for admin password: admin123
    const adminHash = await bcrypt.hash('admin123', saltRounds);
    console.log('Admin password hash (password: admin123):');
    console.log(adminHash);
    console.log('');
    
    // Generate hash for user password: user123
    const userHash = await bcrypt.hash('user123', saltRounds);
    console.log('User password hash (password: user123):');
    console.log(userHash);
    console.log('');
    
    // Generate SQL statements
    console.log('SQL INSERT statements:');
    console.log('');
    console.log(`INSERT IGNORE INTO Users (name, email, phone, role, password) VALUES`);
    console.log(`('Admin User', 'admin@rental.com', '+1234567890', 'admin', '${adminHash}'),`);
    console.log(`('John Doe', 'user@rental.com', '+1234567891', 'user', '${userHash}');`);
    console.log('');
    
    console.log('Test credentials:');
    console.log('Admin: admin@rental.com / admin123');
    console.log('User: user@rental.com / user123');
    
  } catch (error) {
    console.error('Error generating hashes:', error);
  }
}

generateHashes();
