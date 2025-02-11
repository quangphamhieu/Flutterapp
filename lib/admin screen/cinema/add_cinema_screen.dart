import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'manage_cinemas_controller.dart';

class AddCinemaScreen extends StatelessWidget {
  const AddCinemaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController regionController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController locationController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Rạp')),
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
                    .addCinema(nameController.text, regionController.text, cityController.text, locationController.text);
                Navigator.pop(context);
              },
              child: const Text('Thêm rạp'),
            ),
          ],
        ),
      ),
    );
  }
}
