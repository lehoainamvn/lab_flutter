import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_contact_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        leading: const Icon(Icons.menu),
      ),
      body: Column(
        children: [
          // Thanh Search
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          
          // Danh sách Contact lấy từ Firestore
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('contacts').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange[100],
                        child: Text(data['name'][0].toString().toLowerCase()),
                      ),
                      title: Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(data['phone']),
                      trailing: const Icon(Icons.phone),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Nút thêm mới
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[100],
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddContactPage())),
        child: const Icon(Icons.person_add_alt_1, color: Colors.brown),
      ),
    );
  }
}