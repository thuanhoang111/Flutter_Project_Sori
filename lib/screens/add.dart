import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _ratingController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _ratingController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Thêm sản phẩm vào Firestore
        await FirebaseFirestore.instance.collection('products').add({
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'price': _priceController.text.trim(),
          'rating': _ratingController.text.trim(),
          'quantity': _quantityController.text.trim(),
          'imageUrl': _imageUrlController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          // Hiển thị thông báo thành công
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thêm sản phẩm thành công!'),
              backgroundColor: Colors.green,
            ),
          );

          // Reset form
          _formKey.currentState!.reset();
          _nameController.clear();
          _descriptionController.clear();
          _priceController.clear();
          _ratingController.clear();
          _quantityController.text = '1';
          _categoryController.clear();
          _imageUrlController.clear();
        }
      } catch (e) {
        if (mounted) {
          // Hiển thị thông báo lỗi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${e.toString()}'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Sản Phẩm'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tên sản phẩm
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên sản phẩm',
                    hintText: 'Nhập tên sản phẩm',
                    prefixIcon: const Icon(Icons.shopping_bag),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên sản phẩm';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Mô tả
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Mô tả',
                    hintText: 'Nhập mô tả sản phẩm',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Giá
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Giá',
                    hintText: 'Nhập giá sản phẩm (VD: 35000)',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập giá';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Giá không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Rating
                TextFormField(
                  controller: _ratingController,
                  decoration: InputDecoration(
                    labelText: 'Đánh giá',
                    hintText: 'Nhập đánh giá (VD: 4.5)',
                    prefixIcon: const Icon(Icons.star),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập đánh giá';
                    }
                    final rating = double.tryParse(value);
                    if (rating == null) {
                      return 'Đánh giá không hợp lệ';
                    }
                    if (rating < 0 || rating > 5) {
                      return 'Đánh giá phải từ 0 đến 5';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Số lượng
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Số lượng',
                    hintText: 'Nhập số lượng',
                    prefixIcon: const Icon(Icons.inventory),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số lượng';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Số lượng không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // URL hình ảnh
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'URL Hình ảnh',
                    hintText: 'Nhập URL hình ảnh',
                    prefixIcon: const Icon(Icons.image),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập URL hình ảnh';
                    }
                    if (!value.startsWith('http')) {
                      return 'URL không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Nút thêm
                ElevatedButton(
                  onPressed: _isLoading ? null : _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Thêm Sản Phẩm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 16),

                // Hiển thị preview hình ảnh nếu có URL
                if (_imageUrlController.text.isNotEmpty &&
                    _imageUrlController.text.startsWith('http'))
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
