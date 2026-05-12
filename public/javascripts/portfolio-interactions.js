(function () {
  const modal = document.getElementById("infoModal");
  const content = document.getElementById("infoModalContent");
  const panel = modal ? modal.querySelector(".info-modal__panel") : null;
  let lastFocus = null;

  function escapeHtml(value) {
    return String(value || "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  function list(items, empty, render) {
    if (!items || !items.length) return `<p class="muted">${escapeHtml(empty)}</p>`;
    return `<ul class="clean-list">${items.map(render).join("")}</ul>`;
  }

  function openModal(html) {
    if (!modal || !content || !panel) return;
    lastFocus = document.activeElement;
    content.innerHTML = html;
    modal.classList.add("is-open");
    modal.setAttribute("aria-hidden", "false");
    panel.focus();
  }

  function closeModal() {
    if (!modal || !content) return;
    modal.classList.remove("is-open");
    modal.setAttribute("aria-hidden", "true");
    content.innerHTML = "";
    if (lastFocus && typeof lastFocus.focus === "function") lastFocus.focus();
  }

  function renderKnowledge(data) {
    const level = data.level ? `<p><strong>Niveau</strong><br>${escapeHtml(data.level_label || data.level)}</p>` : "<p class=\"muted\">Niveau non renseigne</p>";
    return `
      <article class="info-card">
        <p class="eyebrow">${data.type === "technology" ? "Technologie" : "Competence"}</p>
        <h2 id="infoModalTitle">${escapeHtml(data.name)}</h2>
        <p><strong>Categorie</strong><br>${escapeHtml(data.category || "Non renseignee")}</p>
        ${level}
        <p>${escapeHtml(data.description || "Aucune description renseignee")}</p>
        <h3>Projets lies</h3>
        ${list(data.projects, "Aucun projet lie", (item) => `<li>${item.slug ? `<a href="/projets/${escapeHtml(item.slug)}">${escapeHtml(item.name)}</a>` : escapeHtml(item.name)}</li>`)}
        <h3>Etudes liees</h3>
        ${list(data.studies, "Aucune etude liee", (item) => `<li>${escapeHtml(item.title)}${item.school_name ? ` - ${escapeHtml(item.school_name)}` : ""}</li>`)}
        <h3>Experiences liees</h3>
        ${list(data.experiences, "Aucune experience liee", (item) => `<li>${escapeHtml(item.title)}${item.company_name ? ` - ${escapeHtml(item.company_name)}` : ""}</li>`)}
      </article>
    `;
  }

  async function openKnowledge(button) {
    const type = button.dataset.knowledgeType;
    const id = button.dataset.knowledgeId;
    const name = button.dataset.knowledgeName;
    const endpoint = id && type ? `/api/${type === "technology" ? "technologies" : "skills"}/${encodeURIComponent(id)}` : `/api/knowledge/${encodeURIComponent(name || "")}`;
    openModal(`<article class="info-card"><h2 id="infoModalTitle">Chargement</h2><p class="muted">Recuperation des informations...</p></article>`);
    try {
      const response = await fetch(endpoint);
      if (!response.ok) throw new Error("not-found");
      const data = await response.json();
      openModal(renderKnowledge(data));
    } catch (err) {
      openModal(`<article class="info-card"><h2 id="infoModalTitle">${escapeHtml(name || "Element")}</h2><p class="muted">Aucune fiche detaillee disponible.</p></article>`);
    }
  }

  document.addEventListener("click", (event) => {
    const interactive = event.target.closest("a, button, input, select, textarea, [data-info-template], [data-knowledge-name], [data-knowledge-id]");
    const close = event.target.closest("[data-modal-close]");
    if (close) {
      closeModal();
      return;
    }

    const infoButton = event.target.closest("[data-info-template]");
    if (infoButton) {
      const template = document.getElementById(infoButton.dataset.infoTemplate);
      if (template) openModal(template.innerHTML);
      return;
    }

    const knowledgeButton = event.target.closest("[data-knowledge-name], [data-knowledge-id]");
    if (knowledgeButton) {
      openKnowledge(knowledgeButton);
      return;
    }

    const card = event.target.closest("[data-card-href]");
    if (card && !interactive) {
      window.location.href = card.dataset.cardHref;
    }
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") closeModal();
    if ((event.key === "Enter" || event.key === " ") && event.target.matches("[data-card-href]")) {
      event.preventDefault();
      window.location.href = event.target.dataset.cardHref;
    }
  });
})();
