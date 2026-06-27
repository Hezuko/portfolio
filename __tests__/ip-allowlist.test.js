const { parseAllowlist, normalizeIp, isAllowed } = require("../utils/ipAllowlist");

describe("ipAllowlist", () => {
  test("parseAllowlist découpe, trim et filtre", () => {
    expect(parseAllowlist("1.2.3.4, 5.6.7.8 ,")).toEqual(["1.2.3.4", "5.6.7.8"]);
    expect(parseAllowlist("")).toEqual([]);
    expect(parseAllowlist(undefined)).toEqual([]);
  });

  test("normalizeIp retire le préfixe IPv6-mapped", () => {
    expect(normalizeIp("::ffff:88.10.20.30")).toBe("88.10.20.30");
    expect(normalizeIp("88.10.20.30")).toBe("88.10.20.30");
    expect(normalizeIp(undefined)).toBe("");
  });

  test("isAllowed : liste vide = aucune restriction (sûr par défaut)", () => {
    expect(isAllowed([], "9.9.9.9")).toBe(true);
    expect(isAllowed(undefined, "9.9.9.9")).toBe(true);
  });

  test("isAllowed : IP listée autorisée, sinon refusée", () => {
    const list = ["88.10.20.30", "90.1.2.3"];
    expect(isAllowed(list, "88.10.20.30")).toBe(true);
    expect(isAllowed(list, "::ffff:88.10.20.30")).toBe(true); // forme IPv6-mapped
    expect(isAllowed(list, "1.1.1.1")).toBe(false);
    expect(isAllowed(list, "")).toBe(false);
  });
});
