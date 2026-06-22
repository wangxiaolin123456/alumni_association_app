enum UserRole {
  member('会员'),
  merchant('商家/店员'),
  administrator('管理员');

  const UserRole(this.label);

  final String label;
}
