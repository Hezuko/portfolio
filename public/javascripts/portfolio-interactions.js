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

  const focusPage = document.querySelector("[data-focus-scroll]");
  const focusSections = focusPage ? Array.from(focusPage.querySelectorAll(".focus-scroll-section")) : [];
  let focusFrame = null;
  let focusScrollTimer = null;
  let isProgrammaticFocusScroll = false;

  function getVisibleFocusSections() {
    return focusSections.filter((section) => !section.hidden);
  }

  function updateActiveFocusSection() {
    focusFrame = null;
    const visibleSections = getVisibleFocusSections();
    if (!focusPage || !visibleSections.length) return;

    const viewportCenter = window.innerHeight / 2;
    let active = visibleSections[0];
    let activeDistance = Number.POSITIVE_INFINITY;

    visibleSections.forEach((section) => {
      const rect = section.getBoundingClientRect();
      const sectionCenter = rect.top + rect.height / 2;
      const distance = Math.abs(sectionCenter - viewportCenter);
      if (distance < activeDistance) {
        active = section;
        activeDistance = distance;
      }
    });

    focusPage.classList.add("has-focus-effect");
    focusSections.forEach((section) => {
      section.classList.toggle("is-active", section === active);
    });
  }

  function getClosestFocusSection() {
    const visibleSections = getVisibleFocusSections();
    if (!visibleSections.length) return null;
    const viewportCenter = window.innerHeight / 2;
    return visibleSections.reduce((closest, section) => {
      const rect = section.getBoundingClientRect();
      const sectionCenter = rect.top + rect.height / 2;
      const distance = Math.abs(sectionCenter - viewportCenter);
      return distance < closest.distance ? { section, distance } : closest;
    }, { section: visibleSections[0], distance: Number.POSITIVE_INFINITY }).section;
  }

  function centerFocusSection(section, behavior) {
    if (!section) return;
    isProgrammaticFocusScroll = true;
    section.scrollIntoView({ block: "center", behavior: behavior || "smooth" });
    window.setTimeout(() => {
      isProgrammaticFocusScroll = false;
      requestFocusUpdate();
    }, behavior === "auto" ? 0 : 520);
  }

  function scheduleFocusSnap() {
    const visibleSections = getVisibleFocusSections();
    if (!focusPage || !visibleSections.length || isProgrammaticFocusScroll) return;
    window.clearTimeout(focusScrollTimer);
    focusScrollTimer = window.setTimeout(() => {
      if (window.matchMedia("(max-width: 768px)").matches) return;
      if (focusPage.getBoundingClientRect().bottom < window.innerHeight * 0.82) return;
      centerFocusSection(getClosestFocusSection(), "smooth");
    }, 140);
  }

  function requestFocusUpdate() {
    if (focusFrame) return;
    focusFrame = window.requestAnimationFrame(updateActiveFocusSection);
  }

  function refreshFocusNavigation() {
    if (!focusPage || !focusSections.length) return;
    const visibleSections = getVisibleFocusSections();

    focusSections.forEach((section) => {
      section.querySelectorAll("[data-focus-target]").forEach((arrow) => {
        arrow.hidden = true;
      });
    });

    visibleSections.forEach((section, index) => {
      const previous = visibleSections[index - 1];
      const next = visibleSections[index + 1];
      const upArrow = section.querySelector(".focus-arrow-up");
      const downArrow = section.querySelector(".focus-arrow-down");

      if (upArrow && previous) {
        upArrow.dataset.focusTarget = String(focusSections.indexOf(previous));
        upArrow.hidden = false;
      }

      if (downArrow && next) {
        downArrow.dataset.focusTarget = String(focusSections.indexOf(next));
        downArrow.hidden = false;
      }
    });
  }

  function formatProjectCount(count) {
    return `${count} projet${count > 1 ? "s" : ""} affiche${count > 1 ? "s" : ""}`;
  }

  function normalizeFilterValue(value) {
    return String(value || "").trim().toLowerCase();
  }

  function applyProjectFilters(options) {
    const filterForm = document.querySelector("[data-project-filters]");
    if (!filterForm) return;

    const projectSections = Array.from(document.querySelectorAll("[data-project-section]"));
    const emptySection = document.querySelector("[data-project-empty]");
    const count = document.querySelector("[data-project-count]");
    const formData = new FormData(filterForm);
    const category = normalizeFilterValue(formData.get("category"));
    const year = normalizeFilterValue(formData.get("year"));
    const technology = normalizeFilterValue(formData.get("technology"));
    let visibleCount = 0;

    projectSections.forEach((section) => {
      const sectionCategory = normalizeFilterValue(section.dataset.projectCategory);
      const sectionYears = normalizeFilterValue(section.dataset.projectYears).split("|").filter(Boolean);
      const sectionTechnologies = normalizeFilterValue(section.dataset.projectTechnologies).split("|").filter(Boolean);
      const matchesCategory = !category || sectionCategory === category;
      const matchesYear = !year || sectionYears.includes(year);
      const matchesTechnology = !technology || sectionTechnologies.includes(technology);
      const matches = matchesCategory && matchesYear && matchesTechnology;

      section.hidden = !matches;
      if (matches) visibleCount += 1;
    });

    projectSections.filter((section) => !section.hidden).forEach((section, index) => {
      const position = section.querySelector("[data-project-position]");
      if (position) position.textContent = `${index + 1} / ${visibleCount}`;
    });

    if (emptySection) emptySection.hidden = visibleCount > 0;
    if (count) count.textContent = formatProjectCount(visibleCount);

    refreshFocusNavigation();
    requestFocusUpdate();

    if (!options || options.center !== false) {
      const target = visibleCount > 0 ? projectSections.find((section) => !section.hidden) : emptySection;
      centerFocusSection(target, "smooth");
    }
  }

  if (focusPage && focusSections.length) {
    refreshFocusNavigation();
    updateActiveFocusSection();
    focusPage.addEventListener("click", (event) => {
      const arrow = event.target.closest("[data-focus-target]");
      if (!arrow) return;
      const targetIndex = Number.parseInt(arrow.dataset.focusTarget, 10);
      const target = focusSections[targetIndex];
      if (target && !target.hidden) centerFocusSection(target, "smooth");
    });
    window.addEventListener("scroll", () => {
      requestFocusUpdate();
      scheduleFocusSnap();
    }, { passive: true });
    window.addEventListener("resize", requestFocusUpdate);
  }

  const projectFilterForm = document.querySelector("[data-project-filters]");
  if (projectFilterForm) {
    applyProjectFilters({ center: false });
    projectFilterForm.addEventListener("change", () => applyProjectFilters());
    projectFilterForm.addEventListener("submit", (event) => event.preventDefault());

    const resetButton = projectFilterForm.querySelector("[data-project-reset]");
    if (resetButton) {
      resetButton.addEventListener("click", () => {
        projectFilterForm.reset();
        applyProjectFilters();
      });
    }
  }
})();
