import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditContactPage extends StatefulWidget {
  final String docId;
  final String name;
  final String phone;
  final String email;

  const EditContactPage({
    super.key,
    required this.docId,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> updateContact() async {
    // Kiểm tra dữ liệu trống
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    try {
      // Cập nhật dữ liệu trong Firestore
      await FirebaseFirestore.instance
          .collection('contacts')
          .doc(widget.docId)
          .update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      });

      // Quay lại trang trước ngay lập tức
      if (mounted) {
        Navigator.pop(context, true); // Trả về true để báo hiệu đã cập nhật thành công
        
        // Hiển thị thông báo sau khi đã pop
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact updated successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Hiển thị thông báo lỗi nếu có
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> deleteContact() async {
    // Hiển thị dialog xác nhận xóa
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Xóa contact từ Firestore
        await FirebaseFirestore.instance
            .collection('contacts')
            .doc(widget.docId)
            .delete();

        if (mounted) {
          Navigator.pop(context, true); // Trả về true để báo hiệu đã xóa thành công
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contact deleted successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: deleteContact,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(_nameController, 'Name'),
            const SizedBox(height: 15),
            _buildTextField(_phoneController, 'Phone'),
            const SizedBox(height: 15),
            _buildTextField(_emailController, 'Email'),
            const SizedBox(height: 30),

            // Nút Update
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[50],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: updateContact,
                child: const Text('Update',
                    style: TextStyle(color: Colors.brown, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
