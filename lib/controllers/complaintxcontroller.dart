import 'package:get/get.dart';
import 'package:complaints_portal/models/complaint_item.dart';

class ComplaintxController extends GetxController {
  final RxList<ComplaintItem> complaints = <ComplaintItem>[].obs;

  void addComplaint(ComplaintItem complaint) {
    complaints.add(complaint);
  }

  void deleteComplaint(ComplaintItem complaint) {
    complaints.remove(complaint);
  }

  void clearComplaints() {
    complaints.clear();
  }
}
