import 'package:get/get.dart';

import '../modules/assessment/bindings/assessment_binding.dart';
import '../modules/assessment/views/assessment_view.dart';
import '../modules/certificates/bindings/certificates_binding.dart';
import '../modules/certificates/views/certificates_view.dart';
import '../modules/detail/bindings/detail_binding.dart';
import '../modules/detail/views/detail_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/status/views/status_view.dart';
import '../modules/upload_cv/bindings/upload_cv_binding.dart';
import '../modules/upload_cv/views/upload_cv_view.dart';
import 'app_routes.dart';

// --- IMPORT SEMUA BINDING ---
import '../modules/status/bindings/status_binding.dart'; // Jangan lupa status

// --- IMPORT SEMUA VIEW ---

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.DETAIL,
      page: () => DetailView(),
      binding: DetailBinding(),
    ),
    GetPage(
      name: Routes.UPLOAD_CV,
      page: () => UploadCvView(),
      binding: UploadCvBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.CERTIFICATES,
      page: () => CertificatesView(),
      binding: CertificatesBinding(),
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.STATUS,
      page: () => StatusView(),
      binding: StatusBinding(),
    ),
    GetPage(
      name: Routes.ASSESSMENT,
      page: () => AssessmentView(),
      binding: AssessmentBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
