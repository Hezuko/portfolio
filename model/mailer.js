const nodemailer = require("nodemailer");

const mailUser = process.env.MAIL_USER;
const mailPass = process.env.MAIL_PASS;
const mailTo = process.env.MAIL_TO || mailUser;
const mailFrom = process.env.MAIL_FROM || mailUser;
const brevoApiKey = process.env.BREVO_API_KEY;
// Logo via URL publique (l'API ne gère pas les images inline CID simplement).
const logoUrl = `${process.env.SITE_URL || ""}/images/came.png`;

// SMTP (dev local) — créé seulement si identifiants présents. En prod OVH le SMTP
// sortant est bloqué : on passe par l'API HTTPS de Brevo (cf. sendViaBrevo).
const transporter = mailUser && mailPass
  ? nodemailer.createTransport({ service: "gmail", auth: { user: mailUser, pass: mailPass } })
  : null;

function isConfigured() {
  return Boolean(mailTo && mailFrom && (brevoApiKey || transporter));
}

function esc(value) {
  return String(value == null ? "" : value).replace(/[&<>"]/g, function (c) {
    return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c];
  });
}

function buildHtml(d) {
  const message = esc(d.texte).replace(/\n/g, "<br>");
  const logo = logoUrl
    ? `<td style="padding-right:11px;vertical-align:middle;"><img src="${esc(logoUrl)}" width="30" height="30" alt="Logo" style="display:block;border-radius:8px;"></td>`
    : "";
  return `<!DOCTYPE html><html><body style="margin:0;background:#0a0712;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#0a0712;padding:28px 0;">
    <tr><td align="center">
      <table width="520" cellpadding="0" cellspacing="0" style="max-width:520px;width:100%;background:#15101f;border:1px solid #2a2140;border-radius:16px;overflow:hidden;font-family:-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;">
        <tr><td style="height:4px;background:#8b6cff;background-image:linear-gradient(90deg,#8b6cff,#c56cff,#6c8bff,#5fd6c4);font-size:0;line-height:0;">&nbsp;</td></tr>
        <tr><td style="padding:20px 24px 14px;">
          <table cellpadding="0" cellspacing="0"><tr>
            ${logo}
            <td style="vertical-align:middle;color:#f1edf7;font-size:16px;font-weight:600;">Nouveau message depuis ton portfolio</td>
          </tr></table>
        </td></tr>
        <tr><td style="padding:4px 24px 22px;">
          <table width="100%" cellpadding="0" cellspacing="0" style="font-size:14px;color:#f1edf7;">
            <tr><td width="74" style="color:#a99fc0;padding:5px 0;">De</td><td style="padding:5px 0;color:#f1edf7;">${esc(d.prenom)} ${esc(d.nom)}</td></tr>
            <tr><td style="color:#a99fc0;padding:5px 0;">Email</td><td style="padding:5px 0;"><a href="mailto:${esc(d.email)}" style="color:#a98bff;text-decoration:none;">${esc(d.email)}</a></td></tr>
            <tr><td style="color:#a99fc0;padding:5px 0;">Objet</td><td style="padding:5px 0;color:#f1edf7;">${esc(d.objet)}</td></tr>
          </table>
          <div style="background:#1d1630;border:1px solid #2a2140;border-radius:10px;padding:14px 16px;margin-top:14px;font-size:14px;line-height:1.6;color:#e8e2f2;">${message}</div>
          <a href="mailto:${esc(d.email)}?subject=RE:%20${encodeURIComponent(d.objet)}" style="display:inline-block;margin-top:20px;background:#8b6cff;color:#ffffff;text-decoration:none;font-size:14px;font-weight:600;padding:12px 22px;border-radius:10px;">Répondre à ${esc(d.prenom)}</a>
        </td></tr>
        <tr><td style="border-top:1px solid #2a2140;padding:14px 24px;font-size:12px;color:#6f6790;">Reçu via le formulaire de contact de ton portfolio.</td></tr>
      </table>
    </td></tr>
  </table></body></html>`;
}

function buildText(d) {
  return `Nouveau message depuis ton portfolio\n\n` +
    `De : ${d.prenom} ${d.nom}\nEmail : ${d.email}\nObjet : ${d.objet}\n\n` +
    `Message :\n${d.texte}\n\n— Reçu via le formulaire de contact. Réponds directement à ${d.email}.`;
}

// Envoi via l'API HTTPS de Brevo (port 443 — non bloqué par OVH, contrairement au SMTP).
async function sendViaBrevo(d) {
  const res = await fetch("https://api.brevo.com/v3/smtp/email", {
    method: "POST",
    headers: { "api-key": brevoApiKey, "content-type": "application/json", accept: "application/json" },
    body: JSON.stringify({
      sender: { email: mailFrom, name: "Portfolio — contact" },
      to: [{ email: mailTo }],
      replyTo: { email: d.email, name: `${d.prenom} ${d.nom}`.trim() },
      subject: `Nouveau message : ${d.objet}`,
      htmlContent: buildHtml(d),
      textContent: buildText(d),
    }),
  });
  if (!res.ok) {
    const body = await res.text().catch(() => "");
    throw new Error(`Brevo API ${res.status}: ${body.slice(0, 300)}`);
  }
  return { sent: true, via: "brevo" };
}

async function sendViaSmtp(d) {
  await transporter.sendMail({
    from: `"Portfolio — contact" <${mailFrom}>`,
    to: mailTo,
    replyTo: d.email,
    subject: `Nouveau message : ${d.objet}`,
    text: buildText(d),
    html: buildHtml(d),
  });
  return { sent: true, via: "smtp" };
}

async function sendContactEmail(d) {
  if (!isConfigured()) return { sent: false, reason: "mail-non-configure" };
  // Priorité à l'API Brevo (fonctionne en prod OVH) ; SMTP en repli pour le dev local.
  if (brevoApiKey) return sendViaBrevo(d);
  return sendViaSmtp(d);
}

module.exports = { sendContactEmail, isConfigured, buildHtml, buildText };
