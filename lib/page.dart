import 'package:flutter/material.dart';
import 'pdf_generator.dart';
import 'package:provider/provider.dart';
import 'services/data_service.dart';

class PageMain extends StatefulWidget {
  final Text title;
  const PageMain({super.key, required this.title});

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  // Add categories data
  final Map<String, List<Map<String, dynamic>>> menuCategories = {
    'Burger': [
      {
        'name': 'Original Burger',
        'price': 5.99,
        'image':
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
      },
      {
        'name': 'Double Burger',
        'price': 10.99,
        'image':
            'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=500',
      },
      {
        'name': 'Cheese Burger',
        'price': 6.99,
        'image':
            'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=500',
      },
      {
        'name': 'Special Black Burger',
        'price': 12.99,
        'image':
            'https://images.unsplash.com/photo-1582196016295-f8c8bd4b3a99?w=500',
      },
    ],
    'Noodles': [
      {
        'name': 'Ramen',
        'price': 8.99,
        'image':
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500',
      },
      {
        'name': 'Udon',
        'price': 9.99,
        'image':
            'https://images.unsplash.com/photo-1618841557871-b4664fbf0cb3?w=500',
      },
      {
        'name': 'Pad Thai',
        'price': 7.99,
        'image':
            'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=500',
      },
    ],
    'Drinks': [
      {
        'name': 'Iced Coffee',
        'price': 3.99,
        'image':
            'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=500',
      },
      {
        'name': 'Smoothie',
        'price': 4.99,
        'image':
            'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=500',
      },
      {
        'name': 'Lemonade',
        'price': 2.99,
        'image':
            'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=500',
      },
    ],
    'Desserts': [
      {
        'name': 'Cheesecake',
        'price': 6.99,
        'image':
            'https://images.unsplash.com/photo-1524351199678-941a58a3df50?w=500',
      },
      {
        'name': 'Ice Cream',
        'price': 4.99,
        'image':
            'https://images.unsplash.com/photo-1488900128323-21503983a07e?w=500',
      },
      {
        'name': 'Chocolate Cake',
        'price': 5.99,
        'image':
            'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500',
      },
    ],
  };

  String selectedCategory = 'Burger'; // Track selected category

  // Add these new variables
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false;

  // Add these variables for order management
  List<Map<String, dynamic>> orderItems = [];
  double get subtotal => orderItems.fold(
        0,
        (sum, item) => sum + (item['price'] * item['quantity']),
      );
  double get tax => subtotal * 0.1; // 10% tax
  double get total => subtotal + tax;

  // Add this method to filter menu items
  void _handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults.clear();
      });
      return;
    }

    final results =
        menuCategories.values.expand((items) => items).where((item) {
      final name = item['name'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      isSearching = true;
      searchResults = results;
    });
  }

  // Add this method to handle adding items to order
  void _addToOrder(Map<String, dynamic> menuItem) {
    setState(() {
      final existingItemIndex = orderItems.indexWhere(
        (item) => item['name'] == menuItem['name'],
      );

      if (existingItemIndex >= 0) {
        orderItems[existingItemIndex]['quantity']++;
      } else {
        orderItems.add({
          ...menuItem,
          'quantity': 1,
        });
      }
    });
  }

  // Add method to process the order
  void _processOrder() {
    if (orderItems.isEmpty) return;

    final dataService = Provider.of<DataService>(context, listen: false);
    dataService.processOrder({
      'items': List<Map<String, dynamic>>.from(orderItems),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'tableNumber': 'Table 1', // You might want to make this dynamic
    });

    // Clear the order
    setState(() {
      orderItems.clear();
    });
  }

  // Add method to remove items from order
  void _removeFromOrder(int index) {
    setState(() {
      if (orderItems[index]['quantity'] > 1) {
        orderItems[index]['quantity']--;
      } else {
        orderItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (context, dataService, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1E1E1E),
          body: Row(
            children: [
              // Main Content (75% width)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.deepOrange,
                            child: Icon(Icons.restaurant_menu,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lorem Restaurant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '30 September 2022',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: SearchBar(
                                controller: _searchController,
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.grey[900]),
                                hintText: 'Search menu here...',
                                hintStyle: WidgetStateProperty.all(
                                    TextStyle(color: Colors.grey[600])),
                                leading:
                                    Icon(Icons.search, color: Colors.grey[600]),
                                onChanged: _handleSearch,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Order',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Table 8',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Category Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          for (String category in menuCategories.keys)
                            _buildCategoryButton(
                              category,
                              _getCategoryIcon(category),
                              category == selectedCategory,
                            ),
                        ],
                      ),
                    ),
                    // Menu Grid
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: isSearching
                            ? searchResults.length
                            : dataService
                                    .menuCategories[selectedCategory]?.length ??
                                0,
                        itemBuilder: (context, index) {
                          final item = isSearching
                              ? searchResults[index]
                              : dataService
                                  .menuCategories[selectedCategory]![index];
                          return _buildMenuItem(item);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Order Panel (25% width)
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  border: Border(
                    left: BorderSide(color: Colors.grey[800]!, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    // Order Items List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orderItems.length,
                        itemBuilder: (context, index) => _buildOrderItem(index),
                      ),
                    ),
                    // Order Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        border: Border(
                          top: BorderSide(color: Colors.grey[800]!, width: 1),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildOrderSummaryRow(
                            'Sub Total',
                            '\$${subtotal.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 8),
                          _buildOrderSummaryRow(
                            'Tax',
                            '\$${tax.toStringAsFixed(2)}',
                          ),
                          const SizedBox(height: 8),
                          _buildOrderSummaryRow(
                            'Total',
                            '\$${total.toStringAsFixed(2)}',
                            isTotal: true,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                padding: const EdgeInsets.all(16),
                              ),
                              onPressed: orderItems.isEmpty
                                  ? null
                                  : () async {
                                      await PdfGenerator.generateAndPrintBill(
                                        orderItems: orderItems,
                                        subtotal: subtotal,
                                        tax: tax,
                                        total: total,
                                        tableNumber: 'Table 1',
                                      );
                                      _processOrder(); // Process the order after printing
                                    },
                              child: const Text(
                                'Print Bills',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Burger':
        return Icons.lunch_dining;
      case 'Noodles':
        return Icons.ramen_dining;
      case 'Drinks':
        return Icons.local_drink;
      case 'Desserts':
        return Icons.cake;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildCategoryButton(String text, IconData icon, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        // Make button clickable
        onTap: () {
          setState(() {
            selectedCategory = text;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepOrange : Colors.grey[900],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return InkWell(
      onTap: () => _addToOrder(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  item['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item['price'].toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.deepOrange[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(int index) {
    final item = orderItems[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${item['price'].toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.deepOrange[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline,
                    color: Colors.white),
                onPressed: () => _removeFromOrder(index),
                iconSize: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${item['quantity']}×',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                onPressed: () => _addToOrder(item),
                iconSize: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryRow(String label, String value,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
