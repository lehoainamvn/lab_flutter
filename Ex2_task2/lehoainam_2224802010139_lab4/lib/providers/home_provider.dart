import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_constants.dart';

class HomeProvider {
  final FirebaseFirestore firebaseFirestore;

  HomeProvider({required this.firebaseFirestore});

  Future<void> updateDataFirestore(String collectionPath, String path, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore.collection(collectionPath).doc(path).update(dataUpdate);
  }

  Stream<QuerySnapshot> getStreamFireStore(String pathCollection, int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      return firebaseFirestore
          .collection(pathCollection)
          .limit(limit)
          .where(FirestoreConstants.nickname, isEqualTo: textSearch)
          .snapshots();
    } else {
      return firebaseFirestore.collection(pathCollection).limit(limit).snapshots();
    }
  }

  Future<void> addSampleUsers() async {
    List<Map<String, String>> samples = [
      {
        FirestoreConstants.id: 'sample1',
        FirestoreConstants.nickname: 'ChiPu',
        FirestoreConstants.aboutMe: 'Shopping',
        FirestoreConstants.photoUrl: 'https://i.pravatar.cc/150?u=sample1',
      },
      {
        FirestoreConstants.id: 'sample2',
        FirestoreConstants.nickname: 'SonTung MTP',
        FirestoreConstants.aboutMe: 'Like travel',
        FirestoreConstants.photoUrl: 'https://i.pravatar.cc/150?u=sample2',
      },
      {
        FirestoreConstants.id: 'sample3',
        FirestoreConstants.nickname: 'Dan Truong',
        FirestoreConstants.aboutMe: 'Sing my song',
        FirestoreConstants.photoUrl: 'https://i.pravatar.cc/150?u=sample3',
      },
    ];

    for (var user in samples) {
      await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(user[FirestoreConstants.id])
          .set(user);
    }
  }
}
