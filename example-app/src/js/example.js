import { AppAttest } from 'capacitor-app-attest';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    AppAttest.echo({ value: inputValue })
}
