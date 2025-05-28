# Capacitor App Attest Backend Example

This is an example project of the backend for the Capacitor App Attest plugin.

## Usage

Create a `.env` file in the `example-backend` directory following the template below, changing the values to match your App bundle identifier and Team identifier from your Apple Developer account:

```bash
PORT = 8080
BUNDLE_IDENTIFIER = "com.ludufre.AppAttestExample"
TEAM_IDENTIFIER = "XXXXXXXXXX"
```

```bash
pnpm install

# Run the backend server
pnpm run start
```

## Credit

Based on the [node-app-attest-example](https://github.com/uebelack/node-app-attest-example) ([@uebelack](https://github.com/uebelack)).