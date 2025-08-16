# 📸 Images d'Onboarding - Taf-Taf

Ce dossier contient les images d'arrière-plan pour le splash screen et l'onboarding de l'application Taf-Taf.

## 📁 Structure des fichiers

```
assets/images/onboarding/
├── splash_bg.png          # ⚠️ MANQUANT - Image d'arrière-plan du splash screen
├── page1_bg.png          # ✅ PRÉSENT - Page 1 : Échange de services
├── page2_bg.png          # ✅ PRÉSENT - Page 2 : Trouvez ou proposez
├── page3_bg.png          # ✅ PRÉSENT - Page 3 : Gagnez des crédits
└── README.md             # Ce fichier
```

## 🎯 Images requises

### 1. **splash_bg.png** - Splash Screen ⚠️ MANQUANT
- **Thème** : Collaboration, échange, communauté
- **Style** : Image moderne et professionnelle
- **Résolution recommandée** : 1080x1920px (ratio 9:16)
- **Format** : PNG (comme les autres images)
- **Statut** : ❌ **À fournir** - L'app utilise temporairement page1_bg.png

### 2. **page1_bg.png** - Échange de services ✅ PRÉSENT
- **Thème** : Entraide, solidarité, échange de compétences
- **Contenu suggéré** : Personnes qui s'entraident, collaboration
- **Résolution** : 2.7MB
- **Format** : PNG

### 3. **page2_bg.png** - Trouvez ou proposez ✅ PRÉSENT
- **Thème** : Diversité des services, marketplace
- **Contenu suggéré** : Différents types de services, variété
- **Résolution** : 4.6MB
- **Format** : PNG

### 4. **page3_bg.png** - Gagnez des crédits ✅ PRÉSENT
- **Thème** : Système de crédits, monétisation, professionnalisme
- **Contenu suggéré** : Économie, paiements, services professionnels
- **Résolution** : 5.5MB
- **Format** : PNG

## 🚨 **Action requise**

**Vous devez ajouter l'image `splash_bg.png`** dans ce dossier pour que le splash screen fonctionne correctement.

**En attendant**, l'application utilise `page1_bg.png` comme image de fond du splash screen.

## 🎨 Conseils pour splash_bg.png

### **Qualité et optimisation**
- **Taille** : Maximum 3MB pour de bonnes performances
- **Format** : PNG (comme vos autres images)
- **Résolution** : 1080x1920px (ratio 9:16)

### **Composition**
- **Zone de logo** : Laissez de l'espace au centre pour le logo blanc
- **Contraste** : L'image aura un overlay noir pour la lisibilité
- **Focal point** : Centrez l'élément principal de l'image

### **Style cohérent**
- **Palette de couleurs** : Harmonisez avec page1_bg.png, page2_bg.png, page3_bg.png
- **Style visuel** : Gardez un style cohérent avec vos autres images
- **Ambiance** : Professionnel mais accessible, moderne

## 🔧 Intégration

Une fois `splash_bg.png` ajouté :

1. **Vérifiez le nom** : `splash_bg.png` (exactement)
2. **Testez l'app** : Lancez `flutter run` pour vérifier l'affichage
3. **Ajustez si nécessaire** : Modifiez l'overlay dans le code si besoin

## 📱 Test sur différents appareils

Testez vos images sur :
- **iPhone** (ratio 9:19.5)
- **Android** (ratio 9:16)
- **Tablettes** (ratio 4:3)

Les images s'adaptent automatiquement grâce à `BoxFit.cover`.

---

**Note** : Toutes vos images sont maintenant au format PNG, ce qui est parfait pour la qualité !
