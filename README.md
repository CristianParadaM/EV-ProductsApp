# EV Products App

Aplicacion movil construida con Flutter para explorar un catalogo de productos, autenticarse con diferentes metodos (credenciales, Google y Facebook), y operar con soporte offline en escenarios de conectividad intermitente.

## Descripcion General Del Proyecto

El proyecto implementa una experiencia de ecommerce centrada en:

- Inicio de sesion y registro con Firebase Authentication.
- Listado de productos con paginacion, categorias y productos destacados.
- Detalle de producto y pantalla de carrito.
- Preferencias de usuario (idioma y tema) persistidas localmente.
- Comportamiento resiliente cuando falla la red, con fallback a cache local.

## API Consumida
La app consume la API REST pública de `https://api.escuelajs.co/api/v1` que expone recursos para obtener información sobre productos y categorias. La API soporta paginacion, filtrado por categoria y operaciones CRUD basicas.

En esta primera implementación se hace consumo de listar productos, listar categorias, obtener detalle de producto y listar productos destacados (el cual se simula trayendo 10 productos con el mismo endpoint). La API es sencilla y adecuada para demostrar los conceptos de consumo remoto y cacheo local.

## Arquitectura Aplicada

Se aplica una arquitectura con enfoque de `feature-first` y basada principios de Clean Architecture:

- `presentation`: pantallas y `Cubit` para manejar estado y eventos de UI.
- `domain`: entidades de negocio, contratos de repositorio y casos de uso.
- `data`: data sources remotos/locales, modelos y mapeadores.
- `core`: infraestructura transversal (DI, red, storage, rutas, tema, localizacion).

Patrones y decisiones estructurales:

- Inyeccion de dependencias con `GetIt` centralizada en `InjectorContainer`.
- Navegacion declarativa con `GoRouter` y `ShellRoute` para secciones autenticadas.
- Gestor de estado con `flutter_bloc` usando `Cubit` por modulo (auth, productos, settings, layout, conectividad).

## Estrategia Offline

La estrategia principal es `remote-first` con fallback local:

- Productos:
	- Se intenta consumir API remota.
	- Si la llamada falla, se recupera informacion guardada en local con SQLite.
	- Se cachean listas paginadas, categorias, destacados y detalle por producto.
- Autenticacion por credenciales:
	- Se intenta login remoto con Firebase.
	- Si falla (timeout/error de red), se usa validacion local contra usuarios persistidos por defecto.
    - Dichos usuarios locales se guardan con contraseña cifrada con libreria Argon.
- Conectividad:
	- Se combina `connectivity_plus` con verificacion DNS real para no depender solo del tipo de red.
	- La app notifica cambios online/offline mediante `ConnectivityCubit`.
- Imagenes:
	- Se pre-calientan en cache con `flutter_cache_manager` para mejorar continuidad visual.

## Flujo De Autenticacion

1. Al iniciar la app, `AuthCubit` ejecuta `checkLogin()`.
2. Se valida si existe token en almacenamiento seguro y si coincide con la sesion activa de Firebase
3. Si es valido, el usuario queda autenticado y entra al flujo principal sin necesidad de hacer login nuevamente.
4. Si no existe o es invalido, el usuario permanece en el flujo inicial (`start/login/register`) para registrarse o hacer login.
5. Metodos de acceso soportados:
	 - Credenciales (email/password)
	 - Google Sign-In
	 - Facebook Login
6. En logout se cierra sesion remota y se elimina token local seguro.

Nota: en el datasource local existe un usuario por defecto para pruebas offline si no hay registros previos el cual siempre va a existir, las credenciales son las siguientes:

- Email: `admin@evertec.com`
- Password: `Pruebas123*`

## Decisiones Tecnicas Relevantes

- API HTTP (`Dio` + `ClientApi`):
	- Se eligio por su flexibilidad para timeouts, headers, query params y manejo de errores.
	- La `baseUrl` se lee desde `.env`, lo que facilita cambiar ambientes sin recompilar logica de red.
	- La API consumida expone recursos REST claros (`products`, `categories`) y permite paginacion simple (`limit/offset`).

- Persistencia local:
	- `SQLite` (`sqflite`) para cache key-value de payloads grandes (listas/detalles serializados) se realiza de esta manera por su sencillez de implementación para esta prueba.
	- `SharedPreferences` para preferencias livianas (idioma/tema).
	- `FlutterSecureStorage` para datos sensibles de sesion (token).
	- Esta separacion evita usar un unico mecanismo para todos los casos y mejora seguridad/rendimiento.

- Gestor de estado (`Cubit`):
	- Se eligio por simplicidad para flujos UI bien definidos.
	- Facilita pruebas, trazabilidad de estados y separacion clara entre UI y negocio.
	- Encaja bien con casos de uso del dominio y repositorios desacoplados.

- Estados con Freezed (`Freezed`):
    - Facilita la gestión de estados con múltiples casos (cargando, éxito, error) y reduce el código repetitivo en comparación con clases tradicionales.
    - Permite un manejo más claro y robusto de los estados en los `Cubit`, mejorando la mantenibilidad del código.
    - Implementa metodos como when/maybeWhen para manejar estados de manera más expresiva y facil de entender en la UI.

## Posibles Mejoras Futuras

- Agregar politica de expiracion (TTL) e invalidacion inteligente de cache para el token y demás datos.
- Incorporar interceptores en `Dio` para renovacion de token y observabilidad de errores.
- Cifrar adicionalmente datos sensibles de autenticacion local (ademas del hash de password).
- Implementar carrito persistente y checkout real.
- Agregar analitica y monitoreo de errores (Crashlytics/observabilidad).
- Mejorar accesibilidad y adaptaciones de UI para diferentes tamaños de pantalla.

## Configuracion y Ejecucion

1. Clonar el repositorio y abrirlo en tu IDE favorito.
2. Crear un archivo `.env` en la raiz del proyecto con el siguiente contenido:
```
serverClientId="699995366858-149q2nlbn1c7ttut8vogja4uf1d6u4po.apps.googleusercontent.com"
apiBaseUrl="https://api.escuelajs.co"
```
3. Ejecutar `flutter pub get` para instalar las dependencias.
4. Conectar un dispositivo o iniciar un emulador.
5. Ejecutar `flutter run` para iniciar la aplicación.
