import 'package:flutter/material.dart';

enum OrderStatus { pending, completed, cancelled }

class DataService extends ChangeNotifier {
  // Products data
  final Map<String, List<Map<String, dynamic>>> _menuCategories = {
    'Burger': [
      {
        'name': 'Original Burger',
        'price': 5.99,
        'stock': 50,
        'image':
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
        'category': 'Burger',
      },
      // Add more initial burgers...
    ],
    'Noodles': [
      {
        'name': 'Ramen',
        'price': 8.99,
        'stock': 30,
        'image':
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=500',
        'category': 'Noodles',
      },
      // Add more initial noodles...
    ],
    'Drinks': [],
    'Desserts': [],
  };

  // Add inventory tracking
  final Map<String, Map<String, dynamic>> _inventory = {
    'Ingredients': {
      'Beef Patty': {'quantity': 100, 'unit': 'pcs', 'minStock': 20},
      'Chicken Breast': {'quantity': 80, 'unit': 'pcs', 'minStock': 15},
      'Burger Buns': {'quantity': 150, 'unit': 'pcs', 'minStock': 30},
      'Tomatoes': {'quantity': 50, 'unit': 'kg', 'minStock': 10},
      'Lettuce': {'quantity': 30, 'unit': 'kg', 'minStock': 5},
      'Cheese Slices': {'quantity': 200, 'unit': 'pcs', 'minStock': 40},
    },
    'Sauces': {
      'Ketchup': {'quantity': 20, 'unit': 'L', 'minStock': 5},
      'Mayo': {'quantity': 15, 'unit': 'L', 'minStock': 4},
      'BBQ Sauce': {'quantity': 10, 'unit': 'L', 'minStock': 3},
    }
  };

  // Orders history
  final List<Map<String, dynamic>> _orders = [];
  int _orderSequence = 1;

  // Promo codes
  final List<Map<String, dynamic>> _promoCodes = [];

  // Getters
  Map<String, List<Map<String, dynamic>>> get menuCategories => _menuCategories;
  List<Map<String, dynamic>> get orders => _orders;
  List<Map<String, dynamic>> get promoCodes => _promoCodes;
  Map<String, Map<String, dynamic>> get inventory => _inventory;

  // Add validation methods
  bool isValidProduct(Map<String, dynamic> product) {
    return product.containsKey('name') &&
        product.containsKey('price') &&
        product.containsKey('stock') &&
        product.containsKey('image') &&
        product.containsKey('category');
  }

  // Update addProduct with validation
  void addProduct(Map<String, dynamic> product) {
    if (!isValidProduct(product)) return;
    _menuCategories[product['category']]?.add(product);
    notifyListeners();
  }

  void updateProduct(
      String category, int index, Map<String, dynamic> newProduct) {
    _menuCategories[category]?[index] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String category, int index) {
    _menuCategories[category]?.removeAt(index);
    notifyListeners();
  }

  // Add method to get formatted date
  String get currentDate {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // Update addOrder to include date
  void addOrder(Map<String, dynamic> order) {
    order['date'] = currentDate;
    _orders.add(order);
    notifyListeners();
  }

  // Promo Methods
  void addPromoCode(Map<String, dynamic> promo) {
    _promoCodes.add(promo);
    notifyListeners();
  }

  void deletePromoCode(int index) {
    _promoCodes.removeAt(index);
    notifyListeners();
  }

  // Add methods for inventory management
  void updateInventory(String category, String item, int quantity) {
    if (_inventory[category]?[item] != null) {
      _inventory[category]![item]['quantity'] = quantity;
      notifyListeners();
    }
  }

  // Add method for order processing
  void processOrder(Map<String, dynamic> order) {
    final orderNumber = 'ORD${_orderSequence.toString().padLeft(4, '0')}';
    order['orderNumber'] = orderNumber;
    order['status'] = OrderStatus.pending;
    order['timestamp'] = DateTime.now();
    _orders.add(order);
    _orderSequence++;
    notifyListeners();
  }

  // Add methods for reports
  Map<String, dynamic> getFinancialReport({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final filteredOrders = _orders.where((order) {
      final orderDate = order['timestamp'] as DateTime;
      return orderDate.isAfter(startDate) && orderDate.isBefore(endDate);
    }).toList();

    final totalSales = filteredOrders.fold<double>(
      0,
      (sum, order) => sum + (order['total'] as double),
    );

    final itemsSold = <String, int>{};
    for (final order in filteredOrders) {
      for (final item in order['items']) {
        itemsSold[item['name']] =
            ((itemsSold[item['name']] ?? 0) + (item['quantity'] as num))
                .toInt();
      }
    }

    return {
      'totalSales': totalSales,
      'orderCount': filteredOrders.length,
      'itemsSold': itemsSold,
      'averageOrderValue': totalSales / filteredOrders.length,
    };
  }

  // Add method for low stock alerts
  List<Map<String, dynamic>> getLowStockAlerts() {
    final alerts = <Map<String, dynamic>>[];

    _inventory.forEach((category, items) {
      items.forEach((item, data) {
        if (data['quantity'] <= data['minStock']) {
          alerts.add({
            'category': category,
            'item': item,
            'quantity': data['quantity'],
            'minStock': data['minStock'],
            'unit': data['unit'],
          });
        }
      });
    });

    return alerts;
  }
}
