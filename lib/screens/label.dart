import 'package:flutter/material.dart';
import '../services/fireStore_upload.dart';

class Label extends StatelessWidget {
  const Label({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Label")),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () async {
      //       await uploadSampleProducts();
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(
      //             content: Text("Đã upload dữ liệu mẫu thành công!")),
      //       );
      //     },
      //     child: const Text("Upload dữ liệu mẫu"),
      //   ),
      // ),
    );
  }
}
