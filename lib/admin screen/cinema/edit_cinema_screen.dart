import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'manage_cinemas_controller.dart';

class EditCinemaScreen extends StatelessWidget {
  final Map<String, dynamic> cinema;

  const EditCinemaScreen({super.key, required this.cinema});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: cinema['name']);
    final TextEditingController regionController = TextEditingController(text: cinema['region']);
    final TextEditingController cityController = TextEditingController(text: cinema['city']);
    final TextEditingController locationController = TextEditingController(text: cinema['location']);

    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa Rạp')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Tên rạp')),
            TextField(controller: regionController, decoration: const InputDecoration(labelText: 'Miền')),
            TextField(controller: cityController, decoration: const InputDecoration(labelText: 'Thành phố')),
            TextField(controller: locationController, decoration: const InputDecoration(labelText: 'Địa chỉ')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<ManageCinemasController>(context, listen: false)
                    .updateCinema(cinema['id'], nameController.text, regionController.text, cityController.text, locationController.text);
                Navigator.pop(context);
              },
              child: const Text('Cập nhật rạp'),
            ),
          ],
        ),
      ),
    );
  }
}
