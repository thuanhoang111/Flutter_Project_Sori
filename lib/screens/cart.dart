import 'package:Flutter_Project_Sori/util/const.dart';
import 'package:flutter/material.dart';
import 'package:Flutter_Project_Sori/services/notification_service.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> cart;
  final formatter = NumberFormat('#,###', 'vi_VN');

  @override
  void initState() {
    super.initState();
    cart = List<Map<String, dynamic>>.from(widget.cartItems);
  }

  void increaseQuantity(int index) {
    setState(() {
      int qty = int.parse(cart[index]["quantity"]);
      cart[index]["quantity"] = (qty + 1).toString();
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      int qty = int.parse(cart[index]["quantity"]);
      if (qty > 1) {
        cart[index]["quantity"] = (qty - 1).toString();
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cart.removeAt(index);
    });
  }

  void removeAllItem() {
    setState(() {
      cart.clear();
    });
  }

  int get totalPrice {
    int total = 0;
    for (var item in cart) {
      int price = int.parse(item["price"]);
      int qty = int.parse(item["quantity"]);
      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text(
                "Giỏ hàng trống!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : SafeArea(
              child: Column(
                children: [
                  // 🔹 Danh sách sản phẩm (có thể cuộn)
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: isNetworkImage(item["imageUrl"])
                                  ? Image.network(
                                      item["imageUrl"],
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    )
                                  : Image.asset(
                                      item["imageUrl"],
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    ),
                            ),
                            title: Text(
                              item["name"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "${formatter.format(int.parse(item["price"]))} đ",
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                            // 🔹 Cột chứa tăng/giảm và xóa
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.remove_circle_outline),
                                      onPressed: () => decreaseQuantity(index),
                                    ),
                                    Text(
                                      item["quantity"].toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      icon:
                                          const Icon(Icons.add_circle_outline),
                                      onPressed: () => increaseQuantity(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      onPressed: () => removeItem(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 🔹 Tổng tiền
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng cộng:",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${formatter.format(totalPrice)} đ",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Nút thanh toán (đặt dưới SafeArea để không bị tràn)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: SafeArea(
                      top: false,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.payment, color: Colors.white),
                        label: const Text(
                          "Thanh toán ngay",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          removeAllItem();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Thanh toán thành công 🎉")),
                          );
                          // 🟢 Gọi hiển thị thông báo thanh toán thành công
                          NotificationService()
                              .showPaymentSuccessNotification();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
