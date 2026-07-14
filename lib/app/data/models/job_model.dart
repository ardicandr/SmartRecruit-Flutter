import 'package:intl/intl.dart';

class JobModel {
  int? id;
  String? title;
  String? company;
  String? companyLogo;
  String? location;
  String? salary;
  String? postedAt;
  String? category;
  String? department;
  String? employmentType;
  String? description;
  String? requirements;
  int? maxApplicants;
  String? status;
  bool? isApplied;
  int? matchScore;
  bool? isBookmarked;

  JobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? json['job_title'];
    company = json['company_name'] ?? json['company'];
    companyLogo = json['company_logo'];
    location = json['location'];
    salary = json['salary_range'] ?? json['salary'];
    String? rawPostedAt = json['created_at'] ?? json['posted'];
    if (rawPostedAt != null) {
      try {
        DateTime dt = DateTime.parse(rawPostedAt);
        postedAt = DateFormat('dd MMMM yyyy', 'id_ID').format(dt);
      } catch (e) {
        postedAt = rawPostedAt;
      }
    }

    category = json['category'];
    department = json['department'];
    employmentType = json['employment_type'];
    description = json['description'];
    requirements = json['requirements'];
    maxApplicants = json['max_applicants'];
    status = json['status'];
    isApplied = json['is_applied'] ?? false;
    if (json['match_score'] != null) {
      matchScore = (json['match_score'] as num).toInt();
    }
    isBookmarked = json['is_bookmarked'] ?? false;
  }
}
