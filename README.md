# Gestor de cafetería

Aplicación Flutter de ejemplo que consume una API de pedidos de cafetería. El cliente HTTP decodifica respuestas JSON y distingue errores de red, validación, recurso inexistente, conflicto, servidor y respuestas inesperadas.

## Requisitos

- Flutter estable con Dart 3.13.2 o posterior compatible con Dart 3. Se verificó con Flutter 3.47.3 y Dart 3.13.3.
- Node.js 22.13 o superior para el servidor de desarrollo.
- Chrome, un emulador Android o un dispositivo para ejecutar la aplicación.

## Servidor de ejemplo

El servidor es un repositorio independiente: [DMI-2026/mini_backend](https://github.com/DMI-2026/mini_backend). No se copia dentro de esta aplicación. Se probó con el commit `94d2533` y Node.js 22.15.1.

```bash
git clone https://github.com/DMI-2026/mini_backend.git
cd mini_backend
git checkout 94d2533
node server.js
```

En otra terminal, comprueba `curl http://localhost:8000/health`. Mantén el servidor en ejecución. Se puede utilizar una versión más reciente si se comprueba su compatibilidad.

## Ejecutar la aplicación

En la carpeta de este repositorio:

```bash
flutter pub get
flutter run -d chrome --dart-define=API_URL=http://localhost:8000
```

Para el emulador Android, utiliza `--dart-define=API_URL=http://10.0.2.2:8000`. En un teléfono físico, utiliza la dirección IP local de la computadora y asegúrate de que ambos dispositivos estén en la misma red. El valor por defecto es `localhost` en web y `10.0.2.2` en Android cuando no se especifica `API_URL`.

## Verificaciones

```bash
flutter analyze
flutter test
```

Las pruebas del cliente usan `MockClient` y no necesitan el servidor en ejecución. La Práctica B también se verificó con el servidor local.

## Estructura

- `lib/core/http_client.dart`: peticiones HTTP, decodificación y mapeo de fallos.
- `lib/core/failure.dart`: tipos de fallo.
- `lib/main.dart`: punto de entrada y pantalla de ejemplo.
- `test/core/`: pruebas de fallos y del cliente.
- `android/` y `web/`: integración de plataformas.
