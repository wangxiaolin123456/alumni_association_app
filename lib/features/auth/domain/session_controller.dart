import 'package:alumni_association_app/features/auth/domain/user_role.dart';
import 'package:get/get.dart';

/// Owns the authenticated session and the role workspace selected at login.
///
/// The backend should eventually return the role after verifying the email
/// code. Keeping it here makes the member/merchant split a single source of
/// truth for the entire app.
class SessionController extends GetxController {
  /// Whether protected role pages may currently be displayed.
  final isAuthenticated = false.obs;

  /// Active workspace role returned by login.
  final role = UserRole.member.obs;

  /// Opens a session under the selected member or merchant role.
  void signInAs(UserRole selectedRole) {
    role.value = selectedRole;
    isAuthenticated.value = true;
  }

  /// Clears the role session and returns to the login workspace.
  void signOut() {
    isAuthenticated.value = false;
    role.value = UserRole.member;
  }
}
