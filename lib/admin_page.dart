import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/data_service.dart';
import 'admin_reports_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedCategory = 'Burger';
  final _promoCodeController = TextEditingController();
  final _discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        
         backgroundColor: Colors.grey[900],
        
        actions: const [

          
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 16),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
            ),
            SizedBox(width: 8),
            Text(
              'Hi, Admin',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        ],
         
        ),
          body: Row(
        children: [
          // Navigation Rail
          NavigationRail(
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.grey[900],
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.inventory, color: Colors.white),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history, color: Colors.white),
                label: Text('Orders'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics, color: Colors.white),
                label: Text('Reports'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.local_offer, color: Colors.white),
                label: Text('Promos'),
              ),
            ],
          ),
          // Main Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildProductsPage();
      case 1:
        return _buildOrdersPage();
      case 2:
        return const AdminReportsPage();
      case 3:
        return _buildPromosPage();
      default:
        return const SizedBox();
    }
  }

  Widget _buildProductsPage() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Form
              Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Product',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Product Name'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _priceController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Price'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _stockController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Stock'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _imageUrlController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Image URL'),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      dropdownColor: Colors.grey[850],
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Category'),
                      items: ['Burger', 'Noodles', 'Drinks', 'Desserts']
                          .map((String category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: _addProduct,
                        child: const Text('Add Product'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Product List
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Inventory',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: dataService
                                  .menuCategories[_selectedCategory]?.length ??
                              0,
                          itemBuilder: (context, index) {
                            final item = dataService
                                .menuCategories[_selectedCategory]![index];
                            return _buildProductItem(
                                _selectedCategory, index, item);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductItem(
      String category, int index, Map<String, dynamic> item) {
    return Card(
      color: Colors.grey[850],
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            item['image'],
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item['name'],
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'Stock: ${item['stock']} | Price: \$${item['price'].toStringAsFixed(2)}',
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => _editProduct(category, index, item),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                final dataService =
                    Provider.of<DataService>(context, listen: false);
                dataService.deleteProduct(category, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersPage() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataService.orders.length,
                    itemBuilder: (context, index) {
                      final order = dataService.orders[index];
                      return Card(
                        color: Colors.grey[850],
                        child: ListTile(
                          title: Text(
                            'Order #${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Total: \$${order['total'].toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          trailing: Text(
                            order['date'],
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPromosPage() {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Promo Form
              Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Promo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _promoCodeController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Promo Code'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _discountController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Discount %'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () {
                          if (_promoCodeController.text.isNotEmpty &&
                              _discountController.text.isNotEmpty) {
                            dataService.addPromoCode({
                              'code': _promoCodeController.text,
                              'discount':
                                  double.parse(_discountController.text),
                            });
                            _promoCodeController.clear();
                            _discountController.clear();
                          }
                        },
                        child: const Text('Add Promo'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Promo List
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Promos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: dataService.promoCodes.length,
                          itemBuilder: (context, index) {
                            final promo = dataService.promoCodes[index];
                            return Card(
                              color: Colors.grey[850],
                              child: ListTile(
                                title: Text(
                                  promo['code'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  '${promo['discount']}% off',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      dataService.deletePromoCode(index),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.grey[850],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _addProduct() {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _imageUrlController.text.isEmpty) {
      return;
    }

    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.addProduct({
      'name': _nameController.text,
      'price': double.parse(_priceController.text),
      'stock': int.parse(_stockController.text),
      'image': _imageUrlController.text,
      'category': _selectedCategory,
    });

    // Clear form
    _nameController.clear();
    _priceController.clear();
    _stockController.clear();
    _imageUrlController.clear();
  }

  void _editProduct(String category, int index, Map<String, dynamic> product) {
    _nameController.text = product['name'];
    _priceController.text = product['price'].toString();
    _stockController.text = product['stock'].toString();
    _imageUrlController.text = product['image'];
    _selectedCategory = category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title:
            const Text('Edit Product', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Product Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _priceController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _stockController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Stock'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _imageUrlController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Image URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.deepOrange),
            onPressed: () {
              final dataService =
                  Provider.of<DataService>(context, listen: false);
              dataService.updateProduct(category, index, {
                'name': _nameController.text,
                'price': double.parse(_priceController.text),
                'stock': int.parse(_stockController.text),
                'image': _imageUrlController.text,
                'category': category,
              });
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    _promoCodeController.dispose();
    _discountController.dispose();
    super.dispose();
  }
}
