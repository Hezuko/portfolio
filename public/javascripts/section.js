// Attendre que le DOM soit complètement chargé avant d'exécuter le script.
document.addEventListener('DOMContentLoaded', () => {
    
  // Sélectionne tous les éléments ayant la classe 'content'.
  const sections = document.querySelectorAll('.content');
  
  // Compte le nombre de sections trouvées.
  const numberOfSections = sections.length;
  
  // Si aucune section n'est trouvée, on quitte la fonction pour éviter les erreurs.
  if (numberOfSections === 0) {
    return;
  }

  // Création d'un Intersection Observer pour détecter quand une section entre dans la vue.
  const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        // Vérifie si la section observée est au moins à 90% visible dans la fenêtre d'affichage.
        if (entry.isIntersecting) {
          const currentSection = entry.target;
          
          // Ajoute la classe 'active' à la section visible.
          currentSection.classList.add('active');
  
          // Parcourt toutes les sections pour appliquer l'effet de flou.
          sections.forEach(section => {
            if (section !== currentSection) {
              // Ajoute la classe 'blur' aux autres sections pour les flouter.
              section.classList.add('blur');
            } else {
              // Retire l'effet de flou sur la section active.
              section.classList.remove('blur');
            }
          });
        } else {
          // Si la section sort de la vue, on lui enlève la classe 'active'.
          entry.target.classList.remove('active');
        }
      });
    }, {
      // Définition du seuil de visibilité : la section doit être visible à 90% pour être considérée comme active.
      threshold: 0.9
    });

  // Applique l'observation à chaque section pour détecter quand elles deviennent visibles.
  sections.forEach(section => {
    observer.observe(section);
  });

});
