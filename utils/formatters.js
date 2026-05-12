const STATUS_LABELS = {
  education: {
    done: "Obtenu",
    in_progress: "En cours",
    planned: "Prevu",
    paused: "En pause",
    cancelled: "Annule",
    abandoned: "Abandonne",
  },
  default: {
    done: "Termine",
    in_progress: "En cours",
    planned: "Prevu",
    paused: "En pause",
    cancelled: "Annule",
    abandoned: "Abandonne",
  },
};

const LEVEL_LABELS = {
  beginner: "Debutant",
  debutant: "Debutant",
  intermediate: "Intermediaire",
  intermediaire: "Intermediaire",
  advanced: "Avance",
  avance: "Avance",
  expert: "Expert",
};

const CONTRACT_LABELS = {
  apprenticeship: "Alternance",
  internship: "Stage",
  full_time: "CDI",
  cdi: "CDI",
  fixed_term: "CDD",
  cdd: "CDD",
  freelance: "Freelance",
  school_project: "Projet academique",
  personal_project: "Projet personnel",
  personal: "Projet personnel",
  other: "Autre",
};

const PROJECT_CATEGORY_LABELS = {
  web: "Web",
  embedded: "Systemes embarques",
  electronics: "Electronique",
  robotics: "Robotique",
  ai: "Intelligence artificielle",
  ia: "Intelligence artificielle",
  mobile: "Mobile",
  crypto: "Crypto",
  drone: "Drone",
  other: "Autre",
};

function formatStatus(status, context = "default") {
  if (!status) return "Statut non renseigne";
  const labels = STATUS_LABELS[context] || STATUS_LABELS.default;
  return labels[status] || status;
}

function formatLevel(level) {
  if (!level) return "Niveau non renseigne";
  return LEVEL_LABELS[level] || level;
}

function formatDate(date) {
  if (!date) return "";
  return new Intl.DateTimeFormat("fr-FR", { month: "short", year: "numeric" }).format(new Date(date));
}

function formatDateRange(startDate, endDate, status) {
  const start = formatDate(startDate);
  const end = formatDate(endDate);
  if (start && end) return `${start} - ${end}`;
  if (start && status === "in_progress") return `${start} - Aujourd'hui`;
  if (start) return `Depuis ${start}`;
  return "Periode non renseignee";
}

function formatContractType(contractType) {
  if (!contractType) return "";
  return CONTRACT_LABELS[contractType] || contractType;
}

function formatProjectCategory(category) {
  if (!category) return "";
  return PROJECT_CATEGORY_LABELS[category] || category;
}

module.exports = {
  formatContractType,
  formatDateRange,
  formatLevel,
  formatProjectCategory,
  formatStatus,
};
