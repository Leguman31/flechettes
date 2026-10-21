# Écran sous la cible avec un Raspberry Pi

Matériel : un Raspberry Pi avec Raspberry Pi OS (version avec bureau), un adaptateur HDMI → VGA **actif**, une connexion internet (Wi-Fi ou câble).

1. Démarre le Raspberry et connecte-le à internet.
2. Ouvre un terminal et colle ces lignes :

```
mkdir -p ~/.config/labwc
echo 'chromium --kiosk --noerrdialogs --disable-infobars --password-store=basic https://scoreflechettes.netlify.app/#ecran &' >> ~/.config/labwc/autostart
sudo raspi-config nonint do_blanking 1
```

3. Redémarre : `sudo reboot`. La page écran s'ouvre seule, en plein écran, à chaque démarrage, et l'écran ne se met plus en veille.
4. Lance une partie sur ton téléphone : un code à 4 caractères s'affiche en jaune en haut de l'écran de jeu. Tape ce code sur le Raspberry (avec un clavier) et valide. Le Raspberry s'en souvient : pas besoin de le retaper aux parties suivantes avec le même téléphone.

Si rien ne s'ouvre, remplace `chromium` par `chromium-browser` dans la ligne ci-dessus (selon la version du système).
Pour quitter le plein écran : Alt + F4.
