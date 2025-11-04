import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;
  bool _isEditing = false;
  String _profileId = '';
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Tải thông tin profile từ Firebase
  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Lấy profile đầu tiên (hoặc bạn có thể dùng user ID)
      final querySnapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();

        setState(() {
          _profileId = doc.id;
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _addressController.text = data['address'] ?? '';
          _bioController.text = data['bio'] ?? '';
          _avatarUrl = data['avatarUrl'] ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Lưu hoặc cập nhật profile
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final data = {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'bio': _bioController.text.trim(),
          'avatarUrl': _avatarUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (_profileId.isEmpty) {
          // Tạo mới profile
          data['createdAt'] = FieldValue.serverTimestamp();
          final docRef =
              await FirebaseFirestore.instance.collection('profiles').add(data);
          _profileId = docRef.id;
        } else {
          // Cập nhật profile
          await FirebaseFirestore.instance
              .collection('profiles')
              .doc(_profileId)
              .update(data);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lưu thông tin thành công!'),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {
            _isEditing = false;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Tin Cá Nhân'),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              tooltip: 'Chỉnh sửa',
            ),
        ],
      ),
      body: _isLoading && _nameController.text.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header với avatar
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue, Colors.blue.shade300],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Avatar
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: _avatarUrl.isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        _avatarUrl,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stack) {
                                          return const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.blue,
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.blue,
                                    ),
                            ),
                            if (_isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _showAvatarDialog();
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _nameController.text.isEmpty
                              ? 'Người dùng mới'
                              : _nameController.text,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _emailController.text.isEmpty
                              ? 'email@example.com'
                              : _emailController.text,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Form thông tin
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Tên
                          TextFormField(
                            controller: _nameController,
                            enabled: _isEditing,
                            decoration: InputDecoration(
                              labelText: 'Họ và tên',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: !_isEditing,
                              fillColor: _isEditing ? null : Colors.grey[100],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập tên';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Email
                          TextFormField(
                            controller: _emailController,
                            enabled: _isEditing,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: !_isEditing,
                              fillColor: _isEditing ? null : Colors.grey[100],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập email';
                              }
                              if (!value.contains('@')) {
                                return 'Email không hợp lệ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Số điện thoại
                          TextFormField(
                            controller: _phoneController,
                            enabled: _isEditing,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Số điện thoại',
                              prefixIcon: const Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: !_isEditing,
                              fillColor: _isEditing ? null : Colors.grey[100],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập số điện thoại';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Địa chỉ
                          TextFormField(
                            controller: _addressController,
                            enabled: _isEditing,
                            maxLines: 2,
                            decoration: InputDecoration(
                              labelText: 'Địa chỉ',
                              prefixIcon: const Icon(Icons.location_on),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: !_isEditing,
                              fillColor: _isEditing ? null : Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Giới thiệu
                          TextFormField(
                            controller: _bioController,
                            enabled: _isEditing,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Giới thiệu bản thân',
                              prefixIcon: const Icon(Icons.info),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: !_isEditing,
                              fillColor: _isEditing ? null : Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Nút lưu/hủy
                          if (_isEditing)
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            setState(() {
                                              _isEditing = false;
                                            });
                                            _loadProfile();
                                          },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text('Hủy'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _saveProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
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
                                            'Lưu',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),

                          // Các thông tin khác
                          if (!_isEditing) ...[
                            const Divider(height: 32),
                            _buildInfoCard(
                              icon: Icons.shopping_bag,
                              title: 'Đơn hàng',
                              subtitle: 'Xem lịch sử đơn hàng',
                              onTap: () {},
                            ),
                            _buildInfoCard(
                              icon: Icons.favorite,
                              title: 'Yêu thích',
                              subtitle: 'Danh sách sản phẩm yêu thích',
                              onTap: () {},
                            ),
                            _buildInfoCard(
                              icon: Icons.settings,
                              title: 'Cài đặt',
                              subtitle: 'Cài đặt ứng dụng',
                              onTap: () {},
                            ),
                            _buildInfoCard(
                              icon: Icons.logout,
                              title: 'Đăng xuất',
                              subtitle: 'Đăng xuất khỏi tài khoản',
                              onTap: () {},
                              color: Colors.red,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.blue),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showAvatarDialog() {
    final controller = TextEditingController(text: _avatarUrl);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thay đổi ảnh đại diện'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'URL ảnh đại diện',
            hintText: 'Nhập URL hình ảnh',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _avatarUrl = controller.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}
