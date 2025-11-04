import 'package:cloud_firestore/cloud_firestore.dart';

/// Dữ liệu mẫu các sản phẩm
final List<Map<String, dynamic>> sampleProducts = [
  {
    "imageUrl": "assets/food1.jpeg",
    "name": "Há cảo tôm thịt",
    "description":
        "Há cảo nhân tôm thịt thơm ngon, được hấp chín mềm với lớp vỏ mỏng trong suốt, dùng kèm nước tương gừng.",
    "price": "35000",
    "rating": "4.5",
    "quantity": "1"
  },
  {
    "imageUrl": "assets/food2.jpeg",
    "name": "Bánh taco Mexico",
    "description":
        "Taco truyền thống nhân thịt bò, gà và rau củ tươi, phủ sốt salsa cay nhẹ — lựa chọn hoàn hảo cho bữa ăn nhanh.",
    "price": "60000",
    "rating": "4.6",
    "quantity": "1"
  },
  {
    "imageUrl": "assets/food3.jpeg",
    "name": "Burger bò phô mai",
    "description":
        "Burger nhân bò nướng, thêm lát phô mai tan chảy, rau tươi và sốt mayonnaise đậm đà, kèm khoai tây chiên giòn.",
    "price": "85000",
    "rating": "4.7",
    "quantity": "1"
  },
  {
    "imageUrl": "assets/food4.jpeg",
    "name": "Salad rau củ tươi",
    "description":
        "Salad mix gồm xà lách, cà chua bi, cà rốt, bắp ngọt, trộn cùng sốt mè rang, mang lại cảm giác thanh mát dễ chịu.",
    "price": "45000",
    "rating": "4.4",
    "quantity": "1"
  },
  {
    "imageUrl": "assets/food5.jpeg",
    "name": "Pizza pepperoni",
    "description":
        "Pizza đế mỏng giòn, phủ xúc xích pepperoni, phô mai mozzarella và sốt cà chua Ý đặc trưng.",
    "price": "120000",
    "rating": "4.8",
    "quantity": "1"
  },
  {
    "imageUrl": "assets/food6.jpeg",
    "name": "Salad măng tây phô mai",
    "description":
        "Món salad măng tây trộn phô mai parmesan và hạt dẻ, giàu dinh dưỡng và hương vị tự nhiên.",
    "price": "70000",
    "rating": "4.5",
    "quantity": "1"
  },
  {
    "imageUrl": "assets/food7.jpeg",
    "name": "Salad Caesar gà nướng",
    "description":
        "Xà lách giòn trộn sốt Caesar béo nhẹ, kèm gà nướng, phô mai và bánh mì giòn rụm.",
    "price": "75000",
    "rating": "4.7",
    "quantity": "1"
  },
  {
    "imageUrl": "assets/food8.jpeg",
    "name": "Pizza phô mai đặc biệt",
    "description":
        "Pizza phô mai tan chảy đậm đà với lớp vỏ giòn, dùng kèm cà chua bi và lá thơm tươi.",
    "price": "110000",
    "rating": "4.6",
    "quantity": "1"
  },
  {
    "imageUrl": "assets/food9.jpeg",
    "name": "Pizza bốn mùa",
    "description":
        "Pizza với bốn phần topping đặc biệt: xúc xích, nấm, phô mai và ớt chuông – mỗi miếng là một hương vị khác nhau.",
    "price": "130000",
    "rating": "4.8",
    "quantity": "1"
  },
  {
    "imageUrl": "assets/food10.jpeg",
    "name": "Bánh tiramisu Ý",
    "description":
        "Bánh tiramisu mềm mịn, hòa quyện hương cà phê espresso và kem mascarpone, kết thúc bữa ăn trọn vị.",
    "price": "55000",
    "rating": "4.6",
    "quantity": "1"
  }
];

/// Hàm upload dữ liệu mẫu lên Firestore
Future<void> uploadSampleProducts() async {
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  for (final product in sampleProducts) {
    await productsRef.add(product);
  }

  print("✅ Đã upload ${sampleProducts.length} sản phẩm vào Firestore!");
}
