import 'package:flutter/material.dart';
import 'cart.dart';

class productDetail extends StatefulWidget {
  final Map<String, dynamic> product;

  const productDetail({super.key, required this.product});

  @override
  _productDetailState createState() => _productDetailState();
}

class _productDetailState extends State<productDetail> {
  // ✅ Giỏ hàng tạm trong state
  final List<Map<String, dynamic>> cart = [];

  void addToCart() {
    final existingIndex = cart.indexWhere(
      (item) => item['name'] == widget.product['name'],
    );

    setState(() {
      if (existingIndex >= 0) {
        int qty = int.parse(cart[existingIndex]['quantity']);
        cart[existingIndex]['quantity'] = (qty + 1).toString();
      } else {
        cart.add(Map<String, dynamic>.from(widget.product));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Đã thêm vào giỏ hàng"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: cart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"]),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        actions: [
          // ✅ Nút giỏ hàng ở góc phải
          IconButton(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 26),
                if (cart.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: goToCart,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh
            Container(
              height: 250,
              width: double.infinity,
              child: Image.asset(
                product["imageUrl"],
                fit: BoxFit.cover,
              ),
            ),

            // Nội dung
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product["name"],
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        product["rating"],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product["description"],
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Giá:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${product["price"]} đ",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),

      // ✅ Nút “Thêm vào giỏ hàng” ở dưới cùng
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // nền xanh
              foregroundColor: Colors.white, // chữ trắng
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Thêm vào giỏ hàng",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
