const { cloudinaryUrl, cloudinarySrcset } = require("../utils/cloudinary");

// Couvre le chemin "authenticated" (re-signature via le SDK) + le format forcé.
describe("cloudinary - URLs authenticated (re-signature)", () => {
  const AUTH =
    "https://res.cloudinary.com/portfolio-hezuko/image/authenticated/s--NFSd42bf--/v1/portfolio/private/profile/hp7v57d9atzloiukmmaw";

  it("ré-injecte f_auto,q_auto,w_ dans une URL authenticated signée", () => {
    const out = cloudinaryUrl(AUTH, { w: 720 });
    expect(out).toMatch(/\/image\/authenticated\/s--[^/]+\//); // toujours signée
    expect(out).toContain("f_auto");
    expect(out).toContain("w_720");
    expect(out).toContain("portfolio/private/profile/hp7v57d9atzloiukmmaw");
  });

  it("force le format moderne avec opts.fmt", () => {
    expect(cloudinaryUrl(AUTH, { w: 540, fmt: "avif" })).toContain("f_avif");
  });

  it("génère un srcset multi-largeurs sur une URL authenticated", () => {
    const ss = cloudinarySrcset(AUTH, [360, 720]);
    expect(ss).toMatch(/ 360w/);
    expect(ss).toMatch(/ 720w/);
    expect((ss.match(/\d+w/g) || []).length).toBe(2); // 2 descripteurs de largeur
  });

  it("srcset avec format forcé (source <picture> AVIF)", () => {
    const ss = cloudinarySrcset(AUTH, [360, 720], { fmt: "avif" });
    expect(ss).toContain("f_avif");
  });

  it("no-op sur une URL non Cloudinary et entrées invalides", () => {
    expect(cloudinaryUrl("/images/local.png", { w: 100 })).toBe("/images/local.png");
    expect(cloudinaryUrl(null)).toBe(null);
    expect(cloudinaryUrl(undefined)).toBe(undefined);
    expect(cloudinarySrcset("/images/local.png", [100])).toBe("");
    expect(cloudinarySrcset("", [100])).toBe("");
  });
});
