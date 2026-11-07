# Contributing

Thanks for helping improve E-Tools.

## Before submitting

1. Open an issue for substantial features or architectural changes.
2. Keep features modular and follow the existing feature-first structure.
3. Keep domain logic independent from widgets and platform APIs.
4. Add tests for calculations, parsing, validation and failure cases.
5. Document Android permission requirements and platform limitations.
6. Never commit credentials, tokens, private keys or personal diagnostic data.

## Local checks

```bash
dart format .
flutter analyze
flutter test
```

## Pull requests

Describe the problem, implementation, test coverage, permission impact and screenshots for UI changes. Mark capabilities as planned or limited when they are not fully implemented.
