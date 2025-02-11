import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageCinemasController extends ChangeNotifier {
  List<Map<String, dynamic>> cinemas = []; // Danh sách rạp từ Firebase
  List<Map<String, dynamic>> filteredCinemas = []; // Danh sách rạp sau khi lọc
  Set<String> selectedCinemas = {}; // Danh sách rạp được chọn

  final TextEditingController searchController = TextEditingController();
  String searchType = 'name'; // Mặc định tìm theo tên

  ManageCinemasController() {
    loadCinemas();
  }

  /// Load danh sách rạp từ Firestore
  Future<void> loadCinemas() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('cinemas').get();

      cinemas = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'region': doc['region'],
          'city': doc['city'],
          'location': doc['location'],
        };
      }).toList();

      filteredCinemas = List.from(cinemas);
      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi khi tải dữ liệu rạp: $e');
    }
  }

  /// Cập nhật kiểu tìm kiếm
  void setSearchType(String type) {
    searchType = type;
    searchCinemas(searchController.text);
    notifyListeners();
  }

  /// Lọc danh sách rạp theo từ khóa tìm kiếm
  void searchCinemas(String query) {
    filteredCinemas = cinemas.where((cinema) {
      final value = cinema[searchType]?.toString().toLowerCase() ?? '';
      return value.contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

  /// Thêm một rạp mới vào Firestore
  Future<void> addCinema(
      String name, String region, String city, String location) async {
    DocumentReference docRef =
    await FirebaseFirestore.instance.collection('cinemas').add({
      'name': name,
      'region': region,
      'city': city,
      'location': location,
    });

    cinemas.add({
      'id': docRef.id,
      'name': name,
      'region': region,
      'city': city,
      'location': location
    });
    filteredCinemas = List.from(cinemas);
    notifyListeners();
  }

  /// Cập nhật thông tin một rạp
  Future<void> updateCinema(
      String id, String name, String region, String city, String location) async {
    await FirebaseFirestore.instance.collection('cinemas').doc(id).update({
      'name': name,
      'region': region,
      'city': city,
      'location': location,
    });

    int index = cinemas.indexWhere((cinema) => cinema['id'] == id);
    if (index != -1) {
      cinemas[index] = {
        'id': id,
        'name': name,
        'region': region,
        'city': city,
        'location': location
      };
      filteredCinemas = List.from(cinemas);
      notifyListeners();
    }
  }

  /// Chọn/Bỏ chọn rạp
  void toggleSelection(String id) {
    if (selectedCinemas.contains(id)) {
      selectedCinemas.remove(id);
    } else {
      selectedCinemas.add(id);
    }
    notifyListeners();
  }

  /// Xóa một rạp duy nhất
  Future<void> deleteCinema(String id) async {
    await FirebaseFirestore.instance.collection('cinemas').doc(id).delete();

    cinemas.removeWhere((cinema) => cinema['id'] == id);
    filteredCinemas.removeWhere((cinema) => cinema['id'] == id);
    selectedCinemas.remove(id);
    notifyListeners();
  }

  /// Xóa nhiều rạp cùng lúc
  Future<void> deleteMultipleCinemas() async {
    for (String id in selectedCinemas) {
      await FirebaseFirestore.instance.collection('cinemas').doc(id).delete();
    }

    cinemas.removeWhere((cinema) => selectedCinemas.contains(cinema['id']));
    filteredCinemas.removeWhere((cinema) => selectedCinemas.contains(cinema['id']));
    selectedCinemas.clear();
    notifyListeners();
  }
}
