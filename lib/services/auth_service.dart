class AuthService {
  static const List<Map<String, String>> credentials = [
    {
      'role': 'Admin',
      'username': 'admin',
      'email': 'admin@edufolio.com',
      'password': 'admin123',
      'route': '/dashboard-admin',
    },
    {
      'role': 'Guru',
      'username': 'guru',
      'email': 'guru@edufolio.com',
      'password': 'guru123',
      'route': '/dashboard-guru',
    },
    {
      'role': 'Siswa',
      'username': 'siswa',
      'email': 'siswa@edufolio.com',
      'password': 'siswa123',
      'route': '/dashboard-siswa',
    },
  ];

  static Map<String, String>? login(String identifier, String password) {
    final id = identifier.trim().toLowerCase();
    final pass = password.trim();

    for (final account in credentials) {
      final username = account['username']!.toLowerCase();
      final email = account['email']!.toLowerCase();
      final pwd = account['password']!;

      if ((id == username || id == email) && pass == pwd) {
        return account;
      }
    }
    return null;
  }
}
