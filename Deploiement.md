# Document de Déploiement

## 1. Introduction <a name="introduction"></a>

Ce document fournit des instructions pour le déploiement de la solution logicielle Whowiaty mobile.

## 2. Prérequis <a name="prérequis"></a>
     (Installer et configurer Framework Flutter)

```plaintext
(Pour Windows)
```
- Télécharger Git (2.4 ou version ultérieure)

- Télécharger Framework Flutter :  
`https://docs.flutter.dev/get-started/install/windows/mobile?tab=download`
	 - Après le téléchargement et le décompresser du fichier "flutter", copie le et coller dans le dossier local (C:)
	 - Entre au dossier "flutter" après "bin" et copie leur chemin, comme suivant :
	`C:\flutter\bin`
	 - Ouvrir "modifier les variables d'environnement système"
	 - Cliquez sur "Variables d'environnement"
	 - Dans les "Variables utilisateur", recherchez l'entrée "Path"
	 - Cliquez sur "Nouveau" et coller le chemin `C:\flutter\bin` 
	 - Cliquez sur OK trois fois
	
- Télécharger Android Studio :
`https://developer.android.com/studio`
     - Démarrez Android Studio
     - Suivez l'assistant de configuration d'Android Studio
     - Si il n'ouvre pas automatiquement, recherche le et ouvrir
     - La boîte de dialogue "Bienvenue dans Android Studio" s'affiche
     - Vérifier les étapes suivants : 

![android studio](assets/screenshots/android_studio_1.png)

![android studio](assets/screenshots/android_studio_2.png)

![android studio](assets/screenshots/android_studio_3.png)

![android studio](assets/screenshots/android_studio_4.png)
    
 - Ouvrir "Terminal" :
	 - taper `flutter doctor --android-licenses` pour accepter les licences Android
	 - taper `flutter doctor` si le résultat comme suivants donc le téléchargement et l'installation du Flutter fait correctement : 
```
Running flutter doctor...
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.13.4, on Windows A.B chipset, locale en)
[✓] Windows version (Installed version of Windows is version 10 or higher)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
[!] Chrome - develop for the web
[!] Visual Studio - develop Windows apps
[✓] Android Studio (version 2022.3 (Giraffe) or later)
[✓] VS Code (version 1.81.1)
[✓] Connected device (1 available)
[✓] Network resources

! Doctor found issues in 2 categories.
```

- Télécharger VS Code IDE et installer les extensions "Dart" et "Flutter"

