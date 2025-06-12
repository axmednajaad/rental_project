import 'package:flutter/material.dart';
import '../../models/property.dart';
import '../../services/api_service.dart';

class AddEditPropertyScreen extends StatefulWidget {
  final Property? property;

  const AddEditPropertyScreen({
    super.key,
    this.property,
  });

  @override
  State<AddEditPropertyScreen> createState() => _AddEditPropertyScreenState();
}

class _AddEditPropertyScreenState extends State<AddEditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _sizeController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedType = 'Apartment';
  bool _isLoading = false;

  final List<String> _propertyTypes = [
    'Apartment',
    'House',
    'Condo',
    'Studio',
    'Villa',
    'Townhouse',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      _populateFields();
    }
  }

  void _populateFields() {
    final property = widget.property!;
    _nameController.text = property.name;
    _descriptionController.text = property.description;
    _locationController.text = property.location;
    _sizeController.text = property.size;
    _priceController.text = property.price.toString();
    _selectedType = property.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _sizeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveProperty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final property = Property(
        propertyId: widget.property?.propertyId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType,
        size: _sizeController.text.trim(),
        location: _locationController.text.trim(),
        price: double.parse(_priceController.text.trim()),
      );

      if (widget.property == null) {
        // Create new property
        await ApiService.createProperty(property);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Property created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Update existing property
        await ApiService.updateProperty(widget.property!.propertyId!, property);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Property updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save property: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.property != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Property' : 'Add Property'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProperty,
            child: Text(
              'Save',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Property Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Property Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter property name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Property Type
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Property Type *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _propertyTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Size
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(
                  labelText: 'Size *',
                  hintText: 'e.g., 2 BHK, 1200 sq ft',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.square_foot),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter size';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Rent *',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter monthly rent';
                  }
                  final price = double.tryParse(value.trim());
                  if (price == null || price <= 0) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe the property features, amenities, etc.',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProperty,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        isEditing ? 'Update Property' : 'Create Property',
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
              const SizedBox(height: 16),
              // Cancel Button
              OutlinedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
