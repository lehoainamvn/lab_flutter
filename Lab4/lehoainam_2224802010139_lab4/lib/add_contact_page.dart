import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});
  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  Future<void> createContact() async {
    // Kiểm tra dữ liệu trống
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    try {
      // Thêm dữ liệu vào bộ sưu tập 'contacts' trên Firestore
      await FirebaseFirestore.instance.collection('contacts').add({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      });
      
      // Quay lại trang trước ngay lập tức
      if (mounted) {
        Navigator.pop(context, true); // Trả về true để báo hiệu đã thêm thành công
        
        // Hiển thị thông báo sau khi đã pop
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact added successfully!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contact')),
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
            
            // Nút Create
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: createContact,
                child: const Text('Create', style: TextStyle(color: Colors.brown, fontSize: 18)),
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