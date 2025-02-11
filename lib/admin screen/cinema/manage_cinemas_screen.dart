import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'manage_cinemas_controller.dart';
import 'add_cinema_screen.dart';
import 'edit_cinema_screen.dart';

class ManageCinemasScreen extends StatelessWidget {
  const ManageCinemasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ManageCinemasController>(context, listen: false);
    controller.loadCinemas(); // Load dữ liệu ngay khi vào màn hình

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý Rạp')),
      body: Consumer<ManageCinemasController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              // Thanh tìm kiếm + bộ lọc
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: controller.searchCinemas,
                        decoration: InputDecoration(
                          labelText: 'Tìm kiếm rạp',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: controller.searchType,
                      items: const [
                        DropdownMenuItem(value: 'name', child: Text('Tên')),
                        DropdownMenuItem(value: 'city', child: Text('Thành phố')),
                        DropdownMenuItem(value: 'region', child: Text('Miền')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          controller.setSearchType(value);
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Danh sách rạp
              Expanded(
                child: controller.filteredCinemas.isEmpty
                    ? const Center(child: Text('Chưa có rạp nào trong hệ thống'))
                    : ListView.builder(
                  itemCount: controller.filteredCinemas.length,
                  itemBuilder: (context, index) {
                    final cinema = controller.filteredCinemas[index];
                    final isSelected = controller.selectedCinemas.contains(cinema['id']);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: isSelected ? Colors.blue : Colors.grey),
                      ),
                      child: ListTile(
                        leading: Checkbox(
                          value: isSelected,
                          onChanged: (value) {
                            controller.toggleSelection(cinema['id']);
                          },
                        ),
                        title: Text(
                          cinema['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Miền: ${cinema['region']}'),
                            Text('Thành phố: ${cinema['city']}'),
                            Text('Địa chỉ: ${cinema['location']}'),
                          ],
                        ),
                        trailing: isSelected
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditCinemaScreen(cinema: cinema),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                controller.deleteCinema(cinema['id']);
                              },
                            ),
                          ],
                        )
                            : null,
                      ),
                    );
                  },
                ),
              ),

              // Nút xóa nhiều rạp
              if (controller.selectedCinemas.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => controller.deleteMultipleCinemas(),
                    icon: const Icon(Icons.delete),
                    label: Text('Xóa ${controller.selectedCinemas.length} rạp'),
                  ),
                ),

              // Nút thêm rạp mới
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddCinemaScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm rạp mới'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
