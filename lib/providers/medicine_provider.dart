import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medi_tick/models/medicine.dart';
import 'package:medi_tick/services/notification_service.dart';

class MedicineProvider with ChangeNotifier {
  List<Medicine> _medicines = [];

  List<Medicine> get medicines => _medicines;

  final String _boxName = 'medicines';

  void getMedicines() async {
    var box = await Hive.openBox<Medicine>(_boxName);

    _medicines = box.values.toList();

    _medicines.sort((a, b) {
      return a.scheduledTime.compareTo(b.scheduledTime);
    });

    notifyListeners();
  }

  Future<void> addMedicine({
    required String name,
    required int dosage,
    required String dosageType,
    required DateTime scheduledTime,
  }) async {
    var box = await Hive.openBox<Medicine>(_boxName);
    int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final newMedicine = Medicine(
      name: name,
      dosage: dosage,
      dosageType: dosageType,
      scheduledTime: scheduledTime,
      notificationId: notificationId,
    );

    await box.add(newMedicine);
    log("scheduling notification");
    print("scheduling notification");

    await NotificationService().scheduleNotification(
      id: notificationId,
      title: 'Time for your Medicine!',
      body: 'Take $dosage $dosageType of $name',
      scheduledTime: scheduledTime,
    );
    log('notification scheduled');
    print('notification scheduled');

    getMedicines();
  }

  // 3. Delete Medicine
  Future<void> deleteMedicine(int index) async {
    
    final medicineToDelete = _medicines[index];
    
    // 2. Cancel the Notification using its unique ID
   
    await NotificationService().cancelNotification(medicineToDelete.notificationId);

    // 3. Delete from Hive Database
    await medicineToDelete.delete();

    // 4. Refresh the UI list
    getMedicines();
    
    // Optional: Print to console for debugging
    print("Deleted medicine and cancelled notification ID: ${medicineToDelete.notificationId}");
  }
}
