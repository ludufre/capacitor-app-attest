import { Component, inject } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonButton, IonTextarea } from '@ionic/angular/standalone';
import { AppAttest } from 'capacitor-app-attest';
import { Dialog } from '@capacitor/dialog';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { JsonPipe } from '@angular/common';
import { catchError } from 'rxjs';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, IonButton, IonTextarea, JsonPipe],
})
export class HomePage {
  http = inject(HttpClient);

  keyId = '';
  challenge = '';
  attestation: Awaited<ReturnType<typeof AppAttest.attestKey>> | null = null;
  verified = false;

  busyChallenge = false;
  busyAttestation = false;
  busyVerify = false;
  busyAssertion = false;

  async step1() {
    try {
      const key = await AppAttest.generateKey();

      this.keyId = key.keyId;
    } catch (error) {
      console.error('Error generating key:', error);
      await Dialog.alert({
        title: 'Error',
        message: 'Failed to generate key. Please try again.',
      });
    }
  }

  async step2() {
    try {
      this.busyChallenge = true;
      this.http.get<{ challenge: string }>(`${environment.endpoint}/challenge`).subscribe(
        async (response) => {
          const challenge = response.challenge;
          console.log('Challenge received:', challenge);

          this.challenge = challenge;
          this.busyChallenge = false;
        },
        async (error) => {
          console.error('Error fetching challenge:', error);
          await Dialog.alert({
            title: 'Error',
            message: 'Failed to fetch challenge. Please try again.',
          });
          this.busyChallenge = false;
        },
      );
    } catch (error) {
      console.error('Error retrieving stored key ID:', error);
      await Dialog.alert({
        title: 'Error',
        message: 'Failed to retrieve stored key ID. Please try again.',
      });
    }
  }

  async step3() {
    try {
      this.busyAttestation = true;
      const challenge = this.challenge;

      const attestationResult = await AppAttest.attestKey({
        keyId: this.keyId,
        challenge,
      });

      console.log('Attestation result:', attestationResult);

      this.attestation = attestationResult;
      this.busyAttestation = false;
    } catch (error) {
      console.error('Error attesting key:', error);
      await Dialog.alert({
        title: 'Error',
        message: 'Failed to attest key. Please try again.',
      });
      this.busyAttestation = false;
    }
  }

  async step4() {
    try {
      this.busyVerify = true;
      this.http
        .post<void>(`${environment.endpoint}/verify`, {
          attestation: this.attestation?.attestation,
          challenge: this.challenge,
          keyId: this.keyId,
        })
        .subscribe(
          async () => {
            console.log('Attestation verified successfully');

            this.verified = true;
            this.busyVerify = false;
          },
          async (error) => {
            console.error('Error verifying attestation:', error);
            await Dialog.alert({
              title: 'Error',
              message: 'Failed to verify attestation. Please try again.',
            });
            this.busyVerify = false;
          },
        );
    } catch (error) {
      console.error('Error initiating verification:', error);
      await Dialog.alert({
        title: 'Error',
        message: 'Failed to initiate verification. Please try again.',
      });
      this.busyVerify = false;
    }
  }

  async step5(data: IonTextarea) {
    try {
      this.busyAssertion = true;

      const challengeResponse = await this.http
        .get<{ challenge: string }>(`${environment.endpoint}/challenge`)
        .toPromise();

      const payload = {
        message: data.value,
        challenge: challengeResponse!.challenge,
      };

      const { assertion } = await AppAttest.generateAssertion({
        keyId: this.keyId,
        payload: JSON.stringify(payload),
      });

      console.log('Assertion result:', assertion);

      this.http
        .post<void>(`${environment.endpoint}/send-message`, payload, {
          headers: {
            Authentication: btoa(
              JSON.stringify({
                keyId: this.keyId,
                assertion: assertion,
              }),
            ),
          },
        })
        .subscribe(
          async () => {
            console.log('Message sent successfully');

            await Dialog.alert({
              title: 'Success',
              message: 'Message sent and validated successfully!',
            });

            data.value = '';
          },
          async (error) => {
            console.error('Error sending message:', error);
            await Dialog.alert({
              title: 'Error',
              message: 'Failed to send message. Please try again.',
            });
            this.busyChallenge = false;
          },
        );

      this.busyAssertion = false;
    } catch (error) {
      console.error('Error generating assertion:', error);
      await Dialog.alert({
        title: 'Error',
        message: 'Failed to generate assertion. Please try again.',
      });
      this.busyAssertion = false;
    }
  }
}
