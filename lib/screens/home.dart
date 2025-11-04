import 'package:flutter/material.dart';
import 'package:Flutter_Project_Sori/screens/categories.dart';
import 'package:Flutter_Project_Sori/screens/product_detail.dart';
import 'package:Flutter_Project_Sori/screens/trending.dart';
import 'package:Flutter_Project_Sori/util/categories.dart';
import 'package:Flutter_Project_Sori/util/friends.dart';
// import 'package:Flutter_Project_Sori/util/products.dart';
import 'package:Flutter_Project_Sori/widgets/category_item.dart';
import 'package:Flutter_Project_Sori/widgets/search_card.dart';
import 'package:Flutter_Project_Sori/widgets/slide_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: ListView(
            children: <Widget>[
              buildSearchBar(context),
              const SizedBox(height: 20.0),
              buildProductRow('Trending products', context),
              const SizedBox(height: 10.0),
              buildProductList(context),
              const SizedBox(height: 10.0),
              buildCategoryRow('Category', context),
              const SizedBox(height: 10.0),
              buildCategoryList(context),
              const SizedBox(height: 20.0),
              buildCategoryRow('Friends', context),
              const SizedBox(height: 10.0),
              buildFriendsList(),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- product ----------------
  Widget buildProductRow(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Trending()),
            );
          },
          child: Text(
            "See all (9)",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  /// ---------------- CATEGORY ----------------
  Widget buildCategoryRow(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Categories()),
            );
          },
          child: Text(
            "See all (9)",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  /// ---------------- SEARCH BAR ----------------
  Widget buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: SearchCard(),
    );
  }

  /// ---------------- CATEGORY LIST ----------------
  Widget buildCategoryList(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 6,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return CategoryItem(cat: cat);
        },
      ),
    );
  }

  Widget buildProductList(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.4,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products') // 🔹 Firestore collection
            .snapshots(),
        builder: (context, snapshot) {
          // 🌀 Trạng thái loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ⚠️ Lỗi kết nối
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          // ❗ Không có dữ liệu
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Chưa có sản phẩm nào!"));
          }

          // ✅ Có dữ liệu Firestore
          final products = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
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
    );
  }

  /// ---------------- FRIENDS ----------------
  Widget buildFriendsList() {
    return SizedBox(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final img = friends[index];
          return Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(img),
              radius: 25.0,
            ),
          );
        },
      ),
    );
  }
}
