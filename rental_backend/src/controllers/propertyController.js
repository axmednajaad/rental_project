const Property = require('../models/Property');

exports.createProperty = async (req, res) => {
  try {
    const propertyId = await Property.create(req.body);
    res.status(201).json({ id: propertyId, ...req.body });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getAllProperties = async (req, res) => {
  try {
    const properties = await Property.findAll();
    res.json(properties);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getPropertyById = async (req, res) => {
  try {
    const property = await Property.findById(req.params.id);
    if (!property) {
      return res.status(404).json({ message: 'Property not found' });
    }
    res.json(property);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.updateProperty = async (req, res) => {
  try {
    const affectedRows = await Property.update(req.params.id, req.body);
    if (affectedRows === 0) {
      return res.status(404).json({ message: 'Property not found' });
    }
    res.json({ message: 'Property updated successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deleteProperty = async (req, res) => {
  try {
    const affectedRows = await Property.delete(req.params.id);
    if (affectedRows === 0) {
      return res.status(404).json({ message: 'Property not found' });
    }
    res.json({ message: 'Property deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};