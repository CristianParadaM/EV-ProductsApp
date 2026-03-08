import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Catalogo de localizacion en codigo para `es` y `en`.
///
/// Este proyecto usa un enfoque manual en lugar de ARB generado para mantener
/// la logica de resolucion explicita y facil de rastrear.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('es'), Locale('en')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final result = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(result != null, 'No AppLocalizations found in context');
    return result!;
  }

  String get _languageCode => locale.languageCode.toLowerCase();

  /// Selector minimo usado por todos los getters de texto.
  ///
  /// Cualquier codigo de idioma no soportado cae a espanol por diseno.
  String _value({required String es, required String en}) {
    return _languageCode == 'en' ? en : es;
  }

  String get appTitle => _value(es: 'Products App', en: 'Products App');

  // Start page
  String get appStartTitle => _value(
    es: 'Descubre tus productos soñados aquí',
    en: 'Discover Your Dream Products Here',
  );
  String get appStartSubTitle => _value(
    es: 'Explora un mundo de productos increíbles y encuentra lo que necesitas con nosotros.',
    en: 'Explore a world of amazing products and find your perfect match with us.',
  );
  String get buttonStartLogin => _value(es: 'Ingresar', en: 'Login');
  String get buttonStartRegister => _value(es: 'Registrarse', en: 'Register');

  // Login Page
  String get loginTitle => _value(es: 'Iniciar Sesión', en: 'Login here');
  String get loginSubtitle => _value(
    es: 'Bienvenido de nuevo! Te hemos extrañado.',
    en: 'Welcome back! You\'ve been missed.',
  );
  String get emailLabel => _value(es: 'Correo electrónico', en: 'Email');
  String get invalidEmail =>
      _value(es: 'Correo electrónico inválido', en: 'Invalid email address');
  String get passwordLabel => _value(es: 'Contraseña', en: 'Password');
  String get forgotPassword =>
      _value(es: '¿Olvidaste tu contraseña?', en: 'Forgot your password?');
  String get loginButton => _value(es: 'Ingresar', en: 'Login');
  String get createNewAccount =>
      _value(es: 'Crear una nueva cuenta', en: 'Create a new account');
  String get orLoginWith => _value(es: 'O ingresa con', en: 'Or login with');
  String get requiredValue =>
      _value(es: 'Este es un campo requerido', en: 'This is a required field');

  // Register Page
  String get registerTitle =>
      _value(es: 'Crea tu cuenta', en: 'Create your account');
  String get registerSubtitle => _value(
    es: '¡Únete a nosotros y descubre un mundo de productos increíbles!',
    en: 'Join us and discover a world of amazing products!',
  );
  String get nameLabel => _value(es: 'Nombre completo', en: 'Full Name');
  String get confirmPasswordLabel =>
      _value(es: 'Confirmar contraseña', en: 'Confirm Password');
  String get passwordMismatch =>
      _value(es: 'Las contraseñas no coinciden', en: 'Passwords do not match');
  String get alreadyHaveAccount =>
      _value(es: '¿Ya tienes una cuenta?', en: 'Already have an account?');
  String get invalidPassword => _value(
    es: 'La contraseña debe tener al menos 8 caracteres, incluir una letra mayúscula, una letra minúscula, un número y un caracter especial',
    en: 'Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number and a special character',
  );

  // Navigation
  String get navCart => _value(es: 'Carrito', en: 'Cart');
  String get navProducts => _value(es: 'Productos', en: 'Products');
  String get navSettings => _value(es: 'Ajustes', en: 'Settings');

  String navLabel(String key) {
    switch (key) {
      case 'cart':
        return navCart;
      case 'products':
        return navProducts;
      case 'settings':
        return navSettings;
      default:
        // Las claves desconocidas se retornan intactas para no romper la UI.
        return key;
    }
  }

  String get productsTitle => _value(es: 'Productos', en: 'Products');

  // Settings Page
  String get settingsTitle => _value(es: 'Ajustes', en: 'Settings');
  String get settingsSubtitle => _value(
    es: 'Personaliza tu experiencia',
    en: 'Personalize your experience',
  );
  String get settingsAccountSection => _value(es: 'Cuenta', en: 'Account');
  String get settingsThemeSection => _value(es: 'Tema', en: 'Theme');
  String get settingsLanguageSection => _value(es: 'Idioma', en: 'Language');
  String get settingsThemeLight => _value(es: 'Claro', en: 'Light');
  String get settingsThemeDark => _value(es: 'Oscuro', en: 'Dark');
  String get settingsLanguageEs => _value(es: 'Espanol', en: 'Spanish');
  String get settingsLanguageEn => _value(es: 'Ingles', en: 'English');
  String get settingsVersionLabel => _value(es: 'Version', en: 'Version');
  String get settingsUnknownUser =>
      _value(es: 'Usuario sin nombre', en: 'Unknown user');
  String get settingsUnknownEmail =>
      _value(es: 'Correo no disponible', en: 'Email unavailable');
  String get settingsLogoutButton => _value(es: 'Cerrar sesión', en: 'Logout');
  String get errorPrefix => _value(es: 'Error', en: 'Error');

  // Cart Page
  String get cartTitle => _value(es: 'Carrito', en: 'Cart');
  String get screenInConstruction =>
      _value(es: 'Pantalla en construcción', en: 'Screen in construction');

  // Notifications Snackbar
  String get notificationLogoutSuccess =>
      _value(es: 'Cierre de sesión exitoso', en: 'Logout successful');
  String get notificationLoginSuccess =>
      _value(es: 'Login exitoso', en: 'Login successful');
  String get notificationRegisterSuccess => _value(
    es: 'Su registro ha sido exitoso',
    en: 'Your registration was successful',
  );
  String get screenInConstructionMessage => _value(
    es: 'Estamos trabajando en esta funciónalidad, esperamos tenerla lista pronto!',
    en: 'We hope to have it ready soon!',
  );
  String get notificationSectionInBuilding => _value(
    es: 'Esta sección está en construcción',
    en: 'This section is under construction',
  );

  String get searchProducts =>
      _value(es: 'Buscar productos', en: 'Search products');

  String get addedToCart =>
      _value(es: 'Producto agregado al carrito', en: 'Product added to cart');

  String get emptyCachedProducts => _value(
    es: 'Ups!, parece que no hay productos guardados previamente en caché',
    en: 'Ups!, it seems there are no previously cached products saved',
  );

  String get offlineMessage => _value(
    es: 'Sin conexión. Mostrando datos guardados. Conectate para sincronizar información',
    en: 'No connection. Showing cached data. Connect to synchronize information',
  );

  String get onlineMessage =>
      _value(es: 'Conexión restablecida.', en: 'Connection restored.');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((item) => item.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    // SynchronousFuture evita planificacion async innecesaria en datos en memoria.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
