import { registerPlugin } from '@capacitor/core';

import type { AppAttestPlugin } from './definitions';

const AppAttest = registerPlugin<AppAttestPlugin>('AppAttest', {
  web: () => import('./web').then((m) => new m.AppAttestWeb()),
});

export * from './definitions';
export { AppAttest };
