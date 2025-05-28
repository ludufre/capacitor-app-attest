<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">App Attest</h3>
<p align="center"><strong><code>capacitor-app-attest</code></strong></p>
<p align="center">
  Capacitor community plugin for App Attestation from Apple
</p>

<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2025?style=flat-square" />
  <a href="https://github.com/ludufre/capacitor-app-attest/actions?query=workflow%3A%22CI%22"><img src="https://img.shields.io/github/workflow/status/ludufre/capacitor-app-attest/CI?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/capacitor-app-attest"><img src="https://img.shields.io/npm/l/capacitor-app-attest?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/capacitor-app-attest"><img src="https://img.shields.io/npm/dw/capacitor-app-attest?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/capacitor-app-attest"><img src="https://img.shields.io/npm/v/capacitor-app-attest?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors-"><img src="https://img.shields.io/badge/all%20contributors-0-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>

## Maintainers

| Maintainer | GitHub | Social |
| -----------| -------| -------|
| Luan Freitas (ludufre) | [ludufre](https://github.com/ludufre) | [@ludufre](https://x.com/ludufre) |

## Installation

```bash
npm install capacitor-app-attest
npx cap sync
```

## API

<docgen-index>

* [`isSupported()`](#issupported)
* [`generateKey()`](#generatekey)
* [`attestKey(...)`](#attestkey)
* [`generateAssertion(...)`](#generateassertion)
* [`hashPayload(...)`](#hashpayload)
* [`storeKeyId(...)`](#storekeyid)
* [`getStoredKeyId()`](#getstoredkeyid)
* [`clearStoredKeyId()`](#clearstoredkeyid)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### isSupported()

```typescript
isSupported() => Promise<{ isSupported: boolean; }>
```

Verifica se o App Attest é suportado no dispositivo

**Returns:** <code>Promise&lt;{ isSupported: boolean; }&gt;</code>

--------------------


### generateKey()

```typescript
generateKey() => Promise<{ keyId: string; }>
```

Gera uma nova chave para o App Attest

**Returns:** <code>Promise&lt;{ keyId: string; }&gt;</code>

--------------------


### attestKey(...)

```typescript
attestKey(options: { keyId: string; challenge: string; }) => Promise<{ attestation: string; keyId: string; challenge: string; }>
```

Atesta uma chave usando um challenge

| Param         | Type                                               |
| ------------- | -------------------------------------------------- |
| **`options`** | <code>{ keyId: string; challenge: string; }</code> |

**Returns:** <code>Promise&lt;{ attestation: string; keyId: string; challenge: string; }&gt;</code>

--------------------


### generateAssertion(...)

```typescript
generateAssertion(options: { keyId: string; payload: string; }) => Promise<{ assertion: string; keyId: string; }>
```

Gera uma assertion para um payload

| Param         | Type                                             |
| ------------- | ------------------------------------------------ |
| **`options`** | <code>{ keyId: string; payload: string; }</code> |

**Returns:** <code>Promise&lt;{ assertion: string; keyId: string; }&gt;</code>

--------------------


### hashPayload(...)

```typescript
hashPayload(options: { payload: string; }) => Promise<{ hash: string; }>
```

Cria hash SHA256 de um payload (utilitário)

| Param         | Type                              |
| ------------- | --------------------------------- |
| **`options`** | <code>{ payload: string; }</code> |

**Returns:** <code>Promise&lt;{ hash: string; }&gt;</code>

--------------------


### storeKeyId(...)

```typescript
storeKeyId(options: { keyId: string; }) => Promise<{ success: boolean; }>
```

Armazena o keyId localmente

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ keyId: string; }</code> |

**Returns:** <code>Promise&lt;{ success: boolean; }&gt;</code>

--------------------


### getStoredKeyId()

```typescript
getStoredKeyId() => Promise<{ keyId: string | null; hasStoredKey: boolean; }>
```

Recupera o keyId armazenado localmente

**Returns:** <code>Promise&lt;{ keyId: string | null; hasStoredKey: boolean; }&gt;</code>

--------------------


### clearStoredKeyId()

```typescript
clearStoredKeyId() => Promise<{ success: boolean; }>
```

Remove o keyId armazenado

**Returns:** <code>Promise&lt;{ success: boolean; }&gt;</code>

--------------------

</docgen-api>