- Ouvrir le dossier du projet et run les commandes suivants :
   `flutter clean`
   `flutter pub get`

 ```plaintext
 (Pour MacOS)
 ```
 - Some Flutter components require the [Rosetta 2 translation process](https://github.com/flutter/website/pull/7119#issuecomment-1124537969) on Macs running [Apple silicon](https://support.apple.com/en-us/HT211814). To run all Flutter components on Apple silicon, install [Rosetta 2](https://support.apple.com/en-us/HT211861).
	 -  Ouvrir "Terminal" et taper : 
	 `sudo softwareupdate --install-rosetta --agree-to-license`
- Télécharger Xcode :
	 - Ouvrir "App Store" 
	 - Recherche sur "Xcode" et installer le 
	 - Si la boîte de dialogue "Xcode" affiche pour sélectionné la platform de développement coché sur IOS et cliquez sur "télécharger et installer"
	 - Ouvrir "Terminal" et taper :
	 `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
	 `sudo xcodebuild -runFirstLaunch`
	 - Après Installez "CocoaPods". Ce programme regroupe diverses dépendances dans le code "Flutter" et "macOS".
	 `sudo gem install cocoapods`
	 - S'il y a une erreur lors de l'installation, exécutez commande suivant et réinstallez  "CocoaPods" :
	 `sudo gem install drb -v 2.0.5`
	 
- Télécharger Framework Flutter :  
`https://docs.flutter.dev/get-started/install/macos/mobile-ios?tab=download`
	- Après le téléchargement et le décompresser du fichier "flutter", copie le et coller dans votre dossier `Users > username`
	- Entre au dossier "flutter" après "bin" et copie leur chemin
	- Lancez votre éditeur de texte préféré
	- Afficher les fichiers cachés dans votre dossier `Users > username` avec la command suivant :  `Press Command + Shift + . (period)`
	- S'il existe, ouvrez le fichier de variable d'environnement Zsh ~/.zshenv dans votre éditeur de texte. Si ce n'est pas le cas, créez ~/.zshenv
	- Copiez la ligne suivante et collez-la à la fin de votre fichier ~/.zshenv
	`export PATH="$PATH:/Users/username/flutter/bin"`

	
- Télécharger Android Studio :
`https://developer.android.com/studio`
     - Démarrez Android Studio
     - Suivez l'assistant de configuration d'Android Studio
     - Si il n'ouvre pas automatiquement, recherche le et ouvrir
     - La boîte de dialogue "Bienvenue dans Android Studio" s'affiche
     - Vérifier les étapes suivants : 

![android studio](assets/screenshots/android_studio_1.png)

![android studio](assets/screenshots/android_studio_2.png)

![android studio](assets/screenshots/android_studio_3.png)

![android studio](assets/screenshots/android_studio_4.png)   
 
 - Ouvrir "Terminal" :
	 - taper `flutter doctor --android-licenses` pour accepter les licences Android
	 - taper `flutter doctor` si le résultat comme suivants donc le téléchargement et l'installation du Flutter fait correctement : 
```
Running flutter doctor...
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.13.4, on macOS A.B chipset, locale en)
[!] Android toolchain - develop for Android devices
[!] Chrome - develop for the web
[✓] Xcode - develop for iOS and macOS (Xcode 15)
[!] Android Studio (not installed)
[✓] VS Code (version 1.81.1)
[✓] Connected device (1 available)
[✓] Network resources

! Doctor found issues in 3 categories.
```
- Télécharger VS Code IDE et installer les extensions "Dart" et "Flutter"

- Ouvrir le dossier du projet et run les commandes suivants :
   `cd ios`
   `pod install`
   `cd ..`
   `flutter clean`
   `flutter pub get`


## 3. Déploiement  <a name="déploiement"></a>
     (Les étapes à suivre pour le déploiement d'une nouvelle version)

```plaintext
(Pour la version Android)
```

1.  Accéder à la [Google Play Console](https://play.google.com/console/u/0/developers/4835810507970136412/app/4975136487171041964/app-dashboard?timespan=thirtyDays) pour déployer la nouvelle version d'Android sur le `Play Store` 

2. Accédez à l'onglet `Production` puis cliquez sur `Créer une version` : 

![google play console](assets/screenshots/deploie_android_1.png)

3. Ouvrez simultanément "Terminal" dans votre projet Flutter:
	 - Taper `flutter build appbundle` pour créer votre fichier "App Bundle"
     - À la fin, vous trouverez le fichier avec l'extension ".aab" :

![app bundle](assets/screenshots/deploie_android_2.png)

4. Retournez à la `Google Play Console` et faites glisser votre fichier avec l'extension ".aab" dans la zone `App bundles` :

![google play console](assets/screenshots/deploie_android_3.png)

5. Après avoir déployé le fichier, cliquez sur `Suivant` :

![google play console](assets/screenshots/deploie_android_4.png)

6. Après cliquez sur `Enregistrer` :

![google play console](assets/screenshots/deploie_android_5.png)

7. Enfin, cliquez sur `Envoyer modification pour examen?` pour soumettre votre nouvelle version à l'examen de Google en vue de son déploiement sur le `Play Store` dans quelques heures :

![google play console](assets/screenshots/deploie_android_6.png)

- Voici le résultat souhaité :

![google play console](assets/screenshots/deploie_android_7.png)

```plaintext
(Pour la version IOS)
```

1. Vérifiez la dernière version du projet avant de commencer le déploiement comme suivant `version: 2.0.4+14` : 

![version](assets/screenshots/deploy_ios_1.png)

2. Ouvrez [App Store Connect](https://appstoreconnect.apple.com/account), puis accédez à l'onglet `Apps` dans `Apps Store Connect` :

![app store connect](assets/screenshots/deploy_ios_16.png)

3. Puis cliquez sur `Whowiaty` : 

![app store connect](assets/screenshots/deploy_ios_17.png)

4. Cliquez sur `IOS App (+)` et taper le numéro de nouvelle version et cliquez sur `Create` :

![app store connect](assets/screenshots/deploy_ios_18.png)

4. Ouvrez "Xcode" et accédez le fichier `Runner.xcworkspace` dans votre projet Flutter, ou ouvrez directement comme suit :

![app store connect](assets/screenshots/deploy_ios_3.png)

5. Accédez à l'onglet `Runner`, puis cliquez sur `Product` puis `Archive` comme suit :

![app store connect](assets/screenshots/deploy_ios_4.png)

6. Sélectionnez votre nouvelle version, puis cliquez sur `Distribute App` :

![app store connect](assets/screenshots/deploy_ios_5.png)

7. Sélectionnez la case `TestFlight & App Store`, puis cliquez sur `Distribute`:

![app store connect](assets/screenshots/deploy_ios_6.png)

- Voici le résultat souhaité, cliquez sur `Done` :

![app store connect](assets/screenshots/deploy_ios_7.png)

8. Retournez au `App Store Connect` et accédez à l'onglet `TestFlight`, puis cliquez sur `Manage` :

![app store connect](assets/screenshots/deploy_ios_8.png)

- Sélectionnez comme suit puis cliquez sur `Save` :

![app store connect](assets/screenshots/deploy_ios_9.png)

9. Retournez à l'onglet `App Store`, puis faites défiler jusqu'à `Build` et cliquez sur `Add build` :

![app store connect](assets/screenshots/deploy_ios_10.png)

- Sélectionnez votre `BUILD`, puis cliquez sur `Done` :

![app store connect](assets/screenshots/deploy_ios_11.png)

10. Ajoutez des informations sur votre version, puis cliquez su `Save` en haut de votre page :

![app store connect](assets/screenshots/deploy_ios_12.png)

- Puis cliquez sur `Add for Review` :

![app store connect](assets/screenshots/deploy_ios_13.png)

- Vous serez redirigé vers la page `Confirm Submission`, cliquez sur `Submit to Add Review` :

![app store connect](assets/screenshots/deploy_ios_14.png)

- Voici le résultat souhaité :

![app store connect](assets/screenshots/deploy_ios_15.png)