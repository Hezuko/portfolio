document.addEventListener('DOMContentLoaded', () => {
    console.log('Le DOM est complètement chargé');
    
    const sections = document.querySelectorAll('.content');

    const resizeText = (element, step) => {
        let parentHeight = element.parentElement.offsetHeight;
        let fontSize = (parentHeight * step) - 80; // Adjust this factor as needed
        element.style.fontSize = `${fontSize}px`;
    }

    sections.forEach(section => {
        const observer = new MutationObserver(function (mutationList) {
            mutationList.forEach((mutation) => {
                if (mutation.type === 'attributes' && mutation.attributeName === 'style') {
                    const textElements = section.querySelectorAll('.text, h1, h3');
                    textElements.forEach(text => resizeText(text, 0.5));
                }
            });
        });

        observer.observe(section, {
            attributes: true,
            attributeFilter: ['style']
        });

        // Initial resize
        const textElements = section.querySelectorAll('.text');
        textElements.forEach(text => resizeText(text, 0.1));
    });
});
