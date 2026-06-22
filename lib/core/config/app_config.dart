enum AppEnvironment { development, staging, production }

abstract final class AppConfig {
  static const environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static AppEnvironment get currentEnvironment =>
      AppEnvironment.values.byName(environment);
}
