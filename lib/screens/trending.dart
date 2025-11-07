import 'package:Flutter_Project_Sori/screens/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Flutter_Project_Sori/widgets/search_card.dart';
import 'package:Flutter_Project_Sori/widgets/slide_item.dart';

class Trending extends StatelessWidget {
  const Trending({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Trending Products"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            SearchCard(),
            const SizedBox(height: 10.0),

            /// 🔥 Dùng StreamBuilder để lấy dữ liệu Firestore
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products') // 🔹 tên collection
                  .snapshots(),
              builder: (context, snapshot) {
                // Trạng thái đang load
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Nếu có lỗi
                if (snapshot.hasError) {
                  return Center(child: Text("Lỗi: ${snapshot.error}"));
                }

                // Nếu không có dữ liệu
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Chưa có sản phẩm nào!"),
                  );
                }

                // Lấy danh sách documents
                final products = snapshot.data!.docs;

                return ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final data = products[index].data() as Map<String, dynamic>;

return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => productDetail(product: data),
                      ),
                    );
                  },
                  child: SlideItem(
                    imageUrl: data["imageUrl"] ?? "",
                    name: data["name"] ?? "Không có tên",
                    rating: data["rating"] ?? "0.0",
                    description: data["description"] ?? "",
                    price: data["price"] ?? "0",
                  ),
                ),
              );
                  },
                );
              },
            ),

            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
