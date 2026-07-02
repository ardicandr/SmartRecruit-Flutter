class JobModel {
  int? id;
  String? title;
  String? company;
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

  JobModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    company = json['company_name'] ?? json['company'];
    location = json['location'];
    salary = json['salary_range'] ?? json['salary'];
    postedAt = json['created_at'] ?? json['posted'];
    
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
  }
}