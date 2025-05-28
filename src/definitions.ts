export interface AppAttestPlugin {
  /**
   * Verifica se o App Attest é suportado no dispositivo
   */
  isSupported(): Promise<{ isSupported: boolean }>;

  /**
   * Gera uma nova chave para o App Attest
   */
  generateKey(): Promise<{ keyId: string }>;

  /**
   * Atesta uma chave usando um challenge
   */
  attestKey(options: { keyId: string; challenge: string }): Promise<{
    attestation: string;
    keyId: string;
    challenge: string;
  }>;

  /**
   * Gera uma assertion para um payload
   */
  generateAssertion(options: { keyId: string; payload: string }): Promise<{
    assertion: string;
    keyId: string;
  }>;

  /**
   * Cria hash SHA256 de um payload (utilitário)
   */
  hashPayload(options: { payload: string }): Promise<{ hash: string }>;

  /**
   * Armazena o keyId localmente
   */
  storeKeyId(options: { keyId: string }): Promise<{ success: boolean }>;

  /**
   * Recupera o keyId armazenado localmente
   */
  getStoredKeyId(): Promise<{
    keyId: string | null;
    hasStoredKey: boolean;
  }>;

  /**
   * Remove o keyId armazenado
   */
  clearStoredKeyId(): Promise<{ success: boolean }>;
}
