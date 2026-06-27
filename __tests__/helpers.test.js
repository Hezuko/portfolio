const { cloudinaryUrl, cloudinarySrcset } = require("../utils/cloudinary");
const { techFamily } = require("../utils/techFamily");
const formatters = require("../utils/formatters");

const CL = "https://res.cloudinary.com/demo/image/upload/v123/photo.jpg";

describe("cloudinaryUrl", () => {
  test("injecte f_auto,q_auto,w_", () => {
    expect(cloudinaryUrl(CL, { w: 400 })).toContain("/image/upload/f_auto,q_auto,w_400/");
  });
  test("no-op sur une URL non Cloudinary", () => {
    expect(cloudinaryUrl("/images/x.png", { w: 400 })).toBe("/images/x.png");
  });
  test("ne double pas les transformations déjà présentes", () => {
    const once = cloudinaryUrl(CL, { w: 400 });
    expect(cloudinaryUrl(once, { w: 800 })).toBe(once);
  });
});

describe("cloudinarySrcset", () => {
  test("génère plusieurs largeurs avec descripteurs w", () => {
    const ss = cloudinarySrcset(CL, [400, 800]);
    expect(ss).toContain("w_400");
    expect(ss).toContain("400w");
    expect(ss).toContain("800w");
  });
  test("chaîne vide sur une URL non Cloudinary", () => {
    expect(cloudinarySrcset("/x.png", [400])).toBe("");
  });
});

describe("techFamily", () => {
  test("regroupe les technologies connues en familles", () => {
    expect(techFamily("STM32")).toBe("Embarqué & électronique");
    expect(techFamily("Flutter")).toBe("Mobile (Flutter)");
    expect(techFamily("PyTorch")).toBe("IA / Machine Learning");
    expect(techFamily("PostgreSQL")).toBe("Bases de données");
  });
  test("retourne null pour le bruit (deps, fichiers de config)", () => {
    expect(techFamily("bcrypt")).toBeNull();
    expect(techFamily("netlify.toml")).toBeNull();
    expect(techFamily("")).toBeNull();
  });
});

describe("formatters", () => {
  test("formatProjectCategory renvoie une chaîne", () => {
    expect(typeof formatters.formatProjectCategory("web")).toBe("string");
  });
  test("formatDateRange gère une période ouverte", () => {
    expect(typeof formatters.formatDateRange("2023-09-01", null, "in_progress")).toBe("string");
  });
});
