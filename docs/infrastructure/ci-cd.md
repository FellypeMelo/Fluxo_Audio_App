# Pipeline de CI/CD (GitHub Actions)

A estratégia de entrega contínua assegura qualidade e build automatizado dos binários.

```yaml
name: Fluxo Enterprise CI

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  quality-gate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
          channel: 'stable'
      
      - name: Instalar Dependências
        run: flutter pub get
        
      - name: Analise Estática (Linting)
        run: flutter analyze
        
      - name: Testes Unitários
        run: flutter test --coverage
        
      - name: Codecov Upload
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info

  build-android:
    needs: quality-gate
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - name: Build APK
        run: flutter build apk --release --obfuscate --split-debug-info=./debug-info
      - name: Upload Artifact
        uses: actions/upload-artifact@v3
        with:
          name: app-release
          path: build/app/outputs/flutter-apk/app-release.apk
```

## Estratégia de Deploy
- **Alfa/Beta:** Distribuição automatizada via Firebase App Distribution ou TestFlight.
- **Rollback Strategy:** Manutenção do estado imutável das branches de release. Em caso de regressão crítica, incremento imediato de patch version no `pubspec.yaml` com checkout de tag anterior estabilizada e rebuild da esteira.
