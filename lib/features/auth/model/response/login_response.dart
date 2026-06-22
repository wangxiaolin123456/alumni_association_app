class LoginResponse {
  String _token;
  String _role;
  String _userName;
  String _company;
  String _nickName;
  LoginResponse({
    required String token,
    required String userName,
    required String role,
    required String company,
    required String nickName,
  })  : _token = token,
        _userName = userName,
        _role = role,
        _company = company,
        _nickName = nickName;

  // Getter 和 Setter
  String get token => _token;
  set token(String token) => _token = token;

  String get role => _role;
  set role(String role) => _role = role;


  String get userName => _userName;
  set userName(String userName) => _userName = userName;

  String get company => _company;
  set company(String company) => _company = company;

  String get nickName => _nickName;
  set nickName(String nickName) => _nickName = nickName;

  bool get isAdmin =>!(_role == 'common' || _role == 'companyCommon');/// _role != 'common';

  // JSON 解析
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      role: json['role'] ?? 'common',
      userName: json['userName'] ?? '',
      company: json['company'] ?? '',
      nickName: json['nickName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': _token,
      'role': _role,
      'userName': _userName,
      'company': _company,
      'nickName': _nickName,
    };
  }
}