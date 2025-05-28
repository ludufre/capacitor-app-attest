import { WebPlugin } from '@capacitor/core';

import type { AppAttestPlugin } from './definitions';

export class AppAttestWeb extends WebPlugin implements AppAttestPlugin {
  async isSupported(): Promise<{ isSupported: boolean }> {
    // App Attest só está disponível no iOS
    return { isSupported: false };
  }

  async generateKey(): Promise<{ keyId: string }> {
    throw new Error('App Attest is not available on the web');
  }

  async attestKey(_options: { keyId: string; challenge: string }): Promise<{
    attestation: string;
    keyId: string;
    challenge: string;
  }> {
    throw new Error('App Attest is not available on the web');
  }

  async generateAssertion(_options: { keyId: string; payload: string }): Promise<{
    assertion: string;
    keyId: string;
  }> {
    throw new Error('App Attest is not available on the web');
  }

  async hashPayload(options: { payload: string }): Promise<{ hash: string }> {
    // Implementação básica de hash para web (apenas para desenvolvimento)
    const encoder = new TextEncoder();
    const data = encoder.encode(options.payload);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    const hashHex = hashArray.map((b) => b.toString(16).padStart(2, '0')).join('');
    return { hash: btoa(hashHex) };
  }

  async storeKeyId(options: { keyId: string }): Promise<{ success: boolean }> {
    localStorage.setItem('AttestKeyId', options.keyId);
    return { success: true };
  }

  async getStoredKeyId(): Promise<{
    keyId: string | null;
    hasStoredKey: boolean;
  }> {
    const keyId = localStorage.getItem('AttestKeyId');
    return {
      keyId,
      hasStoredKey: keyId !== null,
    };
  }

  async clearStoredKeyId(): Promise<{ success: boolean }> {
    localStorage.removeItem('AttestKeyId');
    return { success: true };
  }
}
