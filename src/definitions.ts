export interface AppAttestPlugin {
  /**
   * Checks if App Attest is supported on the device
   */
  isSupported(): Promise<{ isSupported: boolean }>;

  /**
   * Generates a new key for App Attest
   */
  generateKey(): Promise<{ keyId: string }>;

  /**
   * Attests a key using a challenge
   * @param options - Object containing the keyId and challenge.
   * @returns A promise that resolves with the attestation result.
   * @throws Will throw an error if the attestation fails.
   */
  attestKey(options: { keyId: string; challenge: string }): Promise<{
    attestation: string;
    keyId: string;
    challenge: string;
  }>;

  /**
   * Generates an assertion for a payload
   * @param options - Object containing the keyId and payload
   * @returns A promise that resolves with the assertion and keyId.
   * @throws Will throw an error if the assertion generation fails.
   */
  generateAssertion(options: { keyId: string; payload: string }): Promise<{
    assertion: string;
    keyId: string;
  }>;

  /**
   * Stores the keyId locally in UserDefaults
   * @param options - Object containing the keyId to store.
   * @returns A promise that resolves with a success status.
   * @throws Will throw an error if storing the keyId fails.
   */
  storeKeyId(options: { keyId: string }): Promise<{ success: boolean }>;

  /**
   * Retrieves the stored keyId locally
   * @returns A promise that resolves with the stored keyId and a boolean indicating if a key is stored.
   * @throws Will throw an error if retrieving the keyId fails.
   */
  getStoredKeyId(): Promise<{
    keyId: string | null;
    hasStoredKey: boolean;
  }>;

  /**
   * Removes the stored keyId
   * @returns A promise that resolves with a success status.
   * @throws Will throw an error if clearing the stored keyId fails.
   */
  clearStoredKeyId(): Promise<{ success: boolean }>;
}
